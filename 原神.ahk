; https://stackoverflow.com/questions/43298908/how-to-add-administrator-privileges-to-autohotkey-script
#SingleInstance Force
;@Ahk2Exe-UpdateManifest 1
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

;防泛濫觸發
SetKeyDelay 500

;設定取位方法
CoordMode "Pixel", "Client"
CoordMode "Mouse", "Client"

SendMode "Event"
SetTitleMatchMode "RegEx"
;設定圖標
I_Icon := "klee.ico"
If FileExist(I_Icon)
    TraySetIcon(I_Icon)

WinTitle := "ahk_exe GenshinImpact"
Global PreventCheat := false
Global ScenarioList := {Chatting:false, Login:false}
/*
    ==========================================================
    檢測
    ==========================================================
*/
;立刻檢測是否前台
CheckActive
;每5秒檢測是否前台
SetTimer CheckActive, 5000


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
    if (ChatReturn && SendIcon && SendButton)
        ScenarioList.Chatting := true
    else
        ScenarioList.Chatting := false
}

IsLogin(){
    LoginTab := IsColor(730, 300, "0xFFFFFF")
    LoginBtn := IsColor(800, 680, "0x393B40")
    if (LoginTab && LoginBtn)
        ScenarioList.Login := true
    else
        ScenarioList.Login := false
}

;當原神開啟時檢測, 每100ms
CheckENV(){
    ;聊天/登入時禁
    IsChatting
    IsLogin
}

;每5秒檢測視窗是否前台
CheckActive(){
    if WinWaitActive(WinTitle,,5){
        CheckENV
        SetTimer CheckENV, 500
        Suspend false
    }else{
        Suspend true
        SetTimer CheckENV, 0
    }
}

RandDelay(){
    RandSleep := Random(0.05, 0.15)
    Sleep RandSleep
}
/*
==========================================================
主要
==========================================================
*/
#HotIf WinActive("ahk_exe GenshinImpact.exe") && !ScenarioList.Chatting && !ScenarioList.Login
; 按Alt+N暫停所有熱鍵, 再次Alt+N啟動
    #SuspendExempt 
    ~!n::
    {
        Suspend
        ToolTip a_isSuspended ? "插件已暫停":"插件運作中"
        SetTimer CheckActive, (A_IsSuspended) == 1 ? 0 : 5000
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
    *MButton::
    {
        Loop{
            if(!GetKeyState("CapsLock", "T"))
                Click
            else{
                DllCall("mouse_event", "UInt", 0x0001, "UInt", A_ScreenWidth*10, "UInt", 0)
            }
        }Until KeyWait("MButton", "T0.2")
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
            if(PreventCheat)
                RandDelay
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
        xpos := 1303
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
    /*p::
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
    }*/

    ; 强化聖遺物(手動)
    /*F8::
    {
        SendMode "Input"
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
        
        Sleep 50
        Send "{Esc}"
        Sleep 150
        MouseMove 1600, 1000
        Sleep 200
        Click
        Sleep 50
        MouseMove 1180, 754
        Sleep 50
        Click
        Sleep 250
        MouseMove 130, 150
        Click
        Sleep 150
        MouseMove 130, 225
        Click
        Sleep 50
        MouseMove 1250, 870
        Click
        ;MouseMove, xpos, ypos
        BlockInput false
        SendMode "Event"
    }*/

    ; 强化聖遺物(自動置入)
    /*F9::
    {
        SendMode "Input"
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
        Sleep 150
        MouseMove 130, 225
        Click
        Sleep 50
        MouseMove 1650, 760
        BlockInput false
        SendMode "Event"
    }*/
    
    #MaxThreadsPerHotkey 2
    ;自動跳過劇情(1920x1080下運作)
    ;F12 啟動/取消
    F12::{
        Static on := False
        If on := !on{
            ;左上角顯示運行中
            ToolTip("Auto skip on",10,10)
            xpos := 1303
            Loop{
                ypos := 810
                choices := 0
                SendInput "f"
                sleep Random(200,500)
                color := PixelGetColor(xpos, ypos)
                If (color = 0xFFFFFF){
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
                    ypos := 810 - 74 * choices + 74 * 1
                    Click xpos, ypos
                }
            }
        } Else Reload
    }

    #MaxThreadsPerHotkey 0
    ; 點擊右下角的確定/砍樹
    Tab::
    {
        If ! KeyWait("Tab", "T0.3")
        {
            Loop
            {
                Click
            }until KeyWait("Tab", "T0.6")
        }
        else
        {
            MouseGetPos &xpos, &ypos
            Click 1650, 1000
            Sleep 50
            MouseMove xpos, ypos
        }
    }

    ~CapsLock::{
        if GetKeyState("CapsLock", "T")
            ToolTip "Capslock is on"
        else
            ToolTip "Capslock is off"
        sleep 1500
        ToolTip
    }
#HotIf
