++time;
if (time == 1)
{
	//char_animate(0,10,1,,,100,100);
	//enemy_damage(numb_from,numb_to,2);
	//enemy_mercy(numb_to,10);
	//enemy_tired(numb_to);
	
	//force_speak(numb_to,"YAWN",70);
	//enemy_spare(numb_to);
	
	//start_cutscene("cc_youWon",40);
	//end_battle();
	//destroy_battle();
	
	op.textCC=["Template Text"];
	
	if (oMenuBattle.singleStack)
	{
		if (op.party[numb_from]._numberExistence == 1) { array_push(op.textCC,"* Susie Extra Template.");  op.faceCC=[-1,[FACE.SUSIE,1]]; }
		if (op.party[numb_from]._numberExistence == 2) { array_push(op.textCC,"* Ralsei Extra Template."); op.faceCC=[-1,[FACE.RALSEIHAT,8]]; }
	}
	
	start_cutscene("cc_anything",,true);
	
	//
	//
	//
	
	instance_destroy();
}