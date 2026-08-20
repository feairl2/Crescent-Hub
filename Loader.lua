local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local TargetParent = (LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")) or game:GetService("CoreGui")

if TargetParent:FindFirstChild("CrescentNotificationGui") then
    TargetParent.CrescentNotificationGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrescentNotificationGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = TargetParent

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Size = UDim2.new(0, 250, 0, 60)
NotificationFrame.Position = UDim2.new(1, 20, 1, -80) 
NotificationFrame.BackgroundColor3 = Color3.fromRGB(12,12,12)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = NotificationFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(50, 50, 60)
UIStroke.Thickness = 1.2
UIStroke.Transparency = 1
UIStroke.Parent = NotificationFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -28, 0, 20)
TitleLabel.Position = UDim2.new(0, 18, 0, 10)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Crescent API"
TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 250)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextTransparency = 1
TitleLabel.Parent = NotificationFrame

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Name = "SubtitleLabel"
SubtitleLabel.Size = UDim2.new(1, -28, 0, 16)
SubtitleLabel.Position = UDim2.new(0, 18, 0, 32)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Text = "API Successfully loaded and ready"
SubtitleLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
SubtitleLabel.TextSize = 12
SubtitleLabel.Font = Enum.Font.Gotham
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.TextTransparency = 1
SubtitleLabel.Parent = NotificationFrame

local tweenInfo = TweenInfo.new(
    0.5,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

local targetPosition = UDim2.new(1, -270, 1, -80)

TweenService:Create(NotificationFrame, tweenInfo, {
    Position = targetPosition,
    BackgroundTransparency = 0
}):Play()

TweenService:Create(UIStroke, tweenInfo, { Transparency = 0 }):Play()
TweenService:Create(TitleLabel, tweenInfo, { TextTransparency = 0 }):Play()
TweenService:Create(SubtitleLabel, tweenInfo, { TextTransparency = 0 }):Play()

task.delay(4, function()
    local hideTween = TweenService:Create(NotificationFrame, tweenInfo, {
        Position = UDim2.new(1, 20, 1, -80),
        BackgroundTransparency = 1
    })
    
    TweenService:Create(UIStroke, tweenInfo, { Transparency = 1 }):Play()
    TweenService:Create(TitleLabel, tweenInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(SubtitleLabel, tweenInfo, { TextTransparency = 1 }):Play()
    
    hideTween:Play()
    hideTween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end)
