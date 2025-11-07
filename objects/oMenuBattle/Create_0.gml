updatestruct_items();

time=0;
surfTP=-1;

tp=0;
pastTP=0;
tpUse=0;
tpShow=[0,0,0];
tpX=-30;

tp=0;

target=-1;

reset_keys();
reset_cursor(); saveCur=[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]];
master_reset(); op.cameraMode=0; op.menuPep=0;



enemyAttackExtra=[0,0,0]; 
partyAttackExtra=[0,0,0];

enemyDefenseExtra=[0,0,0];
partyDefenseExtra=[0,0,0];

extraStatsTimer=[0,0,0];
extraPartyStatsTimer=[0,0,0];

enemyStatus=["","",""];

loop=true;
normalEnd=true;
if array_contains(op.battle_seed,"stopEnd") { normalEnd=false; }

if (array_length(op.battle_enemy) == 1) { enemyHere=[true,false,false]; }
if (array_length(op.battle_enemy) == 2) { enemyHere=[true,true,false]; }
if (array_length(op.battle_enemy) == 3) { enemyHere=[true,true,true]; }

declare_battle(true);

sideText=["",""];
knockX=[0,0,0];
canSpare=false; canTired=false; alertTP=999;

bullet_objects = [];

//spawn handlers
res_i(); repeat (array_length(op.battle_enemy)) { with (instance_create_depth(0,0,0,op.battle_enemy[i]._handler)) { declare_handler(other.i); } ++i; }

//find pacify
pacify=[[],""];
res_i();
repeat(array_length(op.party))
{
	i1=0;
	repeat(array_length(op.spells[i])) { if (op.spells[i][i1]._isPacify) { array_push(pacify[0],i); pacify[1]=op.party[i]._infoText[0]; } ++i1; }
	++i;
}



drText=get_text("t_menuBattle");