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
#constant cNumCharsInFont	80
#constant cFontHeight		34
#constant cFontWidth		32

//------------------------------------------------------------------------------
function UpdateBlock(tiles ref as integer[][][], x0, y0, x1, y1, stage)
	for y = y0 to y1
		for x = x0 to x1
			// and 1 alternate with 0 = totally random
			if stage = 0
				character = random(1, cNumCharsInFont)
			// 1 shows a set character
			elseif stage = 1
				character = tiles[y, x, 1]
			// random characters but mostly white squares
			elseif stage = 2
				if random(1, 5) = 5 then character = random(1, cNumCharsInFont) else character = 80
			// mostly white squares with some random characters and changes along a diagonal
			elseif stage = 3
				if x +random(-3, 3) = y and random(1, 5) = 5 then character = random(1, cNumCharsInFont) else character = -1
			// mostly white squares with some blocks changing betwene characters and colors
			elseif stage = 4
				if tiles[y, x, 2] = 5 then character = random(1, cNumCharsInFont) else character = 80
			endif
			
			if stage < 2
				if character >= 62
					SetSpriteColor(tiles[y, x, 0], 190, 190, 190, 255)
				else
					SetSpriteColor(tiles[y, x, 0], 0, 224, 196, 255)
				endif
			else
				if character <> -1
					if character = 80
						SetSpriteColor(tiles[y, x, 0], 190, 190, 190, 255)
					else
						SetSpriteColor(tiles[y, x, 0], Random(50, 255), Random(50, 255), Random(50, 255), 255)
					endif
				endif
			endif
			
			// if the character is -1 then leave the block unchanged (stage 3)
			if character <> -1 
				PlaySprite(tiles[y, x, 0], 0, 1, character, character) 
			endif
			
		next x
	next y
endfunction

//------------------------------------------------------------------------------
function MemCheck()
	tiles as integer[cOriginalYCells, cOriginalXCells, 2]
	
	// Make sprites for tiles
	for y = 0 to cOriginalYCells-1
		for x = 0 to cOriginalXCells-1
			tiles[y, x, 0] = CreateSprite(gImages[IMAGE_FONT])
			tiles[y, x, 1] = random(1, cNumCharsInFont)
			tiles[y, x, 2] = random(1, 5)
			SetSpriteAnimation(tiles[y, x, 0], cFontWidth, cFontHeight, cNumCharsInFont)
			SetSpriteSize(tiles[y, x, 0], -1, 3.0)
			SetSpritePosition(tiles[y, x, 0], x*(100.0/cOriginalXCells), y*(100.0/cOriginalYCells))
		next x
	next y

	// for the difefrent stages of the ram check
	flipflop = 0
	stage = flipflop
	
	// fill the screen with tiles
	UpdateBlock(tiles, 0, 0, cOriginalXCells-1, cOriginalYCells-1, stage)

	ResetTimer()
	dt# = Timer()
	
	// for 6 seconds to 4 1.5 second "checks"
	while dt# < 4.0
		sync()
		sleep(50)

		// 1 & 2 have green and white random-ish stuff that moves
		// in blocks
		if stage < 2
			xp = random(cOriginalXCells/3, cOriginalXCells-3)
			UpdateBlock(tiles, xp, 2, cOriginalXCells-1, cOriginalYCells-1, stage)
			UpdateBlock(tiles, 0, cOriginalYCells-3, cOriginalXCells-1, cOriginalYCells-1, stage)
			sync()
			sleep(50)
			UpdateBlock(tiles, 0, 2, xp-1, cOriginalYCells-3, stage)
			UpdateBlock(tiles, 0, 0, cOriginalXCells-1, 1, stage)
			flipflop = 1 - flipflop
			stage = flipflop
		else
			UpdateBlock(tiles, 0, 0, cOriginalXCells-1, cOriginalYCells-1, stage)
		endif

		// Tick stages over
		dt# = Timer()
		if dt# > 1.0 then stage = 2
		if dt# > 2.0 then stage = 3
		if dt# > 3.0 then stage = 4
	endwhile

	// Delete tile sprites
	for y = 0 to cOriginalYCells-1
		for x = 0 to cOriginalXCells-1
			DeleteSprite(tiles[y, x, 0])
		next x
	next y
	
endfunction

//------------------------------------------------------------------------------
function RamOK()
	text as integer[9]
	posx as integer[9] = [80, 80, 80, 80, 80, 80, 80, 90, 90, 90]
	posy as integer[9] = [90, 85, 80, 75, 70, 65, 60, 50, 45, 40]
	
	// Show RAM OK
	text[0] = CreateText(gStrings$[TEXT_RAM_OK])
	SetTextPosition(text[0], 40, 10)
	SetTExtSize(text[0], cTextSize)
	SetTextColor(text[0], 255, 255, 255, 255)
	sync()
	sleep(250)
	DeleteText(text[0])
	
	// Show the status, but upside - down
	for i = 0 to 9
		pointIndex = i+TEXT_RAM_OK
		text[i] = CreateText(gStrings$[pointIndex])
		SetTextAngle(text[i], 180)
		SetTExtSize(text[i], cTextSize)
		SetTextColor(text[i], 255, 255, 255, 255)
		SetTextPosition(text[i], posx[i], posy[i])
	next i

	// Hide sound
	SetTextVisible(text[TEXT_SOUND_00-TEXT_RAM_OK], 0)
	sync()
	sleep(250)
	
	// Show Sound
	SetTextVisible(text[TEXT_SOUND_00-TEXT_RAM_OK], 1)
	sync()
	sleep(250)

	for i = 0 to 9
		DeleteText(text[i])
	next i
	
endfunction

//------------------------------------------------------------------------------
function ShowGrid()
	PlaySound(gSounds[SOUND_PLAYER_DIE])
	vh# = GetVirtualHeight()
	vw# = GetVirtualWidth()
	dw# = GetDeviceWidth()
	dh# = GetDeviceHeight()
	sw# = vw# / dw#
	sh# = vh# / dh#

	for y = 0 to (cOriginalYCells/2)
		p0# = y*(99.6/(cOriginalYCellsF/2.0))
		p1# = p0#+0.4
		for y1# = p0# to p1# step sh#
			DrawLine(0.0, y1#, 100.0, y1#, 255, 255, 255)
		next y1#
	next y
	for x = 0 to (cOriginalXCells/2)
		p0# = x*(99.6/(cOriginalXCellsF/2.0))
		p1# = p0#+0.4
		for x1# = p0# to p1# step sw#
			DrawLine(x1#, 0.0, x1#, 100.0, 255, 255, 255)
		next x1#
	next x
	sync()
	sleep(1500)
endfunction

//------------------------------------------------------------------------------
function StartupSequence()


	// Flash memory check sequence
	MemCheck()
	
	// RAM OK text sequence
	RamOK()
	
	// Grid seguence
	ShowGrid()
	
endfunction
