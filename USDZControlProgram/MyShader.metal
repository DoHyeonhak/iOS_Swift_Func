#include <metal_stdlib>
using namespace metal;

constant int runtimeFunctionConstants [[function_constant(0)]];

kernel void ditherShader(texture2d<float, access::write> output [[texture(0)]],
                         uint2 gid [[thread_position_in_grid]]) {
    if (gid.x < output.get_width() && gid.y < output.get_height()) {
        float4 color = float4(1.0, 0.0, 0.0, 1.0); // 빨간색 픽셀
        output.write(color, gid);
    }
}
