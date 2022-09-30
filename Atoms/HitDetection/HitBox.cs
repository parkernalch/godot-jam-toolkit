using Godot;
using System;

// Attach HitBox to any Node2D that can take damage
public class HitBox : Area2D
{
	[Signal]public delegate void GotHit(HurtBox source);
	
	public override void _Ready()
	{
		Activate();
	}
	
	private void _OnAreaEntered(HurtBox hurtBox)
	{
		if (hurtBox == null || !hurtBox.isActive)
		{
			return;
		}
		EmitSignal("GotHit", hurtBox);
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
