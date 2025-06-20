use_keys(true);
if (page != "filesaved" and !op.chapter1style) { use_cursor(); }



if (page == "start")
{
	saveCur=[0,0,0,0,0,0,0,0,0];
	
	wide_cursor(4 - (op.world == "light"));
	
	if tap_cancel() { op.mode="overworld"; page=0; instance_destroy(); }
	
	res_i();
	if tap_confirm()
	{
		if (cursor == 0 and i == 0) { i=1; page="save"; cursor=op.fileOn; }
		if (cursor == 1 and i == 0) { i=1; op.mode="overworld"; page=0; instance_destroy(); }
		if (cursor == 2 and i == 0)
		{
			i=1;
			if (op.world == "dark")
			{
				instance_create_depth(0,0,-9999,oMenuStorage);
				instance_destroy();
			}
			else
			{
				page = "start_wait";
				music_stop();
				transition(,function(){ room_goto(op.mainMenuRoom); });
			}
		}
		
		if (cursor == 3 and i == 0)
		{
			i=1;
			if (array_length(op.recruits) == 0) { force_undo(0); }else{ instance_create_depth(0,0,-9999,oMenuRecruits); instance_destroy(); }
		}
	}
}



if (page == "save")
{
	vertical_cursor(4); saveCur[0]=cursor;
	
	res_i();
	if tap_confirm(,!(op.fileOn == cursor or !file_exists("save"+string(cursor))))
	{
		if (cursor < 3 and i == 0) { i=1; if (op.fileOn == cursor or !file_exists("save"+string(cursor))) { sound(snd_save); op.fileOn=cursor; page="filesaved"; }else{ page="ask"; } cursor=0; }
		if (cursor == 3 and i == 0) { i=1; force_undo(1); sound(snd_select); }
	}
	
	if tap_menu() { if file_exists("save"+string(cursor)) { file_delete("save"+string(cursor)); } }
}



if (page == "ask")
{
	horizontal_cursor(2);
	
	res_i();
	if tap_confirm(,!(cursor == 0 and i == 0))
	{
		if (cursor == 0 and i == 0) { sound(snd_save); op.fileOn=saveCur[0]; /* */ i=1; page="filesaved"; cursor=0; }
		if (cursor == 1 and i == 0) { i=1; force_undo(1); }
	}
}



if (page != "filesaved") { readyToSave=true; }
if (page == "filesaved")
{
	if (readyToSave) { readyToSave=false; file_save(); }
	if (tap_confirm(,false) or tap_cancel(,false)) { op.mode="overworld"; page=0; instance_destroy(); }
}



//chapter 1 styled menu (step)
if (page == "startC1")
{
	horizontal_cursor(2);
	
	if (tap_cancel(,false) or tap_confirm(1,false))
	{
		instance_destroy();
		set_mode();
	}
	
	if tap_confirm(0,false)
	{
		page="savedC1";
		file_save();
		
		sound(snd_save);
	}
}



if (page == "savedC1")
{
	if (tap_cancel(,false) or tap_confirm(,false))
	{
		instance_destroy();
		set_mode();
	}
}