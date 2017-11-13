#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
TCPStartup()

HotKeySet("{Esc}", "_Close")

$ip = @IPAddress1;could be your "real" ip address (whatismyip.com). you will need to port forward if you have a router
$port = 29200

$connect = TCPConnect($ip, $port)
If @error Then
    ToolTip("could not connect to " & $ip)
    Sleep(1000)
    _Close()
EndIf

$data = "0C 00 51 66 65 47 62 61 FF 0C AC 40 "

TCPSend($connect, $data)

Sleep(3000)
_Close()

Func _Close()
    TCPShutdown()
    Exit
EndFunc