Shader "Custom/Particle" {

	SubShader {
		Pass {
		Tags{ "RenderType" = "Opaque" }
		LOD 200
		Blend SrcAlpha one

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 5.0

		struct Particle{
			float3 position;
			float3 velocity;
			float life;
		};
		
		struct PS_INPUT{
			float4 position : SV_POSITION;
			float4 color : COLOR;
			float life : LIFE;
		};
		// particles' data
		StructuredBuffer<Particle> particleBuffer;
		

		PS_INPUT vert(uint vertex_id : SV_VertexID, uint instance_id : SV_InstanceID)
		{
			PS_INPUT o = (PS_INPUT)0;

			// Color
			float life = particleBuffer[instance_id].life;
			float lerpVal = life * 0.25f;
			o.color = fixed4(1.0f - lerpVal+0.1, lerpVal+0.1, 1.0f, lerpVal);

			// Position
			o.position = UnityObjectToClipPos(float4(particleBuffer[instance_id].position, 1.0f));

			return o;
		}

		float4 frag(PS_INPUT i) : COLOR
		{
			return i.color;
		}

		struct g2f
		{
			
		};

		[maxvertexcount(4)] // on génère un triangle strip de 4 points
		void geom(point PS_INPUT IN[1], inout TriangleStream<g2f> triStream) {
		// v2g est une structure (à définir) émise en sortie du Vertex Shader
		// IN[1] est un tableau de v2g, qui ne contient qu’une seule entrée (car le vertex shader traite un point ici)
		// triStream est un tableau de la structure g2f (à définir) stockant les Vertex à générer
		}



		ENDCG
		}
	}
	FallBack Off
}