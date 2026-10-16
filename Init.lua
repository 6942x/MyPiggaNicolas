local source = [====[
-- =========================================================
--  Regrowth Incremental Â· Auto Farm
-- =========================================================

local plr = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local env = type(getgenv) == "function" and getgenv() or shared

if not plr then
    warn("[Auto Farm] Run this script inside the game client")
    return
end

-- ===================== QUICK CONFIG ======================
-- Nomes EXATOS dos valores no Player.Stats (confirmados pelo locator):
local CURRENCY_NAMES = {
    money = "Money",
    emerald = "EmeraldCoins",
    gold = "Gold",
    goldDiamond = "GoldenDiamond",
}

-- Tree principal: upgrades comprados (nessa ordem)
local TREE_MAIN_IDS = { 1, 2, 3, 4, 5, 10, 19, 23, 26, 42, 43, 72 }
-- Gold Diamond: prioridade de compra (somente esses)
local DIAMOND_ORDER = { 10, 3, 2, 6, 14, 1, 9, 11, 15 }
-- =========================================================

local stateKey = "AutoFarm_" .. game.PlaceId .. "_" .. plr.UserId
local configFile = stateKey .. ".json"

if type(env[stateKey]) == "table" and type(env[stateKey].unload) == "function" then
    pcall(env[stateKey].unload)
end

local rt = {
    alive = true,
    connections = {},
    threads = {},
    toggles = {},
    currentOre = nil,
    session = 0,
}

env[stateKey] = {
    unload = function()
        rt.alive = false
    end,
}

local CFG = {
    autoMine = false,
    multiOres = false,
    singleOre = "Onyx",
    cycleOres = { "Coal", "Garnet", "Onyx", "Copper", "Plutonium" },
    oreSlot = 1,
    oreElapsed = 0,
    duration = 7200,

    autoUpgradeGears = false,
    autoResetNormal = false,
    autoResetShiny = false,
    minShiny = 1e6,
    minLife = 5e3,

    monsterClick = false,
    monsterReset = false,
    monsterPerks = false,
    monsterUpgrades = false,
    monsterMinimum = 1e6,

    treeMain = false,
    treeEmerald = false,
    treeGold = false,
    treeDiamond = false,
    diamondReset = false,
    diamondResetMinimum = 1e6,

    hide = false,
    hideOrePopup = false,
    key = "G",
}

local ORES = {
    Coal = { 0, 1 },
    Tin = { 0, 4 },
    Copper = { 0, 622 },
    Iron = { 325, 1 },
    Silver = { 20, 60 },
    Gold = { 20, 622 },
    Topaz = { 125, 180 },
    Sapphire = { 125, 622 },
    Ruby = { 5000, 32 },
    Emerald = { 600, 622 },
    Azurite = { 5000, 145 },
    Diamond = { 5000, 550 },
    Tanzanite = { 7500, 622 },
    Plutonium = { 7500, 205 },
    Uranium = { 27500, 1 },
    Onyx = { 52500, 30 },
    Garnet = { 27500, 622 },
    Neptunium = { 150000, 622 },
    Osmium = { 4500000, 622 },
    Mithril = { 6250000, 622 },
    Painite = { 6250000, 622 },
}

local SUFFIXES = {
    "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc",
    "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg",
}

local function formatSci(value, digits)
    local mantissa, exponent = string.format("%." .. (digits or 3) .. "e", value):match("^(.-)e([+-]?%d+)$")
    mantissa = mantissa:gsub("%.?0+$", "")
    return mantissa .. "e" .. tostring(tonumber(exponent))
end

local function formatNumber(value)
    value = tonumber(value)
    if not value or value ~= value or math.abs(value) == math.huge then
        return "-"
    end
    local sci = formatSci(value)
    local sciValue = tonumber(sci)
    local abs = math.abs(sciValue)
    local index = 1
    while abs >= 1000 and index < #SUFFIXES do
        abs = abs / 1000
        index = index + 1
    end
    local suffixed = sci
    if abs < 1000 then
        suffixed = string.format("%.3f", sciValue / 1000 ^ (index - 1)):gsub("%.?0+$", "") .. SUFFIXES[index]
        if sciValue ~= 0 and math.abs(sciValue) < 1e-3 then
            suffixed = sci
        end
    end
    return sci .. " (" .. suffixed .. ")"
end

local SUFFIX_MAP = {
    k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18,
    sx = 1e21, sp = 1e24, oc = 1e27, no = 1e30, dc = 1e33, [""] = 1,
}

local function parseNumber(value)
    local text = tostring(value):lower():gsub("%s*%([^()]*%)%s*$", ""):gsub("[%s,]", "")
    local number = tonumber(text)
    if not number then
        local digits, suffix = text:match("^([%d%.]+)(%a*)$")
        local multiplier = digits and tonumber(digits)
        local factor = suffix and SUFFIX_MAP[suffix]
        if multiplier and factor then
            number = multiplier * factor
        end
    end
    if number and number == number and number >= 0 and number < math.huge then
        return number
    end
end

local function parseTextNumber(text)
    if type(text) ~= "string" then
        return nil
    end
    text = text:gsub("<[^>]+>", ""):gsub(",", "")
    local value = parseNumber(text:gsub("^%s*%+", ""))
    if value then
        return value
    end
    local sci = text:match("[%d%.]+[eE][+%-]?%d+")
    if sci then
        return parseNumber(sci)
    end
    local digits, suffix = text:match("([%d%.]+)%s*([%a]*)")
    return digits and parseNumber(digits .. suffix) or nil
end

local ORE_NAMES = {}
for ore in pairs(ORES) do
    table.insert(ORE_NAMES, ore)
end
table.sort(ORE_NAMES)
local ORE_NAMES_SNAPSHOT = table.clone(ORE_NAMES)

local function applyConfig(config)
    if type(config) ~= "table" then
        return
    end
    for key, value in pairs(CFG) do
        if type(value) == "boolean" and type(config[key]) == "boolean" then
            CFG[key] = config[key]
        end
    end
    for _, key in ipairs({ "minShiny", "minLife", "monsterMinimum", "diamondResetMinimum" }) do
        local value = tonumber(config[key])
        if value and value > 0 and value < math.huge then
            CFG[key] = value
        end
    end
    if type(config.key) == "string" then
        local ok, keyCode = pcall(function()
            return Enum.KeyCode[config.key]
        end)
        if ok and keyCode and not table.find({ "Unknown", "K", "Escape", "F9", "F11", "F12", "PrintScreen" }, config.key) then
            CFG.key = config.key
        end
    end
    if ORES[config.singleOre] then
        CFG.singleOre = config.singleOre
    end
    if type(config.cycleOres) == "table" then
        local ores = {}
        for _, ore in ipairs(config.cycleOres) do
            if ORES[ore] and not table.find(ores, ore) then
                table.insert(ores, ore)
            end
        end
        CFG.cycleOres = ores
    end
    CFG.oreSlot = math.clamp(math.floor(parseNumber(config.oreSlot) or 1), 1, math.max(1, #CFG.cycleOres))
    CFG.duration = math.clamp(math.floor((parseNumber(config.duration) or 7200) / 600 + 0.5), 1, 24) * 600
    CFG.oreElapsed = math.clamp(parseNumber(config.oreElapsed) or 0, 0, CFG.duration)
end

if type(readfile) == "function" then
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(configFile))
    end)
    if ok then
        applyConfig(decoded)
    end
end
applyConfig(env[stateKey .. "_config"])

local function saveConfig()
    env[stateKey .. "_config"] = table.clone(CFG)
    env[stateKey .. "_config"].cycleOres = table.clone(CFG.cycleOres)
    if type(writefile) == "function" then
        pcall(function()
            writefile(configFile, HttpService:JSONEncode(CFG))
        end)
    end
end

local function track(connection)
    rt.connections[#rt.connections + 1] = connection
    return connection
end

local function spawnTask(fn)
    local thread = task.defer(function()
        if rt.alive then
            local ok, err = xpcall(fn, debug.traceback)
            if not ok and rt.alive then
                warn("[Regrowth thread error] " .. tostring(err))
            end
        end
        rt.threads[coroutine.running()] = nil
    end)
    rt.threads[thread] = true
    return thread
end

local function fireRemote(remote, ...)
    if not remote or not remote:IsA("RemoteEvent") then
        return false
    end
    local ok = pcall(remote.FireServer, remote, ...)
    return ok
end

local function findPath(root, parts)
    for _, part in ipairs(parts) do
        root = root and root:FindFirstChild(part)
    end
    return root
end

local function statValue(name)
    local stats = plr:FindFirstChild("Stats")
    local value = stats and stats:FindFirstChild(name)
    if not value then
        return nil
    end
    local ok, number = pcall(function()
        return tonumber(value.Value)
    end)
    if ok then
        return number
    end
    return nil
end

-- Anti-spam "Reached Max Upgrade": quando o servidor recusa uma compra,
-- o upgrade fica em cooldown por 30s (chave = categoria:id).
local rejectCooldown = {}
local lastFireKey, lastFireTime = nil, 0

local function noteFire(key)
    lastFireKey = key
    lastFireTime = os.clock()
end

local guardsActive = false
local settingGuard = false
local waitingForKey = false
local library
local window
local keybindButton

local function unload()
    if not rt.alive then
        return
    end
    saveConfig()
    rt.alive = false
    for _, connection in ipairs(rt.connections) do
        pcall(connection.Disconnect, connection)
    end
    for thread in pairs(rt.threads) do
        if thread ~= coroutine.running() and coroutine.status(thread) ~= "dead" then
            pcall(task.cancel, thread)
        end
    end
    table.clear(rt.connections)
    table.clear(rt.threads)
    if library and not library.Unloaded then
        pcall(library.Destroy, library)
    end
    if env[stateKey] and env[stateKey].unload == unload then
        env[stateKey] = nil
    end
end

rt.unload = unload
env[stateKey] = { unload = unload }

local function loadFluent()
    local url = "https://github.com/dawid-scripts/Fluent/releases/download/1.1.0/main.lua"
    local cacheFile = "Regrowth_Fluent_1_1_0.lua"
    local ok, content = pcall(function()
        return game:HttpGet(url)
    end)
    if not rt.alive then
        return nil
    end
    if ok and type(content) == "string" and #content > 200 then
        if type(writefile) == "function" then
            pcall(writefile, cacheFile, content)
        end
    elseif type(readfile) == "function" then
        ok, content = pcall(readfile, cacheFile)
    end
    assert(ok and type(content) == "string" and #content > 200, "Fluent unavailable: check your connection")
    local chunk, err = loadstring(content, "=Regrowth.Fluent.1.1.0")
    assert(chunk, "Failed to compile Fluent: " .. tostring(err))
    return chunk()
end

local loadOk, lib = pcall(loadFluent)

if not rt.alive then
    if loadOk and type(lib) == "table" then
        pcall(lib.Destroy, lib)
    end
    return
end

if not loadOk or type(lib) ~= "table" then
    unload()
    error("[Regrowth] " .. tostring(lib), 0)
end

library = lib

local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)

window = library:CreateWindow({
    Title = "Regrowth Incremental",
    SubTitle = "Auto Farm",
    TabWidth = 130,
    Size = UDim2.fromOffset(
        math.max(360, math.min(640, viewport.X - 24)),
        math.max(320, math.min(530, viewport.Y - 64))
    ),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = { Name = CFG.key },
})

if library.GUI then
    track(library.GUI.Destroying:Connect(unload))
end
window.Root.Visible = not CFG.hide
window.Minimized = CFG.hide

local mineTab = window:AddTab({ Title = "Mine", Icon = "hammer" })
local gearsTab = window:AddTab({ Title = "Gears", Icon = "settings-2" })
local monsterTab = window:AddTab({ Title = "Monster", Icon = "skull" })
local treeTab = window:AddTab({ Title = "Upgrade Tree", Icon = "trees" })
local settingsTab = window:AddTab({ Title = "Settings", Icon = "settings" })

-- ==================== helpers de UI ====================

local function resetOreProgress()
    CFG.oreSlot = 1
    CFG.oreElapsed = 0
    rt.currentOre = nil
    rt.session = rt.session + 1
    saveConfig()
end

local function addToggle(tab, key, title)
    local toggle = tab:AddToggle(key, {
        Title = title,
        Default = CFG[key],
        Callback = function(value)
            if not guardsActive or settingGuard or not rt.alive or CFG[key] == value then
                return
            end
            CFG[key] = value
            if key == "autoMine" then
                rt.session = rt.session + 1
            end
            if key == "multiOres" then
                resetOreProgress()
            else
                saveConfig()
            end
        end,
    })
    rt.toggles[key] = toggle
    return toggle
end

local function addNumberInput(tab, title, key)
    local input
    local before = {}
    for _, object in ipairs(tab.Container:GetDescendants()) do
        before[object] = true
    end

    local function commit(text)
        if not guardsActive or settingGuard or not rt.alive then
            return
        end
        local value = (text == formatNumber(CFG[key])) and CFG[key] or parseNumber(text)
        if value and value > 0 and value ~= CFG[key] then
            CFG[key] = value
            saveConfig()
        end
        settingGuard = true
        input:SetValue(formatNumber(CFG[key]))
        settingGuard = false
    end

    input = tab:AddInput(key, {
        Title = title,
        Default = formatNumber(CFG[key]),
        Description = "Accepts 25k, 1.5M, 2B, 1e6, or 1e6 (1M)",
        Numeric = false,
        Finished = true,
        Callback = commit,
    })

    for _, object in ipairs(tab.Container:GetDescendants()) do
        if object:IsA("TextBox") and not before[object] then
            track(object.Focused:Connect(function()
                object.Text = formatSci(CFG[key], 16)
            end))
            track(object.FocusLost:Connect(function()
                if object.Text ~= formatNumber(CFG[key]) then
                    commit(object.Text)
                end
            end))
            break
        end
    end
end

-- ==================== aba Mine ====================

addToggle(mineTab, "autoMine", "Auto Mine Â· K")
addToggle(mineTab, "multiOres", "Multi Ores")

local oreDurationSlider
oreDurationSlider = mineTab:AddSlider("OreDuration", {
    Title = "Time per ore (minutes)",
    Description = "10-minute steps Â· 10 minutes to 4 hours",
    Min = 10,
    Max = 240,
    Rounding = 0,
    Default = CFG.duration / 60,
    Callback = function(value)
        if not guardsActive or settingGuard or not rt.alive then
            return
        end
        local snapped = math.clamp(math.floor(value / 10 + 0.5), 1, 24) * 10
        if value ~= snapped then
            settingGuard = true
            oreDurationSlider:SetValue(snapped)
            settingGuard = false
        end
        value = snapped
        local seconds = value * 60
        if seconds == CFG.duration then
            return
        end
        CFG.duration = seconds
        CFG.oreElapsed = math.min(CFG.oreElapsed, seconds)
        saveConfig()
    end,
})

local singleOreDropdown
singleOreDropdown = mineTab:AddDropdown("SingleOre", {
    Title = "Single Ore",
    Description = "Used when Multi Ores is disabled",
    Values = ORE_NAMES,
    Multi = false,
    Default = CFG.singleOre,
    Callback = function(ore)
        if not guardsActive or settingGuard or not rt.alive or not ORES[ore] or CFG.singleOre == ore then
            return
        end
        CFG.singleOre = ore
        if not CFG.multiOres then
            resetOreProgress()
        else
            saveConfig()
        end
    end,
})

local cycleOresDropdown
cycleOresDropdown = mineTab:AddDropdown("CycleOres", {
    Title = "Cycle Ores",
    Description = "Selection order determines the mining sequence",
    Values = ORE_NAMES,
    Multi = true,
    Default = CFG.cycleOres,
    Callback = function(selected)
        if not guardsActive or settingGuard or not rt.alive then
            return
        end
        local ordered = {}
        for _, ore in ipairs(CFG.cycleOres) do
            if selected[ore] then
                ordered[#ordered + 1] = ore
            end
        end
        for _, ore in ipairs(ORE_NAMES) do
            if selected[ore] and not table.find(ordered, ore) then
                ordered[#ordered + 1] = ore
            end
        end
        if table.concat(ordered, "|") == table.concat(CFG.cycleOres, "|") then
            return
        end
        CFG.cycleOres = ordered
        if CFG.multiOres then
            resetOreProgress()
        else
            saveConfig()
        end
    end,
})

local function setCycleSelection(ores)
    CFG.cycleOres = ores
    local selected = {}
    for _, ore in ipairs(ores) do
        selected[ore] = true
    end
    settingGuard = true
    cycleOresDropdown:SetValues(ORE_NAMES)
    cycleOresDropdown:SetValue(selected)
    cycleOresDropdown:SetValues(ORE_NAMES_SNAPSHOT)
    settingGuard = false
    resetOreProgress()
end

mineTab:AddButton({
    Title = "Select All",
    Callback = function()
        local ores = table.clone(CFG.cycleOres)
        for _, ore in ipairs(ORE_NAMES) do
            if not table.find(ores, ore) then
                table.insert(ores, ore)
            end
        end
        setCycleSelection(ores)
    end,
})

mineTab:AddButton({
    Title = "Clear Selection",
    Callback = function()
        setCycleSelection({})
    end,
})

-- ==================== aba Gears ====================

addToggle(gearsTab, "autoUpgradeGears", "Auto Upgrade")
addToggle(gearsTab, "autoResetNormal", "Auto Reset Normal â†’ Shiny")
addNumberInput(gearsTab, "Minimum Shiny per reset", "minShiny")
addToggle(gearsTab, "autoResetShiny", "Auto Reset Shiny â†’ Life")
addNumberInput(gearsTab, "Minimum Life per reset", "minLife")

-- ==================== aba Monster ====================

addToggle(monsterTab, "monsterClick", "Auto Monster Click")
addToggle(monsterTab, "monsterReset", "Auto Monster Sacrifice")
addNumberInput(monsterTab, "Minimum gain per monster sacrifice", "monsterMinimum")
addToggle(monsterTab, "monsterPerks", "Auto Monster Perks (max)")
addToggle(monsterTab, "monsterUpgrades", "Auto Sacrifice Upgrades")

-- ==================== leitura de cards ====================
-- Maxed SOMENTE pelo Progress "X/Y" (Level/UpgradeMax dao falso positivo).

local function matchXY(text)
    local from = 1
    while from <= #text do
        local start, stop, current, cap = text:find("(%d+)%s*/%s*(%d+)", from)
        if not start then
            return nil
        end
        if start > 1 and text:sub(start - 1, start - 1) == "." then
            from = stop + 1
        else
            return tonumber(current), tonumber(cap)
        end
    end
    return nil
end

local function readProgress(container)
    if not container then
        return nil
    end
    local progress = container:FindFirstChild("Progress")
    if not progress then
        progress = container:FindFirstChild("Progress", true)
    end
    if not progress then
        return nil
    end
    local ok, text = pcall(function()
        return tostring(progress.Text)
    end)
    if not ok or type(text) ~= "string" then
        return nil
    end
    text = text:gsub("<[^>]+>", ""):gsub("^%s*[Ll]evel%s*", "")
    local current, cap = matchXY(text)
    if current and cap and cap > 0 then
        return current >= cap, current .. "/" .. cap
    end
    return false, text:sub(1, 12)
end

local function readCard(card, isMain)
    if not card then
        return false, nil, true, nil
    end
    local hud
    if isMain then
        hud = findPath(card, { "MainPart", "SurfaceGui", "Hud" })
    else
        hud = card:FindFirstChild("Frame")
    end
    if not hud then
        return false, nil, true, nil
    end
    local isMax = false
    local maxed, progStr = readProgress(hud)
    if maxed == nil then
        maxed, progStr = readProgress(card)
    end
    if maxed == true then
        isMax = true
    end
    local price, invalid = nil, false
    local priceObject = hud:FindFirstChild("Price")
    if priceObject then
        local ok, raw = pcall(function()
            return tostring(priceObject.Text)
        end)
        raw = ok and raw or nil
        if raw == "" or raw == "1,234" or raw == "0" then
            invalid = true
        else
            price = parseTextNumber(raw)
            if not price then
                invalid = true
            end
        end
    else
        invalid = true
    end
    return isMax, price, invalid, progStr
end

local function findCheapest(container, maxId)
    if not container then
        return nil, nil
    end
    local bestId, bestPrice
    for id = 1, maxId do
        local card = container:FindFirstChild("Upgrade" .. id)
        if card then
            local frame = card:FindFirstChild("Frame") or card
            local maxed = readProgress(frame)
            if maxed == nil then
                maxed = readProgress(card)
            end
            if maxed ~= true then
                local priceObject = frame:FindFirstChild("Price")
                local ok, raw = pcall(function()
                    return priceObject and tostring(priceObject.Text) or nil
                end)
                local price = ok and raw and parseTextNumber(raw) or nil
                if price and (not bestPrice or price < bestPrice) then
                    bestId, bestPrice = id, price
                end
            end
        end
    end
    return bestId, bestPrice
end

local function findUpgradeBoard(root)
    if not root then
        return nil
    end
    if root:FindFirstChild("Upgrade1") and root:FindFirstChild("Upgrade7") then
        return root
    end
    local found
    for _, object in ipairs(root:GetDescendants()) do
        if object.Name == "Upgrade1" and (object:FindFirstChild("Price") or (object:FindFirstChild("Frame") and object.Frame:FindFirstChild("Price"))) then
            local parent = object.Parent
            if parent and parent:FindFirstChild("Upgrade7") then
                if found and found ~= parent then
                    return nil
                end
                found = parent
            end
        end
    end
    return found
end

-- ==================== console (debug) ====================

local function dumpCurrencies()
    local lines = {}
    local function add(line)
        lines[#lines + 1] = tostring(line)
    end
    add("=== Regrowth currency check Â· copie tudo daqui ===")
    add("Money: " .. tostring(statValue(CURRENCY_NAMES.money)))
    add("EmeraldCoins: " .. tostring(statValue(CURRENCY_NAMES.emerald)))
    add("Gold: " .. tostring(statValue(CURRENCY_NAMES.gold)))
    add("GoldenDiamond: " .. tostring(statValue(CURRENCY_NAMES.goldDiamond)))
    add("PerkPoints: " .. tostring(statValue("PerkPoints")))
    add("DarkLiquid: " .. tostring(statValue("DarkLiquid")))
    local gainLabel = findPath(workspace, { "Boards", "MonsterSacrifice" })
    gainLabel = gainLabel and gainLabel:FindFirstChild("Gain", true)
    add("Monster Gain label: " .. (gainLabel and (gainLabel:GetFullName() .. " = " .. tostring(gainLabel.Text)) or "<not found>"))
    local resetLabel = findPath(workspace, { "Boards", "GoldenDiamondReset" })
    resetLabel = resetLabel and resetLabel:FindFirstChild("GoldDiamond", true)
    add("GoldDiamond reset label: " .. (resetLabel and (resetLabel:GetFullName() .. " = " .. tostring(resetLabel.Text)) or "<not found>"))
    add("=== fim ===")
    warn(table.concat(lines, "\n"))
end

-- ==================== listener de rejeicao ====================

spawnTask(function()
    for _ = 1, 30 do
        if not rt.alive then
            return
        end
        local clientEvents = game:GetService("ReplicatedStorage"):FindFirstChild("ClientEvents")
        local notifier = clientEvents and clientEvents:FindFirstChild("Notifier")
        if notifier and notifier:IsA("RemoteEvent") then
            track(notifier.OnClientEvent:Connect(function(message)
                if type(message) == "string" then
                    local low = message:lower()
                    if low:find("reached max", 1, true) or low:find("reached upgrade limit", 1, true) then
                        if lastFireKey and (os.clock() - lastFireTime) < 3 then
                            rejectCooldown[lastFireKey] = os.clock() + 30
                        end
                    end
                end
            end))
            return
        end
        task.wait(2)
    end
end)

-- ==================== thread Monster ====================

spawnTask(function()
    local nextClick, nextSacrifice, nextPerk, nextUpgrade = 0, 0, 0, 0
    local perkPauseUntil = 0
    local prioritizeFirstPerk = true

    while rt.alive do
        if CFG.monsterClick or CFG.monsterReset or CFG.monsterPerks or CFG.monsterUpgrades then
            local now = os.clock()

            local events = findPath(game:GetService("ReplicatedStorage"), { "Events" })
            local monsterGain = findPath(plr, { "GameplayEvents", "MonsterGain" })
            local monsterSacrifice = findPath(events, { "MonsterEvolution", "MonsterSacrifice" })
            local monsterPerk = findPath(events, { "PerkUpgrade", "MonsterPerk" })
            local sacrificeUpgrade = findPath(events, { "MonsterEvolution", "SacrificeUpgrade" })

            local boards = workspace:FindFirstChild("Boards")
            local sacrificeBoard = boards and boards:FindFirstChild("MonsterSacrifice")
            local levelBoard = boards and boards:FindFirstChild("MonsterLevel")

            local gainLabel = sacrificeBoard and sacrificeBoard:FindFirstChild("Gain", true) or nil
            local perkList = findPath(levelBoard, { "MonsterPerks", "SurfaceGui", "Info", "List" })
                or (levelBoard and levelBoard:FindFirstChild("List", true))
                or nil
            local sacList = findPath(sacrificeBoard, { "Sacrifice", "SurfaceGui", "Info", "List" })
                or (sacrificeBoard and sacrificeBoard:FindFirstChild("List", true))
                or findUpgradeBoard(sacrificeBoard)
                or nil

            if CFG.monsterClick and now >= nextClick then
                nextClick = now + 0.05
                fireRemote(monsterGain)
            end

            local gain = gainLabel and parseTextNumber(gainLabel.Text) or nil

            if CFG.monsterReset and now >= nextSacrifice then
                nextSacrifice = now + 1
                if gain and gain >= CFG.monsterMinimum and fireRemote(monsterSacrifice) then
                    perkPauseUntil = now + 0.2
                    prioritizeFirstPerk = true
                    nextPerk = perkPauseUntil
                end
            end

            if CFG.monsterPerks and perkList and now >= nextPerk and now >= perkPauseUntil then
                nextPerk = now + 0.5
                local perkPoints = statValue("PerkPoints") or 0
                local perkId, price
                if prioritizeFirstPerk then
                    local firstCard = perkList:FindFirstChild("Upgrade1")
                    local firstMaxed, firstPrice = readCard(firstCard, false)
                    if not firstMaxed and not firstMaxed ~= true and firstPrice then
                        perkId, price = 1, firstPrice
                    end
                    if perkId then
                        prioritizeFirstPerk = false
                    end
                end
                if not perkId then
                    perkId, price = findCheapest(perkList, 12)
                end
                if perkId and price and price <= perkPoints then
                    local key = "P" .. perkId
                    if (rejectCooldown[key] or 0) <= now then
                        if fireRemote(monsterPerk, perkId, true) then
                            noteFire(key)
                            nextPerk = now + 2
                        end
                    end
                end
            end

            if CFG.monsterUpgrades and sacList and now >= nextUpgrade and now >= perkPauseUntil then
                nextUpgrade = now + 0.5
                local balance = statValue("DarkLiquid") or statValue("Dark Liquid") or 0
                local upgradeId, price = findCheapest(sacList, 7)
                if upgradeId and price and price <= balance then
                    local key = "S" .. upgradeId
                    if (rejectCooldown[key] or 0) <= now then
                        if fireRemote(sacrificeUpgrade, upgradeId) then
                            noteFire(key)
                            nextUpgrade = now + 1
                        end
                    end
                end
            end

            task.wait(0.05)
        else
            task.wait(0.2)
        end
    end
end)

-- ==================== aba Upgrade Tree ====================

treeTab:AddSection("Main Tree")
addToggle(treeTab, "treeMain", "Auto Tree Upgrades")
treeTab:AddParagraph({ Title = "Buying", Content = "1, 2, 3, 4, 5, 10, 19, 23, 26, 42, 43, 72" })

treeTab:AddSection("Emerald")
addToggle(treeTab, "treeEmerald", "Auto Emerald Upgrades (1-14)")

treeTab:AddSection("Gold")
addToggle(treeTab, "treeGold", "Auto Gold Upgrades (1-10)")

treeTab:AddSection("Gold Diamond")
addToggle(treeTab, "treeDiamond", "Auto Gold Diamond Upgrades")
treeTab:AddParagraph({ Title = "Priority", Content = "10 > 3 > 2 > 6 > 14 > 1 > 9 > 11 > 15" })
addToggle(treeTab, "diamondReset", "Auto Golden Diamond Reset")
addNumberInput(treeTab, "Minimum to reset", "diamondResetMinimum")

spawnTask(function()
    local EMERALD_IDS = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }
    local GOLD_IDS = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

    local cd = {}
    local mainIdx, emIdx, goldIdx, diaIdx = 1, 1, 1, 1
    local nextMain, nextEmerald, nextGold, nextDiamond, nextResetCheck = 0, 0, 0, 0, 0

    local function getBoardCard(board, prefix, id)
        if not board then
            return nil
        end
        local node = board:FindFirstChild(prefix)
        node = node and node:FindFirstChild("SurfaceGui")
        node = node and node:FindFirstChild("Info")
        node = node and node:FindFirstChild("List")
        return node and node:FindFirstChild("Upgrade" .. id) or nil
    end

    while rt.alive do
        if CFG.treeMain or CFG.treeEmerald or CFG.treeGold or CFG.treeDiamond or CFG.diamondReset then
            local now = os.clock()

            -- Refetch a cada tick: apos o Diamond Reset o jogo recria TreeCards/Boards
            local events = findPath(game:GetService("ReplicatedStorage"), { "Events" })
            local treeRemote = events and events:FindFirstChild("UpgradeTree")
            local emeraldRemote = treeRemote and treeRemote:FindFirstChild("EmeraldUpgrade")
            local goldRemote = treeRemote and treeRemote:FindFirstChild("GoldUpgrade")
            local diamondRemote = treeRemote and treeRemote:FindFirstChild("DiamondUpgrade")
            local diamondResetRemote = treeRemote and treeRemote:FindFirstChild("DiamondReset")
            local treeCards = workspace:FindFirstChild("TreeCards")
            local boards = workspace:FindFirstChild("Boards")
            local goldBarsBoard = boards and boards:FindFirstChild("GoldBarsReset")
            local emeraldBoard = boards and boards:FindFirstChild("EmeraldCoinsReset")
            local goldDiamondBoard = boards and boards:FindFirstChild("GoldenDiamondReset")
            local goldDiamondLabel = goldDiamondBoard and goldDiamondBoard:FindFirstChild("GoldDiamond", true) or nil

            if CFG.treeMain and treeRemote and now >= nextMain then
                nextMain = now + 0.3
                local money = statValue(CURRENCY_NAMES.money)
                if money then
                    for _ = 1, #TREE_MAIN_IDS do
                        local id = TREE_MAIN_IDS[mainIdx]
                        local key = "M" .. id
                        if (cd[key] or 0) <= now and (rejectCooldown[key] or 0) <= now then
                            local card = treeCards and treeCards:FindFirstChild(tostring(id))
                            local isMax, price, invalid = readCard(card, true)
                            if isMax then
                                cd[key] = now + 5
                            elseif not invalid and price and price <= money then
                                noteFire(key)
                                if fireRemote(treeRemote, id, true) then
                                    cd[key] = now + 1
                                    mainIdx = mainIdx % #TREE_MAIN_IDS + 1
                                    break
                                end
                            end
                        end
                        mainIdx = mainIdx % #TREE_MAIN_IDS + 1
                    end
                end
            end

            if CFG.treeEmerald and emeraldRemote and now >= nextEmerald then
                nextEmerald = now + 0.3
                local balance = statValue(CURRENCY_NAMES.emerald)
                if balance then
                    for _ = 1, #EMERALD_IDS do
                        local id = EMERALD_IDS[emIdx]
                        local key = "E" .. id
                        if (cd[key] or 0) <= now and (rejectCooldown[key] or 0) <= now then
                            local card = getBoardCard(emeraldBoard, "EmeraldUpgrades", id)
                            local isMax, price, invalid = readCard(card, false)
                            if isMax then
                                cd[key] = now + 5
                            elseif not invalid and price and price <= balance then
                                noteFire(key)
                                if fireRemote(emeraldRemote, id, true) then
                                    cd[key] = now + 1
                                    emIdx = emIdx % #EMERALD_IDS + 1
                                    break
                                end
                            end
                        end
                        emIdx = emIdx % #EMERALD_IDS + 1
                    end
                end
            end

            if CFG.treeGold and goldRemote and now >= nextGold then
                nextGold = now + 0.3
                local balance = statValue(CURRENCY_NAMES.gold)
                if balance then
                    for _ = 1, #GOLD_IDS do
                        local id = GOLD_IDS[goldIdx]
                        local key = "G" .. id
                        if (cd[key] or 0) <= now and (rejectCooldown[key] or 0) <= now then
                            local card = getBoardCard(goldBarsBoard, "GoldUpgrades", id)
                            local isMax, price, invalid = readCard(card, false)
                            if isMax then
                                cd[key] = now + 5
                            elseif not invalid and price and price <= balance then
                                noteFire(key)
                                if fireRemote(goldRemote, id, true) then
                                    cd[key] = now + 1
                                    goldIdx = goldIdx % #GOLD_IDS + 1
                                    break
                                end
                            end
                        end
                        goldIdx = goldIdx % #GOLD_IDS + 1
                    end
                end
            end

            if CFG.treeDiamond and diamondRemote and now >= nextDiamond then
                nextDiamond = now + 0.3
                local balance = statValue(CURRENCY_NAMES.goldDiamond)
                if balance then
                    for _ = 1, #DIAMOND_ORDER do
                        local id = DIAMOND_ORDER[diaIdx]
                        local key = "D" .. id
                        if (cd[key] or 0) <= now and (rejectCooldown[key] or 0) <= now then
                            local card = getBoardCard(goldDiamondBoard, "GoldUpgrades", id)
                            local isMax, price, invalid = readCard(card, false)
                            if isMax then
                                cd[key] = now + 5
                            elseif not invalid and price and price <= balance then
                                noteFire(key)
                                if fireRemote(diamondRemote, id, true) then
                                    cd[key] = now + 1
                                    diaIdx = diaIdx % #DIAMOND_ORDER + 1
                                    break
                                end
                            end
                        end
                        diaIdx = diaIdx % #DIAMOND_ORDER + 1
                    end
                end
            end

            if CFG.diamondReset and diamondResetRemote and now >= nextResetCheck then
                nextResetCheck = now + 3
                local gain = goldDiamondLabel and parseTextNumber(goldDiamondLabel.Text) or nil
                if gain and gain >= CFG.diamondResetMinimum then
                    if fireRemote(diamondResetRemote) then
                        for key in pairs(cd) do
                            cd[key] = 0
                        end
                        for key in pairs(rejectCooldown) do
                            rejectCooldown[key] = 0
                        end
                        mainIdx, emIdx, goldIdx, diaIdx = 1, 1, 1, 1
                        task.wait(1.5)
                    end
                end
            end

            task.wait(0.1)
        else
            task.wait(0.2)
        end
    end
end)

-- ==================== aba Settings ====================

settingsTab:AddSection("Interface")

settingsTab:AddToggle("AutoHide", {
    Title = "Auto Hide UI",
    Description = "Starts minimized on the next run",
    Default = CFG.hide,
    Callback = function(value)
        if not guardsActive or settingGuard or not rt.alive or CFG.hide == value then
            return
        end
        CFG.hide = value
        saveConfig()
    end,
})

addToggle(settingsTab, "hideOrePopup", "Hide Ore Popups")

keybindButton = settingsTab:AddButton({
    Title = "Toggle Keybind Â· " .. CFG.key,
    Description = "Click, then press a key. Escape cancels. K is reserved for mining.",
    Callback = function()
        waitingForKey = true
        keybindButton:SetTitle("Press a key Â· Escape cancels")
    end,
})

settingsTab:AddSection("Console")

settingsTab:AddButton({
    Title = "Check currencies",
    Description = "Prints the currency values used by the script to the console (F9)",
    Callback = dumpCurrencies,
})

settingsTab:AddSection("Exit")

settingsTab:AddButton({
    Title = "Uninject",
    Description = "Saves configuration, stops automation, and removes the interface",
    Callback = function()
        window:Dialog({
            Title = "Uninject",
            Content = "Stop Regrowth Incremental and remove its interface?",
            Buttons = {
                { Title = "Confirm", Callback = unload },
                { Title = "Cancel" },
            },
        })
    end,
})

-- ==================== input ====================

track(UserInputService.InputBegan:Connect(function(input, processed)
    if not rt.alive or UserInputService:GetFocusedTextBox() then
        return
    end

    if waitingForKey then
        if input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
        if input.KeyCode == Enum.KeyCode.Escape then
            waitingForKey = false
        elseif table.find({ "K", "Unknown", "F9", "F11", "F12", "PrintScreen" }, input.KeyCode.Name) then
            return
        else
            CFG.key = input.KeyCode.Name
            library.MinimizeKey.Name = CFG.key
            waitingForKey = false
            saveConfig()
        end
        keybindButton:SetTitle("Toggle Keybind Â· " .. CFG.key)
        return
    end

    if processed then
        return
    end

    if input.KeyCode.Name == CFG.key then
        window:Minimize()
    elseif input.KeyCode == Enum.KeyCode.K then
        rt.toggles.autoMine:SetValue(not CFG.autoMine)
    end
end))

-- ==================== thread Mine / Gears ====================

spawnTask(function()
    local gameplayEvents = plr:WaitForChild("GameplayEvents", 15)
    local statsFolder = plr:WaitForChild("Stats", 15)
    local eventsFolder = game:GetService("ReplicatedStorage"):WaitForChild("Events", 15)

    if not rt.alive then
        return
    end

    assert(gameplayEvents and statsFolder and eventsFolder, "GameplayEvents, Stats, or Events unavailable")

    local miningEvents = gameplayEvents:WaitForChild("Mining", 15)
    local mineOreRemote = miningEvents and miningEvents:WaitForChild("MineOre", 15)
    local gearsUpgradeRemote = eventsFolder:WaitForChild("GearsUpgrade", 15)
    local gearsResetRemote = gearsUpgradeRemote and gearsUpgradeRemote:WaitForChild("GearsReset", 15)
    local mineOreFolder = eventsFolder:WaitForChild("MineOre", 15)
    local setDepthRemote = mineOreFolder and mineOreFolder:WaitForChild("SetDepth", 15)
    local miningTierRemote = mineOreFolder and mineOreFolder:WaitForChild("MiningTier", 15)
    local adjustSettingRemote = eventsFolder:WaitForChild("AdjustSetting", 15)

    if not rt.alive then
        return
    end

    assert(mineOreRemote and gearsUpgradeRemote and gearsResetRemote and setDepthRemote and miningTierRemote and adjustSettingRemote, "Mining remotes unavailable")

    local function getStat(name)
        local value = statsFolder:FindFirstChild(name)
        return value and tonumber(value.Value) or 0
    end

    local function getNextGearsReward(index)
        local node = findPath(workspace, { "Boards", "GearTypes", "GearsReset", "SurfaceGui", "Info", "Gear" .. index, "NextGears" })
        if not node then
            return 0
        end
        return parseNumber(node.Text:gsub("^%s*%+", "")) or 0
    end

    local gearThresholds = { 50, 65, 80, 95, 120 }
    local gearCooldowns = { 0, 0, 0, 0, 0 }

    spawnTask(function()
        while rt.alive do
            if CFG.autoMine then
                local ore = CFG.multiOres and CFG.cycleOres[CFG.oreSlot] or CFG.singleOre
                if CFG.multiOres and #CFG.cycleOres == 0 then
                    ore = nil
                end

                if ore and ore ~= rt.currentOre then
                    local generation = rt.session

                    local function isCurrent()
                        return rt.alive and CFG.autoMine and generation == rt.session
                    end

                    local function applyOreSetup()
                        adjustSettingRemote:FireServer(ORES[ore][2], "OreLuck")
                        task.wait(0.15)
                        if not isCurrent() then return end
                        setDepthRemote:FireServer(ORES[ore][1])
                        task.wait(0.4)
                        if not isCurrent() then return end
                        miningTierRemote:FireServer(1)
                        task.wait(0.15)
                        if not isCurrent() then return end
                        miningTierRemote:FireServer(1)
                        task.wait(0.2)
                        if isCurrent() then
                            rt.currentOre = ore
                        end
                    end

                    local ok, err = pcall(applyOreSetup)
                    if not ok then
                        error(err, 0)
                    end
                end

                if ore and CFG.autoMine and rt.currentOre == ore then
                    local cycleStarted = os.clock()
                    local generation = rt.session
                    for index = 1, 5 do
                        if not rt.alive or not CFG.autoMine or generation ~= rt.session then
                            break
                        end
                        mineOreRemote:FireServer(index)
                        task.wait(0.02)
                    end
                    task.wait(0.05)

                    if CFG.multiOres and CFG.autoMine and generation == rt.session and CFG.cycleOres[CFG.oreSlot] == ore then
                        CFG.oreElapsed = CFG.oreElapsed + os.clock() - cycleStarted
                        if CFG.oreElapsed >= CFG.duration then
                            CFG.oreElapsed = CFG.oreElapsed % CFG.duration
                            CFG.oreSlot = CFG.oreSlot % #CFG.cycleOres + 1
                            rt.currentOre = nil
                            saveConfig()
                        end
                    end
                else
                    task.wait(0.2)
                end
            else
                task.wait(0.2)
            end
        end
    end)

    spawnTask(function()
        while rt.alive do
            if CFG.autoUpgradeGears then
                for tier = 5, 1, -1 do
                    if not rt.alive or not CFG.autoUpgradeGears then
                        break
                    end
                    if
                        (tier == 1 or getStat("GearsUpgrade" .. (tier - 1)) >= gearThresholds[tier - 1])
                        and getStat("GearsUpgrade" .. tier) < gearThresholds[tier]
                        and os.clock() >= gearCooldowns[tier]
                    then
                        local before = getStat("GearsUpgrade" .. tier)
                        gearsUpgradeRemote:FireServer(tier, true)
                        task.wait(1)
                        if before == getStat("GearsUpgrade" .. tier) then
                            gearCooldowns[tier] = os.clock() + 15
                        end
                        task.wait(0.3)
                    end
                end
            end
            task.wait(0.3)
        end
    end)

    spawnTask(function()
        while rt.alive do
            if CFG.autoResetNormal and getNextGearsReward(1) >= CFG.minShiny then
                gearsResetRemote:FireServer(1)
                task.wait(1)
            end
            if CFG.autoResetShiny and getNextGearsReward(2) >= CFG.minLife then
                gearsResetRemote:FireServer(2)
                task.wait(1)
            end
            task.wait(0.3)
        end
    end)
end)

-- ==================== hide ore popups ====================

spawnTask(function()
    local playerGui = plr:WaitForChild("PlayerGui", 10)
    while rt.alive do
        if CFG.hideOrePopup and playerGui then
            local gameUi = playerGui:FindFirstChild("GameUi")
            if gameUi then
                local template = gameUi:FindFirstChild("PopUpTemplate")
                if template and template.Visible then
                    template.Visible = false
                end
                for _, object in ipairs(gameUi:GetChildren()) do
                    if object.Name:find("PopUp") and object:IsA("GuiObject") and object.Visible then
                        object.Visible = false
                    end
                end
            end
        end
        RunService.RenderStepped:Wait()
    end
end)

-- ==================== auto-save ====================

spawnTask(function()
    while rt.alive do
        task.wait(30)
        if rt.alive then
            saveConfig()
        end
    end
end)

guardsActive = true
window:SelectTab(1)

if CFG.hide then
    library:Notify({
        Title = "Regrowth Incremental",
        Content = "Interface hidden. Press " .. CFG.key .. " to open.",
        Duration = 6,
    })
end

saveConfig()

]====]

local chunk, syntaxError = loadstring(source, "=Regrowth.Main.Recovery")

if not chunk then
    error("[Regrowth.Main syntax] " .. tostring(syntaxError), 0)
end

local ok, runtimeError = xpcall(chunk, debug.traceback)

if not ok then
    warn("[Regrowth.Main runtime] " .. tostring(runtimeError))
    error(runtimeError, 0)
end
