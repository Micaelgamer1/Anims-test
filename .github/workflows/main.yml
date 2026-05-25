--[ R15 to R6 Animation Replacer ]
--[ Funciona com qualquer executor, compatível FE ]
--[ Substitui Walk, Run, Jump, Fall, Climb, Swim, SwimIdle, Idle1, Idle2 e Sit ]

if getgenv().R6AnimReplaceLoaded then return end
getgenv().R6AnimReplaceLoaded = true

-- Tabela global de animações (edite os IDs conforme desejar)
getgenv().R6Anims = getgenv().R6Anims or {
    Idle   = {"12521158637", "12521162526"}, -- Idle1 e Idle2
    Walk   = "12518152696",
    Run    = "12518152696",
    Jump   = "12520880485",
    Fall   = "12520972571",
    Climb  = "12520982150",
    Swim   = "12518152696",
    SwimIdle = "12518152696",
    Sit    = "12520993168"   -- Aplicado a Sit e SitIdle
}

local function applyAnims(character)
    if not character or character ~= game.Players.LocalPlayer.Character then return end
    
    local animate = character:FindFirstChild("Animate")
    if not animate then
        animate = character:WaitForChild("Animate", 5)
        if not animate then return end
    end

    local function setAnim(container, animName, id)
        if not id then return end
        local animObj = container:FindFirstChild(animName)
        if animObj then
            animObj.AnimationId = "rbxassetid://" .. tostring(id)
        end
    end

    -- Idle (dois slots)
    local idleFolder = animate:FindFirstChild("idle")
    if idleFolder then
        local ids = getgenv().R6Anims.Idle
        if type(ids) == "table" then
            local anim1 = idleFolder:FindFirstChild("Animation1")
            if anim1 and ids[1] then anim1.AnimationId = "rbxassetid://" .. ids[1] end
            local anim2 = idleFolder:FindFirstChild("Animation2")
            if anim2 and ids[2] then anim2.AnimationId = "rbxassetid://" .. ids[2] end
        elseif type(ids) == "string" then
            local anim1 = idleFolder:FindFirstChild("Animation1")
            if anim1 then anim1.AnimationId = "rbxassetid://" .. ids end
            local anim2 = idleFolder:FindFirstChild("Animation2")
            if anim2 then anim2.AnimationId = "rbxassetid://" .. ids end
        end
    end

    -- Movimentos básicos
    setAnim(animate, "walk", getgenv().R6Anims.Walk)
    setAnim(animate, "run", getgenv().R6Anims.Run)
    setAnim(animate, "jump", getgenv().R6Anims.Jump)
    setAnim(animate, "fall", getgenv().R6Anims.Fall)
    setAnim(animate, "climb", getgenv().R6Anims.Climb)
    setAnim(animate, "swim", getgenv().R6Anims.Swim)
    setAnim(animate, "swimidle", getgenv().R6Anims.SwimIdle)

    -- Sit (suporte completo para cadeiras/seats)
    local sitFolder = animate:FindFirstChild("sit")
    if sitFolder then
        local sitId = getgenv().R6Anims.Sit
        if sitId then
            local sitAnim = sitFolder:FindFirstChild("Sit")
            if sitAnim then sitAnim.AnimationId = "rbxassetid://" .. sitId end
            local sitIdleAnim = sitFolder:FindFirstChild("SitIdle")
            if sitIdleAnim then sitIdleAnim.AnimationId = "rbxassetid://" .. sitId end
        end
    end
end

local player = game.Players.LocalPlayer

-- Aplica no personagem atual (se existir)
if player.Character then
    task.spawn(applyAnims, player.Character)
end

-- Reaplica automaticamente após cada respawn
player.CharacterAdded:Connect(function(character)
    task.spawn(applyAnims, character)
end)
