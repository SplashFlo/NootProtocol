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


$ip = $EndResultBroadcast
$port = 2500
$aSocket = ""

UDPOpen($ip, $port)

Do
    $aData = UDPRecv($port, 4, 2)
	Until $aData <> ""


			ConsoleWrite("Data: " & $aData)
			Sleep(7000)
			Global $aClientArray[4] = [$aSocket[0], $aSocket[1], $aData[1], $aData[2]] ;Erstelle ein Array mit den Daten die benötigt werden, um den Client etwas zurück zu senden
			UDPSend($aClientArray, @IPAddress1 & $port)
			_Close()
			ConsoleWrite("Data: " & $aData)
			Sleep(7000)

Func _Close()
    UDPShutdown()
	Exit
EndFunc