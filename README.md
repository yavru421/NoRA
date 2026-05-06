<img width="2816" height="1536" alt="output" src="https://github.com/user-attachments/assets/20df96ba-eeb5-43e0-b353-b0702557e4d4" />


🛑 NoRA 🛑
(No Resizing Allowed)
The most banging global AHKv2 Smart Macro Recorder on GitHub.

--------------------------------------------------------------------------------
"im self taught and i literally discover shit like ahk2 and use it to automate whatever i feel like. i spent days digging through github and reddit trying to find a solid macro recorder for autohotkey v2, and honestly, almost all the shit out there is completely broken. so i built my own from scratch."
💀 Why the other recorders out there suck
If you look at the most popular v2 recorders out there (like the forks by 'raeleus' or 'ArtyMcLabin'), they are basically frankenstein code patched together from old AHK v1 scripts. They have massive bugs that people constantly complain about on Reddit and GitHub:

    The Temp File Crash: Half the time you hit record on their scripts, it instantly crashes and throws a Script file not found. C:\Users\...\AppData\Local\Temp\~Record1.ahk error. NoRA doesn't hide your data in some random temporary system folder. It drops a clean, structured SmartMacroData.ini file right next to the script.
    The InputHook Nightmare: People on Reddit literally post threads about how InputHook is too hard to understand. Older recorders capture your typing as 100 individual literal key-down and key-up events. NoRA actually uses v2's InputHook correctly. It senses your normal typing and aggregates it into full, editable sentences inside the INI file.
    V1 Migration Artifacts: The developers of the leading AHKv2 forks openly admit in their own documentation that some recorded scripts fail to execute because of "artifacts from the ahk1->ahk2 engine migration". NoRA was built natively for V2 from the ground up.
    Blind Clicking: Standard recorders click exact, absolute screen coordinates. If your target window moves even an inch, the macro clicks empty space.


--------------------------------------------------------------------------------
✨ Enter NoRA: The Upgrade
Feature
	
The Other Guys 📉
	
NoRA 🚀
Data Storage
	
Hidden Temp .ahk spaghetti code
	
Clean, editable local .ini data
Typing
	
Captures 50 lines for the word "hello"
	
Aggregates characters into Value=hello
Coordinate Mode
	
Absolute Screen (Breaks if you move a window)
	
Window relative (Move the window anywhere!)
Execution
	
Blind, static Sleep timers
	
Intelligent WinWaitActive UI sensing

--------------------------------------------------------------------------------
🚨 THE GOLDEN RULE: NO RESIZING ALLOWED 🚨
The name says it all. This script makes your macros immune to windows being moved around or covered by other apps. When you replay it, it uses WinWaitActive to intelligently sense if the program is loaded, brings it to the front, and clicks the exact right spot relative to the top-left corner of the window.
BUT... you absolutely CANNOT resize the window after you record.
Modern apps are responsive, so if you resize the window, the internal layout shifts. The script will faithfully click the exact relative coordinates you recorded, but because you resized the window, it'll probably click the wrong shit (or end up typing in a completely different text box).
Keep the window the exact same size, and it works flawlessly.

--------------------------------------------------------------------------------
🎮 How to run this shit

    Install AutoHotkey v2.
    Run the NoRA script.
    Press F2 to start recording. Click your shit and type whatever you want.
    Press F2 to stop recording.
    Press F3. This pops open the SmartMacroData.ini file in Notepad. Instead of raw spaghetti code, you'll literally just see Type=Text and Value=your sentence. You can fix any typos directly in this file without having to re-record the whole damn thing.
    Save the Notepad file.
    Press F1 to replay the smart macro. It will instantly activate the correct window and inject your text instantly instead of typing it letter by letter.
    Press F6 for the panic button. Hit it to kill the script instantly if something goes wrong.

Enjoy. And remember, no fucking resizing allowed.
