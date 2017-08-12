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
function DoAttractTitle()

	if gScratch1 = 1
		// Make the Credit an num credits visible
		SetTextRangeVisible(TEXT_CREDIT, TEXT_0, 1)
	elseif gScratch1-1 <= TEXT_2UP - TEXT_GALAGA
		// Make the other text lables visible
		SetTextVisible(gText[TEXT_GALAGA-2+gScratch1], 1)
	endif

	// add the sprites as they need to be revealed
	// 1 & 2 text only, 3 & 4 text and sprites, 5-7 sprites only
	select gScratch1
		case 4: // TEXT_50_100
			sprite = gSprites[gSpriteOffsets[IMAGE_BEE]]
			SetSpritePositionByOffset(sprite, 26.5, 28.5)
			SetSpriteVisible(sprite, 1)
		endcase

		case 5: // TEXT_80_160
			sprite = gSprites[gSpriteOffsets[IMAGE_BUTTERFLY]]
			SetSpritePositionByOffset(sprite, 26.5, 34.0)
			SetSpriteVisible(sprite, 1)
		endcase

		case 6: // Top green guy
			sprite = gSprites[gSpriteOffsets[IMAGE_BOSS_GREEN]]
			SetSpritePositionByOffset(sprite, 50, 45)
			SetSpriteVisible(sprite, 1)
		endcase
		
		case 7: // Next 4 green guys
			for i = 1 to 4
				sprite = gSprites[gSpriteOffsets[IMAGE_BOSS_GREEN]+i]
				SetSpritePositionByOffset(sprite, i*(100.0/5.0), 52)
				SetSpriteVisible(sprite, 1)
			next i
		endcase

		case 8: // The three butterflies
			pos# as float[3] = [10, 11, 13]
			for i = 1 to 3
				sprite = gSprites[gSpriteOffsets[IMAGE_BUTTERFLY]+i]
				SetSpritePositionByOffset(sprite, pos#[i-1]*(100.0/15.0), 57)
				SetSpriteVisible(sprite, 1)
			next i
		endcase
		
		case 9: // Move on to show scores when shooting bugs
			exitFunction(0)
		endcase
	endselect

endfunction(1)

function DoAttractCreditsIn()
	if not gScratch1
		// Hide almost all sprites
		SetSpriteRangeVisible(0, gSpriteOffsets[IMAGE_RED_BULLET], 0)
		// Hide all non-permanent text
		SetTextRangeVisible(TEXT_GALAGA, TEXT_END_GAME_TEXT, 0)
		// Show credit loaded text
		SetTextRangeVisible(TEXT_PUSH_START, TEXT_FOR_BONUS, 1)
		// Show copyright message
		SetTextRangeVisible(TEXT_COPYRIGHT, TEXT_COPYRIGHT, 1)
		// Show three player ships
		for i = 1 to 3
			sprite = gSprites[gSpriteOffsets[IMAGE_PLAYER]+i]
			sx# = GetTextX(gText[TEXT_1BONUS_FOR+i-1])
			SetSpriteScale(sprite, 1.0, 1.0) ` From lives might be scaled down still
			dec sx#, GetSpriteWidth(sprite)
			syd# = GetTextTotalHeight(gText[TEXT_1BONUS_FOR+i-1]) / 2.0
			SetSpritePositionByOffset(sprite, sx#, gStringsPosY[TEXT_1BONUS_FOR+i-1] + syd#)
			SetSpriteVisible(sprite, 1)
		next i
		
		inc gScratch1
	endif
endfunction(1)

//------------------------------------------------------------------------------
function DoAttractSequence()

	dec gStateTimer#, gDT#
	
	select gSubState
		
		case cASTitle:
			if gStateTimer# <= 0.0
				gStateTimer# = cTimeToReveal
				inc gScratch1
				if not DoAttractTitle() then SetSubState(cASShowValues)
			endif
		endcase

		case cASShowValues:
			sprite = gSprites[gSpriteOffsets[IMAGE_PLAYER]]
			SetSpritePositionByOffset(sprite, 50, ((cOriginalYCellsF-3.0)/cOriginalYCellsF)*100.0)
			SetSpriteVisible(sprite, 1)
			SetSubState(cASShowCopyright)
		endcase
		
		case cASShowCopyright:
			if gScratch1 = 0
				SetSpriteVisible(gSprites[gSpriteOffsets[IMAGE_PLAYER]], 0)
				SetSpriteVisible(gSprites[gSpriteOffsets[IMAGE_NAMCO]], 1)
				SetTextVisible(gText[TEXT_COPYRIGHT], 1)
				gStateTimer# = cHoldCopyright
				gScratch1 = 1
			endif
			
			if gScratch1 = 1 and gStateTimer# < 0.0
				SetSpriteRangeVisible(0, gSprites.length, 0)
				SetTextRangeVisible(TEXT_GALAGA, TEXT_COPYRIGHT, 0)
				SetSubState(cASShowPlay)
			endif
		endcase

		case cASShowPlay:
			if gScratch1 = 0
				SetTextVisible(gText[TEXT_FIGHTER_CAPTURED], 1)
				gStateTimer# = cHoldCopyright ` temporarily
				gScratch1 = 1
			endif
			
			if gScratch1 = 1 and gStateTimer# < 0.0
				SetTextVisible(gText[TEXT_FIGHTER_CAPTURED], 0)
				SetTextVisible(gText[TEXT_GAME_OVER], 1)
				gStateTimer# = cHoldHighScores - cHoldCopyright ` temporarily
				gScratch1 = 2
			endif

			if gScratch1 = 2 and gStateTimer# < 0.0
				SetTextVisible(gText[TEXT_GAME_OVER], 0)
				SetSubState(cASShowScores)
			endif
		endcase

		case cASShowScores:
			if gScratch1 = 0
				SetTextRangeVisible(TEXT_HEROES, TEXT_O_O, 1)
				gStateTimer# = cHoldHighScores
				gScratch1 = 1
			endif

			if gScratch1 = 1 and gStateTimer# < 0.0
				SetTextRangeVisible(TEXT_HEROES, TEXT_O_O, 0)
				SetSubState(cASTitle)
			endif
		endcase
		
		case cASHaveCredit:
			DoAttractCreditsIn()
		endcase

	endselect
endfunction

