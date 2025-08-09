func = function()
{
	anything_cutscene(
	[
	"* {color:blue} New features added because of Chapters 3 & 4:"
	,"* You can pick a uniqe icon for Weapons & Armor."
	,"* Added {color:blue} Tired pop up text {color:white} for when enemy's get tired."
	,"* Moves which spare tired enemies {color:blue} (pacify) {color:white} will glow when an enemy is tired."
	,"* The act button will glow when you can aford a action that has {color:blue} _alert {color:white} = {color:red} true;"
	,"* Accurate light world savepoints."
	,"* {color:yellow} enemy_tired(); {color:white} can be used to awaken an enemy."
	,"* Battle seed: {color:yellow} \"swoon\". {color:white} Sets HP to {color:red} -999 {color:white} when party member is knocked down."
	,"* Battle seed: {color:yellow} \"purify\". {color:white} The enemies won't be recruited or give you money when you win."
	,"* Battle seed: {color:yellow} \"noCheck\". {color:white} Removes the check option from the act menu."
	,"* {color:yellow} tpMult {color:white} was added to the {color:yellow} setup_battle(); {color:white} function."
	,"* You can add extra head icons to a spell like {color:green} old man actions {color:white} from chapter 4."
	,"* Number code prompt box was added."
	,"* You can now create quick shops with the {color:yellow} create_shop(); {color:white} function."
	,"* You can draw sprites in text boxes with a new command. {sprite:sKris_Down:10:30:0:0} {color:yellow} \"sprite\"."
	,"* Added puzzle text maker with {color:yellow} effect_puzzleText();"
	,"* You can make dialogue auto proceed {color:yellow} after a picked delay {color:white} in dialouge structs. {color:blue} _autoSkipText"
	,"* Added ghost walls for layer swap. {color:yellow} (Check room to the left)"
	]);
}

draw = function()
{
	draw_ext(sSign,0,x,y);
}