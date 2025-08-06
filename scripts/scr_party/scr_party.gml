//places all party members ontop of kris + advanced mode
function reset_party_position(_keepPos=false)
{
	updatestruct_party();
	op.inputWait=true;
	
	with (oChar) { if (type == "pep") { instance_destroy(); } }
	
	if (!_keepPos)
	{
		op.partyPos = [];
		repeat ((array_length(op.party)+array_length(op.followers))*12)
		{
			array_push(op.partyPos,[op.playerX,op.playerY,op.playerDirection,0,"overworld"]);
		}
	}
	
	var i=0;
	repeat (array_length(op.party)) 
	{
		if (op.world == "dark") or (op.world == "light" and !op.party[i]._isDarkner) { create_char("pep",i); }
		++i;
	}
	
	i=0;
	repeat (array_length(op.followers)) { op.setFollowerNumb=i; create_char("follower",op.followers[i][2],,,op.followers[i][1]); ++i; }
	
	with (oChar) { oChar.walkOffset=0; }
	op.inputWait=true;
	op.resetPartyPosTimer=1;
	
	
	
	if (op.partyGuaranteeFunc != -1)
	{
		op.partyGuaranteeFunc();
	}
	op.partyGuaranteeFunc=-1;
}

//will make the party seamlessly walk back in line after cutscene
function party_lerp()
{
	with (oChar) { if (numb == 1 or numb == 2) { oChar.cutsceneStarted=true; oChar.cutsceneHappened=true oChar.walkOffset=0; } }
}



//increase party member health
function party_heal(_numb=0,_amount=[100],_everyone=false,_autoHeal=false)
{
	var i=0, grab=0, image=-1, pastHP=-1;
	
	audio_stop_sound(snd_heal);
	sound(snd_heal);
	
	if (_everyone)
	{
		repeat(array_length(op.party))
		{
			grab=op.party[i]._numberExistence; if (grab >= array_length(_amount)) { grab=0; } _amount[grab]=round(_amount[grab]);
			
			pastHP=op.hp[i];
			op.hp[i]=clamp(op.hp[i]+_amount[grab],-9999,op.hpMax[i]);
			
			if (op.mode == "battle")
			{
				image=-1; if (op.hp[i] == op.hpMax[i]) { image=2; }
				if (_autoHeal and pastHP < 1 and op.hp[i] > 0) { op.hp[i]=round(op.hpMax[i]/6); image=3; }
				if (pastHP < 1 and op.hp[i] > 0) { char_animate(i,1,1,op.party[i]._spriteIdle,0,,,,,["override"]); }
				
				if (!_autoHeal) { char(i).brightMode="fade"; char(i).bright=1; repeat(10) { effect_star(char(i).x+irandom_range(-8,8),char(i).y-irandom_range(0,24),["heal"]); } }
				effect_number(_amount[grab],op.battle_partyXY[_numb][0]-15,op.battle_partyXY[_numb][1]-15-oMenuBattle.itemUp[i]*10,c_lime,,image);
				
				++oMenuBattle.itemUp[i];
			}
			else
			{
				effect_textpop("+"+string(_amount[grab]),35+i*106.5+(3-array_length(op.party))*53,215,,,,,,,c_lime);
			}
			
			++i;
		}
	}
	else
	{
		grab=op.party[_numb]._numberExistence; if (grab >= array_length(_amount)) { grab=0; } _amount[grab]=round(_amount[grab]);
		
		pastHP=op.hp[_numb];
		op.hp[_numb]=clamp(op.hp[_numb]+_amount[grab],-9999,op.hpMax[_numb]);
		
		if (op.mode == "battle")
		{
			image=-1; if (op.hp[_numb] == op.hpMax[_numb]) { image=2; }
			if (_autoHeal and pastHP < 1 and op.hp[_numb] > 0) { op.hp[_numb]=round(op.hpMax[_numb]/6); image=3; }
			if (pastHP < 1 and op.hp[_numb] > 0) { char_animate(_numb,1,1,op.party[_numb]._spriteIdle,0,,,,,["override"]); }
			
			if (!_autoHeal) { char(_numb).brightMode="fade"; char(_numb).bright=1; repeat(10) { effect_star(char(_numb).x+irandom_range(-8,8),char(_numb).y-irandom_range(0,24),["heal"]); } }
			effect_number(_amount[grab],op.battle_partyXY[_numb][0]-15,op.battle_partyXY[_numb][1]-15-oMenuBattle.itemUp[_numb]*10,c_lime,,image);
			
			++oMenuBattle.itemUp[_numb];
		}
		else
		{
			effect_textpop("+"+string(_amount[grab]),35+_numb*106.5+(3-array_length(op.party))*53,215,,,,,,,c_lime);
		}
	}
}



//decrease party member health
function party_damage(_numb=0,_amount=100)
{
	var i=0, _hp=0, check=false;
	
	camera_shake(1,3);
	audio_stop_sound(snd_hurt);
	sound(snd_hurt);
	
	_amount-=round(op.defense[_numb]*3);
	
	if (op.mode == "battle")
	{
		_amount-=round(oMenuBattle.partyDefenseExtra[_numb]*3);
		
		if (oMenuBattle.sel_button[_numb] == 4) { _amount=round(_amount*(2/3)); }
		
		//
		if (_amount < 1) { _amount=1; } op.hp[_numb]-=round(_amount);
		//
		
		if (oMenuBattle.exists_soul) { oSoul.flash=-1; }
		oMenuBattle.knockX[_numb]=5;
		
		if (op.hp[_numb] < 1)
		{
			op.hp[_numb]=-round(op.hpMax[_numb]/2);
			if (array_contains(op.battle_seed,"swoon")) { op.hp[_numb] = -999; }
		
			char_animate(_numb,1,0,op.party[_numb]._spriteDead,1+array_contains(op.battle_seed,"swoon"),,,,,["override"]);
			
			effect_number(0,op.battle_partyXY[_numb][0]-15,op.battle_partyXY[_numb][1]-15,c_red,,1+array_contains(op.battle_seed,"swoon")*10);
		}
		else
		{
			if (char(_numb).sprite_index != op.party[_numb]._spriteDefend)
			{
				char_animate(_numb,15,0,op.party[_numb]._spriteDead,0,,,,,["override"]);
				char_animate(_numb,1,1,op.party[_numb]._spriteIdle,0);
			}
			
			effect_number(_amount,op.battle_partyXY[_numb][0]-15,op.battle_partyXY[_numb][1]-15);
		}
	}
	else
	{
		op.dodge_hit=100;
		if (_amount < 1) { _amount=1; } op.hp[_numb]-=round(_amount); if (op.hp[_numb] < 1) { op.hp[_numb]=1; }
		effect_number(_amount,char(_numb).x-15,char(_numb).y-15);
	}
	
	
	
	i=0; _hp=0; check=true;
	repeat (array_length(op.party))
	{
		_hp+=op.hp[i];
		if (op.hp[i] > 0) { check=false; }
		++i;
	}
	
	if (!op.dead) and ((op.mode == "battle" and check) or (op.mode != "battle" and _hp == array_length(op.party)))
	{
		op.dead=true; instance_destroy(oNumberEffect);
		if (!surface_exists(op.dieSprite)) { op.dieSprite=surface_create(320*2,240*2); }
		
		music_stop();
		
		surface_set_target(op.dieSprite);
		draw_ext(sPixel,0,0,0,9999,9999,,0);
		draw_surface_ext(application_surface,0,0,1,1,0,c_white,1);
		surface_reset_target();
		
		instance_create_depth(0,0,-9999,oMenuGameOver);
		
		if (op.mode == "battle") { op.mode="dead"; destroy_battle(true); }else{ room_goto(rEmpty); op.dodge_hit=0; }
		
		op.mode="dead";
	}
}



//forcefully sets a party members stats
function set_party_stats(_numb=1,_hpMax=100,_attack=0,_defense=0,_magic=0,_guts=3,_level=1,_weapon,_armor1=-1,_armor2=-1,_spells=[])
{
	op.hp[_numb]=_hpMax;
	op.hpMax[_numb]=_hpMax;
	op.attack[_numb]=_attack;
	op.defense[_numb]=_defense;
	op.magic[_numb]=_magic;
	op.guts[_numb]=_guts;
	op.level[_numb]=_level;
	op.ability[_numb]=[];

	op.equipped[_numb]=[-1,-1,-1];
	op.spells[_numb]=[];
	
	//
	
	if (_weapon != -1)
	{
		struct(_weapon);
		op.equipped[_numb][0]=str; op.ability[_numb][0]=str._ability;
		op.attack[_numb]+=str._attack; op.defense[_numb]+=str._defense; op.magic[_numb]+=str._magic;
	}
	if (_armor1 != -1)
	{
		struct(_armor1);
		op.equipped[_numb][1]=str; op.ability[_numb][1]=str._ability;
		op.attack[_numb]+=str._attack; op.defense[_numb]+=str._defense; op.magic[_numb]+=str._magic;
	}
	if (_armor2 != -1)
	{
		struct(_armor2); op.equipped[_numb][2]=str;
		op.equipped[_numb][2]=str; op.ability[_numb][2]=str._ability;
		op.attack[_numb]+=str._attack; op.defense[_numb]+=str._defense; op.magic[_numb]+=str._magic;
	}
	
	var i=0;
	repeat (array_length(_spells)) { add_spell(_numb,_spells[i]); ++i; }
	
	
	
	update_allData();
}