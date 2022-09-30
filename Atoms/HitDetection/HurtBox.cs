using Godot;
using System;

// Attach to a Node2D that can deal damage
public class HurtBox : Area2D
{
	public bool isActive;
	public int damage;

	public override void _Ready()
	{
		Activate();
	}
	
	public void Activate()
	{
		isActive = true;
	}
	
	public void Deactivate()
	{
		isActive = false;
	}
}
