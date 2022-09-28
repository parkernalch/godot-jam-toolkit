using Godot;
using System;

public class HitBox : Area2D
{
	public bool isActive;

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
