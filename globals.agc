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
#constant cAttackDelayTime					0.5
#constant cBreatheTime						2.1
#constant cBugAttackSpeedBase				50.0
#constant cBugAttackSpeedMax				70.0
#constant cBugAttackSpeedWindow				10
#constant cBugTravelSpeed					70.0
#constant cBulletSpeed						130.0		` distance bullets moves in 1 second
#constant cBulletSpeedEnemy					65.0
#constant cDisplayHeight					100			` Virtual Resulution (% system)
#constant cDisplayWidth						100
#constant cEnemyExplosionFPS				15.0
#constant cEnemyGunReloadTime				0.1
#constant cFlashTime						0.25
#constant cGridOrientAngle					18
#constant cHoldCopyright					3.0			` duration to display copyright
#constant cHoldHighScores					5.0			` duration to display score table
#constant cLeaveGridSpeed					25.0
#constant cMaxBullets						18			` gSpriteNumbers[IMAGE_BLUE_BULLET] + gSpriteNumbers[IMAGE_RED_BULLET]
#constant cMaxEnemies						48			` 12/wave * 4waves = 48
#constant cMaxEnemyBullets					14			` gSpriteNumbers[IMAGE_RED_BULLET]
#constant cNamcoLogoPosX					50			` centre logo around this x
#constant cNamcoLogoPosY					88			` position logo at thus in y
#constant cNamcoLogoSizeX					2.8*8.57	` aspect ratio
#constant cNamcoLogoSizeY					2.8			` Size of Namco logo text
#constant cNumStars							200			` sprites in scrolling background
#constant cOriginalCellResolution			8
#constant cOriginalXCells					27			` Namco version was 27x36
#constant cOriginalXCellsF					27.0
#constant cOriginalYCells					36
#constant cOriginalYCellsF					36.0
#constant cPlayerExplosionFPS				5.0
#constant cPlayerMovementSpeed				41.0
#constant cPlayerCaptureSpeed				31.0
#constant cRepeatDelay						0.25
#constant cRepeatInitialDelay				0.5
#constant cRoomForTitle						0.90		` Non-mobile use up to this % of MaxDeviceSize
#constant cStarAcceleration					18.0
#constant cStarHeight						30.0/100.0
#constant cStarMaxSpeed						25
#constant cStarWidth						40.0/100.0
#constant cSyncRate							60			` FPS
#constant cSyncRateMobile					30			` FPS
#constant cTextSize							2.86		` Size text to same as Galaga
#constant cTimeToNextStageIcon 				0.15
#constant cTimeToReveal						1.0			` delay when revealing attract text
#constant cTimeToShowLives					4.0
#constant cWalkTime							4.0
#constant cColScaleW						0.50
#constant cColScaleH						0.75
#constant cBeamOpenSpeed					0.3
#constant cBeamHoldDuration					1.5
#constant cCaptureSpinSpeed					360.0

//------------------------------------------------------------------------------
#constant VJ_Stick							1

#constant VB_Fire							1
#constant VB_CoinDrop						2
#constant VB_1P_START						3
#constant VB_2P_START						4

//------------------------------------------------------------------------------
#constant cStateAttractLoop					1
#constant cStateHaveCredit					2
#constant cStatePlayGame					3

// Attracts
#constant cASTitle							1
#constant cASShowValues						2
#constant cASShowCopyright					3
#constant cASShowPlay						4
#constant cASShowScores						5
#constant cASHaveCredit						6

// PlayGame
#constant cPSInitGame              		  	1
#constant cPSStageInit            	 		2
#constant cPSStageIconsInit					3
#constant cPSPreShowField         			4
#constant cPSStageIcons            			5
#constant cPSPlayerInit         			6
#constant cPSPrePlay               			7
#constant cPSPlay               			8
#constant cPSStageClear						9
#constant cPSPlayerDied						10
#constant cPSHideField						11
#constant cPSNextToPlay						12
#constant cPSShowField						13
#constant cPSShowChallangeResults			14
#constant cPSPlayerGameOver					15
#constant cPSShowGameOverStats				16
#constant cPSHoldGameOverStats				17
#constant cPSHighScore						18
#constant cPSHoldHighScore					19

//------------------------------------------------------------------------------
#constant PLAN_DEAD							0
#constant PLAN_INIT							1
#constant PLAN_ALIVE						2
#constant PLAN_PATH							3
#constant PLAN_GOTO_GRID					4
#constant PLAN_ORIENT						5
#constant PLAN_GRID							6
#constant PLAN_DIVE_AWAY_LAUNCH				7
#constant PLAN_DIVE_AWAY					8
#constant PLAN_DIVE_ATTACK					9
#constant PLAN_DESCEND						10
#constant PLAN_HOME_OR_FULL_CIRCLE			11
#constant PLAN_FLUTTER						12
#constant PLAN_GOTO_BEAM					13
#constant PLAN_BEAM_ACTION					14

//------------------------------------------------------------------------------
#constant BEAM_OFF							0
#constant BEAM_BOSS_SELECTED				1
#constant BEAM_POSITION						2
#constant BEAM_OPENING						3
#constant BEAM_HOLD							4
#constant BEAM_CLOSING						5

#constant CAPTURE_PLAYER_TOUCHED			1
#constant CAPTURE_PLAYER_DISPLAY			2
#constant CAPTURE_PLAYER_SPIN				3
#constant CAPTURE_PLAYER_HOLD				4
#constant CAPTURE_PLAYER_HOME				5

//------------------------------------------------------------------------------
#constant TEXT_1UP							0
#constant TEXT_SCORE1P						1
#constant TEXT_HIGH_SCORE					2
#constant TEXT_20000						3
#constant TEXT_CREDIT						4
#constant TEXT_0							5
#constant TEXT_GALAGA						6
#constant TEXT_DASH_SCORE					7
#constant TEXT_50_100						8
#constant TEXT_80_160						9
#constant TEXT_2UP							10
#constant TEXT_SCORE2P						11
#constant TEXT_COPYRIGHT					12
#constant TEXT_FIGHTER_CAPTURED				13
#constant TEXT_GAME_OVER					14
#constant TEXT_HEROES						15
#constant TEXT_BEST_5						16
#constant TEXT_SCORE						17
#constant TEXT_NAME							18
#constant TEXT_1ST							19
#constant TEXT_2ND							20
#constant TEXT_3RD							21
#constant TEXT_4TH							22
#constant TEXT_5TH							23
#constant TEXT_SCORE_1						24		
#constant TEXT_SCORE_2						25		
#constant TEXT_SCORE_3						26	
#constant TEXT_SCORE_4						27		
#constant TEXT_SCORE_5						28		
#constant TEXT_N_N							29
#constant TEXT_A_A							30
#constant TEXT_M_M							31
#constant TEXT_C_C							32
#constant TEXT_O_O							33
#constant TEXT_ENTER_INITIALS				34
#constant TEXT_INITIALS_SCORE				35
#constant TEXT_INITIALS_NAME				36
#constant TEXT_INITALS_SCORE_NUM			37
#constant TEXT_INITALS_INITIALS				38
#constant TEXT_TOP_5						39
#constant TEXT_PUSH_START					40
#constant TEXT_1BONUS_FOR					41
#constant TEXT_2BONUS_FOR					42
#constant TEXT_FOR_BONUS					43
#constant TEXT_PLAYER						44
#constant TEXT_PLAYER_NUM					45
#constant TEXT_STAGE						46
#constant TEXT_STAGE_NUM					47
#constant TEXT_CHALLENGING_STAGE			48
#constant TEXT_READY						49
#constant TEXT_RESULTS						50
#constant TEXT_SHOTS_FIRED					51
#constant TEXT_SHOTS_FIRED_NUM				52
#constant TEXT_HIT_MISS_RATIO				53
#constant TEXT_HIT_MISS_RATIO_NUM			54
#constant TEXT_NUMBER_OF_HITS				55
#constant TEXT_NUMBER_OF_HITS_NUM			56
#constant TEXT_BONUS						57
#constant TEXT_BONUS_NUM					58
#constant TEXT_SPECIAL_BONUS				59
#constant TEXT_PERFECT						60
	#constant TEXT_END_GAME_TEXT				60

#constant TEXT_RAM_OK						61
#constant TEXT_ROM_OK						62
#constant TEXT_UPRIGHT						63
#constant TEXT_1_COIN_1_CREDIT				64
#constant TEXT_3_FIGHTERS					65
#constant TEXT_RANK_A						66
#constant TEXT_SOUND_00						67
#constant TEXT_1ST_BONUS					68
#constant TEXT_2ND_BONUS					69
#constant TEXT_EVERY_BONUS					70
	#constant TEXT_END_ALL_TEXT					70

//------------------------------------------------------------------------------
#constant IMAGE_GALAGA_ATLAS				0
#constant IMAGE_PLAYER						1
#constant IMAGE_PLAYER_CAPTURED				2
#constant IMAGE_ENTERPRISE					3
#constant IMAGE_BOSS_GREEN					4
#constant IMAGE_BOSS_BLUE					5
#constant IMAGE_BUTTERFLY					6
#constant IMAGE_BEE							7
#constant IMAGE_GALAXIAN					8
#constant IMAGE_SCORPION					9
#constant IMAGE_BOSCONIAN					10
#constant IMAGE_DRAGONFLY					11
#constant IMAGE_MOSQUITO					12
#constant IMAGE_PLAYER_EXPLOSION			13
#constant IMAGE_BEAM						14
#constant IMAGE_EXPLOSION					15
#constant IMAGE_BLUE_BULLET					16
#constant IMAGE_RED_BULLET					17
#constant IMAGE_BADGE1						18
#constant IMAGE_BADGE5						19
#constant IMAGE_BADGE10						20
#constant IMAGE_BADGE20						21
#constant IMAGE_BADGE30						22
#constant IMAGE_BADGE50						23
#constant IMAGE_NAMCO						24
#constant IMAGE_1P_START					25
#constant IMAGE_2P_START					26
#constant IMAGE_COIN_DROP					27
#constant IMAGE_FIRE_UP						28
#constant IMAGE_FIRE_DOWN					29
	#constant IMAGE_END_ATLAS_IMAGES			29

#constant IMAGE_WHITE_IMAGE					30
#constant IMAGE_FONT						31
	#constant IMAGE_END_ALL_IMAGES				31
	
//------------------------------------------------------------------------------
#constant SOUND_BEAM						0
#constant SOUND_COIN						1
#constant SOUND_DANGER						2
#constant SOUND_DIVE_ATTACK					3
#constant SOUND_HIT_BEE						4
#constant SOUND_HIT_BUTTERFLY				5
#constant SOUND_HIT_BOSS_BLUE				6
#constant SOUND_HIT_BOSS_GREEN				7
#constant SOUND_PLAYER_CAPTURED_SONG		8
#constant SOUND_PLAYER_DIE					9
#constant SOUND_PLAYER_SHOOT				10
#constant SOUND_STAGE_ICON					11
#constant SOUND_START						12
#constant SOUND_HIGHSCORE_LOOP				13
#constant SOUND_HIGHSCORE_END				14
#constant SOUND_CHALLANGE_BONUS				15
#constant SOUND_CHALLANGE_PERFECT			16
	#constant SOUND_END_SOUNDS					16
	
//------------------------------------------------------------------------------
#constant COLOR_WHITE						0
#constant COLOR_ROBIN						1
#constant COLOR_RED							2
#constant COLOR_BLUE						3
#constant COLOR_YELLOW						4
	#constant COLOR_END_COLORS					4

//------------------------------------------------------------------------------
type RGBColor
	red
	green
	blue
endtype

type TypeStar
	spr
	ttl#
	ct#
endtype

type Scores
	score
	name$
endtype

type Object 							` generic container for all things that move
	spr									` handle to the sprite
	isa									` type of enemy this is
	positionIndex
	plan								` what the object should be doing
	nextPlan
	attackIndex							` into gAttackers[] when attacking
	x#									` x position on screen
	y#									` y position on screen
	r#									` rotation (angle)
	dx#
	dy#
	pathIndex							` when following a path, which path
	pointIndex							` headiong to which point in the path
	vx#
	vy#
	dr#
	ir#
	distance#							` distantce remaining to next point
	shotsToFire
	timer#
	//attackData							` additional info wrt the attack plan of the enemy
endtype

type Player
	ships as object[2]					` Up to 2 ships on-screen
	lives								` lives player has in reserve
	score								` current player score
	stage								` current player stage
	stageIconsToShow as integer[]
	stageIconsShown as integer[]
	attackWave
	spawnIndex as integer[2]
	kindIndex
	stageIndex
	spawnActive
	enemiesAlive
	shotsFired
	hits
	gridTimer#
	gridDir#
	gridBreathing
	gridYOffset#
endtype

//------------------------------------------------------------------------------
global gStars as TypeStar[]                                 ` stars in scrolling background
global gColors as RGBColor[COLOR_END_COLORS]                ` colors for text
global gStrings$ as string[TEXT_END_ALL_TEXT]               ` all text strings in game
global gText as integer[TEXT_END_GAME_TEXT]                 ` handles to text objects
global gStringsColors as integer[TEXT_END_GAME_TEXT]        ` pointIndex to color for each text string
global gStringsPosX as float[TEXT_END_GAME_TEXT]            ` point where text will be centered around in X
global gStringsPosY as float[TEXT_END_GAME_TEXT]            ` point where text will be put in Y
global gImageNames$ as string[IMAGE_END_ATLAS_IMAGES]       ` image and subimage names to load
global gImages as integer[IMAGE_END_ALL_IMAGES]             ` handles to loaded images
global gSpriteNumbers as integer[IMAGE_END_ATLAS_IMAGES]    ` max # of sprites for each type
global gSpriteAnimFrames as integer[IMAGE_END_ATLAS_IMAGES] ` which sprites are animated # > 1
global gSpriteOffsets as integer[IMAGE_END_ATLAS_IMAGES]    ` where each class starts in gSprites
global gSpritesUsed as integer[1, IMAGE_END_ATLAS_IMAGES]
global gScoreSheet as integer[1, IMAGE_END_ATLAS_IMAGES]
global gKillSound as integer[IMAGE_END_ATLAS_IMAGES]


global gAttackers as integer[4]								` -1 = empty or # is grid-position
global gMakeBeam
//global gBeamV# as float[1] = [0.0, 0.0, 0.0]
global gBeamSize# as float[4]
global gCapture
global gRotationCount#

global gSprites as integer[]                                ` list of all sprites - pre-alloc'd

global gSoundNames$ as string[SOUND_END_SOUNDS]             ` sound files to load
global gSounds as integer[SOUND_END_SOUNDS]                 ` handles to sounds
global gRunningEffects as TypeStar[]                        ` time when an effect should be killed
// TODO - Move path defines up and use them in gPathDataX|Y for size, rather than a number
global gPathDataX as float[16,0]
global gPathDataY as float[16,0]
global gGridTime as float[1]
global gFlashIndex as integer[]
global gScoreIndex as integer[]

global gHighScores as Scores[4]                             ` score and initials of top 5
global gEntry as Scores
global gEditLetter
global gEditScore
global gEnemiesKilledThisStage
global gEnemies as Object[1, cMaxEnemies]                   ` storage for all on-screen enemies
global gBullets as Object[cMaxBullets]                      ` all bullets possible on-screen
global gBulletIndex                                         ` next slot to use for enemy bullet
global gEnemyToArm as integer[12]							` list of spawning enemies that will shoot (max 12 enemies/wave)
global gEnemyToArmIndex = 0									` walks gEnemyToArm circularly
global gNextExplosion                                       ` cycle through explosion sprites

global gPlayers as Player[1]                                ` p1 or 2 and the state of their world
global gFlashTimer#

global gQuiescence

global gAttackDelayTimer#
global gBugsAttack
global gNumAttackers
global gBugAttackSpeed#

global gSpawnTimer#
global gSpawnWave

global gNumPlayers
global gCurrentPlayer                                       ` 0 or 1 for which player is active

global gState                                               ` holds the game state from cState...
global gSubState                                            ` Per-state usable extra variable
global gScratch1                                            ` Generic helper variable (sub-sub state)
global gScratch2                                            ` Generic helper variable (sub-sub state)

global gDT#                                                 ` delta time elapsed each frame to next

global gStarSpeed#                                          ` speed starts scroll at

global gVirtualStick                                        ` true if there's no joystick
global gActualJoyStick                                      ` 0 = none, otherwise the # of the joystick to use
global gDirection                                           ` player input left/nothing/right -1/0/1
global gFire                                                ` bool fire key pressed/not pressed 1/0
global gStart
global gCoinDropped                                         ` true when an add-credits button pressed
global gNumCredits                                          ` coins active in coin slot - always goes to 2
global gRepeatDelay#
global gPrevDirection
global gManagedDir

global gStateTimer#                                         ` time between text displays in attract mode

//------------------------------------------------------------------------------
gColors[COLOR_WHITE].red    = 206
gColors[COLOR_WHITE].green  = 206
gColors[COLOR_WHITE].blue   = 206

gColors[COLOR_ROBIN].red    = 16
gColors[COLOR_ROBIN].green  = 230
gColors[COLOR_ROBIN].blue   = 206

gColors[COLOR_RED].red      = 230
gColors[COLOR_RED].green    = 16
gColors[COLOR_RED].blue     = 16

gColors[COLOR_BLUE].red     = 16
gColors[COLOR_BLUE].green   = 16
gColors[COLOR_BLUE].blue    = 206

gColors[COLOR_YELLOW].red   = 230
gColors[COLOR_YELLOW].green = 230
gColors[COLOR_YELLOW].blue  = 16

//------------------------------------------------------------------------------
// Text related data
gStrings$ = [
	"1UP",							` TEXT_1UP
	"",								` TEXT_SCORE1P
	"HIGH SCORE",					` TEXT_HIGH_SCORE
	"20000",						` TEXT_20000
	"CREDIT ",						` TEXT_CREDIT
	"0",							` TEXT_0
	"GALAGA",						` TEXT_GALAGA
	"__ SCORE __",					` TEXT_DASH_SCORE
	"50    100",					` TEXT_50_100
	"80    160",					` TEXT_80_160
	"2UP",							` TEXT_2UP
	"00",							` TEXT_SCORE2P
	"^ 1981 NAMCO LTD.",			` TEXT_COPYRIGHT
	"FIGHTER CAPTURED",				` TEXT_FIGHTER_CAPTURED
	"GAME OVER",					` TEXT_GAME_OVER
	"THE GALACTIC HEROES",			` TEXT_HEROES
	"__ BEST 5 __",					` TEXT_BEST_5
	"SCORE",						` TEXT_SCORE
	"NAME",							` TEXT_NAME
	"1ST",							` TEXT_1ST
	"2ND",							` TEXT_2ND
	"3RD",							` TEXT_3RD
	"4TH",							` TEXT_4TH
	"5TH",							` TEXT_5TH
	"20000",						` TEXT_SCORE_1
	"20000",						` TEXT_SCORE_2
	"20000",						` TEXT_SCORE_3
	"20000",						` TEXT_SCORE_4
	"20000",						` TEXT_SCORE_5
	"N.N",							` TEXT_N_N
	"A.A",							` TEXT_A_A
	"M.M",							` TEXT_M_M
	"C.C",							` TEXT_C_C
	"O.O",							` TEXT_O_O
	"ENTER YOUR INITIALS !",		` TEXT_ENTER_INITIALS
	"SCORE",						` TEXT_INITIALS_SCORE
	"NAME",							` TEXT_INITIALS_NAME
	"20000",						` TEXT_INITALS_SCORE_NUM
	"AAA",							` TEXT_INITALS_INITIALS
	"TOP 5",						` TEXT_TOP_5
	"PUSH START BUTTON",			` TEXT_PUSH_START
	"1ST BONUS FOR 20000 PTS",		` TEXT_1BONUS_FOR
	"1ST BONUS FOR 70000 PTS",		` TEXT_2BONUS_FOR
	"AND FOR EVERY 70000 PTS",		` TEXT_FOR_BONUS
	"PLAYER",						` TEXT_PLAYER
	"1",							` TEXT_PLAYER_NUM
	"STAGE",						` TEXT_STAGE
	"1",							` TEXT_STAGE_NUM
	"CHALLENGING STAGE",			` TEXT_CHALLENGING_STAGE
	"READY",						` TEXT_READY
	"_RESULTS_",					` TEXT_RESULTS
	"SHOTS FIRED",					` TEXT_SHOTS_FIRED
	"0",							` TEXT_SHOTS_FIRED_NUM
	"HIT-MISS RATIO",				` TEXT_HIT_MISS_RATIO
	"0.0 %",						` TEXT_HIT_MISS_RATIO_NUM				
	"NUMBER OF HITS",				` TEXT_NUMBER_OF_HITS
	"0",							` TEXT_NUMBER_OF_HITS_NUM
	"BONUS",						` TEXT_BONUS
	"100",							` TEXT_BONUS_NUM
	"SPECIAL BONUS 10000 PTS",		` TEXT_SPECIAL_BONUS
	"PERFECT !",					` TEXT_PERFECT
	
	
	"RAM OK",						` TEXT_RAM_OK
	"ROM OK",						` TEXT_ROM_OK
	"UPRIGHT",						` TEXT_UPRIGHT
	"1 COIN  1 CREDIT",				` TEXT_1_COIN_1_CREDIT
	"3 FIGHTERS",					` TEXT_3_FIGHTERS
	"RANK  A",						` TEXT_RANK_A
	"SOUND 00",						` TEXT_SOUND_00
	"1ST BONUS 20000 PTS",			` TEXT_1ST_BONUS
	"1ST BONUS 70000 PTS",			` TEXT_2ND_BONUS
	"AND EVERY 70000 PTS"]			` TEXT_EVERY_BONUS

gStringsColors = [
	COLOR_RED,		                ` TEXT_1UP
	COLOR_WHITE,					` TEXT_SCORE1P
	COLOR_RED,		                ` TEXT_HIGH_SCORE
	COLOR_WHITE,					` TEXT_20000
	COLOR_WHITE,		            ` TEXT_CREDIT
	COLOR_WHITE,					` TEXT_0
	COLOR_ROBIN,					` TEXT_GALAGA
	COLOR_ROBIN,		            ` TEXT_DASH_SCORE
	COLOR_ROBIN,		            ` TEXT_50_100
	COLOR_ROBIN,		            ` TEXT_80_160
	COLOR_RED,		                ` TEXT_2UP
	COLOR_WHITE,					` TEXT_SCORE2P
	COLOR_WHITE,					` TEXT_COPYRIGHT
	COLOR_RED,		                ` TEXT_FIGHTER_CAPTURED
	COLOR_ROBIN,	                ` TEXT_GAME_OVER
	COLOR_BLUE,		                ` TEXT_HEROES
	COLOR_RED,			            ` TEXT_BEST_5
	COLOR_ROBIN,					` TEXT_SCORE
	COLOR_ROBIN, 					` TEXT_NAME
	COLOR_ROBIN, 					` TEXT_1ST
	COLOR_ROBIN, 					` TEXT_2ND
	COLOR_ROBIN, 					` TEXT_3RD
	COLOR_ROBIN, 					` TEXT_4TH
	COLOR_ROBIN, 					` TEXT_5TH
	COLOR_ROBIN,					` TEXT_SCORE_1
	COLOR_ROBIN,					` TEXT_SCORE_2
	COLOR_ROBIN,					` TEXT_SCORE_3
	COLOR_ROBIN,					` TEXT_SCORE_4
	COLOR_ROBIN,					` TEXT_SCORE_5
	COLOR_ROBIN, 					` TEXT_N_N
	COLOR_ROBIN, 					` TEXT_A_A
	COLOR_ROBIN, 					` TEXT_M_M
	COLOR_ROBIN, 					` TEXT_C_C
	COLOR_ROBIN, 					` TEXT_O_O
	COLOR_RED,						` TEXT_ENTER_INITIALS
	COLOR_ROBIN,					` TEXT_INITIALS_SCORE
	COLOR_ROBIN,					` TEXT_INITIALS_NAME
	COLOR_ROBIN,					` TEXT_INITALS_SCORE_NUM
	COLOR_ROBIN,					` TEXT_INITALS_INITIALS
	COLOR_RED,						` TEXT_TOP_5
	COLOR_ROBIN,					` TEXT_PUSH_START
	COLOR_YELLOW,					` TEXT_1BONUS_FOR
	COLOR_YELLOW,					` TEXT_2BONUS_FOR
	COLOR_YELLOW,					` TEXT_FOR_BONUS
	COLOR_ROBIN, 					` TEXT_PLAYER
	COLOR_ROBIN, 					` TEXT_PLAYER_NUM
	COLOR_ROBIN, 					` TEXT_STAGE
	COLOR_ROBIN,					` TEXT_STAGE_NUM
	COLOR_ROBIN,					` TEXT_CHALLENGING_STAGE
	COLOR_ROBIN,					` TEXT_READY
	COLOR_RED,						` TEXT_RESULTS
	COLOR_YELLOW,					` TEXT_SHOTS_FIRED
	COLOR_YELLOW,					` TEXT_SHOTS_FIRED_NUM
	COLOR_WHITE,					` TEXT_HIT_MISS_RATIO
	COLOR_WHITE,					` TEXT_HIT_MISS_RATIO_NUM
	COLOR_YELLOW,					` TEXT_NUMBER_OF_HITS
	COLOR_YELLOW,					` TEXT_NUMBER_OF_HITS_NUM
	COLOR_ROBIN,					` TEXT_BONUS
	COLOR_ROBIN,					` TEXT_BONUS_NUM
	COLOR_YELLOW,					` TEXT_SPECIAL_BONUS
	COLOR_RED]						` TEXT_PERFECT
	
// Centre text around this point if negative, otherwise position text at the point
gStringsPosX = [
    7.50 ,                           ` TEXT_1UP
    -3.00,                           ` TEXT_SCORE1P
    32.50,                           ` TEXT_HIGH_SCORE
    43.00,                           ` TEXT_20000
    3.75 ,                           ` TEXT_CREDIT
    28.90,                           ` TEXT_0
    39.50,                           ` TEXT_GALAGA
    28.50,                           ` TEXT_DASH_SCORE
    43.00,                           ` TEXT_50_100
    43.00,                           ` TEXT_80_160
    82.50,                           ` TEXT_2UP
    71.75,                           ` TEXT_SCORE2P
    21.00,                           ` TEXT_COPYRIGHT
    20.50,                           ` TEXT_FIGHTER_CAPTURED
    36.00,                           ` TEXT_GAME_OVER
    15.00,                           ` TEXT_HEROES
    25.00,                           ` TEXT_BEST_5
    32.25,                           ` TEXT_SCORE
    68.25,                           ` TEXT_NAME
    11.50,                           ` TEXT_1ST
    11.50,                           ` TEXT_2ND
    11.50,                           ` TEXT_3RD
    11.50,                           ` TEXT_4TH
    11.50,                           ` TEXT_5TH
    25.15,                           ` TEXT_SCORE_1
    25.15,                           ` TEXT_SCORE_2
    25.15,                           ` TEXT_SCORE_3
    25.15,                           ` TEXT_SCORE_4
    25.15,                           ` TEXT_SCORE_5
    71.50,                           ` TEXT_N_N
    71.50,                           ` TEXT_A_A
    71.50,                           ` TEXT_M_M
    71.50,                           ` TEXT_C_C
    71.50,                           ` TEXT_O_O
    15.00,                           ` TEXT_ENTER_INITIALS
    22.00,                           ` TEXT_INITIALS_SCORE
    64.50,                           ` TEXT_INITIALS_NAME
    18.45,                           ` TEXT_INITALS_SCORE_NUM
    68.00,                           ` TEXT_INITALS_INITIALS
    40.00,                           ` TEXT_TOP_5
    21.50,                           ` TEXT_PUSH_START
    14.50,                           ` TEXT_1BONUS_FOR
    14.50,                           ` TEXT_2BONUS_FOR
    14.50,                           ` TEXT_FOR_BONUS
     0.00,                           ` TEXT_PLAYER
     0.00,                           ` TEXT_PLAYER_NUM
    36.00,                           ` TEXT_STAGE
    58.00,                           ` TEXT_STAGE_NUM
    18.00,                           ` TEXT_CHALLENGING_STAGE
    36.00,                           ` TEXT_READY
    32.00,                           ` TEXT_RESULTS
    14.50,                           ` TEXT_SHOTS_FIRED
    72.00,                           ` TEXT_SHOTS_FIRED_NUM
    14.50,                           ` TEXT_HIT_MISS_RATIO
    72.00,                           ` TEXT_HIT_MISS_RATIO_NUM
     0.00,                           ` TEXT_NUMBER_OF_HITS
     0.00,                           ` TEXT_NUMBER_OF_HITS_NUM
    29.00,                           ` TEXT_BONUS
    54.00,                           ` TEXT_BONUS_NUM
    50   ,                           ` TEXT_SPECIAL_BONUS
    50]                              ` TEXT_PERFECT

// Put text at this point
gStringsPosY = [
    0.00 ,                            ` TEXT_1UP
    3.00 ,                            ` TEXT_SCORE1P
    0.00 ,                            ` TEXT_HIGH_SCORE
    3.00 ,                            ` TEXT_20000
    97.00,                            ` TEXT_CREDIT
    97.00,                            ` TEXT_0
    11.00,                            ` TEXT_GALAGA
    19.50,                            ` TEXT_DASH_SCORE
    27.50,                            ` TEXT_50_100
    33.00,                            ` TEXT_80_160
    0.00 ,                            ` TEXT_2UP
    3.00 ,                            ` TEXT_SCORE2P
    80.50,                            ` TEXT_COPYRIGHT
    52.50,                            ` TEXT_FIGHTER_CAPTURED
    50.00,                            ` TEXT_GAME_OVER
    19.50,                            ` TEXT_HEROES
    39.00,                            ` TEXT_BEST_5
    55.50,                            ` TEXT_SCORE
    55.50,                            ` TEXT_NAME
    61.00,                            ` TEXT_1ST
    66.50,                            ` TEXT_2ND
    72.00,                            ` TEXT_3RD
    77.50,                            ` TEXT_4TH
    83.00,                            ` TEXT_5TH
    61.00,                            ` TEXT_SCORE_1
    66.50,                            ` TEXT_SCORE_2
    72.00,                            ` TEXT_SCORE_3
    77.50,                            ` TEXT_SCORE_4
    83.00,                            ` TEXT_SCORE_5
    61.00,                            ` TEXT_N_N
    66.50,                            ` TEXT_A_A
    72.00,                            ` TEXT_M_M
    77.50,                            ` TEXT_C_C
    83.00,                            ` TEXT_O_O
    16.00,                            ` TEXT_ENTER_INITIALS
    25.00,                            ` TEXT_INITIALS_SCORE
    25.00,                            ` TEXT_INITIALS_NAME
    30.00,                            ` TEXT_INITALS_SCORE_NUM
    30.00,                            ` TEXT_INITALS_INITIALS
    50.00,                            ` TEXT_TOP_5
    36.00,                            ` TEXT_PUSH_START
    47.00,                            ` TEXT_1BONUS_FOR
    55.50,                            ` TEXT_2BONUS_FOR
    64.00,                            ` TEXT_FOR_BONUS
    47.00,                            ` TEXT_PLAYER
    47.00,                            ` TEXT_PLAYER_NUM
    50.00,                            ` TEXT_STAGE
    50.00,                            ` TEXT_STAGE_NUM
    50.00,                            ` TEXT_CHALLENGING_STAGE
    50.00,                            ` TEXT_READY
    47.00,                            ` TEXT_RESULTS
    55.50,                            ` TEXT_SHOTS_FIRED
    55.50,                            ` TEXT_SHOTS_FIRED_NUM
    72.50,                            ` TEXT_HIT_MISS_RATIO
    72.50,                            ` TEXT_HIT_MISS_RATIO_NUM
    64.00,                            ` TEXT_NUMBER_OF_HITS
    64.00,                            ` TEXT_NUMBER_OF_HITS_NUM
    58.00,                            ` TEXT_BONUS
    58.00,                            ` TEXT_BONUS_NUM
    70   ,                            ` TEXT_SPECIAL_BONUS
    50   ]                            ` TEXT_PERFECT

//------------------------------------------------------------------------------
// Images 
gImageNames$ = [
	"galaga.png",					` IMAGE_GALAGA_ATLAS
	"player",						` IMAGE_PLAYER
	"player_captured",				` IMAGE_PLAYER_CAPTURED
	"enterprise",					` IMAGE_ENTERPRISE
	"commander_green",				` IMAGE_BOSS_GREEN
	"commander_blue",				` IMAGE_BOSS_BLUE
	"butterfly",					` IMAGE_BUTTERFLY
	"bee_yellow",					` IMAGE_BEE
	"wasp",							` IMAGE_GALAXIAN
	"scorpion",						` IMAGE_SCORPION
	"stingray",						` IMAGE_BOSCONIAN
	"dragonfly",					` IMAGE_DRAGONFLY
	"deathmite",					` IMAGE_MOSQUITO
	"player_explosion",				` IMAGE_PLAYER_EXPLOSION
	"beam",							` IMAGE_BEAM
	"explosion",					` IMAGE_EXPLOSION
	"blue_bullet",					` IMAGE_BLUE_BULLET
	"red_bullet",					` IMAGE_RED_BULLET
	"badge1",						` IMAGE_BADGE1
	"badge5",						` IMAGE_BADGE5
	"badge10",						` IMAGE_BADGE10
	"badge20",						` IMAGE_BADGE20
	"badge30",						` IMAGE_BADGE30
	"badge50",						` IMAGE_BADGE50
	"namco",						` IMAGE_NAMCO
	"1p-start",						` IMAGE_1P_START
	"2p-start",						` IMAGE_2P_START
	"coin-drop",					` IMAGE_COIN_DROP
	"fire-up",						` IMAGE_FIRE_UP
	"fire-down"]					` IMAGE_FIRE_DOWN

//------------------------------------------------------------------------------
// Number of sprites needed for each image type
// TODO: Fix these numbers so that BUT and BEE have just the right numbers
gSpriteNumbers = [
    0 ,                             ` IMAGE_GALAGA_ATLAS
    17,                             ` IMAGE_PLAYER - 15 lives + 2 in use
    1 ,                             ` IMAGE_PLAYER_CAPTURED
    36,                             ` IMAGE_ENTERPRISE 
    6 ,                             ` IMAGE_BOSS_GREEN
    6 ,                             ` IMAGE_BOSS_BLUE
    // TODO - Check these values for gSpriteNumbers - they are made up
    36,                             ` IMAGE_BUTTERFLY : 9*4=36 (chlngs = 10 waves @ 4/wave, 1 wave is cmndr green)
    36,                             ` IMAGE_BEE
    36,                             ` IMAGE_GALAXIAN
    36,                             ` IMAGE_SCORPION
    16,                             ` IMAGE_BOSCONIAN
    36,                             ` IMAGE_DRAGONFLY
    36,                             ` IMAGE_MOSQUITO
    1 ,                             ` IMAGE_PLAYER_EXPLOSION
    1 ,                             ` IMAGE_BEAM
    4 ,                             ` IMAGE_EXPLOSION
    4 ,                             ` IMAGE_BLUE_BULLET
    cMaxEnemyBullets,               ` IMAGE_RED_BULLET
    4 ,                             ` IMAGE_BADGE1
    1 ,                             ` IMAGE_BADGE5
    1 ,                             ` IMAGE_BADGE10
    1 ,                             ` IMAGE_BADGE20
    1 ,                             ` IMAGE_BADGE30
    5 ,                             ` IMAGE_BADGE50
    1 ,                             ` IMAGE_NAMCO
    1 ,                             ` IMAGE_1P_START
    1 ,                             ` IMAGE_2P_START
    1 ,                             ` IMAGE_COIN_DROP
    1 ,                             ` IMAGE_FIRE_UP
    1]                              ` IMAGE_FIRE_DOWN

// Number of animation frames each image has (0=1 frame not animated)
gSpriteAnimFrames = [
    0,                              ` IMAGE_GALAGA_ATLAS
    0,                              ` IMAGE_PLAYER
    0,                              ` IMAGE_PLAYER_CAPTURED
    0,                              ` IMAGE_ENTERPRISE
    2,                              ` IMAGE_BOSS_GREEN
    2,                              ` IMAGE_BOSS_BLUE
    2,                              ` IMAGE_BUTTERFLY
    2,                              ` IMAGE_BEE
    0,                              ` IMAGE_GALAXIAN
    0,                              ` IMAGE_SCORPION
    0,                              ` IMAGE_BOSCONIAN
    0,                              ` IMAGE_DRAGONFLY
    3,                              ` IMAGE_MOSQUITO
    4,                              ` IMAGE_PLAYER_EXPLOSION
    3,                              ` IMAGE_BEAM
    5,                              ` IMAGE_EXPLOSION
    0,                              ` IMAGE_BLUE_BULLET
    0,                              ` IMAGE_RED_BULLET
    0,                              ` IMAGE_BADGE1
    0,                              ` IMAGE_BADGE5
    0,                              ` IMAGE_BADGE10
    0,                              ` IMAGE_BADGE20
    0,                              ` IMAGE_BADGE30
    0,                              ` IMAGE_BADGE50
    0,                              ` IMAGE_NAMCO
    0,                              ` IMAGE_1P_START
    0,                              ` IMAGE_2P_START
    0,                              ` IMAGE_COIN_DROP
    0,                              ` IMAGE_FIRE_UP
    0]                              ` IMAGE_FIRE_DOWN

//------------------------------------------------------------------------------
// Sound data
gSoundNames$ = [
	"beam.wav",                     ` SOUND_BEAM
	"coin.wav",                     ` SOUND_COIN
	"danger.wav",                   ` SOUND_DANGER
	"dive-attack.wav",              ` SOUND_DIVE_ATTACK
	"hit-bee.wav",                  ` SOUND_HIT_BEE
	"hit-butterfly.wav",            ` SOUND_HIT_BUTTERFLY
	"hit-commander-blue.wav",       ` SOUND_HIT_BOSS_BLUE
	"hit-commander-green.wav",      ` SOUND_HIT_BOSS_GREEN
	"player-captured-song.wav",     ` SOUND_PLAYER_CAPTURED_SONG
	"player-die.wav",               ` SOUND_PLAYER_DIE
	"player-shoot.wav",             ` SOUND_PLAYER_SHOOT
	"stage-icon.wav",               ` SOUND_STAGE_ICON
	"start.wav",                    ` SOUND_START
	"highscore-loop.wav",			` SOUND_HIGHSCORE_LOOP
	"highscore-end.wav",			` SOUND_HIGHSCORE_END
	"challange-bonus-tune.wav",		` SOUND_CHALLANGE_BONUS
	"challange-perfect.wav"]		` SOUND_CHALLANGE_PERFECT


gKillSound[IMAGE_PLAYER]            = SOUND_PLAYER_DIE
gKillSound[IMAGE_PLAYER_CAPTURED]   = SOUND_PLAYER_DIE
gKillSound[IMAGE_ENTERPRISE]        = SOUND_HIT_BEE
gKillSound[IMAGE_BOSS_GREEN]   = SOUND_HIT_BOSS_GREEN
gKillSound[IMAGE_BOSS_BLUE]    = SOUND_HIT_BOSS_BLUE
gKillSound[IMAGE_BUTTERFLY]         = SOUND_HIT_BUTTERFLY
gKillSound[IMAGE_BEE]        = SOUND_HIT_BEE
gKillSound[IMAGE_GALAXIAN]              = SOUND_HIT_BEE
gKillSound[IMAGE_SCORPION]          = SOUND_HIT_BEE
gKillSound[IMAGE_BOSCONIAN]          = SOUND_HIT_BEE
gKillSound[IMAGE_DRAGONFLY]         = SOUND_HIT_BEE
gKillSound[IMAGE_MOSQUITO]         = SOUND_HIT_BEE

//------------------------------------------------------------------------------
// Spawn and path data
// The points for motion on a path.  Each path has a "mirror path" which is 
// derived from the path data here so path indicies are 2x the indicies in the array.
// Odd numbered indicies indicate derived mirror paths

#constant aPath_Top_Single				0
#constant aPath_Top_Double_Left			1
#constant aPath_Top_Double_Right		2
#constant aPath_Bottom_Single			3
#constant aPath_Bottom_Double_Out		4
#constant aPath_Bottom_Double_In		5
#constant aPath_Challange_1_1			6
#constant aPath_Challange_1_2			7
#constant aPath_Challange_2_1			8
#constant aPath_Challange_2_2			9
#constant aPath_Challange_3_1			10
#constant aPath_Challange_3_2			11
#constant aPath_Launch					12
#constant aPath_Bee_Attack				13
#constant aPath_Bee_Bottom_Circle		14
#constant aPath_Bee_Top_Circle			15
#constant aPath_Butterfly_Attack		16

#constant PATH_TOP_SINGLE				0
#constant PATH_TOP_SINGLE_MIR			1
#constant PATH_TOP_DOUBLE_LEFT			2
#constant PATH_TOP_DOUBLE_LEFT_MIR		3
#constant PATH_TOP_DOUBLE_RIGHT			4
#constant PATH_TOP_DOUBLE_RIGHT_MIR		5
#constant PATH_BOTTOM_SINGLE			6
#constant PATH_BOTTOM_SINGLE_MIR		7
#constant PATH_BOTTOM_DOUBLE_OUT		8
#constant PATH_BOTTOM_DOUBLE_OUT_MIR	9
#constant PATH_BOTTOM_DOUBLE_IN			10
#constant PATH_BOTTOM_DOUBLE_IN_MIR		11
#constant PATH_CHALLANGE_1_1			12
#constant PATH_CHALLANGE_1_1_MIR		13
#constant PATH_CHALLANGE_1_2			14
#constant PATH_CHALLANGE_1_2_MIR		15
#constant PATH_CHALLANGE_2_1			16
#constant PATH_CHALLANGE_2_1_MIR		17
#constant PATH_CHALLANGE_2_2			18
#constant PATH_CHALLANGE_2_2_MIR		19
#constant PATH_CHALLANGE_3_1			20
#constant PATH_CHALLANGE_3_1_MIR		21
#constant PATH_CHALLANGE_3_2			22
#constant PATH_CHALLANGE_3_2_MIR		23
#constant PATH_LAUNCH					24
#constant PATH_LAUNCH_MIR				25
#constant PATH_BEE_ATTACK				26
#constant PATH_BEE_ATTACK_MIR			27
#constant PATH_BEE_BOTTOM_CIRCLE		28
#constant PATH_BEE_BOTTOM_CIRCLE_MIR	29
#constant PATH_BEE_TOP_CIRCLE			30
#constant PATH_BEE_TOP_CIRCLE_MIR		31
#constant PATH_BUTTERFLY_ATTACK			32
#constant PATH_BUTTERFLY_ATTACK_MIR		33

// TODO: - Use path defines here for sizes
global gStartPathX as float[aPath_Challange_3_2]
global gStartPathY as float[aPath_Challange_3_2]

gStartPathX[aPath_Top_Single]        = 56.14
gStartPathY[aPath_Top_Single]        =  3.30
gStartPathX[aPath_Top_Double_Left]   = 56.27
gStartPathY[aPath_Top_Double_Left]   =  3.30
gStartPathX[aPath_Top_Double_Right]  = 63.52
gStartPathY[aPath_Top_Double_Right]  =  3.30
gStartPathX[aPath_Bottom_Single]     = -3.00
gStartPathY[aPath_Bottom_Single]     = 87.20
gStartPathX[aPath_Bottom_Double_Out] = -3.00
gStartPathY[aPath_Bottom_Double_Out] = 87.20
gStartPathX[aPath_Bottom_Double_In]  = -3.00
gStartPathY[aPath_Bottom_Double_In]  = 81.47
gStartPathX[aPath_Challange_1_1]     = 41.91
gStartPathY[aPath_Challange_1_1]     =  3.30
gStartPathX[aPath_Challange_1_2]     = -3.00
gStartPathY[aPath_Challange_1_2]     = 87.48
gStartPathX[aPath_Challange_2_1]     = 42.00
gStartPathY[aPath_Challange_2_1]     =  3.30
gStartPathX[aPath_Challange_2_2]     = -3.00
gStartPathY[aPath_Challange_2_2]     = 86.50


gStartPathX[aPath_Challange_3_1]     = 42.60
gStartPathY[aPath_Challange_3_1]     =  3.30
gStartPathX[aPath_Challange_3_2]     = -3.00
gStartPathY[aPath_Challange_3_2]     = 86.50

gPathDataX[aPath_Top_Single]         = [ 0.00, -1.09, -2.92, -38.68, -2.07, 0.13, 1.30, 1.94, 4.78, 1.82, 5.82,  2.84,  2.98,  1.68,  3.49,  0.13]
gPathDataY[aPath_Top_Single]         = [ 4.57,  3.60,  3.95,  30.55,  3.21, 3.00, 3.49, 2.14, 2.71, 1.07, 0.10, -1.17, -1.55, -1.45, -4.08, -1.55]
gPathDataX[aPath_Top_Double_Left]    = [ 0.00, -1.68, -3.75, -41.27,  -3.36, -0.91,  0.00,  1.82,  9.18,  7.24,   5.57,  9.44,  6.08,   3.36]
gPathDataY[aPath_Top_Double_Left]    = [ 3.78,  4.85,  5.63,  29.77,   4.95,  2.33,  4.26,  2.72,  7.86,  3.00,   0.29, -3.58, -5.14,  -4.85]
gPathDataX[aPath_Top_Double_Right]   = [ 0.00, -0.13, -1.68,  -3.75, -43.60, -0.91, -0.13,  0.91,  1.94,  4.27,   4.40,  4.53,  6.34,   3.49,   1.03]
gPathDataY[aPath_Top_Double_Right]   = [ 3.00,  2.33,  4.08,   5.62,  33.08,  1.94,  1.35,  3.59,  2.72,  2.81,   1.36,  0.39, -3.01,  -4.75,  -2.72]
gPathDataX[aPath_Bottom_Single]      = [ 3.13,  2.59,  4.52,   9.06,  12.94,  8.53,  3.24,  0.00, -1.15, -3.14,  -4.29, -4.29, -3.14,  -1.15,   1.15,  3.14,  4.29,   4.29,  3.14,  1.15]
gPathDataY[aPath_Bottom_Single]      = [ 0.00, -0.68, -1.46,  -4.75,  -8.73, -7.27, -6.99, -3.49, -3.38, -2.47, -0.90, 0.90, 2.47, 3.38, 3.38, 2.47, 0.90, -0.90, -2.47, -3.38]// Corrected
gPathDataX[aPath_Bottom_Double_Out]  = [ 6.75, 15.40, 11.51,  10.09,   9.44,  1.69,  0.00, -2.01, -5.49, -7.50, -7.50, -5.49, -2.01,  2.01, 5.49,  7.50,  7.50,  5.49,  2.01]
gPathDataY[aPath_Bottom_Double_Out]  = [ 0.00, -4.17, -5.53,  -6.89,  -8.44, -5.43, -2.13, -5.25, -3.84, -1.41, 1.41, 3.84, 5.25, 5.25, 3.84, 1.41, -1.41, -3.84, -5.25]// Corrected
gPathDataX[aPath_Bottom_Double_In]   = [ 6.88, 15.40, 11.51,   9.70,   4.40,  0.00,-1.21, -3.29, -4.50, -4.50, -3.29, -1.21, 1.21, 3.29, 4.50,  4.50,  3.29,  1.21]
gPathDataY[aPath_Bottom_Double_In]   = [ 0.00, -4.17, -5.53,  -7.17,  -6.02, -3.97,-3.38, -2.47, -0.90, 0.90, 2.47, 3.38, 3.38, 2.47, 0.90, -0.90, -2.47, -3.38]// Corrected
gPathDataX[aPath_Challange_1_1]      = [ 0.39,  6.73, 10.35,   2.20,   4.01,  4.40,  4.01,  3.88,  3.75,  3.23,   2.33,  0.00, -1.03,  -2.20,  -2.46, -5.17, -6.73, -72.60]
gPathDataY[aPath_Challange_1_1]      = [27.35, 22.79, 19.89,   3.39,   2.04,  1.94,  0.68, -1.07, -2.04, -3.10,  -3.59, -3.59, -2.13,  -2.52,  -1.46, -2.52, -1.55, -29.51]
gPathDataX[aPath_Challange_1_2]      = [ 8.82,  8.15,  5.43,   7.90,   5.43,  8.15,  8.80,  6.59,  6.21,  3.37,   0.00, -4.01, -2.72,  -2.20,  -2.72, -2.19, -0.39,   0.90,  2.20,  1.81, 2.72, 1.81,  41.94]
gPathDataY[aPath_Challange_1_2]      = [-0.57, -1.36, -1.17,  -2.23,  -1.94, -4.07, -4.66, -4.07, -4.27, -4.07, -24.83, -2.81, -0.97,   0.19,   2.04,  2.62,  1.94,  20.85,  1.84,  1.26, 0.58, 0.49, -40.49]
gPathDataX[aPath_Challange_2_1]      = [-0.02,  0.12,  1.23, 1.36,  5.93, 1.97, 0.06,  0.05, -2.08,  -5.93, -1.36,  -1.23,  -0.12]
gPathDataY[aPath_Challange_2_1]      = [ 2.53, 14.36, 15.74, 2.68, 17.22, 3.61, 0.00, -0.04, -3.57, -17.22, -2.68, -15.74, -14.36]
gPathDataX[aPath_Challange_2_2]      = [53.00, 9.67, 9.01, 7.74, 5.94, 3.73, 1.27, -1.27, -3.73, -5.94, -7.74, -9.01, -9.67, -9.67, -9.01, -7.74, -5.94, -3.73, -1.27, 1.27, 3.73, 5.94, 7.74, 9.01, 9.67, 53.00]// Corrected
gPathDataY[aPath_Challange_2_2]      = [ 0.00, -0.95, -2.80, -4.45, -5.80, -6.76, -7.25, -7.25, -6.76, -5.80, -4.45, -2.80, -0.95, 0.95, 2.80, 4.45, 5.80, 6.76, 7.25, 7.25, 6.76, 5.80, 4.45, 2.80, 0.95,  0.00]// Corrected

gPathDataX[aPath_Challange_3_1]      = [0.00, -1.93, -2.06, -3.09, -8.24, -22.39, -3.22, 0.00, 0.90, 2.58, 2.19, 17.89, 6.30, 6.18, 2.32, 2.05, 1.94, 0.00]
gPathDataY[aPath_Challange_3_1]      = [40.18, 2.70, 3.19, 3.58, 6.76, 11.50, 1.54, -1.54, -1.55, 0.20, 0.28, -8.59, -4.84, -4.92, -3.29, -3.57, -5.12, -43.11]
gPathDataX[aPath_Challange_3_2]      = [37.11, 0.64, 0.00, -0.52, -0.51, -5.41, -5.79, -4.12, -9.39, -2.45, -1.03, 0.13, 1.42, 4.25, 4.63, 5.53, 5.41, 5.79, 5.02, 2.06, 3.86, 0.39, 0.00, 0.05, 0.05, 56.28]
gPathDataY[aPath_Challange_3_2]      = [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, -1.48, -2.31, -7.54, -3.29, -4.05, -9.96, -10.04, -12.18, -5.51, -4.83, -2.80, -1.25, -0.10, 1.06, 3.96, 3.39, 26.57, 0.05, 0.00, 0.00]

gPathDataX[aPath_Launch]             = [-0.67, -1.83, -2.50,  -2.50,  -1.83, -0.67]
gPathDataY[aPath_Launch]             = [-2.50, -1.83, -0.67,   0.67,   1.83,  2.50]
gPathDataX[aPath_Bee_Attack]         = [ 1.55, 42.30,  8.67,   4.53,   5.17]
gPathDataY[aPath_Bee_Attack]         = [ 1.45, 12.22,  6.40,   5.92,   6.77]
gPathDataX[aPath_Bee_Bottom_Circle]  = [-2.34, -6.41, -8.75,  -8.75,  -6.41, -2.34]
gPathDataY[aPath_Bee_Bottom_Circle]  = [ 6.56, 4.80, 1.76, -1.76, -4.80, -6.56] // Corrected
gPathDataX[aPath_Bee_Top_Circle]     = [-2.34, -6.40, -8.75,  -8.75,  -6.40, -2.34]
gPathDataY[aPath_Bee_Top_Circle]     = [-6.56, -4.80, -1.76, 1.76, 4.80, 6.56] // Corrected
gPathDataX[aPath_Butterfly_Attack]   = [ 2.46, 31.35, 6.99, 2.33, 0]
gPathDataY[aPath_Butterfly_Attack]   = [ 2.53, 13.8, 6.02, 3.31, 4.56]


global gSpawnOrder as integer[4,1,7] // wave, enemy # in wave
gSpawnOrder[0,0] = [  7,   8,  15,  16]
gSpawnOrder[1,0] = [  0,   1,   2,   3]
gSpawnOrder[2,0] = [ 10,  18,   4,  12]
gSpawnOrder[3,0] = [ 26,  36,  22,  32]
gSpawnOrder[4,0] = [ 20,  30,  28,  38]

gSpawnOrder[0,1] = [ 24,  25,  34,  35]
gSpawnOrder[1,1] = [  6,   9,  14,  17]
gSpawnOrder[2,1] = [ 11,  19,   5,  13]
gSpawnOrder[3,1] = [ 27,  37,  23,  33]
gSpawnOrder[4,1] = [ 21,  31,  29,  39]

global gGridCols as integer[39] = [
          3, 4, 5, 6, 
    1, 2, 3, 4, 5, 6, 7, 8,  
    1, 2, 3, 4, 5, 6, 7, 8,  
 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

global gGridRows as integer[39] = [
          0, 0, 0, 0, 
    1, 1, 1, 1, 1, 1, 1, 1,  
    2, 2, 2, 2, 2, 2, 2, 2,  
 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]

global gMirror as integer[39] = [
          0, 0, 1, 1, 
    0, 0, 0, 0, 1, 1, 1, 1,  
    0, 0, 0, 0, 1, 1, 1, 1,  
 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
 0, 0, 0, 0, 0, 1, 1, 1, 1, 1]

// This indicates what type of enemy to spawn (repeats 0,1,0,1, etc.)
global gSpawnKind as integer[19, 1]
gSpawnKind[0] 	   = [IMAGE_BUTTERFLY     , IMAGE_BEE]
gSpawnKind[1] 	   = [IMAGE_BOSS_GREEN 	  , IMAGE_BUTTERFLY]
gSpawnKind[2] 	   = [IMAGE_BUTTERFLY     , IMAGE_BUTTERFLY]
gSpawnKind[3] 	   = [IMAGE_BEE      	  , IMAGE_BEE]
gSpawnKind[4] 	   = [IMAGE_BEE      	  , IMAGE_BEE]

// Challange1
gSpawnKind[5] 	   = [IMAGE_BEE       	  , IMAGE_BEE]
gSpawnKind[6] 	   = [IMAGE_BOSS_GREEN 	  , IMAGE_BEE]
gSpawnKind[7] 	   = [IMAGE_BEE       	  , IMAGE_BEE]
gSpawnKind[8] 	   = [IMAGE_BEE      	  , IMAGE_BEE]
gSpawnKind[9] 	   = [IMAGE_BEE      	  , IMAGE_BEE]

// Challange2
gSpawnKind[10] 	   = [IMAGE_BUTTERFLY     , IMAGE_BUTTERFLY]
gSpawnKind[11] 	   = [IMAGE_BOSS_GREEN 	  , IMAGE_BUTTERFLY]
gSpawnKind[12] 	   = [IMAGE_BUTTERFLY     , IMAGE_BUTTERFLY]
gSpawnKind[13] 	   = [IMAGE_BUTTERFLY     , IMAGE_BUTTERFLY]
gSpawnKind[14] 	   = [IMAGE_BUTTERFLY     , IMAGE_BUTTERFLY]

// Challange3
gSpawnKind[15] 	   = [IMAGE_DRAGONFLY     , IMAGE_DRAGONFLY]
gSpawnKind[16] 	   = [IMAGE_BOSS_GREEN 	  , IMAGE_DRAGONFLY]
gSpawnKind[17] 	   = [IMAGE_DRAGONFLY     , IMAGE_DRAGONFLY]
gSpawnKind[18] 	   = [IMAGE_DRAGONFLY     , IMAGE_DRAGONFLY]
gSpawnKind[19] 	   = [IMAGE_DRAGONFLY     , IMAGE_DRAGONFLY]

// indicates onto what path a newly spawned enemy should be put
global gPathIndicies as integer[5, 4, 1] // stage                   , wave , path index for enemy
// Stage 4 and up
gPathIndicies[0, 0] = [PATH_TOP_SINGLE_MIR        , PATH_TOP_SINGLE]
gPathIndicies[0, 1] = [PATH_BOTTOM_SINGLE     	  , PATH_BOTTOM_SINGLE_MIR]
gPathIndicies[0, 2] = [PATH_BOTTOM_SINGLE     	  , PATH_BOTTOM_SINGLE_MIR]
gPathIndicies[0, 3] = [PATH_TOP_SINGLE_MIR        , PATH_TOP_SINGLE]
gPathIndicies[0, 4] = [PATH_TOP_SINGLE_MIR        , PATH_TOP_SINGLE]

// stage 2 and up
gPathIndicies[1, 0] = [PATH_TOP_DOUBLE_RIGHT      , PATH_TOP_DOUBLE_RIGHT_MIR]
gPathIndicies[1, 1] = [PATH_BOTTOM_DOUBLE_OUT     , PATH_BOTTOM_DOUBLE_IN]
gPathIndicies[1, 2] = [PATH_BOTTOM_DOUBLE_OUT_MIR , PATH_BOTTOM_DOUBLE_IN_MIR]
gPathIndicies[1, 3] = [PATH_TOP_DOUBLE_LEFT       , PATH_TOP_DOUBLE_RIGHT]
gPathIndicies[1, 4] = [PATH_TOP_DOUBLE_LEFT_MIR   , PATH_TOP_DOUBLE_RIGHT_MIR]

// Stage 0, 1 and up
gPathIndicies[2, 0] = [PATH_TOP_SINGLE_MIR        , PATH_TOP_SINGLE]
gPathIndicies[2, 1] = [PATH_BOTTOM_SINGLE     	  , PATH_BOTTOM_SINGLE]
gPathIndicies[2, 2] = [PATH_BOTTOM_SINGLE_MIR 	  , PATH_BOTTOM_SINGLE_MIR]
gPathIndicies[2, 3] = [PATH_TOP_SINGLE            , PATH_TOP_SINGLE]
gPathIndicies[2, 4] = [PATH_TOP_SINGLE_MIR        , PATH_TOP_SINGLE_MIR]

// Special levels will go here
// Challange 1
gPathIndicies[3, 0] = [PATH_CHALLANGE_1_1         , PATH_CHALLANGE_1_1_MIR]
gPathIndicies[3, 1] = [PATH_CHALLANGE_1_2     	  , PATH_CHALLANGE_1_2]
gPathIndicies[3, 2] = [PATH_CHALLANGE_1_2_MIR  	  , PATH_CHALLANGE_1_2_MIR]
gPathIndicies[3, 3] = [PATH_CHALLANGE_1_1_MIR     , PATH_CHALLANGE_1_1_MIR]
gPathIndicies[3, 4] = [PATH_CHALLANGE_1_1         , PATH_CHALLANGE_1_1]

// Challange 2
gPathIndicies[4, 0] = [PATH_CHALLANGE_2_1         , PATH_CHALLANGE_2_1_MIR]
gPathIndicies[4, 1] = [PATH_CHALLANGE_2_2		  , PATH_CHALLANGE_2_2_MIR]
gPathIndicies[4, 2] = [PATH_CHALLANGE_2_2		  , PATH_CHALLANGE_2_2_MIR]
gPathIndicies[4, 3] = [PATH_CHALLANGE_2_1_MIR     , PATH_CHALLANGE_2_1_MIR]
gPathIndicies[4, 4] = [PATH_CHALLANGE_2_1         , PATH_CHALLANGE_2_1]

// Challange 3
gPathIndicies[5, 0] = [PATH_CHALLANGE_3_1_MIR     , PATH_CHALLANGE_3_1]
gPathIndicies[5, 1] = [PATH_CHALLANGE_3_2		  , PATH_CHALLANGE_3_2_MIR]
gPathIndicies[5, 2] = [PATH_CHALLANGE_3_2		  , PATH_CHALLANGE_3_2_MIR]
gPathIndicies[5, 3] = [PATH_CHALLANGE_3_1_MIR     , PATH_CHALLANGE_3_1]
gPathIndicies[5, 4] = [PATH_CHALLANGE_3_1_MIR     , PATH_CHALLANGE_3_1]

//------------------------------------------------------------------------------
global gAttackOrder as integer[35] = [
4, 20, 12, 30, 11, 29, 19, 39,  5, 21, 13, 31, 10, 28, 18, 38,  6, 22, 14, 32,  9, 27, 17, 37,  7, 23, 15, 33,  8, 26, 16, 36, 24, 34, 25, 35]
//global gCargo as integer[4, 1]
//gCargo[0] = [5,6,7]
//gCargo[1] = [6,7,8]
//gCargo[2] = [7,8,9]
//gCargo[3] = [8,9,10]

//------------------------------------------------------------------------------
// 0/1 indicies for looking up states or player 1 vs 2 info
gGridTime   = [cWalkTime, cBreatheTime]
gFlashIndex = [TEXT_1UP, TEXT_2UP]
gScoreIndex = [TEXT_SCORE1P, TEXT_SCORE2P]

//------------------------------------------------------------------------------
// Score data
// Score when "standing" in grid
gScoreSheet[0, IMAGE_PLAYER]          = 0
gScoreSheet[0, IMAGE_PLAYER_CAPTURED] = 0
gScoreSheet[0, IMAGE_ENTERPRISE]      = 80
gScoreSheet[0, IMAGE_BOSS_GREEN] = 0
gScoreSheet[0, IMAGE_BOSS_BLUE]  = 0
gScoreSheet[0, IMAGE_BUTTERFLY]       = 80
gScoreSheet[0, IMAGE_BEE]      		  = 50
gScoreSheet[0, IMAGE_GALAXIAN]            = 80
gScoreSheet[0, IMAGE_SCORPION]        = 80
gScoreSheet[0, IMAGE_BOSCONIAN]        = 80
gScoreSheet[0, IMAGE_DRAGONFLY]       = 80
gScoreSheet[0, IMAGE_MOSQUITO]       = 80

// Score when flying
gScoreSheet[1, IMAGE_PLAYER]          = 0
gScoreSheet[1, IMAGE_PLAYER_CAPTURED] = 0
gScoreSheet[1, IMAGE_ENTERPRISE]      = 80
gScoreSheet[1, IMAGE_BOSS_GREEN] = 400
gScoreSheet[1, IMAGE_BOSS_BLUE]  = 400
gScoreSheet[1, IMAGE_BUTTERFLY]       = 160
gScoreSheet[1, IMAGE_BEE]		      = 50
gScoreSheet[1, IMAGE_GALAXIAN]            = 80
gScoreSheet[1, IMAGE_SCORPION]        = 80
gScoreSheet[1, IMAGE_BOSCONIAN]        = 80
gScoreSheet[1, IMAGE_DRAGONFLY]       = 80
gScoreSheet[1, IMAGE_MOSQUITO]       = 80
