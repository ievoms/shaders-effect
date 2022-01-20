Shader "Unlit/linija2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                i.uv.x =i.uv.x- _Time.x;

                float2 middleLine = float2(clamp(i.uv.x,-5,5),0.5);

                middleLine.y = (sin(middleLine *6 ) *0.2)*sin(_Time.z)+0.5;      
                
                float2 atstumas = distance(i.uv,middleLine) ;


                float4 col= float4(0,0,0,1);
                if( atstumas.x<0.2){
                    col=tex2D(_MainTex, i.uv);
                }

                return col;
            }
            ENDCG
        }
    }
}
