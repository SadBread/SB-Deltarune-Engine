use_keys(true);
use_cursor();

if (page == "start")
{
	vertical_cursor(array_length(options));
	
	if tap_cancel() { op.mode="overworld"; instance_destroy(); }
	
	if tap_confirm(0) { if (op.noclip) { op.noclip=false; }else{ op.noclip=true; } force_undo(0); }
	if tap_confirm(1) { page="room"; cursor=op.debugSave[0]; }
	if tap_confirm(2) { room_goto(rMainMenu); }
	if tap_confirm(3) { instance_create_depth(0,0,-9999,oMenuSave); instance_destroy(); }
	if tap_confirm(4) { destroy_battle(); set_mode(); audio_stop_all(); op.currentMusic=-1; op.pastMusic=-1; instance_destroy(); }
	
	if tap_confirm(5) { instance_create_depth(0,0,-9999,oMenuDebugPlace); set_mode(); instance_destroy(); }
}



if (page == "room")
{
	res_i();
	while (room_exists(i))
	{
		++i;
	}
	
	if !(tapConfirm or tapCancel) and !(keyUp and keyDown)
	{
		if tap_up() or (keyUp and tymeUp >= 10 and (!(op.time mod 2) or tymeUp >= 30)) { sound(snd_menumove); --cursor; if (cursor == -1) { cursor=i-1; } }
		if tap_down() or (keyDown and tymeDown >= 10 and (!(op.time mod 2) or tymeDown >= 30)) { sound(snd_menumove); ++cursor; if (cursor == i) { cursor=0; } }
	}
	
	op.debugSave[0]=cursor;
	
	if tap_confirm()
	{
		page=0;
		transition(,function(){ room_goto(oMenuDebug.cursor); master_reset(); },function(){ op.playerX=room_width/2; op.playerY=room_height/2; op.mode="overworld"; reset_party_position(); camera_reset(); })
	}
}