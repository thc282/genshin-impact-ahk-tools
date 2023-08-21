; https://stackoverflow.com/questions/43298908/how-to-add-administrator-privileges-to-autohotkey-script
#SingleInstance Force
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
  try
  {
    if A_IsCompiled
      Run '*RunAs "' A_ScriptFullPath '" /restart'
    else
      Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
  }
  ExitApp
}

;設定取位方法
CoordMode "Pixel", "Client"
CoordMode "Mouse", "Client"

SendMode "Event"

;設定圖標
I_Icon := "klee.ico"
If FileExist(I_Icon)
    TraySetIcon(I_Icon)

/*
    ==========================================================
    模組(勿碰)
    ==========================================================
*/
IsColor(x,y,color_code){
    return PixelGetColor(x,y) == color_code ? true : false
}

IsChatting(){
    ChatReturn := IsColor(35, 60, "0xECE5D8")
    SendIcon := IsColor(985, 1010, "0x313131")
    SendButton := IsColor(1030, 1010, "0xECE5D8")
    return (ChatReturn && SendIcon && SendButton) ? true : false
}
/*
    ==========================================================
    主要
    ==========================================================
*/
#HotIf WinActive("ahk_exe GenshinImpact.exe")
    ; 按Alt+N暫停所有熱鍵, 再次Alt+N啟動
    #SuspendExempt 
    ~!n::
    {
        Suspend
        ToolTip a_isSuspended ? "插件已暫停":"插件運作中"
        Sleep 3000
        ToolTip
    }
    #SuspendExempt false

    ;以下是熱鍵設定
    ;F1::l
    ;F2::o
    ;RCtrl::LCtrl
    *`::Tab
    ~#`::Send "#``"

    ;當原神開啟時檢測
    SetTitleMatchMode "RegEx"
    Loop {
        WinWaitActive("ahk_exe GenshinImpact")
        ;聊天時禁
        if IsChatting(){
            Suspend 1
        }else{
            Suspend 0
        }
        Sleep 100
    }

    ; 鼠標側鍵 1 等於前進，連按兩下等於按住 w
    XButton1::
    {
        Send "{w down}"
        If KeyWait("XButton1", "T0.3")
        {
            Send "{w up}"
            If KeyWait("XButton1", "D T0.2")
            {
                Send "{w down}"
            }
        }
        Else
        {
            KeyWait "XButton1"
            Send "{w up}"
        }
    }
    Return

    ; 鼠標側鍵 2 等於 F 键，按住等於按住 Alt 鍵顯示鼠標標
    XButton2::
    {
        
        If KeyWait("XButton2", "T0.2")
        {
            Send "{LAlt down}"
            KeyWait "XButton2"
            Send "{LAlt up}"
        }
        else
        {
            Send "f"
        }
    }

    ; 按住鼠標中鍵等於狂按左鍵（攻擊或者跳過對话）
    MButton::
    {
        Loop
        {
            Click
            If KeyWait("MButton", "T0.2")
            {
                Break
            }
        }
    }

    ; 按住空格等於狂按空格（按住 1.3 秒之后才觸發，因為離開浪船需要按住空格）
    ~*Space::
    {
        If KeyWait("Space", "T1.3")
        {
            color := PixelGetColor(700, 1020)
            ;換角色
            If (color == 0xECE5D8)
            {
                BlockInput true
                Click 700, 1020
                BlockInput false
                Return
            }

            color := PixelGetColor(1130, 880)
            If (color == 0x4A5366)
            {
                BlockInput true
                MouseGetPos &xpos, &ypos
                Click 1130, 880
                MouseMove xpos, ypos
                BlockInput false
                Return
            }
            Return
        }
        /*Loop
        {
            Send "{Space}"
            If KeyWait("Space", "T0.05")
            {
                Break
            }
        }*/
    }

    ; 按住 f 等於狂按 f
    *f::
    {
        Loop
        {
            SendInput "f"
        }Until KeyWait("f", "T0.05")
    }

    ; 點兩下 h 自動4秒元素視野/長按則手動元素視野
    ~h::
    {
        if KeyWait("h", "T0.3")
        {
            ;雙擊了
            if KeyWait("h", "D T0.2")
            {
                Send "{MButton Down}"
                ;每1000為1秒 //可自行改動
                Sleep 4000
                Send "{MButton Up}"
            }
            else
            {
                ;單擊了
                ;回正視角
                Send "{MButton}"
            }
        }else{
            ;手動元素視野
            Send "{MButton down}"
            KeyWait("h")
            Send "{MButton Up}"
        }

    }

    ; 點兩下 w 按住 w
    ~w::
    {
        If KeyWait("w", "T0.3")
        {
            If KeyWait("w", "D T0.2")
            {
                KeyWait "w"
                Send "{w down}"
            }
        }
    }

    ; 釋放按住的 w
    ~s::
    {
        If ! GetKeyState("w", "P")
        {
            Send "{w up}"
        }
    }

    ; 隊伍切換界面左右
    ~a::
    {
        color := PixelGetColor(64, 538)
        If (color == 0xECE5D8)
        {
            KeyWait "a"
            BlockInput true
            Click 64, 538
            BlockInput false
        }
    }

    ~d::
    {
        color := PixelGetColor(1853, 538)
        If (color == 0xECE5D8)
            {
            KeyWait "d"
            BlockInput true
            Click 1853, 538
            BlockInput false
        }
    }

    ; 對話選項
    Selection(n) {
        xpos := 1298
        choices := 0
        Loop 8
        {
            ypos := 810 - 74 * choices
            color := PixelGetColor(xpos, ypos)
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
        BlockInput true
        MouseMove xpos, ypos
        Click
        BlockInput false
        Return True
    }

    ~1::
    {
        color := PixelGetColor(64, 538)
        If (color == 0xECE5D8)
        {
            BlockInput true
            MouseMove 350, 490
            Click
            BlockInput false
            Return
        }
        If (Selection(1))
        {
            Return
        }
    }

    ~2::
    {
        color := PixelGetColor(64, 538)
        If (color == 0xECE5D8)
        {
            BlockInput true
            MouseMove 760, 490
            Click
            BlockInput false
            Return
        }
        If (Selection(2))
        {
            Return
        }
    }

    ~3::
    {
        color := PixelGetColor(64, 538)
        If (color == 0xECE5D8)
        {
            BlockInput true
            MouseMove 1170, 490
            Click
            BlockInput false
            Return
        }
        If (Selection(3))
        {
            Return
        }
    }
        
    ~4::
    {
        color := PixelGetColor(64, 538)
        If (color == 0xECE5D8)
        {
            BlockInput true
            MouseMove 1590, 490
            Click
            BlockInput false
            Return
        }
        If (Selection(4))
        {
            Return
        }
    }

    ~5::
    {
        If (Selection(5))
        {
            Return
        }
    }

    ~6::
    {
        If (Selection(6))
        {
            Return
        }
    }

    ~7::
    {
        If (Selection(7))
        {
            Return
        }
    }

    ; 替换聖遺物
    p::
    {
        BlockInput true
        MouseGetPos &xpos, &ypos
        MouseMove 1600, 1000
        Click
        Sleep 100
        MouseMove 1200, 760
        Click
        Sleep 100
        MouseMove xpos, ypos
        BlockInput false
    }

    ; 强化聖遺物(手動)
    F8::
    {
        BlockInput true
        MouseGetPos &xpos, &ypos
        xpos2 := xpos
        ypos2 := ypos
        Loop 6
        {
            Click
            Sleep 50
            xpos2 += 142
            If (xpos2 > 1142)
            {
                xpos2 -= 8 * 142
                ypos2 += 168
            }
            MouseMove xpos2, ypos2
        }
        Send "{Esc}"
        Sleep 100
        MouseMove 1600, 1000
        Click
        Sleep 50
        MouseMove 1180, 754
        Click
        Sleep 50
        MouseMove 130, 150
        Click
        Sleep 50
        MouseMove 130, 225
        Click
        Sleep 50
        MouseMove 1250, 870
        Click
        ;MouseMove, xpos, ypos
        BlockInput false
    }

    ; 强化聖遺物(自動置入)
    F9::
    {
        BlockInput true
        MouseMove 1650, 760
        Click
        Sleep 50
        MouseMove 1600, 1000
        Click
        Sleep 50
        MouseMove 1180, 754
        Click
        Sleep 50
        MouseMove 130, 150
        Click
        Sleep 50
        MouseMove 130, 225
        Click
        Sleep 50
        MouseMove 1650, 760
        BlockInput false
    }

    ; 點擊右下角的確定/砍樹
    Tab::
    {
        If ! KeyWait("Tab", "T0.3")
        {
            Loop
            {
                Click
                If KeyWait("Tab", "T0.6")
                {
                    Break
                }
            }
        }
        else
        {
            MouseGetPos &xpos, &ypos
            Click 1650, 1000
            Sleep 50
            MouseMove xpos, ypos
        }
    }

    ; 5個探索派遣
    ; x1, y1 為地區座標
    ; x2, y2 為派遣座標
    ; x3, y3 為人物座標
    Expedition(x1, y1, x2, y2, x3, y3) {
        BlockInput true
        ;選擇地區
        Click x1, y1
        Sleep 50
        ;選擇派遣位置
        Click x2, y2
        Sleep 50
        ;領取獎勵(勿動)
        Click 1650, 1000
        Sleep 150
        ;退出獎勵介面
        Click
        Sleep 200
        ;再次按派遣按鈕
        Click
        Sleep 150
        ;選擇人物
        Click x3, y3
        Sleep 200
        BlockInput false
    }

    ; x1, y1 為地區座標
    ; x2, y2 為派遣座標
    ; x3, y3 為人物座標
    ; Expedition(x1, y1, x2, y2, x3, y3)
    F10::
    {
        ; 蒙德
        Expedition(150, 165, 1050, 330, 300, 150)
        ; 璃月
        Expedition(150, 230, 810, 560, 300, 260)
        Expedition(150, 230, 560, 560, 300, 370)
        ; 稻妻
        Expedition(150, 300, 1100, 280, 300, 260)
        ; 須彌
        Expedition(150, 380, 1030, 610, 300, 150)
    }
#HotIf
