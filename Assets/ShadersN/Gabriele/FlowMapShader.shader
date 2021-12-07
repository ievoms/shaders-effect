Shader "Custom/FlowMapShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _FlowMap("Flow map", 2D) = "white" {}
        _FlowSpeed("Flow speed", float) = 0.05
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0

        [Header(Specular properties)]
        _Specularity("Specularity", Range(0.01,1)) = 0.08
        _SpecularColor("Specular color", Color) = (1,1,1,1)
        [Space(20)]
        [Header(Texture properties)]
        _MainTex2("Texture 2", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent" 
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        LOD 200

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_PIXELSNAP_ON
            #include "UnityCG.cginc"

            //vertex input
            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            //vertex output
            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                half2 texcoord  : TEXCOORD0;
            };

            fixed4 _Color;

            //v2f - vertex to fragment
            v2f vert(appdata_t IN)
            {
                v2f OUT;

                OUT.vertex = UnityObjectToClipPos(IN.vertex);
                OUT.texcoord = IN.texcoord;
                OUT.color = IN.color * _Color;
                #ifdef PIXELSNAP_ON
                        OUT.vertex = UnityPixelSnap (OUT.vertex);
                #endif

                return OUT;
            }

            //When declaring a property it is very important to consider that it will be written 
            // in ShaderLab declarative language while our program will be written in either Cg or 
            // HLSL language. As they are two different languages we have to create “connection variables“.

            //connection variables:
            sampler2D _MainTex;
            sampler2D _FlowMap;
            
            float _FlowSpeed;

            fixed4 frag(v2f IN) : SV_Target
            {
                float3 flowDir = tex2D(_FlowMap, IN.texcoord) * 2.0f - 1.0f;
                flowDir = flowDir * _FlowSpeed;

                float phase0 = frac(_Time[1] * 0.5f + 0.5f);
                float phase1 = frac(_Time[1] * 0.5f + 1.0f);

                half3 tex0 = tex2D(_MainTex, IN.texcoord + flowDir.xy * phase0);
                half3 tex1 = tex2D(_MainTex, IN.texcoord + flowDir.xy * phase1);

                float flowLerp = abs((0.5f - phase0) / 0.5f);
                half3 finalColor = lerp(tex0, tex1, flowLerp);

                fixed4 c = float4(finalColor, 1.0f) * IN.color;
                c.rgb = c.rgb * c.a;
                return c;
            }
            ENDCG
        }
    }
}
