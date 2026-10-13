local addonName, Tweaks = ...
local MapPins = {}
Tweaks.Modules["MapPins"] = MapPins

function MapPins:Init(QM)
    local L = QM.L or {}

    local function HookMapPin(pin)
        if pin._tweakedPin then return end
        pin._tweakedPin = true

        -- Ensure both Left and Right clicks are caught
        if pin.RegisterForClicks then
            pin:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        end

        pin:SetScript("OnClick", function(self, button)
            if not self.pinData then return end

            -- 1. RIGHT-CLICK: Clear the marker/waypoint immediately
            if button == "RightButton" then
                if Tweaks.ClearCurrentMarker then
                    Tweaks.ClearCurrentMarker()
                end
                return
            end

            -- 2. LEFT-CLICK handling
            if button == "LeftButton" then
                local data = self.pinData
                local isTurnIn = (data.pinType == "turnin")

                -- Turn-In without Shift opens quest log
                if isTurnIn and not IsShiftKeyDown() then
                    if QM.OpenQuestLog then
                        QM:OpenQuestLog(data.questId)
                    end
                    return
                end

                -- Set manual waypoint
                local waypointTitle = data.description or data.title
                QM:SetWaypoint(
                    data.questId,
                    data.objectiveIndex or 0,
                    data.x,
                    data.y,
                    data.mapId,
                    waypointTitle,
                    true
                )

                QM.isManualWaypoint = true
                if QM.currentWaypoint then
                    QM.currentWaypoint.isManual = true
                    if waypointTitle and waypointTitle ~= "" then
                        QM.currentWaypoint.title = waypointTitle
                    end
                end

                if QM.ArrowFrame then
                    QM.ArrowFrame:SetAlpha(0)
                    if UIFrameFadeIn then
                        UIFrameFadeIn(QM.ArrowFrame, 0.3, 0, 1)
                    else
                        QM.ArrowFrame:SetAlpha(1)
                    end
                end
                print((L["MSG_PREFIX"] or "[QM]") .. " " .. (L["MSG_WAYPOINT_SET_MANUAL"] or "Waypoint set manually."))
            end
        end)
    end

    local origGetWorldMapPin = QM.GetWorldMapPin
    if origGetWorldMapPin then
        QM.GetWorldMapPin = function(self)
            local pin = origGetWorldMapPin(self)
            if pin then HookMapPin(pin) end
            return pin
        end
    end

    local origGetMinimapPin = QM.GetMinimapPin
    if origGetMinimapPin then
        QM.GetMinimapPin = function(self)
            local pin = origGetMinimapPin(self)
            if pin then HookMapPin(pin) end
            return pin
        end
    end
end