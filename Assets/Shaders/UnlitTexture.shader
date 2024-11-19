Shader "GAT350/UnlitTexture"
{
    Properties
    {
        // Name In editor  Data Type
        _MainTex("Texture", 2D) = "white" {}
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _Intensity("Intensity", Range(0, 1)) = 1
        _Scroll("Scroll", Vector) = (0,0,0,0)
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"


            //Information coming from unity into the Shader
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            //Vertex 2 fragments (pixels)
            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            fixed4 _Tint;
            float _Intensity;
            float4 _Scroll;

            //We sample the pixels on the texture
            sampler2D _MainTex;
            float4 _MainTex_ST;

            //changes the states of our vertex
            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.xyz = v.vertex.xyz * 2;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.uv.x = o.uv.x + (_Time.y * _Scroll.x);
                o.uv.y = o.uv.y + (_Time.y * _Scroll.y);

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 color = tex2D(_MainTex, i.uv);
                color = fixed4(color.rgb * _Tint * _Intensity, color.a);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, color);
                return color;
            }
            ENDCG
        }
    }
}
