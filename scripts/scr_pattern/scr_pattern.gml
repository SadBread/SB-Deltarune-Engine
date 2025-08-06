//sets the stats for an attack pattern
//soul mode, box size & other things related
function pattern_objects(_boxX=160,_boxY=85,_boxXscale=74,_boxYscale=74,_timer=100,_spawnSoul=true,_soulMode="red",_spawnBox=true,_soulXY=-1)
{
	oMenuBattle.mode="dodge";
	
	if (_spawnSoul)
	{
		if (!oMenuBattle.exists_soul)
		{
			oMenuBattle.exists_soul=true;
			var xy=[char(0).x,char(0).y-15];
			
			if array_contains(op.battle_seed,"corner") { xy=[op.x+160,op.y-120]; }
			
			with (instance_create_depth(xy[0],xy[1],-9999,oSoul))
			{
				mode = _soulMode;
				if (_soulXY != -1) { targetXY = _soulXY; }
			}
		}
	}
	
	if (_spawnBox)
	{
		boxX=_boxX; boxY=_boxY;
		oMenuBattle.boxScaleXY=[_boxXscale,_boxYscale];
		
		if (!oMenuBattle.exists_box)
		{
			oMenuBattle.exists_box=true;
			with (instance_create_depth(_boxX+(op.x-160),_boxY+(op.y-120),-2000,oBattleBox)) { mode=_soulMode; }
		}
	}
	
	if (!oMenuBattle.exists_timer) { oMenuBattle.exists_timer=true; oMenuBattle.timer=_timer; }
}



//spawns a battle bullet (ext) (use this for overworld bullets as well to set the damage)
function spawn_bullet_ext(_sprite=sBullet,_subimg=0,_x=0,_y=0,_xscale=1,_yscale=1,_imageAngle=0,_direction=0,_col=c_white,_alpha=1,_walkXY=[0,0,0,0,10],_tp=1,_damage=-1,_seed=[])
{
	if (op.mode == "battle") { _x+=(op.x-160); _y+=(op.y-120); }
	
	with(instance_create_depth(_x,_y,-(room_height+2100),oBullet))
	{
		sprite_index=_sprite;
		image_index=_subimg
		image_xscale=_xscale;
		image_yscale=_yscale;
		
		image_angle=_imageAngle;
		direction=_direction;
		
		image_blend=_col;
		image_alpha=_alpha;
		
		walkXY=_walkXY;
		
		tp=_tp;
		damage=_damage;
		seed=_seed;
		
		if (op.mode == "battle") { numb=other.numb; }
	}
}

//spawns a battle bullet
function spawn_bullet(_sprite=sBullet,_subimg=0,_x=0,_y=0,_walkXY=[0,0,0,0,10],_damage=-1,_seed=[])
{
	spawn_bullet_ext(_sprite,_subimg,_x,_y,,,,,,,_walkXY,,_damage,_seed);
}