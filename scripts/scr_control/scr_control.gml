//generaly resets the most important variables to their default
//note: this is run every time you switch rooms for example
function master_reset(_partyFollowReset = true)
{
	op.overworldMenuSaveCursor=[0,0,0,0,0,0,0,0,0];
	
	if (_partyFollowReset)
		op.partyFollow=[0,1,2];
		
	op.cameraMode="overworld";
	op.camOffsetX=0; op.camOffsetY=0;
	op.une=0;
	
	op.battle_enemyTouchInfo=[];
	
	op.dodge_applyShaders=true;
	op.dodge_hit=0;
	op.dodge=false; op.dodge_alpha=0; op.dodgeTimer=0;
	
	op.fountainON=false;
	
	op.forceNotMove=false;
	
	
	
	if (op.darkEntranceRoom == "wait") { op.darkEntranceRoom=-1; }
	
	update_allData();
}


/*
When this function is run it will store all of your party members data in an array that is disconected from your current party stats.
This makes it so that when a party member is removed from the party their stats will still be saved and will be the same as they was
when they are returned to the party.
*/
function update_allData()
{
	var numb=-1;
	var i=0, j=0;
	
	repeat (array_length(op.party))
	{
		numb=op.party[i]._numberExistence;
		while (numb >= array_length(op.allData)) { array_push(op.allData,-1); }
		
		//
		var equipped_=[];
		j=0; repeat (array_length(op.equipped[i])) { if (op.equipped[i][j] != -1) { array_push(equipped_,instanceof(op.equipped[i][j])); }else{ array_push(equipped_,-1); } ++j; }
		var spells_=[];
		j=0; repeat (array_length(op.spells[i])) { array_push(spells_,instanceof(op.spells[i][j]));++j; }
		//
		op.allData[numb]=[op.hp[i],op.hpMax[i],op.attack[i],op.defense[i],op.magic[i],op.guts[i],op.level[i],op.ability[i],equipped_,spells_];
		//
		
		++i;
	}
}

//if you remove and then add back a party member into the party their stats will still be the same thanks to this function
//you shouldn't have to use this function manualy, as it is connected to the function that adds a party member back to your team
function update_stats()
{
	var numb=-1, data=-1;
	var i=0, j=0;
	
	repeat (array_length(op.party))
	{
		numb=op.party[i]._numberExistence;
		if (array_length(op.allData) > numb)
		{
			data=op.allData[numb];
		
			op.hp[i]=data[0];
			op.hpMax[i]=data[1];
			op.attack[i]=data[2];
			op.defense[i]=data[3];
			op.magic[i]=data[4];
			op.guts[i]=data[5];
			op.level[i]=data[6];
			op.ability[i]=data[7];
			
			op.equipped[i]=[]; j=0; repeat (array_length(data[8])) { if (data[8][j] == -1) { array_push(op.equipped[i],-1); }else{ struct(data[8][j]); array_push(op.equipped[i],str); } ++j; }
			op.spells[i]=[]; j=0; repeat (array_length(data[9])) { struct(data[9][j]); array_push(op.spells[i],str); ++j; }
		}
		
		++i;
	}
}



//sets flags for progress made in the game.
function add_progress(_value)
{
	if (!has_progress(_value)) { array_push(op.progress,_value); }
}

//checks if a flag has been set
function has_progress(_value)
{
	if array_contains(op.progress,_value) { return(true); }else{ return(false); }
}



//run this function in a room that is only a menu and not somewhere the party walks around (Like the main menu for example)
function menu_room()
{
	op.menuRoomTime=3;
	
	op.mode=0;
	instance_destroy(oChar);
}

//easy function that sets the players mode
function set_mode(_mode="overworld")
{
	op.mode=_mode;
}

//destroy run object of designated type value
function destroy_run_object(_type=-1)
{
	with (oRun)
	{
		if (type == _type) { instance_destroy(); }
	}
}



//this function will send the player to a different room in the same way walking into a door does
function regular_room_transition(_room,_canMoveAfter=true,_direction=-1)
{
	if (_direction == 0) { _direction="up"; }
	if (_direction == 1) { _direction="down"; }
	if (_direction == 2) { _direction="left"; }
	if (_direction == 3) { _direction="right"; }
	
	with (instance_create_depth(op.playerX,op.playerY,9999,oDoor))
	{
		r=_room;
		d=_direction;
	}
	
	op.forceNotMove=true;
	set_mode("overworld");
	
	op.canMoveAfter=_canMoveAfter;
}



//set the location text and the location cutscene
function savepoint_text(_locationText="Skip",_locationCC=-1)
{
	op.locationText=_locationText;
	op.locationCC=_locationCC;
}



//will trigger this function after the party oChar objects spawn
function party_guarantee(_func=-1)
{
	op.partyGuaranteeFunc=_func;
}