shader_type canvas_item;

uniform float speed = 1.0; 
uniform float frequency = 1.0; 
uniform float saturation = 1.0; 
uniform float value = 1.0; 
uniform float mix_amount : hint_range(0.0, 1.0) = 1.0; 

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    // 1. Orijinal rengi al
    vec4 tex_color = texture(TEXTURE, UV);
    
    // 2. PIXEL ART DÜZELTMESİ:
    // UV koordinatlarını pürüzsüz akmaktan çıkarıp, dokunun piksel boyutuna göre basamaklandırıyoruz (yuvarlıyoruz).
    vec2 pixelated_uv = floor(UV / TEXTURE_PIXEL_SIZE) * TEXTURE_PIXEL_SIZE;
    
    // 3. Normal UV yerine, bu basamaklanmış 'pixelated_uv' değerini kullanıyoruz.
    // Böylece gökkuşağı gradyanı piksellerin ortasından bölünmek yerine tam piksellerin üzerine oturur.
    float hue = fract(pixelated_uv.x * frequency + (TIME * speed));
    
    vec3 rainbow_color = hsv2rgb(vec3(hue, saturation, value));
    
    vec3 final_color = mix(tex_color.rgb, tex_color.rgb * rainbow_color, mix_amount);
    
    COLOR = vec4(final_color, tex_color.a);
}