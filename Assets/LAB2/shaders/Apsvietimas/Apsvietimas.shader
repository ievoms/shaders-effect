Shader "Unlit/Apsvietimas"
{
    Properties
    {
        _MainTex("RGBA Texture Image", 2D) = "white" { }
    }
    SubShader
    {
        Tags
        {
            "LightMode" = "ForwardBase"
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            uniform sampler2D _MainTex;
            uniform fixed4 _LightColor0;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR0;
                float4 tex : TEXCOORD0;
            };

            VertexOutput vert(VertexInput input)
            {
                VertexOutput output;
                output.tex = input.texcoord;
                output.pos = UnityObjectToClipPos(input.vertex);

                float3 normalDirection = normalize(
                    mul(float4(input.normal, 1.0), unity_WorldToObject).xyz
                );

                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

                float normalLightDot = dot(normalDirection, lightDirection);
                float3 diffuse = _LightColor0.xyz * max(0.0, normalLightDot);

                output.color = half4(diffuse, 1.0);

                return output;
            }

            float4 frag(VertexOutput input) : COLOR
            {
                return tex2D(_MainTex, input.tex.xy) * input.color;
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}