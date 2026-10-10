local addonName, Tweaks = ...
local QuestTracker = {}
Tweaks.Modules["QuestTracker"] = QuestTracker

function QuestTracker:Init(QM)
    local L = QM.L or {}

    -- Override QM:ClickOpensQuestLog
    QM.ClickOpensQuestLog = function(self)
        local mode = self.db and self.db.profile and self.db.profile.tracker and self.db.profile.tracker.openQuestLog or "ctrl"
        if mode == "click" then return "plain" end
        if mode == "ctrl"  then return "ctrlmodifier" end
        if mode == "alt"   then return "altmodifier" end
        return nil
    end

    local function RebuildTrackerTooltip(isObjectiveLine)
        if not GameTooltip:IsShown() then return end

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
                local isHint = text:find("waypoint") or text:find("Waypoint")
                    or text:find("objective") or text:find("Objective")
                    or text:find("Link") or text:find("link")
                    or text:find("Options") or text:find("options")
                    or text:find("log") or text:find("Log")
                    or text:match("^%s*$")

                if isHint then
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
                GameTooltip:AddDoubleLine(l.left, l.right, l.lr, l.lg, l.lb, l.rr, l.lg, l.rb)
            elseif l.left then
                GameTooltip:AddLine(l.left, l.lr, l.lg, l.lb, true)
            end
        end

        local opens = QM:ClickOpensQuestLog()
        local waypointHint = isObjectiveLine and (L["CLICK_OBJECTIVE_WAYPOINT"] or "Left-click: Arrow to this objective")
                                             or (L["CLICK_SET_WAYPOINT"] or "Left-click: Set waypoint")

        GameTooltip:AddLine(" ")

        if opens == "ctrlmodifier" then
            GameTooltip:AddLine("|cFF888888" .. waypointHint .. "|r")
            GameTooltip:AddLine("|cFF888888" .. L["CLICK_CTRL_OPEN_QUESTLOG"] .. "|r")
        elseif opens == "altmodifier" then
            GameTooltip:AddLine("|cFF888888" .. waypointHint .. "|r")
            GameTooltip:AddLine("|cFF888888" .. L["CLICK_ALT_OPEN_QUESTLOG"] .. "|r")
        elseif opens == "plain" then
            if isObjectiveLine then
                GameTooltip:AddLine("|cFF888888" .. L["CLICK_WAYPOINT_AND_LOG"] .. "|r")
            else
                GameTooltip:AddLine("|cFF888888" .. waypointHint .. " & open quest log|r")
            end
        else
            GameTooltip:AddLine("|cFF888888" .. waypointHint .. "|r")
        end

        GameTooltip:AddLine("|cFF888888" .. (L["CLICK_LINK_QUEST"] or "Shift+Left-click: Link quest in chat") .. "|r")
        GameTooltip:AddLine("|cFF888888" .. (L["CLICK_MORE_OPTIONS"] or "Right-click: More options") .. "|r")
        GameTooltip:Show()
    end

    local function HookQuestTitleRow(row)
        if row._tweakedTitleRow then return end
        row._tweakedTitleRow = true

        row:SetScript("OnClick", function(self, button)
            local q = self.questData
            if not q then return end

            if button == "RightButton" then
                QM:ShowQuestContextMenu(self)
            elseif IsShiftKeyDown() then
                QM:LinkQuestToChat(q.id)
            else
                local opens = QM:ClickOpensQuestLog()
                local isCtrlActive = (opens == "ctrlmodifier") and IsControlKeyDown and IsControlKeyDown()
                local isAltActive  = (opens == "altmodifier")  and IsAltKeyDown     and IsAltKeyDown()

                if isCtrlActive or isAltActive then
                    QM:OpenQuestLog(q.id)
                else
                    QM:SetWaypointForQuest(q.id, true)
                    if opens == "plain" then
                        QM:OpenQuestLog(q.id)
                    end
                end
            end
        end)

        row:HookScript("OnEnter", function(self)
            RebuildTrackerTooltip(false)
        end)
    end

    local function HookObjectiveLineRow(row)
        if row._tweakedLineRow then return end
        row._tweakedLineRow = true

        row:SetScript("OnClick", function(self, button)
            if not (self.objectiveData and self.questId) then return end
            local quest = QM.activeQuests and QM.activeQuests[self.questId]

            if button == "RightButton" then
                if quest then QM:ShowQuestContextMenu({questData = quest}) end
            elseif IsShiftKeyDown() then
                QM:LinkQuestToChat(self.questId)
            else
                local opens = QM:ClickOpensQuestLog()
                local isCtrlActive = (opens == "ctrlmodifier") and IsControlKeyDown and IsControlKeyDown()
                local isAltActive  = (opens == "altmodifier")  and IsAltKeyDown     and IsAltKeyDown()

                if isCtrlActive or isAltActive then
                    QM:OpenQuestLog(self.questId)
                else
                    QM:SetWaypointForObjective(self.questId, self.objectiveData.index, true)
                    if opens == "plain" then
                        QM:OpenQuestLog(self.questId)
                    end
                end
            end
        end)

        row:HookScript("OnEnter", function(self)
            RebuildTrackerTooltip(true)
        end)
    end

    hooksecurefunc(QM, "UpdateTracker", function()

        if QM.TrackerQuestRows then
            for _, row in ipairs(QM:TrackerQuestRows()) do
                HookQuestTitleRow(row)
            end
        end

        if QM.TrackerFrame and QM.TrackerFrame.content then
            local children = { QM.TrackerFrame.content:GetChildren() }
            for _, child in ipairs(children) do
                if child.objectiveData ~= nil or child.dot ~= nil or child.bar ~= nil then
                    HookObjectiveLineRow(child)
                end
            end
        end
    end)
end