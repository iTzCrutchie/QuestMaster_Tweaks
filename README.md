# QuestMaster [Tweaks]

A lightweight companion addon for **QuestMaster** (World of Warcraft) that refines UI interactions, fixes stock waypoint and options bugs, and provides localized tooltip enhancements without altering core addon files.

---

## Features & Bug Fixes

- **Waypoint Lock for Available Quests (!):**
  - Fixes an upstream issue where manual waypoints placed on unaccepted quest givers were immediately purged and reverted to the nearest active quest by the auto-waypoint tracker.
- **Native World Map Waypoint Synchronization:**
  - Setting a manual point on empty map terrain cleanly releases QuestMaster's internal quest lock and names the point "Custom Waypoint", preventing the arrow from fighting Blizzard's user pin.
  - Clicking an available quest pin (!) retains the actual quest name on the waypoint rather than falling back to "Custom Waypoint".
- **Options Menu Escape Key Support:**
  - Registers `QuestMasterSettings` into Blizzard's `UISpecialFrames` so the options window closes when pressing the `Escape` key.
- **World Map Turn-in Interaction:**
  - **Left-Click** on a turn-in pin (?) directly opens the quest in your Quest Log.
  - **Shift + Left-Click** on a turn-in pin sets a manual navigation waypoint/arrow.
  - Objective pins and quest givers retain standard left-click waypoint targeting.
- **Dynamic Tracker Tooltips & Keybinds:**
  - Replaces default instructions on both **Quest Title Cards** and individual **Objective Line Rows** with clean, non-duplicated hints.
  - Dynamically updates tooltip hints based on your configured modifier preference (`ctrl`, `alt`, or `plain click`).
- **Comprehensive Localization:**
  - Full translations for `enUS`, `deDE`, `esES`/`esMX`, `frFR`, `itIT`, `koKR`, `ptBR`, `ruRU`, `zhCN`, and `zhTW`.

---

## Click Bindings Overview

### Quest Tracker (Titles & Objectives)

| Action | Control |
| :--- | :--- |
| **Open Quest Log** | `Ctrl + Left-Click` (or configured modifier) |
| **Set Waypoint / Arrow** | `Left-Click` (or configured modifier) |
| **Link Quest to Chat** | `Shift + Left-Click` |
| **Context Menu** | `Right-Click` |

### World Map & Minimap (Turn-in Pins ?)

| Action | Control |
| :--- | :--- |
| **Open in Quest Log** | `Left-Click` |
| **Set Waypoint / Arrow** | `Shift + Left-Click` |

### World Map & Minimap (Available Quests ! & Objectives)

| Action | Control |
| :--- | :--- |
| **Set Locked Waypoint / Arrow** | `Left-Click` |

---

## Installation

1. Download or clone this repository.
2. Place the `QuestMaster_Tweaks` folder inside your World of Warcraft AddOns directory:
   ```text
   World of Warcraft\_classic_\Interface\AddOns\QuestMaster_Tweaks
   ```
   *(Or `_retail_`, `_classic_era_`, depending on your client version).*
3. Ensure the folder contents include:
   ```text
   QuestMaster_Tweaks/
   |-- QuestMaster_Tweaks.toc
   |-- QuestMaster_Tweaks.lua
   \-- README.md
   ```
4. Restart World of Warcraft completely so the client detects the `.toc` file.
5. In your character selection screen, click **AddOns** and ensure **QuestMaster [Tweaks]** is enabled.

---

## Requirements

- **QuestMaster** (Loaded as a hard dependency in `.toc`).

---

## License

GNU General Public License v3.0 (GPL-3.0)
