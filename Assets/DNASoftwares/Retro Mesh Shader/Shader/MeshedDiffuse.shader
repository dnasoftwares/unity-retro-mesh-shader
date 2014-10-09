// Shader created with Shader Forge Beta 0.36 
// Shader Forge (c) Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:0.36;sub:START;pass:START;ps:flbk:Transparent/Diffuse,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:1,bsrc:3,bdst:7,culm:0,dpts:2,wrdp:True,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:32511,y:33027|diff-5-OUT,alpha-16-OUT;n:type:ShaderForge.SFN_Color,id:2,x:32939,y:33047,ptlb:Color,ptin:_Color,glob:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:3,x:32939,y:32872,ptlb:Base Texture,ptin:_BaseTexture,ntxv:0,isnm:False|UVIN-4-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:4,x:33686,y:32874,uv:0;n:type:ShaderForge.SFN_Multiply,id:5,x:32751,y:33027|A-3-RGB,B-2-RGB,C-59-RGB;n:type:ShaderForge.SFN_ScreenParameters,id:6,x:33739,y:33110;n:type:ShaderForge.SFN_ScreenPos,id:7,x:33720,y:33279,sctp:2;n:type:ShaderForge.SFN_Multiply,id:16,x:32751,y:33220|A-3-A,B-2-A,C-59-A,D-43-OUT;n:type:ShaderForge.SFN_Code,id:43,x:33073,y:33334,code:bQBzAHoAKwA9ADAALgAwADAAMAAxAGYAOwAgAC8ALwAgAGkAdAAnAHMAIABtAHkAcwB0AGUAcgBpAG8AdQBzACAAbQBhAGcAaQBjAC4ALgAuAAoAZgBsAG8AYQB0ACAAeAA9AHMALgB4ACoAcAB4AHcAOwAKAGYAbABvAGEAdAAgAHkAPQBzAC4AeQAqAHAAeABoADsACgAKAGYAbABvAGEAdAAgAHgAbQAgAD0AIABmAG0AbwBkACgAeAAsAG0AcwB6ACoAMgApAD4AKABtAHMAegApAD8AMQA6ADAAOwAKAGYAbABvAGEAdAAgAHkAbQAgAD0AIABmAG0AbwBkACgAeQAsAG0AcwB6ACoAMgApAD4AKABtAHMAegApAD8AMQA6ADAAOwAKAAoAcgBlAHQAdQByAG4AIAB5AG0APQA9AHgAbQA/ADEAOgAwADsA,output:0,fname:ScreenToMesh,width:446,height:244,input:1,input:0,input:0,input:0,input_1_label:s,input_2_label:pxw,input_3_label:pxh,input_4_label:msz|A-7-UVOUT,B-6-PXW,C-6-PXH,D-46-OUT;n:type:ShaderForge.SFN_ValueProperty,id:46,x:33825,y:33457,ptlb:Mesh Size,ptin:_MeshSize,glob:False,v1:4;n:type:ShaderForge.SFN_VertexColor,id:59,x:32980,y:33195;proporder:2-3-46;pass:END;sub:END;*/

Shader "DNA Softwares/MeshedDiffuse" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _BaseTexture ("Base Texture", 2D) = "white" {}
        _MeshSize ("Mesh Size", Float ) = 4
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform sampler2D _BaseTexture; uniform float4 _BaseTexture_ST;
            float ScreenToMesh( float2 s , float pxw , float pxh , float msz ){
            msz+=0.0001f; // it's mysterious magic...
            float x=s.x*pxw;
            float y=s.y*pxh;
            
            float xm = fmod(x,msz*2)>(msz)?1:0;
            float ym = fmod(y,msz*2)>(msz)?1:0;
            
            return ym==xm?1:0;
            }
            
            uniform float _MeshSize;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 screenPos : TEXCOORD3;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.screenPos = o.pos;
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5;
/////// Normals:
                float3 normalDirection =  i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                float2 node_4 = i.uv0;
                float4 node_3 = tex2D(_BaseTexture,TRANSFORM_TEX(node_4.rg, _BaseTexture));
                float4 node_59 = i.vertexColor;
                finalColor += diffuseLight * (node_3.rgb*_Color.rgb*node_59.rgb);
                float4 node_6 = _ScreenParams;
/// Final Color:
                return fixed4(finalColor,(node_3.a*_Color.a*node_59.a*ScreenToMesh( sceneUVs.rg , node_6.r , node_6.g , _MeshSize )));
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform sampler2D _BaseTexture; uniform float4 _BaseTexture_ST;
            float ScreenToMesh( float2 s , float pxw , float pxh , float msz ){
            msz+=0.0001f; // it's mysterious magic...
            float x=s.x*pxw;
            float y=s.y*pxh;
            
            float xm = fmod(x,msz*2)>(msz)?1:0;
            float ym = fmod(y,msz*2)>(msz)?1:0;
            
            return ym==xm?1:0;
            }
            
            uniform float _MeshSize;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float4 screenPos : TEXCOORD3;
                float4 vertexColor : COLOR;
                LIGHTING_COORDS(4,5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                o.screenPos = o.pos;
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.normalDir = normalize(i.normalDir);
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5;
/////// Normals:
                float3 normalDirection =  i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
                float3 finalColor = 0;
                float3 diffuseLight = diffuse;
                float2 node_4 = i.uv0;
                float4 node_3 = tex2D(_BaseTexture,TRANSFORM_TEX(node_4.rg, _BaseTexture));
                float4 node_59 = i.vertexColor;
                finalColor += diffuseLight * (node_3.rgb*_Color.rgb*node_59.rgb);
                float4 node_6 = _ScreenParams;
/// Final Color:
                return fixed4(finalColor * (node_3.a*_Color.a*node_59.a*ScreenToMesh( sceneUVs.rg , node_6.r , node_6.g , _MeshSize )),0);
            }
            ENDCG
        }
    }
    FallBack "Transparent/Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
