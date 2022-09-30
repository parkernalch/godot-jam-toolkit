using Godot;
using System;

public class HitDealer : Node2D
{
	private HurtBox _hurtBox;
	private Sprite _sprite;
	private Color _redColor;
	private Color _greenColor;
	
	public override void _Ready()
	{
		_hurtBox = GetNode<HurtBox>("HurtBox");
		_hurtBox.Deactivate();
		_sprite = GetNode<Sprite>("Sprite");
		_redColor = new Color("#FF0000");
		_greenColor = new Color("#00FF00");
	}
	
	public override void _Process(float delta)
	{
		this.GlobalPosition = GetGlobalMousePosition();
	}
	
	public override void _Input(InputEvent inputEvent) {
		InputEventMouseButton buttonEvent = inputEvent as InputEventMouseButton;
		if (buttonEvent != null)
		{
			if (buttonEvent.Pressed) {
				_hurtBox.Activate();
				_sprite.SelfModulate = _greenColor;
				
			} else {
				_hurtBox.Deactivate();
				_sprite.SelfModulate = _redColor;
			}
		}
	}
}
