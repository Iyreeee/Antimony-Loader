
local function Notify(Title, Text, Duration)
	game:GetService('StarterGui'):SetCore("SendNotification", {
	    Title = Title,
	    Text = Text,
	    Duration = Duration
	})
end

local cloneref = cloneref or function(...)
    return ...
end

local Players = cloneref(game:GetService("Players"))
local Player = Players and Players.LocalPlayer

local ScriptID = ({
    [7018190066] = "310e37c829f002bedf76a1213590a4f3", -- Dead Rails
    [3808081382] = "72658b362cb91f830bb5450f954fba35", -- TSB
})[game.GameId]

if not ScriptID then
    return Player:Kick("Unsupported game!")
end

if script_key then
    local success, result = pcall(function()
        return game:HttpGet(`https://api.luarmor.net/files/v3/loaders/{ScriptID}.lua`)
    end)
    if success then
        loadstring(result)()
    else
        warn("Failed to load main script:", result)
        Notify("ERROR", "Failed to load script", 5)
    end
    return
end

local ReGui
do
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
    end)
    if success then
        ReGui = result
    else
        warn("Failed to load UI:", result)
        return
    end
end

local Prefabs
do
    local InsertService = cloneref(game:GetService('InsertService'))
    local success, result = pcall(function()
        return InsertService:LoadLocalAsset("rbxassetid://" .. ReGui.PrefabsId)
    end)
    if success then
        Prefabs = result
    else
        warn("Failed to load lib prefabs:", result)
        return
    end
end

ReGui:Init({
    Prefabs = Prefabs
})

local Window = ReGui:Window({
    Title = "Antimony | Key System",
    Size = UDim2.fromOffset(280, 150)
}):Center()

local KeyInput = Window:InputText({
    Placeholder = "Enter your key...",
    Label = "",
    Value = "",
})

Window:Button({
    Text = "       Submit Key      ",
    Callback = function()
        local Key = KeyInput.Value
        if Key == "" or #Key < 10 then
            return Notify("FAILED", "Invalid Key", 5)
        end

        Window:Remove()
        script_key = Key

        local success, result = pcall(function()
            return game:HttpGet(`https://api.luarmor.net/files/v3/loaders/{ScriptID}.lua`)
        end)

        if success then
            loadstring(result)()
        else
            Notify("ERROR", "Failed to load script", 5)
            warn("Script load failed:", result)
        end
    end,
})

Window:Label({ Text = "Get Key:" })

local Row = Window:Row()

Row:Button({
    Text = "  Linkvertise  ",
    Callback = function()
        setclipboard("https://ads.luarmor.net/get_key?for=Antimony_Linkvertise-gOvqVViGyEmL")
        Notify("NOTIFICATION", "Key System link copied!", 5)
    end,
})

Row:Button({
    Text = "   Lootlabs   ",
    Callback = function()
        setclipboard("https://ads.luarmor.net/get_key?for=Antimony_Lootlabs-ulvowoAItxRF")
        Notify("NOTIFICATION", "Key System link copied!", 5)
    end,
})

Window:Button({
    Text = "Any issues? Join our discord!",
    Callback = function()
        setclipboard("https://discord.gg/HezQqF8Eu8")
        Notify("NOTIFICATION", "Invite link copied!", 5)
    end,
})
