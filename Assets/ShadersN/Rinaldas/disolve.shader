Shader "Unlit/disolve"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DisTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        // LOD 100
        // Zwrite off
        // Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

           float4 rotatete ( float angle, float3 vert )
           {
                float4 vertex = float4( vert, 0 );
        // -----------Rotation matrix in X ----------  
                // float4x4 mat;
                // mat[0] = float4(1, 0, 0, 0);
                // mat[1] = float4(0, cos(angle), -sin(angle), 0);
                // mat[2] = float4(0, sin(angle), cos(angle), 0);
                // mat[3] = float4(0, 0, 0, 1);
        // -----------Rotation matrix in X ----------  
        // -----------Rotation matrix in Y ---------
                // float4x4 mat;
                // mat[0] = float4(cos(angle), 0, sin(angle), 0);
                // mat[1] = float4(0, 1, 0, 0);
                // mat[2] = float4(-sin(angle), 0, cos(angle), 0);
                // mat[3] = float4(0, 0, 0, 1);
        // -----------Rotation matrix in Y ----------  
        // -----------Rotation matrix in Z ---------- 
                float4x4 mat;
                mat[0] = float4(cos(angle), -sin(angle), 0, 0);
                mat[1] = float4(sin(angle), cos(angle), 0, 0);
                mat[2] = float4(0, 0, 1, 0);
                mat[3] = float4(0, 0, 0, 1);
                
        // -----------Rotation matrix in z ----------
                return mul(mat, vert);
           }

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _DisTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = v.vertex;
                // rotating by Time fraction x 3 and vertex
                o.vertex = rotatete( (3 * frac(_Time.z)), v.vertex );
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {  
               sin(i.uv.y += _Time.y);    
               fixed4 col = tex2D(_MainTex, i.uv);
               fixed4 dis = tex2D(_DisTex, i.uv);
               // clipping part of the vertex by noise texture
               clip( col - dis/3 );
               return col;
            }
            ENDCG
        }
    }
}
