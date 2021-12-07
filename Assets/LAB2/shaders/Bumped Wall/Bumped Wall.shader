Shader "Custom/BumpedWall"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpTex ("bump", 2D) = "white" {}
        _Amount ("Extrude", Range(0,0.01)) = 0.01
    }
    SubShader
    {
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpTex;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpTex;
        };

        struct appdata {
	      	float4 vertex: POSITION;
	      	float3 normal: NORMAL;
	      	float4 texcoord: TEXCOORD0;
	    };

        float _Amount;

        void vert (inout appdata v) {
            fixed4 col = tex2Dlod(_BumpTex, v.texcoord);  
            v.vertex.xyz += v.normal * col.rgb * _Amount;
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 col = tex2D (_MainTex, IN.uv_MainTex);

            o.Albedo = col.rgb;

            o.Alpha = col.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
