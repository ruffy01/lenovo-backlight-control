; Ligius (2017) - try to make the Thinkpad keyboard backlight behave more like a normal one
global START_WITH_BACKLIGHT := 1 ; set to 1 if you want backlight on startup, 0 otherwise
global BACKLIGHT_LEVEL := 1 ; set to 0 for no backlight, 1 for the first (dim level), 2 for the brightest level
global IDLE_DURATION := 15000 ; after how many milliseconds of inactivity the light should turn off
global POLLING_PERIOD := 1000 ; how often (ms) should the program check for inactivity; lower turns backlight on faster but drains cpu

global wasOn := 0
setBacklight(START_WITH_BACKLIGHT ? BACKLIGHT_LEVEL : 0)  ; if "START_WITH_BACKLIGHT" is "true" than (?) setBacklight = BACKLIGHT_LEVEL else setBacklight = 0 

; https://autohotkey.com/board/topic/94002-send-escape-key-after-idle-time/
#SingleInstance Force
#Persistent
SetTimer, Check, % POLLING_PERIOD         ;set the timer to POLLING_PERIOD
return

; timer check
Check:
If (A_TimeIdle>=IDLE_DURATION)
{
  setBacklight(0)
  ; SetTimer, Check, Off  ; for testing purposes
}
else
{
  setBacklight(1)
}
return

; set backlight on or off
setBacklight(isOn)
{
  ; do not call backlight program if level is already set
  if (wasOn != isOn){
    wasOn := isOn
    level := isOn ? BACKLIGHT_LEVEL : 0
    Run, thinkpadlightv02.exe "c:\Users\All Users\Lenovo\ImController\Plugins\ThinkKeyboardPlugin\x86\Keyboard_Core.dll" %level% , , Hide
  }
}

; ------------------Ruffy, 2018-06-10, Script to toggle and set BACKLIGHT_LEVEL 

^Space:: 							; hotkey "Ctrl + Space" to toggle global var "BACKLIGHT_LEVEL" between 0; 1; 2
if (BACKLIGHT_LEVEL = 0){ 					; if (BACKLIGHT_LEVEL is "2") 
    BACKLIGHT_LEVEL := 2					; then set "BACKLIGHT_LEVEL" to "0"
    wasOn := isOn    						; turn OFF immediately by writing BACKLIGHT_LEVEL to Keyboard_Core.dll
    level := isOn ? BACKLIGHT_LEVEL : 0
    Run, thinkpadlightv02.exe "C:\ProgramData\Lenovo\ImController\Plugins\ThinkKeyboardPlugin\x86\Keyboard_Core.dll" %level% , , Hide
    } 						
else 								; else ..
    {BACKLIGHT_LEVEL := BACKLIGHT_LEVEL - 1 			; add integer "1" to "BACKLIGHT_LEVEL"
    wasOn := isOn						; and turn ON immediately by writing BACKLIGHT_LEVEL to Keyboard_Core.dll
    level := isOn ? BACKLIGHT_LEVEL : 0
    Run, thinkpadlightv02.exe "C:\ProgramData\Lenovo\ImController\Plugins\ThinkKeyboardPlugin\x86\Keyboard_Core.dll" %level% , , Hide
    } 
;  msgbox, 0, , Backlight is set to %BACKLIGHT_LEVEL%, 1 	; shows value of "BACKLIGHT_LEVEL" in msgbox, timeout 1 sec, for setup und trouble shooting
  return
 
; ------------------Ruffy, 2018-06-10, Script to toggle and set BACKLIGHT_LEVEL
