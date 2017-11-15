#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


$ReadFileBroadcast = FileReadLine("BroadcastResult.txt", 1)
$LengthReadBroadcast = StringLen($ReadFileBroadcast)
$TrimLeft = StringTrimLeft($ReadFileBroadcast, 2)
$AmountTrimRight = $LengthReadBroadcast - 20 			;==> 20 Zeichen wurden eingeräumt um Fehler zu vermeiden bei der Berechnung
$TrimRight = StringTrimRight($TrimLeft, $AmountTrimRight)
$EndResultBroadcast = StringReplace($TrimRight, " ", "")
ConsoleWrite($EndResultBroadcast)

FileDelete("BroadcastResult.txt")


HotKeySet("{Esc}", "_Close")


UDPStartup()
ConsoleWrite("Starting UDP Service")


$ip = @IPAddress1
$port = 2500
$aSocket = ""

UDPBind($EndResultBroadcast, $port)

While 1
    $aData = UDPRecv($port, 4, 2)
		If $aData == 1002 Then
			ConsoleWrite("Got Data")
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