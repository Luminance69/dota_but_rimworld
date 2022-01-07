function Vec(...args: number[]) {
    return new Vector(...args);
}

class Vector {
    x: number;
    y: number;
    z: number;

    constructor(x: number = 0, y: number = 0, z: number = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    static sub(a: Vector, b: Vector | number) {
        if (typeof b === "number") {
            return new Vector(
                a.x - b,
                a.y - b,
                a.z - b,
            )
        } else {
            return new Vector(
                a.x - b.x,
                a.y - b.y,
                a.z - b.z,
            )
        }
    }
}

function MovePanelToWorldPos(panel: Panel, wPos: Vector) {
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

function WorldToScreen(pos: Vector) {
    return Vec(
        Game.WorldToScreenX(pos.x, pos.y, pos.z),
        Game.WorldToScreenY(pos.x, pos.y, pos.z),
    )
}
