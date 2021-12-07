Shader "Custom/targetcolorinTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _BlurSize ("Blur",Range(0,0.1)) = 0
        _ColorValueToBlend ("Color Value To Blend", Range(0,1)) = 0.0
             _Amount ("Extrude", Range(0,1)) = 0.01
    }
    SubShader
    {

        // ZWrite Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float _BlurSize;
        half _ColorValueToBlend;

        struct Input
        {
            float2 uv_MainTex;
        };
           struct appdata {
	      	float4 vertex: POSITION;
	      	float3 normal: NORMAL;
	      	float4 texcoord: TEXCOORD0;
	      };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Amount;

        void vert (inout appdata v) {
            fixed4 col = tex2Dlod(_MainTex, v.texcoord);
            if(col.r>0.8 && col.b>0.8&& col.g>0.8){          
                v.vertex.xyz += v.normal * _Amount;
            }
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 col = tex2D (_MainTex, IN.uv_MainTex) ;
                // target ~white color
                if(col.r>0.8 && col.b>0.8&& col.g>0.8){
                    o.Emission=1;
                }
                // target red eyes. change emision intensity over time
                if(col.r > 0.8 && col.b < 0.3 && col.g < 0.3){
                    o.Emission=saturate(sin(_Time.z)*_Color);
                    o.Alpha=0;
                }
                // target color to apply blur
                if(col.r<_ColorValueToBlend && col.b<_ColorValueToBlend && col.g<_ColorValueToBlend ){

                    float4 color = 0;
                    // creates seamless blur with ten layers
                    for (float index = 0; index < 10; index++)
                    {
                        // add offset to create blur illusions
                        float2 uv = IN.uv_MainTex + float2(0, (index / 9 - 0.5) * _BlurSize);
                        color += tex2D(_MainTex, uv);
                    }
                    color = color / 10;
                    o.Albedo= color;
            
                }else{
                    o.Albedo = col.rgb;
                }
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = col.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
