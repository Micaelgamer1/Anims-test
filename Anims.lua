--[ R15 to R6 Animation Replacer ]
--[ Persiste após reset/morte sem precisar reinjetar ]

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

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function stopAllTracks(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end
end

local function applyAnimation(folder, animName, animId)
    if not folder then return end
    
    local anim = folder:FindFirstChild(animName)
    if anim then
        anim.AnimationId = "rbxassetid://" .. animId
        return true
    end
    return false
end

local function applyAnims(character)
    if not character then return end

    local animate = character:FindFirstChild("Animate")
    if not animate then
        animate = character:WaitForChild("Animate", 10)
        if not animate then
            warn("Animate folder not found for character")
            return
        end
    end

    task.wait(0.3)
    stopAllTracks(character)

    local animConfig = getgenv().R6Anims

    -- Idle (table support)
    local idleFolder = animate:FindFirstChild("idle")
    if idleFolder then
        local ids = animConfig.Idle
        if type(ids) == "table" then
            if ids[1] then applyAnimation(idleFolder, "Animation1", ids[1]) end
            if ids[2] then applyAnimation(idleFolder, "Animation2", ids[2]) end
        else
            applyAnimation(idleFolder, "Animation1", ids)
            applyAnimation(idleFolder, "Animation2", ids)
        end
    end

    -- Walk
    local walkFolder = animate:FindFirstChild("walk")
    if walkFolder then
        applyAnimation(walkFolder, "WalkAnim", animConfig.Walk)
    end

    -- Run
    local runFolder = animate:FindFirstChild("run")
    if runFolder then
        applyAnimation(runFolder, "RunAnim", animConfig.Run)
    end

    -- Jump
    local jumpFolder = animate:FindFirstChild("jump")
    if jumpFolder then
        applyAnimation(jumpFolder, "JumpAnim", animConfig.Jump)
    end

    -- Fall
    local fallFolder = animate:FindFirstChild("fall")
    if fallFolder then
        applyAnimation(fallFolder, "FallAnim", animConfig.Fall)
    end

    -- Climb
    local climbFolder = animate:FindFirstChild("climb")
    if climbFolder then
        applyAnimation(climbFolder, "ClimbAnim", animConfig.Climb)
    end

    -- Swim
    local swimFolder = animate:FindFirstChild("swim")
    if swimFolder then
        applyAnimation(swimFolder, "Swim", animConfig.Swim)
    end

    -- SwimIdle
    local swimIdleFolder = animate:FindFirstChild("swimidle")
    if swimIdleFolder then
        applyAnimation(swimIdleFolder, "SwimIdle", animConfig.SwimIdle)
    end

    -- Sit (CORRIGIDO - Handles both R15 and R6)
    local sitFolder = animate:FindFirstChild("sit")
    if sitFolder then
        local sitId = animConfig.Sit
        if sitId then
            -- Tenta aplicar em ambas as variações possíveis
            applyAnimation(sitFolder, "Sit", sitId)
            applyAnimation(sitFolder, "SitIdle", sitId)
            applyAnimation(sitFolder, "SitAnim", sitId) -- Algumas versões usam isso
        end
    end

    -- Refresh animation state
    task.wait(0.1)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        local currentState = hum:GetState()
        if currentState == Enum.HumanoidStateType.Seated then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            task.wait(0.15)
            hum:ChangeState(Enum.HumanoidStateType.Seated)
        else
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end

-- Protection against double injection
if getgenv().R6AnimReplaceLoaded then
    if not getgenv()._r6AnimConnection then
        getgenv()._r6AnimConnection = player.CharacterAdded:Connect(function(character)
            task.spawn(applyAnims, character)
        end)
        if player.Character then
            task.spawn(applyAnims, player.Character)
        end
    end
    print("R6 Animation Replacer already loaded. Using existing connection.")
    return
end

getgenv().R6AnimReplaceLoaded = true

-- Apply to current character
if player.Character then
    task.spawn(applyAnims, player.Character)
end

-- Listen for new characters
getgenv()._r6AnimConnection = player.CharacterAdded:Connect(function(character)
    task.spawn(applyAnims, character)
end)
