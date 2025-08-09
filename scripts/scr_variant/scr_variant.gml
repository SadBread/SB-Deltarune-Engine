//loads in the included csv document
function variant_csv()
{
	op.csvText=load_csv("DR text.csv");
}



//automaticaly sets the voice based on what face is currently being used
function variant_face_match(_face)
{
	//you can also set font's or any other value if you want to
	if (_face == sFace_Susie) { voice=txt_sus; }
	
	if (_face == sFace_Ralsei or _face == sFace_RalseiHat) { voice=txt_ral; }
		
	if (_face == sFace_Lancer) { voice=txt_lan; }
}

//you can offset dialogue faces here if you want to and or permanetly in battle if you need to
function variant_face_offset()
{
	faceXY=[0,0];
		
	if (op.mode == "battle")
	{
		if (face[0] == sFace_Susie or face[0] == sFace_Ralsei or face[0] == sFace_RalseiHat) { faceXY=[-5,-5]; }
	}
}

//if you use a color command {color:yellow} these symbols will still be white
function variant_white_symbols()
{
	return ["*",".",",",":",";","(",")","[","]","!","?"];
}

//no voice sound effect will be played on these symbol during dialogue
function variant_novoice_symbols()
{
	return [" ","^","!",".","?",",",":","/","\\","|","*"];
}

//set the mono space width for fonts when used in dialogue boxes.
function variant_font(_font)
{
	if (_font == fDetermination) { return(8); }
	if (_font == fDotum) { return(9); }
}



//decide recruits background colors
function variant_recruits(_chapter)
{
	
	var color=c_gray;
	
	if (_chapter == 1) { color=c_purple; }
	if (_chapter == 2) { color=c_aqua; }
	
	return(color);
}



//fight heads offset (why does this exists toby WHY???????????????????????????)
function variant_fightheads()
{
	//j is numberExistence
	
	if (j == 0) { j1=[0,0]; } //Kris
	if (j == 1) { j1=[-2,-1]; } //Susie
	if (j == 2) { j1=[-6,-3]; } //Ralsei
}



//set shortcut door options
function variant_shortcutdoor()
{
	addPlace(rRoom6,"Gizmo Test");
	addPlace(rRoom7,"Music Test");
	addPlace(rPush,"Push");
}