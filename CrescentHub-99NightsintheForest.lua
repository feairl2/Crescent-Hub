local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Crescent Hub - 99 Nights in the Forest",
    Icon = "sparkles",
    Author = "Crescent Team",
    Folder = "CrescentHub",
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    Size = UDim2.fromOffset(600, 440),
})

local globalSettings = {
    Range = 1000,
    MaxCount = 10,
    Speed = 0.15
}

local autoCampfireSettings = {
    Enabled = false,
    Speed = 0.5,
    TargetPosition = Vector3.new(0.3, 11.7, 0.3)
}

local autoGearsSettings = {
    Enabled = false,
    Speed = 0.1
}

local autoFlowerSettings = {
    Enabled = false,
    MaxCount = 10,
    Speed = 0.2
}

local autoCoinsSettings = {
    Enabled = false,
    MaxCount = 10,
    Speed = 0.2
}

local autoEatSettings = {
    Enabled = false
}

local godModeSettings = {
    Enabled = false,
    Height = 15
}

local killAuraSettings = {
    Enabled = false,
    Range = 70,
    Delay = 0.1
}

local treeAuraSettings = {
    Enabled = false,
    Range = 1000,
    Delay = 0.8
}

local autoDaySettings = {
    Enabled = false,
    Radius = 150,
    Height = 100,
    Speed = 1
}
local autoDayAngle = 0

local playerSettings = {
    WalkSpeedEnabled = false,
    WalkSpeed = 30,
    JumpPowerEnabled = false,
    JumpPower = 30,
    FlyEnabled = false,
    FlySpeed = 30
}

local miscSettings = {
    FullBrightEnabled = false,
    Brightness = 2,
    ClockTime = 14,
    Ambient = Color3.fromRGB(200, 200, 200),
    
    GlowEnabled = false,
    GlowBrightness = 10,
    GlowRange = 20,
    GlowColor = Color3.fromRGB(255, 255, 255)
}

local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function executeBring(targetNames)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    local nameLookup = {}
    for _, name in ipairs(targetNames) do
        nameLookup[name] = true
    end

    local broughtCount = 0

    for _, obj in ipairs(workspace:GetDescendants()) do
        if broughtCount >= globalSettings.MaxCount then break end

        if obj:IsA("Model") or obj:IsA("BasePart") then
            if not obj:IsDescendantOf(character) then
                local objName = obj.Name
                if nameLookup[objName] then
                    local objPosition = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position) or nil
                    
                    if objPosition then
                        local distance = (objPosition - rootPart.Position).Magnitude
                        if distance <= globalSettings.Range then
                            local randomOffsetX = math.random(-3, 3)
                            local randomOffsetZ = math.random(-3, 3)
                            local randomOffsetY = math.random(1, 4)
                            local targetCFrame = rootPart.CFrame + Vector3.new(randomOffsetX, randomOffsetY, randomOffsetZ)

                            if obj:IsA("Model") then
                                obj:SetPrimaryPartCFrame(targetCFrame)
                                for _, part in ipairs(obj:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.Anchored = false
                                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                    end
                                end
                            elseif obj:IsA("BasePart") then
                                obj.CFrame = targetCFrame
                                obj.Anchored = false
                                obj.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                obj.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            end

                            broughtCount = broughtCount + 1
                            task.wait(globalSettings.Speed)
                        end
                    end
                end
            end
        end
    end
end

task.spawn(function()
    local fuelNames = {
        ["Log"] = true,
        ["Chair"] = true,
        ["Coal"] = true,
        ["Fuel Canister"] = true,
        ["Oil Barrel"] = true
    }

    while true do
        if autoCampfireSettings.Enabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if autoCampfireSettings.Enabled and (obj:IsA("Model") or obj:IsA("BasePart")) then
                        if not obj:IsDescendantOf(character) and fuelNames[obj.Name] then
                            local objPosition = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position) or nil
                            if objPosition then
                                local distance = (objPosition - character.HumanoidRootPart.Position).Magnitude
                                if distance <= globalSettings.Range then
                                    if obj:IsA("Model") then
                                        obj:SetPrimaryPartCFrame(CFrame.new(autoCampfireSettings.TargetPosition))
                                        for _, part in ipairs(obj:GetDescendants()) do
                                            if part:IsA("BasePart") then part.Anchored = false end
                                        end
                                    elseif obj:IsA("BasePart") then
                                        obj.CFrame = CFrame.new(autoCampfireSettings.TargetPosition)
                                        obj.Anchored = false
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
            task.wait(autoCampfireSettings.Speed)
        else
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    local gearNames = {
        ["Bolt"] = true,
        ["Tyre"] = true,
        ["Sheet Metal"] = true,
        ["Old Radio"] = true,
        ["Broken Fan"] = true,
        ["Broken Microwave"] = true,
        ["Washing Machine"] = true,
        ["Old Car Engine"] = true,
        ["UFO Scrap"] = true,
        ["UFO Component"] = true,
        ["UFO Junk"] = true,
        ["Cultist Gem"] = true,
        ["Gem of the Forest"] = true
    }

    while true do
        if autoGearsSettings.Enabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetGrinder = workspace:FindFirstChild("GrindersLeft", true)
                
                if targetGrinder then
                    local targetPos = nil
                    if targetGrinder:IsA("Model") and targetGrinder.PrimaryPart then
                        targetPos = targetGrinder.PrimaryPart.Position
                    elseif targetGrinder:IsA("BasePart") then
                        targetPos = targetGrinder.Position
                    end

                    if targetPos then
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if autoGearsSettings.Enabled and (obj:IsA("Model") or obj:IsA("BasePart")) then
                                if not obj:IsDescendantOf(character) and gearNames[obj.Name] then
                                    local objPosition = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position) or nil
                                    if objPosition then
                                        local distance = (objPosition - character.HumanoidRootPart.Position).Magnitude
                                        if distance <= globalSettings.Range then
                                            if obj:IsA("Model") then
                                                obj:SetPrimaryPartCFrame(CFrame.new(targetPos))
                                                for _, part in ipairs(obj:GetDescendants()) do
                                                    if part:IsA("BasePart") then part.Anchored = false end
                                                end
                                            elseif obj:IsA("BasePart") then
                                                obj.CFrame = CFrame.new(targetPos)
                                                obj.Anchored = false
                                            end
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(autoGearsSettings.Speed)
        else
            task.wait(0.1)
        end
    end
end)

task.spawn(function()
    local foodNames = {
        ["Sweet Potato"] = true,
        ["Stuffing"] = true,
        ["Turkey Leg"] = true,
        ["Carrot"] = true,
        ["Pumpkin"] = true,
        ["Mackerel"] = true,
        ["Salmon"] = true,
        ["Swordfish"] = true,
        ["Berry"] = true
    }

    while true do
        if autoEatSettings.Enabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local originalCFrame = rootPart.CFrame
                local foundFood = false

                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not autoEatSettings.Enabled then break end

                    if obj:IsA("Model") or obj:IsA("BasePart") then
                        if not obj:IsDescendantOf(character) then
                            local objName = obj.Name
                            if foodNames[objName] then
                                local objPosition = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position) or nil
                                
                                if objPosition then
                                    local distance = (objPosition - originalCFrame.Position).Magnitude
                                    if distance <= globalSettings.Range then
                                        if obj:IsA("Model") and obj.PrimaryPart then
                                            rootPart.CFrame = obj.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                        elseif obj:IsA("BasePart") then
                                            rootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                        end
                                        
                                        task.wait(0.1)
                                        pressE()
                                        task.wait(0.15)
                                        
                                        rootPart.CFrame = originalCFrame
                                        foundFood = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                
                if not foundFood then
                    task.wait(2)
                else
                    task.wait(2)
                end
            else
                task.wait(1)
            end
        else
            task.wait(1)
        end
    end
end)

task.spawn(function()
    local flowerNames = {
        ["Flower"] = true,
        ["Blue Flower"] = true,
        ["Red Flower"] = true,
        ["Yellow Flower"] = true,
        ["Wild Flower"] = true,
        ["White Flower"] = true
    }

    while true do
        if autoFlowerSettings.Enabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local processedCount = 0

                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not autoFlowerSettings.Enabled then break end
                    if processedCount >= autoFlowerSettings.MaxCount then break end

                    if obj:IsA("Model") or obj:IsA("BasePart") then
                        if not obj:IsDescendantOf(character) then
                            local objName = obj.Name
                            local isFlower = flowerNames[objName] or string.find(string.lower(objName), "flower")
                            
                            if isFlower then
                                local objPosition = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position) or nil
                                
                                if objPosition then
                                    local distance = (objPosition - rootPart.Position).Magnitude
                                    if distance <= globalSettings.Range then
                                        if obj:IsA("Model") and obj.PrimaryPart then
                                            rootPart.CFrame = obj.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                        elseif obj:IsA("BasePart") then
                                            rootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                        end
                                        
                                        task.wait(0.1)
                                        pressE()
                                        
                                        processedCount = processedCount + 1
                                        task.wait(autoFlowerSettings.Speed)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        else
            task.wait(0.2)
        end
    end
end)

task.spawn(function()
    local coinNames = {
        ["Coin"] = true,
        ["Coins"] = true,
        ["Gold Coin"] = true,
        ["Silver Coin"] = true
    }

    while true do
        if autoCoinsSettings.Enabled then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local processedCount = 0

                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not autoCoinsSettings.Enabled then break end
                    if processedCount >= autoCoinsSettings.MaxCount then break end

                    if obj:IsA("Model") or obj:IsA("BasePart") then
                        if not obj:IsDescendantOf(character) then
                            local objName = obj.Name
                            local isCoin = coinNames[objName] or string.find(string.lower(objName), "coin") or string.find(string.lower(objName), "cash")
                            
                            if isCoin then
                                local objPosition = (obj:IsA("Model") and obj.PrimaryPart and obj.PrimaryPart.Position) or (obj:IsA("BasePart") and obj.Position) or nil
                                
                                if objPosition then
                                    local distance = (objPosition - rootPart.Position).Magnitude
                                    if distance <= globalSettings.Range then
                                        if obj:IsA("Model") and obj.PrimaryPart then
                                            rootPart.CFrame = obj.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                        elseif obj:IsA("BasePart") then
                                            rootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                                        end
                                        
                                        task.wait(0.1)
                                        pressE()
                                        
                                        processedCount = processedCount + 1
                                        task.wait(autoCoinsSettings.Speed)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        else
            task.wait(0.2)
        end
    end
end)

task.spawn(function()
    while true do
        if killAuraSettings.Enabled then
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")

            local weapon = player.Inventory:FindFirstChild("Old Axe")
                or player.Inventory:FindFirstChild("Good Axe")
                or player.Inventory:FindFirstChild("Strong Axe")
                or player.Inventory:FindFirstChild("Chainsaw")

            if weapon then
                for _, mob in pairs(workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") and mob.PrimaryPart and mob ~= character then
                        local distance = (mob.PrimaryPart.Position - hrp.Position).Magnitude
                        if distance <= killAuraSettings.Range then
                            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(
                                mob, weapon, 999, hrp.CFrame
                            )
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
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            
            local weapon = player.Inventory:FindFirstChild("Old Axe") 
                or player.Inventory:FindFirstChild("Good Axe") 
                or player.Inventory:FindFirstChild("Strong Axe") 
                or player.Inventory:FindFirstChild("Chainsaw")

            if weapon then
                local function chop(folder)
                    for _, tree in pairs(folder:GetChildren()) do
                        if tree:IsA("Model") and (tree.Name == "Small Tree" or tree.Name == "TreeBig1" or tree.Name == "TreeBig2") and tree.PrimaryPart then
                            local distance = (tree.PrimaryPart.Position - hrp.Position).Magnitude
                            if distance <= treeAuraSettings.Range then
                                game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(
                                    tree, weapon, 999, hrp.CFrame
                                )
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
        task.wait(treeAuraSettings.Delay)
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if autoDaySettings.Enabled then
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            autoDayAngle = autoDayAngle + autoDaySettings.Speed * dt
            local x = math.cos(autoDayAngle) * autoDaySettings.Radius
            local z = math.sin(autoDayAngle) * autoDaySettings.Radius
            local newPos = Vector3.new(x, autoDaySettings.Height, z)
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

        local rayOrigin = rootPart.Position + Vector3.new(0, 5, 0)
        local rayDirection = Vector3.new(0, -500, 0)
        local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

        local targetY = rayOrigin.Y - 5
        if raycastResult then
            targetY = raycastResult.Position.Y
        end

        local desiredY = targetY + godModeSettings.Height
        local currentVelocity = rootPart.AssemblyLinearVelocity

        rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
        rootPart.CFrame = CFrame.new(rootPart.Position.X, desiredY, rootPart.Position.Z) * (rootPart.CFrame - rootPart.Position)
    end
end)

local flyLockedPosition = nil

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end

    if playerSettings.WalkSpeedEnabled then
        humanoid.WalkSpeed = playerSettings.WalkSpeed
    end

    if playerSettings.JumpPowerEnabled then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = playerSettings.JumpPower
    end

    if playerSettings.FlyEnabled then
        humanoid.PlatformStand = true
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end

        local camLook = camera.CFrame.LookVector
        local flatLook = Vector3.new(camLook.X, 0, camLook.Z)
        if flatLook.Magnitude > 0 then
            flatLook = flatLook.Unit
        else
            flatLook = Vector3.new(0, 0, -1)
        end

        if moveDirection.Magnitude > 0 then
            flyLockedPosition = nil
            moveDirection = moveDirection.Unit * playerSettings.FlySpeed
            rootPart.AssemblyLinearVelocity = moveDirection
            rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + flatLook)
        else
            if not flyLockedPosition then
                flyLockedPosition = rootPart.Position
            end
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.CFrame = CFrame.new(flyLockedPosition, flyLockedPosition + flatLook)
        end
    else
        flyLockedPosition = nil
        if humanoid.PlatformStand and not godModeSettings.Enabled then
            humanoid.PlatformStand = false
        end
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
    else
        if glowPointLight then
            glowPointLight.Enabled = false
        end
    end
end)

local InfoTab = Window:Tab({
    Title = "Information",
    Icon = "info",
})

InfoTab:Section({
    Title = "Community & Links",
})

InfoTab:Button({
    Title = "Website",
    Desc = "Click to copy the official website link",
    Callback = function()
        if setclipboard then
            setclipboard("https://crescent-ds7.pages.dev/")
            WindUI:Notify({
                Title = "Success",
                Content = "Website link copied to clipboard!",
                Duration = 3,
            })
        end
    end,
})

InfoTab:Button({
    Title = "Discord",
    Desc = "Click to copy the Discord invite link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/sy4R8MbDAQ")
            WindUI:Notify({
                Title = "Success",
                Content = "Discord link copied to clipboard!",
                Duration = 3,
            })
        end
    end,
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "shield",
})

MainTab:Section({
    Title = "Auto Day Settings",
})

MainTab:Toggle({
    Title = "Auto Days",
    Desc = "Circle Tween map",
    Icon = "star",
    Default = false,
    Callback = function(state)
        autoDaySettings.Enabled = state
        WindUI:Notify({
            Title = "Auto Days",
            Content = state and "Auto Days Enabled" or "Auto Days Disabled",
            Duration = 2,
        })
    end,
})

MainTab:Slider({
    Title = "Circle Radius",
    Step = 10,
    Value = {
        Min = 50,
        Max = 500,
        Default = 150
    },
    Callback = function(value)
        autoDaySettings.Radius = value
    end,
})

MainTab:Slider({
    Title = "Circle Height",
    Step = 10,
    Value = {
        Min = 10,
        Max = 300,
        Default = 100
    },
    Callback = function(value)
        autoDaySettings.Height = value
    end,
})

MainTab:Slider({
    Title = "Circle Speed",
    Step = 0.1,
    Value = {
        Min = 0.1,
        Max = 5,
        Default = 1
    },
    Callback = function(value)
        autoDaySettings.Speed = value
    end,
})

MainTab:Section({
    Title = "God Mode Settings",
})

MainTab:Toggle({
    Title = "Enable God Mode (Float)",
    Desc = "Keep your character walking in the air at a set distance above ground",
    Default = false,
    Callback = function(state)
        godModeSettings.Enabled = state
        WindUI:Notify({
            Title = "God Mode",
            Content = state and "God Mode Enabled" or "God Mode Disabled",
            Duration = 2,
        })
    end,
})

MainTab:Slider({
    Title = "Float Height (Studs)",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 15
    },
    Callback = function(value)
        godModeSettings.Height = value
    end,
})

MainTab:Section({
    Title = "Kill Aura Settings",
})

MainTab:Toggle({
    Title = "Enable Kill Aura",
    Desc = "Continuously damage nearby mobs using backend tool events",
    Default = false,
    Callback = function(state)
        killAuraSettings.Enabled = state
        WindUI:Notify({
            Title = "Kill Aura",
            Content = state and "Kill Aura Enabled" or "Kill Aura Disabled",
            Duration = 2,
        })
    end,
})

MainTab:Slider({
    Title = "Kill Aura Range (Studs)",
    Step = 5,
    Value = {
        Min = 10,
        Max = 200,
        Default = 70
    },
    Callback = function(value)
        killAuraSettings.Range = value
    end,
})

MainTab:Slider({
    Title = "Kill Aura Delay (Seconds)",
    Step = 0.05,
    Value = {
        Min = 0.05,
        Max = 2,
        Default = 0.1
    },
    Callback = function(value)
        killAuraSettings.Delay = value
    end,
})

MainTab:Section({
    Title = "Tree Aura Settings (Auto Chop)",
})

MainTab:Toggle({
    Title = "Enable Tree Aura",
    Desc = "Automatically chop down nearby trees using axes or chainsaw",
    Default = false,
    Callback = function(state)
        treeAuraSettings.Enabled = state
        WindUI:Notify({
            Title = "Tree Aura",
            Content = state and "Tree Aura Enabled" or "Tree Aura Disabled",
            Duration = 2,
        })
    end,
})

MainTab:Slider({
    Title = "Tree Aura Range (Studs)",
    Step = 50,
    Value = {
        Min = 100,
        Max = 3000,
        Default = 1000
    },
    Callback = function(value)
        treeAuraSettings.Range = value
    end,
})

MainTab:Slider({
    Title = "Tree Aura Delay (Seconds)",
    Step = 0.05,
    Value = {
        Min = 0.05,
        Max = 2,
        Default = 0.8
    },
    Callback = function(value)
        treeAuraSettings.Delay = value
    end,
})

local AutoTab = Window:Tab({
    Title = "Auto",
    Icon = "refresh-cw",
})

AutoTab:Section({
    Title = "Auto Campfire Settings",
})

AutoTab:Toggle({
    Title = "Enable Auto Campfire",
    Desc = "Automatically feed fuel items to the campfire coordinate",
    Default = false,
    Callback = function(state)
        autoCampfireSettings.Enabled = state
        WindUI:Notify({
            Title = "Auto Campfire",
            Content = state and "Auto Campfire Enabled" or "Auto Campfire Disabled",
            Duration = 2,
        })
    end,
})

AutoTab:Slider({
    Title = "Feed Delay (Seconds)",
    Step = 0.05,
    Value = {
        Min = 0.01,
        Max = 5,
        Default = 0.5
    },
    Callback = function(value)
        autoCampfireSettings.Speed = value
    end,
})

AutoTab:Section({
    Title = "Auto Farm Gears Settings",
})

AutoTab:Toggle({
    Title = "Enable Auto Farm Gears",
    Desc = "Automatically bring Gears to GrindersLeft object",
    Default = false,
    Callback = function(state)
        autoGearsSettings.Enabled = state
        WindUI:Notify({
            Title = "Auto Farm Gears",
            Content = state and "Auto Farm Gears Enabled" or "Auto Farm Gears Disabled",
            Duration = 2,
        })
    end,
})

AutoTab:Slider({
    Title = "Gears Farm Delay (Seconds)",
    Step = 0.05,
    Value = {
        Min = 0.01,
        Max = 5,
        Default = 0.1
    },
    Callback = function(value)
        autoGearsSettings.Speed = value
    end,
})

AutoTab:Section({
    Title = "Auto Eat Settings",
})

AutoTab:Toggle({
    Title = "Enable Auto Eat",
    Desc = "Automatically teleport to a random food item, press E to eat, and return back",
    Default = false,
    Callback = function(state)
        autoEatSettings.Enabled = state
        WindUI:Notify({
            Title = "Auto Eat",
            Content = state and "Auto Eat Enabled" or "Auto Eat Disabled",
            Duration = 2,
        })
    end,
})

AutoTab:Section({
    Title = "Auto Flower Settings",
})

AutoTab:Toggle({
    Title = "Enable Auto Flower",
    Desc = "Automatically teleport to flowers, press E, and collect them",
    Default = false,
    Callback = function(state)
        autoFlowerSettings.Enabled = state
        WindUI:Notify({
            Title = "Auto Flower",
            Content = state and "Auto Flower Enabled" or "Auto Flower Disabled",
            Duration = 2,
        })
    end,
})

AutoTab:Slider({
    Title = "Flower Max Count",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 10
    },
    Callback = function(value)
        autoFlowerSettings.MaxCount = value
    end,
})

AutoTab:Slider({
    Title = "Flower Speed (Delay)",
    Step = 0.05,
    Value = {
        Min = 0.05,
        Max = 2,
        Default = 0.2
    },
    Callback = function(value)
        autoFlowerSettings.Speed = value
    end,
})

AutoTab:Section({
    Title = "Auto Pick Coins Settings",
})

AutoTab:Toggle({
    Title = "Enable Auto Pick Coins",
    Desc = "Automatically teleport to coins, press E, and collect them",
    Default = false,
    Callback = function(state)
        autoCoinsSettings.Enabled = state
        WindUI:Notify({
            Title = "Auto Pick Coins",
            Content = state and "Auto Pick Coins Enabled" or "Auto Pick Coins Disabled",
            Duration = 2,
        })
    end,
})

AutoTab:Slider({
    Title = "Coins Max Count",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 10
    },
    Callback = function(value)
        autoCoinsSettings.MaxCount = value
    end,
})

AutoTab:Slider({
    Title = "Coins Speed (Delay)",
    Step = 0.05,
    Value = {
        Min = 0.05,
        Max = 2,
        Default = 0.2
    },
    Callback = function(value)
        autoCoinsSettings.Speed = value
    end,
})

local BringTab = Window:Tab({
    Title = "Bring",
    Icon = "navigation",
})

BringTab:Section({
    Title = "Global Bring Settings",
})

BringTab:Slider({
    Title = "Range (Studs)",
    Step = 10,
    Value = {
        Min = 50,
        Max = 3000,
        Default = 1000
    },
    Callback = function(value)
        globalSettings.Range = value
    end,
})

BringTab:Slider({
    Title = "Max Count",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 10
    },
    Callback = function(value)
        globalSettings.MaxCount = value
    end,
})

BringTab:Slider({
    Title = "Speed (Delay)",
    Step = 0.01,
    Value = {
        Min = 0.01,
        Max = 1,
        Default = 0.15
    },
    Callback = function(value)
        globalSettings.Speed = value
    end,
})

BringTab:Section({
    Title = "Bring Cultists",
})

local selectedCultists = {"Jungle Cultist", "Shadow Cultist"}
BringTab:Dropdown({
    Title = "Select Cultist",
    Values = {
        "Jungle Cultist",
        "Darkstring Cultist",
        "Shadow Cultist",
        "Brutal Cultist",
        "Crossbow Cultist",
        "Juggernaut Cultist"
    },
    Multi = true,
    Value = {"Jungle Cultist", "Shadow Cultist"},
    Callback = function(value)
        selectedCultists = value
    end,
})

BringTab:Button({
    Title = "Bring Cultists",
    Desc = "Execute bring for selected cultists",
    Callback = function()
        task.spawn(function()
            executeBring(selectedCultists)
        end)
        WindUI:Notify({
            Title = "Success",
            Content = "Bringing selected cultists...",
            Duration = 3,
        })
    end,
})

BringTab:Section({
    Title = "Bring Meteor Items",
})

local selectedMeteor = {"Raw Obsidiron Ore", "Meteor Shard"}
BringTab:Dropdown({
    Title = "Select Meteor Item",
    Values = {
        "Raw Obsidiron Ore",
        "Gold Shard",
        "Meteor Shard",
        "Scalding Obsidiron Ingot"
    },
    Multi = true,
    Value = {"Raw Obsidiron Ore", "Meteor Shard"},
    Callback = function(value)
        selectedMeteor = value
    end,
})

BringTab:Button({
    Title = "Bring Meteor Items",
    Desc = "Execute bring for selected meteor items",
    Callback = function()
        task.spawn(function()
            executeBring(selectedMeteor)
        end)
        WindUI:Notify({
            Title = "Success",
            Content = "Bringing selected meteor items...",
            Duration = 3,
        })
    end,
})

BringTab:Section({
    Title = "Bring Fuel [BETA]",
})

local selectedFuel = {"Log", "Coal"}
BringTab:Dropdown({
    Title = "Select Fuel",
    Values = {
        "Log",
        "Chair",
        "Coal",
        "Fuel Canister",
        "Oil Barrel"
    },
    Multi = true,
    Value = {"Log", "Coal"},
    Callback = function(value)
        selectedFuel = value
    end,
})

BringTab:Button({
    Title = "Bring Fuel",
    Desc = "Execute bring for selected fuel",
    Callback = function()
        task.spawn(function()
            executeBring(selectedFuel)
        end)
        WindUI:Notify({
            Title = "Success",
            Content = "Bringing selected fuel...",
            Duration = 3,
        })
    end,
})

BringTab:Section({
    Title = "Bring Food",
})

local selectedFood = {"Turkey Leg", "Salmon"}
BringTab:Dropdown({
    Title = "Select Food",
    Values = {
        "Sweet Potato",
        "Stuffing",
        "Turkey Leg",
        "Carrot",
        "Pumpkin",
        "Mackerel",
        "Salmon",
        "Swordfish",
        "Berry"
    },
    Multi = true,
    Value = {"Turkey Leg", "Salmon"},
    Callback = function(value)
        selectedFood = value
    end,
})

BringTab:Button({
    Title = "Bring Food",
    Desc = "Execute bring for selected food",
    Callback = function()
        task.spawn(function()
            executeBring(selectedFood)
        end)
        WindUI:Notify({
            Title = "Success",
            Content = "Bringing selected food...",
            Duration = 3,
        })
    end,
})

BringTab:Section({
    Title = "Bring Healing",
})

local selectedHealing = {"MedKit", "Bandage"}
BringTab:Dropdown({
    Title = "Select Healing",
    Values = {
        "MedKit",
        "Bandage"
    },
    Multi = true,
    Value = {"MedKit", "Bandage"},
    Callback = function(value)
        selectedHealing = value
    end,
})

BringTab:Button({
    Title = "Bring Healing",
    Desc = "Execute bring for selected healing items",
    Callback = function()
        task.spawn(function()
            executeBring(selectedHealing)
        end)
        WindUI:Notify({
            Title = "Success",
            Content = "Bringing selected healing items...",
            Duration = 3,
        })
    end,
})

BringTab:Section({
    Title = "Bring Gears",
})

local selectedGears = {"Bolt", "Tyre", "Sheet Metal"}
BringTab:Dropdown({
    Title = "Select Gear",
    Values = {
        "Bolt",
        "Tyre",
        "Sheet Metal",
        "Old Radio",
        "Broken Fan",
        "Broken Microwave",
        "Washing Machine",
        "Old Car Engine",
        "UFO Scrap",
        "UFO Component",
        "UFO Junk",
        "Cultist Gem",
        "Gem of the Forest"
    },
    Multi = true,
    Value = {"Bolt", "Tyre", "Sheet Metal"},
    Callback = function(value)
        selectedGears = value
    end,
})

BringTab:Button({
    Title = "Bring Gears",
    Desc = "Execute bring for selected gears",
    Callback = function()
        task.spawn(function()
            executeBring(selectedGears)
        end)
        WindUI:Notify({
            Title = "Success",
            Content = "Bringing selected gears...",
            Duration = 3,
        })
    end,
})

BringTab:Section({
    Title = "Bring Guns & Armor",
})

local selectedGunsArmor = {"Shotgun", "Armor Vest"}
BringTab:Dropdown({
    Title = "Select Gun or Armor",
    Values = {
        "Pistol",
        "Shotgun",
        "Rifle",
        "Assault Rifle",
        "Armor Vest",
        "Helmet"
    },
    Multi = true,
    Value = {"Shotgun", "Armor Vest"},
    Callback = function(value)
        selectedGunsArmor = value
    end,
})

BringTab:Button({
    Title = "Bring Guns & Armor",
    Desc = "Execute bring for selected guns or armor",
    Callback = function()
        task.spawn(function()
            executeBring(selectedGunsArmor)
        end)
        WindUI:Notify({
            Title = "Success",
            Content = "Bringing selected guns & armor...",
            Duration = 3,
        })
    end,
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
})

PlayerTab:Section({
    Title = "Movement Settings",
})

PlayerTab:Toggle({
    Title = "Enable WalkSpeed",
    Desc = "Modify character walking speed",
    Default = false,
    Callback = function(state)
        playerSettings.WalkSpeedEnabled = state
        if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end,
})

PlayerTab:Slider({
    Title = "WalkSpeed Value",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 30
    },
    Callback = function(value)
        playerSettings.WalkSpeed = value
    end,
})

PlayerTab:Toggle({
    Title = "Enable JumpPower",
    Desc = "Modify character jump power",
    Default = false,
    Callback = function(state)
        playerSettings.JumpPowerEnabled = state
        if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
        end
    end,
})

PlayerTab:Slider({
    Title = "JumpPower Value",
    Step = 1,
    Value = {
        Min = 50,
        Max = 300,
        Default = 30
    },
    Callback = function(value)
        playerSettings.JumpPower = value
    end,
})

PlayerTab:Section({
    Title = "Fly Settings",
})

PlayerTab:Toggle({
    Title = "Enable Fly",
    Desc = "Fly freely in the air without falling down",
    Default = false,
    Callback = function(state)
        playerSettings.FlyEnabled = state
        WindUI:Notify({
            Title = "Fly",
            Content = state and "Fly Enabled" or "Fly Disabled",
            Duration = 2,
        })
    end,
})

PlayerTab:Slider({
    Title = "Fly Speed",
    Step = 1,
    Value = {
        Min = 10,
        Max = 200,
        Default = 30
    },
    Callback = function(value)
        playerSettings.FlySpeed = value
    end,
})

local TeleportTab = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

TeleportTab:Section({
    Title = "Custom Teleport",
})

TeleportTab:Button({
    Title = "Tp to campfire",
    Desc = "Teleport back to the campfire",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(0.9, 13.5, -1.1)
            WindUI:Notify({
                Title = "Teleport",
                Content = "Successfully teleported to campfire!",
                Duration = 2,
            })
        end
    end,
})

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "wrench",
})

MiscTab:Section({
    Title = "FullBright Settings",
})

MiscTab:Toggle({
    Title = "Enable FullBright",
    Desc = "Make the entire map bright and remove dark shadows",
    Default = false,
    Callback = function(state)
        miscSettings.FullBrightEnabled = state
        if not state then
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            Lighting.GlobalShadows = true
        end
        WindUI:Notify({
            Title = "FullBright",
            Content = state and "FullBright Enabled" or "FullBright Disabled",
            Duration = 2,
        })
    end,
})

MiscTab:Slider({
    Title = "Brightness",
    Step = 0.5,
    Value = {
        Min = 1,
        Max = 10,
        Default = 2
    },
    Callback = function(value)
        miscSettings.Brightness = value
    end,
})

MiscTab:Slider({
    Title = "Clock Time (Sun Hour)",
    Step = 1,
    Value = {
        Min = 0,
        Max = 24,
        Default = 14
    },
    Callback = function(value)
        miscSettings.ClockTime = value
    end,
})

MiscTab:Section({
    Title = "Player Glow Settings",
})

MiscTab:Toggle({
    Title = "Enable Player Glow",
    Desc = "Attach a custom light source around your character",
    Default = false,
    Callback = function(state)
        miscSettings.GlowEnabled = state
        if not state and glowPointLight then
            glowPointLight:Destroy()
            glowPointLight = nil
        end
        WindUI:Notify({
            Title = "Player Glow",
            Content = state and "Player Glow Enabled" or "Player Glow Disabled",
            Duration = 2,
        })
    end,
})

MiscTab:Slider({
    Title = "Glow Brightness",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 10
    },
    Callback = function(value)
        miscSettings.GlowBrightness = value
    end,
})

MiscTab:Slider({
    Title = "Glow Range (Studs)",
    Step = 5,
    Value = {
        Min = 5,
        Max = 100,
        Default = 20
    },
    Callback = function(value)
        miscSettings.GlowRange = value
    end,
})

Window:SelectTab(1)
