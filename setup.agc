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
function Setup()
	
	// TODO - Remove Validation code
	errorcode = 0
	if cMaxBullets <> gSpriteNumbers[IMAGE_BLUE_BULLET] + gSpriteNumbers[IMAGE_RED_BULLET] then errorcode = 1
	if errorcode
		do
			print("Validation error code: "+str(errorcode))
			sync()
		loop
	endif
	// End Validation code

	SetOrientationAllowed(1, 1, 0, 0)

	dev$ = GetDeviceBaseName()
	if dev$ = "ios" or dev$ = "android" 
		SetSyncRate(cSyncRateMobile, 0)
	else
		// on Win/Mac/Linux see if it's the 1st time running and get sane defaults
		if not GetFileExists("/window_position.dat")
			// Get the largest screen in aspect ratio that will fit the device
			// after leaving some room for a title bar, task bar, etc
			w = (GetMaxDeviceWidth() * cRoomForTitle) / cOriginalXCells
			h = (GetMaxDeviceHeight() * cRoomForTitle) / cOriginalYCells
			if w < h then scale = w else scale = h
			SetWindowSize(cOriginalXCells*scale, cOriginalYCells*scale, 0)
			SetWindowPosition((GetMaxDeviceWidth()-GetDeviceWidth())/2.0, 0)
		endif
		SetSyncRate(cSyncRate, 0)
		SetWindowAllowResize(1)
	endif

	// set display properties
	SetDisplayAspect(cOriginalXCellsF/cOriginalYCellsF) ` Use the % system
	SetScissor(0, 0, 0, 0)
	UseNewDefaultFonts(0)

	// set window properties
	SetWindowTitle(gStrings$[TEXT_GALAGA])
	SetClearColor(0, 0, 0)

	// Use this to see the collision shapes
	//SetPhysicsDebugOn()
	
	// load atlas images
	imageOffset = 0
	for i = 0 to IMAGE_END_ATLAS_IMAGES
		spritesNeeded = gSpriteNumbers[i]
		if not spritesNeeded
			gImages[i] = LoadImage(gImageNames$[i])
			lastImage = i
		else
			gImages[i] = LoadSubImage(gImages[lastImage], gImageNames$[i])
			
			width = GetImageWidth(gImages[i])
			height = GetImageHeight(gImages[i])

			if gSpriteAnimFrames[i] then width = width / gSpriteAnimFrames[i]

			w2c = ((width >> 1) * cColScaleW)/cOriginalCellResolution
			h2c = ((height >> 1) * cColScaleH)/cOriginalCellResolution

			for j = 1 to spritesNeeded
				sprite = CreateSprite(gImages[i])
				// Make the collision boxes smaller - in the original you can also shoot through the wings
				SetSpriteShapeBox(sprite, -w2c, -h2c, w2c, h2c, 0)
				SetSpriteSize(sprite, width/cOriginalCellResolution, -1)
				SetSpriteVisible(sprite, 0)
				if gSpriteAnimFrames[i] 
					SetSpriteAnimation(sprite, width, height, gSpriteAnimFrames[i])
					PlaySprite(sprite, 2, 1)
				endif
				
				gSprites.insert(sprite)
			next j
			gSpriteOffsets[i] = imageOffset
			inc imageOffset, spritesNeeded
		endif
	next i

	// Namco sprite is special
	SetSpritePositionByOffset(gSprites[gSpriteOffsets[IMAGE_NAMCO]], 50, 91)

	// Non-atlas images
	gImages[IMAGE_WHITE_IMAGE] = CreateImageColor(255, 255, 255, 255)
	gImages[IMAGE_FONT] = LoadImage("font.png")
	SetTextDefaultFontImage(gImages[IMAGE_FONT])
	

	// make text and assign colors
	for i = 0 to TEXT_END_GAME_TEXT
		gText[i] = CreateText(gStrings$[i])
		SetTextSize(gText[i], cTextSize)
		SetTextColor(gText[i], gColors[gStringsColors[i]].red, gColors[gStringsColors[i]].green, gColors[gStringsColors[i]].blue, 255)
		SetTextVisible(gText[i], 0)
		SetTextPosition(gText[i], gStringsPosX[i], gStringsPosY[i])
	next i

	for i = 1 to gSpriteNumbers[IMAGE_PLAYER]-1
		sprite = gSprites[gSpriteOffsets[IMAGE_PLAYER]+i]
		SetSpritePosition(sprite, (2*(i-1)/cOriginalXCellsF)*100.0, ((cOriginalYCellsF-3)/cOriginalYCellsF)*100.0) ` player is 2 tiles wide but offset is 50%
	next i
	
	// load the audio files
	for i = 0 to SOUND_END_SOUNDS
		gSounds[i] = LoadSound(gSoundNames$[i])
	next i

	// set up the player bullets
	for i = 0 to gSpriteNumbers[IMAGE_BLUE_BULLET]-1
		sprite = gSprites[gSpriteOffsets[IMAGE_BLUE_BULLET]+i]
		gBullets[i].spr = sprite
		gBullets[i].isa = IMAGE_BLUE_BULLET
		gBullets[i].plan = PLAN_DEAD
	next i

	// set up the enemy bullets
	for i = 0 to gSpriteNumbers[IMAGE_RED_BULLET]-1
		sprite = gSprites[gSpriteOffsets[IMAGE_RED_BULLET]+i]
		gBullets[gSpriteNumbers[IMAGE_BLUE_BULLET]+i].spr = sprite
		gBullets[gSpriteNumbers[IMAGE_BLUE_BULLET]+i].isa = IMAGE_RED_BULLET
		gBullets[gSpriteNumbers[IMAGE_BLUE_BULLET]+i].plan = PLAN_DEAD
	next i
	
	// Set up the global variables
	for i = 0 to gHighScores.length
		gHighScores[i].name$ = gStrings$[TEXT_N_N+i]
		gHighScores[i].score = val(gStrings$[TEXT_SCORE_1+i])
		SetTextString(gText[TEXT_SCORE_1+i], FormatValue(gHighScores[i].score))
	next i
	gStarSpeed# = cStarMaxSpeed
	gNumCredits = 0
	
	SetStates(cStateAttractLoop, cASTitle)

endfunction

function SetupJoystick()

	gVirtualStick = 0

	// For good measure
	CompleteRawJoystickDetection()

	dev$ = GetDeviceBaseName()
	// on devices, add a virtual joystick
	if "ios" = dev$ or "android" = dev$
		gVirtualStick = 1
		AddVirtualJoystick(VJ_Stick, 80, GetVirtualHeight()-5, 10)
		AddVirtualButton(VB_Fire, 20, GetVirtualHeight()-5, 10)
		AddVirtualButton(VB_CoinDrop, 50, GetVirtualHeight()-5, 10)
		AddVirtualButton(VB_1P_START, 20, GetVirtualHeight()-9, 10)
		AddVirtualButton(VB_2P_START, 80, GetVirtualHeight()-9, 10)
		
		SetVirtualButtonImageUp(VB_CoinDrop, gImages[IMAGE_COIN_DROP])
		SetVirtualButtonImageUp(VB_1P_START, gImages[IMAGE_1P_START])
		SetVirtualButtonImageUp(VB_2P_START, gImages[IMAGE_2P_START])
		SetVirtualButtonImageUp(VB_Fire, gImages[IMAGE_FIRE_UP])
		SetVirtualButtonImageDown(VB_Fire, gImages[IMAGE_FIRE_DOWN])

		SetVirtualJoystickVisible(VJ_Stick, 0)
		SetVirtualButtonVisible(VB_CoinDrop, 1)
		SetVirtualButtonVisible(VB_1P_START, 0)
		SetVirtualButtonVisible(VB_2P_START, 0)
		SetVirtualButtonVisible(VB_Fire, 0)
	else
		// TODO - Make a proper joystick selection page
		//   with ability to select functions on buttons
		// find the first real joystick if there is one
		gActualJoyStick = 0
		for i = 1 to 7
			if GetRawJoystickExists(i)
				gActualJoyStick = i
				exit
			endif
		next i
	endif

endfunction

//------------------------------------------------------------------------------
function SetupPlayer(playerNum)
	
	gPlayers[playerNum].ships[0].x# = 50
	gPlayers[playerNum].ships[0].y# = ((cOriginalYCellsF-3.0)/cOriginalYCellsF)*100.0
	
	// TODO - remove next 2 lines eventually
	gPlayers[playerNum].ships[1].x# = 50+GetSpriteWidth(gSprites[gSpriteOffsets[IMAGE_PLAYER]])
	gPlayers[playerNum].ships[1].y# = ((cOriginalYCellsF-3.0)/cOriginalYCellsF)*100.0
	
	gPlayers[playerNum].ships[0].plan = PLAN_INIT
	gPlayers[playerNum].ships[1].plan = PLAN_INIT
	
	gPlayers[playerNum].ships[0].spr = gSprites[gSpriteOffsets[IMAGE_PLAYER]]
	gPlayers[playerNum].ships[1].spr = gSprites[gSpriteOffsets[IMAGE_PLAYER]+1]
	SetSpritePositionByOffset(gPlayers[playerNum].ships[0].spr, gPlayers[playerNum].ships[0].x#, gPlayers[playerNum].ships[0].y#)
	// TODO remove next line eventually
	SetSpritePositionByOffset(gPlayers[playerNum].ships[1].spr, gPlayers[playerNum].ships[1].x#, gPlayers[playerNum].ships[1].y#)
	gPlayers[playerNum].score = 0
	gPlayers[playerNum].lives = 2 // 15 max
	gPlayers[playerNum].stage = 1
	gPlayers[playerNum].enemiesAlive = 0
	gPlayers[playerNum].shotsFired = 0
	gPlayers[playerNum].hits = 0
	
	SetTextString(gText[gScoreIndex[playerNum]], "     00")

	// Set the # of lives sprites to be in a row at the bottom
	p# = 1
	for i = 2 to gSpriteNumbers[IMAGE_PLAYER]-1
		sprite = gSprites[gSpriteOffsets[IMAGE_PLAYER]+i]
		SetSpriteScale(sprite, 0.85, 0.85)
		SetSpritePosition(sprite, p#, ((cOriginalYCellsF-2)/cOriginalYCellsF)*100.0) ` player is 2 tiles high
		inc p#, GetSpriteWidth(sprite)
	next i


	for i = gSpriteOffsets[IMAGE_BADGE1] to gSpriteOffsets[IMAGE_BADGE50]+gSpriteNumbers[IMAGE_BADGE50]
		sprite = gSprites[i]
		SetSpriteScale(sprite, 0.85, 0.85)
	next i

	// Make sure all bullets are dead
	for i = 0 to cMaxBullets
		gBullets[i].plan = PLAN_DEAD
	next i

	// Make sure all enemies are dead from last game
	for i = 0 to cMaxEnemies
		gEnemies[playerNum, i].plan = PLAN_DEAD
	next i

endfunction

//------------------------------------------------------------------------------
function SetupStageIcons(icons ref as integer[])
	
	badges as integer[5] = [50, 30, 20, 10, 5, 1]
	counts as integer[5] = [ 0,  0,  0,  0, 0, 0]

	stage = gPlayers[gCurrentPlayer].stage
	for i = 0 to badges.Length
		counts[i] = stage / badges[i]
		dec stage, counts[i] * badges[i]
	next i
	
	SetSpriteRangeVisible(gSpriteOffsets[IMAGE_BADGE1], gSpriteOffsets[IMAGE_BADGE50]+gSpriteNumbers[IMAGE_BADGE50], 0)
	
	x# = 99.0
	for i = counts.Length to 0 step -1
		num = counts[i]
		for j = 0 to num-1
			sprite = gSprites[gSpriteOffsets[IMAGE_BADGE50-i]+j]
			dec x#, GetSpriteWidth(sprite)
			SetSpritePosition(sprite, x#, 100.0 - GetSpriteHeight(sprite))
			icons.insert(sprite)
		next j
	next i
	
endfunction

