

Shader "Unlit/Geom_rotate_spikes"
{
 Properties
    {
        _Color1 ("Color", Color) = (0, 0, 0, 1)
        _Color2 ("Color2", Color) = (0, 0, 0, 1)
        _Color3 ("Color3", Color) = (0, 0, 0, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", range(1,15) ) = 1
        _Extrusion ("Extrusion", range(0,5) ) = 2
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off
        LOD 100

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
                float4 color : COLOR;
            };

            fixed4 _Color1;
            fixed4 _Color2;
            fixed4 _Color3;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Speed;
            float _Extrusion;

            
        //    float4 rotateteY ( float angle, float3 vert )
        //    {
        //         float4 vertex = float4( vert, 0 );
        //         float4x4 mat;
        //         mat[0] = float4(cos(angle), 0, sin(angle), 0);
        //         mat[1] = float4(0, 1, 0, 0);
        //         mat[2] = float4(-sin(angle), 0, cos(angle), 0);
        //         mat[3] = float4(0, 0, 0, 1);
        //         return mul(mat, vert);
        //    }

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

                float3 normal = normalize( cross( v2.vertex - v1.vertex, v2.vertex - v3.vertex ) );
                
                o.vertex = UnityObjectToClipPos(rotateteZ(_Time.y * _Speed,IN[0].vertex) + normal * _Extrusion );
                o.uv = TRANSFORM_TEX(IN[0].uv, _MainTex);
                o.color = _Color1;
                triStream.Append(o);

                o.vertex = UnityObjectToClipPos(IN[1].vertex + normal * _Extrusion );
                o.uv = TRANSFORM_TEX(IN[1].uv, _MainTex);
                o.color = _Color2;
                triStream.Append(o);

                o.vertex = UnityObjectToClipPos(IN[2].vertex + normal * _Extrusion );
                o.uv = TRANSFORM_TEX(IN[2].uv, _MainTex);
                o.color = _Color3;
                triStream.Append(o);

                triStream.RestartStrip();
            }

            fixed4 frag (g2f i) : SV_Target
            {
                
                fixed4 col = tex2D(_MainTex, i.uv) * i.color;
                return col;
            }
            ENDCG
        }
    }
}
