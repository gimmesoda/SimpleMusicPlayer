import h3d.shader.ScreenShader;

/** I don't remember where this shader's from, but it's not mine!! **/
class BackgroundShader extends ScreenShader {
	private static final SRC = {
		@param var texture:Sampler2D;
		@global var time:Float;

		function gradient(p:Float):Float {
			var pt0:Vec2 = vec2(0.000, 0.0);
			var pt1:Vec2 = vec2(0.860, 0.1);
			var pt2:Vec2 = vec2(0.955, 0.4);
			var pt3:Vec2 = vec2(0.990, 1.0);
			var pt4:Vec2 = vec2(1.000, 0.0);

			if (p < pt0.x) return pt0.y;
			else if (p < pt1.x) return mix(pt0.y, pt1.y, (p - pt0.x) / (pt1.x - pt0.x));
			else if (p < pt2.x) return mix(pt1.y, pt2.y, (p - pt1.x) / (pt2.x - pt1.x));
			else if (p < pt3.x) return mix(pt2.y, pt3.y, (p - pt2.x) / (pt3.x - pt2.x));
			else return mix(pt3.y, pt4.y, (p - pt3.x) / (pt4.x - pt3.x));
		}

		function waveN(uv:Vec2, s12:Vec2, t12:Vec2, f12:Vec2, h12:Vec2):Float {
			var x12:Vec2 = sin((time * s12 + t12 + uv.x) * f12) * h12;
			var g:Float = gradient(uv.y / (0.5 + x12.x + x12.y));
			return g * 0.27;
		}

		function wave1(uv:Vec2):Float {
			return waveN(vec2(uv.x, uv.y - 0.25), vec2(0.03, 0.06), vec2(0.0, 0.02), vec2(8.0, 3.7), vec2(0.06, 0.05));
		}

		function wave2(uv:Vec2):Float {
			return waveN(vec2(uv.x,uv.y-0.25), vec2(0.04,0.07), vec2(0.16,-0.37), vec2(6.7,2.89), vec2(0.06,0.05));
		}

		function wave3(uv:Vec2):Float {
			return waveN(vec2(uv.x,0.75-uv.y), vec2(0.035,0.055), vec2(-0.09,0.27), vec2(7.4,2.51), vec2(0.06,0.05));
		}

		function wave4(uv:Vec2):Float {
			return waveN(vec2(uv.x,0.75-uv.y), vec2(0.032,0.09), vec2(0.08,-0.22), vec2(6.5,3.89), vec2(0.06,0.05));
		}

		function fragment() {
			var uv:Vec2 = calculatedUV;

			var waves:Float = wave1(uv) + wave2(uv) + wave3(uv) + wave4(uv);

			var x:Float = uv.x;
			var y:Float = uv.y * -1.0;

			var bg:Vec3 = mix(vec3(0.05,0.05,0.3),vec3(0.1,0.65,0.85), (x+y)*0.55);
			var ac:Vec3 = bg + vec3(1.0,1.0,1.0) * waves;

			pixelColor = vec4(ac, 1.0);
		}
	}
}