local addonName, Tweaks = ...
local Navigation = {}
Tweaks.Modules["Navigation"] = Navigation

function Navigation:Init(QM)
    Tweaks.isSettingFromPin = false

-- 0. Restore persistent cleared state on load / reload
    if QM.db and QM.db.char and QM.db.char.userClearedWaypoint then
        QM.userClearedWaypoint = true
        QM.currentWaypoint = nil
        QM.manualWaypoint = false
    end

-- ------------------------------------------------------------------------
    -- 1. Suppress Auto-Waypoint and Hide Gray Idle Arrow
    -- ------------------------------------------------------------------------
    if QM.AutoSelectBestWaypoint then
        local origAutoSelect = QM.AutoSelectBestWaypoint
        QM.AutoSelectBestWaypoint = function(self, force, ...)
            local isCleared = QM.userClearedWaypoint or (QM.db and QM.db.char and QM.db.char.userClearedWaypoint)
            if isCleared then
                return
            end
            return origAutoSelect(self, force, ...)
        end
    end

    -- Prevent DrawArrow from keeping the gray idle arrow visible when cleared
    if QM.DrawArrow then
        local origDrawArrow = QM.DrawArrow
        QM.DrawArrow = function(self, elapsed, ...)
            local isCleared = QM.userClearedWaypoint or (QM.db and QM.db.char and QM.db.char.userClearedWaypoint)
            if isCleared or not self.currentWaypoint then
                if QM.ArrowFrame and QM.ArrowFrame:IsShown() then
                    QM.ArrowFrame:Hide()
                end
                return
            end
            return origDrawArrow(self, elapsed, ...)
        end
    end

    -- ------------------------------------------------------------------------
    -- 2. Reset Cleared Flags & Restore Arrow on Waypoint Assignment
    -- ------------------------------------------------------------------------
    if QM.SetWaypoint then
        local origSetWaypoint = QM.SetWaypoint
        QM.SetWaypoint = function(self, questId, objIndex, x, y, mapId, title, isManual, ...)
            -- Unlock the cleared state
            QM.userClearedWaypoint = nil
            if QM.db and QM.db.char then
                QM.db.char.userClearedWaypoint = nil
            end

            Tweaks.isSettingFromPin = true
            local result = origSetWaypoint(self, questId, objIndex, x, y, mapId, title, isManual, ...)

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

            -- Ensure ArrowFrame is visible and active
            if QM.ArrowFrame and QM.db.profile.arrow.enabled then
                QM.ArrowFrame:Show()
                if QM.UpdateArrow then
                    QM:UpdateArrow()
                end
            end

            C_Timer.After(0.05, function()
                Tweaks.isSettingFromPin = false
            end)

            return result
        end
    end

    -- ------------------------------------------------------------------------
    -- 3. Sync Native Map Pins (Custom Terrain Pins)
    -- ------------------------------------------------------------------------
    local userWaypointFrame = CreateFrame("Frame")
    userWaypointFrame:RegisterEvent("USER_WAYPOINT_UPDATED")
    userWaypointFrame:SetScript("OnEvent", function(self, event)
        if Tweaks.isSettingFromPin then return end

        if C_Map and C_Map.HasUserWaypoint and C_Map.HasUserWaypoint() then
            local mapPoint = C_Map.GetUserWaypoint()
            if mapPoint and mapPoint.position then
                -- Player placed a new map pin on terrain: reset cleared states
                QM.userClearedWaypoint = nil
                if QM.db and QM.db.char then
                    QM.db.char.userClearedWaypoint = nil
                end
                QM.isManualWaypoint = true

                -- Apply waypoint to QuestMaster
                if QM.SetWaypoint then
                    QM:SetWaypoint(0, 0, mapPoint.position.x, mapPoint.position.y, mapPoint.uiMapID, "Custom Waypoint", true)
                end

                -- Force Arrow container to show and point to the new location
                if QM.ArrowFrame and QM.db.profile.arrow.enabled then
                    QM.ArrowFrame:Show()
                    if QM.ArrowFrame.arrow then QM.ArrowFrame.arrow:Show() end
                    if QM.ArrowFrame.shadow then QM.ArrowFrame.shadow:Show() end
                end

                if QM.UpdateArrow then
                    QM:UpdateArrow()
                end
            end
        else
            local isCleared = QM.userClearedWaypoint or (QM.db and QM.db.char and QM.db.char.userClearedWaypoint)
            if not isCleared and Tweaks.ClearCurrentMarker then
                Tweaks.ClearCurrentMarker()
            end
        end
    end)

    -- 4. Sync Native Map Pins (Terrain Clicks)
    local userWaypointFrame = CreateFrame("Frame")
    userWaypointFrame:RegisterEvent("USER_WAYPOINT_UPDATED")
    userWaypointFrame:SetScript("OnEvent", function(self, event)
        if Tweaks.isSettingFromPin then return end

        if C_Map and C_Map.HasUserWaypoint and C_Map.HasUserWaypoint() then
            local mapPoint = C_Map.GetUserWaypoint()
            if mapPoint and mapPoint.position then
                QM.userClearedWaypoint = nil
                if QM.db and QM.db.char then
                    QM.db.char.userClearedWaypoint = nil
                end
                QM.isManualWaypoint = true

                if QM.SetWaypoint then
                    QM:SetWaypoint(0, 0, mapPoint.position.x, mapPoint.position.y, mapPoint.uiMapID, "Custom Waypoint", true)
                end

                if QM.UpdateArrow then
                    QM:UpdateArrow()
                end
            end
        else
            local isCleared = QM.userClearedWaypoint or (QM.db and QM.db.char and QM.db.char.userClearedWaypoint)
            if not isCleared and Tweaks.ClearCurrentMarker then
                Tweaks.ClearCurrentMarker()
            end
        end
    end)

    if C_Map and C_Map.ClearUserWaypoint then
        hooksecurefunc(C_Map, "ClearUserWaypoint", function()
            if not Tweaks.isSettingFromPin and not QM.userClearedWaypoint and Tweaks.ClearCurrentMarker then
                Tweaks.ClearCurrentMarker()
            end
        end)
    end

-- 5. Physical Right-Click & Complete Blizzard Beacon Scrubber
    local WM = QM.WorldMarker
    if WM then
        local function EnableMarkerMouse(marker)
            if not marker then return end
            local clickFrame = marker.head or marker.body
            if clickFrame then
                clickFrame:EnableMouse(true)
                if clickFrame.RegisterForClicks then
                    clickFrame:RegisterForClicks("RightButtonUp")
                end
                clickFrame:SetScript("OnMouseUp", function(self, button)
                    if button == "RightButton" and Tweaks.ClearCurrentMarker then
                        Tweaks.ClearCurrentMarker()
                    end
                end)
            end
        end

        if WM.marker then
            EnableMarkerMouse(WM.marker)
        elseif WM.CreateMarker then
            hooksecurefunc(WM, "CreateMarker", function(self)
                EnableMarkerMouse(self.marker)
            end)
        end

        -- Intercept ShowBlizzardMarker
        if WM.ShowBlizzardMarker then
            local origShowBlizz = WM.ShowBlizzardMarker
            WM.ShowBlizzardMarker = function(self, show, ...)
                if QM.userClearedWaypoint then
                    return origShowBlizz(self, false, ...)
                end
                return origShowBlizz(self, show, ...)
            end
        end

        -- Scrubber function: Hides the Blizzard diamond textures directly
        local function ScrubNavTextures()
            if not QM.userClearedWaypoint then return end

            if _G.SuperTrackedFrame then
                _G.SuperTrackedFrame:Hide()
                _G.SuperTrackedFrame:SetAlpha(0)
            end

            if C_Navigation and C_Navigation.GetFrame then
                local navFrame = C_Navigation.GetFrame()
                if navFrame and navFrame ~= (WM and WM.marker) then
                    navFrame:Hide()
                    navFrame:SetAlpha(0)

                    -- Hide all child textures/regions inside Blizzard's navigation frame
                    for _, region in ipairs({ navFrame:GetRegions() }) do
                        if region:IsObjectType("Texture") then
                            region:SetAlpha(0)
                            region:Hide()
                        end
                    end
                    for _, child in ipairs({ navFrame:GetChildren() }) do
                        if child ~= (WM and WM.marker) then
                            child:Hide()
                            child:SetAlpha(0)
                        end
                    end
                end
            end
        end

        -- Run scrubber every frame tick while userClearedWaypoint is active
        if WM.UpdateMarker then
            hooksecurefunc(WM, "UpdateMarker", function(self)
                if QM.userClearedWaypoint then
                    ScrubNavTextures()
                end
            end)
        end
    end

    -- ------------------------------------------------------------------------
    -- 6. World Marker Suppression & Live ETA Countdown
    -- ------------------------------------------------------------------------
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
        local origUpdateMarker = WM.UpdateMarker
        WM.UpdateMarker = function(self, dt, ...)
            -- ABORT & HIDE: If the waypoint was cleared by the user, keep it completely hidden
            if QM.userClearedWaypoint then
                if self.marker and self.marker:IsShown() then
                    self.marker:Hide()
                end
                if _G.QuestMasterWorldMarker and _G.QuestMasterWorldMarker:IsShown() then
                    _G.QuestMasterWorldMarker:Hide()
                end
                return
            end

            -- Otherwise, run QuestMaster's normal UpdateMarker logic
            local result = origUpdateMarker(self, dt, ...)

            -- Live ETA addition
            local marker = self.marker
            if not (marker and marker:IsShown() and marker.distance and marker.distance:IsShown()) then
                return result
            end

            local wp = QM.currentWaypoint
            if not wp then return result end

            local yards
            if wp.x and wp.mapId and QM.GetDistanceToPoint then
                local d = QM:GetDistanceToPoint(wp.x, wp.y, wp.mapId)
                if type(d) == "number" and d < 99999 then yards = d end
            end
            if not yards and C_Navigation and C_Navigation.GetDistance then
                local ok, d = pcall(C_Navigation.GetDistance)
                if ok and type(d) == "number" and d > 0 then yards = d end
            end

            if not yards or yards <= 5 then return result end

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

            return result
        end
    end
end