local addonName, Tweaks = ...
local Navigation = {}
Tweaks.Modules["Navigation"] = Navigation

function Navigation:Init(QM)
    Tweaks.isSettingFromPin = false

    -- 1. Waypoint Lock: Guard against auto-selector purging unaccepted quests
    if QM.SetWaypoint then
        local origSetWaypoint = QM.SetWaypoint
        QM.SetWaypoint = function(self, questId, objIndex, x, y, mapId, title, isManual, ...)
            Tweaks.isSettingFromPin = true
            origSetWaypoint(self, questId, objIndex, x, y, mapId, title, isManual, ...)

            if isManual then
                self.isManualWaypoint = true
                if self.currentWaypoint then
                    self.currentWaypoint.isManual = true
                    if title and title ~= "" then
                        self.currentWaypoint.title = title
                    end
                end
                self.manualWaypointSetAt = GetTime()
            end

            C_Timer.After(0.05, function()
                Tweaks.isSettingFromPin = false
            end)
        end
    end

    local autoPickerNames = {"AutoSelectNearestQuest", "UpdateNearestWaypoint", "PickClosestObjective", "AutoSelectNext"}
    for _, funcName in ipairs(autoPickerNames) do
        if QM[funcName] then
            local origPicker = QM[funcName]
            QM[funcName] = function(self, ...)
                if self.isManualWaypoint or (self.currentWaypoint and self.currentWaypoint.isManual) then
                    return
                end
                return origPicker(self, ...)
            end
        end
    end

    -- 2. Sync Native Map Pins (Terrain Clicks)
    local userWaypointFrame = CreateFrame("Frame")
    userWaypointFrame:RegisterEvent("USER_WAYPOINT_UPDATED")
    userWaypointFrame:SetScript("OnEvent", function(self, event)
        if Tweaks.isSettingFromPin then return end

        if C_Map and C_Map.HasUserWaypoint and C_Map.HasUserWaypoint() then
            local mapPoint = C_Map.GetUserWaypoint()
            if mapPoint then
                QM.isManualWaypoint = nil
                if QM.currentWaypoint then
                    QM.currentWaypoint.isManual = nil
                end

                if QM.SetWaypoint then
                    QM:SetWaypoint(0, 0, mapPoint.position.x, mapPoint.position.y, mapPoint.uiMapID, "Custom Waypoint", true)
                end
            end
        else
            QM.isManualWaypoint = nil
            if QM.currentWaypoint and QM.currentWaypoint.questId == 0 then
                QM.currentWaypoint = nil
                if QM.ClearWaypoint then
                    QM:ClearWaypoint()
                end
            end
        end
    end)

    if C_Map and C_Map.ClearUserWaypoint then
        hooksecurefunc(C_Map, "ClearUserWaypoint", function()
            if not Tweaks.isSettingFromPin then
                QM.isManualWaypoint = nil
                if QM.currentWaypoint and QM.currentWaypoint.questId == 0 then
                    QM.currentWaypoint = nil
                    if QM.ClearWaypoint then
                        QM:ClearWaypoint()
                    end
                end
            end
        end)
    end

    -- 3. World Marker Live ETA Countdown
    local smoothedSpeed = 7.0
    local lastPlayerX, lastPlayerY, lastPlayerTime

    local function FormatETA(seconds)
        if not seconds or seconds <= 0 or seconds == math.huge then return nil end
        local m = math.floor(seconds / 60)
        local s = math.floor(seconds % 60)
        if m > 0 then
            return string.format("%dm:%02ds ETA", m, s)
        else
            return string.format("%ds ETA", s)
        end
    end

    local WM = QM.WorldMarker
    if WM and WM.UpdateMarker then
        hooksecurefunc(WM, "UpdateMarker", function(self)
            local marker = self.marker
            if not (marker and marker:IsShown() and marker.distance and marker.distance:IsShown()) then
                return
            end

            local wp = QM.currentWaypoint
            local yards
            if wp and wp.x and wp.mapId and QM.GetDistanceToPoint then
                local d = QM:GetDistanceToPoint(wp.x, wp.y, wp.mapId)
                if type(d) == "number" and d < 99999 then yards = d end
            end
            if not yards and C_Navigation and C_Navigation.GetDistance then
                local ok, d = pcall(C_Navigation.GetDistance)
                if ok and type(d) == "number" and d > 0 then yards = d end
            end

            if not yards or yards <= 5 then return end

            local speed = GetUnitSpeed("player")
            local now = GetTime()

            if (not speed or speed <= 1) and C_Map and C_Map.GetPlayerMapPosition then
                local currentMap = C_Map.GetBestMapForUnit("player")
                if currentMap then
                    local pos = C_Map.GetPlayerMapPosition(currentMap, "player")
                    if pos and lastPlayerX and lastPlayerTime and (now - lastPlayerTime) > 0.1 then
                        local dx = (pos.x - lastPlayerX) * 1000
                        local dy = (pos.y - lastPlayerY) * 1000
                        local distMoved = math.sqrt(dx * dx + dy * dy)
                        local dt = now - lastPlayerTime
                        if dt > 0 and distMoved > 0.05 then
                            speed = distMoved / dt
                        end
                    end
                    if pos then
                        lastPlayerX, lastPlayerY, lastPlayerTime = pos.x, pos.y, now
                    end
                end
            end

            if not speed or speed <= 1 then
                speed = IsMounted() and 14.0 or 7.0
            end

            smoothedSpeed = smoothedSpeed + (speed - smoothedSpeed) * 0.1
            local eta = yards / math.max(smoothedSpeed, 1.0)
            local etaStr = FormatETA(eta)

            if etaStr then
                local distText = marker.distance.qmText or marker.distance:GetText()
                if distText and not distText:find("ETA") then
                    marker.distance:SetText(distText .. "\n" .. etaStr)
                end
            end
        end)
    end
end