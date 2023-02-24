Shader "MyShader/BasicShader"
{
    Properties
    {
        _Color("Main Color",Color) = (1,1,1,1)
        _MainTex("Main Texture",2D)="white"{}

    }

        SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader //se compila 
            #include "UnityCG.cginc"
            //ligar variables del codigo principal con el shader
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;

            //Vertex Input
            struct vertexInput
            {
                //posicion de los vertices
                float4 vertex:POSITION;
                float2 uv:TEXCOORD0; // recuperar la informacion de entrada
            };

            //Vertex Oput
            struct vertexOutput
            {
                float4 position:SV_POSITION; //pasar al viewSpace
                float2 uv:TEXCOORD0;
            };

            vertexOutput vertexShader(vertexInput i)
            {
                vertexOutput o;
                o.position = UnityObjectToClipPos(i.vertex); // para que no se deforme la geometria 
                /*o.uv = i.uv;
                o.uv = (i.uv * _MainTex_ST.xy + _MainTex_ST.zw);*/// tile de la textura x=u , y=v, z= offset en x , w= offset en y
                o.uv = TRANSFORM_TEX(i.uv, _MainTex);// segunda forma de como modificar los tiles
                return o;

            }

            fixed4 fragmentShader(vertexOutput i) :SV_Target{
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }

            ENDCG
        }
    }

    FallBack "Default"
}
