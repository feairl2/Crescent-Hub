local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ESP_Enabled = false
local ESP_ShowRoles = false
local ESP_ShowNames = false
local ESP_ShowGun = false
local ChamsContainer = {}
local GunESPContainer = {}
local Noclip_Enabled = false

local Fly_Enabled = false
local FlySpeed = 30
local Fly_BodyVelocity = nil
local Fly_BodyGyro = nil

local AutoFarm_Enabled = false
local FarmSpeed = 30
local KillAll_Enabled = false
local AutoGrabGun_Enabled = false

local AutoDodgeKnife_Enabled = false

local XRay_Enabled = false
local OriginalTransparency = {}

local FakeDeath_Enabled = false
local OriginalCFrame = nil
local IsFlinging = false

local Window = WindUI:CreateWindow({
    Title = "Crescent Hub - MM2",
    Icon = "sparkles",
    Author = "Crescent",
    Folder = "CrescentHub",
    Size = UDim2.fromOffset(600, 420),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
})

local function ClearAllNameTags()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head and head:FindFirstChild("NameESP") then
                head.NameESP:Destroy()
            end
        end
    end
end

local function ClearGunESP()
    for _, box in pairs(GunESPContainer) do
        if box then pcall(function() box:Destroy() end) end
    end
    table.clear(GunESPContainer)
end

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "rbxassetid://4483345998",
})

MainTab:Section({ Title = "Official Website" })

MainTab:Button({
    Title = "Copy Website URL",
    Desc = "Copy the official website link.",
    Callback = function()
        if setclipboard then setclipboard("https://crescent-ds7.pages.dev/") end
        WindUI:Notify({ Title = "Crescent Hub", Content = "Website link copied!", Duration = 2 })
    end
})

MainTab:Section({ Title = "Discord Community" })

MainTab:Button({
    Title = "Join Our Discord",
    Desc = "Copy the Discord invite link.",
    Callback = function()
        if setclipboard then setclipboard("https://discord.gg/sy4R8MbDAQ") end
        WindUI:Notify({ Title = "Crescent Hub", Content = "Discord link copied!", Duration = 2 })
    end
})

local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "sword",
})

CombatTab:Section({ Title = "Murderer Automation" })

CombatTab:Toggle({
    Title = "Auto Kill All (As Murderer)",
    Desc = "Teleport behind targets, ensure death, and avoid repeats.",
    Default = false,
    Callback = function(Value) KillAll_Enabled = Value end
})

CombatTab:Section({ Title = "Sheriff Automation" })

CombatTab:Button({
    Title = "Auto Kill Murderer (As Sheriff)",
    Desc = "Instantly teleport behind the murderer and shoot him.",
    Callback = function()
        local lp = Players.LocalPlayer
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if root and hum and hum.Health > 0 then
            local gun = lp:FindFirstChild("Backpack") and lp.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun")
            if gun then
                local murderer = nil
                for _, enemy in pairs(Players:GetPlayers()) do
                    if enemy ~= lp and enemy.Character then
                        local hasKnife = enemy:FindFirstChild("Backpack") and enemy.Backpack:FindFirstChild("Knife") or enemy.Character:FindFirstChild("Knife")
                        if hasKnife and enemy.Character:FindFirstChild("HumanoidRootPart") and enemy.Character:FindFirstChild("Humanoid") and enemy.Character.Humanoid.Health > 0 then
                            murderer = enemy
                            break
                        end
                    end
                end
                
                if murderer then
                    local enemyRoot = murderer.Character.HumanoidRootPart
                    localPlayer_Noclip_Active = true
                    root.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 2)
                    task.wait(0.1)
                    
                    if gun.Parent == lp.Backpack then
                        hum:EquipTool(gun)
                    end
                    task.wait(0.05)
                    
                    VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(0.05)
                    VirtualUser:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    
                    task.wait(0.2)
                    localPlayer_Noclip_Active = false
                    WindUI:Notify({ Title = "Sheriff Combat", Content = "Murderer targeted and shot!", Duration = 2 })
                else
                    WindUI:Notify({ Title = "Sheriff Combat", Content = "Murderer not found or already dead.", Duration = 2 })
                end
            else
                WindUI:Notify({ Title = "Sheriff Combat", Content = "You do not have the Gun!", Duration = 2 })
            end
        end
    end
})

CombatTab:Section({ Title = "Survival & Evasion" })

CombatTab:Toggle({
    Title = "Auto Dodge Thrown Knife (Ultra Precise)",
    Desc = "Smartly detects flying knife projectiles with zero false positives.",
    Default = false,
    Callback = function(Value) AutoDodgeKnife_Enabled = Value end
})

local TrollTab = Window:Tab({
    Title = "Troll",
    Icon = "smile",
})

TrollTab:Section({ Title = "Fake & Prank" })

TrollTab:Toggle({
    Title = "Fake Death",
    Desc = "Lies down flat on the ground to fool other players.",
    Default = false,
    Callback = function(Value)
        FakeDeath_Enabled = Value
        local lp = Players.LocalPlayer
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if Value then
            if root and hum then
                hum.PlatformStand = true
                root.CFrame = root.CFrame * CFrame.Angles(math.rad(90), 0, 0)
            end
        else
            if root and hum then
                hum.PlatformStand = false
                root.CFrame = root.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
            end
        end
    end
})

TrollTab:Section({ Title = "Fling Controls" })

TrollTab:Button({
    Title = "Fling Murderer / Sheriff",
    Desc = "Attach to murderer or sheriff, spin wildly for 10s, then restore back to original position.",
    Callback = function()
        if IsFlinging then return end
        local lp = Players.LocalPlayer
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local hasKnife = p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                local hasGun = p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                if hasKnife or hasGun then
                    if p.Character:FindFirstChild("HumanoidRootPart") then
                        target = p.Character.HumanoidRootPart
                        break
                    end
                end
            end
        end
        
        if not target then
            WindUI:Notify({ Title = "Troll Fling", Content = "No Murderer or Sheriff found!", Duration = 2 })
            return
        end
        
        IsFlinging = true
        OriginalCFrame = root.CFrame
        
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.AngularVelocity = Vector3.new(0, 99999, 0)
        bav.Parent = root
        
        local startTime = tick()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if target and target.Parent and root and (tick() - startTime < 10) then
                localPlayer_Noclip_Active = true
                root.CFrame = target.CFrame * CFrame.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2)) * CFrame.Angles(math.random(0, 360), math.random(0, 360), math.random(0, 360))
            else
                if connection then connection:Disconnect() end
            end
        end)
        
        task.delay(10, function()
            if connection then connection:Disconnect() end
            if bav then bav:Destroy() end
            localPlayer_Noclip_Active = false
            
            if root and OriginalCFrame then
                root.CFrame = OriginalCFrame
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
            
            IsFlinging = false
            WindUI:Notify({ Title = "Troll Fling", Content = "Fling completed and returned to original position!", Duration = 2 })
        end)
    end
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
})

PlayerTab:Section({ Title = "Player Modifications" })

PlayerTab:Slider({
    Title = "WalkSpeed",
    Value = { Min = 16, Max = 100, Default = 16 },
    Callback = function(Value)
        local p = Players.LocalPlayer
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:Slider({
    Title = "JumpPower",
    Value = { Min = 50, Max = 250, Default = 50 },
    Callback = function(Value)
        local p = Players.LocalPlayer
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.UseJumpPower = true
            p.Character.Humanoid.JumpPower = Value
        end
    end
})

PlayerTab:Toggle({
    Title = "Enable Fly",
    Desc = "Toggle 3D camera-relative flight.",
    Default = false,
    Callback = function(Value)
        Fly_Enabled = Value
        local lp = Players.LocalPlayer
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if not Value then
            if Fly_BodyVelocity then Fly_BodyVelocity:Destroy() Fly_BodyVelocity = nil end
            if Fly_BodyGyro then Fly_BodyGyro:Destroy() Fly_BodyGyro = nil end
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = false end
        else
            if root and char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = true
                Fly_BodyGyro = Instance.new("BodyGyro")
                Fly_BodyGyro.P = 9e4
                Fly_BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                Fly_BodyGyro.cframe = root.CFrame
                Fly_BodyGyro.Parent = root
                
                Fly_BodyVelocity = Instance.new("BodyVelocity")
                Fly_BodyVelocity.velocity = Vector3.new(0, 0, 0)
                Fly_BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
                Fly_BodyVelocity.Parent = root
            end
        end
    end
})

PlayerTab:Slider({
    Title = "Fly Speed",
    Desc = "Adjust your flight movement speed.",
    Value = { Min = 16, Max = 150, Default = 30 },
    Callback = function(Value) FlySpeed = Value end
})

PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Allows walking through walls.",
    Default = false,
    Callback = function(Value) Noclip_Enabled = Value end
})

local FarmTab = Window:Tab({
    Title = "Auto Farm",
    Icon = "shopping-cart",
})

FarmTab:Section({ Title = "Safe Coin Farming" })

FarmTab:Toggle({
    Title = "Enable Auto Farm Coins",
    Desc = "Automatically collect coins seamlessly.",
    Default = false,
    Callback = function(Value) AutoFarm_Enabled = Value end
})

FarmTab:Slider({
    Title = "Farm Tween Speed",
    Desc = "Recommended: 30. Higher values risk bans.",
    Value = { Min = 15, Max = 60, Default = 30 },
    Callback = function(Value) FarmSpeed = Value end
})

FarmTab:Section({ Title = "Automation" })

FarmTab:Toggle({
    Title = "Auto Grab Gun",
    Desc = "Instantly teleport and pick up dropped sheriff gun.",
    Default = false,
    Callback = function(Value) AutoGrabGun_Enabled = Value end
})

local TeleportTab = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin",
})

TeleportTab:Section({ Title = "MM2 Custom Teleports" })

TeleportTab:Button({
    Title = "Teleport to Lobby",
    Desc = "Teleport back to the lobby.",
    Callback = function()
        local p = Players.LocalPlayer
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = CFrame.new(5.51, 506.82, -16.91)
        end
    end
})

TeleportTab:Button({
    Title = "TP to map (Sheriff)",
    Desc = "Teleport straight to the sheriff holding the gun.",
    Callback = function()
        local lp = Players.LocalPlayer
        if not (lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")) then return end
        local foundSheriff = false
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local hasGun = p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                if hasGun and p.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                    foundSheriff = true
                    WindUI:Notify({ Title = "Teleport", Content = "Teleported to Sheriff!", Duration = 2 })
                    break
                end
            end
        end
        if not foundSheriff then
            WindUI:Notify({ Title = "Teleport", Content = "Sheriff not found or gun not taken yet.", Duration = 2 })
        end
    end
})

TeleportTab:Button({
    Title = "Teleport to Sheriff (Gun Holder)",
    Desc = "Teleport right above the player holding the gun.",
    Callback = function()
        local lp = Players.LocalPlayer
        if not (lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")) then return end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character then
                local hasGun = p:FindFirstChild("Backpack") and p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                if hasGun and p.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                    break
                end
            end
        end
    end
})

TeleportTab:Button({
    Title = "Teleport to Dropped Gun",
    Desc = "Instantly teleport to the dropped gun.",
    Callback = function()
        local lp = Players.LocalPlayer
        if not (lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")) then return end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "GunDrop" then
                lp.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 1, 0)
                break
            end
        end
    end
})

local ESPTab = Window:Tab({
    Title = "Visuals / ESP",
    Icon = "eye",
})

ESPTab:Section({ Title = "ESP Settings" })

ESPTab:Toggle({
    Title = "Enable Player ESP (Chams)",
    Desc = "Toggle wallhack highlights on players.",
    Default = false,
    Callback = function(Value)
        ESP_Enabled = Value
        if not Value then
            for _, folder in pairs(ChamsContainer) do if folder then pcall(function() folder:Destroy() end) end end
            table.clear(ChamsContainer)
            ClearAllNameTags()
        end
    end
})

ESPTab:Toggle({
    Title = "Show Roles (MM2)",
    Desc = "Color-code roles (Red=Murder, Blue=Sheriff, Green=Innocent).",
    Default = false,
    Callback = function(Value) ESP_ShowRoles = Value end
})

ESPTab:Toggle({
    Title = "Show Player Names",
    Desc = "Display name tags above players.",
    Default = false,
    Callback = function(Value)
        ESP_ShowNames = Value
        if not Value then ClearAllNameTags() end
    end
})

ESPTab:Toggle({
    Title = "Show Dropped Gun ESP",
    Desc = "Highlight the dropped sheriff gun on the floor.",
    Default = false,
    Callback = function(Value)
        ESP_ShowGun = Value
        if not Value then ClearGunESP() end
    end
})

ESPTab:Section({ Title = "World Visuals" })

ESPTab:Toggle({
    Title = "X-Ray (Map Transparency)",
    Desc = "Makes the entire map semi-transparent excluding players.",
    Default = false,
    Callback = function(Value)
        XRay_Enabled = Value
        if Value then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local isCharacterPart = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character and obj:IsDescendantOf(p.Character) then
                            isCharacterPart = true
                            break
                        end
                    end
                    if not isCharacterPart then
                        OriginalTransparency[obj] = obj.Transparency
                        obj.Transparency = 0.6
                    end
                end
            end
        else
            for obj, trans in pairs(OriginalTransparency) do
                if obj and obj.Parent then
                    obj.Transparency = trans
                end
            end
            table.clear(OriginalTransparency)
        end
    end
})

local function GetPlayerRoleColor(player)
    if not ESP_ShowRoles then return Color3.fromRGB(255, 255, 255) end
    if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Knife") or player.Character and player.Character:FindFirstChild("Knife") then return Color3.fromRGB(255, 0, 0) end
    if player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun") or player.Character and player.Character:FindFirstChild("Gun") then return Color3.fromRGB(0, 0, 255) end
    return Color3.fromRGB(0, 255, 0)
end

local function ApplyChams(player, char)
    if ChamsContainer[player.Name] then return end
    local folder = Instance.new("Folder", workspace)
    folder.Name = player.Name .. "_ChamsFolder"
    ChamsContainer[player.Name] = folder
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local box = Instance.new("BoxHandleAdornment", folder)
            box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
            box.AlwaysOnTop, box.ZIndex, box.Adornee, box.Transparency = true, 5, part, 0.5
        end
    end
end

local function FindNearestCoin(playerRoot)
    local closest, shortest = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") and (obj.Name == "MainCoin" or obj.Name:lower():find("coin")) then
                if not (math.abs(obj.Position.Y - 506.82) < 10 and math.abs(obj.Position.X - 5.51) < 100) then
                    local dist = (playerRoot.Position - obj.Position).Magnitude
                    if dist < shortest then shortest, closest = dist, obj end
                end
            end
        end)
    end
    return closest
end

task.spawn(function()
    while true do
        task.wait(0.01)
        if AutoFarm_Enabled and not Fly_Enabled and not KillAll_Enabled then
            local lp = Players.LocalPlayer
            local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
            if root and hum and hum.Health > 0 then
                local targetCoin = FindNearestCoin(root)
                if targetCoin and targetCoin.Parent then
                    localPlayer_Noclip_Active = true
                    local tween = TweenService:Create(root, TweenInfo.new((root.Position - targetCoin.Position).Magnitude / FarmSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetCoin.Position + Vector3.new(0, 0.2, 0))})
                    tween:Play()
                    while tween.PlaybackState == Enum.PlaybackState.Playing and AutoFarm_Enabled and not Fly_Enabled and not KillAll_Enabled and targetCoin.Parent and hum.Health > 0 do task.wait() end
                    tween:Cancel()
                    localPlayer_Noclip_Active = false
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoGrabGun_Enabled then
            local lp = Players.LocalPlayer
            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local hasGun = lp:FindFirstChild("Backpack") and lp.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun")
                if not hasGun then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") and v.Name == "GunDrop" then
                            root.CFrame = v.CFrame * CFrame.new(0, 1, 0)
                            WindUI:Notify({ Title = "Auto Grab Gun", Content = "Successfully grabbed dropped gun!", Duration = 2 })
                            task.wait(1)
                            break
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    local killedTargets = {}
    
    while true do
        task.wait(0.1)
        
        if not KillAll_Enabled then
            table.clear(killedTargets)
        else
            local lp = Players.LocalPlayer
            local char = lp.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local knife = lp:FindFirstChild("Backpack") and lp.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife")
                if knife then
                    local allCleared = true
                    
                    for _, enemy in pairs(Players:GetPlayers()) do
                        if not KillAll_Enabled then break end
                        
                        if enemy ~= lp and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") and enemy.Character:FindFirstChild("Humanoid") then
                            local enemyHum = enemy.Character.Humanoid
                            
                            if enemyHum.Health > 0 and not killedTargets[enemy.Name] then
                                allCleared = false
                                local enemyRoot = enemy.Character.HumanoidRootPart
                                
                                localPlayer_Noclip_Active = true
                                root.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 2)
                                task.wait(0.1)
                                
                                if knife.Parent == lp.Backpack then
                                    hum:EquipTool(knife)
                                end
                                
                                local startTime = tick()
                                while KillAll_Enabled and enemy.Parent and enemyHum.Health > 0 and (tick() - startTime < 3) do
                                    VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                                    task.wait(0.05)
                                    VirtualUser:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                                    task.wait(0.15)
                                    
                                    if enemyRoot and root then
                                        root.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 2)
                                    end
                                end
                                
                                if enemyHum.Health <= 0 then
                                    killedTargets[enemy.Name] = true
                                end
                                
                                localPlayer_Noclip_Active = false
                                task.wait(0.2)
                            end
                        end
                    end
                    
                    if allCleared then
                        table.clear(killedTargets)
                        task.wait(1)
                    end
                end
            end
        end
    end
end)

local lastDodgeTick = 0

RunService.Heartbeat:Connect(function()
    local lp = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    
    if (Noclip_Enabled or localPlayer_Noclip_Active) and lp.Character then
        for _, p in pairs(lp.Character:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end

    if Fly_Enabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and Fly_BodyVelocity and Fly_BodyGyro then
        local root = lp.Character.HumanoidRootPart
        Fly_BodyGyro.cframe = camera.CFrame
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
        Fly_BodyVelocity.velocity = dir.Magnitude > 0 and dir.Unit * FlySpeed or Vector3.new(0,0,0)
    end

    if AutoDodgeKnife_Enabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local root = lp.Character.HumanoidRootPart
        if tick() - lastDodgeTick > 0.4 then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "KnifeProjectile" then
                    local isOwnedByPlayer = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character and obj:IsDescendantOf(p.Character) then
                            isOwnedByPlayer = true
                            break
                        end
                    end
                    
                    if not isOwnedByPlayer then
                        local dist = (root.Position - obj.Position).Magnitude
                        if dist < 12 then
                            lastDodgeTick = tick()
                            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + Vector3.new(math.random(-12, 12), 12, math.random(12, 20))
                            break
                        end
                    end
                end
            end
        end
    end

    if ESP_Enabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then
                local char = p.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    if not ChamsContainer[p.Name] or not ChamsContainer[p.Name].Parent then ApplyChams(p, char) end
                    local color = GetPlayerRoleColor(p)
                    if ChamsContainer[p.Name] then
                        for _, a in pairs(ChamsContainer[p.Name]:GetChildren()) do if a:IsA("BoxHandleAdornment") then a.Color3 = color end end
                    end
                    local head = char:FindFirstChild("Head")
                    if head then
                        if ESP_ShowNames then
                            local tag = head:FindFirstChild("NameESP")
                            if not tag then
                                local bb = Instance.new("BillboardGui", head)
                                bb.Name, bb.Size, bb.AlwaysOnTop, bb.StudsOffset = "NameESP", UDim2.new(0,100,0,30), true, Vector3.new(0,3,0)
                                local tl = Instance.new("TextLabel", bb)
                                tl.Size, tl.BackgroundTransparency, tl.Text, tl.TextColor3, tl.Font, tl.TextSize, tl.TextStrokeTransparency = UDim2.new(1,0,1,0), 1, p.DisplayName or p.Name, color, Enum.Font.SourceSansBold, 16, 0.4
                            else
                                if tag:FindFirstChild("TextLabel") then tag.TextLabel.TextColor3 = color end
                            end
                        else
                            if head:FindFirstChild("NameESP") then head.NameESP:Destroy() end
                        end
                    end
                else
                    if ChamsContainer[p.Name] then pcall(function() ChamsContainer[p.Name]:Destroy() end) ChamsContainer[p.Name] = nil end
                end
            end
        end
    end

    if ESP_ShowGun then
        local foundGun = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "GunDrop" then
                foundGun = true
                if not GunESPContainer["GunDrop"] or not GunESPContainer["GunDrop"].Parent then
                    local box = Instance.new("BoxHandleAdornment", v)
                    box.Size = v.Size + Vector3.new(0.1, 0.1, 0.1)
                    box.AlwaysOnTop = true
                    box.ZIndex = 6
                    box.Color3 = Color3.fromRGB(0, 180, 255)
                    box.Transparency = 0.4
                    box.Adornee = v
                    GunESPContainer["GunDrop"] = box
                    
                    local bb = Instance.new("BillboardGui", v)
                    bb.Size = UDim2.new(0, 80, 0, 20)
                    bb.AlwaysOnTop = true
                    bb.StudsOffset = Vector3.new(0, 2, 0)
                    local tl = Instance.new("TextLabel", bb)
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = "★ GUN DROP ★"
                    tl.TextColor3 = Color3.fromRGB(0, 180, 255)
                    tl.Font = Enum.Font.SourceSansBold
                    tl.TextSize = 14
                    tl.TextStrokeTransparency = 0.2
                    GunESPContainer["GunDropText"] = bb
                end
            end
        end
        if not foundGun then ClearGunESP() end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if ChamsContainer[p.Name] then pcall(function() ChamsContainer[p.Name]:Destroy() end) ChamsContainer[p.Name] = nil end
end)

MainTab:Select()
