#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Process.au3>
#include <File.au3>

$ServerSocket = ""


$Broadcast = _RunDos('arp -a | find "ff-ff-ff-ff-ff-ff" >>BroadcastResult.txt')

$ReadFileBroadcast = FileReadLine("BroadcastResult.txt", 1)
$LengthReadBroadcast = StringLen($ReadFileBroadcast)
$TrimLeft = StringTrimLeft($ReadFileBroadcast, 2)
$AmountTrimRight = $LengthReadBroadcast - 20 			;==> 20 Zeichen wurden eingeräumt um Fehler zu vermeiden bei der Berechnung
$TrimRight = StringTrimRight($TrimLeft, $AmountTrimRight)
$EndResultBroadcast = StringReplace($TrimRight, " ", "")

FileDelete("BroadcastResult.txt")

UDPStartup()

HotKeySet("{Esc}", "_Close")

$ip = $EndResultBroadcast
$port = 2500

$aSocket = UDPOpen($ip, $port)


$connect = UDPSend($asocket, 1002)
If @error Then
    ConsoleWrite("could not send Broadcast")
    Sleep(10000)
    _Close()
EndIf

$data = $ip

UDPSend($connect, $data)
UDPBind($EndResultBroadcast, $port)


While 1
	$ServerData = UDPRecv($port, 10, 2)
Sleep(3000)
_Close()

Func _Close()
    UDPShutdown()
    Exit
EndFunc