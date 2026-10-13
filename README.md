# QuestMaster [Tweaks]

A lightweight companion addon for **QuestMaster** (World of Warcraft - Forever) that refines UI interactions, fixes stock waypoint and options bugs, and provides localized tooltip enhancements without altering core addon files.

---

## Features & Bug Fixes

- **Waypoint Lock for Available Quests (!):**
  - Fixes an issue where manual waypoints placed on unaccepted quest givers were immediately reverted to the nearest active quest by the auto-waypoint tracker.
- **Native World Map Waypoint Synchronization:**
  - Setting a manual point on empty map terrain names the point "Custom Waypoint"
  - Adds an ETA to the waypoint to indicate roughly how far in time you are away from the pin
- **Options Menu Escape Key Support:**
  - Allows the options window to be closed with the escape key
- **World Map Turn-in Interaction:**
  - **Left-Click** on a turn-in pin (?) directly opens the quest in your Quest Log.
  - **Shift + Left-Click** on a turn-in pin sets a manual navigation waypoint/arrow.
  - Objective pins and quest givers retain standard left-click waypoint targeting.
- **Dynamic Tracker Tooltips & Keybinds:**
  - Dynamically updates tooltip hints based on your configured modifier preference (`ctrl`, `alt`, or `plain click`).
- **Clear a markers or waypoints:**
  - Clear markers or waypoints with a right click on the worl map, a custom keybind set through WoW's keybind interface. or running /qm cm, /qm clearmarker, /qmcm, or /clearmarker
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
   |-- Locales
   |-- Modules
   \-- README.md
   ```
4. Restart World of Warcraft
5. In your character selection screen, click **AddOns** and ensure **QuestMaster [Tweaks]** is enabled.

---

## Requirements

- **QuestMaster** (Loaded as a dependency in `.toc`).

---

## License

GNU General Public License v3.0 (GPL-3.0)
