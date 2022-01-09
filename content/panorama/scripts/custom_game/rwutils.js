"use strict";
function Vec(...args) {
    return new Vector(...args);
}
class Vector {
    constructor(x = 0, y = 0, z = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    static sub(a, b) {
        if (typeof b === "number") {
            return new Vector(a.x - b, a.y - b, a.z - b);
        }
        else {
            return new Vector(a.x - b.x, a.y - b.y, a.z - b.z);
        }
    }
}
function MovePanelToWorldPos(panel, wPos) {
    const sPos = WorldToScreen(wPos);
    const scale = Game.GetScreenHeight() / 1080;
    const width = panel.actuallayoutwidth / scale;
    const height = panel.actuallayoutheight / scale;
    const offsetX = width / 2;
    const offsetY = height / 2;
    const x = sPos.x / scale - offsetX;
    const y = sPos.y / scale - offsetY;
    panel.style.x = `${x}px`;
    panel.style.y = `${y}px`;
}
function WorldToScreen(pos) {
    return Vec(Game.WorldToScreenX(pos.x, pos.y, pos.z), Game.WorldToScreenY(pos.x, pos.y, pos.z));
}
function ParseLuaArray(array) {
    return typeof array === "object"
        ? Object.values(array)
        : [array];
}
function ParseChatArgs(text) {
    const exp = /[^\s"]+|"([^"]*)"/g;
    let args = [];
    do {
        var match = exp.exec(text);
        if (match)
            args.push(match[1] ? match[1] : match[0]);
    } while (match);
    return args;
}
