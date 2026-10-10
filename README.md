# QuestMaster [Tweaks]

A lightweight companion addon for QuestMaster (World of Warcraft) that applies quality-of-life UI changes, refined click-interactions, and localized tooltips without modifying core addon files.

Because this is packaged as an independent companion addon, your customizations remain intact whenever the upstream QuestMaster addon is updated.

---

## Features

- World Map Turn-in Interaction:
  - Left-Click on a turn-in pin (?) directly opens the quest in your Quest Log instead of setting a waypoint.
  - Shift + Left-Click on a turn-in pin sets a manual navigation waypoint/arrow.
  - Objective and pickup pins retain standard left-click waypoint targeting.
- Tracker Title Override:
  - Automatically overrides the QuestMaster tracker header title from "QuestMaster" to "Quests".
- Dynamic Tracker Tooltips & Keybinds:
  - Strips stock instructions from the bottom of tracker tooltips and replaces them with clean, localized bindings.
  - Supports separate tooltip hints and click handling for both the Quest Title/Card and individual Objective Line Rows.
  - Dynamically updates tooltip hints based on your configured modifier preference (ctrl, alt, or plain click).
- Full Localization Support:
  - Includes localization strings for enUS, deDE, esES/esMX, frFR, itIT, koKR, ptBR, ruRU, zhCN, and zhTW.

---

## Click Bindings Overview

### Quest Tracker (Titles & Objectives)

Action: Open Quest Log
Control: Ctrl + Left-Click (or configured modifier)

Action: Set Waypoint / Arrow
Control: Left-Click (or configured modifier)

Action: Link Quest to Chat
Control: Shift + Left-Click

Action: Context Menu
Control: Right-Click

### World Map & Minimap (Turn-in Pins)

Action: Open in Quest Log
Control: Left-Click

Action: Set Waypoint / Arrow
Control: Shift + Left-Click

---

## Installation

1. Download or clone this repository.
2. Place the QuestMaster_Tweaks folder inside your World of Warcraft AddOns directory:
   World of Warcraft\_retail_\Interface\AddOns\QuestMaster_Tweaks
   (Or _classic_, _classic_era_, depending on your client version).
3. Ensure the folder contents look like this:
   QuestMaster_Tweaks/
   |-- QuestMaster_Tweaks.toc
   |-- QuestMaster_Tweaks.lua
   \-- README.md
4. Completely exit and restart World of Warcraft.
5. In your character selection screen, click AddOns and ensure QuestMaster [Tweaks] is enabled.

---

## Requirements

- QuestMaster (Loaded as a hard dependency in .toc).

---

## License

GPL-3.0 license