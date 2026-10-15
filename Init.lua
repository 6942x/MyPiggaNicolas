local r = game:GetService("Players").LocalPlayer
local r1 = game:GetService("TweenService")
local r2 = game:GetService("UserInputService")
local r3 = game:GetService("HttpService")
local r4 = type(getgenv) == "function" and getgenv() or shared

if not r then
    warn("[Auto Farm] Execute dentro do cliente do jogo")
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

    for r1, r2 in ipairs({ "r4", "r5" }) do
        if type(r[r2]) == "number" and r[r2] > 0e0 and r[r2] < math.huge then
            r8[r2] = r[r2]
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
    r8.r10 = math.clamp(r14(r.r10) or 0e0, 0e0, 7.2e3)
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

        r7.r6 = r and "Config salva" or "Falha ao salvar arquivo"
    else
        r7.r6 = "Config salva nesta sessão"
    end
end

local function r18(r, r1)
    local r2 = r:Connect(r1)
    table.insert(r7.r1, r2)
    return r2
end

local function r19(r)
    local r1 = task.defer(function()
        if r7.r then
            local r1, r2 = xpcall(r, debug.traceback)

            if not r1 and r7.r then
                r7.r7 = tostring(r2)
                warn(r2)
            end
        end

        r7.r2[coroutine.running()] = nil
    end)

    r7.r2[r1] = true
    return r1
end

local function r20(r, r2)
    if r7.r3[r] then
        r7.r3[r]:Cancel()
    end

    local r3 = false

    for r4, r5 in pairs(r2) do
        if r[r4] ~= r5 then
            r3 = true
            break
        end
    end

    if not r3 then
        r7.r3[r] = nil
        return
    end

    local r4 = r1:Create(r, TweenInfo.new(1.8e-1, Enum.EasingStyle.Quad), r2)
    r7.r3[r] = r4

    r4.Completed:Once(function()
        if r7.r3[r] == r4 then
            r7.r3[r] = nil
        end
    end)

    r4:Play()
end

local function r21(r, r1, r2)
    local r3 = Instance.new(r)

    for r4, r5 in pairs(r2 or {}) do
        r3[r4] = r5
    end

    r3.Parent = r1
    return r3
end

local function r22(r, r1)
    r21("UICorner", r, { CornerRadius = UDim.new(0e0, r1 or 8e0) })
end

local r23 = r:WaitForChild("PlayerGui", 1.5e1)

if not r7.r then
    return
end

assert(r23, "PlayerGui indisponível")
local r24 = r23:FindFirstChild("AutoFarmUI")

if r24 then
    local r = r24:FindFirstChild("Stop")

    if r and r:IsA("BindableEvent") then
        r:Fire()
    end

    r24:Destroy()
end

local r25 = r21("ScreenGui", r23, {
    Name = "AutoFarmUI",
    ResetOnSpawn = false,
    DisplayOrder = 9.99e2,
    ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local r26 = Color3.fromRGB(1.5e1, 1.7e1, 2.3e1)
local r27 = Color3.fromRGB(2.3e1, 2.7e1, 3.6e1)
local r28 = Color3.fromRGB(1.03e2, 1.48e2, 2.55e2)
local r29 = Color3.fromRGB(2.38e2, 2.38e2, 2.45e2)

local r30 = r21("Frame", r25, {
    Size = UDim2.new(1e0, -2.4e1, 1e0, -4.8e1),
    Position = UDim2.fromScale(5e-1, 5e-1),
    AnchorPoint = Vector2.new(5e-1, 5e-1),
    BackgroundColor3 = r26,
    BorderSizePixel = 0e0,
})

r21("UISizeConstraint", r30, { MaxSize = Vector2.new(4.3e2, 6e2) })
r22(r30, 1.2e1)
r21("UIStroke", r30, { Color = Color3.fromRGB(5.5e1, 5.5e1, 7e1) })

local r31 = r21("TextLabel", r30, {
    Size = UDim2.new(1e0, -1e2, 0e0, 4.4e1),
    Position = UDim2.fromOffset(1.6e1, 0e0),
    BackgroundTransparency = 1e0,
    Text = "Auto Farm",
    Font = Enum.Font.GothamBold,
    TextSize = 1.6e1,
    TextColor3 = r29,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local r32 = r21("TextButton", r30, {
    Size = UDim2.fromOffset(6.2e1, 3e1),
    Position = UDim2.new(1e0, -7.6e1, 0e0, 7e0),
    BackgroundColor3 = r27,
    Text = "Fechar",
    TextColor3 = r29,
    TextSize = 1.2e1,
    Font = Enum.Font.GothamMedium,
    BorderSizePixel = 0e0,
})

r22(r32)
local r33, r34 = {}, {}

local r35 = r21("Frame", r30, {
    Size = UDim2.new(1e0, -2.8e1, 0e0, 4.2e1),
    Position = UDim2.fromOffset(1.4e1, 4.8e1),
    BackgroundColor3 = r27,
    BorderSizePixel = 0e0,
})

r22(r35, 9e0)

local r36 = r21("TextLabel", r30, {
    Size = UDim2.new(1e0, -2.8e1, 0e0, 2.4e1),
    Position = UDim2.new(0e0, 1.4e1, 1e0, -2.8e1),
    BackgroundTransparency = 1e0,
    Font = Enum.Font.Gotham,
    TextSize = 1.1e1,
    TextColor3 = Color3.fromRGB(1.39e2, 1.51e2, 1.73e2),
    TextXAlignment = Enum.TextXAlignment.Left,
    Text = "Configuração automática",
})

local r37 = "Mine"
local r38

local function r39(r)
    r37 = r

    if r38 then
        r38(false)
    end

    for r1, r2 in pairs(r33) do
        r2.Visible = r1 == r

        r20(r34[r1], {
            BackgroundTransparency = r1 == r and 0e0 or 1e0,
            TextColor3 = r1 == r and r29 or Color3.fromRGB(1.39e2, 1.51e2, 1.73e2),
        })
    end
end

local function r40(r, r1)
    local r2 = r21("ScrollingFrame", r30, {
        Name = r,
        Size = UDim2.new(1e0, -2.8e1, 1e0, -1.32e2),
        Position = UDim2.fromOffset(1.4e1, 1e2),
        BackgroundTransparency = 1e0,
        BorderSizePixel = 0e0,
        ScrollBarThickness = 3e0,
        ScrollBarImageColor3 = r28,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = r == "Mine",
    })

    r21("UIListLayout", r2, { Padding = UDim.new(0e0, 1e1), SortOrder = Enum.SortOrder.LayoutOrder })
    r21("UIPadding", r2, { PaddingRight = UDim.new(0e0, 6e0), PaddingBottom = UDim.new(0e0, 8e0) })

    local r3 = r21("TextButton", r35, {
        Size = UDim2.new(1e0 / 3e0, -8e0, 1e0, -8e0),
        Position = UDim2.new((r1 - 1e0) / 3e0, 4e0, 0e0, 4e0),
        BackgroundColor3 = Color3.fromRGB(4.2e1, 5.3e1, 7.7e1),
        BackgroundTransparency = 1e0,
        BorderSizePixel = 0e0,
        Text = r,
        TextSize = 1.3e1,
        Font = Enum.Font.GothamMedium,
        TextColor3 = r29,
        AutoButtonColor = false,
    })

    r22(r3, 7e0)
    r33[r] = r2
    r34[r] = r3

    r18(r3.Activated, function()
        r39(r)
    end)

    return r2
end

local r41 = r40("Mine", 1e0)
r40("Gears", 2e0)
r40("Info", 3e0)
r39("Mine")
local r42 = 0e0

local function r43(r, r1)
    r42 = r42 + 1e0

    local r2 = r21(r or "Frame", r41, {
        Size = UDim2.new(1e0, 0e0, 0e0, r1 or 4.2e1),
        BackgroundColor3 = r27,
        BorderSizePixel = 0e0,
        LayoutOrder = r42,
    })

    r22(r2)
    return r2
end

local function r44(r, r1)
    return r21("TextLabel", r, {
        Size = UDim2.new(1e0, -2e1, 1e0, 0e0),
        Position = UDim2.fromOffset(1e1, 0e0),
        BackgroundTransparency = 1e0,
        Text = r1,
        Font = Enum.Font.Gotham,
        TextSize = 1.3e1,
        TextColor3 = r29,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
end

local r45

local function r46(r, r1)
    local r2 = r43("TextButton")
    r2.Text = ""
    r2.AutoButtonColor = false
    local r3 = r44(r2, r)
    r3.Size = UDim2.new(1e0, -8.2e1, 1e0, 0e0)

    local r4 = r21("Frame", r2, {
        Size = UDim2.fromOffset(4.6e1, 2.4e1),
        Position = UDim2.new(1e0, -5.8e1, 5e-1, -1.2e1),
        BorderSizePixel = 0e0,
        BackgroundColor3 = r26,
    })

    r22(r4, 1.2e1)

    local r5 = r21("Frame", r4, {
        Size = UDim2.fromOffset(1.8e1, 1.8e1),
        Position = UDim2.fromOffset(3e0, 3e0),
        BorderSizePixel = 0e0,
        BackgroundColor3 = r29,
    })

    r22(r5, 9e0)

    local function r6()
        r20(r4, { BackgroundColor3 = r8[r1] and r28 or Color3.fromRGB(6.5e1, 6.5e1, 7.8e1) })
        r20(r5, { Position = UDim2.fromOffset(r8[r1] and 2.5e1 or 3e0, 3e0) })
    end

    r7.r4[r1] = r6

    r18(r2.Activated, function()
        r8[r1] = not r8[r1]

        if r1 == "r" then
            r7.r10 = r7.r10 + 1e0
        end

        if r1 == "r8" then
            r8.r9 = 1e0
            r8.r10 = 0e0
            r7.r8 = nil
            r7.r10 = r7.r10 + 1e0
        end

        r6()
        r17()

        if r45 then
            r45()
        end
    end)

    r6()
end

r46("Auto Mine · K", "r")
r46("Multi ores · 2 horas por minério", "r8")
local r47 = r43("TextButton", 4.8e1)
r47.Text = ""
r47.AutoButtonColor = false
local r48 = r44(r47, "")
r48.Size = UDim2.new(1e0, -8.2e1, 1e0, 0e0)
r48.TextTruncate = Enum.TextTruncate.AtEnd

local r49 = r21("TextLabel", r47, {
    Size = UDim2.fromOffset(6.6e1, 4.8e1),
    Position = UDim2.new(1e0, -7.6e1, 0e0, 0e0),
    BackgroundTransparency = 1e0,
    Text = "Abrir",
    TextSize = 1.2e1,
    Font = Enum.Font.GothamMedium,
    TextColor3 = r28,
    TextXAlignment = Enum.TextXAlignment.Right,
})

local r50 = r43("Frame", 0e0)
r50.Visible = false
r50.ClipsDescendants = true

local r51 = r21("TextBox", r50, {
    Size = UDim2.new(1e0, -2e1, 0e0, 4e1),
    Position = UDim2.fromOffset(1e1, 1e1),
    BackgroundColor3 = r26,
    BorderSizePixel = 0e0,
    Text = "",
    PlaceholderText = "Buscar minério...",
    PlaceholderColor3 = Color3.fromRGB(1.39e2, 1.51e2, 1.73e2),
    TextColor3 = r29,
    Font = Enum.Font.Gotham,
    TextSize = 1.3e1,
    ClearTextOnFocus = false,
})

r22(r51, 7e0)

local r52 = r21("Frame", r50, {
    Size = UDim2.new(1e0, -2e1, 0e0, 3.6e1),
    Position = UDim2.fromOffset(1e1, 5.8e1),
    BackgroundTransparency = 1e0,
})

local function r53(r, r1)
    local r2 = r21("TextButton", r52, {
        Size = UDim2.new(5e-1, -4e0, 1e0, 0e0),
        Position = UDim2.new(r1, r1 == 0e0 and 0e0 or 4e0, 0e0, 0e0),
        BackgroundColor3 = Color3.fromRGB(3.5e1, 4.2e1, 5.7e1),
        BorderSizePixel = 0e0,
        Text = r,
        TextColor3 = r29,
        TextSize = 1.2e1,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
    })

    r22(r2, 6e0)
    return r2
end

local r54 = r53("Selecionar todos", 0e0)
local r55 = r53("Limpar seleção", 5e-1)

local r56 = r21("ScrollingFrame", r50, {
    Size = UDim2.new(1e0, -2e1, 1e0, -1.1e2),
    Position = UDim2.fromOffset(1e1, 1.02e2),
    BackgroundTransparency = 1e0,
    BorderSizePixel = 0e0,
    ScrollBarThickness = 3e0,
    ScrollBarImageColor3 = r28,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
})

r21("UIListLayout", r56, { Padding = UDim.new(0e0, 4e0), SortOrder = Enum.SortOrder.LayoutOrder })

local r57 = r21("TextLabel", r56, {
    Size = UDim2.new(1e0, -6e0, 0e0, 4.4e1),
    BackgroundTransparency = 1e0,
    Text = "Nenhum minério encontrado",
    TextColor3 = Color3.fromRGB(1.39e2, 1.51e2, 1.73e2),
    Font = Enum.Font.Gotham,
    TextSize = 1.3e1,
    Visible = false,
    LayoutOrder = 1e2,
})

local r58 = {}
local r59 = false

r38 = function(r)
    r59 = r
    r49.Text = r and "Fechar" or "Abrir"

    if r then
        r50.Visible = true
    end

    r20(r50, { Size = UDim2.new(1e0, 0e0, 0e0, r and 2.86e2 or 0e0) })

    if not r then
        r51:ReleaseFocus()

        r19(function()
            task.wait(2e-1)

            if not r59 then
                r50.Visible = false
            end
        end)
    end
end

r45 = function()
    r48.Text = r8.r8 and ("Multi ores  /  " .. #r8.r6 .. " selecionados") or ("Minério  /  " .. r8.r7)
    r54.Visible = r8.r8
    r55.Visible = r8.r8
    r52.Visible = r8.r8
    r56.Position = UDim2.fromOffset(1e1, r8.r8 and 1.02e2 or 5.8e1)
    r56.Size = UDim2.new(1e0, -2e1, 1e0, r8.r8 and -1.1e2 or -6.6e1)
    local r2 = r51.Text:lower()
    local r3 = 0e0

    for r, r1 in pairs(r58) do
        local r4 = r8.r8 and table.find(r8.r6, r) or (not r8.r8 and r8.r7 == r)
        r1.r.Visible = r:lower():find(r2, 1e0, true) ~= nil

        if r1.r.Visible then
            r3 = r3 + 1e0
        end

        r1.r1.Text = r
        r1.r2.BackgroundColor3 = r4 and r28 or Color3.fromRGB(4.9e1, 5.7e1, 7.3e1)
        r1.r3.Text = r4 and (r8.r8 and tostring(r4) or "") or ""
        r1.r.BackgroundColor3 = r4 and Color3.fromRGB(3.5e1, 4.6e1, 6.8e1) or r27
    end

    r57.Visible = r3 == 0e0
end

local function r60()
    r8.r9 = 1e0
    r8.r10 = 0e0
    r7.r8 = nil
    r7.r10 = r7.r10 + 1e0
    r45()
    r17()
end

r18(r47.Activated, function()
    r38(not r59)
end)

r18(r51:GetPropertyChangedSignal("Text"), r45)

r18(r54.Activated, function()
    for r, r1 in ipairs(r15) do
        if not table.find(r8.r6, r1) then
            table.insert(r8.r6, r1)
        end
    end

    r60()
end)

r18(r55.Activated, function()
    table.clear(r8.r6)
    r60()
end)

for r, r1 in ipairs(r15) do
    local r2 = r21("TextButton", r56, {
        Size = UDim2.new(1e0, -6e0, 0e0, 4.4e1),
        BackgroundColor3 = r27,
        BorderSizePixel = 0e0,
        Text = "",
        LayoutOrder = r,
        AutoButtonColor = false,
    })

    r22(r2, 7e0)
    local r3 = r44(r2, r1)
    r3.Position = UDim2.fromOffset(4.2e1, 0e0)
    r3.Size = UDim2.new(1e0, -5.4e1, 1e0, 0e0)

    local r4 = r21("Frame", r2, {
        Size = UDim2.fromOffset(2.4e1, 2.4e1),
        Position = UDim2.new(0e0, 1e1, 5e-1, -1.2e1),
        BackgroundColor3 = r26,
        BorderSizePixel = 0e0,
    })

    r22(r4, 6e0)

    local r5 = r21("TextLabel", r4, {
        Size = UDim2.fromScale(1e0, 1e0),
        BackgroundTransparency = 1e0,
        Text = "",
        TextColor3 = r26,
        TextSize = 1.2e1,
        Font = Enum.Font.GothamBold,
    })

    r58[r1] = { r = r2, r1 = r3, r2 = r4, r3 = r5 }

    r18(r2.Activated, function()
        if r8.r8 then
            local r = table.find(r8.r6, r1)

            if r then
                table.remove(r8.r6, r)
            else
                table.insert(r8.r6, r1)
            end
        else
            r8.r7 = r1
            r38(false)
        end

        r60()
    end)
end

r45()
local r61 = r44(r43(nil, 6.4e1), "Aguardando mineração")
r61.TextWrapped = true
local r62 = r43(nil, 4e0)
r62.BackgroundColor3 = Color3.fromRGB(3.5e1, 4.2e1, 5.7e1)
local r63 =
    r21("Frame", r62, { Size = UDim2.fromScale(0e0, 1e0), BackgroundColor3 = r28, BorderSizePixel = 0e0 })
r22(r63, 3e0)
r41 = r33.Gears
r46("Auto Upgrade", "r1")
r46("Auto Reset Normal → Shiny", "r2")

local function r64(r, r1)
    local r2 = r43(nil, 6.2e1)
    local r3 = r44(r2, r)
    r3.Size = UDim2.new(1e0, -2e1, 0e0, 2.6e1)

    local r4 = r21("TextBox", r2, {
        Size = UDim2.new(1e0, -2e1, 0e0, 2.6e1),
        Position = UDim2.fromOffset(1e1, 2.8e1),
        Text = r12(r8[r1]),
        ClearTextOnFocus = false,
        BackgroundColor3 = r26,
        TextColor3 = r29,
        TextSize = 1.2e1,
        Font = Enum.Font.Gotham,
        BorderSizePixel = 0e0,
    })

    r22(r4, 5e0)

    r18(r4.Focused, function()
        r4.Text = r11(r8[r1], 1.6e1)
    end)

    r18(r4.FocusLost, function()
        local r6 = r4.Text == r12(r8[r1]) and r8[r1] or r14(r4.Text)

        if r6 and r6 > 0e0 and r6 < math.huge then
            r8[r1] = r6
            r17()
        end

        r4.Text = r12(r8[r1])
    end)
end

r64("Mínimo de Shiny por reset", "r4")
r46("Auto Reset Shiny → Life", "r3")
r64("Mínimo de Life por reset", "r5")
r41 = r33.Info
local r65 = r44(r43(nil, 1.12e2), "Carregando estatísticas...")
r65.TextWrapped = true
local r66 = r44(r43(nil, 6e1), "")
r66.TextWrapped = true
local r67 = r44(r43(nil, 1.5e2), "")
r67.TextWrapped = true

local r68 = r44(
    r43(nil, 6.6e1),
    "Ciclo de 2 horas por minério.\nA numeração da seleção define a ordem.\nK pausa ou retoma a mineração."
)

r68.TextWrapped = true
local r69 = r21("BindableEvent", r25, { Name = "Stop" })
r7.r = true

r7.r9 = function()
    if not r7.r then
        return
    end

    r7.r = false
    r17()

    for r, r1 in ipairs(r7.r1) do
        r1:Disconnect()
    end

    for r, r1 in pairs(r7.r2) do
        if r ~= coroutine.running() and coroutine.status(r) ~= "dead" then
            pcall(task.cancel, r)
        end
    end

    for r, r1 in pairs(r7.r3) do
        r1:Cancel()
    end

    table.clear(r7.r1)
    table.clear(r7.r2)
    table.clear(r7.r3)
    r25:Destroy()

    if r4[r5] and r4[r5].r == r7.r9 then
        r4[r5] = nil
    end
end

r4[r5] = { r = r7.r9 }
r18(r25.Destroying, r7.r9)
r18(r69.Event, r7.r9)
r18(r32.Activated, r7.r9)

r18(r2.InputBegan, function(r, r1)
    if r1 or r2:GetFocusedTextBox() then
        return
    end

    if r.KeyCode == Enum.KeyCode.Escape then
        r38(false)
        return
    end

    if r.KeyCode == Enum.KeyCode.K then
        r8.r = not r8.r
        r7.r10 = r7.r10 + 1e0
        r7.r4.r()
        r17()
    end
end)

local r70, r71, r72

r18(r31.InputBegan, function(r)
    if r.UserInputType == Enum.UserInputType.MouseButton1 or r.UserInputType == Enum.UserInputType.Touch then
        r70 = r
        r71 = r.Position
        r72 = r30.Position
    end
end)

r18(r2.InputChanged, function(r)
    if r70 and (r == r70 or r.UserInputType == Enum.UserInputType.MouseMovement) then
        local r1 = r.Position - r71
        r30.Position = UDim2.new(r72.X.Scale, r72.X.Offset + r1.X, r72.Y.Scale, r72.Y.Offset + r1.Y)
    end
end)

r18(r2.InputEnded, function(r)
    if r == r70 or r.UserInputType == Enum.UserInputType.MouseButton1 then
        r70 = nil
    end
end)

r19(function()
    local r73 = r:WaitForChild("GameplayEvents", 1.5e1)
    local r74 = r:WaitForChild("Stats", 1.5e1)
    local r75 = game:GetService("ReplicatedStorage"):WaitForChild("Events", 1.5e1)

    if not r7.r then
        return
    end

    assert(r73 and r74 and r75, "GameplayEvents, Stats ou Events indisponíveis")
    local r76 = r73:WaitForChild("Mining", 1.5e1)
    local r77 = r76 and r76:WaitForChild("MineOre", 1.5e1)
    local r78 = r75:WaitForChild("GearsUpgrade", 1.5e1)
    local r79 = r78 and r78:WaitForChild("GearsReset", 1.5e1)
    local r80 = r75:WaitForChild("MineOre", 1.5e1)
    local r81 = r80 and r80:WaitForChild("SetDepth", 1.5e1)
    local r82 = r80 and r80:WaitForChild("MiningTier", 1.5e1)
    local r83 = r75:WaitForChild("AdjustSetting", 1.5e1)

    if not r7.r then
        return
    end

    assert(r77 and r78 and r79 and r81 and r82 and r83, "Remotes de mineração indisponíveis")

    local function r84(r)
        local r1 = r74:FindFirstChild(r)
        return r1 and tonumber(r1.Value) or 0e0
    end

    local function r85(r)
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

    local r86 = { 5e1, 6.5e1, 8e1, 9.5e1, 1.2e2 }
    local r87 = { 0e0, 0e0, 0e0, 0e0, 0e0 }

    r19(function()
        while r7.r do
            if r8.r then
                local r = r8.r8 and r8.r6[r8.r9] or r8.r7

                if r8.r8 and #r8.r6 == 0e0 then
                    r = nil
                end

                if r and r ~= r7.r8 then
                    local r1 = r7.r10

                    local function r88()
                        return r7.r and r8.r and r1 == r7.r10
                    end

                    local function r89()
                        r83:FireServer(r9[r][2e0], "OreLuck")
                        task.wait(1.5e-1)

                        if not r88() then
                            return
                        end

                        r81:FireServer(r9[r][1e0])
                        task.wait(4e-1)

                        if not r88() then
                            return
                        end

                        r82:FireServer(1e0)
                        task.wait(1.5e-1)

                        if not r88() then
                            return
                        end

                        r82:FireServer(1e0)
                        task.wait(2e-1)

                        if r88() then
                            r7.r8 = r
                        end
                    end

                    r7.r5 = true
                    local r2, r3 = pcall(r89)
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

                        r77:FireServer(r2)
                        task.wait(2e-2)
                    end

                    task.wait(5e-2)

                    if r8.r8 and r8.r and r3 == r7.r10 and r8.r6[r8.r9] == r then
                        r8.r10 = r8.r10 + os.clock() - r1

                        if r8.r10 >= 7.2e3 then
                            r8.r10 = r8.r10 % 7.2e3
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

    r19(function()
        while r7.r do
            if r8.r1 then
                for r = 5e0, 1e0, -1e0 do
                    if not r7.r or not r8.r1 then
                        break
                    end

                    if
                        (r == 1e0 or r84("GearsUpgrade" .. (r - 1e0)) >= r86[r - 1e0])
                        and r84("GearsUpgrade" .. r) < r86[r]
                        and os.clock() >= r87[r]
                    then
                        local r1 = r84("GearsUpgrade" .. r)
                        r78:FireServer(r, true)
                        task.wait(1e0)

                        if r1 == r84("GearsUpgrade" .. r) then
                            r87[r] = os.clock() + 1.5e1
                        end

                        task.wait(3e-1)
                    end
                end
            end

            task.wait(3e-1)
        end
    end)

    r19(function()
        while r7.r do
            if r8.r2 and r85(1e0) >= r8.r4 then
                r79:FireServer(1e0)
                task.wait(1e0)
            end

            if r8.r3 and r85(2e0) >= r8.r5 then
                r79:FireServer(2e0)
                task.wait(1e0)
            end

            task.wait(3e-1)
        end
    end)

    r19(function()
        while r7.r do
            r65.Text = string.format(
                "Normal: %s\nShiny: %s\nLife: %s\nTitanic: %s",
                r12(r84("Gears")),
                r12(r84("Gears2")),
                r12(r84("Gears3")),
                r12(r84("Gears4"))
            )

            r66.Text =
                string.format("Depth: %s\nOre luck: %s", r12(r84("MiningDepth")), r12(r84("CustomOreLuck")))
            local r = {}

            for r1 = 1e0, 5e0 do
                table.insert(
                    r,
                    string.format("Upgrade %d: %s / %s", r1, r12(r84("GearsUpgrade" .. r1)), r12(r86[r1]))
                )
            end

            r67.Text = table.concat(r, "\n")
            task.wait(5e-1)
        end
    end)
end)

r19(function()
    local r = os.clock()

    while r7.r do
        local r1 = math.ceil(math.max(0e0, 7.2e3 - r8.r10))

        r61.Text = r7.r7
            or (
                r7.r5 and "Aplicando minério..."
                or (
                    (r8.r and "Ativo: " or "Pausado: ")
                    .. (r7.r8 or "—")
                    .. (
                        r8.r8
                            and string.format(
                                "\n%02d:%02d:%02d restantes · %d/%d",
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

        if r8.r8 and #r8.r6 == 0e0 then
            r61.Text = "Selecione pelo menos um minério"
        end

        r20(r63, { Size = UDim2.fromScale(r8.r8 and math.clamp(r8.r10 / 7.2e3, 0e0, 1e0) or 0e0, 1e0) })
        r36.Text = r7.r6 or "Configuração automática"

        if os.clock() - r >= 3e1 then
            r17()
            r = os.clock()
        end

        task.wait(5e-1)
    end
end)

r17()
