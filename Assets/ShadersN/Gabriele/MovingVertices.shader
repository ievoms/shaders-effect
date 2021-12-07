Shader "Unlit/MovingVertices"
{
   Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Texture noise", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1,1,1,1)
        _Transparency ("Transparency", Range(0.0, 0.5)) = 0.25
        _CutoutTresh ("Cutout Treshold", Range(0.0,1.0)) = 0.2
        _Distance("Distance", Float) = 1
        _Amplitude("Amplitude", Float) = 1
        _Speed ("Speed", Float) = 1
        _Amount ("Amount", Float) = 1
        _BlurSize("Blur Size", Range(0,0.1)) = 0

    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 100
        ZWrite off //do not write to depth buffer
        Blend SrcAlpha OneMinusSrcAlpha //Premultiplied transparency

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
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            float4 _TintColor;
            float _Transparency;
            float _CutoutTresh;
            float _Distance;
            float _Amplitude;
            float _Speed;
            float _Amount;
            float _BlurSize;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.z += sin(_Time.y * _Speed + v.vertex.y * _Amplitude) * _Distance * _Amount;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float random (float2 uv)
            {
                return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
            }

            fixed4 frag (v2f i) : SV_Target
            {

                float4 noiseTex = tex2D(_NoiseTex,i.uv);

                float k = random(noiseTex.xy);
                // sample the texture
                float invAspect =  _ScreenParams.y / _ScreenParams.x;
                float4 col = 0;
                _BlurSize = sin(_BlurSize*_Time.z*15)*k;
                for(float index = 0; index < 10; index++){
                    float2 uv = i.uv + float2((index/9 - 0.5) * _BlurSize * invAspect, 0);
                    col += tex2D(_MainTex, uv);
                }
                col = col / 10;
                // fixed4 col = tex2D(_MainTex, i.uv) + _TintColor;
                // col.a = _Transparency;

                // clip(col.r - _CutoutTresh);  //if (col.r < _CutoutTresh) discard
                return col;
            }
            ENDCG
        }
    }
}
