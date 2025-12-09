if (dodge_hit > 0) { draw_party_hud(); }

if keyboard_check(vk_escape) { ++quitTime; }else{ quitTime-=3; quitTime=clamp(quitTime,0,999); }
draw_ext(sQuitting,quitTime/8,0,0,,,,,clamp(quitTime/10,0,1));
if ((quitTime-4)/8 >= 4) { game_end(); }

//
//
//

//
//
//

//print(string(x)+","+string(y));

if (array_length(op.party) == 0 and debug)
{
	draw_ext(sPixel,0,playerX-10,playerY-10,20,10);
}

/**/
if (debug)
{
	print(string(mouse_x)+","+string(mouse_y),mouse_x-(x-160),mouse_y-(y-120),,,,,,,c_red);
	if mouse_check_button(mb_right) { clipboard_set_text(string(mouse_x)+","+string(mouse_y)) }
}

//print(mode,0,0);

//print(op.checkpointProgress,0,0,,,,,,,c_blue);
//if (op.mode == "battle") { print(oMenuBattle.mode,0,0,,,,,,,c_lime); }

if (false)
{
	res_i();
	repeat(array_length(allData))
	{
		print(allData[i],0,10+i*20,,,,0.5,0.5,,,,,,,["bc1"]);
		++i;
	}
}

//print([sFace_Susie,sFace_Ralsei,sFace_RalseiHat,sFace_Lancer],0,0,,,,,,,c_yellow,c_red,,,,["fade"]);

//print(progress);

//print(op.darkEntranceRoom);

//if (array_length(global.gamepads) > 0)
	//print(gamepad_get_description(global.gamepads[0]),10,10);