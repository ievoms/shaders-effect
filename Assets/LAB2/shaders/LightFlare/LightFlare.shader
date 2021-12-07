Shader "Custom/Light"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" { }
        _AccumOrig("AccumOrig", Float) = 0.65
    }

    SubShader
    {
        ZTest Always Cull Off ZWrite Off

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB
            BindChannels
            {
                Bind "vertex", vertex
                Bind "texcoord", texcoord
            }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct AppData
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };

            struct V2f
            {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD;
            };

            float4 _MainTex_ST;
            float _AccumOrig;

            V2f vert(AppData input)
            {
                V2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.texcoord = TRANSFORM_TEX(input.texcoord, _MainTex);

                return output;
            }

            sampler2D _MainTex;

            half4 frag(V2f input) : SV_Target
            {
                return half4(tex2D(_MainTex, input.texcoord).rgb, _AccumOrig);
            }
            ENDCG
        }
        Pass{
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB
            BindChannels
            {
                Bind "vertex", vertex
                Bind "texcoord", texcoord
            }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct AppData
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD;
            };

            struct V2f
            {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD;
            };

            float4 _MainTex_ST;
            float _AccumOrig;

            V2f vert(AppData input)
            {
                V2f output;

                output.vertex = UnityObjectToClipPos(input.vertex);
                output.texcoord = TRANSFORM_TEX(input.texcoord, _MainTex);

                return output;
            }

            sampler2D _MainTex;

            half4 frag(V2f input) : SV_Target
            {
                return half4(tex2D(_MainTex, input.texcoord).rgb, _AccumOrig);
            }
            ENDCG
        }

    }

    SubShader
    {
        ZTest Always Cull Off ZWrite Off

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB
            SetTexture[_MainTex] {
                ConstantColor(0,0,0,[_AccumOrig])
                Combine texture, constant
            }
        }
           Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB
            SetTexture[_MainTex] {
                ConstantColor(0,0,0,[_AccumOrig])
                Combine texture, constant
            }
        }
        // Pass
        // {
        //     Blend One Zero
        //     ColorMask A
        //     SetTexture[_MainTex] {
        //         Combine texture
        //     }
        // }

    }
    Fallback off
}
