++time;
pastXY=[x,y];

//shake char
if (shakeInfo[0] > -1)
{
	if (shakeInfo[3] > 0 and shakeInfo[0] > 0) { shakeX=(shakeInfo[0]/shakeInfo[3])*shakeInfo[3]*sign(shakeX); shakeY=(shakeInfo[0]/shakeInfo[3])*shakeInfo[3]*sign(shakeY); }
	shakeInfo[0]--;
	if (shakeInfo[1] > 0) { if (shakeX == 0) { shakeX=shakeInfo[1]; }else{ shakeX*=-1; } }
	if (shakeInfo[2] > 0) { if (shakeY == 0) { shakeY=shakeInfo[2]; }else{ shakeY*=-1; } }
	
	
	
	if (shakeInfo[0] == -1)
	{
		shakeInfo=[-1,0,0,0];
		shakeX=0; shakeY=0;
	}
}

var _numb=-1;
var _i=0;

if (walkOffsetMode == 2 and op.moving) { ++walkOffset; }
if (walkOffset == 0 and walkOffsetMode != 0) { walkOffsetMode=0; }



if (returnToNormal and op.mode="overworld") { returnToNormal=false; sprite_index=walkSprites[defaultWalkSprite]; image_index=0; image_speed=0; }



//declare special variables
if (time == 1)
{
	if (type == "pep")
	{
		if (op.world == "light") { _i=4; }
		
		_numb=numb;
		
		walkSprites=[op.party[_numb]._spriteWalk[0+_i],op.party[_numb]._spriteWalk[1+_i],op.party[_numb]._spriteWalk[2+_i],op.party[_numb]._spriteWalk[3+_i]];
		
		with (oCharCol) { if (type == other.type and numb == other.numb) { instance_destroy(); } }
		with (instance_create_depth(x,y,-9999,oCharCol)) { type=other.type; numb=other.numb; }
	}
	else
	{
		if is_array(walkSprites)
		{
			if (array_length(walkSprites) == 1) { defaultWalkSprite=0; }else{ defaultWalkSprite=1; }
			
			if array_contains(seed,"defaultUp")    { defaultWalkSprite=0; }
			if array_contains(seed,"defaultDown")  { defaultWalkSprite=1; }
			if array_contains(seed,"defaultLeft")  { defaultWalkSprite=2; }
			if array_contains(seed,"defaultRight") { defaultWalkSprite=3; }
			
			sprite_index=walkSprites[defaultWalkSprite];
		}
		else
		{
			sprite_index=walkSprites;
			defaultWalkSprite=-1;
		}
	}
	
	if (type == 0) { image_index=0; image_speed=0; }
	
	//spawn connections
	if (func != -1)
	{
		with (instance_create_depth(x,y,0,oInteract))
		{
			forceHide=true;
			charData=other.ranUne;
			
			func=other.func;
			spawnWall=false;
		}
	}
	func=-1;
	
	//give the oChar object collision
	if array_contains(seed,"wall")
	{
		with (instance_create_depth(-9999,-9999,0,oWall))
		{
			forceHide=true;
			charData=other.ranUne;
		}
	}
}






//party members and followers | visuals and functionality
if (type == "pep" or type == "follower") and ((op.mode == "overworld" and array_length(animate) == 0) or (op.resetPartyPosTimer > 0))
{
	//set numb math
	if (numb != 0)
	{
		if (type == "pep") { _numb=numb+op.partyPosOffset[numb]; }
		if (type == "follower") { _numb=op.followers[followerNumb][0]; }
		number=_numb;
		numbClamp=clamp(walkOffset+_numb*12,0,array_length(op.partyPos)-1);
	}
	
	extraX=0; extraY=0;
	
	//lerp party after cutscene is done and you can move again
	if (cutsceneStarted and cutsceneHappened)
	{
		image_index=0; image_speed=0;
		walkOffset=0;
		
		if (numb != 0)
		{
			if (type == "pep") { _numb=numb+op.partyPosOffset[numb]; }
			if (type == "follower") { _numb=op.followers[followerNumb][0]; }
			
			//figure out who's ahead
			res_u(); u3=0; with (oChar) { if (number == other.number-1) and (type == "pep" or type == "follower") { other.u3=numb; } }
			
			//lerp math
			u1=[x,y,char(u3).x,char(u3).y];
			u2=pos_to_ang(u1[0],u1[1],u1[2],u1[3]);
			
			repeat (12)
			{
				op.partyPos[-u+_numb*12][0]=lerp(u1[0],u1[2],(1/12)*u);
				op.partyPos[-u+_numb*12][1]=lerp(u1[1],u1[3],(1/12)*u);
				op.partyPos[-u+_numb*12][2]=u2;
				op.partyPos[-u+_numb*12][3]=0;
				++u;
			}
		}
	}
	
	cutsceneStarted=false;
	
	if (array_contains(op.partyFollow,numb)) or (type == "follower" and followerFollow)
	{
		//set numb math
		if (type == "pep") { _numb=numb+op.partyPosOffset[numb]; }
		if (type == "follower") { _numb=op.followers[followerNumb][0]; }
		number=_numb;
		numbClamp=clamp(walkOffset+_numb*12,0,array_length(op.partyPos)-1);
		
		if (op.partyPos[numbClamp][4] == "overworld" and walkOffsetMode == 1) { walkOffsetMode=2; }
		
		//set x & y to follow after the player
		if (walkOffsetMode != 2)
		{
			x=op.partyPos[numbClamp][0];
			y=op.partyPos[numbClamp][1];
		}

		if (op.inputWait or op.resetPartyPosTimer > 0)
		{
			//set sprites for following the player
			direction_=op.partyPos[numbClamp][2];
			if (direction_ == "up") { sprite=walkSprites[0]; }
			if (direction_ == "down") { sprite=walkSprites[1]; }
			if (direction_ == "left") { sprite=walkSprites[2]; }
			if (direction_ == "right") { sprite=walkSprites[3]; }
			
			//set subimg for following the player
			_subimg=op.partyPos[numbClamp][3]; _subimg=op.partyPos[0][3];
			
			if (op.pastXY[0] == op.playerX and op.pastXY[1] == op.playerY) or (op.partyPos[numbClamp][0] == op.partyPos[clamp(walkOffset+1+_numb*12,0,array_length(op.partyPos)-1)][0] and op.partyPos[numbClamp][1] == op.partyPos[clamp(walkOffset+1+_numb*12,0,array_length(op.partyPos)-1)][1])
			{
				_subimg=0;
			}
			
			//set sprite_index and image_index to their respective variables
			if (op.partyPos[numbClamp][4] == "overworld")
			{
				sprite_index=sprite;
				image_index=_subimg;
			}
			
			//set sprites for sliding down a cliff
			if (op.partyPos[numbClamp][4] == "slide")
			{
				if (type == "pep") { sprite_index=op.party[numb]._spriteSlide; }
				if (type == "follower") { sprite_index=op.followers[followerNumb][3]; }
				
				image_index=op.time/5;
				
				if (numb != 0 and op.movement == "overworld" and !op.moving) { --walkOffset; if (walkOffsetMode == 0) { walkOffsetMode=1; } }
			}
		}
	}
	else
	{
		//if the party members can't move set image_index & image_speed to 0
		if (array_length(animate) == 0) { image_index=0; image_speed=0; }
	}
}



//set x & y to the right place when you suddenly can't move anymore
if (!cutsceneStarted and op.mode != "overworld" and op.mode != "battleOver")
{
	cutsceneStarted=true;
	if (!returnToNormal) { image_index=0; image_speed=0; }
	
	if (numb == 0 or numb == 1 or numb == 2) or (type == "follower")
	{
		//set numb math
		if (type == "pep") { _numb=numb+op.partyPosOffset[numb]; }
		if (type == "follower") { _numb=op.followers[followerNumb][0]; }
		number=_numb;
		numbClamp=clamp(walkOffset+_numb*12,0,array_length(op.partyPos)-1);
		
		//set x & y
		if (type == "pep" and array_contains(op.partyFollow,numb)) or (type == "follower" and followerFollow)
		{
			x=op.partyPos[numbClamp][0];
			y=op.partyPos[numbClamp][1];
		}
	}
}



//animate & cutscene
if (array_length(animate) > 0)
{
	//declare major changes
	if (animateCheck)
	{
		animateCheck=false;
		animate[0][7]=x; animate[0][8]=y;
		
		if (animate[0][2] != -1) { image_speed=animate[0][2]; }
		if (animate[0][3] != -1) { sprite_index=animate[0][3]; }
		if (animate[0][4] != -1) { image_index=animate[0][4]; }
		
		if (animate[0][9] != -1) { animate[0][9](); }
		
		
		
		//special setup
		subnumber=false;
		if (array_contains(animate[0][11],"subnumber") and !subnumber) { subnumber=true; }
		
		//auto pick walk animation based on where the character will move
		if (animate[0][3] == -1 and array_length(walkSprites) > 1) and (animate[0][5] != -1 or animate[0][6] != -1) and (!array_contains(animate[0][11],"autooff"))
		{
			findAngle=pos_to_ang(animate[0][7],animate[0][8],animate[0][5],animate[0][6],true);
			sprite_index=walkSprites[findAngle]; image_index=1;
		}
		
		extraX=0;
		extraY=0;
	}
	
	//move x & y
	if (animate[0][5] != -1) { x+=(animate[0][5]-animate[0][7])/animate[0][1]; }
	if (animate[0][6] != -1) { y+=(animate[0][6]-animate[0][8])/animate[0][1]; }
	
	//decrease timer (once 0 the animation stops)
	--animate[0][0];
	
	if (numb == 0) { op.playerX=x; op.playerY=y; }
	
	
	
	//special animations
	if array_contains(animate[0][11],"jump") { extraY=sin((animate[0][0]/animate[0][1])*pi)*-80; }
	if array_contains(animate[0][11],"jump2") { extraY=sin((animate[0][0]/animate[0][1])*pi)*-30; }
	if array_contains(animate[0][11],"jumpOffset") { extraY-=20 }
	
	if array_contains(animate[0][11],"fadeEffect") { if !(op.time mod 2) or array_contains(animate[0][11],"fadeFast") { effect_fade(sprite_index,image_index,x+extraX,y+extraY,,,,,,depth+50); } }
	
	
	
	//declare values when the animation is over (timer equals 0)
	if (animate[0][0] <= 0 and !subnumber)
	{
		if (type == 0) { extraX=0; extraY=0; }
		
		//run custom function when the animation is over
		if (animate[0][10] != -1) { animate[0][10](); }
		
		//automaticaly set image_index and image_speed to 0 when the animation is over (can be disabled)
		if (animate[0][5] != -1 or animate[0][6] != -1) { if (!array_contains(animate[0][11],"autooff")) { image_speed=0; image_index=0; } }
		
		//set walk direction sprite when the animation is over
		if (array_contains(animate[0][11],"faceUp")) { sprite_index=walkSprites[0]; extraX=0; extraY=0; }
		if (array_contains(animate[0][11],"faceDown")) { sprite_index=walkSprites[1]; extraX=0; extraY=0; }
		if (array_contains(animate[0][11],"faceLeft")) { sprite_index=walkSprites[2]; extraX=0; extraY=0; }
		if (array_contains(animate[0][11],"faceRight")) { sprite_index=walkSprites[3]; extraX=0; extraY=0; }
		
		
		
		//set numb math
		_numb=-1;
		if (type == "pep") { _numb=numb+op.partyPosOffset[numb]; }
		if (type == "follower") { _numb=op.followers[followerNumb][0]; }
		
		//fix op.partyPos array based on where you moved the (ochar) objects
		if (_numb != -1) { if array_contains(op.partyFollow,_numb) or (type == "follower") { op.partyPos[_numb*12][0]=x; op.partyPos[_numb*12][1]=y; } if (_numb == 0) { op.playerX=x; op.playerY=y; op.playerDirection=pos_to_ang(animate[0][7],animate[0][8],animate[0][5],animate[0][6]); op.playerSubimg=0; } }
		
		array_delete(animate,0,1); animateCheck=true;
	}
}



//manual effects
if (effect == "fadeEffect" or effect == "fadeFast")
{
	if !(op.time mod 4) or (effect == "fadeFast") { effect_fade(sprite_index,image_index,x,y,,,,,,depth+50); }
}






//enemy | visuals and functionality (Warning this code sucks)
if (type == "enemy" and str != -1)
{
	if (op.mode != "battle")
	{
		//Enemy only moves when the player CAN move
		if (op.mode == "overworld") { image_speed=1; path_speed=pathSpeed; }else{ image_speed=0; path_speed=0; }
		
		//Reacting to the player getting close (exclamation over head then start chasing)
		if (reaction[1] != 0)
		{
			//first frame starts to move along path
			if (time == 1)
			{
				if (path != -1) { path_start(path,pathSpeed,true,false); }
				reaction[1]=clamp(str._reactionTime,1,999);
			}
			
			//detecting player distance
			if (time > 10 and distance_to_object(oPlayerCol) <= str._reactionDistance and array_length(animate) == 0 and !reaction[0] and op.mode == "overworld" and !array_contains(seed,"oblivious") and !array_contains(op.winRooms,room))
			{
				if (str._reactionTime != 0) { sound(snd_exclamation); }
				path_end();
				reaction[0]=true;
			}
			
			//enemy freezing in place after seeing you delay
			if (reaction[0])
			{
				--reaction[1];
				image_speed=0;
				
				//delay runs out
				if (reaction[1] == 0) { pastXY=[x,y]; }
			}
			
			//change enemy xscale based on if it's moving to the left or right along a path
			if (path != -1)
			{
				if (path_get_x(path,path_position)-path_get_x(path,path_position-0.01) > 0) { xscale=-1; }
				if (path_get_x(path,path_position)-path_get_x(path,path_position-0.01) < 0) { xscale=1; }
			}
		}
		
		
		//enemy chases player
		if (reaction[0] and reaction[1] == 0 and op.mode == "overworld")
		{
			if (reaction[2] < str._runSpeed) { reaction[2]+=0.5; reaction[2]=clamp(reaction[2],-999,str._runSpeed); }
			dWalkXY=[dcos(point_direction(x,y,op.playerX,op.playerY))*reaction[2],dsin(point_direction(x,y,op.playerX,op.playerY))*reaction[2]];
			reaction[3]=true;
			
			//move x
			x+=dWalkXY[0];
			//collide with wall X axsis
			while (place_meeting(x,y,[oWall,oEnemyWall])) { x=round(x); x-=sign(dWalkXY[0]); reaction[3]=false; if (sign(dWalkXY[0]) < 0) { xscale=1; } if (sign(dWalkXY[0]) > 0) { xscale=-1; } }
			
			//move x
			y-=dWalkXY[1];
			//collide with wall Y axsis
			while (place_meeting(x,y,[oWall,oEnemyWall])) { y=round(y); y+=sign(dWalkXY[1]); }
			
			//change enemy xscale based on if it's moving to the left or right
			if (reaction[3])
			{
				if (x-pastXY[0] < -0.1) { xscale=1; }
				if (x-pastXY[0] > 0.1) { xscale=-1; }
			}
		}
		
		//enemy touches player and triggers the battle
		if (place_meeting(x,y,oPlayerCol))
		{
			with (oChar)
			{
				reaction[0]=false; reaction[1]=0; path_end();
				if (strString == other.strString and une != other.une) { numb=-1; }
			}
		
			reaction[4]=true; xscale=1; op.mode=0; sprite_index=str._spriteTouch;
		}
		
		//delay and then battle_start is run
		if (reaction[4])
		{
			++reaction[5];
			if (reaction[5] == 1) { audio_sound_pitch(snd_tensionhorn,1); sound(snd_tensionhorn); }
			if (reaction[5] == 10) { audio_sound_pitch(snd_tensionhorn,1.1); sound(snd_tensionhorn); }
		
			if (reaction[5] == 30)
			{
				op.battle_enemyTouchInfo=[strString,numb,x,y];
				start_battle();
			}
		}
	}
	
	//in battle, if the enemy is at 100% spare the idle animations are replaced with the sprite _spriteHappy from the enemy struct
	if (op.mode == "battle") and (numb == "ene0" or numb == "ene1" or numb == "ene2")
	{
		number=real(string_char_at(numb,4));
		if (op.battle_enemySpare[number] == 100 and sprite_index == op.battle_enemy[number]._spriteIdle and op.battle_enemy[number]._spriteIdle != op.battle_enemy[number]._spriteHappy)
		{
			sprite_index=op.battle_enemy[number]._spriteHappy;
		}
	}
}






//subnumber control
if (subnumber and image_index > image_number-1) { subnumber=false; image_speed=0; }

//set depth in battle
if (!front)
{
	depth=-y;
	if (op.battle_background[1] or op.mode == "darkEntrance")
	and ( (type == "pep") or (type == "enemy" and (numb == "ene0" or numb == "ene1" or numb == "ene2")) )
	{
		depth-=(room_height+100);
		if (op.mode == "darkEntrance") and (numb == 0 or numb == 1 or numb == 2) { depth-=numb*100; }
	}
}

if (type == "pep" or type == "follower") and (op.ghostWall)
{
	depth -= room_height;
}

//force front
if (front) { depth=-9999; }

//set the (oCharCol) object to the x & y of their corresponding (oChar) objects
with (oCharCol) { if (type == other.type and numb == other.numb) { x=other.x; y=other.y; } }