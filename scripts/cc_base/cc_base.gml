//declaring values for dialogue and cutscenes
function cc_base() constructor
{
	/*
	gets text from the csv document (the function returns an array)
	check this link:
		https://docs.google.com/spreadsheets/d/1hj0DLNNkepahaFvXPdy9alGS68qjq8zwKMC-3khYpx0/edit?usp=sharing
	and look for the realText named   "t_bakesale"   on the leftmost side
	*/
	
	_dialogue=get_text("t_bakesale");
	
	_x=[12];
	if (op.y < op.playerY-20) { _y=[1]; }else{ _y=[156]; }
	_xScale=[296.5];
	_yScale=[83.5];
	
	//[[FACE.SUSIE,1],-1,[FACE.RALSEI,5]]
	_face=[-1];
	//(0 == Shuffle back and fourth)
	_faceAnimate=[-1];
	
	_font=[fDetermination];
	_voice=[txt_text];
	_textSpeed=[1];
	
	//pauses eveything and hides the box for the designated time
	_hideBox=[0];
	
	_seed=[];
	
	//if true will automaticaly use susie's voice if susie's face is being used and etcetera for other characters.
	//(Declare this in object oDialouge create event bottom)
	_match=true;
	
	
	//(-1 == no box) // (0 == overworld box) // (1 == battle text bubble)
	_box=[0];
	//(0 == right side) // (1 == left side)
	_arrow=[-1];
	
	//[[[ OUTDATED LEAVE BE ]]]
	_color=[];
	_jump=[];
	
	
	
	_shopSprite=[-1];
	//[[sprite1,sprite2,sprite3],-1,[sprite1,sprite3]]
	_asteriskFace=[-1];
	
	//[["aaa"],["bbb"],["ccc"]]
	_printSeed=-1;
	//executes when dialouge is over.
	_func=-1;
	if (op.locationCCcheck) { _func=function(){ op.locationCCcheck=false; op.locationCC=-1; instance_create_depth(0,0,-9999,oMenuSave); } }
	//execute every time a new line begins.
	_funcLine=[];
	//execute with the {func} command, moves to the next function every time you use the command.
	_funcAny=[];
	
	_boxOffsetXY=[17,18];
	//increases to monospace width
	_xOffset=0;
	//how far to jump when you run out of space
	_yOffset=18;
	//if true will make the player able to move when the scene is done
	_moveAfter=true;
	//styles of going to the next line. can set to (-1 or "fade")
	_proceedAnimate=-1;
	//set to anything higher than 0 (This is for random encounter auto press confirm after a few frames)
	_proceedAuto=0;
	//set to anything higher than -1 to auto press confirm when the line has finished printing (it waits the amount of frames you replace -1 with)
	_autoSkipText=[-1];
	//will draw how much money and inventory space you have
	_moneyBox=false;
	
	
	
	
	
	
	//changes the base values when you are in battle
	if (op.mode == "battle")
	{
		_box=[-1];
		_x=[-2];
		_y=[156+18+op.stackFix*14];
		_xScale=[296];
		
		if (oMenuBattle.stackJump != 0) { ++op.stackFix; }
		
		_yOffset=14;
		_moveAfter=false;
		
		if (op.continueOrders) { op.continueOrders=false; _func=function(){ continue_orders(); } }
		
		
		
		if (oMenuBattle.mode == "talk")
		{
			_font=[fDotum]; _yOffset=20; _boxOffsetXY=[11,12];
			_x=[160]; _y=[120]; _xScale=[150]; _yScale=[36];
			_box=[1]; _arrow=[0];
		}
	}
	
	
	
	
	
	
	//changes the base values when you are in a shop
	if (op.mode == "shop")
	{
		_x=[0];
		_y=[120];
		_xScale=[320];
		_yScale=[120];
		_box=[-1];
		
		_moveAfter=false;
		
		if (op.continueOrders) { _func=function(){ oMenuShop.dialogueDone=true; } }
	}
}