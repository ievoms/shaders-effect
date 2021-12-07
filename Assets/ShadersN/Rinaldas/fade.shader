Shader "Unlit/fade"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BangosAukstis("BangosAukstis", Range(0,5))=0.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _BangosAukstis;

            v2f vert (appdata v)
            {
                v2f o;
                // creates wave 
                v.vertex.y = sin(((v.uv.y +_Time.y *0.1)*6.283185*7)*0.3)*_BangosAukstis;            
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // visability overt sin time
                col.a = saturate(sin(_Time.y));
                return col;
            }
            ENDCG
        }
    }
}
