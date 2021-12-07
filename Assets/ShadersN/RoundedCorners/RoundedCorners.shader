Shader "Unlit/RoundedCorners"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _KiekIskirpti ("KiekIskirpti", Range(0,0.5)) =0.1
        _Border ("Border", Range(0,0.5)) =0.1
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
            float _KiekIskirpti;
            float _Border;

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

                fixed4 col = tex2D(_MainTex, i.uv);
                float2 coords=i.uv;
                coords.x *= 2;

                float2 middleLine=float2(clamp(coords.x,0.5,1.5),0.5);
                float atstumas = distance(coords,middleLine)*2-1;

                float border = atstumas+_Border;
                float borderLayer = step(0,-border);
                
                if(atstumas>_KiekIskirpti){
                    clip(-1);
                }

                // return float4(frac(coords.x),0,0,0);
                return float4(col.rgb*borderLayer,1);
                // return float4(atstumas.xxx,1);
              
            }
            ENDCG
        }
    }

}
