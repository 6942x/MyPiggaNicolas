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
    Monster = r22:AddTab({ Title = "Monster", Icon = "skull" }),
    Info = r22:AddTab({ Title = "Info", Icon = "info" }),
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
    if not r then
        return false
    end

    local r60 = r:GetDescendants()
    table.insert(r60, 1e0, r)

    for r61, r62 in ipairs(r60) do
        local r63 = true
        local r64 = r62

        while r64 and r64 ~= r.Parent do
            if r64:IsA("GuiObject") and not r64.Visible then
                r63 = false
                break
            end

            r64 = r64.Parent
        end

        if r63 then
            local r65, r66 = pcall(function()
                return r62:GetAttributes()
            end)

            if r65 then
                for r67, r68 in pairs(r66) do
                    local r69 = r67:lower()

                    if
                        (r69 == "maxed" or r69 == "ismaxed" or r69 == "completed" or r69 == "ismaxlevel")
                        and r68 == true
                    then
                        return true
                    end
                end

                local r70 = tonumber(r66.Level or r66.CurrentLevel)
                local r71 = tonumber(r66.MaxLevel or r66.LevelCap)

                if r70 and r71 and r71 > 0e0 and r70 >= r71 then
                    return true
                end
            end

            if r62:IsA("TextLabel") or r62:IsA("TextButton") or r62:IsA("TextBox") then
                local r68 = r62.Text:gsub("<[^>]+>", ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
                local r69 = r62.Name:lower()

                if
                    r68:match("^max[!%.]*$")
                    or r68:find("maxed", 1e0, true)
                    or r68 == "maximum"
                    or r68 == "max level"
                    or r68 == "completed"
                    or r68 == "fully upgraded"
                then
                    return true
                end

                if r69:find("level", 1e0, true) or r68:find("level", 1e0, true) then
                    local r70, r71 = r68:match("(%d+)%s*/%s*(%d+)")

                    if r70 and tonumber(r71) > 0e0 and tonumber(r70) >= tonumber(r71) then
                        return true
                    end

                    if r68:find("(max)", 1e0, true) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

local function r72(r)
    if r59(r) then
        return nil, true
    end

    local r73 = r and r:FindFirstChild("Frame")
    local r74 = r and (r:FindFirstChild("Price") or r73 and r73:FindFirstChild("Price"))

    if not r74 then
        return nil, false
    end

    local r30

    if r74:IsA("TextLabel") or r74:IsA("TextButton") or r74:IsA("TextBox") then
        r30 = r74.Text
    elseif r74:IsA("StringValue") or r74:IsA("NumberValue") or r74:IsA("IntValue") then
        r30 = tostring(r74.Value)
    end

    if not r30 then
        return nil, false
    end

    local r75 = r30:gsub("<[^>]+>", ""):lower()

    if r75:gsub("%s", "") == "1,234" then
        return nil, true
    end

    if r75:find("max", 1e0, true) then
        return nil, true
    end

    if r75:match("^%s*free%s*$") then
        return 0e0, false
    end

    return r57(r30), false
end

local function r76(r, r77)
    if not r then
        return nil
    end

    local r61, r78

    for r79 = 1e0, r77 or 5e0 do
        local r68, r80 = r72(r:FindFirstChild("Upgrade" .. r79))

        if not r80 and r68 and (not r78 or r68 < r78) then
            r61, r78 = r79, r68
        end
    end

    return r61, r78
end

local function r81(r)
    if not r then
        return nil
    end

    if r:FindFirstChild("Upgrade1") and r:FindFirstChild("Upgrade7") then
        return r
    end

    local r82

    for r61, r62 in ipairs(r:GetDescendants()) do
        if
            r62.Name == "Upgrade1"
            and (
                r62:FindFirstChild("Price")
                or r62:FindFirstChild("Frame") and r62.Frame:FindFirstChild("Price")
            )
        then
            local r64 = r62.Parent

            if r64 and r64:FindFirstChild("Upgrade7") then
                if r82 and r82 ~= r64 then
                    return nil
                end

                r82 = r64
            end
        end
    end

    return r82
end

r20(function()
    local r83, r84, r85, r86 = 0e0, 0e0, 0e0, 0e0
    local r87 = 0e0
    local r88 = true
    local r89 = {}
    local r90 = 0e0
    local r91, r92, r93, r94, r95, r96, r97, r98
    local r99 = "Waiting for perk prices"
    local r100 = "Waiting for sacrifice upgrade prices"

    local function r101(r, r1, ...)
        if not r or not r:IsA("RemoteEvent") then
            if not r89[r1] then
                r89[r1] = true
            end

            return false
        end

        local r2, r3 = pcall(r.FireServer, r, ...)

        if not r2 then
            return false
        end

        r89[r1] = nil
        return true
    end

    while r7.r do
        local r102 = os.clock()

        if r102 >= r90 then
            r90 = r102 + 2e0
            r91 = r58(game:GetService("ReplicatedStorage"), { "Events" })
            r92 = r58(r, { "GameplayEvents", "MonsterGain" })
            r93 = r58(r91, { "MonsterEvolution", "MonsterSacrifice" })
            r94 = r58(r91, { "PerkUpgrade", "MonsterPerk" })
            r95 = r58(r91, { "MonsterEvolution", "SacrificeUpgrade" })
            r96 = r58(workspace, { "Boards", "MonsterSacrifice", "Sacrifice", "SurfaceGui", "Gain" })
            r97 = r58(workspace, { "Boards", "MonsterLevel", "MonsterPerks", "SurfaceGui", "Info", "List" })
            r98 = r81(r58(workspace, { "Boards", "MonsterSacrifice" })) or r81(r58(workspace, { "Boards" }))
        end

        if r8.monsterClick and r102 >= r83 then
            r83 = r102 + 1e-1
            r101(r92, "Monster click")
        end

        local r103 = r96 and r57(r96.Text) or nil

        if r8.monsterReset and r102 >= r84 then
            r84 = r102 + 1e0

            if r103 and r103 >= r8.monsterMinimum and r101(r93, "Monster sacrifice") then
                r87 = r102 + 2e-1
                r88 = true
                r85 = r87
            elseif not r103 and not r89.Gain then
                r89.Gain = true
            end
        end

        if r103 then
            r89.Gain = nil
        end

        if r8.monsterPerks and r102 >= r85 and r102 >= r87 then
            r85 = r102 + 5e-1
            local r61, r78 = r76(r97)
            local r104, r105 = r72(r97 and r97:FindFirstChild("Upgrade1"))

            if r88 and not r105 and r104 then
                r61, r78 = 1e0, r104
            end

            if r61 then
                r99 = "Next perk: " .. r61 .. (r78 and " · " .. r12(r78) or " · priority purchase")

                if r101(r94, "Monster perk", r61) then
                    r88 = false
                end
            else
                r99 = "No readable perk prices, or all perks are maxed"
            end
        end

        if r8.monsterUpgrades and r102 >= r86 and r102 >= r87 then
            r86 = r102 + 5e-1
            local r61, r78 = r76(r98, 7e0)
            local r106 = r:FindFirstChild("Stats")
            local r107 = r106 and r106:FindFirstChild("Dark Liquid")
            local r108 = r107 and r14(r107.Value)

            if not r108 then
                r100 = "Dark Liquid balance unavailable; purchases paused"
            elseif r61 and r78 <= r108 then
                r100 = "Next sacrifice upgrade: " .. r61 .. " · " .. r12(r78)
                r101(r95, "Sacrifice upgrade", r61)
            elseif r61 then
                r100 = "Waiting for Dark Liquid: " .. r12(r108) .. " / " .. r12(r78)
            else
                r100 = "No readable sacrifice prices, or all upgrades are maxed"
            end
        end

        r30(
            r55,
            "Click: "
                .. (r8.monsterClick and "On" or "Off")
                .. " · Sacrifice: "
                .. (r8.monsterReset and "On" or "Off")
                .. "\nExpected sacrifice gain: "
                .. (r103 and r12(r103) or "Unavailable")
                .. "\nPerks: "
                .. (r8.monsterPerks and "On" or "Off")
                .. " · Sacrifice upgrades: "
                .. (r8.monsterUpgrades and "On" or "Off")
                .. (r8.monsterPerks and "\n" .. r99 or "")
                .. (r8.monsterUpgrades and "\n" .. r100 or "")
        )

        task.wait(1e-1)
    end
end)

local r109 = r36.Info:AddParagraph({ Title = "Gears", Content = "Loading statistics..." })
local r110 = r36.Info:AddParagraph({ Title = "Mining", Content = "" })
local r111 = r36.Info:AddParagraph({ Title = "Upgrades", Content = "" })

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
    local r112 = r:WaitForChild("GameplayEvents", 1.5e1)
    local r113 = r:WaitForChild("Stats", 1.5e1)
    local r114 = game:GetService("ReplicatedStorage"):WaitForChild("Events", 1.5e1)

    if not r7.r then
        return
    end

    assert(r112 and r113 and r114, "GameplayEvents, Stats, or Events unavailable")
    local r115 = r112:WaitForChild("Mining", 1.5e1)
    local r116 = r115 and r115:WaitForChild("MineOre", 1.5e1)
    local r117 = r114:WaitForChild("GearsUpgrade", 1.5e1)
    local r118 = r117 and r117:WaitForChild("GearsReset", 1.5e1)
    local r119 = r114:WaitForChild("MineOre", 1.5e1)
    local r120 = r119 and r119:WaitForChild("SetDepth", 1.5e1)
    local r121 = r119 and r119:WaitForChild("MiningTier", 1.5e1)
    local r122 = r114:WaitForChild("AdjustSetting", 1.5e1)

    if not r7.r then
        return
    end

    assert(r116 and r117 and r118 and r120 and r121 and r122, "Mining remotes unavailable")

    local function r123(r)
        local r1 = r113:FindFirstChild(r)
        return r1 and tonumber(r1.Value) or 0e0
    end

    local function r124(r)
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

    local r125 = { 5e1, 6.5e1, 8e1, 9.5e1, 1.2e2 }
    local r126 = { 0e0, 0e0, 0e0, 0e0, 0e0 }

    r20(function()
        while r7.r do
            if r8.r then
                local r = r8.r8 and r8.r6[r8.r9] or r8.r7

                if r8.r8 and #r8.r6 == 0e0 then
                    r = nil
                end

                if r and r ~= r7.r8 then
                    local r1 = r7.r10

                    local function r127()
                        return r7.r and r8.r and r1 == r7.r10
                    end

                    local function r128()
                        r122:FireServer(r9[r][2e0], "OreLuck")
                        task.wait(1.5e-1)

                        if not r127() then
                            return
                        end

                        r120:FireServer(r9[r][1e0])
                        task.wait(4e-1)

                        if not r127() then
                            return
                        end

                        r121:FireServer(1e0)
                        task.wait(1.5e-1)

                        if not r127() then
                            return
                        end

                        r121:FireServer(1e0)
                        task.wait(2e-1)

                        if r127() then
                            r7.r8 = r
                            r7.r7 = nil
                        end
                    end

                    r7.r5 = true
                    local r2, r3 = pcall(r128)
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

                        r116:FireServer(r2)
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
                        (r == 1e0 or r123("GearsUpgrade" .. (r - 1e0)) >= r125[r - 1e0])
                        and r123("GearsUpgrade" .. r) < r125[r]
                        and os.clock() >= r126[r]
                    then
                        local r1 = r123("GearsUpgrade" .. r)
                        r117:FireServer(r, true)
                        task.wait(1e0)

                        if r1 == r123("GearsUpgrade" .. r) then
                            r126[r] = os.clock() + 1.5e1
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
            if r8.r2 and r124(1e0) >= r8.r4 then
                r118:FireServer(1e0)
                task.wait(1e0)
            end

            if r8.r3 and r124(2e0) >= r8.r5 then
                r118:FireServer(2e0)
                task.wait(1e0)
            end

            task.wait(3e-1)
        end
    end)

    r20(function()
        while r7.r do
            r30(
                r109,
                string.format(
                    "Normal: %s\nShiny: %s\nLife: %s\nTitanic: %s",
                    r12(r123("Gears")),
                    r12(r123("Gears2")),
                    r12(r123("Gears3")),
                    r12(r123("Gears4"))
                )
            )

            r30(
                r110,
                string.format("Depth: %s\nOre luck: %s", r12(r123("MiningDepth")), r12(r123("CustomOreLuck")))
            )

            local r = {}

            for r1 = 1e0, 5e0 do
                table.insert(
                    r,
                    string.format("Upgrade %d: %s / %s", r1, r12(r123("GearsUpgrade" .. r1)), r12(r125[r1]))
                )
            end

            r30(r111, table.concat(r, "\n"))
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
