Shader "Lec_09/HDREmissiveColorIntensity"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Emission("Emission", color) = (0 ,0 ,0 , 1)
        [Range] _Intensity("Shadow Steps", Range(-10, 10)) = 0
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

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Intensity;
        half3 _Emission;

        void surf(Input input, inout SurfaceOutputStandard output)
        {
            // If not using gamma color space, convert from linear to gamma.
#ifndef UNITY_COLORSPACE_GAMMA
            _Emission.rgb = LinearToGammaSpace(_Emission.rgb);
#endif
            // Apply intensity exposure.
            _Emission.rgb *=pow(2.0, sin(_Intensity*_Time.y));

            // If not using gamma color space, convert back to linear.
#ifndef UNITY_COLORSPACE_GAMMA
            _Emission.rgb = GammaToLinearSpace(_Emission.rgb);
#endif

            fixed4 color = tex2D(_MainTex, input.uv_MainTex) ;
            output.Albedo = color.rgb;
            output.Emission = _Emission;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
