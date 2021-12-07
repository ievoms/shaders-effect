Shader "Custom/VertexDisplacementShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _DisplacementTex("Displacement Texture", 2D) = "grey" {}
        _MaxDisplacement("Max Displacement", Float) = 1.0
    }
    SubShader
    {

        Pass 
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            sampler2D _DisplacementTex;
            float _MaxDisplacement;

            struct vertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct vertexOutput {
                float4 position :   SV_POSITION;
                float4 texcoord : TEXCOORD0;
            };
            vertexOutput vert(vertexInput i) {
                vertexOutput o;

                // get color for displacement map, and convert to float from 0 to _MaxDisplacement
                //text2Dlod - lod - level of detail
                float4 dispTexColor = tex2Dlod(_DisplacementTex, float4(i.normal.xy, 0.0, 0.0));
                //dot  vektoriu daugyba
                float displacement = dispTexColor * _MaxDisplacement;
                

                //displace vertices along surface normal vector
                float4 newVertexPos = i.vertex + float4(i.normal * displacement  , 0.0);

                //output data
                o.position = UnityObjectToClipPos(newVertexPos);
                o.texcoord = newVertexPos;
                return o;
            }

            float4 frag(vertexOutput i) : COLOR
            {
                return tex2D(_MainTex, i.texcoord.xy);
            }

            ENDCG
        }
    }
}
