local addonName, Tweaks = ...
Tweaks.Locales = {}

-- Global Keybinding Strings (must be set in global scope on load)
_G["BINDING_HEADER_QMTWEAKS"] = "QuestMaster [Tweaks]"
_G["BINDING_NAME_QMTWEAKS_CLEAR_WAYPOINT"] = "Clear Current Waypoint / Marker"

function Tweaks.Locales:Load(QM)
    local L = QM.L or {}
    local locale = GetLocale()

    if locale == "deDE" then
        L["CLICK_OPEN_QUESTLOG"]       = "Links-Klick: Im Questlog öffnen"
        L["CLICK_SET_WAYPOINT"]        = "Links-Klick: Wegpunkt setzen"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Shift+Links-Klick: Wegpunkt setzen"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Strg+Links-Klick: Im Questlog öffnen"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+Links-Klick: Im Questlog öffnen"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Links-Klick: Wegpunkt") .. " & Im Questlog öffnen"
    elseif locale == "esES" or locale == "esMX" then
        L["CLICK_OPEN_QUESTLOG"]       = "Clic izquierdo: Abrir registro de misiones"
        L["CLICK_SET_WAYPOINT"]        = "Clic izquierdo: Establecer punto de ruta"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Mayús+Clic izquierdo: Establecer punto de ruta"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+Clic izquierdo: Abrir registro de misiones"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+Clic izquierdo: Abrir registro de misiones"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Clic izquierdo: Flecha al objetivo") .. " y abrir registro"
    elseif locale == "frFR" then
        L["CLICK_OPEN_QUESTLOG"]       = "Clic gauche : Ouvrir le journal des quêtes"
        L["CLICK_SET_WAYPOINT"]        = "Clic gauche : Définir un point de passage"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Maj+Clic gauche : Définir un point de passage"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+Clic gauche : Ouvrir le journal des quêtes"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+Clic gauche : Ouvrir le journal des quêtes"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Clic gauche : Flèche vers l'objectif") .. " et ouvrir journal"
    elseif locale == "itIT" then
        L["CLICK_OPEN_QUESTLOG"]       = "Clic sinistro: Apri registro missioni"
        L["CLICK_SET_WAYPOINT"]        = "Clic sinistro: Imposta punto di passaggio"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Maiusc+Clic sinistro: Imposta punto di passaggio"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+Clic sinistro: Apri registro missioni"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+Clic sinistro: Apri registro missioni"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Clic sinistro: Freccia verso questo obiettivo") .. " e apri registro"
    elseif locale == "koKR" then
        L["CLICK_OPEN_QUESTLOG"]       = "좌클릭: 퀘스트 목록 열기"
        L["CLICK_SET_WAYPOINT"]        = "좌클릭: 목표 지점 설정"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Shift+좌클릭: 목표 지점 설정"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+좌클릭: 퀘스트 목록 열기"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+좌클릭: 퀘스트 목록 열기"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Ctrl+좌클릭: 이 목표로 화살표 설정") .. " 및 목록 열기"
    elseif locale == "ptBR" then
        L["CLICK_OPEN_QUESTLOG"]       = "Clique-esquerdo: Abrir registro de missões"
        L["CLICK_SET_WAYPOINT"]        = "Clique-esquerdo: Definir ponto de rota"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Shift+Clique-esquerdo: Definir ponto de rota"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+Clique-esquerdo: Abrir registro de missões"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+Clique-esquerdo: Abrir registro de missões"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Ctrl+Clique-esquerdo: Flecha para este objetivo") .. " e abrir registro"
    elseif locale == "ruRU" then
        L["CLICK_OPEN_QUESTLOG"]       = "Левый клик: Открыть в журнале заданий"
        L["CLICK_SET_WAYPOINT"]        = "Левый клик: Установить метку маршрута"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Shift+Левый клик: Установить метку маршрута"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+Левый клик: Открыть в журнале заданий"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+Левый клик: Открыть в журнале заданий"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Левый клик: Стрелка к цели") .. " и открыть журнал"
    elseif locale == "zhCN" then
        L["CLICK_OPEN_QUESTLOG"]       = "左键：在任务日志中打开"
        L["CLICK_SET_WAYPOINT"]        = "左键：设置路径点"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Shift+左键：设置路径点"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+左键：在任务日志中打开"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+左键：在任务日志中打开"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "左键：指向该目标的箭头") .. " 并打开任务日志"
    elseif locale == "zhTW" then
        L["CLICK_OPEN_QUESTLOG"]       = "左鍵：在任務日誌中開啟"
        L["CLICK_SET_WAYPOINT"]        = "左鍵：設定路徑點"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Shift+左鍵：設定路徑點"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+左鍵：在任務日誌中開啟"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+左鍵：在任務日誌中開啟"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "左鍵：指向該目標的箭頭") .. " 並開啟任務日誌"
    else
        L["CLICK_OPEN_QUESTLOG"]       = "Left-click: Open Quest Log"
        L["CLICK_SET_WAYPOINT"]        = "Left-click: Set waypoint"
        L["MAP_CLICK_SET_WAYPOINT"]    = "Shift+Left-click: Set waypoint"
        L["CLICK_CTRL_OPEN_QUESTLOG"]  = "Ctrl+Left-click: Open Quest Log"
        L["CLICK_ALT_OPEN_QUESTLOG"]   = "Alt+Left-click: Open Quest Log"
        L["CLICK_WAYPOINT_AND_LOG"]    = (L["CLICK_OBJECTIVE_WAYPOINT"] or "Left-click: Arrow to this objective") .. " & open quest log"
    end
end