Shader "Custom/RandomStripes"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Speed("Speed", Range(1,100)) = 10
        _MetallicTex ("Metallic Texture", 2D) = "white" {}
        _SpecColor ("Specular", Color) = (1,1,1,1)
        _NoiseTex("Noise tex", 2D) = "white" {}
        
    }
    SubShader
    {
        Tags { "Queue"="Geometry" }

        CGPROGRAM
        #pragma surface surf StandardSpecular

        sampler2D _MetallicTex;    
        sampler2D _NoiseTex;    
        fixed4 _Color;
        float _Speed;

        struct Input
        {
            float2 uv_MetallicTex;
            float2 uv_Texture;
            float2 uv_NoiseTex;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {       
            float t = _Time.x * _Speed;
            //value which will move through y axis
            float value = sin(IN.worldPos.y * 3 + t);
            
            fixed2 mettalic=IN.uv_MetallicTex;
            mettalic += fixed2(IN.uv_MetallicTex.x,t);

            o.Albedo = _Color.rgb;
            //animating albedo color red channel
            o.Albedo.r = sin(value*8);
            //adding mettalic texture
            half col = tex2D (_MetallicTex, mettalic).r ;
            // assign mettalic texture to smoothness
            o.Smoothness = col;
            o.Specular = _SpecColor.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
