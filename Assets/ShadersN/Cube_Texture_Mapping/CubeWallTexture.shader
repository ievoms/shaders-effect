Shader "Custom/CubeWallTexture"
{
	Properties
	{
		_FloorTex("Floor Texture", 2D) = "white" {}
		_WallTex1("Wall Texture1", 2D) = "white" {}
		_WallTex2("Wall Texture2", 2D) = "white" {}
		_WallTex3("Wall Texture3", 2D) = "white" {}
		_WallTex4("Wall Texture4", 2D) = "white" {}
		_CeilTex("Ceil Texture", 2D) = "white" {}
	}

		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		CGPROGRAM
		#pragma target 3.5
		#pragma surface surf Standard

		struct Input {
			float3 worldNormal;
			float2 uv_FloorTex;
			float2 uv_WallTex1;
			float2 uv_WallTex2;
			float2 uv_WallTex3;
			float2 uv_WallTex4;
			float2 uv_CeilTex;
		};

		sampler2D _FloorTex;
		sampler2D _WallTex1;
		sampler2D _WallTex2;
		sampler2D _WallTex3;
		sampler2D _WallTex4;
		sampler2D _CeilTex;

		void surf(Input IN, inout SurfaceOutputStandard o) {
			// Floor
			if (IN.worldNormal.y > 0.8){
				o.Albedo = tex2D(_FloorTex, IN.uv_FloorTex).rgb;
			}
			// Ceiling
			else if (IN.worldNormal.y < -0.7){
				o.Albedo = tex2D(_CeilTex, IN.uv_CeilTex).rgb;
			}
			// Walls

			else if (IN.worldNormal.x < -0.9) {
				o.Albedo = tex2D(_WallTex3, IN.uv_WallTex3).rgb;
			}
			else if (IN.worldNormal.x > 0.5) {
				o.Albedo = tex2D(_WallTex2, IN.uv_WallTex2).rgb;
			}
			else if (IN.worldNormal.z > 0.5) {
				o.Albedo = tex2D(_WallTex1, IN.uv_WallTex1).rgb;
			}
			else {
				o.Albedo = tex2D(_WallTex4, IN.uv_WallTex4).rgb;
			}

			o.Emission = o.Albedo;
			o.Metallic = 0.0;
			o.Smoothness = 0.5;
		}

		ENDCG
	}
		FallBack "Diffuse"
}
