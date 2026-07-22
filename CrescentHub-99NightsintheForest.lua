local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Crescent Hub - 99 Nights in the Forest",
    Icon = "https://crescent-ds7.pages.dev/Crescent Logo.png",
    Author = "Crescent Team",
    Folder = "CrescentHub",
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    Size = UDim2.fromOffset(600, 440),
})

local globalSettings = { Range = 2000, MaxCount = 100, Speed = 0.15, BringDestination = "玩家" }
local autoCampfireSettings = { Enabled = false, Speed = 2.0, TargetPosition = Vector3.new(20.9, 6.2, -5.4) }
local autoGearsSettings = { Enabled = false, Speed = 0.1 }
local autoEatSettings = { Enabled = false, Threshold = 90 }
local godModeSettings = { Enabled = false, Height = 15 }
local killAuraSettings = { Enabled = false, Range = 150, Delay = 0.1 }
local treeAuraSettings = { Enabled = false, Range = 100 }
local autoDaySettings = { Enabled = false, Radius = 150, Height = 100, Speed = 1 }
local autoDayAngle = 0

local playerSettings = {
    WalkSpeedEnabled = false, WalkSpeed = 30,
    JumpPowerEnabled = false, JumpPower = 30,
    FlyEnabled = false, FlySpeed = 30
}

local miscSettings = {
    FullBrightEnabled = false, Brightness = 2, ClockTime = 14, Ambient = Color3.fromRGB(200, 200, 200),
    GlowEnabled = false, GlowBrightness = 10, GlowRange = 20, GlowColor = Color3.fromRGB(255, 255, 255)
}

local espSettings = { Players = false, Trees = false, Rabbits = false, Categories = {} }
local activeESP = {}

local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function unfreezeAndFix(obj)
    if obj:IsA("Model") then
        for _, part in ipairs(obj:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            end
        end
    elseif obj:IsA("BasePart") then
        obj.Anchored = false
        obj.AssemblyLinearVelocity = Vector3.zero
        obj.AssemblyAngularVelocity = Vector3.zero
    end
end

local function forceUnstuck(obj)
    if not obj or not obj.Parent then return end
    
    local parts = {}
    if obj:IsA("Model") then
        for _, p in ipairs(obj:GetDescendants()) do
            if p:IsA("BasePart") then table.insert(parts, p) end
        end
    elseif obj:IsA("BasePart") then
        table.insert(parts, obj)
    end

    for _, part in ipairs(parts) do
        part.Anchored = true
    end

    task.wait(0.05)

    for _, part in ipairs(parts) do
        part.Anchored = false
        part.AssemblyLinearVelocity = Vector3.new(0, -30, 0)
        part.AssemblyAngularVelocity = Vector3.zero
    end
end

local function getNearbyTargetObjects(targetNamesTable, radius)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return {} end
    local rootPos = character.HumanoidRootPart.Position

    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    overlapParams.FilterDescendantsInstances = {character}

    local partsInRadius = workspace:GetPartBoundsInRadius(rootPos, radius, overlapParams)
    local foundObjects = {}
    local processedModels = {}

    for i, part in ipairs(partsInRadius) do
        if i % 50 == 0 then task.wait() end

        local model = part:FindFirstAncestorOfClass("Model")
        local targetObj = model or part

        if not processedModels[targetObj] and targetNamesTable[targetObj.Name] then
            processedModels[targetObj] = true
            table.insert(foundObjects, targetObj)
        end
    end

    return foundObjects
end

local function executeBring(targetNames)
    local nameLookup = {}
    for _, name in ipairs(targetNames) do nameLookup[name] = true end

    local matchedObjects = getNearbyTargetObjects(nameLookup, globalSettings.Range)

    local count = 0
    for _, obj in ipairs(matchedObjects) do
        if count >= globalSettings.MaxCount then break end
        count = count + 1

        task.spawn(function()
            local targetCFrame
            if globalSettings.BringDestination == "玩家" then
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                targetCFrame = character.HumanoidRootPart.CFrame + Vector3.new(math.random(-3, 3), math.random(1, 4), math.random(-3, 3))
            elseif globalSettings.BringDestination == "工作臺" then
                targetCFrame = CFrame.new(20.9, 6.2, -5.4) + Vector3.new(math.random(-3, 3), math.random(1, 4), math.random(-3, 3))
            elseif globalSettings.BringDestination == "營火" then
                targetCFrame = CFrame.new(0.5, 8.4, 0.3) + Vector3.new(math.random(-3, 3), math.random(1, 4), math.random(-3, 3))
            end

            if targetCFrame then
                if obj:IsA("Model") and obj.PrimaryPart then
                    obj:SetPrimaryPartCFrame(targetCFrame)
                elseif obj:IsA("BasePart") then
                    obj.CFrame = targetCFrame
                end
                unfreezeAndFix(obj)
            end
        end)
        task.wait(globalSettings.Speed)
    end
end

local function pickAllCoins()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local coinLookup = { ["Coin Stack"] = true }
        local coins = getNearbyTargetObjects(coinLookup, 500)
        local count = 0

        for _, Obj in ipairs(coins) do
            if Obj:IsA("Model") and Obj.PrimaryPart then
                Obj.PrimaryPart.CFrame = hrp.CFrame
                unfreezeAndFix(Obj)
                count = count + 1
            end
        end
        WindUI:Notify({ Title = "Pick All Coins", Content = "Collected " .. count .. " coin stacks!", Duration = 2 })
    end
end

local function applyESP(obj, displayName, color, isPlayer)
    if activeESP[obj] then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "CrescentESP"
    highlight.FillColor = color or Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.Adornee = obj
    highlight.Parent = obj

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CrescentESPLabel"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = isPlayer and Vector3.new(0, 4.5, 0) or Vector3.new(0, 3, 0)
    billboard.Adornee = (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChild("Head"))) or obj

    local label = Instance.new("TextLabel")
    label.Parent = billboard
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = displayName
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextSize = 13

    billboard.Parent = obj
    activeESP[obj] = { Highlight = highlight, Label = billboard }
end

local function removeESP(obj)
    if activeESP[obj] then
        if activeESP[obj].Highlight then activeESP[obj].Highlight:Destroy() end
        if activeESP[obj].Label then activeESP[obj].Label:Destroy() end
        activeESP[obj] = nil
    end
end

local function clearAllESP()
    for obj, _ in pairs(activeESP) do
        removeESP(obj)
    end
end

task.spawn(function()
    while true do
        task.wait(1.5)
        local currentObjects = {}

        if espSettings.Players then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    currentObjects[plr.Character] = true
                    applyESP(plr.Character, plr.DisplayName or plr.Name, Color3.fromRGB(0, 255, 255), true)
                end
            end
        end

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local name = obj.Name
                local shouldShow = false
                local labelName = ""
                local labelColor = Color3.fromRGB(255, 255, 255)

                if espSettings.Trees and (name == "Small Tree" or name == "TreeBig1" or name == "TreeBig2") then
                    shouldShow = true
                    labelName = "Tree"
                    labelColor = Color3.fromRGB(0, 255, 0)
                elseif espSettings.Rabbits and name == "Bunny" then
                    shouldShow = true
                    labelName = "Rabbit"
                    labelColor = Color3.fromRGB(255, 192, 203)
                else
                    for category, names in pairs(espSettings.Categories) do
                        if names[name] then
                            shouldShow = true
                            labelName = category .. " (" .. name .. ")"
                            labelColor = Color3.fromRGB(255, 215, 0)
                            break
                        end
                    end
                end

                if shouldShow then
                    currentObjects[obj] = true
                    applyESP(obj, labelName, labelColor, false)
                end
            end
        end

        for obj, _ in pairs(activeESP) do
            if not currentObjects[obj] or not obj.Parent then
                removeESP(obj)
            end
        end
    end
end)

task.spawn(function()
    local fuelNames = {
        ["Log"] = true, ["Chair"] = true, ["Coal"] = true,
        ["Fuel Canister"] = true, ["Oil Barrel"] = true, ["Biofuel"] = true
    }
    while true do
        if autoCampfireSettings.Enabled then
            local matchedFuels = getNearbyTargetObjects(fuelNames, globalSettings.Range)

            for i = 1, math.min(#matchedFuels, 5) do
                local obj = matchedFuels[i]
                task.spawn(function()
                    local startPos = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position)
                    
                    if obj:IsA("Model") and obj.PrimaryPart then
                        obj:SetPrimaryPartCFrame(CFrame.new(autoCampfireSettings.TargetPosition))
                    elseif obj:IsA("BasePart") then
                        obj.CFrame = CFrame.new(autoCampfireSettings.TargetPosition)
                    end
                    unfreezeAndFix(obj)

                    task.wait(0.5)
                    if obj and obj.Parent then
                        local newPos = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position)
                        if newPos and startPos and (newPos - startPos).Magnitude < 1 then
                            forceUnstuck(obj)
                        end
                    end
                end)
                task.wait(0.05)
            end
            task.wait(autoCampfireSettings.Speed)
        else
            task.wait(0.2)
        end
    end
end)

task.spawn(function()
    local gearNames = {
        ["Bolt"] = true, ["Tyre"] = true, ["Sheet Metal"] = true, ["Old Radio"] = true, ["Broken Fan"] = true,
        ["Broken Microwave"] = true, ["Washing Machine"] = true, ["Old Car Engine"] = true, ["UFO Scrap"] = true,
        ["UFO Component"] = true, ["UFO Junk"] = true, ["Cultist Gem"] = true, ["Gem of the Forest"] = true
    }
    while true do
        if autoGearsSettings.Enabled then
            local targetGrinder = workspace:FindFirstChild("GrindersLeft", true)
            if targetGrinder then
                local targetPos = (targetGrinder:IsA("Model") and targetGrinder.PrimaryPart and targetGrinder.PrimaryPart.Position) or (targetGrinder:IsA("BasePart") and targetGrinder.Position)
                if targetPos then
                    targetPos = targetPos + Vector3.new(0.5, 0, 0)
                    local matchedGears = getNearbyTargetObjects(gearNames, globalSettings.Range)

                    for i = 1, math.min(#matchedGears, 5) do
                        local obj = matchedGears[i]
                        task.spawn(function()
                            local startPos = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position)
                            
                            if obj:IsA("Model") and obj.PrimaryPart then
                                obj:SetPrimaryPartCFrame(CFrame.new(targetPos))
                            elseif obj:IsA("BasePart") then
                                obj.CFrame = CFrame.new(targetPos)
                            end
                            unfreezeAndFix(obj)

                            task.wait(0.5)
                            if obj and obj.Parent then
                                local newPos = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position)
                                if newPos and startPos and (newPos - startPos).Magnitude < 1 then
                                    forceUnstuck(obj)
                                end
                            end
                        end)
                        task.wait(0.05)
                    end
                end
            end
            task.wait(autoGearsSettings.Speed)
        else
            task.wait(0.2)
        end
    end
end)

task.spawn(function()
    local foodNames = {
        ["Sweet Potato"] = true, ["Stuffing"] = true, ["Turkey Leg"] = true, ["Carrot"] = true,
        ["Pumpkin"] = true, ["Mackerel"] = true, ["Salmon"] = true, ["Swordfish"] = true,
        ["Berry"] = true, ["Ribs"] = true, ["Stew"] = true, ["Steak Dinner"] = true,
        ["Morsel"] = true, ["Steak"] = true, ["Corn"] = true, ["Cooked Morsel"] = true,
        ["Cooked Steak"] = true, ["Chilli"] = true, ["Apple"] = true, ["Cake"] = true
    }
    local requestConsume = ReplicatedStorage:WaitForChild("RemoteEvents", 5) and ReplicatedStorage.RemoteEvents:WaitForChild("RequestConsumeItem", 5)
    local success, hungryBar = pcall(function()
        return LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface"):WaitForChild("StatBars"):WaitForChild("HungerBar"):WaitForChild("Bar")
    end)

    if success and hungryBar and requestConsume then
        hungryBar:GetPropertyChangedSignal("Size"):Connect(function()
            if autoEatSettings.Enabled and hungryBar.Size.X.Scale < (autoEatSettings.Threshold / 100) then
                local foods = getNearbyTargetObjects(foodNames, 200)
                if #foods > 0 then
                    pcall(function() requestConsume:InvokeServer(foods[1]) end)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        if killAuraSettings.Enabled then
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local weapon = LocalPlayer.Inventory:FindFirstChild("Old Axe") or LocalPlayer.Inventory:FindFirstChild("Good Axe") or LocalPlayer.Inventory:FindFirstChild("Strong Axe") or LocalPlayer.Inventory:FindFirstChild("Chainsaw")
                if weapon and workspace:FindFirstChild("Characters") then
                    for _, mob in pairs(workspace.Characters:GetChildren()) do
                        if mob:IsA("Model") and mob.PrimaryPart and mob ~= character then
                            if (mob.PrimaryPart.Position - hrp.Position).Magnitude <= killAuraSettings.Range then
                                ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(mob, weapon, 999, hrp.CFrame)
                            end
                        end
                    end
                end
            end
        end
        task.wait(killAuraSettings.Delay)
    end
end)

task.spawn(function()
    while true do
        if treeAuraSettings.Enabled then
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local weapon = LocalPlayer.Inventory:FindFirstChild("Old Axe") or LocalPlayer.Inventory:FindFirstChild("Good Axe") or LocalPlayer.Inventory:FindFirstChild("Strong Axe") or LocalPlayer.Inventory:FindFirstChild("Chainsaw")
                
                local function chop(folder)
                    for _, tree in pairs(folder:GetChildren()) do
                        if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") then
                            if tree.PrimaryPart then
                                local dist = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                                if dist <= treeAuraSettings.Range and weapon then
                                    ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(tree, weapon, 999, hrp.CFrame)
                                end
                            end
                        end
                    end
                end

                if workspace:FindFirstChild("Map") then
                    if workspace.Map:FindFirstChild("Foliage") then chop(workspace.Map.Foliage) end
                    if workspace.Map:FindFirstChild("Landmarks") then chop(workspace.Map.Landmarks) end
                end
            end
        end
        task.wait(0.3)
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if autoDaySettings.Enabled then
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            autoDayAngle = autoDayAngle + autoDaySettings.Speed * dt
            local newPos = Vector3.new(math.cos(autoDayAngle) * autoDaySettings.Radius, autoDaySettings.Height, math.sin(autoDayAngle) * autoDaySettings.Radius)
            hrp.CFrame = CFrame.new(newPos, Vector3.new(0, autoDaySettings.Height, 0))
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end

    if godModeSettings.Enabled then
        humanoid.PlatformStand = false
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {character}

        local raycastResult = workspace:Raycast(rootPart.Position + Vector3.new(0, 5, 0), Vector3.new(0, -500, 0), raycastParams)
        local targetY = raycastResult and raycastResult.Position.Y or (rootPart.Position.Y - 5)
        rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, 0, rootPart.AssemblyLinearVelocity.Z)
        rootPart.CFrame = CFrame.new(rootPart.Position.X, targetY + godModeSettings.Height, rootPart.Position.Z) * (rootPart.CFrame - rootPart.Position)
    end
end)

local flyLockedPosition = nil
RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    if playerSettings.WalkSpeedEnabled then humanoid.WalkSpeed = playerSettings.WalkSpeed end
    if playerSettings.JumpPowerEnabled then humanoid.UseJumpPower = true humanoid.JumpPower = playerSettings.JumpPower end

    if playerSettings.FlyEnabled then
        humanoid.PlatformStand = true
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection -= Vector3.new(0, 1, 0) end

        local flatLook = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z).Unit
        if moveDirection.Magnitude > 0 then
            flyLockedPosition = nil
            rootPart.AssemblyLinearVelocity = moveDirection.Unit * playerSettings.FlySpeed
            rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + flatLook)
        else
            if not flyLockedPosition then flyLockedPosition = rootPart.Position end
            rootPart.AssemblyLinearVelocity = Vector3.zero
            rootPart.CFrame = CFrame.new(flyLockedPosition, flyLockedPosition + flatLook)
        end
    else
        flyLockedPosition = nil
        if humanoid.PlatformStand and not godModeSettings.Enabled then humanoid.PlatformStand = false end
    end
end)

RunService.RenderStepped:Connect(function()
    if miscSettings.FullBrightEnabled then
        Lighting.Brightness = miscSettings.Brightness
        Lighting.ClockTime = miscSettings.ClockTime
        Lighting.OutdoorAmbient = miscSettings.Ambient
        Lighting.GlobalShadows = false
    end
end)

local glowPointLight = nil
RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if miscSettings.GlowEnabled and rootPart then
        if not glowPointLight or glowPointLight.Parent ~= rootPart then
            if glowPointLight then glowPointLight:Destroy() end
            glowPointLight = Instance.new("PointLight")
            glowPointLight.Name = "CrescentGlow"
            glowPointLight.Parent = rootPart
        end
        glowPointLight.Brightness = miscSettings.GlowBrightness
        glowPointLight.Range = miscSettings.GlowRange
        glowPointLight.Color = miscSettings.GlowColor
        glowPointLight.Enabled = true
    elseif glowPointLight then
        glowPointLight.Enabled = false
    end
end)

local InfoTab = Window:Tab({ Title = "Information", Icon = "info" })
InfoTab:Image({ Image = "https://crescent-ds7.pages.dev/Crescent.png", Height = 180 })
InfoTab:Paragraph({ Title = "Created by Crescent Team", Desc = "Thank you for using Crescent Hub!" })
InfoTab:Section({ Title = "Community & Links" })
InfoTab:Button({ Title = "Website", Desc = "Click to copy link", Callback = function() if setclipboard then setclipboard("https://crescent-ds7.pages.dev/") end end })
InfoTab:Button({ Title = "Discord", Desc = "Click to copy link", Callback = function() if setclipboard then setclipboard("https://discord.gg/sy4R8MbDAQ") end end })

local MainTab = Window:Tab({ Title = "Main", Icon = "shield" })
MainTab:Section({ Title = "Auto Day Settings" })
MainTab:Toggle({ Title = "Auto Days", Desc = "Circle Tween map", Icon = "star", Default = false, Callback = function(s) autoDaySettings.Enabled = s end })
MainTab:Slider({ Title = "Circle Radius", Step = 10, Value = { Min = 50, Max = 500, Default = 150 }, Callback = function(v) autoDaySettings.Radius = v end })
MainTab:Slider({ Title = "Circle Height", Step = 10, Value = { Min = 10, Max = 300, Default = 100 }, Callback = function(v) autoDaySettings.Height = v end })
MainTab:Slider({ Title = "Circle Speed", Step = 0.1, Value = { Min = 0.1, Max = 5, Default = 1 }, Callback = function(v) autoDaySettings.Speed = v end })

MainTab:Section({ Title = "Pick All Coins" })
MainTab:Button({ Title = "Pick All Coins", Desc = "Teleport all Coin Stacks to player", Callback = function() pickAllCoins() end })

MainTab:Section({ Title = "God Mode Settings" })
MainTab:Toggle({ Title = "Enable God Mode (Float)", Default = false, Callback = function(s) godModeSettings.Enabled = s end })
MainTab:Slider({ Title = "Float Height (Studs)", Step = 1, Value = { Min = 1, Max = 50, Default = 15 }, Callback = function(v) godModeSettings.Height = v end })

MainTab:Section({ Title = "Kill Aura Settings" })
MainTab:Toggle({ Title = "Enable Kill Aura", Default = false, Callback = function(s) killAuraSettings.Enabled = s end })
MainTab:Slider({ Title = "Kill Aura Range (Studs)", Step = 5, Value = { Min = 10, Max = 300, Default = 150 }, Callback = function(v) killAuraSettings.Range = v end })
MainTab:Slider({ Title = "Kill Aura Delay (Seconds)", Step = 0.05, Value = { Min = 0.05, Max = 2, Default = 0.1 }, Callback = function(v) killAuraSettings.Delay = v end })

MainTab:Section({ Title = "Auto Cut Tree Settings" })
MainTab:Toggle({ Title = "Enable Auto Cut Tree", Default = false, Callback = function(s) treeAuraSettings.Enabled = s end })
MainTab:Slider({ Title = "Auto Cut Tree Range (Studs)", Step = 10, Value = { Min = 10, Max = 200, Default = 100 }, Callback = function(v) treeAuraSettings.Range = v end })

local AutoTab = Window:Tab({ Title = "Auto", Icon = "refresh-cw" })
AutoTab:Section({ Title = "Auto Campfire Settings" })
AutoTab:Toggle({ Title = "Enable Auto Campfire", Default = false, Callback = function(s) autoCampfireSettings.Enabled = s end })
AutoTab:Slider({ Title = "Feed Delay (Seconds)", Step = 0.05, Value = { Min = 0.01, Max = 5, Default = 2.0 }, Callback = function(v) autoCampfireSettings.Speed = v end })

AutoTab:Section({ Title = "Auto Farm Gears Settings" })
AutoTab:Toggle({ Title = "Enable Auto Farm Gears", Default = false, Callback = function(s) autoGearsSettings.Enabled = s end })
AutoTab:Slider({ Title = "Gears Farm Delay (Seconds)", Step = 0.05, Value = { Min = 0.01, Max = 5, Default = 0.1 }, Callback = function(v) autoGearsSettings.Speed = v end })

AutoTab:Section({ Title = "Auto Eat Settings" })
AutoTab:Toggle({ Title = "Enable Auto Eat", Default = false, Callback = function(s) autoEatSettings.Enabled = s end })
AutoTab:Slider({ Title = "Eat Hunger Threshold (%)", Step = 1, Value = { Min = 10, Max = 100, Default = 90 }, Callback = function(v) autoEatSettings.Threshold = v end })

local BringTab = Window:Tab({ Title = "Bring", Icon = "navigation" })
BringTab:Section({ Title = "Global Bring Settings" })
BringTab:Dropdown({ Title = "Bring Destination", Values = {"玩家", "工作臺", "營火"}, Value = "玩家", Callback = function(v) globalSettings.BringDestination = v end })
BringTab:Slider({ Title = "Range (Studs)", Step = 10, Value = { Min = 50, Max = 3000, Default = 2000 }, Callback = function(v) globalSettings.Range = v end })
BringTab:Slider({ Title = "Max Count", Step = 1, Value = { Min = 1, Max = 500, Default = 100 }, Callback = function(v) globalSettings.MaxCount = v end })
BringTab:Slider({ Title = "Speed (Delay)", Step = 0.01, Value = { Min = 0.01, Max = 1, Default = 0.15 }, Callback = function(v) globalSettings.Speed = v end })

local bringCategories = {
    {"Bring Cultists", {"Jungle Cultist", "Darkstring Cultist", "Shadow Cultist", "Brutal Cultist", "Crossbow Cultist", "Juggernaut Cultist"}, {"Jungle Cultist", "Shadow Cultist"}},
    {"Bring Meteor Items", {"Raw Obsidiron Ore", "Gold Shard", "Meteor Shard", "Scalding Obsidiron Ingot"}, {"Raw Obsidiron Ore", "Meteor Shard"}},
    {"Bring Fuel", {"Log", "Chair", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}, {"Log", "Coal"}},
    {"Bring Food", {"Sweet Potato", "Stuffing", "Turkey Leg", "Carrot", "Pumpkin", "Mackerel", "Salmon", "Swordfish", "Berry", "Ribs", "Stew", "Steak Dinner", "Morsel", "Steak", "Corn", "Cooked Morsel", "Cooked Steak", "Chilli", "Apple", "Cake"}, {"Turkey Leg", "Salmon"}},
    {"Bring Healing", {"MedKit", "Bandage"}, {"MedKit", "Bandage"}},
    {"Bring Gears", {"Bolt", "Tyre", "Sheet Metal", "Old Radio", "Broken Fan", "Broken Microwave", "Washing Machine", "Old Car Engine", "UFO Scrap", "UFO Component", "UFO Junk", "Cultist Gem", "Gem of the Forest"}, {"Bolt", "Tyre", "Sheet Metal"}},
    {"Bring Guns & Armor", {"Infernal Sword", "Morningstar", "Crossbow", "Infernal Crossbow", "Laser Sword", "Raygun", "Ice Axe", "Ice Sword", "Chainsaw", "Strong Axe", "Axe Trim Kit", "Spear", "Good Axe", "Revolver", "Air Rifle", "Rifle", "Tactical Shotgun", "Revolver Ammo", "Rifle Ammo", "Alien Armour", "Frog Boots", "Leather Body", "Iron Body", "Thorn Body", "Riot Shield"}, {"Laser Sword", "Raygun"}}
}

for _, cat in ipairs(bringCategories) do
    local title, values, defaultVal = cat[1], cat[2], cat[3]
    local selected = defaultVal
    BringTab:Section({ Title = title })
    BringTab:Dropdown({ Title = "Select " .. title, Values = values, Multi = true, Value = defaultVal, Callback = function(v) selected = v end })
    BringTab:Button({ Title = title, Callback = function() task.spawn(function() executeBring(selected) end) end })
end

local ESPTab = Window:Tab({ Title = "ESP", Icon = "eye" })
ESPTab:Section({ Title = "Entities ESP" })
ESPTab:Toggle({ Title = "Player ESP", Default = false, Callback = function(s) espSettings.Players = s clearAllESP() end })
ESPTab:Toggle({ Title = "Tree ESP", Default = false, Callback = function(s) espSettings.Trees = s clearAllESP() end })
ESPTab:Toggle({ Title = "Rabbit ESP", Default = false, Callback = function(s) espSettings.Rabbits = s clearAllESP() end })

ESPTab:Section({ Title = "Item Categories ESP" })
local categoriesData = {
    ["Cultists"] = {"Jungle Cultist", "Darkstring Cultist", "Shadow Cultist", "Brutal Cultist", "Crossbow Cultist", "Juggernaut Cultist"},
    ["Meteor Items"] = {"Raw Obsidiron Ore", "Gold Shard", "Meteor Shard", "Scalding Obsidiron Ingot"},
    ["Fuel"] = {"Log", "Chair", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"},
    ["Food"] = {"Sweet Potato", "Stuffing", "Turkey Leg", "Carrot", "Pumpkin", "Mackerel", "Salmon", "Swordfish", "Berry", "Ribs", "Stew", "Steak Dinner", "Morsel", "Steak", "Corn", "Cooked Morsel", "Cooked Steak", "Chilli", "Apple", "Cake"},
    ["Healing"] = {"MedKit", "Bandage"},
    ["Gears"] = {"Bolt", "Tyre", "Sheet Metal", "Old Radio", "Broken Fan", "Broken Microwave", "Washing Machine", "Old Car Engine", "UFO Scrap", "UFO Component", "UFO Junk", "Cultist Gem", "Gem of the Forest"},
    ["Guns & Armor"] = {"Infernal Sword", "Morningstar", "Crossbow", "Infernal Crossbow", "Laser Sword", "Raygun", "Ice Axe", "Ice Sword", "Chainsaw", "Strong Axe", "Axe Trim Kit", "Spear", "Good Axe", "Revolver", "Air Rifle", "Rifle", "Tactical Shotgun", "Revolver Ammo", "Rifle Ammo", "Alien Armour", "Frog Boots", "Leather Body", "Iron Body", "Thorn Body", "Riot Shield"}
}

for category, items in pairs(categoriesData) do
    ESPTab:Toggle({
        Title = "ESP " .. category,
        Default = false,
        Callback = function(state)
            if state then
                local lookup = {}
                for _, item in ipairs(items) do lookup[item] = true end
                espSettings.Categories[category] = lookup
            else
                espSettings.Categories[category] = nil
            end
            clearAllESP()
        end,
    })
end

local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
PlayerTab:Section({ Title = "Movement Settings" })
PlayerTab:Toggle({ Title = "Enable WalkSpeed", Default = false, Callback = function(s) playerSettings.WalkSpeedEnabled = s if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16 end end })
PlayerTab:Slider({ Title = "WalkSpeed Value", Step = 1, Value = { Min = 16, Max = 200, Default = 30 }, Callback = function(v) playerSettings.WalkSpeed = v end })
PlayerTab:Toggle({ Title = "Enable JumpPower", Default = false, Callback = function(s) playerSettings.JumpPowerEnabled = s if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50 end end })
PlayerTab:Slider({ Title = "JumpPower Value", Step = 1, Value = { Min = 50, Max = 300, Default = 30 }, Callback = function(v) playerSettings.JumpPower = v end })

PlayerTab:Section({ Title = "Fly Settings" })
PlayerTab:Toggle({ Title = "Enable Fly", Default = false, Callback = function(s) playerSettings.FlyEnabled = s end })
PlayerTab:Slider({ Title = "Fly Speed", Step = 1, Value = { Min = 10, Max = 200, Default = 30 }, Callback = function(v) playerSettings.FlySpeed = v end })

local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
TeleportTab:Section({ Title = "Custom Teleport" })
TeleportTab:Button({ Title = "Tp to campfire", Callback = function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0.9, 13.5, -1.1) end end })

TeleportTab:Section({ Title = "Player Teleport" })
local selectedPlayerToTP = nil
local function getPlayerList()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then table.insert(names, plr.Name) end end
    return names
end

local playerDropdown = TeleportTab:Dropdown({ Title = "Select Player", Values = getPlayerList(), Value = nil, Callback = function(v) selectedPlayerToTP = v end })
TeleportTab:Button({
    Title = "Teleport to Selected Player",
    Callback = function()
        if selectedPlayerToTP then
            local targetPlr = Players:FindFirstChild(selectedPlayerToTP)
            if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end,
})
Players.PlayerAdded:Connect(function() playerDropdown:SetValues(getPlayerList()) end)
Players.PlayerRemoving:Connect(function() playerDropdown:SetValues(getPlayerList()) end)

local MiscTab = Window:Tab({ Title = "Misc", Icon = "wrench" })
MiscTab:Section({ Title = "FullBright Settings" })
MiscTab:Toggle({ Title = "Enable FullBright", Default = false, Callback = function(s) miscSettings.FullBrightEnabled = s if not s then Lighting.Brightness = 1 Lighting.ClockTime = 14 Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127) Lighting.GlobalShadows = true end end })
MiscTab:Slider({ Title = "Brightness", Step = 0.5, Value = { Min = 1, Max = 10, Default = 2 }, Callback = function(v) miscSettings.Brightness = v end })
MiscTab:Slider({ Title = "Clock Time (Sun Hour)", Tag = "Clock Time", Step = 1, Value = { Min = 0, Max = 24, Default = 14 }, Callback = function(v) miscSettings.ClockTime = v end })

MiscTab:Section({ Title = "Player Glow Settings" })
MiscTab:Toggle({ Title = "Enable Player Glow", Default = false, Callback = function(s) miscSettings.GlowEnabled = s if not s and glowPointLight then glowPointLight:Destroy() glowPointLight = nil end end })
MiscTab:Slider({ Title = "Glow Brightness", Step = 1, Value = { Min = 1, Max = 50, Default = 10 }, Callback = function(v) miscSettings.GlowBrightness = v end })
MiscTab:Slider({ Title = "Glow Range (Studs)", Step = 5, Value = { Min = 5, Max = 100, Default = 20 }, Callback = function(v) miscSettings.GlowRange = v end })

Window:SelectTab(1)
