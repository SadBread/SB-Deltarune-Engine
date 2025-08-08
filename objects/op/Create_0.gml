fileVer = 2;
load = true;

mainMenuRoom = rMainMenu;


//debug Variables
showHitboxes=true;
debug=true;

noclip=false;

//will make the save menu and other things related look like they did in chapter 1
chapter1style=false;



//settings, creating fonts from sprites, world time & language
	//what file you are currently on (0, 1 or 2)
fileOn=0;

display_set_gui_size(320,240);
window_set_fullscreen(false); window_set_size(320*4,240*4); window_center();
instance_create_depth(0,0,0,oPlayerCol);

reset_keys(); time=0; ti=0;
seconds=0; minutes=0;

variant_csv();
	//the row text is grabed from in the csv file
language=1;

option_volume=60;
option_simplifyVFX=false;
option_autoRun=false;
keybinds=[[0,vk_down],[0,vk_right],[0,vk_up],[0,vk_left],[1,"Z"],[1,"X"],[1,"C"]];
gamepadBinds = [gp_padd,gp_padr,gp_padu,gp_padl,gp_face1,gp_face2,gp_face4];
config_load();
audio_group_set_gain(audiogroup_default,op.option_volume/100,0);

fontHP=font_add_sprite_ext(sFontHP,"1234567890-",true,1);
fontDamage=font_add_sprite_ext(sFontDamage,"1234567890-+%",true,0);
fontGold=font_add_sprite_ext(sFontGold,"1234567890-+%/",true,0);

textFadeAlpha=0;



//finished Variables (you don't have to use or set these)
image_alpha=0; reset_keys(); reset_cursor(); cursor=-1;

#region

boxImage=3; boxImageSpeed=0.1; stackFix=0;
battleSticks=[1,3,7]; battleRaise=[0,0,0]; hudY=0;
battleTime=0; forceTextWait=0;
retryBattleTimer=0; menuPrompt=[0,0,0,0];
inputWait=true; dogRandom=0; setFollowerNumb=-1;
shortcutDoorRoom=-1; quitTime=0; dodgeTimer=0;
fountainON=false;
soul4XY=[0,0];
dieSprite=-1;
forceNotMove=false; canMoveAfter=true;
resetPartyPosTimer=0;
partyGuaranteeFunc=-1;

une=0;
dead=false;
darkEntranceRoom=-1; darkEntranceX=[0,0,0]; darkEntrancFast=false;
debugSave=[0,0,0];

promptCursor=0;
structAt=0;
previousRoom=-1;

#endregion



//special variables
transitionInfo=[];
overworldMenuSaveCursor=[0,0,0];

	//you can set these variables and then run start_cutscene("cc_anything"); if you just want some small dialouge and not a whole cutscene
	//check the cc_anything struct for more info
textCC=[];
funcCC=-1;
faceCC=-1;

ccImage=0; ccLine=0;

	//is automaticaly set to true if the corresponding inventory is full
fullJustItem=false;
fullItem=false;
fullWeapon=false;
fullArmor=false;

	//this variable (should usually) automaticaly be set to whatever party member you are sellecting in any cenario
partyOn=0;



//control variables
world="dark";
mode=0;
movement="overworld";

	//check the script catagory scr_camera for camera control
cameraMode="overworld"; camOffsetX=0; camOffsetY=0;
camShakeX=0;
camShakeY=0;
camShake=[0,0];
camMove=[0,0,0,0,0,0,0,0,0,0];

	//there are custom audio functions that control music and sound. Check the script catagory scr_sound
currentMusic=-1;
pastMusic=-1;

	//in a oCreate object whatever you set this text to will be what 
locationText="Skip";
locationCC=-1;
locationCCcheck=false;



//declare and reset data
declare_gamestats();



//overworld
partyPos=[[0,0,"down",0,"overworld"]]; pastXY=[0,0];

playerX=x;
playerY=y;
playerSubimg=0;
playerDirection="down";

walkSpeed=2;
walkMult=1;
runTimer=0;
walkTimeOut=0;
moving=false;

wallCounter=0;
wallCheck=true;

forceRun=0;

checkpointProgress=[];



//battle variables
continueOrders=false;
isBoss=false;
endCC=-1;

battle_enemyTouchInfo=[];

battle_enemyString=[];
battle_enemy=[];

battle_enemyXY=[];
battle_partyXY=[];

battle_magicActions=[];

battle_enemyHP=[0,0,0];
battle_enemySpare=[0,0,0];
battle_enemyTired=[false,false,false];

battle_background=[false,false];
battle_music=-1;
battle_flavourText="A";
battle_seed=[];

battle_tpMult = 1;

battle_enemysLeft=0;

menuPep=0;
save_partyXY=[];
gainMoney=0;

	//is set to false when any battle begins. Is set to true when you kill atleast one enemy in battle. (Not for bosses)
killedAny=false;

oldEnemyXY=[];



//overworld dodging variables
dodge=false;
dodge_applyShaders=true;
dodge_alpha=0; dodge_hideParty=false;
dodge_hit=0;

//extra
slopesAmount = 0; slopeTouch = 0;
ghostWall = false;