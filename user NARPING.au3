#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
TCPStartup()

HotKeySet("{Esc}", "_Close")

$ip = @IPAddress1
$port = 29200

$connect = UDPBind($ip, $port)
If @error Then
    ToolTip("could not connect to " & $ip)
    Sleep(1000)
    _Close()
EndIf

$data = $ip

UDPSend($connect, $data)

Sleep(3000)
_Close()

Func _Close()
    TCPShutdown()
    Exit
EndFunc