--[ R15 to R6 Animation Replacer - Estilo GAZE ]
--[ Persiste após reset/morte sem precisar reinjetar ]

if getgenv().R6AnimReplaceLoaded then
    -- Se já carregado, reconecta o evento e reaplica
    if not getgenv()._r6AnimConnection then
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        getgenv()._r6AnimConnection = player.CharacterAdded:Connect(function(character)
            task.spawn(function()
                -- Aguarda o Animate carregar
                local animate = character:WaitForChild("Animate", 10)
                if animate then
                    -- Destrói o Animate original e cria um novo
                    local newAnimate = getgenv().createNewAnimate(character, getgenv().R6Anims)
                    animate:Destroy()
                    newAnimate.Parent = character
                end
            end)
        end)
        if player.Character then
            task.spawn(function()
                local animate = player.Character:WaitForChild("Animate", 10)
                if animate then
                    local newAnimate = getgenv().createNewAnimate(player.Character, getgenv().R6Anims)
                    animate:Destroy()
                    newAnimate.Parent = player.Character
                end
            end)
        end
    end
    return
end

getgenv().R6AnimReplaceLoaded = true

-- Tabela global de animações
getgenv().R6Anims = getgenv().R6Anims or {
    Idle     = {"12521158637", "12521162526"},
    Walk     = "12518152696",
    Run      = "12518152696",
    Jump     = "12520880485",
    Fall     = "12520972571",
    Climb    = "12520982150",
    Swim     = "12518152696",
    SwimIdle = "12518152696",
    Sit      = "12520993168"
}

-- Função que cria um novo script Animate com os IDs personalizados
function getgenv().createNewAnimate(character, anims)
    local animate = Instance.new("LocalScript")
    animate.Name = "Animate"
    
    local scriptContent = [[
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

local animsData = ]] .. game:GetService("HttpService"):JSONEncode(anims) .. [[

-- Idle
local idle = Instance.new("Animation")
idle.AnimationId = "rbxassetid://" .. (type(animsData.Idle) == "table" and animsData.Idle[1] or animsData.Idle)
local idleTrack = humanoid:LoadAnimation(idle)

-- Idle2
local idle2 = Instance.new("Animation")
idle2.AnimationId = "rbxassetid://" .. (type(animsData.Idle) == "table" and animsData.Idle[2] or animsData.Idle)

-- Walk
local walk = Instance.new("Animation")
walk.AnimationId = "rbxassetid://" .. animsData.Walk

-- Run
local run = Instance.new("Animation")
run.AnimationId = "rbxassetid://" .. animsData.Run

-- Jump
local jump = Instance.new("Animation")
jump.AnimationId = "rbxassetid://" .. animsData.Jump

-- Fall
local fall = Instance.new("Animation")
fall.AnimationId = "rbxassetid://" .. animsData.Fall

-- Climb
local climb = Instance.new("Animation")
climb.AnimationId = "rbxassetid://" .. animsData.Climb

-- Swim
local swim = Instance.new("Animation")
swim.AnimationId = "rbxassetid://" .. animsData.Swim

-- SwimIdle
local swimIdle = Instance.new("Animation")
swimIdle.AnimationId = "rbxassetid://" .. animsData.SwimIdle

-- Sit
local sit = Instance.new("Animation")
sit.AnimationId = "rbxassetid://" .. animsData.Sit

-- Controle de estados
local currentAnim = nil

local function playAnim(anim, fadeTime)
    if currentAnim == anim then return end
    if currentAnim then currentAnim:Stop(0) end
    currentAnim = anim
    if anim then anim:Play(0, 1, fadeTime or 0.1) end
end

humanoid.StateChanged:Connect(function(oldState, newState)
    if newState == Enum.HumanoidStateType.Running then
        if humanoid.MoveDirection.Magnitude > 0 then
            if humanoid:GetState() == Enum.HumanoidStateType.Running then
                playAnim(run:Clone(), 0.1)
            else
                playAnim(walk:Clone(), 0.1)
            end
        else
            playAnim(idle:Clone(), 0.1)
        end
    elseif newState == Enum.HumanoidStateType.Landed then
        task.wait(0.05)
        playAnim(idle:Clone(), 0.1)
    elseif newState == Enum.HumanoidStateType.Jumping then
        playAnim(jump:Clone(), 0)
    elseif newState == Enum.HumanoidStateType.Freefall then
        playAnim(fall:Clone(), 0.1)
    elseif newState == Enum.HumanoidStateType.Climbing then
        playAnim(climb:Clone(), 0.1)
    elseif newState == Enum.HumanoidStateType.Swimming then
        if humanoid.MoveDirection.Magnitude > 0 then
            playAnim(swim:Clone(), 0.1)
        else
            playAnim(swimIdle:Clone(), 0.1)
        end
    elseif newState == Enum.HumanoidStateType.Seated then
        playAnim(sit:Clone(), 0.1)
    end
end)

-- Animação Idle aleatória
task.spawn(function()
    while humanoid.Parent and humanoid.Health > 0 do
        if humanoid:GetState() == Enum.HumanoidStateType.Running and humanoid.MoveDirection.Magnitude == 0 then
            local randomIdle = math.random(1, 2)
            local idleAnim = (randomIdle == 1 and idle or idle2)
            playAnim(idleAnim:Clone(), 1)
        end
        task.wait(5)
    end
end)
]]
    
    animate.Source = scriptContent
    return animate
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Função principal para aplicar as animações (substitui o Animate original)
local function applyAnims(character)
    if not character then return end
    
    -- Aguarda o personagem ter um Humanoid
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end
    
    -- Aguarda ou cria o Animate
    local animate = character:FindFirstChild("Animate")
    if not animate then
        animate = character:WaitForChild("Animate", 10)
    end
    
    if animate then
        -- Cria um novo Animate com as animações personalizadas
        local newAnimate = getgenv().createNewAnimate(character, getgenv().R6Anims)
        -- Substitui o antigo pelo novo
        animate:Destroy()
        task.wait(0.05)
        newAnimate.Parent = character
    end
end

-- Aplica no personagem atual se existir
if player.Character then
    task.spawn(applyAnims, player.Character)
end

-- Conecta o evento de respawn
getgenv()._r6AnimConnection = player.CharacterAdded:Connect(function(character)
    task.spawn(applyAnims, character)
end)
