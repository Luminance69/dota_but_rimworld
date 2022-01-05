const Severity: Record<string, string> = {
    White: "#ffffff",
    Blue: "#79afdb",
    Yellow: "#ccc47f",
    Red: "#ca7471",
}

class Incident {
    panel: Panel;
    colour: string;
    letter: ImagePanel;
    name: LabelPanel;

    constructor(parent: Panel, severity: string, name: string) {
        const panel = $.CreatePanel("Panel", parent, "Incident");
        panel.BLoadLayoutSnippet("Incident");
        this.panel = panel;
        this.colour = Severity[severity];

        this.letter = panel.FindChild("Letter") as ImagePanel;
        this.name = panel.FindChild("Name") as LabelPanel;

        this.letter.SetImage("file://{images}/custom_game/letter.png");
        this.name.text = name;
        this.Style();
        this.Glow();
    }

    Style() {
        const _WIDTH = 76; // Original letter width
        const _HEIGHT = 60; // Original letter height
        const SCALING = 0.75;
        const MARGIN = 20;

        this.panel.style.height = `${_HEIGHT * SCALING}px`;
        this.panel.style.margin = `${MARGIN / 2}px 0px`;

        this.letter.style.washColor = `${this.colour}`
        this.letter.style.width = `${_WIDTH * SCALING}px`;
        this.letter.style.marginRight = `${MARGIN}px`;

        // Awful hack to centre text while allowing overflow into margin
        $.Schedule(0.2, () =>
            this.panel.style.width = `${this.panel.actuallayoutwidth + 25}px`
        );
    }

    // Simulates a keyframe with dynamic colouring
    Glow() {
        this.letter.style.boxShadow = `${this.colour}00 100px 0px 250px 0px`;
        $.Schedule(1, () => {
            this.letter.style.boxShadow = `${this.colour}60 100px 0px 450px 0px`;
            $.Schedule(1, () =>
                this.letter.style.boxShadow = `${this.colour}00 100px 0px 250px 0px`
            );
        });
    }
}
