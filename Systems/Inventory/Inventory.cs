using Godot;
using System;
using JamToolkit.Util;

public class Inventory : Control
{
    private GridContainer _container;

    private PackedScene _inventorySlot;

    public override void _Ready()
    {
	    _inventorySlot = this.LoadRelative<PackedScene>("InventorySlot.tscn");
        _container = this.FindChildByName<GridContainer>("GridContainer");
        var gameInventory = this.FindSingleton<InventoryGameData>();
        var playerInventory = this.FindSingleton<InventoryPlayerData>();
        Assert.True(gameInventory.IsInitialized, "InventoryPlayerData must be loaded before Inventory");
        Assert.True(playerInventory.IsInitialized, "InventoryPlayerData must be loaded before Inventory");

        foreach (var playerInventoryItemId in playerInventory.ItemIds)
        {
            var slot = _inventorySlot.Instance();
            if(playerInventoryItemId != null)
            {
	            var item = gameInventory.GetItem(playerInventoryItemId);
	            var icon = ResourceLoader.Load<Texture>(item.IconTexture);
	            slot.GetNode<TextureRect>("Icon").Texture = icon;
            }

            _container.AddChild(slot, true);
        }

    }
}
