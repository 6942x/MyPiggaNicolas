local r = game:GetService("Players").LocalPlayer
local r1 = game:GetService("TweenService")
local r2 = game:GetService("UserInputService")
local r3 = game:GetService("HttpService")
local r4 = type(getgenv) == "function" and getgenv() or shared
local r5 = "AutoFarm_" .. game.PlaceId .. "_" .. r.UserId
local r6 = r5 .. ".json"
if r4[r5] and type(r4[r5].r) == "function" then r4[r5].r() end
local r7 = {r = true, r1 = {}, r2 = {}, r3 = {}, r4 = {}, r5 = false, r10 = 0}
r4[r5] = r7
local r8 = {
    r = false, r1 = false, r2 = false, r3 = false,
    r4 = 1e6, r5 = 5e3,
    r6 = {"Coal", "Garnet", "Onyx", "Copper", "Plutonium"},
    r7 = "Onyx", r8 = false, r9 = 1, r10 = 0
}
local r9 = {
    Coal = {0, 1}, Tin = {0, 4}, Copper = {0, 622}, Iron = {325, 1},
    Silver = {20, 60}, Gold = {20, 622}, Topaz = {125, 180},
    Sapphire = {125, 622}, Ruby = {5000, 32}, Emerald = {600, 622},
    Azurite = {5000, 145}, Diamond = {5000, 550}, Tanzanite = {7500, 622},
    Plutonium = {7500, 205}, Uranium = {27500, 1}, Onyx = {52500, 30},
    Garnet = {27500, 622}, Neptunium = {150000, 622}, Osmium = {4500000, 622},
    Mithril = {6250000, 622}, Painite = {6250000, 622}
}
local r10 = {}
for r, r1 in pairs(r9) do table.insert(r10, r) end
table.sort(r10)
local function r11(r)
    if type(r) ~= "table" then return end
    for r1, r2 in pairs(r8) do
        if type(r2) == "boolean" and type(r[r1]) == "boolean" then r8[r1] = r[r1] end
    end
    for r1, r2 in ipairs({"r4", "r5"}) do
        if type(r[r2]) == "number" and r[r2] > 0 and r[r2] < math.huge then r8[r2] = r[r2] end
    end
    if r9[r.r7] then r8.r7 = r.r7 end
    if type(r.r6) == "table" then
        local r1 = {}
        for r2, r3 in ipairs(r.r6) do
            if r9[r3] and not table.find(r1, r3) then table.insert(r1, r3) end
        end
        r8.r6 = r1
    end
    r8.r9 = math.clamp(math.floor(tonumber(r.r9) or 1), 1, math.max(1, #r8.r6))
    r8.r10 = math.clamp(tonumber(r.r10) or 0, 0, 7200)
end
if type(readfile) == "function" then
    local r, r1 = pcall(function() return r3:JSONDecode(readfile(r6)) end)
    if r then r11(r1) end
end
r11(r4[r5 .. "_config"])
local function r12()
    r4[r5 .. "_config"] = table.clone(r8)
    r4[r5 .. "_config"].r6 = table.clone(r8.r6)
    if type(writefile) == "function" then
        local r, r1 = pcall(function() writefile(r6, r3:JSONEncode(r8)) end)
        r7.r6 = r and "Config salva" or "Falha ao salvar arquivo"
    else
        r7.r6 = "Config salva nesta sessão"
    end
end
local function r13(r, r1)
    local r2 = r:Connect(r1)
    table.insert(r7.r1, r2)
    return r2
end
local function r14(r)
    local r1 = task.defer(function()
        local r1, r2 = xpcall(r, debug.traceback)
        if not r1 and r7.r then r7.r7 = tostring(r2); warn(r2) end
    end)
    table.insert(r7.r2, r1)
    return r1
end
local function r15(r, r2)
    if r7.r3[r] then r7.r3[r]:Cancel() end
    local r3 = r1:Create(r, TweenInfo.new(0.18, Enum.EasingStyle.Quad), r2)
    r7.r3[r] = r3
    r3:Play()
end
local function r16(r, r1, r2)
    local r3 = Instance.new(r)
    for r4, r5 in pairs(r2 or {}) do r3[r4] = r5 end
    r3.Parent = r1
    return r3
end
local function r17(r, r1)
    r16("UICorner", r, {CornerRadius = UDim.new(0, r1 or 8)})
end
local r18 = r:WaitForChild("PlayerGui")
local r19 = r18:FindFirstChild("AutoFarmUI")
if r19 then
    local r = r19:FindFirstChild("Stop")
    if r and r:IsA("BindableEvent") then r:Fire() end
    r19:Destroy()
end
local r20 = r16("ScreenGui", r18, {
    Name = "AutoFarmUI", ResetOnSpawn = false, DisplayOrder = 999,
    ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})
local r21 = Color3.fromRGB(15, 17, 23)
local r22 = Color3.fromRGB(23, 27, 36)
local r23 = Color3.fromRGB(103, 148, 255)
local r24 = Color3.fromRGB(238, 238, 245)
local r25 = r16("Frame", r20, {
    Size = UDim2.new(1, -24, 1, -48), Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = r21, BorderSizePixel = 0
})
r16("UISizeConstraint", r25, {MaxSize = Vector2.new(430, 600)})
r17(r25, 12)
r16("UIStroke", r25, {Color = Color3.fromRGB(55, 55, 70)})
local r26 = r16("TextLabel", r25, {
    Size = UDim2.new(1, -100, 0, 44), Position = UDim2.fromOffset(16, 0),
    BackgroundTransparency = 1, Text = "Auto Farm", Font = Enum.Font.GothamBold,
    TextSize = 16, TextColor3 = r24, TextXAlignment = Enum.TextXAlignment.Left
})
local r27 = r16("TextButton", r25, {
    Size = UDim2.fromOffset(62, 30), Position = UDim2.new(1, -76, 0, 7),
    BackgroundColor3 = r22, Text = "Fechar", TextColor3 = r24, TextSize = 12, Font = Enum.Font.GothamMedium, BorderSizePixel = 0
})
r17(r27)
local r60, r61 = {}, {}
local r64 = r16("Frame", r25, {
    Size = UDim2.new(1, -28, 0, 42), Position = UDim2.fromOffset(14, 48),
    BackgroundColor3 = r22, BorderSizePixel = 0
})
r17(r64, 9)
local r65 = r16("TextLabel", r25, {
    Size = UDim2.new(1, -28, 0, 24), Position = UDim2.new(0, 14, 1, -28),
    BackgroundTransparency = 1, Font = Enum.Font.Gotham, TextSize = 11,
    TextColor3 = Color3.fromRGB(139, 151, 173), TextXAlignment = Enum.TextXAlignment.Left,
    Text = "Configuração automática"
})
local r66 = "Mine"
local r75
local function r63(r)
    r66 = r
    if r75 then r75(false) end
    for r1, r2 in pairs(r60) do
        r2.Visible = r1 == r
        r15(r61[r1], {
            BackgroundTransparency = r1 == r and 0 or 1,
            TextColor3 = r1 == r and r24 or Color3.fromRGB(139, 151, 173)
        })
    end
end
local function r62(r, r1)
    local r2 = r16("ScrollingFrame", r25, {
        Name = r, Size = UDim2.new(1, -28, 1, -132), Position = UDim2.fromOffset(14, 100),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = r23, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = r == "Mine"
    })
    r16("UIListLayout", r2, {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder})
    r16("UIPadding", r2, {PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 8)})
    local r3 = r16("TextButton", r64, {
        Size = UDim2.new(1 / 3, -8, 1, -8), Position = UDim2.new((r1 - 1) / 3, 4, 0, 4),
        BackgroundColor3 = Color3.fromRGB(42, 53, 77), BackgroundTransparency = 1,
        BorderSizePixel = 0, Text = r, TextSize = 13, Font = Enum.Font.GothamMedium,
        TextColor3 = r24, AutoButtonColor = false
    })
    r17(r3, 7)
    r60[r] = r2
    r61[r] = r3
    r13(r3.Activated, function() r63(r) end)
    return r2
end
local r28 = r62("Mine", 1)
r62("Gears", 2)
r62("Info", 3)
r63("Mine")
local r29 = 0
local function r30(r, r1)
    r29 = r29 + 1
    local r2 = r16(r or "Frame", r28, {
        Size = UDim2.new(1, 0, 0, r1 or 42), BackgroundColor3 = r22,
        BorderSizePixel = 0, LayoutOrder = r29
    })
    r17(r2)
    return r2
end
local function r31(r, r1)
    return r16("TextLabel", r, {
        Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1, Text = r1, Font = Enum.Font.Gotham,
        TextSize = 13, TextColor3 = r24, TextXAlignment = Enum.TextXAlignment.Left
    })
end
local r32
local function r33(r, r1)
    local r2 = r30("TextButton")
    r2.Text = ""
    r2.AutoButtonColor = false
    local r3 = r31(r2, r)
    r3.Size = UDim2.new(1, -82, 1, 0)
    local r4 = r16("Frame", r2, {
        Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -58, 0.5, -12),
        BorderSizePixel = 0, BackgroundColor3 = r21
    })
    r17(r4, 12)
    local r5 = r16("Frame", r4, {
        Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
        BorderSizePixel = 0, BackgroundColor3 = r24
    })
    r17(r5, 9)
    local function r6()
        r15(r4, {BackgroundColor3 = r8[r1] and r23 or Color3.fromRGB(65, 65, 78)})
        r15(r5, {Position = UDim2.fromOffset(r8[r1] and 25 or 3, 3)})
    end
    r7.r4[r1] = r6
    r13(r2.Activated, function()
        r8[r1] = not r8[r1]
        if r1 == "r8" then r8.r9 = 1; r8.r10 = 0; r7.r8 = nil; r7.r10 = r7.r10 + 1 end
        r6()
        r12()
        if r32 then r32() end
    end)
    r6()
end
r33("Auto Mine · K", "r")
r33("Multi ores · 2 horas por minério", "r8")
local r34 = r30("TextButton", 48)
r34.Text = ""
r34.AutoButtonColor = false
local r77 = r31(r34, "")
r77.Size = UDim2.new(1, -82, 1, 0)
r77.TextTruncate = Enum.TextTruncate.AtEnd
local r76 = r16("TextLabel", r34, {
    Size = UDim2.fromOffset(66, 48), Position = UDim2.new(1, -76, 0, 0),
    BackgroundTransparency = 1, Text = "Abrir", TextSize = 12, Font = Enum.Font.GothamMedium,
    TextColor3 = r23, TextXAlignment = Enum.TextXAlignment.Right
})
local r67 = r30("Frame", 0)
r67.Visible = false
r67.ClipsDescendants = true
local r68 = r16("TextBox", r67, {
    Size = UDim2.new(1, -20, 0, 40), Position = UDim2.fromOffset(10, 10),
    BackgroundColor3 = r21, BorderSizePixel = 0, Text = "", PlaceholderText = "Buscar minério...",
    PlaceholderColor3 = Color3.fromRGB(139, 151, 173), TextColor3 = r24,
    Font = Enum.Font.Gotham, TextSize = 13, ClearTextOnFocus = false
})
r17(r68, 7)
local r70 = r16("Frame", r67, {
    Size = UDim2.new(1, -20, 0, 36), Position = UDim2.fromOffset(10, 58), BackgroundTransparency = 1
})
local function r81(r, r1)
    local r2 = r16("TextButton", r70, {
        Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(r1, r1 == 0 and 0 or 4, 0, 0),
        BackgroundColor3 = Color3.fromRGB(35, 42, 57), BorderSizePixel = 0,
        Text = r, TextColor3 = r24, TextSize = 12, Font = Enum.Font.GothamMedium, AutoButtonColor = false
    })
    r17(r2, 6)
    return r2
end
local r71 = r81("Selecionar todos", 0)
local r72 = r81("Limpar seleção", 0.5)
local r35 = r16("ScrollingFrame", r67, {
    Size = UDim2.new(1, -20, 1, -110), Position = UDim2.fromOffset(10, 102),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
    ScrollBarImageColor3 = r23, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y
})
r16("UIListLayout", r35, {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})
local r73 = r16("TextLabel", r35, {
    Size = UDim2.new(1, -6, 0, 44), BackgroundTransparency = 1,
    Text = "Nenhum minério encontrado", TextColor3 = Color3.fromRGB(139, 151, 173),
    Font = Enum.Font.Gotham, TextSize = 13, Visible = false, LayoutOrder = 100
})
local r36 = {}
local r74 = false
r75 = function(r)
    r74 = r
    r76.Text = r and "Fechar" or "Abrir"
    if r then r67.Visible = true end
    r15(r67, {Size = UDim2.new(1, 0, 0, r and 286 or 0)})
    if not r then
        r68:ReleaseFocus()
        r14(function()
            task.wait(0.2)
            if not r74 then r67.Visible = false end
        end)
    end
end
r32 = function()
    r77.Text = r8.r8 and ("Multi ores  /  " .. #r8.r6 .. " selecionados") or ("Minério  /  " .. r8.r7)
    r71.Visible = r8.r8
    r72.Visible = r8.r8
    r70.Visible = r8.r8
    r35.Position = UDim2.fromOffset(10, r8.r8 and 102 or 58)
    r35.Size = UDim2.new(1, -20, 1, r8.r8 and -110 or -66)
    local r2 = r68.Text:lower()
    local r3 = 0
    for r, r1 in pairs(r36) do
        local r4 = r8.r8 and table.find(r8.r6, r) or (not r8.r8 and r8.r7 == r)
        r1.r.Visible = r:lower():find(r2, 1, true) ~= nil
        if r1.r.Visible then r3 = r3 + 1 end
        r1.r1.Text = r
        r1.r2.BackgroundColor3 = r4 and r23 or Color3.fromRGB(49, 57, 73)
        r1.r3.Text = r4 and (r8.r8 and tostring(r4) or "") or ""
        r1.r.BackgroundColor3 = r4 and Color3.fromRGB(35, 46, 68) or r22
    end
    r73.Visible = r3 == 0
end
local function r82()
    r8.r9 = 1
    r8.r10 = 0
    r7.r8 = nil
    r7.r10 = r7.r10 + 1
    r32()
    r12()
end
r13(r34.Activated, function() r75(not r74) end)
r13(r68:GetPropertyChangedSignal("Text"), r32)
r13(r71.Activated, function()
    for r, r1 in ipairs(r10) do
        if not table.find(r8.r6, r1) then table.insert(r8.r6, r1) end
    end
    r82()
end)
r13(r72.Activated, function() table.clear(r8.r6); r82() end)
for r, r1 in ipairs(r10) do
    local r2 = r16("TextButton", r35, {
        Size = UDim2.new(1, -6, 0, 44), BackgroundColor3 = r22,
        BorderSizePixel = 0, Text = "", LayoutOrder = r, AutoButtonColor = false
    })
    r17(r2, 7)
    local r3 = r31(r2, r1)
    r3.Position = UDim2.fromOffset(42, 0)
    r3.Size = UDim2.new(1, -54, 1, 0)
    local r4 = r16("Frame", r2, {
        Size = UDim2.fromOffset(24, 24), Position = UDim2.new(0, 10, 0.5, -12),
        BackgroundColor3 = r21, BorderSizePixel = 0
    })
    r17(r4, 6)
    local r5 = r16("TextLabel", r4, {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "", TextColor3 = r21, TextSize = 12, Font = Enum.Font.GothamBold
    })
    r36[r1] = {r = r2, r1 = r3, r2 = r4, r3 = r5}
    r13(r2.Activated, function()
        if r8.r8 then
            local r = table.find(r8.r6, r1)
            if r then table.remove(r8.r6, r) else table.insert(r8.r6, r1) end
        else
            r8.r7 = r1
            r75(false)
        end
        r82()
    end)
end
r32()
local r37 = r31(r30(nil, 64), "Aguardando mineração")
r37.TextWrapped = true
local r78 = r30(nil, 4)
r78.BackgroundColor3 = Color3.fromRGB(35, 42, 57)
local r79 = r16("Frame", r78, {Size = UDim2.fromScale(0, 1), BackgroundColor3 = r23, BorderSizePixel = 0})
r17(r79, 3)
r28 = r60.Gears
r33("Auto Upgrade", "r1")
r33("Auto Reset Normal → Shiny", "r2")
local function r38(r, r1)
    local r2 = r30(nil, 62)
    local r3 = r31(r2, r)
    r3.Size = UDim2.new(1, -20, 0, 26)
    local r4 = r16("TextBox", r2, {
        Size = UDim2.new(1, -20, 0, 26), Position = UDim2.fromOffset(10, 28),
        Text = tostring(r8[r1]), ClearTextOnFocus = false, BackgroundColor3 = r21,
        TextColor3 = r24, TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0
    })
    r17(r4, 5)
    r13(r4.FocusLost, function()
        local r = r4.Text:lower():gsub("%s", "")
        local r2, r3 = r:match("^([%d%.]+)(%a*)$")
        local r5 = {k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18, sx = 1e21, sp = 1e24, oc = 1e27, no = 1e30, dc = 1e33, [""] = 1}
        local r6 = tonumber(r2) and r5[r3] and tonumber(r2) * r5[r3]
        if r6 and r6 > 0 and r6 < math.huge then r8[r1] = r6; r12() end
        r4.Text = tostring(r8[r1])
    end)
end
r38("Mínimo de Shiny por reset", "r4")
r33("Auto Reset Shiny → Life", "r3")
r38("Mínimo de Life por reset", "r5")
r28 = r60.Info
local r39 = r31(r30(nil, 76), "Carregando estatísticas...")
r39.TextWrapped = true
local r80 = r31(r30(nil, 60), "")
r80.TextWrapped = true
local r83 = r31(r30(nil, 120), "")
r83.TextWrapped = true
local r84 = r31(r30(nil, 66), "Ciclo de 2 horas por minério.\nA numeração da seleção define a ordem.\nK pausa ou retoma a mineração.")
r84.TextWrapped = true
local r40 = r16("BindableEvent", r20, {Name = "Stop"})
r7.r = true
r7.r9 = function()
    if not r7.r then return end
    r7.r = false
    r12()
    for r, r1 in ipairs(r7.r1) do r1:Disconnect() end
    for r, r1 in ipairs(r7.r2) do
        if r1 ~= coroutine.running() and coroutine.status(r1) ~= "dead" then pcall(task.cancel, r1) end
    end
    for r, r1 in pairs(r7.r3) do r1:Cancel() end
    r20:Destroy()
    if r4[r5] and r4[r5].r == r7.r9 then r4[r5] = nil end
end
r4[r5] = {r = r7.r9}
r13(r40.Event, r7.r9)
r13(r27.Activated, r7.r9)
r13(r2.InputBegan, function(r, r1)
    if r1 or r2:GetFocusedTextBox() then return end
    if r.KeyCode == Enum.KeyCode.Escape then r75(false); return end
    if r.KeyCode == Enum.KeyCode.K then
        r8.r = not r8.r
        r7.r4.r()
        r12()
    end
end)
local r41, r42, r43
r13(r26.InputBegan, function(r)
    if r.UserInputType == Enum.UserInputType.MouseButton1 or r.UserInputType == Enum.UserInputType.Touch then
        r41 = r
        r42 = r.Position
        r43 = r25.Position
    end
end)
r13(r2.InputChanged, function(r)
    if r41 and (r == r41 or r.UserInputType == Enum.UserInputType.MouseMovement) then
        local r1 = r.Position - r42
        r25.Position = UDim2.new(r43.X.Scale, r43.X.Offset + r1.X, r43.Y.Scale, r43.Y.Offset + r1.Y)
    end
end)
r13(r2.InputEnded, function(r)
    if r == r41 or r.UserInputType == Enum.UserInputType.MouseButton1 then r41 = nil end
end)
r14(function()
    local r44 = r:WaitForChild("GameplayEvents", 15)
    local r45 = r:WaitForChild("Stats", 15)
    local r46 = game:GetService("ReplicatedStorage"):WaitForChild("Events", 15)
    assert(r44 and r45 and r46, "GameplayEvents, Stats ou Events indisponíveis")
    local r47 = r44:WaitForChild("Mining", 15)
    local r48 = r47 and r47:WaitForChild("MineOre", 15)
    local r49 = r46:WaitForChild("GearsUpgrade", 15)
    local r50 = r49 and r49:WaitForChild("GearsReset", 15)
    local r51 = r46:WaitForChild("MineOre", 15)
    local r52 = r51 and r51:WaitForChild("SetDepth", 15)
    local r53 = r51 and r51:WaitForChild("MiningTier", 15)
    local r54 = r46:WaitForChild("AdjustSetting", 15)
    assert(r48 and r49 and r50 and r52 and r53 and r54, "Remotes de mineração indisponíveis")
    local function r55(r)
        local r1 = r45:FindFirstChild(r)
        return r1 and tonumber(r1.Value) or 0
    end
    local function r56(r)
        local r1 = workspace:FindFirstChild("Boards")
        r1 = r1 and r1:FindFirstChild("GearTypes")
        r1 = r1 and r1:FindFirstChild("GearsReset")
        r1 = r1 and r1:FindFirstChild("SurfaceGui")
        r1 = r1 and r1:FindFirstChild("Info")
        r1 = r1 and r1:FindFirstChild("Gear" .. r)
        r1 = r1 and r1:FindFirstChild("NextGears")
        if not r1 then return 0 end
        local r2 = r1.Text:lower():gsub("[%s+,]", "")
        local r3, r4 = r2:match("^([%d%.]+)(%a*)$")
        local r5 = {[""] = 1, k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18}
        return (tonumber(r3) or 0) * (r5[r4] or 0)
    end
    local r57 = {50, 65, 80, 95, 120}
    local r58 = {0, 0, 0, 0, 0}
    r14(function()
        while r7.r do
            if r8.r then
                local r = r8.r8 and r8.r6[r8.r9] or r8.r7
                if r8.r8 and #r8.r6 == 0 then r = nil end
                if r and r ~= r7.r8 then
                    local r1 = r7.r10
                    r7.r5 = true
                    r54:FireServer(r9[r][2], "OreLuck")
                    task.wait(0.15)
                    r52:FireServer(r9[r][1])
                    task.wait(0.4)
                    r53:FireServer(1)
                    task.wait(0.15)
                    r53:FireServer(1)
                    task.wait(0.2)
                    if r1 == r7.r10 then r7.r8 = r end
                    r7.r5 = false
                end
                if r and r8.r and r7.r8 == r then
                    local r1 = os.clock()
                    local r3 = r7.r10
                    for r2 = 1, 5 do
                        if not r8.r or r3 ~= r7.r10 then break end
                        r48:FireServer(r2)
                        task.wait(0.02)
                    end
                    task.wait(0.05)
                    if r8.r8 and r8.r and r3 == r7.r10 and r8.r6[r8.r9] == r then
                        r8.r10 = r8.r10 + os.clock() - r1
                        if r8.r10 >= 7200 then
                            r8.r10 = 0
                            r8.r9 = r8.r9 % #r8.r6 + 1
                            r7.r8 = nil
                            r12()
                        end
                    end
                else task.wait(0.2) end
            else task.wait(0.2) end
        end
    end)
    r14(function()
        while r7.r do
            if r8.r1 then
                for r = 5, 1, -1 do
                    if not r8.r1 then break end
                    if (r == 1 or r55("GearsUpgrade" .. (r - 1)) >= r57[r - 1]) and r55("GearsUpgrade" .. r) < r57[r] and os.clock() >= r58[r] then
                        local r1 = r55("GearsUpgrade" .. r)
                        r49:FireServer(r, true)
                        task.wait(1)
                        if r1 == r55("GearsUpgrade" .. r) then r58[r] = os.clock() + 15 end
                        task.wait(0.3)
                    end
                end
            end
            task.wait(0.3)
        end
    end)
    r14(function()
        while r7.r do
            if r8.r2 and r56(1) >= r8.r4 then r50:FireServer(1); task.wait(1) end
            if r8.r3 and r56(2) >= r8.r5 then r50:FireServer(2); task.wait(1) end
            task.wait(0.3)
        end
    end)
    r14(function()
        while r7.r do
            r39.Text = string.format("Normal: %.3g  ·  Shiny: %.3g\nLife: %.3g  ·  Titanic: %.3g", r55("Gears"), r55("Gears2"), r55("Gears3"), r55("Gears4"))
            r80.Text = string.format("Depth: %.3g\nOre luck: %.3g", r55("MiningDepth"), r55("CustomOreLuck"))
            local r = {}
            for r1 = 1, 5 do
                table.insert(r, string.format("Upgrade %d: %g / %g", r1, r55("GearsUpgrade" .. r1), r57[r1]))
            end
            r83.Text = table.concat(r, "\n")
            task.wait(0.5)
        end
    end)
end)
r14(function()
    local r = os.clock()
    while r7.r do
        local r1 = math.ceil(math.max(0, 7200 - r8.r10))
        r37.Text = r7.r7 or (r7.r5 and "Aplicando minério..." or ((r8.r and "Ativo: " or "Pausado: ") .. (r7.r8 or "—") .. (r8.r8 and string.format("\n%02d:%02d:%02d restantes · %d/%d", math.floor(r1 / 3600), math.floor(r1 / 60) % 60, r1 % 60, r8.r9, #r8.r6) or "")))
        if r8.r8 and #r8.r6 == 0 then r37.Text = "Selecione pelo menos um minério" end
        r15(r79, {Size = UDim2.fromScale(r8.r8 and math.clamp(r8.r10 / 7200, 0, 1) or 0, 1)})
        r65.Text = r7.r6 or "Configuração automática"
        if os.clock() - r >= 30 then r12(); r = os.clock() end
        task.wait(0.5)
    end
end)
r12()
