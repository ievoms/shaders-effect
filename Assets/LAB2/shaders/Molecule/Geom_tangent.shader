

Shader "Unlit/Geom_tangent"
{
 Properties
    {
        _Color ("Color", Color) = (0, 0, 0, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _ExtrusionFactor ("Extrusion factor", float) = 2
        _SpeedMovement ("Speed", range(0, 5)) = 2
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag

            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2g
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct g2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color;
            float _Speedexpand;
            float _SpeedMovement;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _ExtrusionFactor;

        float4 rotateteZ ( float angle, float3 vert )
           {
                float4 vertex = float4( vert, 0 );
                float4x4 mat;
                mat[0] = float4(cos(angle), -sin(angle), 0, 0);
                mat[1] = float4(sin(angle), cos(angle), 0, 0);
                mat[2] = float4(0, 0, 1, 0);
                mat[3] = float4(0, 0, 0, 1);
                return mul(mat, vert);
           }

            v2g vert (appdata v)
            {
                v2g o;
                o.vertex = v.vertex;
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream)
            {
                g2f o;

                v2g v1 = IN[0];
                v2g v2 = IN[1];
                v2g v3 = IN[2];

//              rotate v1 in Z axis and then use it from normal calcualtion 
                v1.vertex = rotateteZ(tan(_Time.x * _SpeedMovement  ), v1.vertex );
//              calculate normal 
                float3 normal = normalize( cross( v2.vertex - v1.vertex, v2.vertex - v3.vertex ) );
                
                o.vertex = UnityObjectToClipPos(IN[0].vertex + normal * _ExtrusionFactor );
                o.uv = TRANSFORM_TEX(IN[0].uv, _MainTex);
                triStream.Append(o);

                o.vertex = UnityObjectToClipPos(IN[1].vertex + normal * _ExtrusionFactor );
                o.uv = TRANSFORM_TEX(IN[1].uv, _MainTex);
                triStream.Append(o);

                o.vertex = UnityObjectToClipPos(IN[2].vertex + normal * _ExtrusionFactor );
                o.uv = TRANSFORM_TEX(IN[2].uv, _MainTex);
                triStream.Append(o);

                triStream.RestartStrip();
            }

            fixed4 frag (g2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    }
}
