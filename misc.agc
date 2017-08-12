/*------------------------------------------------------------------------------*\

   Galaga - Arcade game remake

   Created by Stefan Wessels.
   Copyright (c) 2017 Wessels Consulting Ltd. All rights reserved.

   This software is provided 'as-is', without any express or implied warranty.
   In no event will the authors be held liable for any damages arising from the use of this software.

   Permission is granted to anyone to use this software for any purpose,
   including commercial applications, and to alter it and redistribute it freely.

\*------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------
function SetStates(newState, newSubState)
	gState = newState
	gSubState = newSubState
	gScratch1 = 0
	gScratch2 = 0
	gStateTimer# = 0
endfunction

//------------------------------------------------------------------------------
function SetSubState(newState)
	gSubState = newState
	gScratch1 = 0
	gScratch2 = 0
	gStateTimer# = 0
endfunction

//------------------------------------------------------------------------------
function AddCredit()
	inc gNumCredits
	if gNumCredits > 9 then visCredits = 9 else visCredits = gNumCredits
	SetTextString(gText[TEXT_0], str(visCredits))
endfunction

//------------------------------------------------------------------------------
function UseCredits()
		dec gNumCredits, gStart
		SetTextString(gText[TEXT_0], str(gNumCredits))
		gStart = 0
		if gVirtualStick
			SetVirtualButtonVisible(VB_CoinDrop, 0)
			SetVirtualButtonVisible(VB_1P_START, 0)
			SetVirtualButtonVisible(VB_2P_START, 0)
			SetVirtualJoystickVisible(VJ_Stick, 1)
			SetVirtualButtonVisible(VB_Fire, 1)
		endif
endfunction

//------------------------------------------------------------------------------
function SetTextRangeVisible(rangeStart, rangeEnd, visState)
	for i = rangeStart to rangeEnd
		SetTextVisible(gText[i], visState)
	next i
endfunction

//------------------------------------------------------------------------------
function SetSpriteRangeVisible(rangeStart, rangeEnd, visState)
	for i = rangeStart to rangeEnd
		SetSpriteVisible(gSprites[i], visState)
	next i
endfunction

//------------------------------------------------------------------------------
function ShowLivesIcons()
	SetSpriteRangeVisible(gSpriteOffsets[IMAGE_PLAYER]+2,gSpriteOffsets[IMAGE_PLAYER]+2+gPlayers[gCurrentPlayer].lives, 1)
	SetSpriteRangeVisible(gSpriteOffsets[IMAGE_PLAYER]+2+gPlayers[gCurrentPlayer].lives, gSpriteOffsets[IMAGE_PLAYER]+gSpriteNumbers[IMAGE_PLAYER], 0)
endfunction

//------------------------------------------------------------------------------
// TODO - Make sure the scores show up correctly after adjusting the width here
function FormatValue(value)
	str$ = right("      "+str(value),7)
endfunction(str$)

//------------------------------------------------------------------------------
function Clamp(a#, b#, value#)
	//if a# < b# 
		//lo# = a#
		//hi# = b#
	//else
		//lo# = b#
		//hi# = a#
	//endif
	
	//if value# < lo#
		//v# = lo#
	//elseif value# > hi#
		//v# = hi#
	//else
		//v# = value#
	//endif

	if value# < a#
		v# = a#
	elseif value# > b#
		v# = b#
	else
		v# = value#
	endif
	
endfunction(v#)
