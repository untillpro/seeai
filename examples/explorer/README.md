# Windows 11 Desktop Clone

A web-based Windows 11 desktop simulator with working apps. Built with SeeAI in like 3 prompts.

## What is this?

A single HTML file that recreates the Windows 11 desktop experience. Double-click icons to open working mini-apps:

- Microsoft Word (basic text editor with formatting)
- Paint (drawing canvas with colors and tools)
- Calculator (actually does math)
- Chrome (browser with working iframe navigation - most sites block iframe embedding, but Wikipedia works)

Plus draggable/resizable windows, a taskbar with a clock, and that nice Windows 11 gradient wallpaper.

![desktop](desktop.png)

## How to run

Just open `desktop.html` in your browser. That's it.

## How it was built

Used SeeAI to go from idea to working code:

- Started with a simple spec in [desktop.md](desktop.md)
- Ran `/seeai:design` -> got [desktop-design.md](desktop-design.md) (full architecture, flows, the works)
- Two rounds of vibecoding to implement and polish
- Done

The whole thing is ~1100 lines of HTML/CSS/JS in one file. No frameworks, no build tools, no dependencies.
