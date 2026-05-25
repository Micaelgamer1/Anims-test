--[ FE Animation Editor - Versão Completa com Billie Eilish e Katseye ]

pcall(function()

if not game.Players.LocalPlayer.Character or game.Players.LocalPlayer.Character:WaitForChild("Humanoid").RigType ~= Enum.HumanoidRigType.R15 then 
    game.StarterGui:SetCore("SendNotification", {Title = "R6", Text = "You're on R6, bro. Change to R15!", Duration = 60})
    return
end

local st = os.clock()
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local camera = workspace.CurrentCamera

cloneref = cloneref or function(o) return o end
local GazeGoGui = cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Notifbro = {}
function Notify(titletxt, text, time)
    coroutine.wrap(function()
        local GUI = Instance.new("ScreenGui")
        local Main = Instance.new("Frame", GUI)
        local title = Instance.new("TextLabel", Main)
        local message = Instance.new("TextLabel", Main)

        GUI.Name = "BackgroundNotif"
        GUI.Parent = GazeGoGui

        local sw = workspace.CurrentCamera.ViewportSize.X
        local sh = workspace.CurrentCamera.ViewportSize.Y
        local nh = sh / 7
        local nw = sw / 5

        Main.Name = "MainFrame"
        Main.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Main.BackgroundTransparency = 0.2
        Main.BorderSizePixel = 0
        Main.Size = UDim2.new(0, nw, 0, nh)

        title.BackgroundColor3 = Color3.new(0, 0, 0)
        title.BackgroundTransparency = 0.9
        title.Size = UDim2.new(1, 0, 0, nh / 2)
        title.Font = Enum.Font.GothamBold
        title.Text = titletxt
        title.TextColor3 = Color3.new(1, 1, 1)
        title.TextScaled = true

        message.BackgroundColor3 = Color3.new(0, 0, 0)
        message.BackgroundTransparency = 1
        message.Position = UDim2.new(0, 0, 0, nh / 2)
        message.Size = UDim2.new(1, 0, 1, -nh / 2)
        message.Font = Enum.Font.Gotham
        message.Text = text
        message.TextColor3 = Color3.new(1, 1, 1)
        message.TextScaled = true

        local offset = 50
        for _, notif in ipairs(Notifbro) do
            offset = offset + notif.Size.Y.Offset + 10
        end

        Main.Position = UDim2.new(1, 5, 0, offset)
        table.insert(Notifbro, Main)

        task.wait(0.1)
        Main:TweenPosition(UDim2.new(1, -nw, 0, offset), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        Main:TweenSize(UDim2.new(0, nw * 1.06, 0, nh * 1.06), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.5, true)
        task.wait(0.1)
        Main:TweenSize(UDim2.new(0, nw, 0, nh), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.2, true)

        task.wait(time)

        Main:TweenSize(UDim2.new(0, nw * 1.06, 0, nh * 1.06), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 0.2, true)
        task.wait(0.2)
        Main:TweenSize(UDim2.new(0, nw, 0, nh), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 0.2, true)
        task.wait(0.2)
        Main:TweenPosition(UDim2.new(1, 5, 0, offset), Enum.EasingDirection.In, Enum.EasingStyle.Bounce, 0.5, true)
        task.wait(0.1)

        GUI:Destroy()
        for i, notif in ipairs(Notifbro) do
            if notif == Main then
                table.remove(Notifbro, i)
                break
            end
        end

        for i, notif in ipairs(Notifbro) do
            local newOffset = 50 + (nh + 10) * (i - 1)
            notif:TweenPosition(UDim2.new(1, -nw, 0, newOffset), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        end
    end)()
end

task.wait(0.1)

local guiName = "GazeVerificator"
if GazeGoGui:FindFirstChild(guiName) then
    Notify("Error","Script Already Executed", 1)
    return
end

local function getScaledSize(relativeWidth, relativeHeight)
    local viewportSize = camera.ViewportSize
    return UDim2.new(0, math.floor(viewportSize.X * relativeWidth), 0, math.floor(viewportSize.Y * relativeHeight))
end

local core = cloneref(game.CoreGui)
local old = core:FindFirstChild("DraggableGui")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggableGui"
screenGui.Parent = core

local frame = Instance.new("TextButton")
frame.Name = "GazeBro"
frame.Text = ""
frame.Size = getScaledSize(0.3, 0.4)
frame.Position = UDim2.new(0.5, -getScaledSize(0.3,0.4).X.Offset/2, 0.5, -getScaledSize(0.3,0.4).Y.Offset/2)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(0,0,0)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local labelSize = UDim2.new(1, 0, 0.1, 0)

local gazeLabel = Instance.new("TextLabel")
gazeLabel.Name = "GazeLabel"
gazeLabel.Text = "GAZE"
gazeLabel.Font = Enum.Font.SourceSansBold
gazeLabel.TextScaled = true
gazeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gazeLabel.BackgroundTransparency = 1
gazeLabel.Size = labelSize
gazeLabel.Position = UDim2.new(0, 0, 0, 0)
gazeLabel.Parent = frame

local searchBar = Instance.new("TextBox")
searchBar.Name = "SearchBar"
searchBar.Text = ""
searchBar.PlaceholderText = "Search..."
searchBar.Font = Enum.Font.SourceSans
searchBar.TextScaled = true
searchBar.TextColor3 = Color3.fromRGB(200, 200, 200)
searchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchBar.BorderSizePixel = 0
searchBar.Size = UDim2.new(0.9, 0, 0.2, 0)
searchBar.Position = UDim2.new(0.05, 0, 0.10, 0)
searchBar.ClearTextOnFocus = true
searchBar.Parent = frame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
scrollFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 0
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarImageTransparency = 1
scrollFrame.Parent = frame

local buttons = {}
local createdSet = {}

local function createTheButton(text, callback)
    if createdSet[text] then
        return
    end
    createdSet[text] = true

    local button = Instance.new("TextButton")
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(1, 0, 0, #buttons * 45)
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Parent = scrollFrame

    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    local tweenInfoLocal = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {
        Position = UDim2.new(0, 0, 0, #buttons * 45),
        BackgroundTransparency = 0
    }
    local tween = TweenService:Create(button, tweenInfoLocal, goal)
    tween:Play()

    table.insert(buttons, button)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #buttons * 45)
end

searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchBar.Text:lower()
    local order = 0
    for _, button in ipairs(buttons) do
        if searchText == "" or button.Text:lower():find(searchText) then
            button.Visible = true
            button:TweenPosition(UDim2.new(0, 0, 0, order * 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
            order += 1
        else
            button.Visible = false
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, order * 45)
end)

-- ANIMAÇÕES COM BILLIE EILISH E KATSEYE
OriginalAnimations = {
    ["Idle"] = {
        ["Billie Eilish (BE)"] = {"92151291669373", "102934602894410"},
        ["Katseye (KE)"] = {"108187809145790", "72329200359275"},
        ["R6"] = {"12521158637", "12521162526"},
        ["R15 Reanimated"] = {"4211217646", "4211218409"},
    },
    ["Walk"] = {
        ["Billie Eilish (BE)"] = "81877886552514",
        ["Katseye (KE)"] = "99182913548783",
        ["R6"] = "12518152696",
        ["R15 Reanimated"] = "4211223236",
    },
    ["Run"] = {
        ["Billie Eilish (BE)"] = "100920560634123",
        ["Katseye (KE)"] = "73117360545482",
        ["R6"] = "12518152696",
        ["R15 Reanimated"] = "4211220381",
    },
    ["Jump"] = {
        ["Billie Eilish (BE)"] = "117602630922781",
        ["Katseye (KE)"] = "103632305262747",
        ["R6"] = "12520880485",
        ["R15 Reanimated"] = "4211219390",
    },
    ["Fall"] = {
        ["Billie Eilish (BE)"] = "81072141180299",
        ["Katseye (KE)"] = "127802717128367",
        ["R6"] = "12520972571",
        ["R15 Reanimated"] = "4211216152",
    },
    ["Climb"] = {
        ["Billie Eilish (BE)"] = "117873469361430",
        ["Katseye (KE)"] = "106213237973858",
        ["R6"] = "12520982150",
        ["Reanimated R15"] = "4211214992",
    },
    ["SwimIdle"] = {
        ["Billie Eilish (BE)"] = "78535650384589",
        ["R6"] = "12518152696",
    },
    ["Swim"] = {
        ["Billie Eilish (BE)"] = "121824746242877",
        ["Katseye (KE)"] = "134148268480210",
        ["R6"] = "12518152696",
    },
    ["Sit"] = {
        ["R6"] = "12520993168",
        ["Katseye (KE)"] = "2506281703",
        ["R15 Default"] = "3782556882",
    }
}

local Animations
if isfile("GreyLikesToSmellUrFeet.json") then
    local data = readfile("GreyLikesToSmellUrFeet.json")
    Animations = HttpService:JSONDecode(data)
    Notify("Loading..", "Animations loaded!", 3)
else
    writefile("GreyLikesToSmellUrFeet.json", HttpService:JSONEncode(OriginalAnimations))
    Animations = OriginalAnimations
    Notify("Saved", "Animations saved!", 3)
end

-- FUNÇÃO PARA APLICAR ANIMAÇÕES
local function setAnimation(animType, animId)
    local player = Players.LocalPlayer
    if not player.Character then return end
    
    local animate = player.Character:FindFirstChild("Animate")
    if not animate then return end
    
    if animType == "Idle" then
        local idleFolder = animate:FindFirstChild("idle")
        if idleFolder then
            local anim1 = idleFolder:FindFirstChild("Animation1")
            local anim2 = idleFolder:FindFirstChild("Animation2")
            if type(animId) == "table" then
                if anim1 and animId[1] then anim1.AnimationId = "rbxassetid://" .. animId[1] end
                if anim2 and animId[2] then anim2.AnimationId = "rbxassetid://" .. animId[2] end
            end
        end
    elseif animType == "Sit" then
        local sitFolder = animate:FindFirstChild("sit")
        if sitFolder then
            local sit = sitFolder:FindFirstChild("Sit")
            local sitIdle = sitFolder:FindFirstChild("SitIdle")
            if sit then sit.AnimationId = "rbxassetid://" .. animId end
            if sitIdle then sitIdle.AnimationId = "rbxassetid://" .. animId end
        end
    else
        local folderName = animType:lower()
        local folder = animate:FindFirstChild(folderName)
        if not folder then return end
        
        local animNames = {
            ["Walk"] = "WalkAnim",
            ["Run"] = "RunAnim",
            ["Jump"] = "JumpAnim",
            ["Fall"] = "FallAnim",
            ["Climb"] = "ClimbAnim",
            ["Swim"] = "Swim",
            ["SwimIdle"] = "SwimIdle"
        }
        
        local animName = animNames[animType]
        if animName then
            local anim = folder:FindFirstChild(animName)
            if anim then anim.AnimationId = "rbxassetid://" .. animId end
        end
    end
end

-- REFRESH BUTTONS
local function refreshMainButtons()
    for _, btn in ipairs(buttons) do
        if btn and btn.Parent then btn:Destroy() end
    end
    buttons = {}
    createdSet = {}

    local typeOrder = {"Idle", "Walk", "Run", "Jump", "Fall", "Swim", "SwimIdle", "Climb", "Sit"}
    
    for _, animType in ipairs(typeOrder) do
        local anims = Animations[animType]
        if anims then
            for name, ids in pairs(anims) do
                local buttonText = name .. " - " .. animType
                createTheButton(buttonText, function()
                    pcall(function()
                        setAnimation(animType, ids)
                        Notify(animType, name, 1)
                    end)
                end)
            end
        end
    end
end

refreshMainButtons()

Notify("Loaded", "✅ Animation Editor - Billie Eilish & Katseye Ready!", 3)

end)
