Shader "Unlit/Craide"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Border ("Border", Range(0,0.5)) = 0.1
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
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Border;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);
                float2 coords=i.uv;
                // coords.x ;

                float2 middleLine=float2(clamp(coords.x,0.5,0.5),0.5);
                float atstumas = distance(coords,middleLine);
                if(atstumas>0.5){

                    clip(-1);
                }
                  if( atstumas<0.3){

                    clip(-1);
                }
                if(coords.x<0.3){
                    clip(-1);
                }
                // float border = atstumas+_Border;
                // float borderLayer = step(0,-border);      
                return float4(atstumas,0,0,1);
            }
            ENDCG
        }
    }
}
