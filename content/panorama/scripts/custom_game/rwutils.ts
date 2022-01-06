function MovePanelToWorldPos(panel: Panel, pos: number[]) {
	pos = WorldToScreen(pos);
	const scale = Game.GetScreenHeight() / 1080;
	const width = panel.actuallayoutwidth / scale;
	const height = panel.actuallayoutheight / scale;
	const offsetX = width / 2;
	const offsetY = height / 2;

	let x = pos[0] / scale - offsetX;
	let y = pos[1] / scale - offsetY;
	$.Msg(x,y)
	panel.style.x = `${x}px`;
	panel.style.y = `${y}px`;
}

function WorldToScreen(pos: number[]) {
	return [
		Game.WorldToScreenX(pos[0], pos[1], pos[2]),
		Game.WorldToScreenY(pos[0], pos[1], pos[2]),
	]
}
