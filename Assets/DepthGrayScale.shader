// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DepthGrayscale" {

	Properties{
		_gray("Gray Scale", Float) = 0
	}

	SubShader {
		Cull Off ZWrite Off ZTest Always
		Tags { "RenderType"="Opaque" }

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			#define f_05 float3(.5, .5, .5)
			#define f_10 float3(1., 1., 1.)

			float _gray;

			sampler2D _CameraDepthTexture;

			struct v2f {
			   float4 pos : SV_POSITION;
			   float4 scrPos:TEXCOORD1;
			};

			v2f vert (appdata_base v){
			   v2f o;
			   o.pos = UnityObjectToClipPos (v.vertex);
			   o.scrPos = ComputeScreenPos(o.pos);
			   return o;
			}

			half4 frag (v2f i) : COLOR{
				// the value is between [0, 1] = [near plane, far plane]
				float depth = Linear01Depth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r);

				if(_gray > 0.)
					return half4(depth, depth, depth, 1.);
				
				float3 d =  f_05+f_05*cos(6.28318*(f_10*depth+float3(.0, .33, .67)));
				return half4(d.r, d.g, d.b, 1.);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}