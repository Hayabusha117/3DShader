Shader "MyShader/Hologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color",Color) = (1,1,1,1)
        _Hologram("Hologram",2D) = "white"{}
        _Frequency("Frequency",Range(1,30)) = 1
        _Speed("Speed",Range(0,5))=1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque"
            "Queue" = "Transparent"
        }
            //efecto de transparencia 
        Blend SrcAlpha oneMinusSrcAlpha //que tanto se va a poner transparente el objeto, esta tomando el canal alpha y aplica la operacion oneMinus

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            //es el vertex input
            struct appdata
            {
                float4 vertex : POSITION; //cordenadas de geometria 
                float2 uv : TEXCOORD0;//cordenadas de textura de una imagen
            };


            //vertex output v2f= vertex to frag (lo que se va a mandar)
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 huv:TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _Hologram;
            float4 _MainTex_ST; //repeticion
            float4 _Color;

            float _Frequency;
            float _Speed;

            //vertex Shader
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);//nunca olvidar la proyeccion
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.huv = v.uv;
                o.huv.y += _Time * _Speed;

                return o;
            }

            //
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv)*_Color;
                fixed holo = tex2D(_Hologram, i.uv);
                col.a = abs(sin(i.huv.y * _Frequency));

            
                return col;
            }
            ENDCG
        }
    }
}
