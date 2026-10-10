local addonName, Tweaks = ...
Tweaks.Modules = {}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    local QM = QuestMaster or _G["QM"]
    if not QM then return end

    -- 1. Initialize Localization
    if Tweaks.Locales and Tweaks.Locales.Load then
        Tweaks.Locales:Load(QM)
    end

    -- 2. Escape Key Support for Settings Panel
    local function RegisterSettingsEscape()
        local frameName = "QuestMasterSettings"
        if _G[frameName] then
            for _, name in ipairs(UISpecialFrames) do
                if name == frameName then return end
            end
            table.insert(UISpecialFrames, frameName)
        end
    end
    RegisterSettingsEscape()
    if QM.ToggleSettings then
        hooksecurefunc(QM, "ToggleSettings", RegisterSettingsEscape)
    end

    -- 3. Initialize Registered Modules
    for moduleName, module in pairs(Tweaks.Modules) do
        if type(module.Init) == "function" then
            module:Init(QM)
        end
    end

    -- 4. Initial Refreshes
    if QM.UpdateMapPins then QM:UpdateMapPins() end
    if QM.UpdateTracker then QM:UpdateTracker() end

    -- 5. Load Announcement
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFD700[QuestMaster Tweaks]|r successfully loaded!")
    else
        print("|cFFFFD700[QuestMaster Tweaks]|r successfully loaded!")
    end
end)