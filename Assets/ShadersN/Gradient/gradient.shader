Shader "Unlit/gradient"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTex2 ("Texture2", 2D) = "white" {}
        _Color ("Col1", Color) = (0,0,0,0)
        _Color2 ("Col2", Color) = (0,0,0,0)
        _Strength1 ("s", Range(0,1)) = 0.5
        _Strength2 ("Col2", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            sampler2D _MainTex2;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _Color2;
            float _Strength1;
            float _Strength2;

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
                fixed4 textura1=tex2D(_MainTex,i.uv);
                fixed4 textura2=tex2D(_MainTex2,i.uv);
                fixed4 t = (i.uv.y-_Strength2)/(_Strength1-_Strength2);
                
                fixed4 mixture =lerp(_Color,_Color2,t);
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return mixture;
            }
            ENDCG
        }
    }
}
