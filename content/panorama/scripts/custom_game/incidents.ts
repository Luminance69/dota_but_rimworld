const Severity: Record<string, string> = {
    White: "#ffffff",
    Blue: "#79afdb",
    Yellow: "#ccc47f",
    Red: "#ca7471",
}

class Incident {
    panel: Panel;
    colour: string;
    desc: string;
    letter: ImagePanel;
    name: LabelPanel;
    tooltipDummy: Button;
    tooltipContainer: Panel;
    tooltip: LabelPanel;

    constructor(parent: Panel, severity: string, name: string) {
        const panel = $.CreatePanel("Panel", parent, "Incident");
        panel.BLoadLayoutSnippet("Incident");
        this.panel = panel;
        this.colour = Severity[severity];
        this.desc = "A group of pirates from The Mantiss of Oppression have arrived nearby.\n\nIt looks like they want to besiege the colony and pound you with mortars from a distance. You can try to wait them out - or go get them.";

        this.letter = panel.FindChild("Letter") as ImagePanel;
        this.name = panel.FindChild("Name") as LabelPanel;

        // Hover and click detection
        this.tooltipDummy = panel.FindChild("TooltipDummy") as Button;
        this.tooltipDummy.SetPanelEvent("oncontextmenu", () => ui.Delete(this));
        this.tooltipDummy.SetPanelEvent("onmouseactivate", () => this.OnLeftClick());
        // Allow positioning tooltip entirely outside dummy
        this.tooltipContainer = panel.FindChildTraverse("TooltipContainer") as Panel;
        this.tooltip = panel.FindChildTraverse("Tooltip") as LabelPanel;

        this.letter.SetImage("file://{images}/custom_game/letter.png");
        this.name.text = name;
        this.tooltip.text = this.desc;
        this.Style();
        this.Glow();
    }

    OnLeftClick() {
        const tooltipLarge = $.CreatePanel("Label", $.GetContextPanel(), "TooltipLarge");
        tooltipLarge.BLoadLayoutSnippet("TooltipLarge")
        tooltipLarge.text = this.desc;

        // Close tooltip and notification
        (<TextButton>tooltipLarge.FindChild("Close")).SetPanelEvent("onactivate", () => {
            tooltipLarge.DeleteAsync(0);
            ui.Delete(this);
        });

        // Move camera to relevant target and close incident
        (<TextButton>tooltipLarge.FindChild("Jump")).SetPanelEvent("onactivate", () => {
            GameUI.MoveCameraToEntity(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()));
            tooltipLarge.DeleteAsync(0);
            ui.Delete(this);
        });
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
