using System.Collections.Generic;
using Godot;
using System.Diagnostics.CodeAnalysis;
using System.Text.Json;
using JamToolkit.Util;

[SuppressMessage("ReSharper", "CheckNamespace")]
public class InventoryGameData : Node
{
    [Export] public string InventoryDataFile { get; set; }

    private Dictionary<string, ItemData> _items;
    public bool IsInitialized => _items != null;

    public override void _EnterTree()
    {
        Assert.NotNull(InventoryDataFile, "InventoryGameData file is null");
        var data = Files.ReadAllText(InventoryDataFile);
        _items = JsonSerializer.Deserialize<Dictionary<string, ItemData>>(data);
        Assert.NotNull(_items, "InventoryGameData file was not in the correct format");
    }

    public ItemData GetItem(string itemId)
    {
        if (!_items.TryGetValue(itemId, out var itemData))
        {
            Assert.Fail($"Invalid item id: {itemId}");
        }

        return itemData;
    }
}
