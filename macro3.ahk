#Requires AutoHotkey v2.0
#SingleInstance Force
CoordMode "Mouse", "Window"

global IsRecording := false
global MacroSteps := []
global LButtonDown := false
global MacroFile := A_ScriptDir "\SmartMacroData.ini"

; 1. SET UP THE KEYBOARD HOOK
global ih := InputHook("V")
ih.KeyOpt("{All}", "N")
ih.OnKeyDown := RecordKeyDown

; ==========================================
; HOTKEYS
; ==========================================

; F2: Start / Stop Recording
F2:: {
    global IsRecording, MacroSteps, ih, LButtonDown
    IsRecording := !IsRecording

    if (IsRecording) {
        MacroSteps := [] ; Clear the memory buffer
        LButtonDown := false
        ih.Start()       
        SetTimer RecordMouse, 10 ; High-speed poll for mouse clicks
        ToolTip "🔴 SMART RECORDING... Press F2 to stop."
    } else {
        ih.Stop()
        SetTimer RecordMouse, 0
        SaveSmartMacro()  ; Translate memory into structured INI/JSON-like data
        ToolTip "✅ Saved! F3 to Edit, F1 to Play."
        SetTimer () => ToolTip(), -4000
    }
}

; F3: Edit the Data File
F3:: {
    if FileExist(MacroFile)
        Run "notepad.exe `"" MacroFile "`""
    else
        MsgBox "No macro recorded yet! Press F2 to record."
}

; F1: Replay the Smart Macro
F1:: {
    if !FileExist(MacroFile) {
        MsgBox "No data file found!"
        return
    }
    
    ToolTip "▶️ Executing Smart Macro..."
    
    ; Parse the structured data file
    sections := IniRead(MacroFile)
    for section in StrSplit(sections, "`n") {
        if (section == "")
            continue
            
        type := IniRead(MacroFile, section, "Type", "Unknown")
        
        ; INTELLIGENT CLICK SENSING
        if (type == "Click") {
            x := IniRead(MacroFile, section, "X")
            y := IniRead(MacroFile, section, "Y")
            exe := IniRead(MacroFile, section, "Exe")
            targetWin := "ahk_exe " exe
            
            ; Sense if the window exists, wait for it, and activate it
            if !WinExist(targetWin) {
                ToolTip "Waiting for " exe " to load..."
                WinWait(targetWin, , 5) ; dynamic wait up to 5 seconds
            }
            if WinExist(targetWin) {
                WinActivate(targetWin)
                WinWaitActive(targetWin)
                Click(x " " y)
                Sleep 250
            }
            
        ; BULK TEXT INJECTION
        } else if (type == "Text") {
            val := IniRead(MacroFile, section, "Value")
            Send("{Text}" val)
            Sleep 100
            
        ; INDIVIDUAL CONTROL KEYS (Enter, Backspace, etc)
        } else if (type == "Key") {
            val := IniRead(MacroFile, section, "Value")
            Send("{" val "}")
            Sleep 100
        }
    }
    
    ToolTip "✨ Replay Complete!"
    SetTimer () => ToolTip(), -2000
}

; F6: Panic Button
F6::ExitApp

; ==========================================
; SMART RECORDING ENGINE
; ==========================================

; Only record exact Mouse Clicks (ignores endless mouse movements)
RecordMouse() {
    global LButtonDown, MacroSteps
    isDown := GetKeyState("LButton", "P")
    
    if (isDown and !LButtonDown) {
        LButtonDown := true
        MouseGetPos &x, &y, &winHwnd
        if (winHwnd) {
            exe := "Unknown"
            try exe := WinGetProcessName(winHwnd)
            MacroSteps.Push(Map("Type", "Click", "X", x, "Y", y, "Exe", exe))
        }
    } else if (!isDown and LButtonDown) {
        LButtonDown := false
    }
}

RecordKeyDown(ih, vk, sc) {
    global MacroSteps
    key := GetKeyName(Format("vk{:x}sc{:x}", vk, sc))
    if (key != "F2")
        MacroSteps.Push(Map("Type", "Key", "Value", key))
}

; ==========================================
; DATA GENERATION (Text Aggregation)
; ==========================================

SaveSmartMacro() {
    global MacroSteps, MacroFile
    if FileExist(MacroFile)
        FileDelete MacroFile

    stepCount := 1
    textBuffer := ""

    ; Helper function to dump aggregated text into a single bulk action
    FlushText() {
        if (textBuffer != "") {
            FileAppend "[Step_" stepCount "]`nType=Text`nValue=" textBuffer "`n`n", MacroFile
            stepCount++
            textBuffer := ""
        }
    }

    ; Loop through recorded memory and build the structured file
    for step in MacroSteps {
        if (step["Type"] == "Key") {
            key := step["Value"]
            ; Aggregate standard typing characters
            if (StrLen(key) == 1) {
                textBuffer .= key
            } else if (key == "Space") {
                textBuffer .= " "
            } else {
                FlushText() ; Push the text sentence before hitting a control key
                FileAppend "[Step_" stepCount "]`nType=Key`nValue=" key "`n`n", MacroFile
                stepCount++
            }
        } else if (step["Type"] == "Click") {
            FlushText() ; Push any pending text before clicking
            FileAppend "[Step_" stepCount "]`nType=Click`nX=" step["X"] "`nY=" step["Y"] "`nExe=" step["Exe"] "`n`n", MacroFile
            stepCount++
        }
    }
    FlushText() ; Catch any remaining text at the end
}
