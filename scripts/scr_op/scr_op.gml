//declares and resets the games major stats
//run this when you launch a new save file
function declare_gamestats()
{
	op.seconds=0;
	op.minutes=0;
	
	op.progress=[];
	op.winRooms=[];
	op.killRooms=[];

	op.name_="John";
	op.money=0;
	op.moneyLight=2;
	op.encounterKills=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	op.party=[];
	op.partyFollow=[0,1,2];

	op.partyPosOffset=[0,0,0];
	op.followers=[];
	
	op.hp=[300,300,150];
	op.hpMax=[300,300,300];
	op.attack=[10,10,10];
	op.defense=[1,1,1];
	op.magic=[0,1,1];
	op.guts=[1,2,0];
	op.level=[1,1,1];
	op.ability=[[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]];

	op.equipped=[[-1,-1,-1],[-1,-1,-1],[-1,-1,-1]]; /* struct */
	op.spells=[[],[],[]]; /* struct */
	
	op.item=[]; /* struct */
	op.storage=array_create(24,-1); /* struct */
	op.itemKey=[]; /* struct */
	op.weapon=array_create(48,-1); /* struct */
	op.armor=array_create(48,-1); /* struct */

	op.recruits=[];
	op.lost=[];

	op.itemLight=[];
	repeat(0) { add_itemlight("item_base"); }
	op.cell=[];
	repeat(0) { add_cell("item_base"); }
	
	op.allData=[];
	
	add_party("pep_kris");
	add_party("pep_susie");
	add_party("pep_ralsei");
	set_party_stats(0,100,10,3,0,1,1,"item_woodBlade",,,["spell_check"]);
	set_party_stats(1,200,10,3,5,1,1,"item_maneAx",,,["spell_rudeBuster","spell_ultimateHeal"]);
	set_party_stats(2,300,10,3,7,1,1,"item_redScarf",,,["spell_pacify","spell_healPrayer"]);
	
	add_item("item_cellPhone",true);
}