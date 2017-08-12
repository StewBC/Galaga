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
// show all errors
SetErrorMode(2)

//------------------------------------------------------------------------------
#insert "globals.agc"
#insert "setup.agc"
#insert "input.agc"
#insert "startup.agc"
#insert "background.agc"
#insert "attract.agc"
#insert "spawn.agc"
#insert "play.agc"
#insert "misc.agc"

/*-----------------------------------------------------------------------------*\
	              * * * *   G A L A G A   --   M A I N   * * * * 
\*-----------------------------------------------------------------------------*/
Setup()
StartupSequence()
SetupJoystick()
MakeStars(cNumStars)
MainLoop()

//------------------------------------------------------------------------------
function MainLoop()

	// Show 1UP, HIGH SCORE and initial high score
	SetTextRangeVisible(TEXT_1UP, TEXT_20000, 1)
	ResetTimer()

	do
		//Print(ScreenFPS())
		
		gDT# = Timer()

		ProcessStars()
		ProcessInput()
		
		// Handle the hardware coin drop here
		if gCoinDropped
			PlaySound(gSounds[SOUND_COIN])
			AddCredit()
			if gState = cStateAttractLoop then SetSubState(cASHaveCredit)
			if gVirtualStick
				if gNumCredits < 2
					SetVirtualButtonVisible(VB_1P_START, 1)
					SetVirtualButtonVisible(VB_2P_START, 0)
				else
					SetVirtualButtonVisible(VB_2P_START, 1)
				endif
			endif
		endif

		// game state machine
		select gState
			
			// Anything to do with the front end (but not the back end - post play before
			// game over
			case cStateAttractLoop:
				// Makew sure there are always gCoinDroppeds to play
				DoAttractSequence()
				if (gStart = 1 and gNumCredits) or (gStart = 2 and gNumCredits > 1)
					gNumPlayers = gStart
					UseCredits()
					SetTextRangeVisible(TEXT_GALAGA, TEXT_END_GAME_TEXT, 0)
					SetSpriteRangeVisible(0, gSprites.length, 0)
					SetStates(cStatePlayGame, cPSInitGame)
				endif
			endcase
			
			// Playing the game, and post game flow
			case cStatePlayGame:
				if not PlayGame() 
					SetStates(cStateAttractLoop, cASTitle)
					SetSpriteRangeVisible(0, gSpriteOffsets[IMAGE_RED_BULLET], 0)
					if gVirtualStick
						SetVirtualButtonVisible(VB_CoinDrop, 1)
						if gNumCredits > 0 then SetVirtualButtonVisible(VB_1P_START, 1)
						if gNumCredits > 1 then SetVirtualButtonVisible(VB_2P_START, 1)
						
						SetVirtualJoystickVisible(VJ_Stick, 0)
						SetVirtualButtonVisible(VB_Fire, 0)
					endif
				endif
			endcase
			
		endselect
		
		// Set up to time the frame
		ResetTimer()
		Sync()
	loop

endfunction
