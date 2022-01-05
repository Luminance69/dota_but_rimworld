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
    tooltipDummy: Panel;
    tooltipContainer: Panel;
    tooltip: LabelPanel;

    constructor(parent: Panel, severity: string, name: string) {
        const panel = $.CreatePanel("Panel", parent, "Incident");
        panel.BLoadLayoutSnippet("Incident");
        this.panel = panel;
        this.colour = Severity[severity];

        this.letter = panel.FindChild("Letter") as ImagePanel;
        this.name = panel.FindChild("Name") as LabelPanel;

        // Hover detection
        this.tooltipDummy = panel.FindChild("TooltipDummy") as Panel;
        // Allow positioning tooltip entirely outside dummy
        this.tooltipContainer = panel.FindChildTraverse("TooltipContainer") as Panel;
        this.tooltip = panel.FindChildTraverse("Tooltip") as LabelPanel;

        this.letter.SetImage("file://{images}/custom_game/letter.png");
        this.name.text = name;
        this.tooltip.text = "A group of pirates from The Mantiss of Opression have arrived nearby.\n\nIt looks like the want to besiege the colony and pound you with mortars from a distance. You can try to wait them out - or go get them."
        this.Style();
        this.Glow();
    }

    Style() {
        const _WIDTH = 76; // Original letter width
        const _HEIGHT = 60; // Original letter height
        const SCALING = 0.75;
        const WIDTH = _WIDTH * SCALING
        const HEIGHT = _HEIGHT * SCALING
        const MARGIN = 20;

        this.panel.style.height = `${HEIGHT}px`;
        this.panel.style.margin = `${MARGIN / 2}px 0px`;

        this.letter.style.washColor = `${this.colour}`
        this.letter.style.width = `${WIDTH}px`;
        this.letter.style.marginRight = `${MARGIN}px`;

        this.tooltipDummy.style.width = `${WIDTH}px`;
        this.tooltipDummy.style.marginRight = `${MARGIN}px`;
        this.tooltipContainer.style.width = `${WIDTH + MARGIN}px`
        this.tooltipContainer.style.marginRight = `${MARGIN}px`;

        // Awful hack to centre text while allowing overflow into margin
        (function centre(panel) {
            !panel.actuallayoutwidth
            ? $.Schedule(0.1, () => centre(panel))
            : panel.style.width = `${panel.actuallayoutwidth + 25}px`;
        })(this.panel);
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
