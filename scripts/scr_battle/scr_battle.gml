//this function sets up the stats that the battle will have
//like the enemy types, music used, background type, enemy and party member x&y positions & other things related
function setup_battle(_enemyStructs=["enemy_base"],_flavourTextFirst="SKIP",_partyXY=-1,_enemyXY=-1,magic_actions=[[],["spell_standard"]],_isBoss=false,_battle_music=mus_rudeBuster,_endCC=-1,_background=true,_seed=[],_tpMult=1)
{
	var counter=0;
	
	op.cameraMode=0; op.gainMoney=0;
	
	if (magic_actions == -1) { magic_actions=[[],[],[]]; }
	op.battle_magicActions=magic_actions; op.battle_seed=_seed;
	op.battle_enemyString=[]; op.battle_enemy=[];
	
	op.battle_flavourText=_flavourTextFirst;
	op.isBoss=_isBoss;
	op.endCC=_endCC;
	
	op.battle_tpMult = _tpMult;
	
	op.battle_music=_battle_music;
	
	repeat(array_length(_enemyStructs))
	{
		array_push(op.battle_enemyString,_enemyStructs[counter]);
		struct(_enemyStructs[counter]); array_push(op.battle_enemy,str);
		
		++counter;
	}
	
	if (_partyXY != -1)
	{
		op.battle_partyXY=_partyXY;
	}
	else
	{
		if (array_length(op.party) == 1) { op.battle_partyXY=[[75,110]]; }
		if (array_length(op.party) == 2) { op.battle_partyXY=[[50,87],[58,134]]; }
		if (array_length(op.party) == 3) { op.battle_partyXY=[[50,63],[58,109],[51,151]]; }
	}
	
	if (_enemyXY != -1)
	{
		op.battle_enemyXY=_enemyXY;
	}
	else
	{
		if (array_length(_enemyStructs) == 1) { op.battle_enemyXY=[[270,104]]; }
		if (array_length(_enemyStructs) == 2) { op.battle_enemyXY=[[264,71],[279,128]]; }
		if (array_length(_enemyStructs) == 3) { op.battle_enemyXY=[[270,74],[233,114],[271,153]]; }
	}
	
	op.battle_background=[_background,false];
}



//this function starts the battle with the stats that was set up previously
function start_battle()
{
	instance_destroy(ob); instance_create_depth(0,0,0,ob);
	
	if (op.battle_music != -1) { audio_pause_sound(op.currentMusic); op.pastMusic=op.currentMusic; op.currentMusic=-1; }
	
	file_save("battle");
	
	op.mode="battle"; op.cameraMode=0; op.killedAny=false;
	
	op.gainMoney=0;
	op.battle_enemyHP=[0,0,0]; op.battle_enemySpare=[0,0,0]; op.battle_enemyTired=[false,false,false];
	op.save_partyXY=[];
	
	if (true) { op.battle_background[1]=true; instance_create_depth(0,0,-room_height,oBattleBC); }
	
	var counter=0, counter2=0, glideDelay=15;
	
	//move party to the left (or wherever)
	repeat (array_length(op.party))
	{
		if (op.retryBattleTimer > 0)
		{
			char_animate(counter,1,0,,,op.battle_partyXY[counter][0]+(op.x-160),op.battle_partyXY[counter][1]+(op.y-120));
			glideDelay=1;
		}
		
		array_push(op.save_partyXY,[char(counter).x,char(counter).y,char(counter).sprite_index,char(counter).direction_]);
		
		char_animate(counter,glideDelay,0,op.party[counter]._spriteGlide,0,op.battle_partyXY[counter][0]+(op.x-160),op.battle_partyXY[counter][1]+(op.y-120),,function(){ if (other.numb == 0) { sound(snd_weaponpullfast); } },["fadeEffect"]);
		char_animate(counter,15,1,op.party[counter]._spriteEnterBattle,0,,,,,["subnumber"]);
		char_animate(counter,1,1,op.party[counter]._spriteIdle,0);
		
		++counter;
	}
	
	char_animate(0,1,,,,,,function()
	{
		instance_create_depth(0,0,0,oMenuBattle); with (oChar) { if (type == "enemy" and !(numb == "ene0" or numb == "ene1" or numb == "ene2")) { instance_destroy(); } }
		res_i(); repeat (array_length(op.battle_enemy)) { char_animate("ene"+string(i),1,1,op.battle_enemy[i]._spriteIdle,0); ++i; }
		
		if (op.battle_music != -1) { music(op.battle_music); }
	});
	
	//move or create enemys
	counter=0;
	repeat (array_length(op.battle_enemy))
	{
		op.oldEnemyXY=[];
		array_push(op.oldEnemyXY,[char("ene"+string(counter)).x,char("ene"+string(counter)).y]);
		
		op.battle_enemyHP[counter]=op.battle_enemy[counter]._hp;
		
		counter2=0;
		if (!char_exists("ene"+string(counter),true))
		{
			var anyExists=false;
			if (array_length(op.battle_enemyTouchInfo) != 0)
			{
				if (op.battle_enemyTouchInfo[0] == op.battle_enemyString[counter]) { anyExists=true; }
			}
			
			//spawn enemy char if they don't exist
			if (anyExists)
			{
				create_char_enemy("ene"+string(counter),op.battle_enemyString[counter],,,,op.battle_enemyTouchInfo[2],op.battle_enemyTouchInfo[3]);
			}
			else
			{
				create_char_enemy("ene"+string(counter),op.battle_enemyString[counter],,,,op.x+260,op.battle_enemyXY[counter][1]+(op.y-120));
			}
		}
		
		char_animate("ene"+string(counter),15,1,op.battle_enemy[counter]._spriteGlide,0,op.battle_enemyXY[counter][0]+(op.x-160),op.battle_enemyXY[counter][1]+(op.y-120));
		++counter;
	}
	
	//delete enemy char that isn't part the battle
	with (oChar) { if (type == "enemy") { xscale=1; reaction[0]=false; reaction[1]=0; } }
}



//run this function to end the battle
function end_battle()
{
	instance_destroy(oDialogue);
	
	var i=0;
	repeat (array_length(op.party))
	{
		if (op.killedAny and !op.isBoss)
		{
			op.encounterKills[op.party[i]._numberExistence]+=1;
			if (op.party[i]._killChange[op.encounterKills[op.party[i]._numberExistence]-1] != -1)
			{
				op.party[i]._killChange[op.encounterKills[op.party[i]._numberExistence]-1](op.party[i]._numberExistence);
			}else{ op.encounterKills[op.party[i]._numberExistence]-=1; }
		}
		
		if (op.hp[i] < 1) { op.hp[i]=round(op.hpMax[i]*0.15); }
		
		char_animate(i,1,1,op.party[i]._spriteVictory,0,,,,,["override","subnumber"]);
		++i;
	}
	
	start_cutscene("cc_youWon",40);
}

//run this function to forcefully destroy every battle element
function destroy_battle(_justDelete=false)
{
	var i=0;
	
	if (!_justDelete) { op.mode="battleOver"; op.battleTime=0; }
	
	with (oRun) { if (type == "pattern") { instance_destroy(); } }
	
	i=0;
	repeat (3)
	{
		if (oMenuBattle.sel_object[i] != -1) { instance_destroy(oMenuBattle.sel_object[i]); }
		
		instance_destroy(op.battle_enemy[i]._handler);
		
		++i;
	}
	
	
	
	if (op.isBoss) { audio_stop_all(); sound(snd_hurt) }
	if (op.mode != "dead") { op.isBoss=false; }
	
	instance_destroy(oMenuBattle);
	instance_destroy(oBattleBC);
	with (oChar) { if (numb == "ene0" or numb == "ene1" or numb == "ene2") { instance_destroy(); } }
	
	instance_destroy(oSoul);
	instance_destroy(oGraze);
	instance_destroy(oBattleBox);
	instance_destroy(oBullet);
	
	instance_destroy(ob);
}






//this resets all battle information every time your turn starts
function declare_battle(_begin=false)
{
	op.stackFix=0;
	
	updatestruct_party();
	
	var i=0, j = 0;
	
	mode="menu";
	
	if (!array_contains(op.battle_seed,"keeptarget")) { target=-1; }
	
	faimd=[0,0,0,-1];
	locked=[false,false,false];
	lockedPast=[];
	
	partyUndo=[];
	
	faceImage=[1,1,1];
	alongside=[[],[],[]];
	itemUp=[0,0,0]; eneUp=[0,0,0];
	forceSpeak=[-1,-1,-1];
	magicActionText="";
	
	
	
	sel_button=[-1,-1,-1,-1];
	sel_priority=[-2,-2,-2];
	sel_person=[-1,-1,-1];
	sel_object=[-1,-1,-1];
	sel_item=[[-1,0],[-1,0],[-1,0]];
	sel_toType=[-1,-1,-1];
	
	sel_magicAction=[-1,-1,-1];
	
	
	
	handler=false;
	handlerCounter=0;
	
	patterns=[-1,-1,-1];
	patternsFree=[true,true,true];
	
	priority=-2;
	priority_counter=0;
	
	wait=true;
	waitDelay=0;
	
	stackAction=false;
	priorityNegative=false;
	stackJump=0;
	singleStack=false;
	
	
	
	exists_soul=false;
	exists_box=false;
	exists_timer=false; timer=0;
	
	boxScaleXY=[0,0];
	
	
	
	alertTP=999;
	i=0;
	repeat (3)
	{
		if (extraStatsTimer[i] > 0) { --extraStatsTimer[i]; }
		if (extraStatsTimer[i] == 0) { enemyAttackExtra[i]=0; enemyDefenseExtra[i]=0; }
		
		//find cheapest alert action price
		if (enemyHere[i])
		{
			j = 0;
			repeat (array_length(op.battle_enemy[i]._spells))
			{
				struct(op.battle_enemy[i]._spells[j]);
				if (str._alert and str._tp < alertTP) { alertTP = str._tp; }
			
				j++;
			}
		}
		++i;
	}
	
	i=0;
	repeat (array_length(op.party))
	{
		if (extraPartyStatsTimer[i] > 0) { --extraPartyStatsTimer[i]; }
		if (extraPartyStatsTimer[i] == 0) { partyAttackExtra[i]=0; partyDefenseExtra[i]=0; }
		++i;
	}
	
	start_cutscene("cc_flavourText");
	
	
	
	if (!_begin and !array_contains(op.battle_seed,"swoon"))
	{
		i=0;
		repeat (array_length(op.party))
		{
			if (op.hp[i] < 1)
			{
				party_heal(i,[op.hpMax[i]/8],,true);
				if (op.hp[i] > 0) { char_animate(i,1,1,op.party[i]._spriteIdle,0); }
			}
			++i;
		}
	}
	
	
	
	//when your turn starts this makes it so that the turn starts on the first party memmber who isn't dead
	var check=true;
	
	op.menuPep=0;
	while (op.hp[op.menuPep] < 1 or op.party[op.menuPep]._lockSpell != -1) and (check)
	{
		++op.menuPep;
		if (op.menuPep == array_length(op.party)) { op.menuPep=0; check=false; }
	}
	
	if (!check) { next_party(true); }
}



//declares  usefull variables in spell objects
function declare_spell()
{
	time=0;
	
	numb_from=oMenuBattle.priority_counter;
	numb_to=oMenuBattle.sel_person[oMenuBattle.priority_counter];
	
	if (oMenuBattle.sel_toType[oMenuBattle.priority_counter] == 0) { while (!oMenuBattle.enemyHere[numb_to]) { ++numb_to; if (numb_to == 3) { numb_to=0; } } }
	
	name_from=op.party[numb_from]._infoText[0];
}

//declares usefull variables in handler objects
function declare_handler(_numb)
{
	numb_from=_numb;
	
	execute=false;
}



//run this in the creation event for a spell object to make the coresonding partymembers automaticaly do their default animations
function default_spell_animation()
{
	var _pc=oMenuBattle.priority_counter;
	
	//array_insert(oMenuBattle.alongside[_pc],0,op.party[_pc]._numberExistence);
	
	var sprite=-1;
	var counter=0;
	var _i1=0;
	
	repeat (array_length(oMenuBattle.alongside[_pc])+1)
	{
		if (counter == 0) { _i1=existence_to_numb(op.party[_pc]._numberExistence); }else{ _i1=existence_to_numb(oMenuBattle.alongside[_pc][counter-1]); }
		
		sprite=-1;
		if (oMenuBattle.sel_magicAction[_pc] == -1)
		{
			if (oMenuBattle.sel_button[_pc] == 1 and array_length(op.party[_i1]._spriteAct) > 1) { sprite=op.party[_i1]._spriteAct[1]; }
			if (oMenuBattle.sel_button[_pc] == 2 and array_length(op.party[_i1]._spriteItem) > 1) { sprite=op.party[_i1]._spriteItem[1]; }
			if (oMenuBattle.sel_button[_pc] == 5 and array_length(op.party[_i1]._spriteMagic) > 1) { sprite=op.party[_i1]._spriteMagic[1]; }
		}
		else
		{
			if (array_length(op.party[_i1]._spriteAct) > 1) { sprite=op.party[_i1]._spriteAct[1]; }
		}
		
		if (op.hp[_i1] > 0) { char_animate(_i1,1,1,sprite,0,,,,,["subnumber"]); }
		++counter;
	}
	oMenuBattle.alongside[_pc]=[];
}



//this is run when you finish selecting what a single party member should do and moves you over to the next (it skips dead party members)
function next_party(_forceDone=false)
{
	var go=true, menuClamp=clamp(op.menuPep,0,array_length(op.party)-1);
	
	if (!_forceDone)
	{
		if (op.menuPep != -1)
		{
			oMenuBattle.faceImage[op.menuPep]=4+clamp(oMenuBattle.sel_priority[op.menuPep],0,999);
			array_insert(partyUndo,0,[op.menuPep,[lockedPast[0],lockedPast[1],lockedPast[2]],tp,-1,-1]);
		}
	
		tp-=tpUse;
	
		while (go or locked[menuClamp] or op.hp[menuClamp] < 1 or op.party[menuClamp]._lockSpell != -1) and (op.menuPep != array_length(op.party))
		{
			++op.menuPep;
			menuClamp=clamp(op.menuPep,0,array_length(op.party)-1);
			go=false;
		}
	}
	else
	{
		op.menuPep=array_length(op.party);
	}
	
	if (op.menuPep == array_length(op.party))
	{
		page="done"; priority=-1; priority_counter=0;
		wait=false; mode="spells";
		
		stackAction=false; priorityNegative=false; stackJump=-1;
		var i=0, i1=0; repeat (array_length(op.party)) { if (sel_priority[i] == -1) { ++i1; } ++i; } if (i1 > 1) { stackAction=true; }
	}
	else
	{
		page=0; cursor=faimd[op.menuPep];
	}
	
	undo=[];
}



//forcefully makes it the partys turn
function force_partyTurn()
{
	with (oMenuBattle) { reset_cursor(); saveCur=[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]; declare_battle(); }
}

//forcefully makes it the enemys turn
function force_enemyTurn()
{
	oMenuBattle.stackJump=0;
	oMenuBattle.handler=true;
	oMenuBattle.handlerCounter=0;
	
	var i=0;
	repeat (array_length(op.battle_enemy))
	{
		if (oMenuBattle.enemyHere[i]) { ++oMenuBattle.handlerCounter; with(op.battle_enemy[i]._handler) { execute=true; } }
		++i;
	}
	
	if (!array_contains(oMenuBattle.enemyHere,true)) { oMenuBattle.handler=false; if (oMenuBattle.normalEnd) { end_battle(); }else{ ob.endSignal=true; } }else{ oMenuBattle.mode="talk"; }
}



//this will end the current party member action and start the next one
//you can also make this function be automaticaly run after dialouge by checking a box in the start_cutscene script
function continue_orders()
{
	var check=false;
	var i=0;
	
	i=0;
	repeat (array_length(op.party))
	{
		if !(char(i).x == op.battle_partyXY[i][0]+(op.x-160) or char(i).y == op.battle_partyXY[i][1]+(op.y-120))
		{
			char_animate(i,10,0,,,op.battle_partyXY[i][0],op.battle_partyXY[i][1],,,["autooff"]);
			check=true;
		}
		++i;
	}
	
	oMenuBattle.wait=false;
	if (check) { oMenuBattle.waitDelay=0; }
}



//sets what attack pattern an enemy should use
function set_pattern(_pattern=-1,_numb=-1)
{
	if (_numb == -1)
	{
		if (oMenuBattle.patternsFree[numb_from]) { oMenuBattle.patterns[numb_from]=_pattern; }
	}
	else
	{
		oMenuBattle.patternsFree[_numb]=false;
		oMenuBattle.patterns[_numb]=_pattern;
	}
}