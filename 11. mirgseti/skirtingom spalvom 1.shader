Shader "Unlit/skirtingom spalvom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // i.uv=i.uv*2-1;
                float4 spalva;
                if(i.uv.x < 0.25){
                    spalva=float4(0,0,0,sin(_Time.x));

                }else if(i.uv.x < 0.5 && i.uv.x > 0.25 ){
                     spalva=float4(0,0,0,sin(_Time.y));
                }else if(i.uv.x < 0.75 && i.uv.x > 0.5 ){
                     spalva=float4(0,0,0,sin(_Time.z));
                }else {
                     spalva=float4(0,0,0,sin(_Time.z));
                }
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return spalva;
            }
            ENDCG
        }
    }
}
