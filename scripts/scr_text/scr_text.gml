//draws proportional text in draw events
function print(_text="Skip",_x=0,_y=0,_font=fDetermination,_sep=12,_width=320,_xscale=1,_yscale=1,_angle=0,_c1=c_white,_c2=c_white,_c3=c_white,_c4=c_white,_alpha=1,_seed=[],_sprites=-1)
{
	//normal data
	superStringWidth = 0;
	
	var xOffset=0, yOffset=0;
	
	if (_font == fDetermination) { yOffset=-4; }
	if (_font == fMars) { yOffset=-1; }
	
	if (!array_contains(_seed,"forceEnglish"))
	{
		if (op.language == 2)
		{
			if (_font == fDetermination) { _font=fDotum; yOffset=0; }
		}
	}
	
	//set halign
	draw_set_halign(fa_left);
	draw_set_font(_font);
	
	if array_contains(_seed,"fa_center") { draw_set_halign(fa_center); }
	if array_contains(_seed,"fa_right") { draw_set_halign(fa_right); }
	
	//draw image
	if (_sprites != -1)
	{
		if (string_length(_sprites) < 8)
		{
			_text = string_replace(_text,"#",_sprites);
		}
		else
		{
			var _splitImageData = string_split(_sprites,":");
			var _splitForImage = string_split(_text,"#");
			_text = string_replace(_text,"#","      ");
			
			draw_ext(asset_get_index(_splitImageData[0]),real(_splitImageData[1]),_x + string_width(_splitForImage[0]) + (draw_get_halign() == fa_center) * (string_width(_text)/-2) + (draw_get_halign() == fa_right) * (-string_width(_text)),_y -2,,,,_c1);
		}
		
		superStringWidth = string_width(_text) + (draw_get_halign() == fa_center) * (string_width(_text)/-2) + (draw_get_halign() == fa_right) * (-string_width(_text));
	}
	
	//menu mode
	if (array_contains(_seed,"menu") or array_contains(_seed,"menu_yellow"))
	{
		if (array_contains(_seed,page) and array_contains(_seed,cursor))
		{
			var soulOffset=0;
			if array_contains(_seed,"fa_right") { soulOffset=string_width(_text); }
			if array_contains(_seed,"fa_center") { soulOffset=string_width(_text)/2; }
			
			if array_contains(_seed,"menu_yellow") { _c1=c_yellow; }
			if array_contains(_seed,"soul1") { draw_ext(sSoul,0,_x+xOffset-soulOffset-8.5,_y+yOffset+9,0.5,0.5); }
			if array_contains(_seed,"soul2") { draw_ext(sSoul,0,_x+xOffset-soulOffset-6,_y+yOffset+9,0.5,0.5); }
			if array_contains(_seed,"soul3") { draw_ext(sSoul2,0,_x+xOffset-soulOffset-7.5,_y+yOffset+9,0.5,0.5); }
			if array_contains(_seed,"soul4")
			{
				op.soul4XY[0]+=((_x+xOffset-soulOffset-5)-op.soul4XY[0])/2;
				op.soul4XY[1]+=((_y+yOffset+3.5)-op.soul4XY[1])/2;
			}
		}
	}
	
	//moves the text over when a face is draw next to it in battle
	if array_contains(_seed,"partyHelp") { _x+=15*partyHelp; }
	
	
	
	//set all other colors to the first one if only the first one got modified
	if (_c1 != c_white and _c2 == c_white and _c3 == c_white and _c4 == c_white) { _c2=_c1; _c3=_c1; _c4=_c1; }
	
	//draw text background
	if array_contains(_seed,"bc1")
	{
		var _c1d=0, _c2d=0, _c3d=0, _c4d=0;
		if (_c1 == c_white and _c2 == c_white and _c3 == c_white and _c4 == c_white) { _c1d=make_color_rgb(42*1.5,42*1.5,86); _c2d=_c1d; _c3d=make_color_rgb(0,0,128); _c4d=_c3d; }else{ _c1d=merge_colour(_c1,c_black,0.75); _c2d=merge_colour(_c2,c_black,0.75); _c3d=merge_colour(_c3,c_black,0.75); _c4d=merge_colour(_c4,c_black,0.75); }
		
		draw_text_ext_transformed_color(_x+xOffset+0.5,_y+yOffset+0.5,_text,_sep,_width,_xscale,_yscale,_angle,_c1d,_c2d,_c3d,_c4d,_alpha);
	}
	if array_contains(_seed,"bc2") { draw_text_ext_transformed_color(_x+xOffset+1*_xscale,_y+yOffset+1*_yscale,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha); }
	if array_contains(_seed,"bc3") { _c1d=make_color_rgb(51,32,51); draw_text_ext_transformed_color(_x+xOffset+1*_xscale,_y+yOffset+1*_yscale,_text,_sep,_width,_xscale,_yscale,_angle,_c1d,_c1d,_c1d,_c1d,_alpha); }
	
	if array_contains(_seed,"bc4")
	{
		_c1d=make_color_rgb(17,31,151);
		draw_text_ext_transformed_color(_x+xOffset-1,_y+yOffset,_text,_sep,_width,_xscale,_yscale,_angle,_c1d,_c1d,_c1d,_c1d,_alpha);
		draw_text_ext_transformed_color(_x+xOffset+1,_y+yOffset,_text,_sep,_width,_xscale,_yscale,_angle,_c1d,_c1d,_c1d,_c1d,_alpha);
		draw_text_ext_transformed_color(_x+xOffset,_y+yOffset-1,_text,_sep,_width,_xscale,_yscale,_angle,_c1d,_c1d,_c1d,_c1d,_alpha);
		draw_text_ext_transformed_color(_x+xOffset,_y+yOffset+1,_text,_sep,_width,_xscale,_yscale,_angle,_c1d,_c1d,_c1d,_c1d,_alpha);
	}
	
	if array_contains(_seed,"bc5")
	{
		draw_text_ext_transformed_color(_x+xOffset-0.5,_y+yOffset,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha);
		draw_text_ext_transformed_color(_x+xOffset+0.5,_y+yOffset,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha);
		draw_text_ext_transformed_color(_x+xOffset,_y+yOffset-0.5,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha);
		draw_text_ext_transformed_color(_x+xOffset,_y+yOffset+0.5,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha);
		
		draw_text_ext_transformed_color(_x+xOffset+0.5,_y+yOffset+0.5,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha);
		draw_text_ext_transformed_color(_x+xOffset+0.5,_y+yOffset-0.5,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha);
		draw_text_ext_transformed_color(_x+xOffset-0.5,_y+yOffset+0.5,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha);
		draw_text_ext_transformed_color(_x+xOffset-0.5,_y+yOffset-0.5,_text,_sep,_width,_xscale,_yscale,_angle,0,0,0,0,_alpha);
	}
	
	
	
	//draw fade effect
	if array_contains(_seed,"fade")
	{
		xOffset+=dcos(op.time*10)*0.5; yOffset+=dsin(op.time*10)*0.5;
	}
	
	
	
	//
	//
	//main draw text
	draw_text_ext_transformed_color(_x+xOffset,_y+yOffset,_text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha);
	//
	//
	//
	
	
	
	//draw fade effect
	if array_contains(_seed,"fade")
	{
		var _fadeAlpha=0;
		xOffset-=dcos(op.time*10)*0.5; yOffset-=dsin(op.time*10)*0.5;
		
		repeat(6)
		{
			draw_text_ext_transformed_color(_x+xOffset+(_fadeAlpha*2)+op.textFadeAlpha,_y+yOffset+(_fadeAlpha*2)+op.textFadeAlpha,_text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,(_alpha-((_fadeAlpha+op.textFadeAlpha/2)/6))/2);
			++_fadeAlpha
		}
	}
	
	//draw blurry text
	if array_contains(_seed,"blur")
	{ 
		var _blurAlpha=(0.3 + (sin(op.time / 14)) * 0.1) * 0.75;
		draw_text_ext_transformed_color((_x+xOffset + 1), _y+yOffset, _text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha*_blurAlpha);
		draw_text_ext_transformed_color((_x+xOffset - 1), _y+yOffset, _text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha*_blurAlpha);
		draw_text_ext_transformed_color(_x+xOffset, (_y+yOffset + 1), _text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha*_blurAlpha);
		draw_text_ext_transformed_color(_x+xOffset, (_y+yOffset - 1), _text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha*_blurAlpha);
		_blurAlpha=(0.08 + (sin(op.time / 14)) * 0.04) * 0.75;
		draw_text_ext_transformed_color((_x+xOffset + 1), (_y+yOffset + 1), _text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha*_blurAlpha);
		draw_text_ext_transformed_color((_x+xOffset - 1), (_y+yOffset - 1), _text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha*_blurAlpha);
		draw_text_ext_transformed_color((_x+xOffset - 1), (_y+yOffset + 1), _text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha*_blurAlpha);
		draw_text_ext_transformed_color((_x+xOffset + 1), (_y+yOffset - 1), _text,_sep,_width,_xscale,_yscale,_angle,_c1,_c2,_c3,_c4,_alpha*_blurAlpha);
		draw_set_alpha(1);
	}
}



//spawns all types of dialogue boxes and custcenes
function start_cutscene(_struct_text,_forceTextWait=0,_continueOrders=false)
{
	//makes it so you can't press confirm to procced within the amount of frames you enter
	op.forceTextWait=_forceTextWait;
	//in battels if true, once the dialouge is done will make the next chosen player actions happen
	op.continueOrders=_continueOrders;
	
	
	
	//spawn oDialogue object
	with (instance_create_depth(0,0,-9999,oDialogue))
	{
		struct(_struct_text);
		info=str;
	}
	
	
	
	//special sprite update fix
	if (op.resetPartyPosTimer > 0) {  }
}

//don't create a new struct for a new cutscene just do it in code
function anything_cutscene(_dialogue=["Test"],_func=-1,_face=[-1],_forceTextWait=0,_continueOrders=false)
{
	op.textCC = _dialogue;
	
	op.funcCC = _func;
	
	op.faceCC = _face;
	
	start_cutscene("cc_anything",_forceTextWait,_continueOrders);
}



//returns an array from the csv document
function get_text(_realText){
	var i=0, array=[];
	
	while (op.csvText[# 0,i] != _realText) { i++; }
	array_push(array,op.csvText[# op.language,i]); i++;
	
	while (op.csvText[# 0,i] == "" and op.csvText[# op.language,i] != "") { array_push(array,op.csvText[# op.language,i]); i++; }
	return (array);
}

//returns a single string from the csv document
function get_text_string(_realText){
	var i=0;
	while (op.csvText[# 0,i] != _realText) { i++; }
	
	return op.csvText[# op.language,i];
}