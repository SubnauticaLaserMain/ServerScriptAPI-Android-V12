local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Windows = Library:CreateWindow({
    Title = '' .. tostring(game.Name) .. ' - Library v' .. tostring(Library.Version),
    SubTitle = "by julianpiggyogbedwarspro (on Discord)",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})
local Tabs = {
    ['Player'] = Windows:AddTab({
        Title = 'Player',
        Icon = 'user-round-pen'
    }),

    ['ESP-Tab'] = Windows:AddTab({
        Title = 'ESP',
        Icon = 'expand'
    })
}
local ItemESPToggle = Tabs['ESP-Tab']:AddToggle('ItemESP-ToggleRenv', {
    Title = 'Item ESP',
    Default = false
})

local TrapESPToggle = Tabs['ESP-Tab']:AddToggle('TrapESP-ToggleRenv', {
    Title = 'Trap ESP',
    Default = false
})

local PlayerESPToggle = Tabs['ESP-Tab']:AddToggle('PLR-ESP-ToggleRenv', {
    Title = 'Player ESP',
    Default = false
})

local BeaconESPToggle = Tabs['ESP-Tab']:AddToggle('BeaconESP-ToggleRenv', {
    Title = 'Beacon ESP',
    Default = false
})


local Players = game:GetService('Players')






local function InvokeSurvivers()
    local Survivers = {}


    for i, v in ipairs(Players:GetPlayers()) do
        local Character = v.Character or v.CharacterAdded:Wait()

        if Character then
            if not Character:FindFirstChild('AnimSaves') then
                Survivers[i] = v
            end
        end
    end

    return Survivers
end






local wait = task.wait


local PlayerESPEnabled = false
local function AddPlayerESP_Object()
    while (PlayerESPEnabled == true) and wait(0.5) do
        local Survivers = InvokeSurvivers()
        
        for i, v in ipairs(Survivers) do
            if i and v and v:IsA('Player') then
                local Character = v.Character or v.CharacterAdded:Wait()

                if Character then
                    local HasESP = Character:FindFirstChild('ESP')

                    if not HasESP then
                        local ESP = Instance.new('Highlight', Character)
                        ESP.Name = 'ESP'
                        ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        ESP.FillColor = Color3.new(1, 1, 1)
                    end
                end
            end
        end
    end
end


local function RemovePlayerESP_Object()
    while (PlayerESPEnabled == false) and wait(0.5) do
        local Survivers = InvokeSurvivers()
        
        for i, v in ipairs(Survivers) do
            if i and v and v:IsA('Player') then
                local Character = v.Character or v.CharacterAdded:Wait()

                if Character then
                    local HasESP = Character:FindFirstChild('ESP')

                    if HasESP then
                        Character:WaitForChild('ESP'):Destroy()
                    end
                end
            end
        end
    end
end


PlayerESPToggle:OnChanged(function(toggle)
    PlayerESPEnabled = toggle

    if toggle == true then
        AddPlayerESP_Object()
    else
        RemovePlayerESP_Object()
    end
end)



local function GetHumanoid()
    local Character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()

    if Character then
        local Humanoid = Character:WaitForChild('Humanoid', 120)

        if Humanoid then
            return Humanoid
        else
            warn('Waited 120 SEC (2 MINS) FOR HUMANOID, AND FAILED.')
            return
        end
    end
end



local WalkSpeedToggle = Tabs['Player']:AddToggle('ToggleWalkerSpeeder-Renver', {
    Title = 'Toggle Walkspeed',
    Default = false
})


local WalkSpeedSlider = Tabs['Player']:AddSlider('ToggleWalkSpeederSliderAsyncer-Renver', {
    Title = 'WalkSpeed Value',
    Description = 'Choose how fast you walk.',
    Default = GetHumanoid().WalkSpeed,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(a)end
})

local NewWalkSpeedValue = GetHumanoid().WalkSpeed
local NewWalkSpeedValueEnabled = false


local WalkSpeedSliderValue = 16
WalkSpeedSlider:OnChanged(function(Val)
    WalkSpeedSliderValue = Val
end)


local function UpdateWalkSpeedObjectItemsTableForLocalPlayer()
    while (NewWalkSpeedValueEnabled == true) and wait(0.2) do
        if GetHumanoid().WalkSpeed ~= WalkSpeedSliderValue then
            GetHumanoid().WalkSpeed = WalkSpeedSliderValue
        end
    end
end

local function ResetWalkSpeedBackToWhatItWas()
    if GetHumanoid() and GetHumanoid().WalkSpeed then
        GetHumanoid().WalkSpeed = NewWalkSpeedValue
    end
end


WalkSpeedToggle:OnChanged(function(toggle)
    NewWalkSpeedValueEnabled = toggle

    if toggle == true then
        UpdateWalkSpeedObjectItemsTableForLocalPlayer()
    else
        ResetWalkSpeedBackToWhatItWas()
    end
end)



local function GetTabsTableInString()
    local String = ''

    for i, v in Tabs do
        String = tostring(i) .. ', '
    end

    return String
end

print('Finished loading, with tabs table beeing: ' .. GetTabsTableInString())















local function GetCurrentMapAsync()
    local MapsFolder = workspace:WaitForChild('CurrentMap', 70)
    if not MapsFolder then
        warn('Could not find map')
        return
    end
    local Map = MapsFolder:GetChildren()
    if Map then
        return Map
    else
        warn('Map was not found')
        return
    end 
end
local Items = {}
local enabled = false
local function ToggleLoopESP()
    while (enabled == true) and wait(0.5) do
        local Map = GetCurrentMapAsync()
        if Map[1] then
            -- Get the 'Utilities' child from Map[1]
            local utilities = Map[1]:WaitForChild('Utilities', 60)

            if utilities then
                for i, v in ipairs(utilities:GetChildren()) do
                    if v and v.ClassName == 'Model' then
                        local HasESP = v:FindFirstChild('ESP')

                        if not HasESP then
                            local ESP = Instance.new('Highlight', v)
                            ESP.Name = 'ESP'
                            ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            ESP.FillColor = (v:FindFirstChild(v.Name) and v:FindFirstChild(v.Name):IsA('MeshPart') and v:FindFirstChild(v.Name).Color) or Color3.new(1, 1, 1)
                            Items[v.Name] = ESP
                        end
                    end
                end
            end
        end
    end
end
local function UpdateItemsTable()
    local Map = GetCurrentMapAsync()
    if Map[1] then
        -- Get the 'Utilities' child from Map[1]
        local utilities = Map[1]:WaitForChild('Utilities', 60)

        if utilities then
            for i, v in ipairs(utilities:GetChildren()) do
                if v and v.ClassName == 'Model' then
                    local HasESP = v:FindFirstChild('ESP')

                    Items[v.Name] = v:FindFirstChild('ESP')
                end
            end
        end
    end
end
local function RemoveESPItemsFromItems()
    while (enabled == false) and wait(0.5) do
        local Map = GetCurrentMapAsync()
        if Map[1] then
            -- Get the 'Utilities' child from Map[1]
            local utilities = Map[1]:WaitForChild('Utilities', 60)

            if utilities then
                for i, v in ipairs(utilities:GetChildren()) do
                    if v and v.ClassName == 'Model' then
                        local HasESP = v:FindFirstChild('ESP')

                        if HasESP then
                            v:FindFirstChild('ESP'):Destroy()
                        end
                    end
                end
            end
        end
    end
end

local TrapESPEnabled = false
local function DoTrapESPLoopForTrapESP()
    while (TrapESPEnabled == true) and wait(0.5) do
        local Map = GetCurrentMapAsync()

        if Map[1] then
            local TrapsFolder = Map[1]:WaitForChild('TemporaryTraps', 60)

            if TrapsFolder then
                for i, v in ipairs(TrapsFolder:GetChildren()) do
                    if v and v.ClassName == 'Model' then
                        local HasESP = v:FindFirstChild('ESP')


                        if not HasESP then
                            local ESP = Instance.new('Highlight', v)
                            ESP.Name = 'ESP'
                            ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            ESP.FillColor = Color3.new(1, 1, 1)
                        end
                    end
                end
            end
        end
    end
end
local function DoTrapESPLoopForRemoveTrapESP()
    while (TrapESPEnabled == false) and wait(0.5) do
        local Map = GetCurrentMapAsync()

        if Map[1] then
            local TrapsFolder = Map[1]:WaitForChild('TemporaryTraps', 60)

            if TrapsFolder then
                for i, v in ipairs(TrapsFolder:GetChildren()) do
                    if v and v.ClassName == 'Model' then
                        local HasESP = v:FindFirstChild('ESP')


                        if HasESP then
                            v:WaitForChild('ESP'):Destroy()
                        end
                    end
                end
            end
        end
    end
end
local function InvokeBeaconBot()
    local Map = GetCurrentMapAsync()


    if Map[1] then
        for i, v in Map[1]:GetChildren() do
            if string.find(v.Name, 'BakonBot') then
                local BeaconBot = v
                return BeaconBot
            end
        end
    else
        return
    end
end
local function InvokeBeacon()
    for i, v in ipairs(Players:GetPlayers()) do
        local isBeacon = v.Character:FindFirstChild('AnimSaves')

        if isBeacon and isBeacon:IsA('Model') then
            return v.Character
        end
    end
end
local function isBeacon()
    local BeaconBot = InvokeBeaconBot()
    local Beacon = InvokeBeacon()


    if BeaconBot or Beacon then
        return true
    end

    return false
end







ItemESPToggle:OnChanged(function(toggle)
    enabled = toggle
    if toggle == true then
        UpdateItemsTable()
        ToggleLoopESP()
    else
        UpdateItemsTable()
        RemoveESPItemsFromItems()
    end
end)


TrapESPToggle:OnChanged(function(toggle)
    TrapESPEnabled = toggle


    if toggle == true then
        DoTrapESPLoopForTrapESP()
    else
        DoTrapESPLoopForRemoveTrapESP()
    end
end)



local BeacoNESPEnbled = false



local function AddESP_Beacon()
    while (BeacoNESPEnbled == true) and wait(0.5) do
        local IsBeaconHere = isBeacon()

        if IsBeaconHere then
            local BeaconBot = InvokeBeaconBot()
            local Beacon = InvokeBeacon()

            if BeaconBot and (not BeaconBot:FindFirstChild('ESP')) then
                local ESP = Instance.new('Highlight', BeaconBot)
                ESP.Name = 'ESP'
                ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                ESP.FillColor = Color3.new(1, 1, 1)
            elseif Beacon and (not Beacon:FindFirstChild('ESP')) then        
                local ESP = Instance.new('Highlight', Beacon)
                ESP.Name = 'ESP'
                ESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                ESP.FillColor = Color3.new(1, 1, 1)
            end
        end
    end
end
local function RemoveESP_Beacon()
    while (BeacoNESPEnbled == false) and wait(0.5) do
        local IsBeaconHere = isBeacon()

        if IsBeaconHere then
            local BeaconBot = InvokeBeaconBot()
            local Beacon = InvokeBeacon()

            if BeaconBot and BeaconBot:FindFirstChild('ESP') then
                BeaconBot:WaitForChild('ESP'):Destroy()
            elseif Beacon and Beacon:FindFirstChild('ESP') then
                Beacon:WaitForChild('ESP'):Destroy()
            end
        end
    end
end



BeaconESPToggle:OnChanged(function(toggle)
    BeacoNESPEnbled = toggle

    if toggle == true then
        AddESP_Beacon()
    else
        RemoveESP_Beacon()
    end
end)


-- loadstring(game:HttpGet('https://raw.githubusercontent.com/SubnauticaLaserMain/ServerScriptAPI-Android-V12/main/Bakon.lua', true))()
