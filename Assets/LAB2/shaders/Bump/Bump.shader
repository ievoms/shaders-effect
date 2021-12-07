Shader "Custom/Bump"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" { }
        _GrayTex("GrayScale Bump Texture", 2D) = "white" { }
        _NormStrength("Normal Strength", Range(0, 5)) = 3.0
        _Glossiness("Smoothness", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_GrayTex;
        };

        sampler2D _MainTex;
        sampler2D _GrayTex;

        uniform float4 _GrayTex_TexelSize;

        half _NormStrength;
        half _Glossiness;
        half _Metallic;

        fixed4 _Color;

        void surf(Input intput, inout SurfaceOutputStandard output)
        {
            fixed4 color = tex2D(_MainTex, intput.uv_MainTex) * _Color;
            output.Albedo = color.rgb;

            //Calculate Normal from Grayscale.
            float3 grayNorm = float3(0, 0, 1);

            float heightSampleCenter = tex2D(_GrayTex, intput.uv_GrayTex).r;

            float heightSampleRight = tex2D(
                _GrayTex, intput.uv_GrayTex + float2(_GrayTex_TexelSize.x, 0)
            ).r;

            float heightSampleUp = tex2D(
                _GrayTex, intput.uv_GrayTex + float2(0, _GrayTex_TexelSize.y)
            ).r;

            float sampleDeltaRight = heightSampleRight - heightSampleCenter;
            float sampleDeltaUp = heightSampleUp - heightSampleCenter;

            grayNorm = cross(
                float3(1, 0, sampleDeltaRight * _NormStrength),
                float3(0, 1, sampleDeltaUp * _NormStrength)
            );

            output.Normal = normalize(grayNorm);

            // PBR Settings.
            output.Metallic = _Metallic;
            output.Smoothness = _Glossiness;
            output.Alpha = color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
