shader_type spatial;

render_mode unshaded, blend_mix;

uniform vec3 uv1_scale = vec3(1.0, 1.0, 1.0);
uniform vec3 uv1_offset = vec3(0.0, 0.0, 0.0);
uniform float variation = 0.0;
varying float elapsed_time;
void vertex() {
	elapsed_time = TIME;
	UV = UV*uv1_scale.xy+uv1_offset.xy;
}
float dot2(vec2 x) {
	return dot(x, x);
}
float rand(vec2 x) {
    return fract(cos(mod(dot(x, vec2(13.9898, 8.141)), 3.14)) * 43758.5);
}
vec2 rand2(vec2 x) {
    return fract(cos(mod(vec2(dot(x, vec2(13.9898, 8.141)),
						      dot(x, vec2(3.4562, 17.398))), vec2(3.14))) * 43758.5);
}
vec3 rand3(vec2 x) {
    return fract(cos(mod(vec3(dot(x, vec2(13.9898, 8.141)),
							  dot(x, vec2(3.4562, 17.398)),
                              dot(x, vec2(13.254, 5.867))), vec3(3.14))) * 43758.5);
}
float param_rnd(float minimum, float maximum, float seed) {
	return minimum+(maximum-minimum)*rand(vec2(seed));
}
float param_rndi(float minimum, float maximum, float seed) {
	return floor(param_rnd(minimum, maximum + 1.0, seed));
}
vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
const float p_o333447176263_cx = 0.000000000;
const float p_o333447176263_cy = 0.000000000;
const float p_o333447176263_scale_x = 0.650000000;
const float p_o333447176263_scale_y = 0.650000000;
const float p_o326769844240_amount1 = 1.150000000;
const float p_o326769844240_amount2 = 1.000000000;
const float p_o326753067022_amount1 = 1.000000000;
const float p_o326753067022_amount2 = 1.000000000;
const float seed_o326887284755 = 0.287872642;
const float p_o326887284755_count = 28.000000000;
const float p_o326887284755_rings = 1.000000000;
const float p_o326887284755_scale_x = 1.000000000;
const float p_o326887284755_scale_y = 1.000000000;
const float p_o326887284755_radius = 0.000000000;
const float p_o326887284755_spiral = 0.000000000;
const float p_o326887284755_i_rotate = 0.000000000;
const float p_o326887284755_i_scale = 0.180000000;
const float p_o326887284755_rotate = 180.000000000;
const float p_o326887284755_scale = 0.000000000;
const float p_o326887284755_value = 0.460000000;
const float seed_o326870507540 = 0.646312714;
const float p_o326870507540_cx = 0.000000000;
const float p_o326870507540_cy = 0.000000000;
const float seed_o326803398674 = 0.181593060;
const float p_o326803398674_count = 4.000000000;
const float p_o326803398674_rings = 1.000000000;
const float p_o326803398674_scale_x = 0.500000000;
const float p_o326803398674_scale_y = 0.500000000;
const float p_o326803398674_spiral = 0.000000000;
const float p_o326803398674_i_rotate = 1.000000000;
const float p_o326803398674_i_scale = 0.000000000;
const float p_o326803398674_rotate = 0.000000000;
const float p_o326803398674_scale = 0.150000000;
const float p_o326803398674_value = 0.000000000;
const float p_o326971170837_translate_x = 0.000000000;
const float p_o326971170837_translate_y = 0.000000000;
const float p_o326971170837_rotate = 0.000000000;
const float p_o326971170837_scale_x = 1.000000000;
const float p_o326971170837_scale_y = 1.000000000;
const float p_o327004725272_min = 0.500000000;
const float p_o327004725272_max = 1.000000000;
const float p_o327004725272_step = 0.000000000;
const float seed_o326987948055 = 0.652516663;
const float seed_o325847097332 = 0.297015786;
const float seed_o325561884652 = 0.328328013;
const float p_o325561884652_translate_x = 0.000000000;
const float p_o325561884652_rotate = 0.000000000;
const float p_o325561884652_scale_x = 1.000000000;
const float p_o325561884652_scale_y = 1.000000000;
const float p_o325796765681_amount1 = 1.000000000;
const float p_o325578661869_repeat = 1.000000000;
const float p_o325578661869_rotate = 0.000000000;
const float p_o325578661869_gradient_pos[2] = float[]( 0.069387756, 1.000000000 );
const vec4 p_o325578661869_gradient_col[2] = vec4[]( vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000), vec4(1.000000000, 1.000000000, 1.000000000, 1.000000000) );
const float p_o325813542899_amount1 = 1.000000000;
const float p_o325830320114_color = 0.500000000;
const float seed_o325545107435 = 0.571176708;
const float p_o325545107435_translate_y = 0.000000000;
const float p_o326786621455_cx = 0.000000000;
const float p_o326786621455_cy = 0.000000000;
const float p_o326786621455_scale_x = 16.000000000;
const float p_o326786621455_scale_y = 1.000000000;
const float seed_o325528330218 = 0.441879839;
const float p_o325528330218_scale_x = 32.000000000;
const float p_o325528330218_scale_y = 1.000000000;
const float p_o325528330218_folds = 0.000000000;
const float p_o325528330218_iterations = 1.000000000;
const float p_o325528330218_persistence = 0.000000000;
const float p_o325528330218_offset = 0.000000000;
uniform sampler2D texture_1;
const float texture_1_size = 512.000000000;
// #globals: scale_2 (o333447176263)
vec2 scale(vec2 uv, vec2 center, vec2 scale) {
	uv -= center;
	uv /= scale;
	uv += center;
	return uv;
}
// #globals: blend
vec3 blend_normal(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*c1 + (1.0-opacity)*c2;
}
vec3 blend_dissolve(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	if (rand(uv) < opacity) {
		return c1;
	} else {
		return c2;
	}
}
vec3 blend_multiply(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*c1*c2 + (1.0-opacity)*c2;
}
vec3 blend_screen(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*(1.0-(1.0-c1)*(1.0-c2)) + (1.0-opacity)*c2;
}
float blend_overlay_f(float c1, float c2) {
	return (c1 < 0.5) ? (2.0*c1*c2) : (1.0-2.0*(1.0-c1)*(1.0-c2));
}
vec3 blend_overlay(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_overlay_f(c1.x, c2.x), blend_overlay_f(c1.y, c2.y), blend_overlay_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_hard_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*0.5*(c1*c2+blend_overlay(uv, c1, c2, 1.0)) + (1.0-opacity)*c2;
}
float blend_soft_light_f(float c1, float c2) {
	return (c2 < 0.5) ? (2.0*c1*c2+c1*c1*(1.0-2.0*c2)) : 2.0*c1*(1.0-c2)+sqrt(c1)*(2.0*c2-1.0);
}
vec3 blend_soft_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_soft_light_f(c1.x, c2.x), blend_soft_light_f(c1.y, c2.y), blend_soft_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_burn_f(float c1, float c2) {
	return (c1==0.0)?c1:max((1.0-((1.0-c2)/c1)),0.0);
}
vec3 blend_burn(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_burn_f(c1.x, c2.x), blend_burn_f(c1.y, c2.y), blend_burn_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_dodge_f(float c1, float c2) {
	return (c1==1.0)?c1:min(c2/(1.0-c1),1.0);
}
vec3 blend_dodge(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_dodge_f(c1.x, c2.x), blend_dodge_f(c1.y, c2.y), blend_dodge_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_lighten(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*max(c1, c2) + (1.0-opacity)*c2;
}
vec3 blend_darken(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*min(c1, c2) + (1.0-opacity)*c2;
}
vec3 blend_difference(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*clamp(c2-c1, vec3(0.0), vec3(1.0)) + (1.0-opacity)*c2;
}
vec3 blend_additive(vec2 uv, vec3 c1, vec3 c2, float oppacity) {
	return c2 + c1 * oppacity;
}
vec3 blend_addsub(vec2 uv, vec3 c1, vec3 c2, float oppacity) {
	return c2 + (c1 - .5) * 2.0 * oppacity;
}
// #globals: adjust_hsv
vec3 rgb_to_hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy);
	vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx);
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv_to_rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
// #globals: blend2_4 (o326769844240)
float blend_linear_light_f(float c1, float c2) {
	return (c1 + 2.0 * c2) - 1.0;
}
vec3 blend_linear_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
return opacity*vec3(blend_linear_light_f(c1.x, c2.x), blend_linear_light_f(c1.y, c2.y), blend_linear_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_vivid_light_f(float c1, float c2) {
	return (c1 < 0.5) ? 1.0 - (1.0 - c2) / (2.0 * c1) : c2 / (2.0 * (1.0 - c1));
}
vec3 blend_vivid_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_vivid_light_f(c1.x, c2.x), blend_vivid_light_f(c1.y, c2.y), blend_vivid_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_pin_light_f( float c1, float c2) {
	return (2.0 * c1 - 1.0 > c2) ? 2.0 * c1 - 1.0 : ((c1 < 0.5 * c2) ? 2.0 * c1 : c2);
}
vec3 blend_pin_light(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_pin_light_f(c1.x, c2.x), blend_pin_light_f(c1.y, c2.y), blend_pin_light_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_hard_mix_f(float c1, float c2) {
	return floor(c1 + c2);
}
vec3 blend_hard_mix(vec2 uv, vec3 c1, vec3 c2, float opacity) {
		return opacity*vec3(blend_hard_mix_f(c1.x, c2.x), blend_hard_mix_f(c1.y, c2.y), blend_hard_mix_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
float blend_exclusion_f(float c1, float c2) {
	return c1 + c2 - 2.0 * c1 * c2;
}
vec3 blend_exclusion(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	return opacity*vec3(blend_exclusion_f(c1.x, c2.x), blend_exclusion_f(c1.y, c2.y), blend_exclusion_f(c1.z, c2.z)) + (1.0-opacity)*c2;
}
vec3 blend_hue(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	vec3 outcol = c2;
	vec3 hsv, hsv2, tmp;
	hsv2 = rgb_to_hsv(c1);
	if (hsv2.y != 0.0) {
		hsv = rgb_to_hsv(outcol);
		hsv.x = hsv2.x;
		tmp = hsv_to_rgb(hsv);
		outcol = mix(outcol, tmp, opacity);
	}
	return outcol;
}
vec3 blend_saturation(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	float facm = 1.0 - opacity;
	vec3 outcol = c2;
	vec3 hsv, hsv2;
	hsv = rgb_to_hsv(outcol);
	if (hsv.y != 0.0) {
		hsv2 = rgb_to_hsv(c1);
		hsv.y = facm * hsv.y + opacity * hsv2.y;
		outcol = hsv_to_rgb(hsv);
	}
	return outcol;
}
vec3 blend_color(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	float facm = 1.0 - opacity;
	vec3 outcol = c2;
	vec3 hsv, hsv2, tmp;
	hsv2 = rgb_to_hsv(c1);
	if (hsv2.y != 0.0) {
		hsv = rgb_to_hsv(outcol);
		hsv.x = hsv2.x;
		hsv.y = hsv2.y;
		tmp = hsv_to_rgb(hsv);
		outcol = mix(outcol, tmp, opacity);
	}
	return outcol;
}
vec3 blend_value(vec2 uv, vec3 c1, vec3 c2, float opacity) {
	float facm = 1.0 - opacity;
	vec3 hsv, hsv2;
	hsv = rgb_to_hsv(c2);
	hsv2 = rgb_to_hsv(c1);
	hsv.z = facm * hsv.z + opacity * hsv2.z;
	return hsv_to_rgb(hsv);
}
// #globals: shader_1 (o333413621834)
vec4 o1448108629132_gradient_gradient_fct(float x) {
	const float p_o1448108629132_gradient_pos[3] = float[]( 0.000000000, 0.653178990, 1.000000000 );
	const vec4 p_o1448108629132_gradient_col[3] = vec4[]( vec4(0.093246460, 0.342082918, 0.378906250, 1.000000000), vec4(0.021820068, 0.074318051, 0.107421875, 1.000000000), vec4(0.023563385, 0.043849036, 0.056640625, 1.000000000) );
  if (x < p_o1448108629132_gradient_pos[0]) {
    return p_o1448108629132_gradient_col[0];
  } else if (x < p_o1448108629132_gradient_pos[1]) {
    return mix(p_o1448108629132_gradient_col[0], p_o1448108629132_gradient_col[1], 0.5-0.5*cos(3.14159265359*(x-p_o1448108629132_gradient_pos[0])/(p_o1448108629132_gradient_pos[1]-p_o1448108629132_gradient_pos[0])));
  } else if (x < p_o1448108629132_gradient_pos[2]) {
    return mix(p_o1448108629132_gradient_col[1], p_o1448108629132_gradient_col[2], 0.5-0.5*cos(3.14159265359*(x-p_o1448108629132_gradient_pos[1])/(p_o1448108629132_gradient_pos[2]-p_o1448108629132_gradient_pos[1])));
  }
  return p_o1448108629132_gradient_col[2];
}
// #globals: uniform_greyscale (o326954393622)
// #globals: rotate_3 (o326870507540)
vec2 rotate(vec2 uv, float rotate) {
 	vec2 rv;
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	return rv;	
}
// #globals: transform2_3 (o326971170837)
vec2 transform2_clamp(vec2 uv) {
	return clamp(uv, vec2(0.0), vec2(1.0));
}
vec2 transform2(vec2 uv, vec2 translate, float rotate, vec2 scale) {
 	vec2 rv;
	uv -= translate;
	uv -= vec2(0.5);
	rv.x = cos(rotate)*uv.x + sin(rotate)*uv.y;
	rv.y = -sin(rotate)*uv.x + cos(rotate)*uv.y;
	rv /= scale;
	rv += vec2(0.5);
	return rv;	
}
// #globals: fbm3 (o325528330218)
float value_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float p00 = rand(mod(o, size));
	float p01 = rand(mod(o + vec2(0.0, 1.0), size));
	float p10 = rand(mod(o + vec2(1.0, 0.0), size));
	float p11 = rand(mod(o + vec2(1.0, 1.0), size));
	p00 = sin(p00 * 6.28318530718 + offset * 6.28318530718) / 2.0 + 0.5;
	p01 = sin(p01 * 6.28318530718 + offset * 6.28318530718) / 2.0 + 0.5;
	p10 = sin(p10 * 6.28318530718 + offset * 6.28318530718) / 2.0 + 0.5;
	p11 = sin(p11 * 6.28318530718 + offset * 6.28318530718) / 2.0 + 0.5;
	vec2 t =  f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	return mix(mix(p00, p10, t.x), mix(p01, p11, t.x), t.y);
}
float fbm_2d_value(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = value_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float perlin_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float a00 = rand(mod(o, size)) * 6.28318530718 + offset * 6.28318530718;
	float a01 = rand(mod(o + vec2(0.0, 1.0), size)) * 6.28318530718 + offset * 6.28318530718;
	float a10 = rand(mod(o + vec2(1.0, 0.0), size)) * 6.28318530718 + offset * 6.28318530718;
	float a11 = rand(mod(o + vec2(1.0, 1.0), size)) * 6.28318530718 + offset * 6.28318530718;
	vec2 v00 = vec2(cos(a00), sin(a00));
	vec2 v01 = vec2(cos(a01), sin(a01));
	vec2 v10 = vec2(cos(a10), sin(a10));
	vec2 v11 = vec2(cos(a11), sin(a11));
	float p00 = dot(v00, f);
	float p01 = dot(v01, f - vec2(0.0, 1.0));
	float p10 = dot(v10, f - vec2(1.0, 0.0));
	float p11 = dot(v11, f - vec2(1.0, 1.0));
	vec2 t =  f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
	return 0.5 + mix(mix(p00, p10, t.x), mix(p01, p11, t.x), t.y);
}
float fbm_2d_perlin(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = perlin_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float perlinabs_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	return abs(2.0*perlin_noise_2d(coord, size, offset, seed)-1.0);
}
float fbm_2d_perlinabs(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = perlinabs_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float fbm_2d_mod289(float x) {
	return x - floor(x * (1.0 / 289.0)) * 289.0;
}
float fbm_2d_permute(float x) {
	return fbm_2d_mod289(((x * 34.0) + 1.0) * x);
}
vec2 fbm_2d_rgrad2(vec2 p, float rot, float seed) {
	float u = fbm_2d_permute(fbm_2d_permute(p.x) + p.y) * 0.0243902439 + rot; // Rotate by shift
	u = fract(u+seed) * 6.28318530718; // 2*pi
	return vec2(cos(u), sin(u));
}
float simplex_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	coord *= 2.0; // needed for it to tile
	coord += rand2(vec2(seed, 1.0-seed)) + size;
	size *= 2.0; // needed for it to tile
	coord.y += 0.001;
	vec2 uv = vec2(coord.x + coord.y*0.5, coord.y);
	vec2 i0 = floor(uv);
	vec2 f0 = fract(uv);
	vec2 i1 = (f0.x > f0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	vec2 p0 = vec2(i0.x - i0.y * 0.5, i0.y);
	vec2 p1 = vec2(p0.x + i1.x - i1.y * 0.5, p0.y + i1.y);
	vec2 p2 = vec2(p0.x + 0.5, p0.y + 1.0);
	i1 = i0 + i1;
	vec2 i2 = i0 + vec2(1.0, 1.0);
	vec2 d0 = coord - p0;
	vec2 d1 = coord - p1;
	vec2 d2 = coord - p2;
	vec3 xw = mod(vec3(p0.x, p1.x, p2.x), size.x);
	vec3 yw = mod(vec3(p0.y, p1.y, p2.y), size.y);
	vec3 iuw = xw + 0.5 * yw;
	vec3 ivw = yw;
	vec2 g0 = fbm_2d_rgrad2(vec2(iuw.x, ivw.x), offset, seed);
	vec2 g1 = fbm_2d_rgrad2(vec2(iuw.y, ivw.y), offset, seed);
	vec2 g2 = fbm_2d_rgrad2(vec2(iuw.z, ivw.z), offset, seed);
	vec3 w = vec3(dot(g0, d0), dot(g1, d1), dot(g2, d2));
	vec3 t = 0.8 - vec3(dot(d0, d0), dot(d1, d1), dot(d2, d2));
	t = max(t, vec3(0.0));
	vec3 t2 = t * t;
	vec3 t4 = t2 * t2;
	float n = dot(t4, w);
	return 0.5 + 5.5 * n;
}
float fbm_2d_simplex(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = simplex_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node =  0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718 * node);
			vec2 diff = neighbor + node - f;
			float dist = length(diff);
			min_dist = min(min_dist, dist);
		}
	}
	return min_dist;
}
float fbm_2d_cellular(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular2_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist1 = 2.0;
	float min_dist2 = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = length(diff);
			if (min_dist1 > dist) {
				min_dist2 = min_dist1;
				min_dist1 = dist;
			} else if (min_dist2 > dist) {
				min_dist2 = dist;
			}
		}
	}
	return min_dist2-min_dist1;
}
float fbm_2d_cellular2(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular2_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular3_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = abs((diff).x) + abs((diff).y);
			min_dist = min(min_dist, dist);
		}
	}
	return min_dist;
}
float fbm_2d_cellular3(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular3_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular4_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist1 = 2.0;
	float min_dist2 = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = abs((diff).x) + abs((diff).y);
			if (min_dist1 > dist) {
				min_dist2 = min_dist1;
				min_dist1 = dist;
			} else if (min_dist2 > dist) {
				min_dist2 = dist;
			}
		}
	}
	return min_dist2-min_dist1;
}
float fbm_2d_cellular4(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular4_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular5_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.5 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = max(abs((diff).x), abs((diff).y));
			min_dist = min(min_dist, dist);
		}
	}
	return min_dist;
}
float fbm_2d_cellular5(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular5_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
float cellular6_noise_2d(vec2 coord, vec2 size, float offset, float seed) {
	vec2 o = floor(coord)+rand2(vec2(seed, 1.0-seed))+size;
	vec2 f = fract(coord);
	float min_dist1 = 2.0;
	float min_dist2 = 2.0;
	for(float x = -1.0; x <= 1.0; x++) {
		for(float y = -1.0; y <= 1.0; y++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 node = rand2(mod(o + vec2(x, y), size)) + vec2(x, y);
			node = 0.5 + 0.25 * sin(offset * 6.28318530718 + 6.28318530718*node);
			vec2 diff = neighbor + node - f;
			float dist = max(abs((diff).x), abs((diff).y));
			if (min_dist1 > dist) {
				min_dist2 = min_dist1;
				min_dist1 = dist;
			} else if (min_dist2 > dist) {
				min_dist2 = dist;
			}
		}
	}
	return min_dist2-min_dist1;
}
float fbm_2d_cellular6(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = cellular6_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
// MIT License Inigo Quilez - https://www.shadertoy.com/view/Xd23Dh
float voronoise_noise_2d( vec2 coord, vec2 size, float offset, float seed) {
	vec2 i = floor(coord) + rand2(vec2(seed, 1.0-seed)) + size;
	vec2 f = fract(coord);
	
	vec2 a = vec2(0.0);
	
	for( int y=-2; y<=2; y++ ) {
		for( int x=-2; x<=2; x++ ) {
			vec2  g = vec2( float(x), float(y) );
			vec3  o = rand3( mod(i + g, size) + vec2(seed) );
			o.xy += 0.25 * sin(offset * 6.28318530718 + 6.28318530718*o.xy);
			vec2  d = g - f + o.xy;
			float w = pow( 1.0-smoothstep(0.0, 1.414, length(d)), 1.0 );
			a += vec2(o.z*w,w);
		}
	}
	
	return a.x/a.y;
}
float fbm_2d_voronoise(vec2 coord, vec2 size, int folds, int octaves, float persistence, float offset, float seed) {
	float normalize_factor = 0.0;
	float value = 0.0;
	float scale = 1.0;
	for (int i = 0; i < octaves; i++) {
		float noise = voronoise_noise_2d(coord*size, size, offset, seed+float(i));
		for (int f = 0; f < folds; ++f) {
			noise = abs(2.0*noise-1.0);
		}
		value += noise * scale;
		normalize_factor += scale;
		size *= 2.0;
		scale *= persistence;
	}
	return value / normalize_factor;
}
// #globals: custom_uv
vec2 get_from_tileset(float count, float seed, vec2 uv) {
	return clamp((uv+floor(rand2(vec2(seed))*count))/count, vec2(0.0), vec2(1.0));
}
vec2 custom_uv_transform(vec2 uv, vec2 cst_scale, float rnd_rotate, float rnd_scale, vec2 seed) {
	seed = rand2(seed);
	uv -= vec2(0.5);
	float angle = (seed.x * 2.0 - 1.0) * rnd_rotate;
	float ca = cos(angle);
	float sa = sin(angle);
	uv = vec2(ca*uv.x+sa*uv.y, -sa*uv.x+ca*uv.y);
	uv *= (seed.y-0.5)*2.0*rnd_scale+1.0;
	uv /= cst_scale;
	uv += vec2(0.5);
	return uv;
}
// #globals: shader_2 (o333430399048)
vec4 o7780937248949_gradient_gradient_fct(float x) {
  const float p_o7780937248949_gradient_pos[3] = float[]( 0.000000000, 0.308572531, 1.000000000 );
  const vec4 p_o7780937248949_gradient_col[3] = vec4[]( vec4(0.000000000, 0.000000000, 0.000000000, 1.000000000), vec4(0.732421875, 0.111579895, 0.000000000, 1.000000000), vec4(0.578125000, 0.578125000, 0.578125000, 1.000000000) );
  if (x < p_o7780937248949_gradient_pos[0]) {
    return p_o7780937248949_gradient_col[0];
  } else if (x < p_o7780937248949_gradient_pos[1]) {
    return mix(p_o7780937248949_gradient_col[0], p_o7780937248949_gradient_col[1], ((x-p_o7780937248949_gradient_pos[0])/(p_o7780937248949_gradient_pos[1]-p_o7780937248949_gradient_pos[0])));
  } else if (x < p_o7780937248949_gradient_pos[2]) {
    return mix(p_o7780937248949_gradient_col[1], p_o7780937248949_gradient_col[2], ((x-p_o7780937248949_gradient_pos[1])/(p_o7780937248949_gradient_pos[2]-p_o7780937248949_gradient_pos[1])));
  }
  return p_o7780937248949_gradient_col[2];
}
vec4 o325578661869_gradient_gradient_fct(float x) {
  if (x < p_o325578661869_gradient_pos[0]) {
    return p_o325578661869_gradient_col[0];
  } else if (x < p_o325578661869_gradient_pos[1]) {
    return mix(p_o325578661869_gradient_col[0], p_o325578661869_gradient_col[1], 0.5-0.5*cos(3.14159265359*(x-p_o325578661869_gradient_pos[0])/(p_o325578661869_gradient_pos[1]-p_o325578661869_gradient_pos[0])));
  }
  return p_o325578661869_gradient_col[1];
}
float o326803398674_input_in(vec2 uv, float _seed_variation_) {
// #output0: uniform_greyscale_3 (o326987948055)
float o326987948055_0_1_f = (param_rnd(0.1,0.35, (seed_o326987948055+fract(_seed_variation_))+0.500000));
// #code: remap (o327004725272)
float o327004725272_0_x = o326987948055_0_1_f*(p_o327004725272_max-p_o327004725272_min);
// #output0: remap (o327004725272)
float o327004725272_0_1_f = p_o327004725272_min+o327004725272_0_x-mod(o327004725272_0_x, max(p_o327004725272_step, 0.00000001));
// #code: gradient (o325578661869)
float o325578661869_0_r = 0.5+(cos(p_o325578661869_rotate*0.01745329251)*(((transform2(uv, vec2(p_o326971170837_translate_x*(2.0*1.0-1.0), p_o326971170837_translate_y*(2.0*1.0-1.0)), p_o326971170837_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o326971170837_scale_x*(2.0*o327004725272_0_1_f-1.0), p_o326971170837_scale_y*(2.0*o327004725272_0_1_f-1.0))))-vec2((param_rnd(-.1,.1, (seed_o325847097332+fract(_seed_variation_))+0.500000)), (param_rnd(-.4,.4, (seed_o325847097332+fract(_seed_variation_))+0.019301)))).x-0.5)+sin(p_o325578661869_rotate*0.01745329251)*(((transform2(uv, vec2(p_o326971170837_translate_x*(2.0*1.0-1.0), p_o326971170837_translate_y*(2.0*1.0-1.0)), p_o326971170837_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o326971170837_scale_x*(2.0*o327004725272_0_1_f-1.0), p_o326971170837_scale_y*(2.0*o327004725272_0_1_f-1.0))))-vec2((param_rnd(-.1,.1, (seed_o325847097332+fract(_seed_variation_))+0.500000)), (param_rnd(-.4,.4, (seed_o325847097332+fract(_seed_variation_))+0.019301)))).y-0.5))/(cos(abs(mod(p_o325578661869_rotate, 90.0)-45.0)*0.01745329251)*1.41421356237);
// #output0: gradient (o325578661869)
vec4 o325578661869_0_1_rgba = o325578661869_gradient_gradient_fct(fract(o325578661869_0_r*p_o325578661869_repeat));
// #output0: uniform_greyscale_2 (o325830320114)
float o325830320114_0_1_f = p_o325830320114_color;
// #output0: fbm3 (o325528330218)
float o325528330218_0_1_f = fbm_2d_value((scale((((transform2(uv, vec2(p_o326971170837_translate_x*(2.0*1.0-1.0), p_o326971170837_translate_y*(2.0*1.0-1.0)), p_o326971170837_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o326971170837_scale_x*(2.0*o327004725272_0_1_f-1.0), p_o326971170837_scale_y*(2.0*o327004725272_0_1_f-1.0))))-vec2((param_rnd(-.1,.1, (seed_o325847097332+fract(_seed_variation_))+0.500000)), (param_rnd(-.4,.4, (seed_o325847097332+fract(_seed_variation_))+0.019301))))-vec2((-elapsed_time+param_rnd(-1.0,1.0, (seed_o325545107435+fract(_seed_variation_))+0.828493)), p_o325545107435_translate_y)), vec2(0.5+p_o326786621455_cx, 0.5+p_o326786621455_cy), vec2(p_o326786621455_scale_x, p_o326786621455_scale_y))), vec2(p_o325528330218_scale_x, p_o325528330218_scale_y), int(p_o325528330218_folds), int(p_o325528330218_iterations), p_o325528330218_persistence, p_o325528330218_offset, (seed_o325528330218+fract(_seed_variation_)));
// #output0: scale (o326786621455)
vec4 o326786621455_0_1_rgba = vec4(vec3(o325528330218_0_1_f), 1.0);
// #output0: translate (o325545107435)
vec4 o325545107435_0_1_rgba = o326786621455_0_1_rgba;
// #code: blend2_2 (o325813542899)
vec4 o325813542899_0_b = o325545107435_0_1_rgba;
vec4 o325813542899_0_l;
float o325813542899_0_a;
o325813542899_0_l = vec4(vec3(o325830320114_0_1_f), 1.0);
o325813542899_0_a = p_o325813542899_amount1*1.0;
o325813542899_0_b = vec4(blend_normal(((transform2(uv, vec2(p_o326971170837_translate_x*(2.0*1.0-1.0), p_o326971170837_translate_y*(2.0*1.0-1.0)), p_o326971170837_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o326971170837_scale_x*(2.0*o327004725272_0_1_f-1.0), p_o326971170837_scale_y*(2.0*o327004725272_0_1_f-1.0))))-vec2((param_rnd(-.1,.1, (seed_o325847097332+fract(_seed_variation_))+0.500000)), (param_rnd(-.4,.4, (seed_o325847097332+fract(_seed_variation_))+0.019301)))), o325813542899_0_l.rgb, o325813542899_0_b.rgb, o325813542899_0_a*o325813542899_0_l.a), min(1.0, o325813542899_0_b.a+o325813542899_0_a*o325813542899_0_l.a));
// #output0: blend2_2 (o325813542899)
vec4 o325813542899_0_1_rgba = o325813542899_0_b;
// #code: blend2 (o325796765681)
vec4 o325796765681_0_b = o325545107435_0_1_rgba;
vec4 o325796765681_0_l;
float o325796765681_0_a;
o325796765681_0_l = o325813542899_0_1_rgba;
o325796765681_0_a = p_o325796765681_amount1*(dot((o325578661869_0_1_rgba).rgb, vec3(1.0))/3.0);
o325796765681_0_b = vec4(blend_normal(((transform2(uv, vec2(p_o326971170837_translate_x*(2.0*1.0-1.0), p_o326971170837_translate_y*(2.0*1.0-1.0)), p_o326971170837_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o326971170837_scale_x*(2.0*o327004725272_0_1_f-1.0), p_o326971170837_scale_y*(2.0*o327004725272_0_1_f-1.0))))-vec2((param_rnd(-.1,.1, (seed_o325847097332+fract(_seed_variation_))+0.500000)), (param_rnd(-.4,.4, (seed_o325847097332+fract(_seed_variation_))+0.019301)))), o325796765681_0_l.rgb, o325796765681_0_b.rgb, o325796765681_0_a*o325796765681_0_l.a), min(1.0, o325796765681_0_b.a+o325796765681_0_a*o325796765681_0_l.a));
// #output0: blend2 (o325796765681)
vec4 o325796765681_0_1_rgba = o325796765681_0_b;
float o333547839572_0 = textureLod(texture_1, fract((transform2_clamp(transform2(((transform2(uv, vec2(p_o326971170837_translate_x*(2.0*1.0-1.0), p_o326971170837_translate_y*(2.0*1.0-1.0)), p_o326971170837_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o326971170837_scale_x*(2.0*o327004725272_0_1_f-1.0), p_o326971170837_scale_y*(2.0*o327004725272_0_1_f-1.0))))-vec2((param_rnd(-.1,.1, (seed_o325847097332+fract(_seed_variation_))+0.500000)), (param_rnd(-.4,.4, (seed_o325847097332+fract(_seed_variation_))+0.019301)))), vec2(p_o325561884652_translate_x*(2.0*1.0-1.0), (param_rnd(0.08,0.1, (seed_o325561884652+fract(_seed_variation_))+0.019301))*(2.0*(dot((o325796765681_0_1_rgba).rgb, vec3(1.0))/3.0)-1.0)), p_o325561884652_rotate*0.01745329251*(2.0*1.0-1.0), vec2(p_o325561884652_scale_x*(2.0*1.0-1.0), p_o325561884652_scale_y*(2.0*1.0-1.0)))))), 0.0).r;
// #output0: transform2_2 (o325561884652)
vec4 o325561884652_0_1_rgba = vec4(vec3(o333547839572_0), 1.0);
// #output0: translate_2 (o325847097332)
vec4 o325847097332_0_1_rgba = o325561884652_0_1_rgba;
// #output0: transform2_3 (o326971170837)
vec4 o326971170837_0_1_rgba = o325847097332_0_1_rgba;
return (dot((o326971170837_0_1_rgba).rgb, vec3(1.0))/3.0);
}
// #instance: circle_splatter_2 (o326803398674)
vec4 splatter_o326803398674(vec2 uv, int count, int rings, inout vec3 instance_uv, vec2 seed, float _seed_variation_) {
	float c = 0.0;
	vec3 rc = vec3(0.0);
	vec3 rc1;
	seed = rand2(seed);
	for (int i = 0; i < count; ++i) {
		float a = -1.57079632679+6.28318530718*float(i)*p_o326803398674_rings/float(count);
		float rings_distance = ceil(float(i+1)*float(rings)/float(count))/float(rings);
		float spiral_distance = float(i+1)/float(count);
		vec2 pos = (param_rnd(0.2,0.4, (seed_o326803398674+fract(_seed_variation_))+0.051036))*mix(rings_distance, spiral_distance, p_o326803398674_spiral)*vec2(cos(a), sin(a));
		float mask = 1.0;
		if (mask > 0.01) {
			vec2 pv = uv-0.5-pos;
			rc1 = rand3(seed);
			seed = rand2(seed);
			float angle = (seed.x * 2.0 - 1.0) * p_o326803398674_rotate * 0.01745329251 + (a+1.57079632679) * p_o326803398674_i_rotate;
			float ca = cos(angle);
			float sa = sin(angle);
			pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);
			pv /= mix(1.0, float(i+1)/float(count+1), p_o326803398674_i_scale);
			pv /= vec2(p_o326803398674_scale_x, p_o326803398674_scale_y);
			pv *= (seed.y-0.5)*2.0*p_o326803398674_scale+1.0;
			pv += vec2(0.5);
			seed = rand2(seed);
			vec2 test_value = clamp(pv, vec2(0.0), vec2(1.0));
			if (pv.x != test_value.x || pv.y != test_value.y) {
				continue;
			}
			vec2 full_uv = pv;
			pv = get_from_tileset( 1.0, seed.x, pv);
			float c1 = o326803398674_input_in(pv, true ? seed.x : 0.0)*mask*(1.0-p_o326803398674_value*seed.x);
			c = max(c, c1);
			rc = mix(rc, rc1, step(c, c1));
			instance_uv = mix(instance_uv, vec3(full_uv, seed.x), step(c, c1));
		}
	}
	return vec4(rc, c);
}
float o326887284755_input_in(vec2 uv, float _seed_variation_) {
// #code: rotate_3 (o326870507540)
vec2 o326870507540_0_c = vec2(0.5+p_o326870507540_cx, 0.5+p_o326870507540_cy);
// #code: circle_splatter_2 (o326803398674)
vec3 o326803398674_0_instance_uv = vec3(0.0);
vec4 o326803398674_0_rch = splatter_o326803398674((rotate(uv-o326870507540_0_c, (elapsed_time*param_rnd(10.0,25.0, (seed_o326870507540+fract(_seed_variation_))+0.872557))*0.01745329251)+o326870507540_0_c), int(p_o326803398674_count), int(p_o326803398674_rings), o326803398674_0_instance_uv, vec2(float((seed_o326803398674+fract(_seed_variation_)))), _seed_variation_);
// #output0: circle_splatter_2 (o326803398674)
float o326803398674_0_1_f = o326803398674_0_rch.a;
// #output0: rotate_3 (o326870507540)
vec4 o326870507540_0_1_rgba = vec4(vec3(o326803398674_0_1_f), 1.0);
return (dot((o326870507540_0_1_rgba).rgb, vec3(1.0))/3.0);
}
// #instance: circle_splatter_3 (o326887284755)
vec4 splatter_o326887284755(vec2 uv, int count, int rings, inout vec3 instance_uv, vec2 seed, float _seed_variation_) {
	float c = 0.0;
	vec3 rc = vec3(0.0);
	vec3 rc1;
	seed = rand2(seed);
	for (int i = 0; i < count; ++i) {
		float a = -1.57079632679+6.28318530718*float(i)*p_o326887284755_rings/float(count);
		float rings_distance = ceil(float(i+1)*float(rings)/float(count))/float(rings);
		float spiral_distance = float(i+1)/float(count);
		vec2 pos = p_o326887284755_radius*mix(rings_distance, spiral_distance, p_o326887284755_spiral)*vec2(cos(a), sin(a));
		float mask = 1.0;
		if (mask > 0.01) {
			vec2 pv = uv-0.5-pos;
			rc1 = rand3(seed);
			seed = rand2(seed);
			float angle = (seed.x * 2.0 - 1.0) * p_o326887284755_rotate * 0.01745329251 + (a+1.57079632679) * p_o326887284755_i_rotate;
			float ca = cos(angle);
			float sa = sin(angle);
			pv = vec2(ca*pv.x+sa*pv.y, -sa*pv.x+ca*pv.y);
			pv /= mix(1.0, float(i+1)/float(count+1), p_o326887284755_i_scale);
			pv /= vec2(p_o326887284755_scale_x, p_o326887284755_scale_y);
			pv *= (seed.y-0.5)*2.0*p_o326887284755_scale+1.0;
			pv += vec2(0.5);
			seed = rand2(seed);
			vec2 test_value = clamp(pv, vec2(0.0), vec2(1.0));
			if (pv.x != test_value.x || pv.y != test_value.y) {
				continue;
			}
			vec2 full_uv = pv;
			pv = get_from_tileset( 1.0, seed.x, pv);
			float c1 = o326887284755_input_in(pv, true ? seed.x : 0.0)*mask*(1.0-p_o326887284755_value*seed.x);
			c = max(c, c1);
			rc = mix(rc, rc1, step(c, c1));
			instance_uv = mix(instance_uv, vec3(full_uv, seed.x), step(c, c1));
		}
	}
	return vec4(rc, c);
}
void fragment() {
	float _seed_variation_ = variation;
	vec2 uv = fract(UV);

// #output0: uniform_greyscale (o326954393622)
float o326954393622_0_1_f = (length((scale((uv), vec2(0.5+p_o333447176263_cx, 0.5+p_o333447176263_cy), vec2(p_o333447176263_scale_x, p_o333447176263_scale_y)))-0.5));

// #output0: shader_1 (o333413621834)
vec4 o333413621834_0_1_rgba = o1448108629132_gradient_gradient_fct(o326954393622_0_1_f);

// #code: circle_splatter_3 (o326887284755)
vec3 o326887284755_0_instance_uv = vec3(0.0);
vec4 o326887284755_0_rch = splatter_o326887284755((scale((uv), vec2(0.5+p_o333447176263_cx, 0.5+p_o333447176263_cy), vec2(p_o333447176263_scale_x, p_o333447176263_scale_y))), int(p_o326887284755_count), int(p_o326887284755_rings), o326887284755_0_instance_uv, vec2(float((seed_o326887284755+fract(_seed_variation_)))), _seed_variation_);
// #output0: circle_splatter_3 (o326887284755)
float o326887284755_0_1_f = o326887284755_0_rch.a;

// #output1: circle_splatter_3 (o326887284755)
vec3 o326887284755_1_2_rgb = o326887284755_0_rch.rgb;

// #output0: shader_2 (o333430399048)
vec4 o333430399048_0_1_rgba = o7780937248949_gradient_gradient_fct((dot(o326887284755_1_2_rgb, vec3(1.0))/3.0));

// #code: blend2_7 (o326753067022)
vec4 o326753067022_0_b = o333430399048_0_1_rgba;
vec4 o326753067022_0_l;
float o326753067022_0_a;

o326753067022_0_l = o333430399048_0_1_rgba;
o326753067022_0_a = p_o326753067022_amount1*1.0;
o326753067022_0_b = vec4(blend_additive((scale((uv), vec2(0.5+p_o333447176263_cx, 0.5+p_o333447176263_cy), vec2(p_o333447176263_scale_x, p_o333447176263_scale_y))), o326753067022_0_l.rgb, o326753067022_0_b.rgb, o326753067022_0_a*o326753067022_0_l.a), min(1.0, o326753067022_0_b.a+o326753067022_0_a*o326753067022_0_l.a));

o326753067022_0_l = vec4(vec3(o326887284755_0_1_f), 1.0);
o326753067022_0_a = p_o326753067022_amount2*1.0;
o326753067022_0_b = vec4(blend_multiply((scale((uv), vec2(0.5+p_o333447176263_cx, 0.5+p_o333447176263_cy), vec2(p_o333447176263_scale_x, p_o333447176263_scale_y))), o326753067022_0_l.rgb, o326753067022_0_b.rgb, o326753067022_0_a*o326753067022_0_l.a), min(1.0, o326753067022_0_b.a+o326753067022_0_a*o326753067022_0_l.a));
// #output0: blend2_7 (o326753067022)
vec4 o326753067022_0_1_rgba = o326753067022_0_b;

// #code: blend2_4 (o326769844240)
vec4 o326769844240_0_b = o326753067022_0_1_rgba;
vec4 o326769844240_0_l;
float o326769844240_0_a;

o326769844240_0_l = o326753067022_0_1_rgba;
o326769844240_0_a = p_o326769844240_amount1*1.0;
o326769844240_0_b = vec4(blend_screen((scale((uv), vec2(0.5+p_o333447176263_cx, 0.5+p_o333447176263_cy), vec2(p_o333447176263_scale_x, p_o333447176263_scale_y))), o326769844240_0_l.rgb, o326769844240_0_b.rgb, o326769844240_0_a*o326769844240_0_l.a), min(1.0, o326769844240_0_b.a+o326769844240_0_a*o326769844240_0_l.a));

o326769844240_0_l = o333413621834_0_1_rgba;
o326769844240_0_a = p_o326769844240_amount2*1.0;
o326769844240_0_b = vec4(blend_additive((scale((uv), vec2(0.5+p_o333447176263_cx, 0.5+p_o333447176263_cy), vec2(p_o333447176263_scale_x, p_o333447176263_scale_y))), o326769844240_0_l.rgb, o326769844240_0_b.rgb, o326769844240_0_a*o326769844240_0_l.a), min(1.0, o326769844240_0_b.a+o326769844240_0_a*o326769844240_0_l.a));
// #output0: blend2_4 (o326769844240)
vec4 o326769844240_0_1_rgba = o326769844240_0_b;

// #output0: scale_2 (o333447176263)
vec4 o333447176263_0_1_rgba = o326769844240_0_1_rgba;

	vec4 color_tex = o333447176263_0_1_rgba;
	color_tex = mix(pow((color_tex + vec4(0.055)) * (1.0 / (1.0 + 0.055)),vec4(2.4)),color_tex * (1.0 / 12.92),lessThan(color_tex,vec4(0.04045)));
	ALBEDO = color_tex.rgb;
	ALPHA = color_tex.a;
}



