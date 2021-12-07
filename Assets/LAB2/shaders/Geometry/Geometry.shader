Shader "Unlit/Geometry"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" { }
        _Color("Color", Color) = (0, 0, 0, 1)
        _ExtrusionFactor("Extrusion factor", float) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

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

            struct AppData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };


            struct V2g
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };


            struct G2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float _ExtrusionFactor;

            V2g vert(AppData v)
            {
                V2g o;
                o.vertex = v.vertex;
                o.uv = v.uv;
                o.normal = v.normal;
                return o;
            }

           [maxvertexcount(3)]
            void geom(triangle V2g input[3], inout TriangleStream<G2f> triStream)
            {
                G2f output;
                float4 barycenter = (input[0].vertex + input[1].vertex + input[2].vertex) / 3;
                float3 normal = (input[0].normal + input[1].normal + input[2].normal) / 3;

                for (int i = 0; i < 3; i++)
                {
                    int next = ((uint) i + 1) % 3;
                    output.vertex = UnityObjectToClipPos(input[i].vertex);
                    output.uv = TRANSFORM_TEX(input[i].uv, _MainTex);
                    output.color = fixed4(0.0, 0.0, 0.0, 1.0);
                    triStream.Append(output);
                    output.vertex = UnityObjectToClipPos(
                        barycenter + float4(normal, 0.0) * _ExtrusionFactor
                    );


                    output.uv = TRANSFORM_TEX(input[i].uv, _MainTex);
                    output.color = fixed4(0.0,0.0,0.0, 1.0);
                    triStream.Append(output);
                    output.vertex = UnityObjectToClipPos(input[next].vertex);

                    output.uv = TRANSFORM_TEX(input[next].uv, _MainTex);
                    output.color = fixed4(0.0, 0.0, 0.0, 1.0);
                    triStream.Append(output);
                    triStream.RestartStrip();
                }

                for (int j = 0; j < 3; j++)
                {
                    output.vertex = UnityObjectToClipPos(input[j].vertex);

                    output.uv = TRANSFORM_TEX(input[j].uv, _MainTex);
                    output.color = fixed4(0.0, 0.0, 0.0, 1.0);
                    triStream.Append(output);
                }

                triStream.RestartStrip();
            }



            fixed4 frag(G2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * _Color;
            }
            ENDCG
        }
    }
}