op.showHitboxes=false;
op.debug=false;

music(mus_scarletForest);

op.locationText="Forest - Push";
op.locationCC="cc_base";

//
//
//

//Spawn Lancer
create_char(0,"lan",220,185,an_lancer_walk());

//
//
//

setup_battle(["enemy_viro","enemy_ambu","enemy_jevil"]);

create_char_enemy("ene0",110-45,310+25,"enemy_viro",pPath3);