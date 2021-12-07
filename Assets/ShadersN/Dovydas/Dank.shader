Shader "Dovydas/Dank"
{
    Properties
    {
        _Tint("Colour Tint", Color) = (1,1,1,1)
        _Speed("Speed", Range(1,100)) = 10
        _Scale1("Scale 1", Range(0.1,10)) = 2
        _Scale2("Scale 2", Range(0.1,10)) = 2
        _Scale3("Scale 3", Range(0.1,10)) = 2
        _Scale4("Scale 4", Range(0.1,10)) = 2
        _KiekIskirpti ("KiekIskirpti", Range(0,0.5)) = 0.1
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        float4 _Tint;
        float _Speed;
        float _Scale1;
        float _Scale2;
        float _Scale3;
        float _Scale4;
        float _KiekIskirpti;

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Suapvalinti kampus
            float2 middleLine = float2(0.5,0.5);
            float atstumas = distance(IN.uv_MainTex, middleLine)*2-1;
            if(atstumas > _KiekIskirpti){
                clip(-1);
            }

            const float PI = 3.14159265;
            float t = _Time.x * _Speed;

            //vertical
            float c = sin(IN.worldPos.x * _Scale1 + t);

            // horizontal
            c += sin(IN.worldPos.z * _Scale2 + t);

            //diagonal
            c += sin(_Scale3*(IN.worldPos.x*sin(t/2.0) + IN.worldPos.z*cos(t/3)) + t);
            // creates grayscale 
            o.Albedo = sin(c/4.0*PI);
            // add tint to the grayscale 
            o.Albedo *= _Tint;
        }
        ENDCG
    }
    FallBack "Diffuse"
}