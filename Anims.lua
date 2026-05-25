--[ R15 to R6 Animation Replacer ]
--[ Persiste após reset/morte sem precisar reinjetar ]

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
    if not character then return end

    local animate = character:FindFirstChild("Animate")
    if not animate then
        animate = character:WaitForChild("Animate", 10)
        if not animate then return end
    end

    local function setAnim(folderName, childName, id)
        if not id then return end
        local folder = animate:FindFirstChild(folderName)
        if not folder then return end
        local animObj = folder:FindFirstChild(childName)
        if animObj then
            animObj.AnimationId = "rbxassetid://" .. tostring(id)
        end
    end

    -- Idle
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
            local sitAnim     = sitFolder:FindFirstChild("Sit")
            local sitIdleAnim = sitFolder:FindFirstChild("SitIdle")
            if sitAnim     then sitAnim.AnimationId     = "rbxassetid://" .. sitId end
            if sitIdleAnim then sitIdleAnim.AnimationId = "rbxassetid://" .. sitId end
        end
    end
end

-- Proteção contra dupla injeção (DEPOIS da função estar definida)
if getgenv().R6AnimReplaceLoaded then
    if not getgenv()._r6AnimConnection then
        local player = game.Players.LocalPlayer
        getgenv()._r6AnimConnection = player.CharacterAdded:Connect(function(character)
            task.spawn(applyAnims, character)
        end)
        if player.Character then
            task.spawn(applyAnims, player.Character)
        end
    end
    return
end
getgenv().R6AnimReplaceLoaded = true

local player = game.Players.LocalPlayer

if player.Character then
    task.spawn(applyAnims, player.Character)
end

getgenv()._r6AnimConnection = player.CharacterAdded:Connect(function(character)
    task.spawn(applyAnims, character)
end)
