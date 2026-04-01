#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

struct Uniforms {
    float time;
    float2 resolution;
};

vertex VertexOut vertex_main(uint vertexID [[vertex_id]]) {
    float2 positions[4] = {
        float2(-1, -1), float2(1, -1),
        float2(-1,  1), float2(1,  1)
    };
    float2 uvs[4] = {
        float2(0, 1), float2(1, 1),
        float2(0, 0), float2(1, 0)
    };
    VertexOut out;
    out.position = float4(positions[vertexID], 0, 1);
    out.uv = uvs[vertexID];
    return out;
}

float hash(float2 p) {
    return fract(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

float snoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i),              hash(i + float2(1,0)), u.x),
               mix(hash(i + float2(0,1)), hash(i + float2(1,1)), u.x), u.y);
}

// FBM — 전체 잔물결용
float fbm(float2 p, float t) {
    float v = 0.0, a = 0.5;
    for (int i = 0; i < 4; i++) {
        v += a * snoise(p + float2(t * 0.28, t * 0.19));
        p  = p * 2.1 + float2(100.0);
        a *= 0.5;
    }
    return v; // [0, ~1]
}

// 부드러운 blob
float blob(float2 uv, float2 center, float radius) {
    return 1.0 - smoothstep(0.0, radius, length(uv - center));
}

fragment float4 fragment_main(VertexOut in [[stage_in]],
                               constant Uniforms &u [[buffer(0)]]) {
    float aspect = u.resolution.x / u.resolution.y;
    float2 uv = in.uv - 0.5;
    uv.x *= aspect;

    float t     = u.time;
    float tBlob = u.time * 1.3; // blob 속도 독립 조절

    // LAYER 1: 전체 화면 FBM 잔물결 (베이스)
    float wave = fbm(in.uv * 2.5, t * 0.35);
    wave = pow(wave, 2.0);
    float baseLum = wave * 0.12; // 아주 은은하게

    // LAYER 2: 큰 덩어리 blob — 화면 전체를 크게 유랑
    // 리사주 + FBM 왜곡으로 예측 불가능하게

    // blob 중심 위치: 리사주 궤도 (화면 끝까지 돌아다님)
    // 주파수 비를 무리수에 가깝게 → 절대 같은 경로 반복 안 함
    float2 b1Center = float2(
        sin(tBlob * 0.41) * 0.38 + sin(tBlob * 0.17) * 0.14,
        cos(tBlob * 0.31) * 0.30 + cos(tBlob * 0.23) * 0.12
    );
    float2 b2Center = float2(
        cos(tBlob * 0.37 + 2.1) * 0.35 + cos(tBlob * 0.13) * 0.10,
        sin(tBlob * 0.29 + 1.4) * 0.32 + sin(tBlob * 0.19) * 0.14
    );
    float2 b3Center = float2(
        sin(tBlob * 0.53 + 4.2) * 0.30 + sin(tBlob * 0.11) * 0.16,
        cos(tBlob * 0.43 + 3.1) * 0.28 + cos(tBlob * 0.27) * 0.10
    );

    // UV에도 FBM 왜곡 추가 → blob 경계가 물결처럼 흐름
    float2 distUV = uv;
    float dx = snoise(uv * 1.8 + float2(t * 0.22, 0.0)) * 2.0 - 1.0;
    float dy = snoise(uv * 1.8 + float2(0.0, t * 0.22 + 5.3)) * 2.0 - 1.0;
    distUV += float2(dx, dy) * 0.10;

    // 각 blob 크기: 화면의 절반 ~ 2/3를 덮는 큰 덩어리
    float g1 = blob(distUV, b1Center, 0.52) * 0.90;
    float g2 = blob(distUV, b2Center, 0.44) * 0.75;
    float g3 = blob(distUV, b3Center, 0.36) * 0.60;

    float blobLum = clamp(g1 + g2 + g3, 0.0, 1.0);
    blobLum = pow(blobLum, 1.5); // 피크만 살리고 가장자리 어둡게

    float lum = clamp(baseLum + blobLum * 0.88, 0.0, 1.0);

    // 실측 기반 알파: 피크 ~0.28, 평균 훨씬 낮게
    float alpha = lum * 0.28;

    // 하단 페이드
    float bottomFade = smoothstep(0.0, 0.15, in.uv.y);
    alpha *= bottomFade;

    // 흰색 오버레이 — 어떤 팀 컬러 위에도 색감 유지
    return float4(alpha, alpha, alpha, alpha); // premultiplied white
}
