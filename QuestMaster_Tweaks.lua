local addonName, Tweaks = ...

-- ----------------------------------------------------------------------------
-- Initialization & Event Handling
-- ----------------------------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    local QM = QuestMaster or _G["QM"]
    if not QM then return end

    local L = QM.L or {}

    -- ------------------------------------------------------------------------
    -- 1. Locales
    -- ------------------------------------------------------------------------
    local locale = GetLocale()
    if locale == "deDE" then
        L["CLICK_OPEN_QUESTLOG"]      = "Links-Klick: Im Questlog öffnen"
        L["CLICK_SET_WAYPOINT"]       = "Links-Klick: Wegpunkt setzen"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Shift+Links-Klick: Wegpunkt setzen"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Strg+Links-Klick: Im Questlog öffnen"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+Links-Klick: Im Questlog öffnen"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Links-Klick: Wegpunkt") .. " & Im Questlog öffnen"
    elseif locale == "esES" or locale == "esMX" then
        L["CLICK_OPEN_QUESTLOG"]      = "Clic izquierdo: Abrir registro de misiones"
        L["CLICK_SET_WAYPOINT"]       = "Clic izquierdo: Establecer punto de ruta"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Mayús+Clic izquierdo: Establecer punto de ruta"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+Clic izquierdo: Abrir registro de misiones"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+Clic izquierdo: Abrir registro de misiones"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Clic izquierdo: Flecha al objetivo") .. " y abrir registro"
    elseif locale == "frFR" then
        L["CLICK_OPEN_QUESTLOG"]      = "Clic gauche : Ouvrir le journal des quêtes"
        L["CLICK_SET_WAYPOINT"]       = "Clic gauche : Définir un point de passage"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Maj+Clic gauche : Définir un point de passage"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+Clic gauche : Ouvrir le journal des quêtes"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+Clic gauche : Ouvrir le journal des quêtes"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Clic gauche : Flèche vers l'objectif") .. " et ouvrir journal"
    elseif locale == "itIT" then
        L["CLICK_OPEN_QUESTLOG"]      = "Clic sinistro: Apri registro missioni"
        L["CLICK_SET_WAYPOINT"]       = "Clic sinistro: Imposta punto di passaggio"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Maiusc+Clic sinistro: Imposta punto di passaggio"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+Clic sinistro: Apri registro missioni"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+Clic sinistro: Apri registro missioni"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Clic sinistro: Freccia verso questo obiettivo") .. " e apri registro"
    elseif locale == "koKR" then
        L["CLICK_OPEN_QUESTLOG"]      = "좌클릭: 퀘스트 목록 열기"
        L["CLICK_SET_WAYPOINT"]       = "좌클릭: 목표 지점 설정"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Shift+좌클릭: 목표 지점 설정"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+좌클릭: 퀘스트 목록 열기"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+좌클릭: 퀘스트 목록 열기"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Ctrl+좌클릭: 이 목표로 화살표 설정") .. " 및 목록 열기"
    elseif locale == "ptBR" then
        L["CLICK_OPEN_QUESTLOG"]      = "Clique-esquerdo: Abrir registro de missões"
        L["CLICK_SET_WAYPOINT"]       = "Clique-esquerdo: Definir ponto de rota"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Shift+Clique-esquerdo: Definir ponto de rota"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+Clique-esquerdo: Abrir registro de missões"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+Clique-esquerdo: Abrir registro de missões"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Ctrl+Clique-esquerdo: Flecha para este objetivo") .. " e abrir registro"
    elseif locale == "ruRU" then
        L["CLICK_OPEN_QUESTLOG"]      = "Левый клик: Открыть в журнале заданий"
        L["CLICK_SET_WAYPOINT"]       = "Левый клик: Установить метку маршрута"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Shift+Левый клик: Установить метку маршрута"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+Левый клик: Открыть в журнале заданий"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+Левый клик: Открыть в журнале заданий"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Левый клик: Стрелка к цели") .. " и открыть журнал"
    elseif locale == "zhCN" then
        L["CLICK_OPEN_QUESTLOG"]      = "左键：在任务日志中打开"
        L["CLICK_SET_WAYPOINT"]       = "左键：设置路径点"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Shift+左键：设置路径点"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+左键：在任务日志中打开"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+左键：在任务日志中打开"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "左键：指向该目标的箭头") .. " 并打开任务日志"
    elseif locale == "zhTW" then
        L["CLICK_OPEN_QUESTLOG"]      = "左鍵：在任務日誌中開啟"
        L["CLICK_SET_WAYPOINT"]       = "左鍵：設定路徑點"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Shift+左鍵：設定路徑點"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+左鍵：在任務日誌中開啟"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+左鍵：在任務日誌中開啟"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "左鍵：指向該目標的箭頭") .. " 並開啟任務日誌"
    else
        L["CLICK_OPEN_QUESTLOG"]      = "Left-click: Open Quest Log"
        L["CLICK_SET_WAYPOINT"]       = "Left-click: Set waypoint"
        L["MAP_CLICK_SET_WAYPOINT"]   = "Shift+Left-click: Set waypoint"
        L["CLICK_CTRL_OPEN_QUESTLOG"] = "Ctrl+Left-click: Open Quest Log"
        L["CLICK_ALT_OPEN_QUESTLOG"]  = "Alt+Left-click: Open Quest Log"
        L["CLICK_WAYPOINT_AND_LOG"]   = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Left-click: Arrow to this objective") .. " & open quest log"
    end

    -- ------------------------------------------------------------------------
    -- 2. Override QM:ClickOpensQuestLog
    -- ------------------------------------------------------------------------
    QM.ClickOpensQuestLog = function(self)
        local mode = self.db and self.db.profile and self.db.profile.tracker and self.db.profile.tracker.openQuestLog or "ctrl"
        if mode == "click" then return "plain" end
        if mode == "ctrl"  then return "ctrlmodifier" end
        if mode == "alt"   then return "altmodifier" end
        return nil
    end

    -- ------------------------------------------------------------------------
    -- 3. Shared Tooltip Pruning & Rebuilding Helper
    -- ------------------------------------------------------------------------
    local function RebuildTrackerTooltip(isObjectiveLine)
        if not GameTooltip:IsShown() then return end

        local numLines = GameTooltip:NumLines()
        if numLines < 2 then return end

        -- Snapshot lines
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

        -- Prune stock hint instructions from bottom up
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

        -- Redraw non-hint upper portion
        GameTooltip:ClearLines()
        for i = 1, cutIndex do
            local l = lines[i]
            if l.right and l.right ~= "" then
                GameTooltip:AddDoubleLine(l.left, l.right, l.lr, l.lg, l.lb, l.rr, l.rg, l.rb)
            elseif l.left then
                GameTooltip:AddLine(l.left, l.lr, l.lg, l.lb, true)
            end
        end

        -- Append dynamic hint lines based on row type
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

    -- ------------------------------------------------------------------------
    -- 4. Hook Quest Title Rows
    -- ------------------------------------------------------------------------
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

    -- ------------------------------------------------------------------------
    -- 5. Hook Objective Line Rows
    -- ------------------------------------------------------------------------
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

    -- ------------------------------------------------------------------------
    -- 6. Hook Tracker Frame Updates (Title Override & Scanning Rows)
    -- ------------------------------------------------------------------------
    hooksecurefunc(QM, "UpdateTracker", function()
        -- Header text to "Quests"
        if QM.TrackerFrame and QM.TrackerFrame.header and QM.TrackerFrame.header.title then
            QM.TrackerFrame.header.title:SetText("|cFFFFD700Quests|r")
        end

        -- Hook active quest title rows
        if QM.TrackerQuestRows then
            for _, row in ipairs(QM:TrackerQuestRows()) do
                HookQuestTitleRow(row)
            end
        end

        -- Hook active objective line rows (children of TrackerFrame.content)
        if QM.TrackerFrame and QM.TrackerFrame.content then
            local children = { QM.TrackerFrame.content:GetChildren() }
            for _, child in ipairs(children) do
                if child.objectiveData ~= nil or child.dot ~= nil or child.bar ~= nil then
                    HookObjectiveLineRow(child)
                end
            end
        end
    end)

    -- ------------------------------------------------------------------------
    -- 7. World Map & Minimap Turn-in Pins
    -- ------------------------------------------------------------------------
    local function HookMapPin(pin)
        if pin._tweakedPin then return end
        pin._tweakedPin = true

        pin:SetScript("OnClick", function(self, button)
            if button ~= "LeftButton" or not self.pinData then return end

            local data = self.pinData
            local isTurnIn = (data.pinType == "turnin")

            -- Normal Left-Click on Turn-In: Open Quest Log
            if isTurnIn and not IsShiftKeyDown() then
                if QM.OpenQuestLog then
                    QM:OpenQuestLog(data.questId)
                end
                return
            end

            -- Shift + Left-Click on Turn-In OR normal click on others: Set Waypoint
            QM:SetWaypoint(
                data.questId,
                data.objectiveIndex or 0,
                data.x,
                data.y,
                data.mapId,
                data.description or data.title,
                true
            )

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
            GameTooltip:AddLine("|cFF888888" .. L["MAP_CLICK_SET_WAYPOINT"] .. "|r")
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

    -- Initial refreshes
    if QM.UpdateMapPins then QM:UpdateMapPins() end
    if QM.UpdateTracker then QM:UpdateTracker() end
end)