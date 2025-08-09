use_keys(); if (page == 0) { reset_keys(); }



if (tapCancel) and (page == "buy" or page == "sell" or page == "talk") { spawnFlavour=true; }



if (tapCancel and page == "buy2") { spawnThin=true; textThin=[sstr._textBuy[1]]; }
if (tapCancel) and (page == "sellItem" or page == "sellWeapon" or page =="sellArmor" or page == "sellStorage") { spawnThin=true; textThin=[sstr._textSell[0]]; }
if (tapCancel) and (page == "sellYN") { spawnThin=true; textThin=[sstr._textSell[6]]; }

if (tapCancel and page != "start") { instance_destroy(oDialogue); }
if (tapConfirm) and !(page == "buy" and has_progress(string(saveCur[0])+"="+string(room)+"sold")) { instance_destroy(oDialogue); }
use_cursor();

++time;
if (time == 2)
{
	if (!quickShop) { music(sstr._music,true); }
	
	items=[];
	res_i();
	repeat (4)
	{
		struct(sstr._items[i]); array_push(items,str);
		++i;
	}
	
	sprite=sstr._spriteIdle;
}



if (dialogueDone) { dialogueDone=false; force_undo(0); spawnThin=true; textThin=[sstr._textTalk]; sprite=sstr._spriteIdle; }
if (page == "buy" or page == "buy2") { nudge-=4; }else{ nudge+=4; } nudge=clamp(nudge,-60,0);

if (page == "start")
{
	res_i(); i1=["buy","sell","talk"];
	
	vertical_cursor(4);
	
	if (quickShop)
	{
		if tap_cancel()
		{
			instance_destroy(oDialogue);
			
			page=0; cursor=0;
			op.mode = "overworld";
			instance_destroy();
		}
	}
	
	if tap_confirm(0) { page=i1[sstr._mainButtons[0]]; cursor=0; }
	if tap_confirm(1) { page=i1[sstr._mainButtons[1]]; cursor=0; }
	if tap_confirm(2) { page=i1[sstr._mainButtons[2]]; cursor=0; }
	if tap_confirm(3)
	{
		page=0; cursor=0;
		
		if (!quickShop)
		{
			start_cutscene("cc_shopExit");
		}
		else
		{
			op.mode = "overworld";
			instance_destroy();
		}
	}
	
	if (page == "buy") { spawnThin=true; textThin=[sstr._textBuy[0]]; }
	if (page == "sell") { spawnThin=true; textThin=[sstr._textSell[0]]; cursor=saveCur[1]; }
	if (page == "talk") { spawnThin=true; textThin=[sstr._textTalk]; cursor=0; }
}



if (page == "buy" or page == "buy2")
{
	if (saveCur[0] < 4) { if (boxY > -80) { boxY-=10; }else{ boxY-=5; } }else{ boxY+=15; } boxY=clamp(boxY,-110,-20);
}
else { boxY=-20; }

if (page == "buy")
{
	vertical_cursor(5); saveCur[0]=cursor;
	
	itemType="i";
	if (cursor < 4)
	{
		if (items[saveCur[0]]._attack > 0 or items[saveCur[0]]._defense > 0 or items[saveCur[0]]._magic > 0) { itemType="a"; }
		if (items[saveCur[0]]._numberExistence != -1) { itemType="w"; }
		if (items[saveCur[0]]._isKeyitem) { itemType="k"; }
	}
	
	if tap_confirm()
	{
		i=string(saveCur[0])+"="+string(room)+"sold";
		if (cursor < 4) { if has_progress(i) { force_undo(0); }else{ page="buy2" cursor=0; } } else { spawnFlavour=true; force_undo(1); }
	}
}



if (page == "buy2")
{
	vertical_cursor(2);
	
	if tap_confirm(0)
	{
		spawnThin=true; textThin=[sstr._textBuy[2]];
		
		if (op.money >= items[saveCur[0]]._price)
		{
			res_i(); i1=true;
			if (itemType == "i" and op.fullItem) { i1=false; }
			if (itemType == "a" and !array_contains(op.armor,-1)) { i1=false; }
			if (itemType == "w" and !array_contains(op.weapon,-1)) { i1=false; }
			
			if (i1)
			{
				if (sstr._soldOut[saveCur[0]]) { add_progress(string(saveCur[0])+"="+string(room)+"sold"); }
				
				if (itemType == "i") { add_item(sstr._items[saveCur[0]]); }
				if (itemType == "a") { add_armor(sstr._items[saveCur[0]]); }
				if (itemType == "w") { add_weapon(sstr._items[saveCur[0]]); }
				if (itemType == "k") { add_item(sstr._items[saveCur[0]],true); }
			}
			
			spawnThin=true;
			if (i1) { op.money-=items[saveCur[0]]._price; textThin=[sstr._textBuy[2]]; sound(snd_locker); }else{ textThin=[sstr._textBuy[4]]; }
		}
		else
		{
			spawnThin=true; textThin=[sstr._textBuy[3]];
		}
		
		force_undo(1);
	}
	if tap_confirm(1) { spawnThin=true; textThin=[sstr._textBuy[1]]; force_undo(1); }
}



if (page == "sell")
{
	offsetPress=0; offset=0;
	vertical_cursor(5); saveCur[1]=cursor;
	
	if tap_confirm(0)
	{
		page="sellItem"; spawnThin=true;
		if (array_length(op.item) == 0) { force_undo(0); textThin=[sstr._textSell[4]]; }else{ cursor=0; textThin=[sstr._textSell[1]]; }
	}
	if tap_confirm(1)
	{
		page="sellWeapon"; spawnThin=true;
		res_i(); i1=true; repeat (array_length(op.weapon)) { if (op.weapon[i] != -1) { i1=false; } ++i; }
		if (i1) { force_undo(0); textThin=[sstr._textSell[4]]; }else{ cursor=0; textThin=[sstr._textSell[2]]; }
	}
	if tap_confirm(2)
	{
		page="sellArmor"; spawnThin=true;
		res_i(); i1=true; repeat (array_length(op.armor)) { if (op.armor[i] != -1) { i1=false; } ++i; }
		if (i1) { force_undo(0); textThin=[sstr._textSell[4]]; }else{ cursor=0; textThin=[sstr._textSell[3]]; }
	}
	if tap_confirm(3)
	{
		page="sellStorage"; spawnThin=true;
		res_i(); i1=true; repeat (array_length(op.storage)) { if (op.storage[i] != -1) { i1=false; } ++i; }
		if (i1) { force_undo(0); textThin=[sstr._textSell[4]]; }else{ cursor=0; textThin=[sstr._textSell[1]]; }
	}
	
	if tap_confirm(4) { spawnFlavour=true; force_undo(1); }
}



if (page == "sellItem" or page == "sellWeapon" or page == "sellArmor" or page == "sellStorage")
{
	res_i();
	if (page == "sellItem") { sellType="i"; sellArray=op.item; }
	if (page == "sellWeapon") { sellType="w"; sellArray=op.weapon; }
	if (page == "sellArmor") { sellType="a"; sellArray=op.armor; }
	if (page == "sellStorage") { sellType="s"; sellArray=op.storage; }
	
	if (array_length(sellArray) > 5)
	{
		if (tapUp)
		{
			--offsetPress;
			if (offsetPress < 0) { offsetPress=0; --offset; }
			if (cursor == 0) { cursor=array_length(sellArray); offsetPress=4; offset=array_length(sellArray)-(4+1); }
		}
		
		if (tapDown)
		{
			++offsetPress;
			if (offsetPress > 4) { offsetPress=4; ++offset; }
			if (cursor == array_length(sellArray)-1) { cursor=-1; offsetPress=0; offset=0; }
		}
	}
	
	vertical_cursor(array_length(sellArray)); if (cursor < offset) { offset=cursor; } saveCur[2]=cursor;
	
	if tap_confirm()
	{
		if (sellArray[saveCur[2]] != -1 and sellArray[saveCur[2]]._canSell) { page="sellYN"; cursor=0; }
		if (sellArray[saveCur[2]] == -1) { force_undo(0); spawnThin=true; textThin=[sstr._textSell[8]]; }else if (!sellArray[saveCur[2]]._canSell) { force_undo(0); spawnThin=true; textThin=[sstr._textSell[9]]; }
	}
}



if (page == "sellYN")
{
	vertical_cursor(2);
	
	if tap_confirm(0)
	{
		sound(snd_locker);
		op.money+=round(sellArray[saveCur[2]]._price/2);
		
		if (sellType == "i")
		{
			array_delete(op.item,saveCur[2],1);
			
			if (array_length(op.item) == 0)
			{
				force_undo(2);
				spawnThin=true; textThin=[sstr._textSell[5]];
			}
			else
			{
				force_undo(1);
				
				if (cursor >= array_length(op.item)) { --saveCur[2]; --cursor; if (offset > 0) { --offset; } }
				
				if (array_length(op.item) <= 5) { offsetPress=0; }
				spawnThin=true; textThin=[sstr._textSell[7]];
			}
		}
		else
		{
			sellArray[saveCur[2]]=-1;
			force_undo(1);
			
			spawnThin=true; textThin=[sstr._textSell[7]];
		}
	}
	
	if tap_confirm(1) { force_undo(1); spawnThin=true; textThin=[sstr._textSell[6]]; }
}



if (page == "talk")
{
	vertical_cursor(5);
	
	if tap_confirm()
	{
		if (cursor < 4)
		{
			start_cutscene(sstr._cutsceneTalk[cursor][talkChecks[cursor]],,true);
			
			if (array_length(sstr._cutsceneTalk[cursor]) != talkChecks[cursor]+1)
			{
				add_progress(string(cursor)+"="+string(talkChecks[cursor])+"="+string(room)+"talk");
				++talkChecks[cursor];
			}
			page=0;
		}
		else
		{
			spawnFlavour=true; force_undo(1);
		}
	}
}



if (page != "start") { checkOtherMenu=true; }

if (spawnFlavour)
{
	spawnFlavour=false; sprite=sstr._spriteIdle;
	if (checkOtherMenu) { op.textCC=[sstr._textFlavour[1]]; }else{ op.textCC=[sstr._textFlavour[0]]; }
	
	start_cutscene("cc_shopFlavour");
}

if (spawnThin)
{
	spawnThin=false;
	op.textCC=textThin;
	
	i=0; repeat (array_length(sstr._textFlavour)) { if (op.textCC[0] == sstr._textFlavour[i] and sstr._spriteFlavour[i] != -1) { sprite=sstr._spriteFlavour[i]; } ++i; }
	i=0; repeat (array_length(sstr._textBuy)) { if (op.textCC[0] == sstr._textBuy[i] and sstr._spriteBuy[i] != -1) { sprite=sstr._spriteBuy[i]; } ++i; }
	i=0; repeat (array_length(sstr._textSell)) { if (op.textCC[0] == sstr._textSell[i] and sstr._spriteSell[i] != -1) { sprite=sstr._spriteSell[i]; } ++i; }
	
	start_cutscene("cc_shopThin");
}