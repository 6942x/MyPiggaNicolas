local r = [====[
local r = game:GetService("Players").LocalPlayer
local r1 = game:GetService("TweenService")
local r2 = game:GetService("UserInputService")
local r3 = game:GetService("HttpService")
local r4 = type(getgenv) == "function" and getgenv() or shared

if not r then
    warn("[Auto Farm] Run this script inside the game client")
    return
end

local r5 = "AutoFarm_" .. game.PlaceId .. "_" .. r.UserId
local r6 = r5 .. ".json"

if type(r4[r5]) == "table" and type(r4[r5].r) == "function" then
    pcall(r4[r5].r)
end

local r7 = { r = true, r1 = {}, r2 = {}, r3 = {}, r4 = {}, r5 = false, r10 = 0e0 }

r4[r5] = {
    r = function()
        r7.r = false
    end,
}

local r8 = {
    r = false,
    r1 = false,
    r2 = false,
    r3 = false,
    r4 = 1e6,
    r5 = 5e3,
    r6 = { "Coal", "Garnet", "Onyx", "Copper", "Plutonium" },
    r7 = "Onyx",
    r8 = false,
    r9 = 1e0,
    r10 = 0e0,
    hide = false,
    key = "G",
    duration = 7.2e3,
    monsterClick = false,
    monsterReset = false,
    monsterPerks = false,
    monsterUpgrades = false,
    monsterMinimum = 1e6,
}

local r9 = {
    Coal = { 0e0, 1e0 },
    Tin = { 0e0, 4e0 },
    Copper = { 0e0, 6.22e2 },
    Iron = { 3.25e2, 1e0 },
    Silver = { 2e1, 6e1 },
    Gold = { 2e1, 6.22e2 },
    Topaz = { 1.25e2, 1.8e2 },
    Sapphire = { 1.25e2, 6.22e2 },
    Ruby = { 5e3, 3.2e1 },
    Emerald = { 6e2, 6.22e2 },
    Azurite = { 5e3, 1.45e2 },
    Diamond = { 5e3, 5.5e2 },
    Tanzanite = { 7.5e3, 6.22e2 },
    Plutonium = { 7.5e3, 2.05e2 },
    Uranium = { 2.75e4, 1e0 },
    Onyx = { 5.25e4, 3e1 },
    Garnet = { 2.75e4, 6.22e2 },
    Neptunium = { 1.5e5, 6.22e2 },
    Osmium = { 4.5e6, 6.22e2 },
    Mithril = { 6.25e6, 6.22e2 },
    Painite = { 6.25e6, 6.22e2 },
}

local r10 = {
    "",
    "K",
    "M",
    "B",
    "T",
    "Qa",
    "Qi",
    "Sx",
    "Sp",
    "Oc",
    "No",
    "Dc",
    "Ud",
    "Dd",
    "Td",
    "Qad",
    "Qid",
    "Sxd",
    "Spd",
    "Ocd",
    "Nod",
    "Vg",
}

local function r11(r, r1)
    local r2, r3 = string.format("%." .. (r1 or 3e0) .. "e", r):match("^(.-)e([+-]?%d+)$")
    r2 = r2:gsub("%.?0+$", "")
    return r2 .. "e" .. tostring(tonumber(r3))
end

local function r12(r)
    r = tonumber(r)

    if not r or r ~= r or math.abs(r) == math.huge then
        return "—"
    end

    local r1 = r11(r)
    local r2 = tonumber(r1)
    local r3 = math.abs(r2)
    local r4 = 1e0

    while r3 >= 1e3 and r4 < #r10 do
        r3 = r3 / 1e3
        r4 = r4 + 1e0
    end

    local r5 = r1

    if r3 < 1e3 then
        r5 = string.format("%.3f", r2 / 1e3 ^ (r4 - 1e0)):gsub("%.?0+$", "") .. r10[r4]

        if r2 ~= 0e0 and math.abs(r2) < 1e-3 then
            r5 = r1
        end
    end

    return r1 .. " (" .. r5 .. ")"
end

local r13 = {
    k = 1e3,
    m = 1e6,
    b = 1e9,
    t = 1e12,
    qa = 1e15,
    qi = 1e18,
    sx = 1e21,
    sp = 1e24,
    oc = 1e27,
    no = 1e30,
    dc = 1e33,
    [""] = 1e0,
}

local function r14(r)
    local r1 = tostring(r):lower():gsub("%s*%([^()]*%)%s*$", ""):gsub("[%s,]", "")
    local r2 = tonumber(r1)

    if not r2 then
        local r3, r4 = r1:match("^([%d%.]+)(%a*)$")
        local r5 = r3 and tonumber(r3)
        local r6 = r4 and r13[r4]

        if r5 and r6 then
            r2 = r5 * r6
        end
    end

    if r2 and r2 == r2 and r2 >= 0e0 and r2 < math.huge then
        return r2
    end
end

local r15 = {}

for r, r1 in pairs(r9) do
    table.insert(r15, r)
end

table.sort(r15)

local function r16(r)
    if type(r) ~= "table" then
        return
    end

    for r1, r2 in pairs(r8) do
        if type(r2) == "boolean" and type(r[r1]) == "boolean" then
            r8[r1] = r[r1]
        end
    end

    for r1, r2 in ipairs({ "r4", "r5", "monsterMinimum" }) do
        if type(r[r2]) == "number" and r[r2] > 0e0 and r[r2] < math.huge then
            r8[r2] = r[r2]
        end
    end

    if type(r.key) == "string" then
        local r1, r2 = pcall(function()
            return Enum.KeyCode[r.key]
        end)

        if
            r1
            and r2
            and not table.find({ "Unknown", "K", "Escape", "F9", "F11", "F12", "PrintScreen" }, r.key)
        then
            r8.key = r.key
        end
    end

    if r9[r.r7] then
        r8.r7 = r.r7
    end

    if type(r.r6) == "table" then
        local r1 = {}

        for r2, r3 in ipairs(r.r6) do
            if r9[r3] and not table.find(r1, r3) then
                table.insert(r1, r3)
            end
        end

        r8.r6 = r1
    end

    r8.r9 = math.clamp(math.floor(r14(r.r9) or 1e0), 1e0, math.max(1e0, #r8.r6))
    r8.duration = math.clamp(math.floor((r14(r.duration) or 7.2e3) / 6e2 + 5e-1), 1e0, 2.4e1) * 6e2
    r8.r10 = math.clamp(r14(r.r10) or 0e0, 0e0, r8.duration)
end

if type(readfile) == "function" then
    local r, r1 = pcall(function()
        return r3:JSONDecode(readfile(r6))
    end)

    if r then
        r16(r1)
    end
end

r16(r4[r5 .. "_config"])

local function r17()
    r4[r5 .. "_config"] = table.clone(r8)
    r4[r5 .. "_config"].r6 = table.clone(r8.r6)

    if type(writefile) == "function" then
        local r, r1 = pcall(function()
            writefile(r6, r3:JSONEncode(r8))
        end)

        r7.r6 = r and "Configuration saved" or "Failed to save configuration file"
    else
        r7.r6 = "Configuration saved for this session"
    end
end

local function r18(r, r1)
    local r2 = r:Connect(r1)
    table.insert(r7.r1, r2)
    return r2
end

local r19

local function r20(r)
    local r1 = task.defer(function()
        if r7.r then
            local r1, r2 = xpcall(r, debug.traceback)

            if not r1 and r7.r then
                r7.r7 = tostring(r2)

                if r19 then
                    r19(r2)
                end

                warn(r2)
            end
        end

        r7.r2[coroutine.running()] = nil
    end)

    r7.r2[r1] = true
    return r1
end

local r21
local r22
local r23 = false
local r24 = false
local r25 = {}
local r26 = {}
local r27
local r28 = false
local r29

local function r30(r, r1)
    if r and r.rText ~= r1 then
        r.rText = r1
        r:SetDesc(r1)
    end
end

local function r31()
    if not r7.r then
        return
    end

    r17()
    r7.r = false
    r7.r10 = r7.r10 + 1e0
    r28 = false

    for r, r1 in ipairs(r7.r1) do
        pcall(r1.Disconnect, r1)
    end

    for r, r1 in pairs(r7.r2) do
        if r ~= coroutine.running() and coroutine.status(r) ~= "dead" then
            pcall(task.cancel, r)
        end
    end

    for r, r1 in pairs(r7.r3) do
        pcall(r1.Cancel, r1)
    end

    table.clear(r7.r1)
    table.clear(r7.r2)
    table.clear(r7.r3)

    if r21 and not r21.Unloaded then
        pcall(r21.Destroy, r21)
    end

    if r4[r5] and r4[r5].r == r31 then
        r4[r5] = nil
    end
end

r7.r9 = r31
r4[r5] = { r = r31 }

local function r32()
    local r = "https://github.com/dawid-scripts/Fluent/releases/download/1.1.0/main.lua"
    local r1 = "Regrowth_Fluent_1_1_0.lua"

    local r2, r3 = pcall(function()
        return game:HttpGet(r)
    end)

    if not r7.r then
        return
    end

    if r2 and type(r3) == "string" and #r3 > 2e2 then
        if type(writefile) == "function" then
            pcall(writefile, r1, r3)
        end
    elseif type(readfile) == "function" then
        r2, r3 = pcall(readfile, r1)
    end

    assert(r2 and type(r3) == "string" and #r3 > 2e2, "Fluent unavailable: check your connection")
    local r4, r5 = loadstring(r3, "=Regrowth.Fluent.1.1.0")
    assert(r4, "Failed to compile Fluent: " .. tostring(r5))
    return r4()
end

local r33, r34 = pcall(r32)

if not r7.r then
    if r33 and type(r34) == "table" then
        pcall(r34.Destroy, r34)
    end

    return
end

if not r33 or type(r34) ~= "table" then
    r31()
    error("[Regrowth] " .. tostring(r34), 0e0)
end

r21 = r34

local r35 = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(8e2, 6e2)

r22 = r21:CreateWindow({
    Title = "Regrowth Incremental",
    SubTitle = "Auto Farm",
    TabWidth = 1.3e2,
    Size = UDim2.fromOffset(
        math.max(3.6e2, math.min(6.4e2, r35.X - 2.4e1)),
        math.max(3.2e2, math.min(5.3e2, r35.Y - 6.4e1))
    ),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = { Name = r8.key },
})

r18(r21.GUI.Destroying, r31)
r22.Root.Visible = not r8.hide
r22.Minimized = r8.hide

local r36 = {
    Mine = r22:AddTab({ Title = "Mine", Icon = "hammer" }),
    Gears = r22:AddTab({ Title = "Gears", Icon = "settings-2" }),
    Info = r22:AddTab({ Title = "Info", Icon = "info" }),
    Monster = r22:AddTab({ Title = "Monster", Icon = "skull" }),
    Settings = r22:AddTab({ Title = "Settings", Icon = "settings" }),
}

local r37
local r38
local r39
local r40 = ""
local r41 = table.clone(r15)

local function r42()
    local r = {}

    for r1, r2 in ipairs(r8.r6) do
        r[#r + 1e0] = tostring(r1) .. ". " .. r2
    end

    r30(r37, #r > 0e0 and table.concat(r, " · ") or "No ores selected")
end

local function r43(r)
    r8.r9 = 1e0
    r8.r10 = 0e0
    r7.r8 = nil
    r7.r10 = r7.r10 + 1e0
    r42()
    r17()

    if r then
    end
end

local function r44(r, r1, r2)
    local r3 = r:AddToggle(r1, {
        Title = r2,
        Default = r8[r1],
        Callback = function(r)
            if not r23 or r24 or not r7.r or r8[r1] == r then
                return
            end

            r8[r1] = r

            if r1 == "r" then
                r7.r10 = r7.r10 + 1e0
            end

            if r1 == "r8" then
                r43()
            else
                r17()
            end
        end,
    })

    r7.r4[r1] = r3
    return r3
end

r44(r36.Mine, "r", "Auto Mine · K")
r44(r36.Mine, "r8", "Multi Ores")
local r45

r45 = r36.Mine:AddSlider("OreDuration", {
    Title = "Time per ore (minutes)",
    Description = "10-minute steps · 10 minutes to 4 hours",
    Min = 1e1,
    Max = 2.4e2,
    Rounding = 0e0,
    Default = r8.duration / 6e1,
    Callback = function(r)
        if not r23 or r24 or not r7.r then
            return
        end

        local r1 = math.clamp(math.floor(r / 1e1 + 5e-1), 1e0, 2.4e1) * 1e1

        if r ~= r1 then
            r24 = true
            r45:SetValue(r1)
            r24 = false
        end

        r = r1
        r1 = r * 6e1

        if r1 == r8.duration then
            return
        end

        r8.duration = r1
        r8.r10 = math.min(r8.r10, r1)
        r17()
    end,
})

r38 = r36.Mine:AddDropdown("SingleOre", {
    Title = "Single Ore",
    Description = "Used when Multi Ores is disabled",
    Values = r15,
    Multi = false,
    Default = r8.r7,
    Callback = function(r)
        if not r23 or r24 or not r7.r or not r9[r] or r8.r7 == r then
            return
        end

        r8.r7 = r

        if not r8.r8 then
            r43("Selected ore: " .. r)
        else
            r17()
        end
    end,
})

r39 = r36.Mine:AddDropdown("CycleOres", {
    Title = "Cycle Ores",
    Description = "Selection order determines the mining sequence",
    Values = r15,
    Multi = true,
    Default = r8.r6,
    Callback = function(r)
        if not r23 or r24 or not r7.r then
            return
        end

        local r1 = {}

        for r2, r3 in ipairs(r8.r6) do
            if r[r3] then
                r1[#r1 + 1e0] = r3
            end
        end

        for r2, r3 in ipairs(r15) do
            if r[r3] and not table.find(r1, r3) then
                r1[#r1 + 1e0] = r3
            end
        end

        if table.concat(r1, "|") == table.concat(r8.r6, "|") then
            return
        end

        r8.r6 = r1

        if r8.r8 then
            r43("Cycle selection updated")
        else
            r42()
            r17()
        end
    end,
})

local function r46(r)
    r8.r6 = r
    local r1 = {}

    for r2, r3 in ipairs(r) do
        r1[r3] = true
    end

    r24 = true
    r39:SetValues(r15)
    r39:SetValue(r1)
    r39:SetValues(r41)
    r24 = false
    r43(#r == 0e0 and "Cycle selection cleared" or "All ores selected")
end

r36.Mine:AddButton({
    Title = "Select All",
    Callback = function()
        local r = table.clone(r8.r6)

        for r1, r2 in ipairs(r15) do
            if not table.find(r, r2) then
                r[#r + 1e0] = r2
            end
        end

        r46(r)
    end,
})

r36.Mine:AddButton({
    Title = "Clear Selection",
    Callback = function()
        r46({})
    end,
})

r37 = r36.Mine:AddParagraph({ Title = "Cycle Order", Content = "" })
r42()

local r47 = r36.Mine:AddParagraph({ Title = "Mining", Content = "Waiting for mining" })

local r48 = r36.Mine:AddParagraph({
    Title = "Ore Progress",
    Content = "0% (" .. string.format(
        "%02d:%02d:%02d",
        math.floor(r8.duration / 3.6e3),
        math.floor(r8.duration / 6e1) % 6e1,
        r8.duration % 6e1
    ) .. " remaining)",
})

local r49 = Instance.new("Frame")
r49.Size = UDim2.new(1e0, -2e1, 0e0, 3e0)
r49.Position = UDim2.new(0e0, 1e1, 1e0, -5e0)
r49.BackgroundColor3 = Color3.fromRGB(4.5e1, 4.9e1, 6e1)
r49.BorderSizePixel = 0e0
r49.Parent = r48.Frame
local r50 = Instance.new("Frame")
r50.Size = UDim2.fromScale(0e0, 1e0)
r50.BackgroundColor3 = Color3.fromRGB(1.03e2, 1.48e2, 2.55e2)
r50.BorderSizePixel = 0e0
r50.Parent = r49

local function r51(r, r2)
    if r7.r3[r] then
        r7.r3[r]:Cancel()
    end

    if r.Size == r2.Size then
        return
    end

    local r3 = r1:Create(r, TweenInfo.new(1.8e-1, Enum.EasingStyle.Quad), r2)
    r7.r3[r] = r3

    r3.Completed:Once(function()
        if r7.r3[r] == r3 then
            r7.r3[r] = nil
        end
    end)

    r3:Play()
end

r44(r36.Gears, "r1", "Auto Upgrade")
r44(r36.Gears, "r2", "Auto Reset Normal → Shiny")

local function r52(r53, r, r1)
    local r2 = {}

    for r3, r4 in ipairs(r53.Container:GetDescendants()) do
        r2[r4] = true
    end

    local r3

    local function r54(r)
        if not r23 or r24 or not r7.r then
            return
        end

        local r2 = r == r12(r8[r1]) and r8[r1] or r14(r)

        if r2 and r2 > 0e0 and r2 ~= r8[r1] then
            r8[r1] = r2
            r17()
        elseif not r2 or r2 <= 0e0 then
        end

        r24 = true
        r3:SetValue(r12(r8[r1]))
        r24 = false
    end

    r3 = r53:AddInput(r1, {
        Title = r,
        Default = r12(r8[r1]),
        Description = "Accepts 25k, 1.5M, 2B, 1e6, or 1e6 (1M)",
        Numeric = false,
        Finished = true,
        Callback = r54,
    })

    for r4, r5 in ipairs(r53.Container:GetDescendants()) do
        if r5:IsA("TextBox") and not r2[r5] then
            r18(r5.Focused, function()
                r5.Text = r11(r8[r1], 1.6e1)
            end)

            r18(r5.FocusLost, function()
                if r5.Text ~= r12(r8[r1]) then
                    r54(r5.Text)
                end
            end)

            break
        end
    end
end

r52(r36.Gears, "Minimum Shiny per reset", "r4")
r44(r36.Gears, "r3", "Auto Reset Shiny → Life")
r52(r36.Gears, "Minimum Life per reset", "r5")

local r55 = r36.Monster:AddParagraph({ Title = "Monster Status", Content = "Monster automation is disabled" })
r44(r36.Monster, "monsterClick", "Auto Monster Click")
r44(r36.Monster, "monsterReset", "Auto Monster Sacrifice")
r52(r36.Monster, "Minimum gain per monster sacrifice", "monsterMinimum")
r44(r36.Monster, "monsterPerks", "Auto Monster Perks")
r44(r36.Monster, "monsterUpgrades", "Auto Sacrifice Upgrades")

r36.Monster:AddParagraph({
    Title = "Upgrade Priority",
    Content = "Perk 1 is requested first after a sacrifice, then the lowest displayed perk price is selected.\nSacrifice upgrades also use their lowest displayed Price.\nUnreadable prices pause purchases; maxed upgrades are skipped.",
})

local function r56(r)
    r = math.max(0e0, math.ceil(r))
    return string.format("%02d:%02d:%02d", math.floor(r / 3.6e3), math.floor(r / 6e1) % 6e1, r % 6e1)
end

local function r57(r)
    if type(r) ~= "string" then
        return nil
    end

    r = r:gsub("<[^>]+>", ""):gsub(",", "")
    local r1 = r14(r:gsub("^%s*%+", ""))

    if r1 then
        return r1
    end

    r1 = r:match("[%d%.]+[eE][+%-]?%d+")

    if r1 then
        return r14(r1)
    end

    local r2, r3 = r:match("([%d%.]+)%s*([%a]*)")
    return r2 and r14(r2 .. r3) or nil
end

local function r58(r, r1)
    for r2, r3 in ipairs(r1) do
        r = r and r:FindFirstChild(r3)
    end

    return r
end

local function r59(r)
    local r60 = r and r:FindFirstChild("Frame")
    local r61 = r and (r:FindFirstChild("Price") or r60 and r60:FindFirstChild("Price"))

    if not r61 then
        return nil, false
    end

    local r30

    if r61:IsA("TextLabel") or r61:IsA("TextButton") or r61:IsA("TextBox") then
        r30 = r61.Text
    elseif r61:IsA("StringValue") or r61:IsA("NumberValue") or r61:IsA("IntValue") then
        r30 = tostring(r61.Value)
    end

    if not r30 then
        return nil, false
    end

    local r62 = r30:gsub("<[^>]+>", ""):lower()

    if r62:find("max", 1e0, true) then
        return nil, true
    end

    if r62:match("^%s*free%s*$") then
        return 0e0, false
    end

    return r57(r30), false
end

local function r63(r, r64)
    if not r then
        return nil
    end

    local r65, r66

    for r67 = 1e0, r64 or 5e0 do
        local r68, r69 = r59(r:FindFirstChild("Upgrade" .. r67))

        if not r69 and r68 and (not r66 or r68 < r66) then
            r65, r66 = r67, r68
        end
    end

    return r65, r66
end

local function r70(r)
    if not r then
        return nil
    end

    if r:FindFirstChild("Upgrade1") and r:FindFirstChild("Upgrade7") then
        return r
    end

    local r71

    for r65, r72 in ipairs(r:GetDescendants()) do
        if
            r72.Name == "Upgrade1"
            and (
                r72:FindFirstChild("Price")
                or r72:FindFirstChild("Frame") and r72.Frame:FindFirstChild("Price")
            )
        then
            local r73 = r72.Parent

            if r73 and r73:FindFirstChild("Upgrade7") then
                if r71 and r71 ~= r73 then
                    return nil
                end

                r71 = r73
            end
        end
    end

    return r71
end

r20(function()
    local r74, r75, r76, r77 = 0e0, 0e0, 0e0, 0e0
    local r78 = 0e0
    local r79 = true
    local r80 = {}
    local r81 = 0e0
    local r82, r83, r84, r85, r86, r87, r88, r89
    local r90 = "Waiting for perk prices"
    local r91 = "Waiting for sacrifice upgrade prices"

    local function r92(r, r1, ...)
        if not r or not r:IsA("RemoteEvent") then
            if not r80[r1] then
                r80[r1] = true
            end

            return false
        end

        local r2, r3 = pcall(r.FireServer, r, ...)

        if not r2 then
            return false
        end

        r80[r1] = nil
        return true
    end

    while r7.r do
        local r93 = os.clock()

        if r93 >= r81 then
            r81 = r93 + 2e0
            r82 = r58(game:GetService("ReplicatedStorage"), { "Events" })
            r83 = r58(r, { "GameplayEvents", "MonsterGain" })
            r84 = r58(r82, { "MonsterEvolution", "MonsterSacrifice" })
            r85 = r58(r82, { "PerkUpgrade", "MonsterPerk" })
            r86 = r58(r82, { "MonsterEvolution", "SacrificeUpgrade" })
            r87 = r58(workspace, { "Boards", "MonsterSacrifice", "Sacrifice", "SurfaceGui", "Gain" })
            r88 = r58(workspace, { "Boards", "MonsterLevel", "MonsterPerks", "SurfaceGui", "Info", "List" })
            r89 = r70(r58(workspace, { "Boards", "MonsterSacrifice" }))
        end

        if r8.monsterClick and r93 >= r74 then
            r74 = r93 + 1e-1
            r92(r83, "Monster click")
        end

        local r94 = r87 and r57(r87.Text) or nil

        if r8.monsterReset and r93 >= r75 then
            r75 = r93 + 1e0

            if r94 and r94 >= r8.monsterMinimum and r92(r84, "Monster sacrifice") then
                r78 = r93 + 2e-1
                r79 = true
                r76 = r78
            elseif not r94 and not r80.Gain then
                r80.Gain = true
            end
        end

        if r94 then
            r80.Gain = nil
        end

        if r8.monsterPerks and r93 >= r76 and r93 >= r78 then
            r76 = r93 + 5e-1
            local r65, r66 = r63(r88)
            local r95, r96 = r59(r88 and r88:FindFirstChild("Upgrade1"))

            if r79 and not r96 then
                r65, r66 = r95 and 1e0 or nil, r95
            end

            if r65 then
                r90 = "Next perk: " .. r65 .. (r66 and " · " .. r12(r66) or " · priority purchase")

                if r92(r85, "Monster perk", r65) then
                    r79 = false
                end
            else
                r90 = "No readable perk prices, or all perks are maxed"
            end
        end

        if r8.monsterUpgrades and r93 >= r77 and r93 >= r78 then
            r77 = r93 + 5e-1
            local r65, r66 = r63(r89, 7e0)

            if r65 then
                r91 = "Next sacrifice upgrade: " .. r65 .. " · " .. r12(r66)
                r92(r86, "Sacrifice upgrade", r65)
            else
                r91 = "No readable sacrifice prices, or all upgrades are maxed"
            end
        end

        r30(
            r55,
            "Click: "
                .. (r8.monsterClick and "On" or "Off")
                .. " · Sacrifice: "
                .. (r8.monsterReset and "On" or "Off")
                .. "\nExpected sacrifice gain: "
                .. (r94 and r12(r94) or "Unavailable")
                .. "\nPerks: "
                .. (r8.monsterPerks and "On" or "Off")
                .. " · Sacrifice upgrades: "
                .. (r8.monsterUpgrades and "On" or "Off")
                .. (r8.monsterPerks and "\n" .. r90 or "")
                .. (r8.monsterUpgrades and "\n" .. r91 or "")
        )

        task.wait(1e-1)
    end
end)

local r97 = r36.Info:AddParagraph({ Title = "Gears", Content = "Loading statistics..." })
local r98 = r36.Info:AddParagraph({ Title = "Mining", Content = "" })
local r99 = r36.Info:AddParagraph({ Title = "Upgrades", Content = "" })

r36.Info:AddParagraph({
    Title = "How to Use",
    Content = "Ore duration is adjustable from 10 minutes to 4 hours.\nSelection order determines the sequence.\nK pauses or resumes mining.",
})

r36.Settings:AddSection("Interface")

r36.Settings:AddToggle("AutoHide", {
    Title = "Auto Hide UI",
    Description = "Starts minimized on the next run",
    Default = r8.hide,
    Callback = function(r)
        if not r23 or not r7.r or r8.hide == r then
            return
        end

        r8.hide = r
        r17()
    end,
})

r29 = r36.Settings:AddButton({
    Title = "Toggle Keybind · " .. r8.key,
    Description = "Click, then press a key. Escape cancels. K is reserved for mining.",
    Callback = function()
        r28 = true
        r29:SetTitle("Press a key · Escape cancels")
    end,
})

r36.Settings:AddSection("Exit")

r36.Settings:AddButton({
    Title = "Uninject",
    Description = "Saves configuration, stops automation, and removes the interface",
    Callback = function()
        r22:Dialog({
            Title = "Uninject",
            Content = "Stop Regrowth Incremental and remove its interface?",
            Buttons = {
                { Title = "Confirm", Callback = r31 },
                { Title = "Cancel" },
            },
        })
    end,
})

r18(r2.InputBegan, function(r, r1)
    if not r7.r or r2:GetFocusedTextBox() then
        return
    end

    if r28 then
        if r.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end

        if r.KeyCode == Enum.KeyCode.Escape then
            r28 = false
        elseif table.find({ "K", "Unknown", "F9", "F11", "F12", "PrintScreen" }, r.KeyCode.Name) then
            return
        else
            r8.key = r.KeyCode.Name
            r21.MinimizeKey.Name = r8.key
            r28 = false
            r17()
        end

        r29:SetTitle("Toggle Keybind · " .. r8.key)
        return
    end

    if r1 then
        return
    end

    if r.KeyCode.Name == r8.key then
        r22:Minimize()
    elseif r.KeyCode == Enum.KeyCode.K then
        r7.r4.r:SetValue(not r8.r)
    end
end)

r23 = true
r22:SelectTab(1e0)

if r8.hide then
    r21:Notify({
        Title = "Regrowth Incremental",
        Content = "Interface hidden. Press " .. r8.key .. " to open.",
        Duration = 6e0,
    })
end

r20(function()
    local r100 = r:WaitForChild("GameplayEvents", 1.5e1)
    local r101 = r:WaitForChild("Stats", 1.5e1)
    local r102 = game:GetService("ReplicatedStorage"):WaitForChild("Events", 1.5e1)

    if not r7.r then
        return
    end

    assert(r100 and r101 and r102, "GameplayEvents, Stats, or Events unavailable")
    local r103 = r100:WaitForChild("Mining", 1.5e1)
    local r104 = r103 and r103:WaitForChild("MineOre", 1.5e1)
    local r105 = r102:WaitForChild("GearsUpgrade", 1.5e1)
    local r106 = r105 and r105:WaitForChild("GearsReset", 1.5e1)
    local r107 = r102:WaitForChild("MineOre", 1.5e1)
    local r108 = r107 and r107:WaitForChild("SetDepth", 1.5e1)
    local r109 = r107 and r107:WaitForChild("MiningTier", 1.5e1)
    local r110 = r102:WaitForChild("AdjustSetting", 1.5e1)

    if not r7.r then
        return
    end

    assert(r104 and r105 and r106 and r108 and r109 and r110, "Mining remotes unavailable")

    local function r111(r)
        local r1 = r101:FindFirstChild(r)
        return r1 and tonumber(r1.Value) or 0e0
    end

    local function r112(r)
        local r1 = workspace:FindFirstChild("Boards")
        r1 = r1 and r1:FindFirstChild("GearTypes")
        r1 = r1 and r1:FindFirstChild("GearsReset")
        r1 = r1 and r1:FindFirstChild("SurfaceGui")
        r1 = r1 and r1:FindFirstChild("Info")
        r1 = r1 and r1:FindFirstChild("Gear" .. r)
        r1 = r1 and r1:FindFirstChild("NextGears")

        if not r1 then
            return 0e0
        end

        return r14(r1.Text:gsub("^%s*%+", "")) or 0e0
    end

    local r113 = { 5e1, 6.5e1, 8e1, 9.5e1, 1.2e2 }
    local r114 = { 0e0, 0e0, 0e0, 0e0, 0e0 }

    r20(function()
        while r7.r do
            if r8.r then
                local r = r8.r8 and r8.r6[r8.r9] or r8.r7

                if r8.r8 and #r8.r6 == 0e0 then
                    r = nil
                end

                if r and r ~= r7.r8 then
                    local r1 = r7.r10

                    local function r115()
                        return r7.r and r8.r and r1 == r7.r10
                    end

                    local function r116()
                        r110:FireServer(r9[r][2e0], "OreLuck")
                        task.wait(1.5e-1)

                        if not r115() then
                            return
                        end

                        r108:FireServer(r9[r][1e0])
                        task.wait(4e-1)

                        if not r115() then
                            return
                        end

                        r109:FireServer(1e0)
                        task.wait(1.5e-1)

                        if not r115() then
                            return
                        end

                        r109:FireServer(1e0)
                        task.wait(2e-1)

                        if r115() then
                            r7.r8 = r
                            r7.r7 = nil
                        end
                    end

                    r7.r5 = true
                    local r2, r3 = pcall(r116)
                    r7.r5 = false

                    if not r2 then
                        error(r3, 0e0)
                    end
                end

                if r and r8.r and r7.r8 == r then
                    local r1 = os.clock()
                    local r3 = r7.r10

                    for r2 = 1e0, 5e0 do
                        if not r7.r or not r8.r or r3 ~= r7.r10 then
                            break
                        end

                        r104:FireServer(r2)
                        task.wait(2e-2)
                    end

                    task.wait(5e-2)

                    if r8.r8 and r8.r and r3 == r7.r10 and r8.r6[r8.r9] == r then
                        r8.r10 = r8.r10 + os.clock() - r1

                        if r8.r10 >= r8.duration then
                            r8.r10 = r8.r10 % r8.duration
                            r8.r9 = r8.r9 % #r8.r6 + 1e0

                            r7.r8 = nil
                            r17()
                        end
                    end
                else
                    task.wait(2e-1)
                end
            else
                task.wait(2e-1)
            end
        end
    end)

    r20(function()
        while r7.r do
            if r8.r1 then
                for r = 5e0, 1e0, -1e0 do
                    if not r7.r or not r8.r1 then
                        break
                    end

                    if
                        (r == 1e0 or r111("GearsUpgrade" .. (r - 1e0)) >= r113[r - 1e0])
                        and r111("GearsUpgrade" .. r) < r113[r]
                        and os.clock() >= r114[r]
                    then
                        local r1 = r111("GearsUpgrade" .. r)
                        r105:FireServer(r, true)
                        task.wait(1e0)

                        if r1 == r111("GearsUpgrade" .. r) then
                            r114[r] = os.clock() + 1.5e1
                        else
                        end

                        task.wait(3e-1)
                    end
                end
            end

            task.wait(3e-1)
        end
    end)

    r20(function()
        while r7.r do
            if r8.r2 and r112(1e0) >= r8.r4 then
                r106:FireServer(1e0)
                task.wait(1e0)
            end

            if r8.r3 and r112(2e0) >= r8.r5 then
                r106:FireServer(2e0)
                task.wait(1e0)
            end

            task.wait(3e-1)
        end
    end)

    r20(function()
        while r7.r do
            r30(
                r97,
                string.format(
                    "Normal: %s\nShiny: %s\nLife: %s\nTitanic: %s",
                    r12(r111("Gears")),
                    r12(r111("Gears2")),
                    r12(r111("Gears3")),
                    r12(r111("Gears4"))
                )
            )

            r30(
                r98,
                string.format("Depth: %s\nOre luck: %s", r12(r111("MiningDepth")), r12(r111("CustomOreLuck")))
            )

            local r = {}

            for r1 = 1e0, 5e0 do
                table.insert(
                    r,
                    string.format("Upgrade %d: %s / %s", r1, r12(r111("GearsUpgrade" .. r1)), r12(r113[r1]))
                )
            end

            r30(r99, table.concat(r, "\n"))
            task.wait(5e-1)
        end
    end)
end)

r20(function()
    local r = os.clock()

    while r7.r do
        local r1 = math.ceil(math.max(0e0, r8.duration - r8.r10))

        r30(
            r47,
            r7.r7
                or (
                    r7.r5 and "Applying ore setup..."
                    or (
                        (r8.r and "Active: " or "Paused: ")
                        .. (r7.r8 or "—")
                        .. (
                            r8.r8
                                and string.format(
                                    "\n%02d:%02d:%02d remaining · %d/%d",
                                    math.floor(r1 / 3.6e3),
                                    math.floor(r1 / 6e1) % 6e1,
                                    r1 % 6e1,
                                    r8.r9,
                                    #r8.r6
                                )
                            or ""
                        )
                    )
                )
        )

        if r8.r8 and #r8.r6 == 0e0 then
            r30(r47, "Select at least one ore")
        end

        r51(r50, { Size = UDim2.fromScale(r8.r8 and math.clamp(r8.r10 / r8.duration, 0e0, 1e0) or 0e0, 1e0) })
        r30(rSaveStatus, r7.r6 or "Automatic configuration")

        r30(
            r48,
            string
                .format("%.1f", r8.r8 and math.clamp(r8.r10 / r8.duration * 1e2, 0e0, 1e2) or 0e0)
                :gsub("%.0$", "")
                .. "% ("
                .. r56(r8.duration - r8.r10)
                .. " remaining)"
        )

        if os.clock() - r >= 3e1 then
            r17()
            r = os.clock()
        end

        task.wait(5e-1)
    end
end)

r17()

]====]

local r1, r2 = loadstring(r, "=Regrowth.Main.Recovery")

if not r1 then
    error("[Regrowth.Main syntax] " .. tostring(r2), 0e0)
end

local r3, r4 = xpcall(r1, debug.traceback)

if not r3 then
    warn("[Regrowth.Main runtime] " .. tostring(r4))
    error(r4, 0e0)
end
