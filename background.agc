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
function MakeStars(count)
	while count
		aStar as TypeStar
		aStar.ttl# = Random(200, 400) / 1000.0
		aStar.ct# = aStar.ttl#
		aStar.spr = CreateSprite(gImages[IMAGE_WHITE_IMAGE])
		SetSpriteDepth(aStar.spr, 100)
		SetSpriteSize(aStar.spr, cStarWidth, cStarHeight)
		SetSpriteColor(aStar.spr, Random(20, 255), Random(20, 255), Random(20, 255), 255)
		SetSpritePosition(aStar.spr, Random(0, cDisplayWidth), cDisplayHeight*.05 + Random(0, cDisplayHeight*0.89))
		SetSpriteVisible(aStar.spr, Random(0, 1))
		gStars.insert(aStar)
		dec count
	endwhile
endfunction

//------------------------------------------------------------------------------
function ProcessStars()
	numStars = gStars.length
	dygdt# = gStarSpeed# * gDT#
	for i = 0 to numStars
		gStars[i].ct# = gStars[i].ct# - gDT#
		if gStars[i].ct# < 0
			SetSpriteVisible(gStars[i].spr, 1-GetSpriteVisible(gStars[i].spr))
			gStars[i].ct# = gStars[i].ttl#
		endif
		sy# = GetSpriteY(gStars[i].spr) + dygdt#
		if sy# > cDisplayHeight*0.94
			sy# = sy# - cDisplayHeight*0.89
		endif
		SetSpritePosition(gStars[i].spr, GetSpriteX(gStars[i].spr), sy#)
	next i
endfunction
