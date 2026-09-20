shader_type canvas_item;

// Hız ve Yön Ayarları
uniform vec2 direction = vec2(0.0, -1.0);
uniform float speed = 0.2;
uniform float bubble_scale = 1.0;
uniform float aspect_ratio = 1.0; 

// --- PİKSEL AYARI ---
// Y eksenine sığacak piksel sayısı. Örneğin ekranınız 1080p ise ve "4x" scale
// istiyorsanız (1080 / 4 = 270), bu değeri 270 yapmalısınız. Ne kadar düşük o kadar pikselli.
uniform float pixel_amount = 150.0; 

// Renk Ayarları
uniform vec4 color_bg : source_color = vec4(0.0, 0.0, 0.0, 0.0);       
uniform vec4 color_outer : source_color = vec4(0.1, 0.4, 0.8, 1.0);    
uniform vec4 color_inner_edge : source_color = vec4(0.3, 0.7, 0.9, 1.0); 
uniform vec4 color_inside : source_color = vec4(0.8, 0.95, 1.0, 1.0);  

// Birleşme ve Kalınlık Eşikleri
uniform float threshold_outer = 1.0;
uniform float threshold_inner_edge = 1.2;
uniform float threshold_inside = 1.6;

float rand(float n) { 
    return fract(sin(n) * 43758.5453123); 
}

void fragment() {
    vec2 uv = UV;
    
    // ----------------------------------------------------
    // UV PİKSELLEŞTİRME ADIMI
    // Yatay piksel sayısını ekran oranına göre hesapla (Piksellerin kare kalması için)
    vec2 grid_resolution = vec2(pixel_amount * aspect_ratio, pixel_amount);
    
    // UV koordinatlarını ızgaraya (grid) yuvarla
    uv = floor(uv * grid_resolution) / grid_resolution;
    // ----------------------------------------------------

    // Ekran oranını uygula (Pikselleştirmeden sonra yapılmalı)
    uv.x *= aspect_ratio; 

    float field = 0.0;
    int num_bubbles = 20;

    for (int i = 0; i < num_bubbles; i++) {
        float fi = float(i);

        vec2 start_pos = vec2(rand(fi * 1.2), rand(fi * 2.5));
        start_pos.x *= aspect_ratio; 

        float size_mult = mix(0.5, 1.5, rand(fi * 3.14)); 
        float speed_mult = mix(0.7, 1.3, rand(fi * 4.2)); 

        vec2 pos = start_pos + direction * TIME * speed * speed_mult;

        pos.x = mod(pos.x, aspect_ratio);
        pos.y = fract(pos.y);

        vec2 diff = abs(uv - pos);
        diff.x = min(diff.x, aspect_ratio - diff.x);
        diff.y = min(diff.y, 1.0 - diff.y);

        float d = length(diff);
        d = max(d, 0.0001); 

        float radius = 0.04 * bubble_scale * size_mult;

        field += (radius * radius) / (d * d);
    }

    // --- RENKLENDİRME ---
    vec4 final_color = color_bg;

    // Piksel görünümü için pürüzsüz geçiş sağlayan 'smoothstep' yerine
    // keskin çizgi çeken 'step' kullanıyoruz.
    float mask_outer = step(threshold_outer, field);
    final_color = mix(final_color, color_outer, mask_outer);

    float mask_inner_edge = step(threshold_inner_edge, field);
    final_color = mix(final_color, color_inner_edge, mask_inner_edge);

    float mask_inside = step(threshold_inside, field);
    final_color = mix(final_color, color_inside, mask_inside);

    COLOR = final_color;
}