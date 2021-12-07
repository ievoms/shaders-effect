Shader "Shaderis/BumpedEnvironment" 
{
    Properties {
        _DiffuseTex ("Diffuse Texture", 2D) = "white" {}
        _BumpTex ("Bump Texture", 2D) = "bump" {}
        _Color("color", Color) = (0,0,0,0)
        _bumbAmount ("Bump Amount", Range(0,10)) = 1
        _Brightness ("Brightness", Range(0,10)) = 1
        _Cube ("Cube Map", CUBE) = "white" {}
    }
    SubShader {

      CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _DiffuseTex;
        sampler2D _BumpTex;
        half _bumbAmount;
        half _Brightness;
        fixed4 _Color;
        samplerCUBE _Cube;

        struct Input {
            float2 uv_DiffuseTex;
            float2 uv_BumpTex;
            float3 worldRefl; INTERNAL_DATA
        };
        
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_DiffuseTex, IN.uv_DiffuseTex).rgb;
            // modifies normal to appear brighter
            o.Normal = UnpackNormal(tex2D(_BumpTex, IN.uv_BumpTex)) * _Brightness;
            // sets bumb amount
            o.Normal *= float3(_bumbAmount,_bumbAmount,1);
            // emits cube texture based on worl reflection
            o.Emission = texCUBE (_Cube, (WorldReflectionVector (IN, o.Normal))).rgb;
        }
      
      ENDCG
    }
    Fallback "Diffuse"
  }