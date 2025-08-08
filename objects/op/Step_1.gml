++time; ti+=pi; ++dodgeTimer;

if !(time mod 30) { ++seconds; }
if (seconds == 60) { seconds=0; ++minutes; }

if (array_length(item) == 12) { fullJustItem=true; }else{ fullJustItem=false; }

if (array_length(item) == 12 and !array_contains(storage,-1)) { fullItem=true; }else{ fullItem=false; }
if (!array_contains(weapon,-1)) { fullWeapon=true; }else{ fullWeapon=false; }
if (!array_contains(armor,-1)) { fullArmor=true; }else{ fullArmor=false; }



//get key input
use_keys(); if (op.forceNotMove) { reset_keys(); }
if (walkTimeOut > 0) { --walkTimeOut; reset_keys(); }
if !(mode == "overworld" or mode == "slide") { walkTimeOut=3; reset_keys(); }

if (key_left()) { keyRight=false; } if (key_up()) { keyDown=false; }



//run
if (forceRun > 0) { --forceRun; }
if ((key_cancel() and !op.option_autoRun) or (!key_cancel() and op.option_autoRun)) or (forceRun > 0) { ++runTimer; }else{ runTimer=0; }
if (runTimer > 60) { walkMult=2.25; }else if (runTimer > 10) { walkMult=2; }else if (runTimer > 0) { walkMult=1.5; }else{ walkMult=1; }
if (world == "dark") { walkSpeed=2; }else{ walkSpeed=2.75; /*walkMult=clamp(walkMult,1,2);*/ }

pastXY=[playerX,playerY];



//move player
if (!noclip)
{
	if (movement == "overworld")
	{
		playerX+=round( ((key_right()-key_left())*walkSpeed*walkMult)*2 )/2;
		playerY+=round( ((key_down()-key_up())*walkSpeed*walkMult)*2 )/2;
	}

	if (movement == "slide")
	{
		if !(time mod 4) { effect_slidedust(playerX,playerY); }
	
		playerX+=round( ((key_right()-key_left())*walkSpeed*walkMult)*2 )/2;
		playerY+=6;
	}
}
else
{
	playerX+=round( ((key_right()-key_left())*8)*2 )/2;
	playerY+=round( ((key_down()-key_up())*8)*2 )/2;
}



var col=instance_place(playerX,playerY,oWall);
if (col != noone) { if (col.sticky) { playerX=pastXY[0]; playerY=pastXY[1];; } }

//change party members sub-image when walking
if (world == "dark") { playerSubimg+=max(walkSpeed,abs(pastXY[0]-playerX)*walkSpeed,abs(pastXY[1]-playerY)*walkSpeed)/30; }
if (world == "light") { playerSubimg+=max(walkSpeed,abs(pastXY[0]-playerX)*walkSpeed,abs(pastXY[1]-playerY)*walkSpeed)/60; }
if (playerSubimg < 1) { playerSubimg=1; }



//wall collision
if (mode == "overworld" and !noclip)
{
	wallCounter=1; wallCheck=true;
	
	var colObject=-1;
	col=noone;
	
	//check for oWall object
	if (!ghostWall)
	{
		col=instance_place(playerX,playerY,oWall);
		if (col != noone) { colObject=[oWall]; }
	}
	else
	{
		col = instance_place(playerX,playerY,oGhostWall);
		if (col != noone) { colObject=[oGhostWall]; }
	}
	
	//find which way to push the player
	if (colObject != -1)
	{
		var playerPlace=[playerX,playerY];
		
		while (place_meeting(playerX,playerY,colObject))
		{
			wallCheck=true;
			playerX=playerPlace[0];
			playerY=playerPlace[1];
			
			if (!place_meeting(playerX-wallCounter,playerY,colObject) and wallCheck) { playerX-=wallCounter; wallCheck=false; runTimer=0; }
			if (!place_meeting(playerX+wallCounter,playerY,colObject) and wallCheck) { playerX+=wallCounter; wallCheck=false; runTimer=0; }
			if (!place_meeting(playerX,playerY-wallCounter,colObject) and wallCheck) { playerY-=wallCounter; wallCheck=false; runTimer=0; }
			if (!place_meeting(playerX,playerY+wallCounter,colObject) and wallCheck) { playerY+=wallCounter; wallCheck=false; runTimer=0; }
			
			if (!place_meeting(playerX+wallCounter,playerY-wallCounter,colObject) and wallCheck) { playerX+=wallCounter; playerY-=wallCounter; wallCheck=false; runTimer=0; }
			if (!place_meeting(playerX+wallCounter,playerY+wallCounter,colObject) and wallCheck) { playerX+=wallCounter; playerY+=wallCounter; wallCheck=false; runTimer=0; }
			if (!place_meeting(playerX-wallCounter,playerY-wallCounter,colObject) and wallCheck) { playerX-=wallCounter; playerY-=wallCounter; wallCheck=false; runTimer=0; }
			if (!place_meeting(playerX-wallCounter,playerY+wallCounter,colObject) and wallCheck) { playerX-=wallCounter; playerY+=wallCounter; wallCheck=false; runTimer=0; }
			
			++wallCounter;
		}
		
		playerX = round(playerX);
		playerY = round(playerY);
	}
	
	//slope collision
	slopesAmount = 0;
	
	if (key_left() or key_up())    { if place_meeting(playerX,playerY,oSlopeUL) { slopesAmount++; slopeTouch = 1; } }
	if (key_right() or key_up())   { if place_meeting(playerX,playerY,oSlopeUR) { slopesAmount++; slopeTouch = 1; } }
	if (key_left() or key_down())  { if place_meeting(playerX,playerY,oSlopeDL) { slopesAmount++; slopeTouch = 1; } }
	if (key_right() or key_down()) { if place_meeting(playerX,playerY,oSlopeDR) { slopesAmount++; slopeTouch = 1; } }
	
	if (place_meeting(playerX,playerY,oSlopeUR) and place_meeting(playerX,playerY,oSlopeDR))
	or (place_meeting(playerX,playerY,oSlopeUL) and place_meeting(playerX,playerY,oSlopeDL))
	{ slopesAmount = 0; playerX = pastXY[0]; }
	
	if (place_meeting(playerX,playerY,oSlopeUL) and place_meeting(playerX,playerY,oSlopeUR))
	or (place_meeting(playerX,playerY,oSlopeDL) and place_meeting(playerX,playerY,oSlopeDR))
	{ slopesAmount = 0; playerY = pastXY[1]; }
	
	if (key_left() or key_up())    { while (place_meeting(playerX,playerY,oSlopeUL) and slopesAmount < 4) { runTimer=0; if key_left()  { ++playerY; } if key_up()   { ++playerX; } if (place_meeting(playerX,playerY,oWall)) { slopesAmount = 10; } } }
	if (key_right() or key_up())   { while (place_meeting(playerX,playerY,oSlopeUR) and slopesAmount < 4) { runTimer=0; if key_right() { ++playerY; } if key_up()   { --playerX; } if (place_meeting(playerX,playerY,oWall)) { slopesAmount = 10; } } }
	if (key_left() or key_down())  { while (place_meeting(playerX,playerY,oSlopeDL) and slopesAmount < 4) { runTimer=0; if key_left()  { --playerY; } if key_down() { ++playerX; } if (place_meeting(playerX,playerY,oWall)) { slopesAmount = 10; } } }
	if (key_right() or key_down()) { while (place_meeting(playerX,playerY,oSlopeDR) and slopesAmount < 4) { runTimer=0; if key_right() { --playerY; } if key_down() { --playerX; } if (place_meeting(playerX,playerY,oWall)) { slopesAmount = 10; } } }
	
	if (slopesAmount > 1)
	{
		playerX = pastXY[0];
		playerY = pastXY[1];
	}
}
else
{
	inputWait=false;
}



//set the player collision objects position to the players position
oPlayerCol.x=playerX;
oPlayerCol.y=playerY;



//fix overide walking animation
if key_up() and !(key_down() or key_left() or key_right()) { playerDirection="up"; }
if key_down() and !(key_up() or key_left() or key_right()) { playerDirection="down"; }
if key_left() and !(key_up() or key_down() or key_right()) { playerDirection="left"; }
if key_right() and !(key_up() or key_down() or key_left()) { playerDirection="right"; }

if (key_up() and playerDirection == "down") { playerDirection="up"; }
if (key_down() and playerDirection == "up") and !key_up() { playerDirection="down"; }
if (key_left() and playerDirection == "right") { playerDirection="left"; }
if (key_right() and playerDirection == "left") and !key_left() { playerDirection="right"; }

if (movement == "slide") { playerDirection="down"; }



//insert information into the first value in an array (partyPos) creates the party follow trail
if (pastXY[0] == playerX and pastXY[1] == playerY) or (mode != "overworld")
{
	moving=false;
	
	runTimer=0;
	playerSubimg=0;
	partyPos[0][2]=playerDirection;
}
else
{
	moving=true;
	
	inputWait=true;
	
	if (noclip) { playerDirection="down"; playerSubimg=0; }
	
	array_insert(partyPos,0,[playerX,playerY,playerDirection,playerSubimg,movement]); 
}



//touch dodge zone shaders that triggers attacks spawning on the overwrold
if (dodge_applyShaders)
{
	dodge_applyShaders=false;
	
	//function layer_shader_start();
	function layer_shader_start()
	{
	    if (event_type == ev_draw and event_number == ev_draw_normal)
	    {
			draw_ext(sPixel,0,0,0,room_width,room_height,,0,op.dodge_alpha*0.5);
			
	        shader_set(sha_rgb);
			
			shader_set_uniform_f(shader_get_uniform(sha_rgb,"col_r"),0);
			shader_set_uniform_f(shader_get_uniform(sha_rgb,"col_g"),0);
			shader_set_uniform_f(shader_get_uniform(sha_rgb,"col_b"),0);
			shader_set_uniform_f(shader_get_uniform(sha_rgb,"col_a"),-1+op.dodge_alpha);
	    }
	}

	//function layer_shader_end();
	function layer_shader_end()
	{
	    if (event_type == ev_draw and event_number == ev_draw_normal)
	    {
			shader_reset();
	    }
	}

	//apply shaders
	var lay_id=layer_get_id("dodge");
	layer_script_begin(lay_id,layer_shader_start);
	layer_script_end(lay_id,layer_shader_end);
}


//dodge zone player collision
if (place_meeting(playerX,playerY,oDodgeZone) and dodgeTimer > 5 and mode == "overworld")
{
	//overworld dodging is enabled
	dodge=true;
	if (dodge_alpha < 1)
	{
		dodge_alpha+=0.1;
		if (dodge_alpha == 0.1)
		{
			//spawn soul in the overworld
			instance_destroy(oSoul);
			instance_create_depth(0,0,-room_height,oSoul);
		}
	}
	
	isBoss=false;
}
else
{
	//overworld dodging is disabled
	dodge=false;
	dodge_hideParty=false;
	
	if (dodge_hit > 0) { --dodge_hit; }
	
	if (dodge_alpha > 0)
	{
		dodge_alpha-=0.1;
		//delete soul in the overworld
		if (dodge_alpha == 0) { instance_destroy(oSoul); }
	}
}



//touch door and change room
col=instance_place(playerX,playerY,oDoor);
if (col != noone and mode == "overworld")
{
	transitionInfo=[room,col.r,col.d]; mode=0; with (oChar) { reaction[0]=false; }
	op.locationCC=-1;
	transition(,function(){ op.previousRoom=room; op.locationText="Skip"; op.fountainON=false; room_goto(op.transitionInfo[1]); master_reset(); },
				function()
				{
					if (op.menuRoomTime == 0)
					{
						op.mode="overworld"; op.cameraMode="overworld";
						op.locationCCcheck=false;
						with(oMarker) { if (r == op.transitionInfo[0]) { op.playerX=x; op.playerY=y; } }
						if (op.transitionInfo[2] != -1) { op.playerDirection=op.transitionInfo[2]; }
						reset_party_position();
						
						if (!op.canMoveAfter) { op.mode="cutscene"; op.cameraMode=0; }
						op.canMoveAfter=true;
					}
				});
}



//interact in the overworld by pressing the confirm button
if tap_confirm()
{
	col=noone;
	
	if (playerDirection == "up")    { col=instance_place(playerX,playerY-12,oInteract); }
	if (playerDirection == "down")  { col=instance_place(playerX,playerY+12,oInteract); }
	if (playerDirection == "left")  { col=instance_place(playerX-12,playerY,oInteract); }
	if (playerDirection == "right") { col=instance_place(playerX+12,playerY,oInteract); }
	
	//check if you colided with any (oInteract) object
	if (col != noone)
	{
		//check if the (oInteract) object has a function to run
		if (col.func != -1)
		{
			col.check=true;
			if (!is_array(col.func)) { col.func(); }else{ col.func[col.counter](); col.counter++; if (col.counter >= array_length(col.func)) { col.counter--; } }
			
			if (col.charData != -1)
			{
				//make oChar objects animate when you interact with them
				with (oChar)
				{
					if (ranUne == col.charData)
					{
						if array_contains(seed,"look")
						{
							if (op.playerDirection == "up")    { sprite_index=walkSprites[1]; }
							if (op.playerDirection == "down")  { sprite_index=walkSprites[0]; }
							if (op.playerDirection == "left")  { sprite_index=walkSprites[3]; }
							if (op.playerDirection == "right") { sprite_index=walkSprites[2]; }
							
							image_speed=0; image_index=0;
							returnToNormal=true;
						}
						
						if array_contains(seed,"speed1")
						{
							image_speed=1; image_index=0;
							returnToNormal=true;
						}
					}
				}
			}
		}
	}
}



//spawn overworld menu by pressing the menu button
if (tap_menu() and mode == "overworld" and !dodge)
{
	dodge_hit=0;
	if (world == "dark") { instance_create_depth(0,0,-9999,oMenuOverworld); }
	if (world == "light") { instance_create_depth(0,0,-9999,oMenuOverworldLight); }
}