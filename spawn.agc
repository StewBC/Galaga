/*------------------------------------------------------------------------------*\

   Galaga - Arcade game remake

   Created by Stefan Wessels.
   Copyright (c) 2017 Wessels Consulting Ltd. All rights reserved.

   This software is provided 'as-is', without any express or implied warranty.
   In no event will the authors be held liable for any damages arising from the use of this software.

   Permission is granted to anyone to use this software for any purpose,
   including commercial applications, and to alter it and redistribute it freely.

\*------------------------------------------------------------------------------*/

// TODO: Check how sprites can get recycled, if needed
// TODO: Clean up all of the globals and global constants
global gChallangeIndex
global gExtraEnemy as integer[1]
global gExtraEnemyCount as integer[2]
global gNextPosition

//------------------------------------------------------------------------------
function SpawnGetNextExtra(side, number)
	
	stage = gPlayers[gCurrentPlayer].stage
	wave = gPlayers[gCurrentPlayer].attackWave
	give = 0

	// Maximum 2 extra enemies per wave
	if number < 2
		// stages < 4, and stage 10 don't get extra enemies
		if stage >= 4 and stage <> 10
			if stage >= 4 and stage <= 8
				// 5,5,4,4,4,4,5,5,5,5
				if not number and (wave = 0 or wave > 2) then give = 1
			elseif stage = 9
				// 6,6,5,5,5,5,5,5,5,5
				give = 1
				if wave >= 1 and number then give = 0
			elseif stage = 12
				// 5,5,5,5,5,5,5,5,5,5
				if not number then give = 1
			elseif stage = 13
				// 6,6,5,5,6,6,6,6,6,6
				give = 1
				if wave = 1 and number then give = 0
			else
				// 6,6,6,6,6,6,6,6,6,6
				give = 1
			endif
		endif
	endif
	
	// if give = 1 then set an extra enemy insert location, else don't give an extra enemy
	if give
		gExtraEnemy[side] = random(gExtraEnemy[side],3)
	else
		gExtraEnemy[side] = -1
	endif
	
endfunction

//------------------------------------------------------------------------------
function SetupSpawn()
	
	gPlayers[gCurrentPlayer].gridTimer# = 0.0
	gPlayers[gCurrentPlayer].gridDir# = 1.0
	gPlayers[gCurrentPlayer].gridBreathing = 0
	gPlayers[gCurrentPlayer].gridYOffset# = 0.0

	gPlayers[gCurrentPlayer].enemiesAlive = 0
	gPlayers[gCurrentPlayer].attackWave = 0
	gPlayers[gCurrentPlayer].spawnIndex[0] = 0
	gPlayers[gCurrentPlayer].spawnIndex[1] = 0
	gPlayers[gCurrentPlayer].kindIndex = 0
	
	// Clear the cache of "sprites in use" by this player
	// As enemies gPlayers[gCurrentPlayer].spawnActive, they look here for the index to the next
	// available sprite of the kind they need to gPlayers[gCurrentPlayer].spawnActive as
	for i = 0 to gSpritesUsed[gCurrentPlayer].length
		gSpritesUsed[gCurrentPlayer, i] = 0
	next i

	 //Stages 0 & 1 maps to attack 0; 2 maps to 1; 3 to 3, 4 to 0, 5 to 1, 6 to 2, 7 to 3, etc
	 //0, 1 & 2 are the "regular" stages; 3 is a Challange Stage
	stage = gPlayers[gCurrentPlayer].stage
	if stage < 2 
		gPlayers[gCurrentPlayer].stageIndex = 2
	elseif stage = 2
		gPlayers[gCurrentPlayer].stageIndex = 1
	else 
		gPlayers[gCurrentPlayer].stageIndex = stage && 3
	endif

	// Non-challange state extra init
	if gPlayers[gCurrentPlayer].stageIndex <> 3
		
		// not a challanging stage
		gChallangeIndex = 0
		
		// Calculate which spawning enemies will fire how many shots
		// stage 0,1 no shooting
		if stage >= 2
			// stages > 5 every other enemy shoots
			if stage > 5
				// except for stage 10 where nobody shoots
				if stage = 10
					every = 0
				else
					every = 2
				endif
			else 
				// 2 - 5, every 3rd enemy shoots
				every = 3
			endif
			
			// Stages below 5 only 1 bullet
			if stage <= 4 
				bullets = 1 
			else
				// stages 5 and up, 2 bullets per enemy
				bullets = 2
			endif
		endif
	else
		// is a challanging stage
		challangeStage = 1 + mod(((gPlayers[gCurrentPlayer].stage - 2) >> 2), 3)
		gChallangeIndex = 5 * challangeStage
		gPlayers[gCurrentPlayer].stageIndex = 2 + challangeStage
	endif
	
	// Fill the structure for enemies that should shoot with how many bullets
	for i = 0 to gEnemyToArm.length
		gEnemyToArm[i] = 0
		if every 
			if not mod(i, every) then gEnemyToArm[i] = bullets
		endif
	next i
		
	// Init the globals that regulate spawning
	gSpawnTimer# = 0.15
	gQuiescence = 0
	gSpawnWave = 0
	gPlayers[gCurrentPlayer].spawnActive = 1

	// Not in a player struct - only matters in challanging stages where player can't die
	gEnemiesKilledThisStage = 0
	
	// There are 0-39 grid positions and 40-43 are for extra, peel-away enemies
	gNextPosition = 40
	
	// Init the extra enemy management variables
	gExtraEnemy[0] = 0
	gExtraEnemy[1] = 0
	
	gExtraEnemyCount[0] = 0
	gExtraEnemyCount[1] = 0
	
	// Get the first extra peel-away eneies for this wave, if there are any
	SpawnGetNextExtra(0, 0)
	SpawnGetNextExtra(1, 0)

endfunction

//------------------------------------------------------------------------------
function SpawnSetupEnemy(enemy ref as Object, position)
	
		path as integer[1]

		// by default, go to grid but if enemy is an extra peel-away, do that
		if position < 40 then nextPlan = PLAN_GOTO_GRID else nextPlan = PLAN_DIVE_AWAY_LAUNCH
		
		// On challange stages, the enmies go straight to death at the end of the path
		if gChallangeIndex then nextPlan = PLAN_DEAD
		
		// Gathetr info that determines how this emeny behaves
		kind = gSpawnKind[gPlayers[gCurrentPlayer].attackWave+gChallangeIndex, gPlayers[gCurrentPlayer].kindIndex]
		path[0] = gPathIndicies[gPlayers[gCurrentPlayer].stageIndex, gPlayers[gCurrentPlayer].attackWave, 0]
		path[1] = gPathIndicies[gPlayers[gCurrentPlayer].stageIndex, gPlayers[gCurrentPlayer].attackWave, 1]
		thePath = path[gPlayers[gCurrentPlayer].kindIndex]
		
		// Install the enemy's values
		enemy.isa = kind
		enemy.spr = gSprites[gSpriteOffsets[kind]+gSpritesUsed[gCurrentPlayer, kind]]
		enemy.positionIndex = position
		enemy.plan = PLAN_PATH
		enemy.nextPlan = nextPlan
		enemy.pathIndex = thePath
		enemy.attackIndex = -1
		
		// start position of the path
		index = thePath >> 1
		enemy.x# = gStartPathX[index]
		enemy.y# = gStartPathY[index]

		// Mirror if path is odd
		if thePath && 1 then enemy.x# = 100.0 - enemy.x#
		
		// Special case challanging stages
		// challanging stage 3 (stage 11 seen first)
		if gChallangeIndex = 15
			// wave is used again later
			wave = gPlayers[gCurrentPlayer].attackWave
			// if the path is odd on wave 0 and 3 then don't mirror the start
			if thePath && 1
				if (wave = 0 or wave = 3) then enemy.x# = 100.0 - enemy.x#
			else
				// but if it's not mirrored on wave 4 then do mirror its start
				if wave = 4 then enemy.x# = 100.0 - enemy.x#
			endif
		endif

		// set up velociy and rotation
		enemy.pointIndex = 0
		NextPathPoint(enemy)

		// Install values in sprite itself
		SetSpritePositionByOffset(enemy.spr, enemy.x#, enemy.y#)
		SetSpriteVisible(enemy.spr, 1)
		// Mark a sprite as in use for this enemy
		inc gSpritesUsed[gCurrentPlayer, kind]
		
		// Set up the firing
		enemy.shotsToFire = gEnemyToArm[gEnemyToArmIndex]
		if gEnemyToArm[gEnemyToArmIndex]
			// delay the fire when on a bottom wave even more
			if index >= aPath_Bottom_Single and index <= aPath_Bottom_Double_In
				enemy.timer# = 1.0 + (random(0, 3) / 10.0)
			else
				enemy.timer# = 0.3 + (random(0, 3) / 10.0)
			endif
		else
			enemy.timer# = 0.0
		endif
		inc gEnemyToArmIndex
		if gEnemyToArmIndex > gEnemyToArm.length then gEnemyToArmIndex = 0
		
		// One more enemy to kill
		inc gPlayers[gCurrentPlayer].enemiesAlive

		// wait a small amount between non-side-by-side enemies, and pairs of side-by-side enemies
		if gSpawnWave and path[0] = path[1] or gPlayers[gCurrentPlayer].kindIndex = 1
			gSpawnTimer# = 0.10
		endif
		
		// challanging stage 3 uses seperate paths but delay spawn as thoug it's a single path
		if gChallangeIndex = 15 //(5 waves per stage, so stage 3 is index 15)
			if wave = 0 or wave = 3 or wave = 4 then gSpawnTimer# = 0.10
		endif
		
endfunction

//------------------------------------------------------------------------------
function RunSpawn()
	
	dec gSpawnTimer#, gDT#
	
	// wait 1 second between waves - wave "done" when in grid or destroyed (challange or all shot out)
	if gSpawnWave = 0 and gQuiescence = 0 then gSpawnTimer# = 1.0
	
	// is it time to spawn
	if gSpawnTimer# <= 0.0
		// a wave is spawning
		gSpawnWave = 1
		
		// each wave has 2 "sides" or streams
		side = gPlayers[gCurrentPlayer].kindIndex
		
		// See if an extra enemy needs to be inserted now
		if gPlayers[gCurrentPlayer].spawnIndex[side] = gExtraEnemy[side]
			position = gNextPosition
			inc gNextPosition
			if gNextPosition = 44 then gNextPosition = 40
			inc gExtraEnemyCount[side]
			SpawnGetNextExtra(side, gExtraEnemyCount[side])
		else
			// where in the grid should this enemy go
			position = gSpawnOrder[gPlayers[gCurrentPlayer].attackWave, side, gPlayers[gCurrentPlayer].spawnIndex[side]]
		endif
		
		// Set up the enmy for spawning, and reset spawn timing based on enemy
		SpawnSetupEnemy(gEnemies[gCurrentPlayer, position], position)

		if position < 40
			// Go to the next position in the spawn grid
			inc gPlayers[gCurrentPlayer].spawnIndex[side]
			if gPlayers[gCurrentPlayer].spawnIndex[side] > gSpawnOrder[gPlayers[gCurrentPlayer].attackWave, side].length
				gPlayers[gCurrentPlayer].spawnIndex[side] = 0
				// If the whole wave has spawned then go to the next wave
				if side = 1
					gSpawnWave = 0
					inc gPlayers[gCurrentPlayer].attackWave
					if gPlayers[gCurrentPlayer].attackWave > gSpawnOrder.length 
						// if all waves have spawned then spawning is done
						gPlayers[gCurrentPlayer].attackWave = 0
						gPlayers[gCurrentPlayer].spawnActive = 0
					else
						// Reset variables per wave
						gExtraEnemy[0] = 0
						gExtraEnemy[1] = 0
						gExtraEnemyCount[0] = 0
						gExtraEnemyCount[1] = 0
						
						// Get the extra enemies for this wave
						SpawnGetNextExtra(0, 0)
						SpawnGetNextExtra(1, 0)
					endif
				endif
			endif
		endif

		// Flip between the two sides of the attack wave
		gPlayers[gCurrentPlayer].kindIndex = 1 - gPlayers[gCurrentPlayer].kindIndex

	endif
	
endfunction

