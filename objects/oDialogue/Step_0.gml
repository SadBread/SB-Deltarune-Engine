++time;

//get key input
use_keys(); if (hideBox > 0) { reset_keys(); }
if (array_length(info._dialogue) == 0) { showText=dialogue; op.forceTextWait=0; }
if (showText == dialogue) { --proceedAuto; if array_contains(info._seed,"noConfirm") { tapConfirm=false; } op.ccImage=0; }else{ ++op.ccImage; }



//press to confirm, skip or hold for auto skip
if ((showText == dialogue and proceedAnimate == -1) and ((tap_confirm() or key_menu() or proceedAuto == 0) and (!array_contains(info._seed,"noConfirm") or proceedAuto == 0)) or (autoConfirm)) or (array_length(info._dialogue) == 0)
{
	if (line+1 == array_length(info._dialogue))
	{
		if (op.forceTextWait == 0)
		{
			//enable end dialouge box
			proceedTime=0; if (info._proceedAnimate != -1) { proceedAnimate=info._proceedAnimate; }else{ proceedLine=true; }
			done=true;
		}
		else
		{
			autoConfirm=true;
		}
	}
	else
	{
		//enable line switch
		proceedTime=0; if (info._proceedAnimate != -1) { proceedAnimate=info._proceedAnimate; }else{ proceedLine=true; }
	}
}



//special transition inbetween lines
++proceedTime;
if (proceedAnimate == "fade")
{
	textAlpha-=0.1;
	
	//enable line switch
	if (proceedTime >= 10) { proceedLine=true; proceedAnimate=-1; }
}

if (op.forceTextWait > 0 and proceedAnimate == -1) { --op.forceTextWait; }



//end & destroy dialouge box
if (proceedLine and done)
{
	if (info._moveAfter and info._func == -1) { op.mode="overworld"; }
	if (info._func != -1) { info._func(); }
	
	op.stackFix=0;
	op.textCC=[]; op.funcCC=-1; op.faceCC=-1;
	
	instance_destroy(oMenuOverworldLight);
	instance_destroy(oSmallFaceEffect);
	instance_destroy();
}



if (array_length(info._dialogue) > 0)
{
	//pres cancel or menu to show all text
	if (key_cancel() or key_menu()) { showText=dialogue; }

	//proceed to the next value in every array (clamps if above)
	if (proceedLine and !done)
	{
		instance_destroy(oSmallFaceEffect);
	
		autoConfirm=false;
		cutSpeed=false; commandDid=[]; delay=0; time=0;
	
		proceedLine=false; proceedAnimate=-1; line++;
	
		op.ccLine=line;
		
		//grab all new (line info) from the struct
		dialogue=info._dialogue[clamp(line,0,array_length(info._dialogue)-1)];
		if (string_char_at(dialogue,string_length(dialogue)) == "}") { dialogue+=" "; }
	
		x_=info._x[clamp(line,0,array_length(info._x)-1)];
		y_=info._y[clamp(line,0,array_length(info._y)-1)];
		if (y_ == "u") { y_=1; }
		if (y_ == "d") { y_=156; }
		xScale=info._xScale[clamp(line,0,array_length(info._xScale)-1)];
		yScale=info._yScale[clamp(line,0,array_length(info._yScale)-1)];
	
		face=info._face[clamp(line,0,array_length(info._face)-1)];
		faceAnimate=info._faceAnimate[clamp(line,0,array_length(info._faceAnimate)-1)];
	
		font=info._font[clamp(line,0,array_length(info._font)-1)];
		voice=info._voice[clamp(line,0,array_length(info._voice)-1)];
		textSpeed=info._textSpeed[clamp(line,0,array_length(info._textSpeed)-1)];
	
		hideBox=info._hideBox[clamp(line,0,array_length(info._hideBox)-1)];
	
		box=info._box[clamp(line,0,array_length(info._box)-1)];
		arrow=info._arrow[clamp(line,0,array_length(info._arrow)-1)];
		color=info._color;
		jump=info._jump;
	
		shopSprite=info._shopSprite[clamp(line,0,array_length(info._shopSprite)-1)];
		if (shopSprite != -1) { oMenuShop.sprite=shopSprite; }
		asteriskFace=info._asteriskFace[clamp(line,0,array_length(info._asteriskFace)-1)];
		
		proceedAuto=info._proceedAuto;
		if (info._autoSkipText[clamp(line,0,array_length(info._autoSkipText)-1)] != -1) { proceedAuto = info._autoSkipText[clamp(line,0,array_length(info._autoSkipText)-1)]; }
		
		//match foices to face
		if (info._match) { func_match(); }
	
		op.menuPrompt=[x_,y_,xScale,yScale];
	
		//run a function from the struct (_funcLine) based on what line you are on
		if (line < array_length(info._funcLine)) { if (info._funcLine[line] != -1) { info._funcLine[line](); } }
	
		//set the print seed to standard or overwrites it based on struct (printSeed is used in the print function that draw the text in the dialouge box)
		printSeed=[];
		if (box == -1 or box == 0) { surf=-1; surfMult=1; textOffsetXY=[17,18]; colorMain=c_white; colorMain2=c_white; if (op.world == "dark") { printSeed=["bc1"]; } }
		if (box == 1) { surfMult=2; textOffsetXY=[10,10]; colorMain=0; colorMain2=0; printSeed=[]; }
		if (info._printSeed != -1) { printSeed=info._printSeed[clamp(line,0,array_length(info._printSeed)-1)]; }
		colorFirst=colorMain;
	
		textAlpha=1;
	
		//if this line has a face portrait shrink the box width math wise
		if (face != -1 and op.mode == "battle") { xScale+=75+75*(box == 1); }
	
		//split strings in spaces
		dialogueSplit=string_split(info._dialogue[line]," ");
		currentAt=0; currentLength=0; edges=[];
		showText="";
	
		proportional=false; if array_contains(info._seed,"proportional") { proportional=true; }
	
		//figure out when to have line breaks (switch rows) should happen in the text
		draw_set_font(font);
		repeat(array_length(dialogueSplit))
		{
			//check every letter in a word (special cases)
			currentAtL=0;
			repeat(string_length(dialogueSplit[currentAt]))
			{
				currentAtL++;
				if (string_char_at(dialogueSplit[currentAt],currentAtL) == "#") { currentLength-=func_spaceAdd("#"); }
			}
		
			//ddd word length
			if (string_char_at(dialogueSplit[currentAt],1) != "{") { currentLength+=func_spaceAdd(dialogueSplit[currentAt],(string_length(dialogueSplit[currentAt]))); }else{ currentLength-=func_spaceAdd(" "); }
		
			jumpForce=false; if (line < array_length(jump)) { if array_contains(jump[line],currentAt) { jumpForce=true; } }
			if (dialogueSplit[currentAt] == "{jump}") { jumpForce=true; }
		
			//(I don't remember what these numbers stand for but they might be important)
			//change row 34
			//(+16)
			if (currentLength > xScale-32-58*(face != -1) or jumpForce)
			{
				currentLength=func_spaceAdd("* ",2) if (string_char_at(dialogue,1) != "*" or jumpForce) { currentLength=0; }
				if (string_char_at(dialogueSplit[currentAt],1) != "{") { currentLength+=func_spaceAdd(dialogueSplit[currentAt],(string_length(dialogueSplit[currentAt]))); }
				array_push(edges,currentAt);
			}
		
			//add space length
			currentLength+=func_spaceAdd(" ");
		
			//increase word check counter
			++currentAt;
		}
	
		//if box type is a bubble automaticaly set the y scale here
		if (box == 1) { yScale=36+array_length(edges)*20; if (arrow == 0) { x_-=xScale/2; } y_-=yScale/4; }
	
		//if press menu key auto set visible text to all real text
		if (key_menu() and hideBox == 0) { showText=dialogue; }
	}



	//addone symbol at a time to the visible text
	if !(time mod textSpeed)
	{
		if (showText != dialogue and delay == 0 and hideBox == 0)
		{
			addLetter=string_char_at(dialogue,string_length(showText)+1);
		
			if !(time mod (textSpeed)) and (!array_contains(noVoice,addLetter)) { sound(voice); }
		
			if (addLetter == "{" or addLetter == "#") { cutSpeed=true; }
	
			if (!cutSpeed) { showText+=addLetter; }
			while (cutSpeed) { addLetter=string_char_at(dialogue,string_length(showText)+1); showText+=addLetter; if (string_char_at(dialogue,string_length(showText)-1) == "}" or string_char_at(dialogue,string_length(showText)-1) == "#") { cutSpeed=false; } }
		}
	}
	if (delay > 0) { --delay; }
	if (hideBox > 0) { --hideBox; }
	
	
	
	//find inventory space value
	if (op.mode == "shop")
	{
		if (time > 1)
		{
			++oMenuShop.image;
			if (showText == dialogue) { oMenuShop.image=0; }
		}
	}
	
	
	
	//stop oChar auto animation
	if (showText == dialogue)
	{
		with (oChar) { if (returnToNormal) { image_index=0; } }
	}
}