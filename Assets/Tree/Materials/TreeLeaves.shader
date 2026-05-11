Shader "Custom/TreeLeavesAnimated"
{
    Properties
    {
        _MainTex ("Leaf Texture", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
        _Glossiness ("Glossiness", Range(0,1)) = 0.3
        _Translucency ("Translucency Strength", Range(0,1)) = 0.5
        _TransColor ("Translucent Color", Color) = (0.5, 1, 0.5, 1)
        _WaveStrength ("Wave Strength", Range(0,0.5)) = 0.1
        _WaveSpeed ("Wave Speed", Range(0,5)) = 1.0
    }

    SubShader
    {
        Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alphatest:_Cutoff addshadow vertex:vert

        sampler2D _MainTex;
        sampler2D _BumpMap;
        half _Glossiness;
        half _Translucency;
        fixed4 _TransColor;
        float _WaveStrength;
        float _WaveSpeed;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        // Vertex function for wave animation
        void vert (inout appdata_full v)
        {
            float wave = sin(_Time.y * _WaveSpeed + v.vertex.x * 0.5 + v.vertex.y * 0.5);
            v.vertex.y += wave * _WaveStrength;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;

            // Alpha cutout
            o.Alpha = c.a;

            // Normal map
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

            // Glossiness
            o.Smoothness = _Glossiness;

            // Fake translucency
            o.Emission = _TransColor.rgb * _Translucency * saturate(1 - o.Albedo);
        }
        ENDCG
    }
    FallBack "Transparent/Cutout/Diffuse"
}
