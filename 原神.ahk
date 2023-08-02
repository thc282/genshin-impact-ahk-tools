; https://stackoverflow.com/questions/43298908/how-to-add-administrator-privileges-to-autohotkey-script
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try ; leads to having the script re-launching itself as administrator
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
I_Icon = klee.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

#IfWinActive ahk_exe GenshinImpact.exe

;F1::l
;F2::o
RCtrl::LCtrl
LCtrl::MButton

; 鼠標側鍵 1 等於前進，連按兩下等於按住 w
XButton1::
    Send {w down}
    KeyWait, XButton1, T0.3
    If Not ErrorLevel
    {
        Send {w up}
        KeyWait, XButton1, D T0.2
        If Not ErrorLevel
        {
            Send {w down}
        }
    }
    Else
    {
        KeyWait, XButton1
        Send {w up}
    }
Return

; 鼠標側鍵 2 等於 F 键，按住等於按住 Alt 鍵顯示鼠標標
XButton2::
    KeyWait, XButton2, T0.2
    If ErrorLevel
    {
        Send, {LAlt down}
        KeyWait, XButton2
        Send, {LAlt up}
    }
    else
    {
        Send f
    }
Return

; 按住鼠標中鍵等於狂按左鍵（攻擊或者跳過對话）
MButton::
    Loop
    {
        Click
        KeyWait, MButton, T0.1
        If Not ErrorLevel
        {
            Break
        }
    }
Return

; 按住空格等於狂按空格（按住 1.3 秒之后才觸發，因为離開浪船需要按住空格）
~*Space::
    KeyWait, Space, T1.3
    If Not ErrorLevel
    {
        PixelGetColor, color, 700, 1020
        If (color == 0xD8E5EC)
        {
            BlockInput, MouseMove
            MouseMove, 700, 1020
            Click
            BlockInput, MouseMoveOff
            Return
        }
        PixelGetColor, color, 1130, 880
        If (color == 0x66534A)
        {
            BlockInput, MouseMove
            MouseGetPos, xpos, ypos
            MouseMove, 1130, 880
            Click
            MouseMove, %xpos%, %ypos%
            BlockInput, MouseMoveOff
            Return
        }
        Return
    }
    Loop
    {
        Send, {Space}
        KeyWait, Space, T0.05
        If Not ErrorLevel
        {
            Break
        }
    }
Return

; 按住 f 等於狂按 f
*f::
    Loop
    {
        Send, {Blind}f
        KeyWait, f, T0.1
        If Not ErrorLevel
        {
            Break
        }
    }
Return

; 點兩下 w 按住 w
~w::
    KeyWait, w, T0.3
    If Not ErrorLevel
    {
        KeyWait, w, D T0.2
        If Not ErrorLevel
        {
            KeyWait, w
            Send {w down}
        }
    }
Return

; 釋放按住的 w
~s::
    If Not GetKeyState("w", "P")
    {
        Send {w up}
    }
Return

; 隊伍切換界面左右
~a::
    PixelGetColor, color, 64, 538
    If (color == 0xD8E5EC)
    {
        BlockInput, MouseMove
        MouseMove, 64, 538
        Click
        BlockInput, MouseMoveOff
    }
Return

~d::
    PixelGetColor, color, 1853, 538
    If (color == 0xD8E5EC)
    {
        BlockInput, MouseMove
        MouseMove, 1853, 538
        Click
        BlockInput, MouseMoveOff
    }
Return

; 對話選項
Selection(n) {
    xpos := 1298
    choices := 0
    Loop, 8
    {
        ypos := 810 - 74 * choices
        PixelGetColor, color, %xpos%, %ypos%
        If (color != 0xFFFFFF)
        {
            Break
        }
        choices += 1
    }
    if (choices == 0)
    {
        Return False
    }
    ypos := 810 - 74 * choices + 74 * n
    BlockInput, MouseMove
    MouseMove, %xpos%, %ypos%
    Click
    BlockInput, MouseMoveOff
    Return True
}

~1::
    PixelGetColor, color, 64, 538
    If (color == 0xD8E5EC)
    {
        BlockInput, MouseMove
        MouseMove, 350, 490
        Click
        BlockInput, MouseMoveOff
        Return
    }
    If (Selection(1))
    {
        Return
    }
Return

~2::
    PixelGetColor, color, 64, 538
    If (color == 0xD8E5EC)
    {
        BlockInput, MouseMove
        MouseMove, 760, 490
        Click
        BlockInput, MouseMoveOff
        Return
    }
    If (Selection(2))
    {
        Return
    }
Return

~3::
    PixelGetColor, color, 64, 538
    If (color == 0xD8E5EC)
    {
        BlockInput, MouseMove
        MouseMove, 1170, 490
        Click
        BlockInput, MouseMoveOff
        Return
    }
    If (Selection(3))
    {
        Return
    }
Return

~4::
    PixelGetColor, color, 64, 538
    If (color == 0xD8E5EC)
    {
        BlockInput, MouseMove
        MouseMove, 1590, 490
        Click
        BlockInput, MouseMoveOff
        Return
    }
    If (Selection(4))
    {
        Return
    }
Return

~5::
    If (Selection(5))
    {
        Return
    }
Return

~6::
    If (Selection(6))
    {
        Return
    }
Return

~7::
    If (Selection(7))
    {
        Return
    }
Return

; 替换聖遺物
p::
    BlockInput, MouseMove
    MouseGetPos, xpos, ypos
    MouseMove, 1600, 1000
    Click
    Sleep 100
    MouseMove, 1200, 760
    Click
    Sleep 100
    MouseMove, %xpos%, %ypos%
    BlockInput, MouseMoveOff
Return

; 强化聖遺物(手動)
F8::
    BlockInput, MouseMove
    MouseGetPos, xpos, ypos
    xpos2 := xpos
    ypos2 := ypos
    Loop, 6
    {
        Click
        xpos2 += 142
        If (xpos2 > 1142)
        {
            xpos2 -= 8 * 142
            ypos2 += 168
        }
        MouseMove %xpos2%, %ypos2%
    }
    Send {Esc}
    Sleep 100
    MouseMove, 1600, 1000
    Click
    MouseMove, 1180, 754
    Click
    MouseMove, 130, 150
    Click
    MouseMove, 130, 225
    Click
    MouseMove, 1250, 870
    Click
    ;MouseMove, xpos, ypos
    BlockInput, MouseMoveOff
Return

; 强化聖遺物(自動置入)
F9::
    BlockInput, MouseMove
    MouseMove, 1650, 760
    Click
    MouseMove, 1600, 1000
    Click
    MouseMove, 1180, 754
    Click
    MouseMove, 130, 150
    Click
    MouseMove, 130, 225
    Click
    BlockInput, MouseMoveOff
Return

; 點擊右下角的確定/砍樹
Tab::
    KeyWait, Tab, T0.3
    If ErrorLevel
    {
        Loop
        {
            Click
            KeyWait, Tab, T0.6
            If Not ErrorLevel
            {
                Break
            }
        }
    }
    else
    {
        BlockInput, MouseMove
        MouseGetPos, xpos, ypos
        MouseMove, 1650, 1000
        Click
        MouseMove, %xpos%, %ypos%
        BlockInput, MouseMoveOff
    }
Return

; 5個探索派遣
;x1, y1 為地區座標
;x2, y2 為派遣座標
;x3, y3 為人物座標
Expedition(x1, y1, x2, y2, x3, y3) {
    BlockInput, MouseMove
    ;選擇地區
    MouseMove, x1, y1
    Sleep 50
    Click
    ;選擇派遣位置
    MouseMove, x2, y2
    Sleep 50
    Click
    ;領取獎勵(勿動)
    MouseMove, 1650, 1000
    Click
    ;退出獎勵介面
    Sleep 250
    Click
    ;再次按派遣按鈕
    Sleep 250
    Click
    ;選擇人物
    MouseMove, x3, y3
    Sleep 50
    Click
    BlockInput, MouseMoveOff
}

;x1, y1 為地區座標
;x2, y2 為派遣座標
;x3, y3 為人物座標
;Expedition(x1, y1, x2, y2, x3, y3)
F10::
    ; 蒙德
    Expedition(150, 165, 1063, 333, 300, 150)
    ; 璃月
    Expedition(150, 230, 810, 560, 300, 260)
    Expedition(150, 230, 560, 560, 300, 370)
    ; 稻妻
    Expedition(150, 300, 1100, 280, 300, 260)
    ;須彌
    Expedition(150, 380, 1030, 610, 300, 150)
Return
