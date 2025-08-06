//bullet touch soul damage party & delete bullet
if (place_meeting(x,y,oSoul) and oSoul.counter == 0)
{
	if (!array_contains(seed,"safe"))
	{
		if (oSoul.iframes == 0)
		{
			oSoul.iframes=oSoul.iframesMax;
			oSoul.damage=damage;
			if (op.mode == "battle") { oSoul.damage+=oMenuBattle.enemyAttackExtra[numb]; }
			oSoul.enemyNumb=numb;
		}
	
		if (!array_contains(seed,"stay")) { instance_destroy(); }
	}
}

//bullet graze
if (place_meeting(x,y,oGraze) and !grazed and oSoul.iframes == 0 and tp != 0)
{
	grazed=true; oSoul.graze=1;
	oMenuBattle.tp=clamp(oMenuBattle.tp+tp,0,100);
	
	audio_stop_sound(snd_graze);
	sound(snd_graze);
}



//send info to the object that draws the sprites masked
if (array_contains(seed,"mask") and oMenuBattle.exists_box)
{
	visible=false;
	array_push(oBattleBox.bulletInfo,[sprite_index,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha]);
}