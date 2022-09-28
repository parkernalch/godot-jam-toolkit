using Godot;
using System;

public class HitDealer : Node2D
{
	private HitBox _hitBox;
	private Sprite _sprite;
	private Color _redColor;
	private Color _greenColor;
	
	public override void _Ready()
	{
		_hitBox = GetNode<HitBox>("HitBox");
		_hitBox.Deactivate();
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
				_hitBox.Activate();
				_sprite.SelfModulate = _greenColor;
				
			} else {
				_hitBox.Deactivate();
				_sprite.SelfModulate = _redColor;
			}
		}
	}
}
