local addonName, Tweaks = ...
local MapPins = {}
Tweaks.Modules["MapPins"] = MapPins

function MapPins:Init(QM)
    local L = QM.L or {}

    local function HookMapPin(pin)
        if pin._tweakedPin then return end
        pin._tweakedPin = true

        pin:SetScript("OnClick", function(self, button)
            if button ~= "LeftButton" or not self.pinData then return end

            local data = self.pinData
            local isTurnIn = (data.pinType == "turnin")

            if isTurnIn and not IsShiftKeyDown() then
                if QM.OpenQuestLog then
                    QM:OpenQuestLog(data.questId)
                end
                return
            end

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
        end)

        pin:HookScript("OnEnter", function(self)
            local data = self.pinData
            if not (data and data.pinType == "turnin" and GameTooltip:IsShown()) then return end

            local numLines = GameTooltip:NumLines()
            if numLines < 2 then return end

            local lines = {}
            for i = 1, numLines do
                local left = _G["GameTooltipTextLeft" .. i]
                local right = _G["GameTooltipTextRight" .. i]
                lines[i] = {
                    left = left and left:GetText(),
                    right = right and right:GetText(),
                    lr = left and select(1, left:GetTextColor()) or 1,
                    lg = left and select(2, left:GetTextColor()) or 1,
                    lb = left and select(3, left:GetTextColor()) or 1,
                    rr = right and select(1, right:GetTextColor()) or 1,
                    rg = right and select(2, right:GetTextColor()) or 1,
                    rb = right and select(3, right:GetTextColor()) or 1,
                }
            end

            local cutIndex = numLines
            while cutIndex > 1 do
                local text = lines[cutIndex].left
                if text then
                    local isDefaultHint = text:find("waypoint") or text:find("Waypoint")
                        or text:find(L["PIN_TOOLTIP_CLICK_WAYPOINT"] or "")
                        or text:match("^%s*$")

                    if isDefaultHint then
                        cutIndex = cutIndex - 1
                    else
                        break
                    end
                else
                    cutIndex = cutIndex - 1
                end
            end

            GameTooltip:ClearLines()
            for i = 1, cutIndex do
                local l = lines[i]
                if l.right and l.right ~= "" then
                    GameTooltip:AddDoubleLine(l.left, l.right, l.lr, l.lg, l.lb, l.rr, l.rg, l.rb)
                elseif l.left then
                    GameTooltip:AddLine(l.left, l.lr, l.lg, l.lb, true)
                end
            end

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cFF888888" .. L["CLICK_OPEN_QUESTLOG"] .. "|r")
            GameTooltip:AddLine("|cFF888888" .. (L["MAP_CLICK_SET_WAYPOINT"] or L["CLICK_SET_WAYPOINT"]) .. "|r")
            GameTooltip:Show()
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