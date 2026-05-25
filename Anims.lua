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
local player  = Players.LocalPlayer

local function stopAllTracks(character)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end
end

local function applyAnims(character)
    if not character then return end

    local animate = character:FindFirstChild("Animate")
    if not animate then
        animate = character:WaitForChild("Animate", 10)
        if not animate then return end
    end

    task.wait(0.3)
    stopAllTracks(character)

    -- Idle
    local idleFolder = animate:FindFirstChild("idle")
    if idleFolder then
        local ids = getgenv().R6Anims.Idle
        local anim1 = idleFolder:FindFirstChild("Animation1")
        local anim2 = idleFolder:FindFirstChild("Animation2")
        if type(ids) == "table" then
            if anim1 and ids[1] then anim1.AnimationId = "rbxassetid://" .. ids[1] end
            if anim2 and ids[2] then anim2.AnimationId = "rbxassetid://" .. ids[2] end
        else
            if anim1 then anim1.AnimationId = "rbxassetid://" .. ids end
            if anim2 then anim2.AnimationId = "rbxassetid://" .. ids end
        end
    end

    -- Walk
    local walkFolder = animate:FindFirstChild("walk")
    if walkFolder then
        local w = walkFolder:FindFirstChild("WalkAnim")
        if w then w.AnimationId = "rbxassetid://" .. getgenv().R6Anims.Walk end
    end

    -- Run
    local runFolder = animate:FindFirstChild("run")
    if runFolder then
        local r = runFolder:FindFirstChild("RunAnim")
        if r then r.AnimationId = "rbxassetid://" .. getgenv().R6Anims.Run end
    end

    -- Jump
    local jumpFolder = animate:FindFirstChild("jump")
    if jumpFolder then
        local j = jumpFolder:FindFirstChild("JumpAnim")
        if j then j.AnimationId = "rbxassetid://" .. getgenv().R6Anims.Jump end
    end

    -- Fall
    local fallFolder = animate:FindFirstChild("fall")
    if fallFolder then
        local f = fallFolder:FindFirstChild("FallAnim")
        if f then f.AnimationId = "rbxassetid://" .. getgenv().R6Anims.Fall end
    end

    -- Climb
    local climbFolder = animate:FindFirstChild("climb")
    if climbFolder then
        local c = climbFolder:FindFirstChild("ClimbAnim")
        if c then c.AnimationId = "rbxassetid://" .. getgenv().R6Anims.Climb end
    end

    -- Swim
    local swimFolder = animate:FindFirstChild("swim")
    if swimFolder then
        local s = swimFolder:FindFirstChild("Swim")
        if s then s.AnimationId = "rbxassetid://" .. getgenv().R6Anims.Swim end
    end

    -- SwimIdle
    local swimIdleFolder = animate:FindFirstChild("swimidle")
    if swimIdleFolder then
        local si = swimIdleFolder:FindFirstChild("SwimIdle")
        if si then si.AnimationId = "rbxassetid://" .. getgenv().R6Anims.SwimIdle end
    end

    -- Sit
    local sitFolder = animate:FindFirstChild("sit")
    if sitFolder then
        local sitId = getgenv().R6Anims.Sit
        if sitId then
            local s1 = sitFolder:FindFirstChild("Sit")
            local s2 = sitFolder:FindFirstChild("SitIdle")
            if s1 then s1.AnimationId = "rbxassetid://" .. sitId end
            if s2 then s2.AnimationId = "rbxassetid://" .. sitId end
        end
    end

    -- Refresh
    task.wait(0.1)
    local hum = character:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum:GetState() == Enum.HumanoidStateType.Seated then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            task.wait(0.1)
            hum:ChangeState(Enum.HumanoidStateType.Seated)
        else
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end
end -- fecha o applyAnims

-- Proteção contra dupla injeção (DEPOIS de tudo definido)
if getgenv().R6AnimReplaceLoaded then
    if not getgenv()._r6AnimConnection then
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

if player.Character then
    task.spawn(applyAnims, player.Character)
end

getgenv()._r6AnimConnection = player.CharacterAdded:Connect(function(character)
    task.spawn(applyAnims, character)
end)
