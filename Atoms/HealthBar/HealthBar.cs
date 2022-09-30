using Godot;
using System;

public class HealthBar : ColorRect
{
	[Export] public Color BarColor = Colors.DarkGray;

	[Export] public GradientTexture BarGradient;

	[Export] public Color BufferColor = Colors.White;

	[Export] public float BufferLagTime = 1.0f;

	[Export] public Orientation Orientation;

	private float _fill = 1.0f;
	private Tween _tween;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

		_tween = (Tween)GetNode("Tween");
		ShaderMaterial.SetShaderParam("color_gradient", BarGradient);
		ShaderMaterial.SetShaderParam("unfilled_color", BarColor);
		ShaderMaterial.SetShaderParam("buffer_color", BufferColor);
		ShaderMaterial.SetShaderParam("is_horizontal", Orientation == Orientation.Horizontal);
		BufferFill = _fill;
		BarFill = _fill;
	}

	public ShaderMaterial ShaderMaterial => (ShaderMaterial)Material;


	float BufferFill
	{
		get => (float)ShaderMaterial.GetShaderParam("buffer_fill");
		set => ShaderMaterial.SetShaderParam("buffer_fill", value);
	}

	float BarFill
	{
		get => (float)ShaderMaterial.GetShaderParam("bar_fill");
		set => ShaderMaterial.SetShaderParam("bar_fill", value);
	}

	float Clamp(float value) => Math.Min(Math.Max(value, 0), 1);

	enum Fill
	{
		Buffer,
		Bar
	}

	/// <summary>
	/// </summary>
	/// <param name="amount"></param>
	/// <returns>Amount of damage applied</returns>

	public float Damage(float amount)
	{
		if (_fill <= 0.0)
			return 0;

		return ApplyInterpolation(_fill - amount, Fill.Buffer);
	}

	public float Heal(float amount)
	{
		if (_fill >= 1.0)
			return 0;

		return ApplyInterpolation(_fill + amount, Fill.Bar);
	}

	private float ApplyInterpolation(float newTarget, Fill fillType)
	{
		_tween.RemoveAll();

		var previous_fill = _tween.IsActive() ? BarFill : _fill;

		_fill = Clamp(newTarget);

		if (fillType == Fill.Bar)
		{
			BarFill = _fill;
		}
		else
		{
			BufferFill = _fill;
		}

		_tween.InterpolateProperty(
			ShaderMaterial,
			fillType == Fill.Bar ? "shader_param/buffer_fill": "shader_param/bar_fill",
			previous_fill,
			_fill,
			BufferLagTime,
			Tween.TransitionType.Sine,
			Tween.EaseType.Out
		);
		_tween.Start();

		return _fill;
	}
}
