if (draw == -1 or drawSelf) { draw_self(); }

if (draw != -1)
{
	depth=-y;
	if (spawnGhostWall)
		depth -= room_height;
	
	draw();
}