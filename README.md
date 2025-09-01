# 📅 Thunderbird Calendar Screensaver Script

This Bash script automatically launches Thunderbird in fullscreen calendar mode on a dedicated workspace when the system is idle for a set period. It returns to your previous workspace and closes Thunderbird when activity resumes, unless you're watching fullscreen video, in which case it stays inactive.

---

## 🧠 What It Does

- ⏳ Detects **user inactivity** (e.g. mouse/keyboard idle)
- 🖥️ Switches to **Workspace 4** 
- 📆 Launches **Thunderbird** and puts it in **fullscreen**
- 👀 Monitors for **user activity or video playback**
- ❌ Closes Thunderbird and switches back when user becomes active
- 🎬 **Skips launching** if a fullscreen video is currently playing

---
## 📚 Use Cases & Examples

Here are some practical ways to use this script in real-world setups:

### 📆 1. Personal Productivity Dashboard

Use Thunderbird’s calendar to create a **self-hosted agenda screen** that appears when you're away:

- Connect to a **CalDAV calendar** (e.g. from Nextcloud or Fastmail)
- Set Thunderbird to open in **Calendar tab**
- The script shows your schedule after 5 minutes of idle time
- Used on a TV with Linux in my living room to always show my calendar

## 🎮 2. Media Center Friendly

- Worried about interference during movies?
- The script detects fullscreen video apps like VLC, MPV, Firefox
- Will not trigger calendar view while a movie or fullscreen video is active

Perfect for:

- Home theater PCs
- Hybrid media/workstations

---

## ⚙️ Configuration

These variables can be changed in the script:

- IDLE_THRESHOLD_MS=300000     # Idle time in milliseconds (default: 5 minutes)
- CALENDAR_WORKSPACE=3         # Workspace number (0-indexed, so 3 = Workspace 4)
- CHECK_INTERVAL=5             # How often to check (in seconds)
- THUNDERBIRD_CMD="thunderbird"  # Command to launch Thunderbird

## 📦 Requirements

Install these via your package manager:


<pre lang="markdown">sudo apt install xdotool xprintidle wmctrl x11-utils</pre>

🚀 How to Use

  Save the script as calendar_screensaver.sh

  Make it executable:

<pre lang="markdown">chmod +x calendar_screensaver.sh</pre>
  Run the script:
<pre lang="markdown">./calendar_screensaver.sh</pre>

You can also add it to your Startup Applications to run automatically on login.
## 📋 Behavior Summary
Condition	Action
- Idle for 5+ minutes:	Launch Thunderbird on Workspace 4 and fullscreen it
- Fullscreen video playing:	Skip activation
- User moves mouse or presses a key:	Close Thunderbird and return to original workspace

## 🎬 Fullscreen Video Detection

The script checks for fullscreen windows from known media players to avoid interrupting:

  - VLC
  - MPV
  - Firefox
  - Chromium
  - Brave
  - Kodi
  - Totem
  - MPlayer

## 📝 License

- MIT License — feel free to use, modify, and distribute
