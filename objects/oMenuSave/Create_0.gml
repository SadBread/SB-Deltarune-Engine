drText=get_text("t_menuSave");
drTextLight = get_text("t_menuOverworldSettings");

update_allData(); update_stats();

reset_keys();
reset_cursor();
master_reset(false);

page="start";
if (op.chapter1style) { page="startC1"; }

op.mode="menuSave";

//draw save file
drawFile=function(_x,_y,_color=c_white,_xoffset=0,_numb=-1)
{
	var _seed=["menu","soul1","save",_numb];
	if (_numb == -1) { _seed=[]; }
	
	if (file_exists("save"+string(_numb)) or _numb == -1)
	{
		if (_numb == -1)
		{
			stat_name=op.name_;
			stat_locationText=op.locationText;
			stat_minutes=op.minutes;
			stat_seconds=op.seconds;
			stat_level=op.allData[0][6];
		}
		else
		{
			file_stats(_numb);
		}
		
		print(drText[4]+" "+string(stat_level),50+_xoffset,20+_y,,,,,,,_color,,,,,_seed); /* LV */
		var i1=""; if (stat_seconds < 10) { i1="0"; }
		print(string(stat_minutes)+":"+i1+string(stat_seconds),271.5,20+_y,,,,,,,_color,,,,,["fa_right"]); /* Time */
		print(stat_name,160,20+_y,,,,,,,_color,,,,,["fa_center"]); /* Name */
	
		print(stat_locationText,160,36+_y,,,,,,,_color,,,,,["fa_center"]); /* Title */
	}
	else
	{
		print(drText[6],133,28+_y,,,,,,,_color,,,,,_seed);
	}
}



readyToSave=true;

res_i();
repeat(array_length(op.party)) { op.hp[i]=op.hpMax[i]; ++i; }