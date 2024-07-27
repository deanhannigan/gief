# gief
Item shopping list commands

### WoW Release Target
2.4.3

### Installation
- Download the [latest](https://github.com/deanhannigan/gief/releases/latest/download/gief.zip)
- Copy the release to `{Your WoW Root}\Interface\AddOns`
- Extract to the release contents to `\gief` and you should get the following `{Your WoW Root}\Interface\AddOns\gief`

### Show all
List all items currently in your shopping list
```lua
\gief
```

### Add to list
Shift-click one or more items. Adds all items to your shopping list
```lua
\gief [Elixir of Draenic Wisdom]
```

### Announce shopping list to Party
Emit all items currently in your shopping list to party chat.
```lua
\gief p
```

### Delete from list
Shift-click one or more items. Will remove all linked items from your shopping list
```lua
\gief d [Elixir of Draenic Wisdom]
```
