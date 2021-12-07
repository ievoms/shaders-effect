Shader "Custom/NewSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _KiekIskirpti ("KiekIskirpti", Range(0,0.5)) =0.1
        _Border ("Border", Range(0,0.5)) =0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
    
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _KiekIskirpti;
        float _Border;

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            
            fixed4 col = tex2D(_MainTex, i.uv_MainTex);
            float2 coords=i.uv_MainTex;
            // x padauginamas iš skaičiaus, kuris sukurtų fragmentus kuo panašesnius į kvadratą
            coords.x *= 2;
            // randama centro linija. x-linija nuo 0,5-1,5, y-vienas taskas 0.5
            float2 middleLine = float2(clamp(coords.x,0.5,1.5),0.5);
            // apskaičiuojamas atstumas nuo vidurio ir išcentruojama
            float atstumas = distance(coords,middleLine)*2-1;
            // pridedamas offset (border)
            float border = atstumas+_Border;
            // jeigu -border < 0 returns 0 
            float borderLayer = step(0,-border);
            
            if( atstumas > _KiekIskirpti){
                clip(-1);
            }
            
            o.Albedo = float4(col.rgb*borderLayer,1);
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
