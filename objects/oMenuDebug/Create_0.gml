reset_keys();
reset_cursor(); page="start";
master_reset();

op.mode="debug";

//
//
//

options=["noclip","room_goto","main menu","save menu"];

//
//
//

extra=[]; repeat(array_length(options)) { array_push(extra,""); }