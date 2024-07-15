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
    ['ESP-Tab'] = Windows:AddTab({
        Title = 'ESP',
        Icon = 'expand'
    })
}
local ItemESPToggle = Tabs['ESP-Tab']:AddToggle('ItemESP-ToggleRenv', {
    Title = 'Item ESP',
    Default = false
})
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
                            ESP.FillColor = (v:FindFirstChild(v.Name) and v:FindFirstChild(v.Name).Color) or Color3.new(1, 1, 1)
                        end
                    end
                end
            end
        end
    end
end
local function RemoveESPItemsFromItems()
    local WaitForMap = true
    local Map = nil
    while (WaitForMap == true) and wait(1) do
        Map = GetCurrentMapAsync()
        print('Finding map. Map is currently: ' .. tostring(Map) .. ': [1] is: ' .. tostring(Map[1]))

        if enabled == false then
            return
        end

        if Map then
            WaitForMap = false
            break
        end
    end

    if Map and Map[1] then
        print('MAP FOUND!')
        -- Get the 'Utilities' child from Map[1]
        local utilities = Map[1]:WaitForChild('Utilities', 60)

        if utilities then
            for i, v in ipairs(utilities:GetChildren()) do
                if v and v.ClassName == 'Model' and v:FindFirstChild('ESP') then
                    print('Successfully removed esp from: ' .. tostring(v:GetFullName()))
                    v:WaitForChild('ESP'):Destroy()
                else
                    warn('Skipped: ' .. tostring(v:GetFullName()))
                end
            end
        end
    end
end
ItemESPToggle:OnChanged(function(toggle)
    enabled = toggle
    if toggle == true then
        ToggleLoopESP()
    else
        print('REMOVING ALL ESP FROM ALL ITEMS')
        RemoveESPItemsFromItems()
    end
end)



-- loadstring(game:HttpGet('https://raw.githubusercontent.com/SubnauticaLaserMain/ServerScriptAPI-Android-V12/main/Bakon2Script.lua', true))()
