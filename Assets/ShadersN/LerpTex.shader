Shader "Unlit/LErpTex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecTex ("Texture", 2D) = "white" {}
        _LerpValue ("Transition float", Range(0,1)) = 0.5
        _dir("Direction", Range(0,1)) = 0
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
            sampler2D _SecTex;
            float _LerpValue;
            float4 _MainTex_ST;
            fixed _dir;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float rotate (float2 uv, float2 pivot, float rotation)
            {
              float cosa = cos(rotation);
              float sina = sin(rotation);
              uv -= pivot;
             return float2(
             (cosa * uv.x) - (sina * uv.y),
             (cosa * uv.y) + (sina * uv.x ))
              + pivot;
            }

             float rotateDir (float2 uv, float2 pivot, float rotation)
            {
              float cosa = cos(rotation);
              float sina = sin(rotation);
              uv -= pivot;
             return float2(
             (cosa * uv.x) + (sina * uv.y),
             (cosa * uv.y) - (sina * uv.x ))
              + pivot;
            }


            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = 0;
                //i.uv.x +=  sin(_Time.x);
               // i.uv = rotate(i.uv,0.5,_Time*3);
                // sample the texture
                //fixed4 col = lerp(tex2D(_MainTex, i.uv),tex2D(_SecTex, i.uv),_LerpValue);
                float2 pv = 0.5;
                 if(_dir > 0.5)
                uv =  rotateDir(i.uv,pv,_Time.y*5);
                else
                 uv =  rotate(i.uv,pv,_Time.y*5);
                fixed4 col = tex2D(_MainTex, uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
