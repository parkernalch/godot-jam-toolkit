using Godot;
using System;

public class HurtBox : Area2D
{
	[Signal]public delegate void GotHit(HitBox source);
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Activate();
	}
	
	private void _OnAreaEntered(HitBox hitBox)
	{
		if (hitBox == null || !hitBox.isActive)
		{
			return;
		}
		EmitSignal("GotHit", hitBox);
	}
	
	public void Activate()
	{
		this.Connect("area_entered", this, "_OnAreaEntered");		
	}
	
	public void Deactivate()
	{
		this.Disconnect("area_entered", this, "_OnAreaEntered");		
	}

}
