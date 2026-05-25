--[ R15 to R6 Animation Replacer ]
--[ Funciona com qualquer executor, compatível FE ]
--[ Substitui Walk, Run, Jump, Fall, Climb, Swim, SwimIdle, Idle1, Idle2 e Sit ]

if getgenv().R6AnimReplaceLoaded then return end
getgenv().R6AnimReplaceLoaded = true

-- Tabela global de animações (edite os IDs conforme desejar)
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

local function applyAnims(character)
    if not character or character ~= game.Players.LocalPlayer.Character then return end

    local animate = character:FindFirstChild("Animate")
    if not animate then
        animate = character:WaitForChild("Animate", 5)
        if not animate then return end
    end

    -- Seta a animação dentro de uma subpasta do Animate
    local function setAnim(folderName, childName, id)
        if not id then return end
        local folder = animate:FindFirstChild(folderName)
        if not folder then return end
        local animObj = folder:FindFirstChild(childName)
        if animObj then
            animObj.AnimationId = "rbxassetid://" .. tostring(id)
        end
    end

    -- Idle (dois slots)
    local idleFolder = animate:FindFirstChild("idle")
    if idleFolder then
        local ids = getgenv().R6Anims.Idle
        local anim1 = idleFolder:FindFirstChild("Animation1")
        local anim2 = idleFolder:FindFirstChild("Animation2")
        if type(ids) == "table" then
            if anim1 and ids[1] then anim1.AnimationId = "rbxassetid://" .. ids[1] end
            if anim2 and ids[2] then anim2.AnimationId = "rbxassetid://" .. ids[2] end
        elseif type(ids) == "string" then
            if anim1 then anim1.AnimationId = "rbxassetid://" .. ids end
            if anim2 then anim2.AnimationId = "rbxassetid://" .. ids end
        end
    end

    -- Movimentos básicos
    setAnim("walk",     "WalkAnim",  getgenv().R6Anims.Walk)
    setAnim("run",      "RunAnim",   getgenv().R6Anims.Run)
    setAnim("jump",     "JumpAnim",  getgenv().R6Anims.Jump)
    setAnim("fall",     "FallAnim",  getgenv().R6Anims.Fall)
    setAnim("climb",    "ClimbAnim", getgenv().R6Anims.Climb)
    setAnim("swim",     "Swim",      getgenv().R6Anims.Swim)
    setAnim("swimidle", "SwimIdle",  getgenv().R6Anims.SwimIdle)

    -- Sit
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

if player.Character then
    task.spawn(applyAnims, player.Character)
end

player.CharacterAdded:Connect(function(character)
    task.spawn(applyAnims, character)
end)
