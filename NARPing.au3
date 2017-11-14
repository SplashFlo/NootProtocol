#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
UDPStartup()

HotKeySet("{Esc}", "_Close")

$ip = @IPAddress1
$port = 29200
$aSocket = ""

While 1
    $aData = UDPRecv($port, 64, 2)
		If $aData <> "" Then

			Global $aClientArray[4] = [$aSocket[0], $aSocket[1], $aData[1], $aData[2]] ;Erstelle ein Array mit den Daten die benötigt werden, um den Client etwas zurück zu senden
			UDPSend($aClientArray, @IPAddress1 & $port)
			_Close()
		Else
			Sleep(20)
		EndIf
WEnd
Func _Close()
    UDPShutdown()
	Exit
EndFunc