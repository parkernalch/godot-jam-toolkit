using Godot;
using System;

public class TestHealthBar : Node
{
    private HealthBar _healthBar;

    public override void _Ready()
    {
        _healthBar = (HealthBar)GetNode("health_bar");
    }


    public override void _Process(float delta)
    {
        if (Input.IsActionJustPressed("move_right"))
        {
            _healthBar.Heal(0.1f);
        }
        else if (Input.IsActionJustPressed("move_left"))
        {
            _healthBar.Damage(0.1f);
        }
    }
}
