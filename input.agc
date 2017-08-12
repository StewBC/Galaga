/*------------------------------------------------------------------------------*\

   Galaga - Arcade game remake

   Created by Stefan Wessels.
   Copyright (c) 2017 Wessels Consulting Ltd. All rights reserved.

   This software is provided 'as-is', without any express or implied warranty.
   In no event will the authors be held liable for any damages arising from the use of this software.

   Permission is granted to anyone to use this software for any purpose,
   including commercial applications, and to alter it and redistribute it freely.

\*------------------------------------------------------------------------------*/

#constant    KEY_ENTER        13
#constant    KEY_CONTROL      17
#constant    KEY_ESCAPE       27
#constant    KEY_LEFT         37
#constant    KEY_RIGHT        39
#constant    KEY_1            49
#constant    KEY_2            50

/*
#constant    KEY_BACK         8
#constant    KEY_TAB          9
#constant    KEY_ENTER        13
#constant    KEY_SHIFT        16
#constant    KEY_CONTROL      17
#constant    KEY_ESCAPE       27
#constant    KEY_SPACE        32
#constant    KEY_PAGEUP       33
#constant    KEY_PAGEDOWN     34
#constant    KEY_END          35
#constant    KEY_HOME         36
#constant    KEY_LEFT         37
#constant    KEY_UP           38
#constant    KEY_RIGHT        39
#constant    KEY_DOWN         40
#constant    KEY_INSERT       45
#constant    KEY_DELETE       46
#constant    KEY_0            48
#constant    KEY_1            49
#constant    KEY_2            50
#constant    KEY_3            51
#constant    KEY_4            52
#constant    KEY_5            53
#constant    KEY_6            54
#constant    KEY_7            55
#constant    KEY_8            56
#constant    KEY_9            57
#constant    KEY_A            65
#constant    KEY_B            66
#constant    KEY_C            67
#constant    KEY_D            68
#constant    KEY_E            69
#constant    KEY_F            70
#constant    KEY_G            71
#constant    KEY_H            72
#constant    KEY_I            73
#constant    KEY_J            74
#constant    KEY_K            75
#constant    KEY_L            76
#constant    KEY_M            77
#constant    KEY_N            78
#constant    KEY_O            79
#constant    KEY_P            80
#constant    KEY_Q            81
#constant    KEY_R            82
#constant    KEY_S            83
#constant    KEY_T            84
#constant    KEY_U            85
#constant    KEY_V            86
#constant    KEY_W            87
#constant    KEY_X            88
#constant    KEY_Y            89
#constant    KEY_Z            90
#constant    KEY_F1           112
#constant    KEY_F2           113
#constant    KEY_F3           114
#constant    KEY_F4           115
#constant    KEY_F5           116
#constant    KEY_F6           117
#constant    KEY_F7           118
#constant    KEY_F8           119
#constant    KEY_S1           186    
#constant    KEY_S2           187
#constant    KEY_S3           188
#constant    KEY_S4           189
#constant    KEY_S5           190
#constant    KEY_S6           191
#constant    KEY_S7           192
#constant    KEY_S8           219
#constant    KEY_S9           220
#constant    KEY_S10          221
#constant    KEY_S11          222
#constant    KEY_S12          223
*/

//------------------------------------------------------------------------------
function ProcessInput()
	
	gDirection = 0
	gFire = 0

	if gVirtualStick 
		joyX = GetVirtualJoystickX(VJ_Stick) 
		
		gFire = GetVirtualButtonPressed(VB_Fire)
		gCoinDropped = GetVirtualButtonPressed(VB_CoinDrop)
		if GetVirtualButtonPressed(VB_1P_START) then gStart = 1 
		if GetVirtualButtonPressed(VB_2P_START) then gStart = 2
	elseif gActualJoyStick 
		// TODO - Add a Joystick configuration page
		joyX = GetRawJoystickX(gActualJoyStick)

		gFire = GetRawJoystickButtonPressed(gActualJoyStick, 1)
		gCoinDropped = GetRawJoystickButtonPressed(gActualJoyStick, 9)
		gStart = GetRawJoystickButtonPressed(gActualJoyStick, 10)
	else
		joyX = 0
		gCoinDropped = 0
		gStart = 0
	endif

	if joyX < -0.1 then gDirection = -1
	if joyX > 0.1 then gDirection = 1
	
	// TODO - Add a Keyboard configuration page - with Joystic dead-zone
	if GetRawKeyState(KEY_LEFT) then gDirection = -1
	if GetRawKeyState(KEY_RIGHT) then gDirection = 1
	if GetRawKeyPressed(KEY_CONTROL) then gFire = 1
	if GetRawKeyPressed(KEY_ENTER) then gCoinDropped = 1
	if GetRawKeyPressed(KEY_1) then gStart = 1
	if GetRawKeyPressed(KEY_2) then gStart = 2
	if GetRawKeyPressed(KEY_ESCAPE) then end

	// Manage the direction input state (debounce, auto-repeat) 
	if gPrevDirection = gDirection
		dec gRepeatDelay#, gDT#
		if gRepeatDelay# > 0.0 
			gManagedDir = 0 
		else
			gManagedDir = gDirection
			gRepeatDelay# = cRepeatDelay
		endif
	else
		gPrevDirection = gDirection
		gManagedDir = gDirection
		gRepeatDelay# = cRepeatInitialDelay
	endif

endfunction
