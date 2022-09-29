using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text.Json;
using Godot;
using JamToolkit.Util;

[SuppressMessage("ReSharper", "CheckNamespace")]
public class InventoryPlayerData : Node
{
    private List<string> _itemIds;
    [Export] public string InventoryDataFile { get; set; }

    public string[] ItemIds => _itemIds.ToArray();

    public bool IsInitialized => ItemIds != null;

    public override void _EnterTree()
    {
        Assert.NotNull(InventoryDataFile, "PlayerInventoryData file is null");
        var data = Files.ReadAllText(InventoryDataFile);
        _itemIds = JsonSerializer.Deserialize<List<string>>(data);
        Assert.NotNull(_itemIds, "InventoryPlayerData file was not in the correct format");
    }

}
