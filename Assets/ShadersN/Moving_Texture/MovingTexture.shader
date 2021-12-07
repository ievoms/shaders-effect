Shader "Custom/MovingTexture"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Tex1 ("Tekstura1", 2D) = "white" {}
        _Tex2 ("Teksture2", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _YMove ("_Ymove", Range(0,10)) = 1
        _XMove ("_Xmove", Range(0,10)) = 2
        _Kazkas ("_Kazkas", Range(0,1)) = 0
    }
    SubShader
    {
        Tags {  "Queue"="Transparent" "RenderType"="Transparent"  }
        Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _Tex1;
        sampler2D _Tex2;

        struct Input
        {
            float2 uv_Tex1;
            float2 uv_Tex2;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        fixed _XMove;
        fixed _YMove;
        float _MixingProportion;
        float _Kazkas;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 pajudintasTex2taskas=IN.uv_Tex2;
            fixed pajudintasTex2taskasX= _XMove*_Time*2;
            fixed pajudintasTex2taskasY= _YMove*_Time*2;
            pajudintasTex2taskas += fixed2(pajudintasTex2taskasX,pajudintasTex2taskasY);

            float4 tex1PixelioSpalva= tex2D(_Tex1,IN.uv_Tex1);
            float4 tex2PixelioSpalva= tex2D(_Tex2,pajudintasTex2taskas);
            float4 finalSpalva = tex2PixelioSpalva;
            // jeigu antros teksturos pixelio spalva ~balta, uzdeda pirmos texturos spalva
            if(tex2PixelioSpalva.r >0.5 && tex2PixelioSpalva.g > 0.5 && tex2PixelioSpalva.b> 0.5){
                finalSpalva = tex1PixelioSpalva;
            }
            //  a + w*(b-a);
            // sujungtuTexturuPixelioSpalva = lerp(tex1PixelioSpalva,tex2PixelioSpalva,_MixingProportion);
            
            o.Albedo = finalSpalva.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = finalSpalva.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
    FallBack "Diffuse"
}
