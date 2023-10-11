Shader "Kotikov/Glass"
{
    Properties
    {
        _Color ("Main color", Color) = (1,1,1,1)
        [Space(10)]
        _MainTex ("Albedo", 2D) = "white" {}
        [NoScaleOffset] _NormalTex ("Normal", 2D) = "bump" {}
        [NoScaleOffset] _AlphaMask ("Alpha mask", 2D) = "white" {}
        [Space(10)]
        _Specularity ("Specularity", Range(0,1)) = 0.5
        _Shiness ("Shiness", Range(0,1)) = 0.5
       
    }
    SubShader
    {
        Tags { 
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
        }
        
        LOD 200
        Cull Off 
        
        CGPROGRAM
        #pragma surface surf StandardSpecular fullforwardshadows alpha
        #pragma target 3.0

        sampler2D
            _MainTex,
            _NormalTex,
            _AlphaMask;

        half
            _Glossiness,
            _Metallic;

        fixed
            _Specularity,
            _Shiness;
        
        fixed4
            _Color;
        
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalTex;
            float2 uv_AlphaMask;
        };
        
        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            float3 mask = tex2D (_AlphaMask, IN.uv_MainTex).rgb;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed3 albedo = c.rgb;
            
            o.Albedo = albedo;
            o.Alpha = c.a * mask;
            o.Specular = (fixed3) _Specularity * albedo;
            o.Smoothness = _Shiness;
            o.Normal = tex2D (_NormalTex, IN.uv_MainTex);
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
