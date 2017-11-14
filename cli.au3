#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;-------------------------------------------------------------------------------------
;	Includings
;-------------------------------------------------------------------------------------

#include <File.au3>
#include <Date.au3>
#include <String.au3>
#include <WinAPIFiles.au3>
#include <Process.au3>
#include <FTPEx.au3>

_readParameters()
;-------------------------------------------------------------------------------------
;	Deklaration von Variablen in einer Funktion und Lädt anschließend die CLI
;-------------------------------------------------------------------------------------
func _readParameters()
	Global $answer = ""
	Global $client = ""
	Global $server = ""
	Global $ConnectSavedServer = ""
	Global $DoNotConnectSavedServer = ""
	Global $g_IP = "" ; IP des Servers
	Global $serverPort = "" ; Port des Servers
	Global $nootAddress = "" ; Noot Adresse des Servers
	Global $readIpIni = IniRead("IPNoot.ini", "ServerAddress", "g_IP", "") ; The IP read from the .INI file - if not present, user has to enter manually
	Global $readNootIni = IniRead("IPNoot.ini", "ServerAddress", "nootAddress", "") ; Noot Address read from .INI file - if not present, user has to enter manually
	Global $readServerPort = IniRead("IPNoot.ini", "ServerAddress", "ServerPort", "") ; Server Port from .INI file
	Global $configOk = IniRead("IPNoot.ini", "Config", "OK", "no") ; Looks up if the Config is OK in the .INI file
	Global $ServerConfigOk = IniRead("Server.ini", "Config", "OK", "no")
	Global $ServerReadIpIni = IniRead("Server.ini", "ServerAddress", "g_IP", "") ; The IP read from the .INI file - if not present, user has to enter manually
	Global $ServerReadNootIni = IniRead("Server.ini", "ServerAddress", "nootAddress", "") ; Noot Address read from .INI file - if not present, user has to enter manually
	Global $ServerReadServerPort = IniRead("Server.ini", "ServerAddress", "ServerPort", "") ; Server Port from .INI file
	_mainMenuCommands() ;Befehle auslesen
	Global $ConnectSavedServerBinary = ""
	Global $DoNotConnectSavedServerBinary = ""
	Global $UseSavedConf = ""
	Global $UseSavedConfBinary = ""
	Global $DoNotUseSavedConf = ""
	Global $DoNotUseSavedConfBinary = ""
	_startCLI() ;Startet die CLI

EndFunc
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------

#cs
	;-------------------------------------------------------------------------------------
	Autor: 			Florian Krismer
	Sytax: 			_startCLI()
	Return Value:		-
	Beschreibung: 	Startet die CLI mit allen Parametern neu
	-------------------------------------------------------------------------------------
#ce
Func _startCLI()

	;-------------------------------------------------------------------------------------
	;	Erststart
	;-------------------------------------------------------------------------------------

	ConsoleWrite("Noot Protocol Copyright Florian Krismer, Stefan Hausberger 2017" & @CRLF & "For help type help or ?" & @CRLF & @CRLF)


	while 1
		ConsoleWrite("client or server?: ")
		$answer = _readConsole()
		Switch $answer
			Case $client
				ConsoleWrite("Starting client..." & @CRLF & @CRLF)
				_client()
			Case $exit
				Exit
			Case $server
				ConsoleWrite("Starting server" & @CRLF & @CRLF)
				_server()
			Case Else
				ConsoleWrite("Unknown command" & @CRLF)
		EndSwitch
	WEnd
EndFunc



;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------



Func _consoleUserView()

	ConsoleWrite("[UserView] ")
	$timeOut = True


	While $timeOut = True

		Global $read = ""
		$readRaw = ConsoleRead(False, True)
		Global $newReadLine = StringTrimRight($readRaw, 4)
		If $newReadLine <> "" Then
			_readConsoleUserView()
		EndIf

	WEnd

EndFunc   ;==>_consoleUserView


;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------




Func _mainMenuCommands()

	Global $help = StringToBinary("help")
	Global $helpShortCut = StringToBinary("?")
	Global $noot = StringToBinary("noot")
	Global $client = StringToBinary("client")
	Global $server = StringToBinary("server")
	Global $y = StringToBinary("y")
	Global $n = StringToBinary("n")
	Global $exit = StringToBinary("exit")
	Global $restart = StringToBinary("restart")
	Global $blank = StringToBinary("")
	Global $cls = StringToBinary("cls")
	Global $ftp = StringToBinary("ftp")

EndFunc   ;==>_mainMenuCommands


#cs
	;-------------------------------------------------------------------------------------
	Autor: 			Florian Krismer
	Sytax: 			_readConsoleUserView()
	Return Value:		-
	Beschreibung: 	Liest die Konsole aus und überprüft die verfügbaren Befehle
	-------------------------------------------------------------------------------------
#ce

Func _readConsoleUserView()

	Switch $newReadLine
		Case $help
			ConsoleWrite("Current Commands: help, ?, noot, exit, restart, cls" & @CRLF & @CRLF)

		Case $helpShortCut
			ConsoleWrite("Current Commands: help, ?, noot, exit, restart, cls"& @CRLF & @CRLF)
		Case $exit
			ConsoleWrite("Exiting..." & @CRLF & @CRLF)
			_countDown()
		Case $noot
			ConsoleWrite(@CRLF & "NOOT" & @CRLF & @CRLF)
		Case $restart
			ConsoleWrite(@CRLF & "Restarting CLI..." & @CRLF & @CRLF & @CRLF & @CRLF)
			sleep(1000)
			_RunDos("cls")
			_readParameters()

		Case $blank

		case $cls
			_RunDos("cls")
			_readParameters()
			ConsoleWrite("Noot Protocol Copyright Florian Krismer, Stefan Hausberger 2017" & @CRLF & "For help type help or ?" & @CRLF & @CRLF)
			ConsoleWrite("Current configuration: " & @CRLF & "Ip Address of Server: " & $readIpIni & @CRLF & "Server Port: " & $readServerPort & @CRLF & "Noot Address: " & $readNootIni & @CRLF & @CRLF & @CRLF)
		Case Else
			ConsoleWrite("Unknown command" & @CRLF)

	EndSwitch
	ConsoleWrite("[UserView] ")

EndFunc

#cs
	;-------------------------------------------------------------------------------------
	Autor: 			Florian Krismer
	Sytax: 			_countDown()
	Return Value:		-
	Beschreibung: 	Final Countdown 10 Sekunden bevor shutdown
	-------------------------------------------------------------------------------------
#ce
Func _countDown()

	ConsoleWrite("Connection closed. This window will close in:" & @CRLF)
	ConsoleWrite("3" & @CRLF)
	Sleep(1000)
	ConsoleWrite("2" & @CRLF)
	Sleep(1000)
	ConsoleWrite("1" & @CRLF)
	Sleep(1000)
	Exit


EndFunc   ;==>_countDown

Func _client()

	;-------------------------------------------------------------------------------------
	;	Client Verbindungsaufbau
	;-------------------------------------------------------------------------------------

	If $configOk == "no" Then

		ConsoleWrite("Type in the IP of the Server: ")
		$g_IPBinary = _readConsole()
		$g_IP = BinaryToString($g_IPBinary)
		ConsoleWrite("Type in the Server port: ")
		$serverPortBinary = _readConsole()
		$serverPort = BinaryToString($serverPortBinary)
		ConsoleWrite("Type in the Noot Address of the Server: ")
		$nootAddressBinary = _readConsole()
		$nootAddress = BinaryToString($nootAddressBinary)

		IniWrite("IPNoot.ini", "ServerAddress", "g_IP", $g_IP)
		IniWrite("IPNoot.ini", "ServerAddress", "nootAddress", $nootAddress)
		IniWrite("IPNoot.ini", "ServerAddress", "ServerPort", $serverPort)

		ConsoleWrite("Saving configuration..." & @CRLF & @CRLF)
		IniWrite("IPNoot.ini", "ServerAddress", "g_IP", $g_IP)
		IniWrite("IPNoot.ini", "ServerAddress", "nootAddress", $nootAddress)
		IniWrite("IPNoot.ini", "ServerAddress", "ServerPort", $serverPort)
		ConsoleWrite("Saving complete" & @CRLF & @CRLF)
		FileDelete("*.tmp")
		IniWrite("IPNoot.ini", "Config", "OK", "ConfigOK")

	Else
		$whileWait = 1
		while $whileWait = 1

			ConsoleWrite("Connect to saved Server? y/n " & @CRLF)
			$ConnectSavedServer = _readConsole()
			Switch $ConnectSavedServer
				case $n
					ConsoleWrite("Are you sure? This will delete your saved Server and restart the console. y/n " & @CRLF)
					$DoNotConnectSavedServer = _readConsole()
						If $DoNotConnectSavedServer == $y Then
							ConsoleWrite("Deleting ini file..." & @CRLF)
							_DeleteINI()
							ConsoleWrite("Reading new Parameters..." & @CRLF & @CRLF & @CRLF)
							_readParameters()
						Else
							_readParameters()
						EndIf
				case $y
					$whileWait = 0

				case else
					ConsoleWrite("Wrong Input" & @CRLF & @CRLF)

			EndSwitch
		WEnd


	EndIf
		_RunDos("cls")
		_readParameters()
		ConsoleWrite("Noot Protocol Copyright Florian Krismer, Stefan Hausberger 2017" & @CRLF & "For help type help or ?" & @CRLF & @CRLF)
		ConsoleWrite("Current configuration: " & @CRLF & "Ip Address of Server: " & $readIpIni & @CRLF & "Server Port: " & $readServerPort & @CRLF & "Noot Address: " & $readNootIni & @CRLF)
		FileDelete("*.tmp")
		UDPStartup() ;Starte UDP
		$udpSocket = UDPOpen($readIpIni, $readServerPort) ;Stelle verbindung her mit Server
		If @error Then ; Fehlermeldung - Verbindungsaufbau fehlgeschlagen
			MsgBox(48, "Error", "ERROR002: Es kann keine UDP Verbindung zum Server hergestellt werden!")
			UDPShutdown()
			_countDown()

		EndIf

		UDPSend($udpSocket, StringToBinary(1001)) ;Sendet das Wort Noot

		Do
			Global $UDPReceivedData = UDPRecv($udpSocket, 128) ;er wartet auf eine Antwort des Servers bei maximal 128 Zeichen
			Sleep(20) ;timeout für wartezeit vom server

		Until $UDPReceivedData <> ""
		ConsoleWrite("Answer from the server: " & $UDPReceivedData & @CRLF)
		UDPShutdown()
		_consoleUserView()

EndFunc   ;==>_client



#cs
	;-------------------------------------------------------------------------------------
	Autor: 			Stefan Hausberger
	Sytax: 			_server
	Return Value:	none
	Beschreibung: 	Die Server Funktion / Wird durch Eingabe von server statt client getriggered
	-------------------------------------------------------------------------------------
#ce

Func _server()

	If $ServerConfigOk == "no" Then
		ConsoleWrite("IP Address for your Server: ")
		$g_IPBinary = _readConsole()
		$g_IP = BinaryToString($g_IPBinary)
		ConsoleWrite("Server Port to use: ")
		$serverPortBinary = _readConsole()
		$serverPort = BinaryToString($serverPortBinary)
		ConsoleWrite("Noot Address for your Server: ")
		$nootAddressBinary = _readConsole()
		$nootAddress = BinaryToString($nootAddressBinary)

		IniWrite("Server.ini", "ServerAddress", "g_IP", $g_IP)
		IniWrite("Server.ini", "ServerAddress", "nootAddress", $nootAddress)
		IniWrite("Server.ini", "ServerAddress", "ServerPort", $serverPort)

		ConsoleWrite("Saving configuration..." & @CRLF & @CRLF)
		IniWrite("Server.ini", "ServerAddress", "g_IP", $g_IP)
		IniWrite("Server.ini", "ServerAddress", "nootAddress", $nootAddress)
		IniWrite("Server.ini", "ServerAddress", "ServerPort", $serverPort)
		ConsoleWrite("Saving complete" & @CRLF & @CRLF)
		FileDelete("*.tmp")
		IniWrite("Server.ini", "Config", "OK", "ConfigOK")

	Else
		$whileWait = 1
		While $whilewait = 1

			ConsoleWrite("Use saved Server Configuration? y/n" & @CRLF)
			$UseSavedConf &= _readConsole()

			Switch $UseSavedConf
				case $n
					ConsoleWrite("Are you sure? This will delete your saved Server Configuration and restart the console. y/n" & @CRLF)
					$DoNotUseSavedConf &= _readConsole()
						If $DoNotUseSavedConf == $y Then
							ConsoleWrite("Deleting saved Configuration..." & @CRLF)
							_DeleteIniServer()
							ConsoleWrite("Successfully deleted old configuration!" & @CRLF & @CRLF & @CRLF)
							_readParameters()
						Else
							_readParameters()

						EndIf
				case $y
						$whileWait = 0
				case else
						ConsoleWrite("Wrong Input!")
			EndSwitch
		WEnd

	EndIf

	UDPStartup() ;startet den UDP-Service
	$aSocket = UDPBind($ServerReadIpIni, $ServerReadServerPort) ; Öffnet einen Socket mit der IP $g_IP und dem Port 65432
	; $aSocket ist genauso aufgebaut wie das Array von UDPOpen()
	;	$aSocket[1]: real socket
	;	$aSocket[2]: IP des Servers
	;	$aSocket[3]: Port des Servers
	ConsoleWrite("Starting UDP Server..." & @CRLF)

	;------------------------------------------------------
	;-----------------Abfrage des UDP----------------------
	;------------------------------------------------------


	If @error Then
		MsgBox(0, "", "ERROR: Could not start UDP Service")
		Exit
	EndIf


	;------------------------------------------------------
	;-------------UDP Abfragen bearbeiten------------------
	;------------------------------------------------------
	ConsoleWrite("Current configuration: " & @CRLF & "Ip Address: " & $ServerReadIpIni & @CRLF & "Port: " & $ServerReadServerPort & @CRLF & $ServerReadNootIni)
	ConsoleWrite("Server is ready to use" & @CRLF & @CRLF & @CRLF)
	ConsoleWrite("ServerView: ")
	While 1 ;Endlosschleife

		$aData = UDPRecv($aSocket, 64, 2) ;empfängt Daten von einem Client
		;durch das Flag 2 wird folgendes Array ausgegeben:
		;	$aData[0]: data
		;	$aData[1]: IP des Clients
		;	$aData[2]: Port des Clients
		If $aData <> "" Then ;Falls Daten vom Client gesendet wurden

			ConsoleWrite("Intialising new connection" & @CRLF)
			Global $aClientArray[4] = [$aSocket[0], $aSocket[1], $aData[1], $aData[2]] ;Erstelle ein Array mit den Daten die benötigt werden, um den Client etwas zurück zu senden
			ConsoleWrite("Got Message: " & $aData[0] & @CRLF)
			ConsoleWrite("Sending connection built" & @CRLF)
			UDPSend($aClientArray, 1001)

		EndIf

		Global $read = ""
		$readRaw = ConsoleRead(False, True)
		Global $newReadLine = StringTrimRight($readRaw, 4)
		If $newReadLine <> "" Then

		Switch $newReadLine

		Case $exit
				ConsoleWrite("Exiting..." & @CRLF & @CRLF)
			_countDown()

		Case $noot
				ConsoleWrite(@CRLF & "NOOT" & @CRLF & @CRLF)

		Case $restart
			ConsoleWrite(@CRLF & "Restarting CLI..." & @CRLF & @CRLF & @CRLF & @CRLF)
			sleep(1000)
			_RunDos("cls")
			_readParameters()

		Case $blank

		Case $help
			ConsoleWrite("Current Commands: help, ?, noot, exit, restart, cls" & @CRLF & @CRLF)

		Case $helpShortCut
			ConsoleWrite("Current Commands: help, ?, noot, exit, restart, cls"& @CRLF & @CRLF)

		case $cls
			_RunDos("cls")
			ConsoleWrite("Noot Protocol Copyright Florian Krismer, Stefan Hausberger 2017" & @CRLF & "For help type help or ?" & @CRLF & @CRLF)
			ConsoleWrite("Current configuration: " & @CRLF & "Ip Address of Server: " & $readIpIni & @CRLF & "Server Port: " & $readServerPort & @CRLF & "Noot Address: " & $readNootIni & @CRLF & @CRLF & @CRLF)
		Case Else
			ConsoleWrite("Unknown command" & @CRLF)

		EndSwitch
		ConsoleWrite("ServerView: ")
		EndIf
		Sleep(20)
	WEnd

EndFunc

#cs
	;-------------------------------------------------------------------------------------
	Autor: 			Florian Krismer
	Sytax: 			_readConsole()
	Return Value:	Der Befehl der eingegeben wurde vom User
	Beschreibung: 	Liest die jetzige Konsole
	-------------------------------------------------------------------------------------
#ce

Func _readConsole()


	$timeOut = True

	While $timeOut = True

		Global $read = ""
		$readRaw = ConsoleRead(False, True)
		$newReadLine = StringTrimRight($readRaw, 4)
		If $newReadLine <> "" Then
			Return ($newReadLine)
		EndIf

	WEnd


EndFunc   ;==>_readConsole

;Funktion für client.au3, um die geschriebene Config in der .INI zu löschen

Func _DeleteINI()

	IniDelete("IPNoot.ini", "Config", "OK")
	Sleep(1000)

EndFunc   ;==>DeleteINI

Func _DeleteIniServer()

	IniDelete("Server.ini", "Config", "OK")
	Sleep (1000)

EndFunc



#cs
	;-------------------------------------------------------------------------------------
	Autor: 			Florian Krismer
	Sytax: 			_getSoundFile()
	Return Value:		-
	Beschreibung: 	Downloaded die Noot Soundfile in das Scriptverzeichnis
	-------------------------------------------------------------------------------------
#ce
func _getSoundFile()

	ConsoleWrite("Starting download for Soundfile!" & @CRLF)
	$ftpOpen = _FTP_OPEN("Soundfile")
	$ftpConn = _FTP_Connect($ftpOpen, "46.228.199.85", "administrator", "!VSAdmin01!")

	if @error Then
		ConsoleWrite("Error while downloading soundfile!" & @CRLF)
	Else
		$ftpGet = _FTP_FileGet($ftpConn, "/noot/noot.mp3", @ScriptDir & "\noot.mp3")
		if @error Then
			ConsoleWrite("Error while downloading soundfile!" & @CRLF)
		Else
			ConsoleWrite("Download finished" & @CRLF)
		EndIf
	EndIf
	sleep(5000)

EndFunc
