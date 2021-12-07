Shader "Custom/BumpDiffuseStencil"
{
    Properties {
        _Color("Color", Color) = (1,1,1,1)
        _myDiffuse ("Diffuse Texture", 2D) = "white" {}

        _SRef("Stencil Ref", Float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)]  _SComp("Stencil Comp", Float)   = 8
        [Enum(UnityEngine.Rendering.StencilOp)]        _SOp("Stencil Op", Float)      = 2
    }
    SubShader {

      Stencil
        {
            Ref[_SRef]
            Comp[_SComp] 
            Pass[_SOp] 
        }  
      
      CGPROGRAM
        #pragma surface surf Lambert
        
        sampler2D _myDiffuse;
        float4 _Color;

        struct Input {
            float2 uv_myDiffuse;
        };
        
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_myDiffuse, IN.uv_myDiffuse).rgb;
        }
      
      ENDCG
    }
    Fallback "Diffuse"
}
