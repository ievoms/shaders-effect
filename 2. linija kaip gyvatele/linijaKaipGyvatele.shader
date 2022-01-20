Shader "Unlit/linijaKaipGyvatele"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Skaicius ("_Skaicius", Range(-1,0.5)) = 0.1
        _Freq ("_Freq", Range(-1,2)) = 0.1
        _Amp ("_Amp", Range(-1,0.5)) = 0.1
        _Offsetas ("_Offsetas", Range(-1,0.5)) = 0.1
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
            float _Amp;
            float _Skaicius;
            float _Freq;
            float _Offsetas;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);


                 float2 centras=float2(clamp(i.uv.x,0,2),0.5);

                   float textureMovement = _Time.y * _Skaicius;

                fixed2 tex1Pixel = i.uv;
                fixed movedTex1PixelX= 0.5 * textureMovement;
                fixed movedTex1PixelY= 0.5 * textureMovement;
                tex1Pixel += fixed2(movedTex1PixelX, i.uv.y);

            //     float t = _Time * _Skaicius;
            //     float waveHeight = sin(t + i.uv.x * _Freq) * _Amp +
            //             sin(t*2 + i.uv.x * _Freq*2) * _Amp;
            //    i.uv.y = i.uv.y + waveHeight;

                float atstumas = distance(tex1Pixel, centras);

                float ts = cos(tex1Pixel.x*6.28);
                // if(atstumas<0.1){
                //     i.uv.x =1;
                // }else{
                //     i.uv.x = 0;
                // }
                
                ts = cos((tex1Pixel.y + ts)*6.28 );
                      
            
                return fixed4(ts,0,0,1);
            }
            ENDCG
        }
    }
}
