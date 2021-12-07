Shader "Custom/Outline"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _Outline("Outline Width", Range (-0.1, 0.1)) = .005
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input{
            float2 uv_MainTex;
        };
        float _Outline;
        float4 _OutlineColor;

        void vert (inout appdata_full v){
            v.vertex.xyz += v.normal * _Outline;
        }
        sampler2D _MainTex;

        void surf(Input IN, inout SurfaceOutput o){
            o.Emission = _OutlineColor.rgb;
        }
        ENDCG



        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
