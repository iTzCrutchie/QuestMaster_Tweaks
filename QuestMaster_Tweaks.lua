local addonName, Tweaks = ...
_G["QuestMaster_Tweaks"] = Tweaks
Tweaks.Modules = {}

-- Comprehensive Waypoint & Marker Clear
function Tweaks.ClearCurrentMarker()
    local QM = QuestMaster or _G["QM"]
    if not QM then return end

    -- 1. Persist the cleared state across /reload and relog
    QM.isManualWaypoint = nil
    QM.userClearedWaypoint = true
    QM.manualWaypoint = false
    QM.currentWaypoint = nil

    if QM.db and QM.db.char then
        QM.db.char.userClearedWaypoint = true
        QM.db.char.savedWaypoint = nil
    end

    -- 2. Clear native Blizzard Map user waypoint
    if C_Map and C_Map.ClearUserWaypoint then
        pcall(C_Map.ClearUserWaypoint)
    end

    -- 3. Clear Blizzard SuperTracking
    if C_SuperTrack then
        if C_SuperTrack.SetSuperTrackedUserWaypoint then
            pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, false)
        end
        if C_SuperTrack.ClearAllSuperTrackedContent then
            pcall(C_SuperTrack.ClearAllSuperTrackedContent)
        end
        if C_SuperTrack.SetSuperTrackedQuestID then
            pcall(C_SuperTrack.SetSuperTrackedQuestID, 0)
        end
    end

    -- 4. Clear QuestMaster core waypoint
    if QM.ClearWaypoint then
        pcall(QM.ClearWaypoint, QM)
    end

    -- 5. Hard hide QuestMaster's WorldMarker
    local WM = QM.WorldMarker
    if WM then
        WM.lastKey = nil
        WM.placed = nil
        WM.ownUserWaypoint = false
        if WM.ClearUserWaypoint then
            pcall(WM.ClearUserWaypoint, WM)
        end
        if WM.marker then
            WM.marker:Hide()
        end
    end

    if _G.QuestMasterWorldMarker then
        _G.QuestMasterWorldMarker:Hide()
    end

    -- 6. HIDE THE ENTIRE ARROW FRAME (no gray idle arrow)
    if QM.ArrowFrame then
        QM.ArrowFrame:Hide()
    end

    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFFD700[QuestMaster Tweaks]|r Waypoint and marker cleared.")
end

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

    -- 3. Intercept QuestMaster's AceConsole Slash Handler for /qm cm and /qm clearmarker
    if QM.addon and QM.addon.SlashCommand then
        local origSlash = QM.addon.SlashCommand
        QM.addon.SlashCommand = function(addonSelf, input)
            local cmd = input and input:trim():lower() or ""
            if cmd == "cm" or cmd == "clearmarker" then
                Tweaks.ClearCurrentMarker()
                return
            end
            return origSlash(addonSelf, input)
        end
    end

    -- Standalone command fallbacks
    SLASH_QMTWEAKS_CM1 = "/qmcm"
    SLASH_QMTWEAKS_CM2 = "/clearmarker"
    SlashCmdList["QMTWEAKS_CM"] = function()
        Tweaks.ClearCurrentMarker()
    end

    -- 4. Initialize Registered Modules
    for moduleName, module in pairs(Tweaks.Modules) do
        if type(module.Init) == "function" then
            module:Init(QM)
        end
    end

    -- 5. Initial Refreshes
    if QM.UpdateMapPins then QM:UpdateMapPins() end
    if QM.UpdateTracker then QM:UpdateTracker() end

    -- 6. Load Announcement
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFFD700[QuestMaster Tweaks]|r successfully loaded!")
    else
        print("|cFFFFD700[QuestMaster Tweaks]|r successfully loaded!")
    end
end)