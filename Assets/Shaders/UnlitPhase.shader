Shader "GAT350/UnlitPhase"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amplitude("Amplitude", Range(0.0, 0.5)) = 0.25
        _Scroll("Scroll", Range(0.0, 0.5)) = 0.25
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

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Scroll;
            float _Amplitude;

            float random(float2 st) 
			{
				return frac(sin(dot(st.xy,
					float2(12.9898,78.233))) * 43758.5453123);
			}
 
			float valueNoise(float2 st) 
			{
				float2 i = floor(st);
				float2 f = frac(st);
				// Four corners
				float a = random(i);
				float b = random(i + float2(1.0, 0.0));
				float c = random(i + float2(0.0, 1.0));
				float d = random(i + float2(1.0, 1.0));
 
				// Smooth interpolation
				float2 u = f * f * (3.0 - 2.0 * f);
 
				// Mix
				return lerp(a, b, u.x) +
						(c - a)* u.y * (1.0 - u.x) +
						(d - b) * u.x * u.y;
			}

            v2f vert (appdata v)
            {
                v2f o;
                //the effect that is morphing the verticies and creating the random feel
                v.vertex.x = v.vertex.x - sin((v.vertex.x + _Time.w) * valueNoise(v.uv + _Time.y)) * 0.05 * _Amplitude;

                //Creating the horizontal scrolling
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.x = o.uv.x + (_Time.y * _Scroll);

                o.vertex = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 color1 = tex2D(_MainTex, i.uv);
                

                //creating the fuzziness & Vertical scrolling 
                float r = random(i.uv + _Time.x);
                float g = random(i.uv + _Time.x);
                float b = random(i.uv + _Time.x);
                float a = random(i.uv + _Time.x);
                fixed4 color2 = fixed4(r, g, b, a);

                //lerp value is low so that the texture is what mostly shows
                fixed4 color = lerp(color1, color2, 0.05f);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, color);
                return color;
            }
            ENDCG
        }
    }
}
