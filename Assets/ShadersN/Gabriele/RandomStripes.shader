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

        float random (float2 uv)
            {
                return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
            }

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {       

            float4 noiseTex = tex2D(_NoiseTex,IN.uv_NoiseTex);

            float k = random(noiseTex.xy);

            float t = _Time.x * _Speed;
            float value = sin(IN.worldPos.y * 3 + t);

            fixed2 pajudintasTex1taskas=IN.uv_MetallicTex;
            fixed pajudintasTex1taskasY= _Speed*_Time*k;
            pajudintasTex1taskas += fixed2(IN.uv_MetallicTex.x,pajudintasTex1taskasY);

            o.Albedo = _Color.rgb;
            o.Albedo.r = sin(value*8);
            half col = tex2D (_MetallicTex, pajudintasTex1taskas).r ;
            o.Smoothness = col;
            o.Specular = _SpecColor.rgb;
    
        }
        ENDCG
    }
    FallBack "Diffuse"
}
