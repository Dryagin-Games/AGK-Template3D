
// Project: {project}
// Created: {date}

#Option_Explicit

#Constant False 0
#Constant True  1

#Constant AGK_ErrorMode_Ignore 0
#Constant AGK_ErrorMode_Report 1
#Constant AGK_ErrorMode_Stop   2
#Constant AGK_SyncRate_Save     0
#Constant AGK_SyncRate_Accurate 1
#Constant AGK_WindowMode_Windowed   0
#Constant AGK_WindowMode_Fullscreen 1

#Constant Key_Shift 16
#Constant Key_A     65
#Constant Key_D     68
#Constant Key_E     69
#Constant Key_Q     81
#Constant Key_S     83
#Constant Key_W     87

#Constant TAB$   = Chr(0x09)
#Constant LF$    = Chr(0x0A)
#Constant CR$    = Chr(0x0D)
#Constant CRLF$  = Chr(0x0D) + Chr(0x0A)
#Constant SPACE$ = Chr(0x20)
#Constant QUOT$  = Chr(0x22)
#Constant TIMES$ = Chr(0xD7)

SetErrorMode(AGK_ErrorMode_Stop)
SetWindowTitle("{project}")
SetWindowSize(1280, 720, AGK_WindowMode_Windowed)
SetWindowAllowResize(True)
SetVirtualResolution(1920, 1080)
SetOrientationAllowed(True, True, True, True)
SetSyncRate(60, AGK_SyncRate_Accurate)
SetScissor(0, 0, 0, 0)
UseNewDefaultFonts(True)
SetPrintSize(32.0)
SetPrintColor(0xFF, 0xFF, 0xFF)
SetClearColor(0x40, 0x80, 0xC0)

Function CreateAxisSubObject(object As Integer, x As Integer, y As Integer, z As Integer, pos As Integer)
	SetObjectColor(object, x * 0xFF, z * 0xFF, y * 0xFF, 0xFF)
	SetObjectRotation(object, 90.0 * z, -90.0 * y, -90.0 * x)
	SetObjectPosition(object, x * pos, y * pos, z * pos)
EndFunction

Function CreateAxisObject(x As Integer, y As Integer, z As Integer)
	CreateAxisSubObject(CreateObjectCylinder(20.0, 1.0, 8), x, y, z, 10.0)
	CreateAxisSubObject(CreateObjectCone(5.0, 2.0, 8), x, y, z, 20.0)
EndFunction

mouseX As Float
mouseY As Float

cameraIndex As Integer = 1
cameraBaseSpeed As Float = 4.0
cameraSlowSpeed As Float = 0.5
cameraSpeed As Float
cameraStartX As Float
cameraStartY As Float
cameraAngleX As Float
cameraAngleY As Float
cameraDiffX As Float
cameraDiffY As Float
cameraNewX As Float

CreateAxisObject(1, 0, 0)
CreateAxisObject(0, 1, 0)
CreateAxisObject(0, 0, 1)

SetCameraPosition(cameraIndex, 100.0, 100.0, 100.0)
SetCameraLookAt(cameraIndex, 0.0, 0.0, 0.0, 0.0)

Do
	
	mouseX = GetRawMouseX()
	mouseY = GetRawMouseY()
	
	If GetRawKeyState(Key_Shift)
		cameraSpeed = cameraSlowSpeed
	Else
		cameraSpeed = cameraBaseSpeed
	EndIf
	If GetRawKeyState(Key_W) Then MoveCameraLocalZ(cameraIndex,  cameraSpeed)
	If GetRawKeyState(Key_S) Then MoveCameraLocalZ(cameraIndex, -cameraSpeed)
	If GetRawKeyState(Key_A) Then MoveCameraLocalX(cameraIndex, -cameraSpeed)
	If GetRawKeyState(Key_D) Then MoveCameraLocalX(cameraIndex,  cameraSpeed)
	If GetRawKeyState(Key_E) Then MoveCameraLocalY(cameraIndex, -cameraSpeed)
	If GetRawKeyState(Key_Q) Then MoveCameraLocalY(cameraIndex,  cameraSpeed)
	If GetRawMouseLeftPressed()
		cameraStartX = mouseX
		cameraStartY = mouseY
		cameraAngleX = GetCameraAngleX(cameraIndex)
		cameraAngleY = GetCameraAngleY(cameraIndex)
	EndIf
	If GetRawMouseLeftState()
		cameraDiffX = (mouseX - cameraStartX) / 4.0
		cameraDiffY = (mouseY - cameraStartY) / 4.0
		cameraNewX = cameraAngleX + cameraDiffY
		If cameraNewX >  89.0 Then cameraNewX =  89.0
		If cameraNewX < -89.0 Then cameraNewX = -89.0
		SetCameraRotation(cameraIndex, cameraNewX, cameraAngleY + cameraDiffX, 0)
	EndIf
	
	Print("FPS: " + Str(ScreenFPS(), 1) + CRLF$)
	
	Print("Camera")
	Print(TAB$ + "position: " + Str(GetCameraX(cameraIndex)) + ", " + Str(GetCameraY(cameraIndex)) + ", " + Str(GetCameraZ(cameraIndex)))
	Print(TAB$ + "angle: " + Str(GetCameraAngleX(cameraIndex)) + ", " + Str(GetCameraAngleY(cameraIndex)) + ", " + Str(GetCameraAngleZ(cameraIndex)))
	Print(TAB$ + "quaternion: " + Str(GetCameraQuatW(cameraIndex)) + ", " + Str(GetCameraQuatX(cameraIndex)) + ", " + Str(GetCameraQuatY(cameraIndex)) + ", " + Str(GetCameraQuatZ(cameraIndex)) + CRLF$)
	/*
	Print("Camera (world)")
	Print(TAB$ + "position: " + Str(GetCameraWorldX(cameraIndex)) + ", " + Str(GetCameraWorldY(cameraIndex)) + ", " + Str(GetCameraWorldZ(cameraIndex)))
	Print(TAB$ + "angle: " + Str(GetCameraWorldAngleX(cameraIndex)) + ", " + Str(GetCameraWorldAngleY(cameraIndex)) + ", " + Str(GetCameraWorldAngleZ(cameraIndex)))
	Print(TAB$ + "quaternion: " + Str(GetCameraWorldQuatW(cameraIndex)) + ", " + Str(GetCameraWorldQuatX(cameraIndex)) + ", " + Str(GetCameraWorldQuatY(cameraIndex)) + ", " + Str(GetCameraWorldQuatZ(cameraIndex)) + CRLF$)
	*/
	Print("Mouse")
	Print(TAB$ + "screen: " + Str(mouseX, 2) + ", " + Str(mouseY, 2))
	Print(TAB$ + "world: " + Str(ScreenToWorldX(mouseX), 2) + ", " + Str(ScreenToWorldY(mouseY), 2))
	
	Sync()
	
Loop
