Shader "Custom/gradient surf"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTex2 ("Texture2", 2D) = "white" {}
        _Strength1 ("s", Range(0,1)) = 0.5
        _Strength2 ("Col2", Range(0,1)) = 0.5
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MainTex2;
        float _Strength1;
        float _Strength2;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 textura1=tex2D(_MainTex,IN.uv_MainTex);
            fixed4 textura2=tex2D(_MainTex2,IN.uv_MainTex);
            // inverse lerp
            fixed4 t = (IN.uv_MainTex.y-_Strength2)/(_Strength1-_Strength2);               
            fixed4 mixture =lerp(textura1,textura2,t);
            o.Albedo = mixture.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = mixture.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
