using Godot;
using System;

public class HitRecipient : Node2D
{
	private Tween _tween;
	private HitBox _hitBox;
	private Sprite _sprite;
	private Color _redColor;
	private Color _whiteColor;
	
	public override void _Ready()
	{
		_redColor = new Color("#FF0000");
		_whiteColor = new Color("#FFFFFF");
		_sprite = (Sprite)GetNode("Sprite");
		_hitBox = (HitBox)GetNode("HitBox");
		_hitBox.Connect("GotHit", this, "_OnGotHit");
		_tween = new Tween();
		AddChild(_tween);        
	}
	
	private void _OnGotHit(Area2D source)
	{
		_tween.InterpolateProperty(
			this,
			"rotation",
			0,
			3.14f / 4f,
			0.2f,
			Tween.TransitionType.Back,
			Tween.EaseType.Out
		);
		_tween.InterpolateProperty(
			this,
			"rotation",
			3.14f / 4f,
			0,
			0.2f,
			Tween.TransitionType.Back,
			Tween.EaseType.Out,
			0.2f
		);
		_tween.Start();
	}
	
	
}
