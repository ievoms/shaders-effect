Shader "Custom/Hologram"
{
    Properties
    {
        [Header(Rim Lighting)]
        [Space(10)]
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _CustomColor ("Custom Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0

        [Header(Noise)]
        [Space(10)]
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _NoiseScale ("Noise Scale", Float) = 2.0
        _MovementSpeed ("Noise Movement Speed", Range(0.0, 8.0)) = 1.0

        [Header(Textures movement)]
        [Space(10)]
        _Texture1 ("Texture 1", 2D) = "white" {}
        _Texture2 ("Texture 2", 2D) = "white" {}
        _YMove ("_Ymove", Range(0,10)) = 1
        _XMove ("_Xmove", Range(0,10)) = 2
        _ScrollingSpeed ("Textures Scrolling Speed", Range(0.0,8.0)) = 1.0
        _TextureColor ("Texture Color", Color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

        Pass {
            ZWrite On
            ColorMask 0
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade vertex:vert
        #include "UnityCG.cginc"

        struct Input
        {
            float3 viewDir;
            float2 uv_Texture1;
            float2 uv_Texture2;
        };

        fixed4 _RimColor;
        fixed4 _CustomColor;
        fixed4 _TextureColor;
        float _RimPower;
        float _NoiseScale;
        float _MovementSpeed;
        float _ScrollingSpeed;

        fixed _XMove;
        fixed _YMove;

        sampler2D _NoiseTex;
        sampler2D _Texture1;
        sampler2D _Texture2;

        void vert(inout appdata_full v)
        {
            //vertices movement
            float movement = _Time.x * _MovementSpeed;

            float3 wPos = mul(unity_ObjectToWorld, v.vertex);

            float3 moved_wPos = movement + wPos;

            float noise =  tex2Dlod(_NoiseTex, float4(moved_wPos.xyz,1)).r * _NoiseScale;

            v.vertex += float4((noise * v.normal ), 0);
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            //textures movement
            float textureMovement = _Time.y * _ScrollingSpeed;

            fixed2 tex1Pixel = IN.uv_Texture1;
            fixed movedTex1PixelX= _XMove * textureMovement;
            fixed movedTex1PixelY= _YMove * textureMovement;
            tex1Pixel += fixed2(movedTex1PixelX, movedTex1PixelY);

            float4 texture1 = tex2D(_Texture1, tex1Pixel) ;

            fixed2 tex2Pixel = IN.uv_Texture2;
            fixed movedTex2PixelX = _XMove * (1 - textureMovement);
            fixed movedTex2PixelY = _YMove * (1 - textureMovement);
            tex2Pixel += fixed2(movedTex2PixelX,movedTex2PixelY);
            
            float4 texture2 = tex2D(_Texture2, tex2Pixel);

            float3 c = texture1 + texture2;

            o.Albedo = c.rgb;

            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            float3 customColor = lerp(_RimColor,_CustomColor,cos(_Time));
            float3 rimEmission = customColor * pow(rim, _RimPower) * 10;

            o.Emission = rimEmission;

            o.Alpha = pow(rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
