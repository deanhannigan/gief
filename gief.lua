if not shopping_list then shopping_list = {} end

local player = {}
local faction_lookup = {
  Alliance = 1,
  Horde = 2
}

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local getPlayerFaction = function()
  local englishFaction = UnitFactionGroup("player")
  return faction_lookup[englishFaction]
end

local init_player = function()
  player['faction'] = getPlayerFaction()
end

function frame:OnEvent(event, arg1)
  if event == "ADDON_LOADED" and arg1 == "gief" then
    DEFAULT_CHAT_FRAME:AddMessage("gief loaded")
  end
  if event == "PLAYER_ENTERING_WORLD" then
    init_player()
  end
end

frame:SetScript("OnEvent", frame.OnEvent)

local function isMember(set, element)
  return set[element] ~= nil
end

local function countItems(itemList)
  local count = 0
  for _, item in ipairs(itemList) do
      count = count + 1
  end
  return count
end

local function listToString()
  local result = ""
  for itemID, _ in pairs(shopping_list) do
    local itemName, itemLink = GetItemInfo(itemID)
    result = result .. itemLink
  end
  return result
end

function addToList(items)
  if items == nil or next(items) == nil then 
    DEFAULT_CHAT_FRAME:AddMessage("No items")
    return
  end

  local size = countItems(items)
  DEFAULT_CHAT_FRAME:AddMessage("Processing Items " .. size)

  for _, itemLink in ipairs(items) do
    local itemName = GetItemInfo(itemLink)
    if itemName ~= nil then
      DEFAULT_CHAT_FRAME:AddMessage("Adding " .. itemName)
      local _, _, Color, Ltype, Id, Enchant = string.find(itemLink,"|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):")
      if not isMember(shopping_list, Id) then
        shopping_list[Id] = true
      end
    else
      DEFAULT_CHAT_FRAME:AddMessage("Failed to parse " .. itemLink)
    end
  end
end

function removeFromList(items)
  if items == nil or next(items) == nil then 
    DEFAULT_CHAT_FRAME:AddMessage("No items")
    return
  end

  local size = countItems(items)
  DEFAULT_CHAT_FRAME:AddMessage("Processing Items " .. size)
  for _, itemLink in ipairs(items) do
    local _, _, _, _, Id = string.find(itemLink,"|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):")
    shopping_list[Id] = nil
    DEFAULT_CHAT_FRAME:AddMessage(itemLink .. " Removed")
  end
end

function findLinks(msg)
  local itemLinks = {}
  local pattern = "(|c%x+|Hitem:%d+[^|]*|h%[.-%]|h|r)"

  for itemLink in string.gmatch(msg, pattern) do
      DEFAULT_CHAT_FRAME:AddMessage("match " .. itemLink)
      table.insert(itemLinks, itemLink)
  end
  return itemLinks
end

SLASH_GIEF1 = '/gief';
function SlashCmdList.GIEF(msg, editbox)
  local cmd_chunks = {}
  for substring in msg:gmatch("%S+") do
    table.insert(cmd_chunks, substring)
  end

  if cmd_chunks[1] == "d" then
    local links = findLinks(msg)
    removeFromList(links)
    return
  end

  if cmd_chunks[1] == "p" then
    local partyMembers = GetNumPartyMembers()
    if partyMembers > 0 then
      SendChatMessage(listToString(), "PARTY")
    else 
      DEFAULT_CHAT_FRAME:AddMessage("You are not in a party")
    end
    return
  end

  -- Add any supplied links to the list 
  local links = findLinks(msg)
  if #links > 0 then
    addToList(links)
    return
  end

  DEFAULT_CHAT_FRAME:AddMessage("Gief " .. listToString())

end
