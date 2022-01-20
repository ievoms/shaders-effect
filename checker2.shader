Shader "Unlit/checker2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float rand(float2 co){
                return frac(sin(dot(co, float2(12.9898, 78.233))) * 43758.5453);
            }

            fixed4 frag (v2f i) : SV_Target
            {
               float stul = 10;
               float eil = 10;

               float smth = 0;

               smth = smth + 1;

               float3 col1 = float3(rand(float2(smth,6)),rand(float2(5,9)), rand(float2(1,8)));
               float3 col2 = float3(0,0,0);

               float total = floor(i.uv.y * stul) + floor(i.uv.x * eil);

               if(floor(i.uv.y * stul) == 0 || floor(i.uv.y * stul) == stul-1){
                   col1 = float3(0,0,1);
                   col2 = float3(1,0,0);
               }
               if(floor(i.uv.x * stul) == 0 || floor(i.uv.x * stul) == stul-1){
                   col1 = float3(0,0,1);
                   col2 = float3(1,0,0);
               }
               
               float3 lerped = lerp(col1, col2, step(fmod(total, 2.0), 0.5));

               return float4(lerped, 1.0);
            }
            ENDCG
        }
    }
}
