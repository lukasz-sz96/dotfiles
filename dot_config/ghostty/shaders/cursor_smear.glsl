float saturate(float v) {
    return clamp(v, 0.0, 1.0);
}

vec2 cursorCenter(vec4 cursor) {
    return cursor.xy + vec2(cursor.z * 0.5, -cursor.w * 0.5);
}

float cursorGlow(vec2 p, vec4 cursor, float size, float softness) {
    vec2 center = cursorCenter(cursor);
    float radius = max(max(cursor.z, cursor.w) * size, 6.0);
    float dist = length(p - center);
    return exp(-(dist * dist) / max(radius * softness, 0.001));
}

float segmentDistance(vec2 p, vec2 a, vec2 b, out float along) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    along = saturate(dot(pa, ba) / max(dot(ba, ba), 0.001));
    return length(pa - ba * along);
}

vec3 cursorColor() {
    vec3 fallback = vec3(0.404, 0.671, 0.894);
    return mix(fallback, iCurrentCursorColor.rgb, step(0.01, iCurrentCursorColor.a));
}

vec3 noctaliaAccent(vec3 cursor) {
    vec3 blue = vec3(0.404, 0.671, 0.894);
    vec3 lavender = vec3(0.882, 0.588, 0.914);
    float luma = dot(cursor, vec3(0.299, 0.587, 0.114));
    vec3 accent = mix(blue, lavender, 0.34);
    return mix(cursor, accent, smoothstep(0.72, 0.92, luma));
}

float softSparkle(vec2 p, float age) {
    float wave = sin(p.x * 0.055 + p.y * 0.037 - age * 18.0);
    return 0.5 + 0.5 * wave;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 currentCenter = cursorCenter(iCurrentCursor);
    vec2 previousCenter = cursorCenter(iPreviousCursor);
    vec2 move = currentCenter - previousCenter;

    float validCursor = step(0.5, min(iCurrentCursor.z, iCurrentCursor.w));
    float validPrevious = step(0.5, min(iPreviousCursor.z, iPreviousCursor.w));
    float movement = length(move);
    float activeMove = validCursor * validPrevious * smoothstep(2.0, 18.0, movement);

    float age = max(iTime - iTimeCursorChange, 0.0);
    float fade = exp(-age * 5.8) * (1.0 - smoothstep(0.30, 0.54, age));
    float activity = activeMove * fade;

    float along = 0.0;
    float dist = segmentDistance(fragCoord, previousCenter, currentCenter, along);
    vec2 dir = move / max(movement, 0.001);
    vec2 ribbonPoint = mix(previousCenter, currentCenter, along);
    float side = dot(fragCoord - ribbonPoint, vec2(-dir.y, dir.x));

    float cursorScale = max(max(iCurrentCursor.z, iCurrentCursor.w), 8.0);
    float width = cursorScale * mix(0.40, 0.72, smoothstep(0.0, 160.0, movement));
    float trailCore = 1.0 - smoothstep(width * 0.18, width * 0.88, dist);
    float trailGlow = 1.0 - smoothstep(width * 0.70, width * 2.65, dist);
    float tail = smoothstep(0.02, 0.18, along) * (1.0 - smoothstep(0.90, 1.0, along));
    float ribbon = activity * tail * (trailCore * 0.62 + trailGlow * 0.20);

    float wobble = sin(along * 12.0 - age * 18.0) * exp(-age * 7.0);
    vec2 drag = dir * ribbon * (4.0 + 5.0 * (1.0 - along));
    vec2 ripple = vec2(-dir.y, dir.x) * wobble * trailGlow * activity * 1.15;

    vec4 base = texture(iChannel0, uv);
    vec2 pulledUv = clamp((fragCoord - drag + ripple) / iResolution.xy, vec2(0.0), vec2(1.0));
    vec4 pulled = texture(iChannel0, pulledUv);

    vec3 color = mix(base.rgb, pulled.rgb, saturate(ribbon * 0.22));

    vec3 cursor = noctaliaAccent(cursorColor());
    vec3 blue = vec3(0.404, 0.671, 0.894);
    vec3 lavender = vec3(0.882, 0.588, 0.914);
    vec3 rose = vec3(0.800, 0.427, 0.400);
    vec3 edgeTint = mix(lavender, blue, smoothstep(-width, width, side));
    vec3 trailTint = mix(cursor, edgeTint, 0.36 + 0.12 * sin(along * 4.0 + age * 10.0));
    trailTint = mix(trailTint, rose, trailCore * 0.08);
    float shimmer = mix(0.88, 1.08, softSparkle(ribbonPoint, age) * trailCore);

    color += trailTint * ribbon * shimmer * (0.19 + trailCore * 0.18);

    float pulse = exp(-age * 8.0);
    float glow = cursorGlow(fragCoord, iCurrentCursor, 1.05 + 0.20 * pulse, 18.0) * validCursor;
    float innerGlow = cursorGlow(fragCoord, iCurrentCursor, 0.40, 6.0) * validCursor;
    color += cursor * glow * (0.045 + 0.045 * pulse);
    color += mix(cursor, blue, 0.22) * innerGlow * (0.035 + 0.035 * pulse);

    fragColor = vec4(clamp(color, 0.0, 1.0), base.a);
}
