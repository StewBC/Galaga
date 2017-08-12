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
function CleanupEffects()
	done as integer[]
	for i = 0 to gRunningEffects.length
		dec gRunningEffects[i].ttl#, gDT#
		if gRunningEffects[i].ttl# < 0
			SetSpriteVisible(gRunningEffects[i].spr, 0)
			done.insert(i)
		endif
	next i
	
	done.sort()
	for i = done.length to 0 step -1
		gRunningEffects.remove(done[i])
	next i
	
endfunction

//------------------------------------------------------------------------------
function RunBeamAction(enemy ref as Object)
	
	sprite = gSprites[gSpriteOffsets[IMAGE_BEAM]]
	select gMakeBeam

		// 2 - Position/Show beam
		case BEAM_POSITION:
			SetSpritePositionByOffset(sprite, enemy.x#, enemy.y#+18.0)
			gBeamSize#[0] = GetSpriteX(sprite)
			gBeamSize#[1] = GetSpriteY(sprite)
			gBeamSize#[2] = gBeamSize#[0] + GetSpriteWidth(sprite)
			gBeamSize#[3] = gBeamSize#[1] + 0.1
			gBeamSize#[4] = gBeamSize#[1] + GetSpriteHeight(sprite)
			SetSpriteScissor(sprite, gBeamSize#[0], gBeamSize#[1], gBeamSize#[2], gBeamSize#[3])
			SetSpriteVisible(sprite, 1)
			inc gMakeBeam
		endcase
		
		// 3 - Open up the beam
		case BEAM_OPENING: 
			inc gBeamSize#[3], cBeamOpenSpeed
			if gBeamSize#[3] >= gBeamSize#[4]
				inc gMakeBeam
				gBeamSize#[3] = gBeamSize#[4]
				enemy.timer# = cBeamHoldDuration
			endif
			SetSpriteScissor(sprite, gBeamSize#[0], gBeamSize#[1], gBeamSize#[2], gBeamSize#[3])
		endcase
		
		// 4 - Hold beam open
		case BEAM_HOLD:
			dec enemy.timer#, gDT#
			if gCapture or enemy.timer# < 0.0 then inc gMakeBeam
		endcase
		
		// 5 - Close beam down
		case BEAM_CLOSING:
			dec gBeamSize#[3], cBeamOpenSpeed
			if gBeamSize#[3] <= gBeamSize#[1] + 0.1
				SetSpriteVisible(sprite, 0)
				enemy.dy# = 103.0 - enemy.y#
				//enemy.nextPlan = PLAN_GOTO_GRID
				enemy.plan = PLAN_DIVE_ATTACK
				SetupEnemyVelocityAndRotation(enemy)
				gMakeBeam = 0
			else
				SetSpriteScissor(sprite, gBeamSize#[0], gBeamSize#[1], gBeamSize#[2], gBeamSize#[3])
			endif
		endcase
		
	endselect

	// Make the collision box the size of the beam at this stage
	hc# = (gBeamSize#[3] - gBeamSize#[1])
	SetSpriteShapeBox(sprite, -GetSpriteOffsetX(sprite), -GetSpriteOffsetY(sprite), GetSpriteWidth(sprite)/2.0, -GetSpriteOffsetY(sprite) + hc#, 0)
	
	if gMakeBeam >= BEAM_OPENING and GetSpriteCollision(sprite, gPlayers[gCurrentPlayer].ships[0].spr)
		gCapture = CAPTURE_PLAYER_TOUCHED
	endif
	
	
endfunction

//------------------------------------------------------------------------------
function AddAttacker(index, position)
	for i = index to gAttackers.length
		if gAttackers[i] = -1 
			gAttackers[i] = position
			//gEnemies[gCurrentPlayer, position].attackIndex = i
			inc gNumAttackers
			// exit j loop as a slot was found
			exit
		endif
	next i
endfunction

//------------------------------------------------------------------------------
function HandleCapture()

	preR# = gPlayers[gCurrentPlayer].ships[0].r#
	if gCapture <= CAPTURE_PLAYER_SPIN
		inc gPlayers[gCurrentPlayer].ships[0].r#, cCaptureSpinSpeed * gDT#
		SetSpriteAngle(gPlayers[gCurrentPlayer].ships[0].spr, gPlayers[gCurrentPlayer].ships[0].r#+90)
		// Normalize the angle
		gPlayers[gCurrentPlayer].ships[0].r# = GetSpriteAngle(gPlayers[gCurrentPlayer].ships[0].spr)-90
	endif

	select gCapture
		
		case CAPTURE_PLAYER_TOUCHED:
			beamX# = GetSpriteXByOffset(gSprites[gSpriteOffsets[IMAGE_BEAM]])
			offsetX# = GetSpriteXByOffset(gPlayers[gCurrentPlayer].ships[0].spr)
			if offsetX# - 1.0 < beamX#
				inc offsetX#, cPlayerCaptureSpeed * gDT#
			elseif offsetX# + 1.0 > beamX#
				dec offsetX#, cPlayerCaptureSpeed * gDT#
			else
				offsetX# = beamX#
			endif
				
			gPlayers[gCurrentPlayer].ships[0].x# = offsetX# - GetSpriteOffsetX(gPlayers[gCurrentPlayer].ships[0].spr)
			
			if gPlayers[gCurrentPlayer].ships[0].y# > 70.0 
				dec gPlayers[gCurrentPlayer].ships[0].y#, cPlayerCaptureSpeed * gDT#
			else
				inc gCapture
			endif
		
			SetSpritePositionByOffset(gPlayers[gCurrentPlayer].ships[0].spr, offsetX#, gPlayers[gCurrentPlayer].ships[0].y#)
		endcase
		
		case CAPTURE_PLAYER_DISPLAY:
			SetTextVisible(gText[TEXT_FIGHTER_CAPTURED], 1)
			// TODO: Get the sound and add it to project and then this line
			//PlaySound(gSounds[SOUND_CAPTURE_PLAYER))
			gRotationCount# = 0.0
			inc gCapture
		endcase
		
		case CAPTURE_PLAYER_SPIN:
			inc gRotationCount#, cCaptureSpinSpeed * gDT#
			if gRotationCount# >= 720.0 and (GetSpriteAngle(gPlayers[gCurrentPlayer].ships[0].spr)-90) - preR# < 0
				gPlayers[gCurrentPlayer].ships[0].r# = 0.0
				SetSpriteAngle(gPlayers[gCurrentPlayer].ships[0].spr, gPlayers[gCurrentPlayer].ships[0].r#)
				gPlayers[gCurrentPlayer].ships[0].timer# = 1.0
				inc gCapture
			endif
		endcase
		
		case CAPTURE_PLAYER_HOLD:
			dec gPlayers[gCurrentPlayer].ships[0].timer#, gDT#
			if gPlayers[gCurrentPlayer].ships[0].timer# < 0.0
				SetTextVisible(gText[TEXT_FIGHTER_CAPTURED], 0)
				inc gCapture
			endif
		endcase
		
		case CAPTURE_PLAYER_HOME:
			// TODO: Fix the capture so it's a real capture
			gPlayers[gCurrentPlayer].ships[0].y# = 91.0
			SetSpritePosition(gPlayers[gCurrentPlayer].ships[0].spr, gPlayers[gCurrentPlayer].ships[0].x#, gPlayers[gCurrentPlayer].ships[0].y#)
			// TODO: Hacked in but causes all kinds of grief - Fix this
			// issues - stages don't tick over upon death; boss will still beam when there are 2 players.
			gPlayers[gCurrentPlayer].ships[1].plan = PLAN_ALIVE
			SetSpriteVisible(gPlayers[gCurrentPlayer].ships[1].spr,1)
			gCapture = 0
		endcase
		
	endselect
endfunction

//------------------------------------------------------------------------------
function HandlePlayer()
	
	// Flash the label for the player that's up
	inc gFlashTimer#, gDT#
	if gFlashTimer# >= cFlashTime 
		index = gText[gFlashIndex[gCurrentPlayer]]
		SetTextVisible(index, 1-GetTextVisible(index))
		gFlashTimer# = 0.0
	endif
	
	// if not a or not b then c will evaluate both a and b in AGK, even if a is false
	if not gPlayers[gCurrentPlayer].ships[0].spr then exitFunction
	if not GetSpriteVisible(gPlayers[gCurrentPlayer].ships[0].spr) then exitFunction
	
	// if the player is being captured
	if gCapture
		HandleCapture()
	else
		
		// Handle direction input
		if gDirection
			if gPlayers[gCurrentPlayer].ships[0].plan && PLAN_ALIVE
				newx# = gPlayers[gCurrentPlayer].ships[0].x#
				if gPlayers[gCurrentPlayer].ships[1].plan && PLAN_ALIVE
					width# = GetSpriteWidth(gPlayers[gCurrentPlayer].ships[1].spr)
				else
					width# = 0
				endif
				inc newx#, gDirection * cPlayerMovementSpeed * gDT#
				offsetX# = GetSpriteOffsetX(gPlayers[gCurrentPlayer].ships[0].spr)
				if newx# - offsetX# < 0
					newx# = offsetX#
				elseif newx# + offsetX# >= 100.0 - width#
					newx# = 100.0 - width# - offsetX#
				endif
				gPlayers[gCurrentPlayer].ships[0].x# = newx#
				SetSpritePositionByOffset(gPlayers[gCurrentPlayer].ships[0].spr, newx#, gPlayers[gCurrentPlayer].ships[0].y#)

				if gPlayers[gCurrentPlayer].ships[1].plan = PLAN_ALIVE
					gPlayers[gCurrentPlayer].ships[1].x# = newx# + width#
					SetSpritePositionByOffset(gPlayers[gCurrentPlayer].ships[1].spr, gPlayers[gCurrentPlayer].ships[1].x#, gPlayers[gCurrentPlayer].ships[1].y#)
				endif
			endif
		endif
	endif

	// don't allow firing before play starts
	if gSubState < cPSPlay then exitFunction
	
	// Fire if not 2 bullets/ship onscreen already
	if gFire
		if not gBullets[0].plan 
			bpointIndex = 0
		elseif not gBullets[1].plan
			bpointIndex = 1
		else
			bpointIndex = -1
		endif
		
		if bpointIndex >= 0
			inc gPlayers[gCurrentPlayer].shotsFired
			PlaySound(gSounds[SOUND_PLAYER_SHOOT])
			sprite = gBullets[bpointIndex].spr
			gBullets[bpointIndex].plan = PLAN_ALIVE
			gBullets[bpointIndex].x# = gPlayers[gCurrentPlayer].ships[0].x# - (GetSpriteOffsetX(sprite)/2.0)
			gBullets[bpointIndex].y# = gPlayers[gCurrentPlayer].ships[0].y# 
			SetSpritePositionByOffset(sprite, gBullets[bpointIndex].x#, gBullets[bpointIndex].y#)
			SetSpriteVisible(sprite, 1)
			
			if gPlayers[gCurrentPlayer].ships[1].plan = PLAN_ALIVE
				inc gPlayers[gCurrentPlayer].shotsFired
				inc bpointIndex, 2
				sprite = gBullets[bpointIndex].spr
				gBullets[bpointIndex].plan = PLAN_ALIVE
				gBullets[bpointIndex].x# = gBullets[bpointIndex-2].x# + GetSpriteWidth(gPlayers[gCurrentPlayer].ships[0].spr)
				gBullets[bpointIndex].y# = gBullets[bpointIndex-2].y#
				SetSpritePositionByOffset(sprite, gBullets[bpointIndex].x#, gBullets[bpointIndex].y#)
				SetSpriteVisible(sprite, 1)
			endif
		endif
	endif
endfunction

//------------------------------------------------------------------------------
function EnemyFireAShot(enemy ref as Object)
	if gBullets[gBulletIndex].plan = PLAN_DEAD
		gBullets[gBulletIndex].plan = PLAN_ALIVE
		gBullets[gBulletIndex].x# = enemy.x#
		gBullets[gBulletIndex].y# = enemy.y#
		dx# = enemy.x# - gPlayers[gCurrentPlayer].ships[0].x#
		dy# = enemy.y# - gPlayers[gCurrentPlayer].ships[0].y#

		// Limit the vertical "slide" of the bullets.  This is really
		// tan(angle)*y but tan(45) = 1 so it reduces nicely
		//Clamp(dy#, -dy#, dx#)
		if dx# > -dy# then dx# = -dy#
		if dx# < dy# then dx# = dy#

		gBullets[gBulletIndex].distance# = sqrt(dx#^2 + dy#^2)
		r# = atan2(dy#, dx#)
		
		// the velocity along the vectors
		gBullets[gBulletIndex].vx# = cBulletSpeedEnemy * cos(r#)
		gBullets[gBulletIndex].vy# = cBulletSpeedEnemy * sin(r#)

		gBullets[gBulletIndex].dx# = dx#
		gBullets[gBulletIndex].dy# = dy#

		SetSpritePositionByOffset(gBullets[gBulletIndex].spr, gBullets[gBulletIndex].x#, gBullets[gBulletIndex].y#)
		SetSpriteVisible(gBullets[gBulletIndex].spr, 1)
		inc gBulletIndex
		if gBulletIndex >= cMaxBullets then gBulletIndex = gSpriteNumbers[IMAGE_BLUE_BULLET]
	endif
endfunction

//------------------------------------------------------------------------------
function MoveBullets()
	for i = 0 to cMaxBullets
		if gBullets[i].plan = PLAN_ALIVE
			sprite = gBullets[i].spr
			if i < gSpriteNumbers[IMAGE_BLUE_BULLET]
				// TODO: Player bullets only travvel in astraight line but
				// when the player is being beamed, the bullets can go at an
				// angle - add support for that
				dec gBullets[i].y#, cBulletSpeed * gDT#
				if(gBullets[i].y# < (1/cOriginalYCellsF)*100.0)
					gBullets[i].plan = PLAN_DEAD
					SetSpriteVisible(sprite, 0)
				endif
			else

				tx# = gDT# * gBullets[i].vx#
				ty# = gDT# * gBullets[i].vy#
				
				// Update the position
				dec gBullets[i].x#, tx#
				dec gBullets[i].y#, ty#

				if(gBullets[i].y# > ((cOriginalYCellsF-2)/cOriginalYCellsF)*100.0)
					gBullets[i].plan = PLAN_DEAD
					SetSpriteVisible(sprite, 0)
				else
					if gPlayers[gCurrentPlayer].ships[0].plan = PLAN_ALIVE and GetSpriteCollision(sprite, gPlayers[gCurrentPlayer].ships[0].spr)
						KillPlayer(gPlayers[gCurrentPlayer].ships[0])
						gBullets[i].plan = PLAN_DEAD
						SetSpriteVisible(sprite, 0)
						continue
					endif

					if gPlayers[gCurrentPlayer].ships[1].plan = PLAN_ALIVE 
						if GetSpriteCollision(gBullets[i].spr, gPlayers[gCurrentPlayer].ships[1].spr)
							KillPlayer(gPlayers[gCurrentPlayer].ships[1])
							gBullets[i].plan = PLAN_DEAD
							SetSpriteVisible(sprite, 0)
						elseif gPlayers[gCurrentPlayer].ships[0].plan = PLAN_DEAD
							// if player 1 is alive and 0 dead, assign 1 to 0 so 0 is always the 1 that's alive
							gPlayers[gCurrentPlayer].ships[0] = gPlayers[gCurrentPlayer].ships[1]
							gPlayers[gCurrentPlayer].ships[1].plan = PLAN_DEAD
						endif
					endif
				endif
			endif
			SetSpritePositionByOffset(sprite, gBullets[i].x#, gBullets[i].y#)
		endif
	next i
endfunction

//------------------------------------------------------------------------------
function IncrementScore(byValue as integer)
	
	oldScore = gPlayers[gCurrentPlayer].score
	newScore = oldScore + byValue
	
	// under 1M points, give life at 20k and every 70k
	if newScore < 1000000
		if oldScore < 20000 and newScore >= 20000 or (oldScore / 70000) < (newScore / 70000)
			inc gPlayers[gCurrentPlayer].lives
			ShowLivesIcons()
			// TODO - Play the sound for extra life here
		endif		
	endif
	gPlayers[gCurrentPlayer].score = newScore
	
	SetTextString(gText[gScoreIndex[gCurrentPlayer]], FormatValue(gPlayers[gCurrentPlayer].score))
	if gPlayers[gCurrentPlayer].score > gHighScores[0].score
		SetTextString(gText[TEXT_20000], FormatValue(gPlayers[gCurrentPlayer].score))
	endif
	
endfunction

//------------------------------------------------------------------------------
function KillPlayer(player ref as Object)

	player.plan = PLAN_DEAD
	PlaySound(gSounds[SOUND_PLAYER_DIE])

	// Hide the player ship
	SetSpriteVisible(player.spr, 0)
	
	// Stop the StarField
	gStarSpeed# = 0.0
	
	// Play an explosion
	sprite = gSprites[gSpriteOffsets[IMAGE_PLAYER_EXPLOSION]]
	SetSpritePositionByOffset(sprite, player.x#, player.y#)
	SetSpriteVisible(sprite, 1)
	PlaySprite(sprite, cPlayerExplosionFPS, 0)

	// Add explosion to effects lidt for cleanup
	effect as TypeStar
	effect.spr = sprite 
	effect.ttl# = gSpriteAnimFrames[IMAGE_PLAYER_EXPLOSION] * (1.0/(cPlayerExplosionFPS-1))
	gRunningEffects.Insert(effect)

	SetSpriteVisible(player.spr, 0)
endfunction

//------------------------------------------------------------------------------
function KillEnemy(enemy ref as Object)

	// Kill the enemy
	SetSpriteVisible(enemy.spr, 0)
	inc gEnemiesKilledThisStage
	inc gPlayers[gCurrentPlayer].hits
	dec gPlayers[gCurrentPlayer].enemiesAlive
	kind = enemy.isa
	
	// TODO: Make sure the beam can just disappear - this may need
	// to be fixed so the beam retracts when the enemy dies
	if enemy.plan = PLAN_BEAM_ACTION 
		SetSpriteVisible(gSprites[gSpriteOffsets[IMAGE_BEAM]], 0)
		gMakebeam = BEAM_OFF
	endif

	enemy.plan = PLAN_DEAD
	PlaySound(gSounds[gKillSound[kind]])

	// Standing in grid gives one score, flying another
	if enemy.plan = PLAN_GRID
		IncrementScore(gScoreSheet[0, kind])
	else
		IncrementScore(gScoreSheet[1, kind])
	endif
	
	// If on an attack run, take it off
	if enemy.attackIndex >= 0
		gAttackers[enemy.attackIndex] = -1
		dec gNumAttackers
	endif
	
	// Play an explosion
	sprite = gSprites[gSpriteOffsets[IMAGE_EXPLOSION]+gNextExplosion]
	inc gNextExplosion
	if gNextExplosion = gSpriteNumbers[IMAGE_EXPLOSION] then gNextExplosion = 0
	SetSpritePositionByOffset(sprite, enemy.x#, enemy.y#)
	SetSpriteVisible(sprite, 1)
	PlaySprite(sprite, cEnemyExplosionFPS, 0)
	
	// Add explosion to effects list for cleanup
	effect as TypeStar
	effect.spr = sprite 
	effect.ttl# = gSpriteAnimFrames[IMAGE_EXPLOSION] * (1.0/cEnemyExplosionFPS)
	gRunningEffects.Insert(effect)
	
endfunction

//------------------------------------------------------------------------------
function CheckEnemyDead(enemy ref as Object)
	// Check if enemy was shot
	for j = 0 to 3
		if gBullets[j].plan = PLAN_ALIVE
			if GetSpriteCollision(enemy.spr, gBullets[j].spr)
				gBullets[j].plan = PLAN_DEAD
				SetSpriteVisible(gBullets[j].spr, 0)

				// Green Commanders become blue, they don't die yet
				if enemy.isa = IMAGE_BOSS_GREEN
					// Hide the green
					SetSpriteVisible(enemy.spr, 0)
					enemy.isa = IMAGE_BOSS_BLUE
					// enable the blue
					enemy.spr = gSprites[gSpriteOffsets[IMAGE_BOSS_BLUE]+gSpritesUsed[gCurrentPlayer, IMAGE_BOSS_BLUE]]
					inc gSpritesUsed[gCurrentPlayer, IMAGE_BOSS_BLUE]
					SetSpritePositionByOffset(enemy.spr, enemy.x#, enemy.y#)
					SetSpriteAngle(enemy.spr, enemy.r#)
					SetSpriteVisible(enemy.spr, 1)
					PlaySound(gSounds[SOUND_HIT_BOSS_GREEN])
				else
					KillEnemy(enemy)
				endif
				
				// Don't check other bullets, this enemy is dead
				exitFunction
				
			endif
		endif
	next j
	
	// Check for a collision with the player if not on a spawn path - on a spawn path doesn't collide with the player
	if not (gPlayers[gCurrentPlayer].spawnActive or gCapture)
		if gPlayers[gCurrentPlayer].ships[0].plan = PLAN_ALIVE and GetSpriteCollision(enemy.spr, gPlayers[gCurrentPlayer].ships[0].spr)
			KillEnemy(enemy)
			KillPlayer(gPlayers[gCurrentPlayer].ships[0])
		endif

		if gPlayers[gCurrentPlayer].ships[1].plan = PLAN_ALIVE and GetSpriteCollision(enemy.spr, gPlayers[gCurrentPlayer].ships[1].spr)
			KillEnemy(enemy)
			KillPlayer(gPlayers[gCurrentPlayer].ships[1])
		endif
	endif
endfunction

//------------------------------------------------------------------------------
function SetupEnemyVelocityAndRotation(enemy ref as Object)
	
	// waves come in at the same velocity but attacks speed up
	if not gBugsAttack 
		speed# = cBugTravelSpeed
	else
		speed# = gBugAttackSpeed#
	endif

	// larger circles require higer velocity to come out shoulder to shoulder with the smaller
	// inner circles
	if enemy.plan = PLAN_PATH
		index = enemy.pathIndex >> 1
		if index = aPath_Bottom_Double_Out 
			if enemy.pointIndex > 4 then speed# = speed# * 1.625 else speed# = speed# * 1.1
		elseif index = aPath_Top_Double_Left 
			if enemy.pointIndex > 4 then speed# = speed# * 1.625
		endif
	endif
	
	// How fat to travel and at what angle
	enemy.distance# = sqrt(enemy.dx#^2 + enemy.dy#^2)
	r# = atan2(enemy.dy#, enemy.dx#)
	
	// set the enemy rotation only if it's not about to land in the grid and is not in the grid.
	// That's because the grid causes left/right motion that leads to extreme rotation which
	// this ignores 
	if enemy.plan < PLAN_ORIENT or enemy.plan > PLAN_GRID
		// if the enemy is about to land in the grid, don't change its angle as that looks bad
		if not (abs(enemy.dy#) < 3.0 and enemy.plan = PLAN_GOTO_GRID) then enemy.r# = 90 + r#
	endif
	
	// the velocity along the vectors
	enemy.vx# = speed# * cos(r#)
	enemy.vy# = speed# * sin(r#)

	// point the sprite at the desired direction
	SetSpriteAngle(enemy.spr, enemy.r#)
	
endfunction

//------------------------------------------------------------------------------
function GetGridCoordinate(enemy ref as Object)

	col = gGridCols[enemy.positionIndex]
	row = gGridRows[enemy.positionIndex]

	// add an offset for breathing or left-right walking
	if gPlayers[gCurrentPlayer].gridBreathing
		breatheX# = 1.418 * gPlayers[gCurrentPlayer].gridTimer#
		breatheY# = 0.675 * gPlayers[gCurrentPlayer].gridTimer#
		// these "magic numbers" are calculated.  For example:
		// 10 bees wide is cols 0-9.  9 * 6.7 = 60.3
		// 100% - 60.3% / 2 = 19.85 - that's the "left edge"
		nx# = 19.85 + (col * 6.7) + (col-5)*BreatheX#
		ny# = 15.25 + (row * 4.2) + (row+1)*BreatheY#
	else
		// 19.85 / 2 = 9.925
		walkX# = 9.925 * gPlayers[gCurrentPlayer].gridTimer#
		nx# = (col * 6.7) + walkX#
		ny# = 15.25 + (row * 4.2)
	endif
	// The non-commanders are another 1.6% down from the commanders
	if row then inc ny#, 1.6
	inc ny#, gPlayers[gCurrentPlayer].gridYOffset#

	enemy.dx# = nx# - enemy.x#
	enemy.dy# = ny# - enemy.y#

	SetupEnemyVelocityAndRotation(enemy)
endfunction

//------------------------------------------------------------------------------
function NextPathPoint(enemy ref as Object)

	index = enemy.pathIndex >> 1

	enemy.dx# = gPathDataX[index, enemy.pointIndex]
	enemy.dy# = gPathDataY[index, enemy.pointIndex]
	
	// Odd paths are mirrored
	if enemy.pathIndex && 1 then enemy.dx# = -enemy.dx#

	SetupEnemyVelocityAndRotation(enemy)
endfunction

//------------------------------------------------------------------------------
function SetupFlutterArc(enemy ref as Object)

	// save the current facing angle
	r# = enemy.r# - 90.0
	sign# = gMirror[enemy.positionIndex]
	
	// Get the angle to the player
	dx# = gPlayers[gCurrentPlayer].ships[0].x# - enemy.x#

	// Figure out the flutter pattern (zig/zag/zag)
	if enemy.y# < 65.0
		dy# = 20.0
		if sign# = 0
			dx# = clamp(-80.0, -15.0, dx#)
		else
			dx# = clamp(15.0, 80.0, dx#)
		endif
	else
		dy# = 15.0
		if sign# = 0
			dx# = clamp(15.0, 25.0, dx#)
		else
			dx# = clamp(-25.0, -15.0, dx#)
		endif
	endif
	
	// angle to the destination
	enemy.dr# = atan2(dy#, dx#)
	// rate of turn (increment angle)
	enemy.ir# = (enemy.dr# - r#) * 3.0
	
	// distance to travel (as a line, not on the curve)
	enemy.dx# = dx#
	enemy.dy# = dy#
	SetupEnemyVelocityAndRotation(enemy)
	
	// Restore the sprite angle that was changed in SetupEnemyVelocityAndRotation
	inc r#, 90.0
	enemy.r# = r#
	SetSpriteAngle(enemy.spr, r#)

endfunction

//------------------------------------------------------------------------------
function DecisionOnPostPath(enemy ref as Object)

	// if just launched, set up to shoot, if not a peel-away
	if enemy.positionIndex < 40
		if enemy.pathIndex >> 1 = aPath_Launch
			enemy.timer# = 0.3
			enemy.shotsToFire = 1
		endif
	endif
	
	// Install the nextPlan as the plan
	enemy.plan = enemy.nextPlan
	
	// Do some setup for the plan that follows completing a path
	select enemy.plan
		
		// TODO: - The DIVE_AWAY guys also have PLAN_PATH as the nextPath - Introduce a new state
		case PLAN_PATH:
			// Set enemy on an arc to face the bottom of the screen
			if enemy.isa = IMAGE_BEE
				enemy.pathIndex = PATH_BEE_ATTACK + gMirror[enemy.positionIndex]
				enemy.nextPlan = PLAN_DESCEND
			else
				enemy.pathIndex = PATH_BUTTERFLY_ATTACK + gMirror[enemy.positionIndex]
				enemy.nextPlan = PLAN_FLUTTER
			endif
			NextPathPoint(enemy)
		endcase

		// After the sweep, get to a height where the circle back starts.
		// Need a seperate state because the bees in rows start at difefrent heights so can't make a path
		// that goes down includes the half-circle arc
		case PLAN_DESCEND:
			// Just barely get a wing out the bottom of the screen
			enemy.dx# = 0
			enemy.dy# = 81.0 - enemy.y#
			SetupEnemyVelocityAndRotation(enemy)
		endcase
		
		// after bottom circle, bee must decide to go home or make a full cirlce
		case PLAN_HOME_OR_FULL_CIRCLE:
			if gPlayers[gCurrentPlayer].enemiesAlive < 6 and gPlayers[gCurrentPlayer].ships[0].plan = PLAN_ALIVE
				enemy.plan = PLAN_PATH
				enemy.pathIndex = PATH_BEE_TOP_CIRCLE + 1-gMirror[enemy.positionIndex]
				NextPathPoint(enemy)
				// if full circle, afterwards dive out the bottom
				enemy.nextPlan = PLAN_DIVE_ATTACK
			else
				// Half cirlce was enough, go home
				enemy.plan = PLAN_GOTO_GRID
			endif
		endcase

		// Calculate the flutter arc
		case PLAN_FLUTTER:
			SetupFlutterArc(enemy)
		endcase
		
		// Start an attack dive that ends with the enemy disappearing off the bottom
		case PLAN_DIVE_AWAY_LAUNCH:
			enemy.plan = PLAN_PATH
			enemy.nextPlan = PLAN_DIVE_AWAY
			enemy.pathIndex = PATH_LAUNCH + gMirror[enemy.positionIndex-36]
			NextPathPoint(enemy)
		endcase
		
		// enemy has launched into the dive away, now set the destination and carry on
		// At end, the enemy will simply disapopear (die)
		case PLAN_DIVE_AWAY:
			// Pick a point to dive at - a 20% range around the player
			left = gPlayers[gCurrentPlayer].ships[0].x# - 10.0
			right = gPlayers[gCurrentPlayer].ships[0].x# + 10.0
			Clamp(10, 90, left)
			Clamp(10, 90, right)
			enemy.dx# = Random(left,right) - enemy.x#
			enemy.dy# = 103.0 - enemy.y#
			SetupEnemyVelocityAndRotation(enemy)
		endcase

		case PLAN_DIVE_ATTACK:
			// Send it out the screen
			enemy.dy# = 103.0 - enemy.y#
			enemy.nextPlan = PLAN_GOTO_GRID

			SetupEnemyVelocityAndRotation(enemy)
		endcase
		
		case PLAN_GOTO_BEAM:
			enemy.dx# = gPlayers[gCurrentPlayer].ships[0].x# - enemy.x#
			enemy.dy# = 62.0 - GetSpriteYByOffset(enemy.spr)
			SetupEnemyVelocityAndRotation(enemy)
		endcase
		
		// This is used by the Challange stages
		case PLAN_DEAD:
			dec gPlayers[gCurrentPlayer].enemiesAlive
			SetSpriteVisible(enemy.spr, 0)
		endcase
		
	endselect
	
endfunction

//------------------------------------------------------------------------------
function DecisionTime(enemy ref as Object)
	select enemy.plan 
	
		// Reached the grid
		case PLAN_GOTO_GRID:
			if gPlayers[gCurrentPlayer].ships[0].plan = PLAN_ALIVE and not gPlayers[gCurrentPlayer].spawnActive and gPlayers[gCurrentPlayer].enemiesAlive < 5
				// keep attacking straight away
				// TODO - I think this is actually right at the top of the screen, not here at the grid level
				enemy.plan = PLAN_PATH
				if enemy.isa = IMAGE_BEE
					enemy.pathIndex = PATH_BEE_ATTACK + gMirror[enemy.positionIndex]
					enemy.nextPlan = PLAN_DESCEND
				else
					enemy.pathIndex = PATH_BUTTERFLY_ATTACK + gMirror[enemy.positionIndex]
					enemy.nextPlan = PLAN_FLUTTER
				endif
				NextPathPoint(enemy)
			else
				// rotate into place
				enemy.plan = PLAN_ORIENT
			endif
		endcase
		
		// keep rotating till zero facing, then just be in the grid
		case PLAN_ORIENT:
			// Take out of attack mode when arriving in the grid
			if enemy.attackIndex >= 0
				gAttackers[enemy.attackIndex] = -1
				dec gNumAttackers
				enemy.attackIndex = -1
			endif
			
			if enemy.r# < -cGridOrientAngle
				inc enemy.r#, cGridOrientAngle
			elseif enemy.r# > cGridOrientAngle
				dec enemy.r#, cGridOrientAngle
			else
				enemy.r# = 0.0
				enemy.plan = PLAN_GRID
			endif
		endcase

		// end of a point in the path, maybe the end of the path
		case PLAN_PATH:
			inc enemy.pointIndex
			
			// go to next path point unless this was the last, then
			// go to the next plan in DecisionOnPostPath
			if enemy.pointIndex <= gPathDataX[enemy.pathIndex>>1].length
				NextPathPoint(enemy)
			else
				enemy.pointIndex = 0
				// Activate nextPlan and set up paramaters to run that plan
				DecisionOnPostPath(enemy)
			endif
			
		endcase
		
		// After descend, start the bototm half circle path
		case PLAN_DESCEND:
			enemy.plan = PLAN_PATH
			enemy.pathIndex = PATH_BEE_BOTTOM_CIRCLE + gMirror[enemy.positionIndex]
			NextPathPoint(enemy)
			// Set up for deciding what to do at the end of that bottom circle
			enemy.nextPlan = PLAN_HOME_OR_FULL_CIRCLE
		endcase
		
		case PLAN_FLUTTER:
			if enemy.y# < 100.0 
				SetupFlutterArc(enemy)
			else
				enemy.plan = PLAN_DIVE_ATTACK
				// TODO - Figure out a better answer to the dx# on a butterfly leaving
				enemy.dx# = 0
				enemy.dy# = 3.0
				enemy.nextPlan = PLAN_GOTO_GRID
				SetupEnemyVelocityAndRotation(enemy)
			endif
		endcase
		
		// Out the bottom so go away
		case PLAN_DIVE_AWAY
			enemy.plan = PLAN_DEAD
			dec gPlayers[gCurrentPlayer].enemiesAlive
			SetSpriteVisible(enemy.spr, 0)
		endcase

		case PLAN_DIVE_ATTACK
			enemy.plan = PLAN_GOTO_GRID
			enemy.y# = 0.0
			enemy.x# = gStartPathX[aPath_Top_Double_Right]
			if not gMirror[enemy.positionIndex] then enemy.x# = 100.0 - enemy.x#
		endcase
		
		case PLAN_GOTO_BEAM:
			enemy.r# = 90
			SetSpriteAngle(enemy.spr, enemy.r#+90)
			enemy.plan = PLAN_BEAM_ACTION
		endcase

	endselect
endfunction

//------------------------------------------------------------------------------
function UpdateEnemy(enemy ref as Object)

	// Anything that moves means it's not all quiet
	if enemy.plan <> PLAN_GRID then gQuiescence = 0
	
	if enemy.plan = PLAN_BEAM_ACTION
		RunBeamAction(enemy)
		// while in beam state there's no movement
		exitFunction
	endif
	
	// TODO - Give GetGridCoordinate it's own update because running it through here is a waste
	// for grid (or grid-bound) enemies, call every frame as the next position keeps changing
	if enemy.plan >= PLAN_GOTO_GRID and enemy.plan <= PLAN_GRID
		GetGridCoordinate(enemy)
	endif

	// Calculate how much to move this frame in each axis
	tx# = gDT# * enemy.vx#
	ty# = gDT# * enemy.vy#

	// figure out what that is along the vector
	dist# = sqrt(tx#^2+ty#^2)
	
	// Butterflies flutter on an ARC
	if enemy.plan = PLAN_FLUTTER
		// get the current angle
		r# = enemy.r# - 90
		// save the angle
		ro# = r#
		// adjust for the increment
		inc r#, enemy.ir# * gDT#
		// see if desired angle reached and stop changing
		if (r# - ro#) * (enemy.dr# - ro#) < 0.0 then enemy.ir# = 0.0
		// get the x/y step sizes
		tx# = gDT# * gBugAttackSpeed# * cos(r#)
		ty# = gDT# * gBugAttackSpeed# * sin(r#)
		// set the facing angle in the Object and the sprite
		enemy.r# = r#+90
		SetSpriteAngle(enemy.spr, enemy.r#)
	else
		// See how far along the path, and clip to not overshoot
		if dist# > enemy.distance#
			tx# = enemy.dx#
			ty# = enemy.dy#
		endif
	endif
	
	// Updat the position
	inc enemy.x#, tx#
	inc enemy.y#, ty#
	
	// update the distance to travel components
	dec enemy.dx#, tx#
	dec enemy.dy#, ty#
	dec enemy.distance#, dist#

	// If at the end of travel figure out what the plan should be
	if enemy.plan <> PLAN_GRID and enemy.distance# <= 0.0 
		DecisionTime(enemy)
	endif
	
	// Let the enemy shoot if it needs to
	if enemy.timer# > 0.0
		dec enemy.timer#, gDT#
		if enemy.timer# <= 0.0 
			if enemy.shotsToFire
				EnemyFireAShot(enemy)
				dec enemy.shotsToFire
				if enemy.shotsToFire then enemy.timer# = cEnemyGunReloadTime
			endif
		endif
	endif
		

	// Put the enemy where it wants to go
	SetSpritePositionByOffset(enemy.spr, enemy.x#, enemy.y#)

endfunction

//------------------------------------------------------------------------------
function UpdateGridOffsets()
	// Breathe in-out
	oldTimer# = gPlayers[gCurrentPlayer].gridTimer#
	inc gPlayers[gCurrentPlayer].gridTimer#, gDT# * gPlayers[gCurrentPlayer].gridDir#
	if gPlayers[gCurrentPlayer].gridTimer# >= gGridTime[gPlayers[gCurrentPlayer].gridBreathing] or gPlayers[gCurrentPlayer].gridTimer# <= 0.0
		// At extets, flip direction
		gPlayers[gCurrentPlayer].gridDir# = -gPlayers[gCurrentPlayer].gridDir#
		// but step back into range so there's no chance of getting
		// stuck outside the range on a smaller gDT# next frame
		inc gPlayers[gCurrentPlayer].gridTimer#, gDT# * gPlayers[gCurrentPlayer].gridDir#
	endif
	
	// After walking left/right, activate breathing when the grid is in the middle
	if not gPlayers[gCurrentPlayer].gridBreathing 
		if not gPlayers[gCurrentPlayer].spawnActive
			middle# = (gGridTime[0] / 2.0)
			s1# = middle# - oldTimer#
			s2# = middle# - gPlayers[gCurrentPlayer].gridTimer#
			// if this is < 0 the signs are not the same meaning the gris crossed just over the middle
			if s1# * s2# < 0
				gPlayers[gCurrentPlayer].gridBreathing = 1
				gPlayers[gCurrentPlayer].gridTimer# = 0.0
				gPlayers[gCurrentPlayer].gridDir# = 1.0
			endif
		endif
	endif
	
endfunction

//------------------------------------------------------------------------------
function UpdateEnemies()

	// The grid keeps moving
	UpdateGridOffsets()
	// Start by assuming the enemies are all standing in the grid
	gQuiescence = 1
	// TODO: Rename this variable
	// Assume there are no active attackers on bombing runs
	
	for i = 0 to cMaxEnemies
		// if not dead, the enemy must be updated
		if gEnemies[gCurrentPlayer, i].plan 
			UpdateEnemy(gEnemies[gCurrentPlayer, i])
			// collide enemy against player and its bullets
			CheckEnemyDead(gEnemies[gCurrentPlayer, i])
			// count the enemies on bombing runs
			plan = gEnemies[gCurrentPlayer, i].plan
		endif
	next i
	
endfunction

//------------------------------------------------------------------------------
function AttackReady()
	// Can't attack while still spawning
	if gPlayers[gCurrentPlayer].spawnActive then exitFunction(0)
	// also wait for the waves to all make it to the grid
	if not gQuiescence then exitFunction(0)
	
	// prime the attack structure with 2 attackers, not bosses, hence start looking from 4
	gNumAttackers = 0
	for i = 0 to gAttackOrder.length
		if gNumAttackers < 2
			position = gAttackOrder[i]
			if gEnemies[gCurrentPlayer, position].plan = PLAN_GRID
				gAttackers[gNumAttackers] = position
				inc gNumAttackers
			endif
		endif
	next i
	
	// mark unsed slots as such
	for i = gNumAttackers to gAttackers.length
		gAttackers[i] = -1
	next i

endfunction(1)

//------------------------------------------------------------------------------
function ChooseAttacker()
	
	if gCapture then exitFunction
	
	dec gAttackDelayTimer#, gDT#
	if gAttackDelayTimer# < 0.0

		// Only allow 2 at a time
		if gNumAttackers < 2

			// try to pick a boss
			for position = 0 to 3
				if gEnemies[gCurrentPlayer, position].plan = PLAN_GRID

					AddAttacker(0, position)
					
					if not gMakeBeam 
						// See if this boss should go make a beam
						// TODO - See if the last boss will make a beam or not and if not add that exclusion here
						if gPlayers[gCurrentPlayer].enemiesAlive > 5 
							gMakeBeam = BEAM_BOSS_SELECTED
						endif
					else
						// See if there's cargo to take and set those ships up on a launch plan as well
						loaded = 0
						for i = 0 to 2
							if gEnemies[gCurrentPlayer, position+5+i].plan = PLAN_GRID
								inc loaded
								AddAttacker(2, position+5+i)
							endif
							if loaded = 2 then exit
						next i
					endif
					
					// a boss added so stop looking
					exit
					
				endif
			next position
		endif
			
		// after boss pick, if still a slot, try to pick a bee or butterfly
		if gNumAttackers < 2
			for i = 0 to gAttackOrder.length
				position = gAttackOrder[i]
				// if idle
				if gEnemies[gCurrentPlayer, position].plan = PLAN_GRID
					AddAttacker(0, position)
					// Exit loop as an enemy was put in a slot
					exit
				endif
			next i
		endif
		
		// launch any attackers that haven't launched yet
		// This is done as a second part so that the initial primed 2 non-boss
		// atatckers will get launched in this way
		for i = 0 to gAttackers.length
			if gAttackers[i] <> -1
				position = gAttackers[i]
				// is this enemy idle or has it launhed
				if gEnemies[gCurrentPlayer, position].plan = PLAN_GRID

					// Make it launch if it was still idle
					kind = gEnemies[gCurrentPlayer, position].isa
					aBoss = (kind = IMAGE_BOSS_BLUE or kind = IMAGE_BOSS_GREEN) 
					cargo = i >= 2

					if aBoss or cargo
						if gMakeBeam = BEAM_BOSS_SELECTED
							inc gMakebeam
							// TODO - Put the make a beam action in here
							gEnemies[gCurrentPlayer, position].nextPlan = PLAN_GOTO_BEAM
						else
							// Put the BOSS and his cargo on their plan here
							gEnemies[gCurrentPlayer, position].nextPlan = PLAN_PATH
						endif
					else
						gEnemies[gCurrentPlayer, position].nextPlan = PLAN_PATH
					endif

					gEnemies[gCurrentPlayer, position].plan = PLAN_PATH
					gEnemies[gCurrentPlayer, position].pathIndex = PATH_LAUNCH + gMirror[gEnemies[gCurrentPlayer, position].positionIndex]
					gEnemies[gCurrentPlayer, position].attackIndex = i
					NextPathPoint(gEnemies[gCurrentPlayer, position])
					if GetSoundInstances(gSounds[SOUND_DIVE_ATTACK]) then StopSound(gSounds[SOUND_DIVE_ATTACK])
					PlaySound(gSounds[SOUND_DIVE_ATTACK])
					gAttackDelayTimer# = cAttackDelayTime
					// if one of the 1st 2 and not a boss, launch only 1 - boss may have cargo later in array
					if not (cargo or aBoss) then exit
				endif
			endif
		next i
	endif

endfunction

//------------------------------------------------------------------------------
function PlayGame()

	HandlePlayer()
	MoveBullets()
	UpdateEnemies()
	CleanupEffects()
	
	dec gStateTimer#, gDT#
	
	select gSubState
		case cPSInitGame:
			SetupPlayer(0)
			SetupPlayer(1)
			gCurrentPlayer = 0
			gStarSpeed# = 0.0
			PlaySound(gSounds[SOUND_START])
			if gNumPlayers > 1
				SetTextRangeVisible(TEXT_2UP, TEXT_SCORE2P, 1)
			else
				SetTextRangeVisible(TEXT_2UP, TEXT_SCORE2P, 0)
			endif
			SetTextString(gText[TEXT_PLAYER_NUM], "1")
			SetTextPosition(gText[TEXT_PLAYER], 39.0, 50.0)
			SetTextPosition(gText[TEXT_PLAYER_NUM], 65.0, 50.0)
			SetTextRangeVisible(TEXT_PLAYER, TEXT_PLAYER_NUM, 1)
			SetSubState(cPSStageInit)
			gStateTimer# = 4.0
		endcase

		case cPSStageInit:
			if gStateTimer# < 0.0
				SetupSpawn()
				gBulletIndex = gSpriteNumbers[IMAGE_BLUE_BULLET]
				SetTextRangeVisible(TEXT_PLAYER, TEXT_PLAYER_NUM, 0)
				if gPlayers[gCurrentPlayer].stageIndex < 3
					SetTextString(gText[TEXT_STAGE_NUM], str(gPlayers[gCurrentPlayer].stage))
					SetTextRangeVisible(TEXT_STAGE, TEXT_STAGE_NUM, 1)
				else
					SetTextVisible(gText[TEXT_CHALLENGING_STAGE], 1)
				endif
				SetTextRangeVisible(TEXT_CREDIT, TEXT_0, 0)
				SetupStageIcons(gPlayers[gCurrentPlayer].stageIconsToShow)
				gPlayers[gCurrentPlayer].stageIconsShown.length = -1
				gBugAttackSpeed# = cBugAttackSpeedBase + ((cBugAttackSpeedMax-cBugAttackSpeedBase)/cBugAttackSpeedWindow) * mod(gPlayers[gCurrentPlayer].stage, cBugAttackSpeedWindow)
				SetSubState(cPSPreShowField)
			endif
		endcase

		case cPSStageIcons:
			if gPlayers[gCurrentPlayer].stageIconsToShow.length >= 0
				if gStateTimer# <= 0.0
					if not GetSoundInstances(gSounds[SOUND_START]) then PlaySound(gSounds[SOUND_STAGE_ICON])
					// reveal stage icons 1 by 1
					sprite = gPlayers[gCurrentPlayer].stageIconsToShow[gPlayers[gCurrentPlayer].stageIconsToShow.length]
					SetSpriteVisible(sprite, 1)
					gPlayers[gCurrentPlayer].stageIconsShown.Insert(sprite)
					gPlayers[gCurrentPlayer].stageIconsToShow.Remove()
					if gPlayers[gCurrentPlayer].stageIconsToShow.length >= 0 then gStateTimer# = cTimeToNextStageIcon
				endif
			else
				SetSubState(cPSPlayerInit)
				gStateTimer# = 1.5
			endif
		endcase

		case cPSPlayerInit:
			if gStateTimer# <= 0.0
				// If there's a change in player or it's a new game
				if gPlayers[gCurrentPlayer].ships[0].plan < PLAN_ALIVE
				// Make the ship visible in the middle of the screen
					gPlayers[gCurrentPlayer].ships[0].x# = 50
					SetSpritePositionByOffset(gPlayers[gCurrentPlayer].ships[0].spr, gPlayers[gCurrentPlayer].ships[0].x#, gPlayers[gCurrentPlayer].ships[0].y#)

					if gNumPlayers > 1 or gPlayers[gCurrentPlayer].ships[0].plan = PLAN_INIT
						// Show PLAYER 1 label
						SetTextString(gText[TEXT_PLAYER_NUM], str(gCurrentPlayer+1))
						SetTextPosition(gText[TEXT_PLAYER], 36.0, 44.5)
						SetTextPosition(gText[TEXT_PLAYER_NUM], 61.5, 44.5)
						SetTextRangeVisible(TEXT_PLAYER, TEXT_PLAYER_NUM, 1)
					endif
			
				endif

				gPlayers[gCurrentPlayer].ships[0].plan = PLAN_ALIVE
				SetSpriteVisible(gPlayers[gCurrentPlayer].ships[0].spr, 1)

				SetSubState(cPSPrePlay)
				gStateTimer# = 1.5
			endif
		endcase
		
		case cPSPrePlay:
			if gStarSpeed# < cStarMaxSpeed then inc gStarSpeed#, gDT# * cStarAcceleration
			if gStateTimer# < 0.0
				SetTextRangeVisible(TEXT_PLAYER, TEXT_READY, 0)
				gStarSpeed# = cStarMaxSpeed
				SetSubState(cPSPlay)
				gBugsAttack = 0
				gNumAttackers = 0
				for i = 0 to gAttackers.length
					gAttackers[i] = -1
				next i
			endif
		endcase

		case cPSPlay:
			// Test for end of stage - all clear - condition
			// do before testing if player has died as that needs to go to a different state
			if not gPlayers[gCurrentPlayer].enemiesAlive and not gPlayers[gCurrentPlayer].spawnActive
				inc gPlayers[gCurrentPlayer].stage
				if gPlayers[gCurrentPlayer].stage = 256 then gPlayers[gCurrentPlayer].stage = 0
				SetSubState(cPSStageClear)
			endif

			if gPlayers[gCurrentPlayer].ships[0].plan
				// While the player is alive and there are enemies to spawn, do so
				if gPlayers[gCurrentPlayer].spawnActive then RunSpawn()
				
				if not gBugsAttack then gBugsAttack = AttackReady()
				if gBugsAttack then ChooseAttacker()
			else
				SetSubState(cPSPlayerDied)
			endif
		endcase
		
		case cPSStageClear:
			if gRunningEffects.length = -1
				if gPlayers[gCurrentPlayer].stageIndex >= 3
					if gEnemiesKilledThisStage = 40
						PlaySound(gSounds[SOUND_CHALLANGE_PERFECT])
					else
						PlaySound(gSounds[SOUND_CHALLANGE_BONUS])
					endif
					SetSubState(cPSShowChallangeResults)
					gStateTimer# = 2.0
				else
					SetSubState(cPSStageInit)
				endif
			endif
		endcase
		
		case cPSPlayerDied:
			if not gQuiescence or gRunningEffects.length <> -1
				if gSpawnWave then RunSpawn()
			else
				dec gPlayers[gCurrentPlayer].lives
				if gPlayers[gCurrentPlayer].lives < 0
					SetSubState(cPSPlayerGameOver)
				else
					if gNumPlayers > 1 and gPlayers[gCurrentPlayer].enemiesAlive
						SetSubState(cPSHideField)
					else
						SetSubState(cPSNextToPlay)
					endif
				endif
			endif
		endcase

		case cPSHideField:
			if gPlayers[gCurrentPlayer].gridYOffset# > -50
				dec gPlayers[gCurrentPlayer].gridYOffset#, cLeaveGridSpeed * gDT#
			else
				for i = 0 to cMaxEnemies
					if gEnemies[gCurrentPlayer, i].plan then SetSpriteVisible(gEnemies[gCurrentPlayer, i].spr, 0)
				next i
				SetSubState(cPSNextToPlay)
			endif
		endcase

		case cPSNextToPlay:
			// Turn on the ?UP indicator
			index = gText[gFlashIndex[gCurrentPlayer]]
			SetTextVisible(index, 1)
			
			// Switch players if needed
			if gNumPlayers > 1 then gCurrentPlayer = 1 - gCurrentPlayer
			
			// if switching to a lifeless player, all players are dead
			if gPlayers[gCurrentPlayer].lives < 0 
				gStarSpeed# = cStarMaxSpeed
				exitFunction(0)
			endif

			// Put the sprites in the right spots for this player and make them visible
			if gNumPlayers > 1
				for i = 0 to cMaxEnemies
					if gEnemies[gCurrentPlayer, i].plan
						SetSpritePositionByOffset(gEnemies[gCurrentPlayer, i].spr, gEnemies[gCurrentPlayer, i].x#, gEnemies[gCurrentPlayer, i].y#)
						SetSpriteVisible(gEnemies[gCurrentPlayer, i].spr, 1)
					endif
				next i
			endif
			
			// continue the stage or start a new stage if all enemies were killed
			if gPlayers[gCurrentPlayer].enemiesAlive or gPlayers[gCurrentPlayer].spawnActive
				SetTextVisible(gText[TEXT_READY], 1)
				SetSubState(cPSPreShowField)
			else
				SetSubState(cPSStageInit)
			endif
		endcase

		case cPSPreShowField:
			// Show available lives icons
			ShowLivesIcons()

			SetSpriteRangeVisible(gSpriteOffsets[IMAGE_BADGE1], gSpriteOffsets[IMAGE_BADGE50]+gSpriteNumbers[IMAGE_BADGE50], 0)
			for i = 0 to gPlayers[gCurrentPlayer].stageIconsShown.length
				SetSpriteVisible(gPlayers[gCurrentPlayer].stageIconsShown[i], 1)
			next i

			// Start ramping up the background speed
			SetSubState(cPSShowField)
		endcase


		case cPSShowField:
			// While the field is not fully on-screen, keep moving it on
			if gPlayers[gCurrentPlayer].gridYOffset# < 0
				inc gPlayers[gCurrentPlayer].gridYOffset#, cLeaveGridSpeed * gDT#
			else
				// At fully on, move to showing the stage icons
				gPlayers[gCurrentPlayer].gridYOffset# = 0.0
				SetSubState(cPSStageIcons)
			endif
		endcase

		case cPSShowChallangeResults:
			// Show enemies killed and award a bonus after challange stage
			if gStateTimer# < 0.0
				select gScratch1
					case 0:
						// TODO - Set Corlo
						SetTextColor(gText[TEXT_NUMBER_OF_HITS], gColors[COLOR_ROBIN].red, gColors[COLOR_ROBIN].green, gColors[COLOR_ROBIN].blue, 255)
						SetTextPosition(gText[TEXT_NUMBER_OF_HITS],  18.0, 50.0)
						SetTextVisible(gText[TEXT_NUMBER_OF_HITS], 1)
						gStateTimer# = 1.0
						inc gScratch1
					endcase
					
					case 1:
						SetTextColor(gText[TEXT_NUMBER_OF_HITS_NUM], gColors[COLOR_ROBIN].red, gColors[COLOR_ROBIN].green, gColors[COLOR_ROBIN].blue, 255)
						SetTextPosition(gText[TEXT_NUMBER_OF_HITS_NUM],  75.0, 50.0)
						SetTextString(gText[TEXT_NUMBER_OF_HITS_NUM], str(gEnemiesKilledThisStage))
						SetTextVisible(gText[TEXT_NUMBER_OF_HITS_NUM], 1)
						gStateTimer# = 1.0
						inc gScratch1
					endcase
					
					case 2:
						if gEnemiesKilledThisStage = 40
							SetTextVisible(gText[TEXT_PERFECT], 1-GetTextVisible(gText[TEXT_PERFECT]))
							inc gScratch2
							if gScratch2 > 6 then inc gScratch1
							gStateTimer# = 0.25
						else
							SetTextVisible(gText[TEXT_BONUS], 1)
							gStateTimer# = 1.0
							inc gScratch1
						endif
					endcase

					case 3:
						if gEnemiesKilledThisStage = 40
							SetTextVisible(gText[TEXT_SPECIAL_BONUS], 1)
							IncrementScore(10000)
						else
							scoreAmount = gEnemiesKilledThisStage*100
							SetTextString(gText[TEXT_BONUS_NUM], str(scoreAmount))
							SetTextVisible(gText[TEXT_BONUS_NUM], 1)
							IncrementScore(scoreAmount)
						endif
						gStateTimer# = 4.0
						inc gScratch1
					endcase

					case 4:
						SetTextRangeVisible(TEXT_NUMBER_OF_HITS, TEXT_PERFECT, 0)
						SetSubState(cPSStageInit)
					endcase

				endselect
			endif
		endcase
		
		case cPSPlayerGameOver:
			// Only show player number who's game is over if there's more than one player
			if gNumPlayers > 1
				SetTextPosition(gText[TEXT_PLAYER], 39.5, 44.0)
				SetTextPosition(gText[TEXT_PLAYER_NUM], 65.0, 44.0)
				SetTextRangeVisible(TEXT_PLAYER, TEXT_PLAYER_NUM, 1)
			endif
			SetTextVisible(gText[TEXT_GAME_OVER], 1)
			SetSubState(cPSShowGameOverStats)
			gStateTimer# = 3.0
		endcase
		
		case cPSShowGameOverStats:
			if gStateTimer# < 0.0
				// Hide old info
				SetSpriteRangeVisible(gSpriteOffsets[IMAGE_PLAYER_CAPTURED], gSpriteOffsets[IMAGE_RED_BULLET], 0)
				SetTextRangeVisible(TEXT_PLAYER, TEXT_PLAYER_NUM, 0)
				SetTextVisible(gText[TEXT_GAME_OVER], 0)
				// Update stats text
				SetTextString(gText[TEXT_SHOTS_FIRED_NUM], str(gPlayers[gCurrentPlayer].shotsFired))
				SetTextString(gText[TEXT_NUMBER_OF_HITS_NUM], str(gPlayers[gCurrentPlayer].hits))
				if gPlayers[gCurrentPlayer].shotsFired
					str$ = str((gPlayers[gCurrentPlayer].hits*100.0)/gPlayers[gCurrentPlayer].shotsFired, 1)
					str$ = str$ + " %"
				else
					str$ = gStrings$[TEXT_HIT_MISS_RATIO_NUM]
				endif
				SetTextString(gText[TEXT_HIT_MISS_RATIO_NUM], str$)
				// Show stats
				SetTextColor(gText[TEXT_NUMBER_OF_HITS], gColors[COLOR_YELLOW].red, gColors[COLOR_YELLOW].green, gColors[COLOR_YELLOW].blue, 255)
				SetTextPosition(gText[TEXT_NUMBER_OF_HITS], 14.5, 64.0)
				SetTextColor(gText[TEXT_NUMBER_OF_HITS_NUM], gColors[COLOR_YELLOW].red, gColors[COLOR_YELLOW].green, gColors[COLOR_YELLOW].blue, 255)
				SetTextPosition(gText[TEXT_NUMBER_OF_HITS_NUM], 72.0, 64.0 )
				SetTextRangeVisible(TEXT_RESULTS, TEXT_NUMBER_OF_HITS_NUM, 1)
				SetSubState(cPSHoldGameOverStats)
				gStateTimer# = 7.3
			endif
		endcase

		case cPSHoldGameOverStats:
			if gStateTimer# < 0.0
				SetTextRangeVisible(TEXT_RESULTS, TEXT_NUMBER_OF_HITS_NUM, 0)
				// if high score - go to enter high score
				if gPlayers[gCurrentPlayer].score > gHighScores[gHighScores.length].score
					gEditScore = gHighScores.length-1
					gEditLetter = 0
					gEntry.name$ = "AAA"
					gEntry.score = gPlayers[gCurrentPlayer].score
					while(gEditScore >= 0)
						// Move old scores to make room for new entry
						if gEntry.score > gHighScores[gEditScore].score 
							SetTextString(gText[TEXT_SCORE_1+gEditScore+1],GetTextString(gText[TEXT_SCORE_1+gEditScore]))
							SetTextString(gText[TEXT_N_N+gEditScore+1],GetTextString(gText[TEXT_N_N+gEditScore]))
							dec gEditScore
						else
							exit
						endif
					endwhile
					inc gEditScore
					// Add the new entry in where it belongs
					gHighScores.insert(gEntry, gEditScore)
					// remove the score that's fallen off the bottom
					gHighScores.remove()
					// Setup to get initials
					SetTextString(gText[TEXT_INITALS_SCORE_NUM], FormatValue(gEntry.score))
					SetTextString(gText[TEXT_SCORE_1+gEditScore], FormatValue(gEntry.score))
					SetTextString(gText[TEXT_INITALS_INITIALS], gEntry.name$)
					SetTextString(gText[TEXT_N_N+gEditScore], "   ")
					SetTextColor(gText[TEXT_1ST+gEditScore], gColors[COLOR_YELLOW].red, gColors[COLOR_YELLOW].green, gColors[COLOR_YELLOW].blue, 255)
					SetTextColor(gText[TEXT_SCORE_1+gEditScore], gColors[COLOR_YELLOW].red, gColors[COLOR_YELLOW].green, gColors[COLOR_YELLOW].blue, 255)
					SetTextColor(gText[TEXT_N_N+gEditScore], gColors[COLOR_YELLOW].red, gColors[COLOR_YELLOW].green, gColors[COLOR_YELLOW].blue, 255)
					SetTextRangeVisible(TEXT_SCORE, TEXT_TOP_5, 1)
					SetSubState(cPSHighScore)
				else
					SetSubState(cPSNextToPlay)
				endif
			endif
		endcase

		case cPSHighScore:
			// Keep looping the highscore tune
			if not GetSoundInstances(gSounds[SOUND_HIGHSCORE_LOOP]) then PlaySound(gSounds[SOUND_HIGHSCORE_LOOP])
			
			// Flash the currently being edited initial
			if gStateTimer# <= 0.0
				if GetTextCharColorRed(gText[TEXT_INITALS_INITIALS], gEditLetter) = gColors[COLOR_YELLOW].red
					SetTextCharColor(gText[TEXT_INITALS_INITIALS], gEditLetter, gColors[COLOR_ROBIN].red, gColors[COLOR_ROBIN].green, gColors[COLOR_ROBIN].blue, 255)
				else
					SetTextCharColor(gText[TEXT_INITALS_INITIALS], gEditLetter, gColors[COLOR_YELLOW].red, gColors[COLOR_YELLOW].green, gColors[COLOR_YELLOW].blue, 255)
				endif
				gStateTimer# = 0.25
			endif
			
			// Use debounced directions
			if gManagedDir <> 0
				// Only some of the alphabet available for initials
				letter = asc(mid(gEntry.name$, gEditLetter+1, 1))
				if gManagedDir = -1 
					if letter = asc("A") 
						letter = asc(".")
					elseif letter = asc(".")
						letter = asc(" ")
					elseif letter = asc(" ")
						letter = asc("Z")
					else
						dec letter
					endif
				else
					if letter = asc("Z") 
						letter = asc(" ")
					elseif letter = asc(" ")
						letter = asc(".")
					elseif letter = asc(".")
						letter = asc("A")
					else
						inc letter
					endif
				endif
				gEntry.name$ = left(gEntry.name$, gEditLetter) + chr(letter) + mid(gEntry.name$, gEditLetter+2, -1)
				SetTextString(gText[TEXT_INITALS_INITIALS], gEntry.name$)
			endif
			
			// On fire, lock in an initial - 3 locked in ends the sequence
			if gFire
				SetTextCharColor(gText[TEXT_INITALS_INITIALS], gEditLetter, gColors[COLOR_ROBIN].red, gColors[COLOR_ROBIN].green, gColors[COLOR_ROBIN].blue, 255)
				SetTextString(gText[TEXT_N_N+gEditScore], left(gEntry.name$, gEditLetter+1))
				inc gEditLetter
				if gEditLetter > 2
					SetSubState(cPSHoldHighScore)
					gStateTimer# = 4.0
				endif
			endif
		endcase
		
		case cPSHoldHighScore:
			if gStateTimer# < 0.0
				// wait for the tune to finish
				if not GetSoundInstances(gSounds[SOUND_HIGHSCORE_LOOP])
					if not gScratch1
						// play the end of tune sound
						PlaySound(gSounds[SOUND_HIGHSCORE_END])
						inc gScratch1
						// wait for end of tune to finish before finally taking the screen down
					elseif not GetSoundInstances(gSounds[SOUND_HIGHSCORE_END])
						// Set the color for the new entry back to robin (from the highlighted yellow)
						SetTextColor(gText[TEXT_1ST+gEditScore], gColors[COLOR_ROBIN].red, gColors[COLOR_ROBIN].green, gColors[COLOR_ROBIN].blue, 255)
						SetTextColor(gText[TEXT_SCORE_1+gEditScore], gColors[COLOR_ROBIN].red, gColors[COLOR_ROBIN].green, gColors[COLOR_ROBIN].blue, 255)
						SetTextColor(gText[TEXT_N_N+gEditScore], gColors[COLOR_ROBIN].red, gColors[COLOR_ROBIN].green, gColors[COLOR_ROBIN].blue, 255)
						// Hide all the high-score text
						SetTextRangeVisible(TEXT_SCORE, TEXT_TOP_5, 0)
						SetSubState(cPSNextToPlay)
					endif
				endif
			else 
				// Keep up the loop here too, till it's time to hide the high-score
				if not GetSoundInstances(gSounds[SOUND_HIGHSCORE_LOOP]) then PlaySound(gSounds[SOUND_HIGHSCORE_LOOP])
			endif
		endcase
		
	endselect

endfunction(1)
