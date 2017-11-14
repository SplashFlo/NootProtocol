#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
TCPStartup()

HotKeySet("{Esc}", "_Close")

$ip = @IPAddress1;try $IPAddress2/3/4 if this doesn't work
$port = 29200
$listen = TCPListen($ip, $port)

While 1
    $accept = TCPAccept($listen)
    If $accept <> -1 Then
		MsgBox(0, "IP", $ip)
        MsgBox(0, "hi", $accept & " has conncected")
        ExitLoop
    EndIf
WEnd

While 1
    $recv = TCPRecv($accept, 1024)
    If @error Then;connection lost
        MsgBox(0, "hi", "lost connection between " & $accept)
    EndIf
    If $recv <> "" Then;if received something
        MsgBox(0, "hi", "received this: " & $recv)
    EndIf
WEnd

Func _Close()
    TCPShutdown()
    Exit
EndFunc