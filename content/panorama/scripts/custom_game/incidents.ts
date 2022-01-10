class Incident {
    panel: Panel;
    letter: ImagePanel;
    name: LabelPanel;
    tooltipDummy: Button;
    tooltipContainer: Panel;
    tooltip: LabelPanel;
    arrows: Arrow[] = [];

    constructor(parent: Panel, name: string, description: string, colour: string, targets: EntityIndex[]) {
        const panel = $.CreatePanel("Panel", parent, "Incident");
        panel.BLoadLayoutSnippet("Incident");
        this.panel = panel;
        this.letter = panel.FindChild("Letter") as ImagePanel;
        this.name = panel.FindChild("Name") as LabelPanel;

        // Hover and click detection
        this.tooltipDummy = panel.FindChild("TooltipDummy") as Button;
        // Incident right click
        this.tooltipDummy.SetPanelEvent("oncontextmenu", () => {
            Game.EmitSound("Click");
            ui.Delete(this);
        });

        // Incident left click
        this.tooltipDummy.SetPanelEvent("onmouseactivate", () => {
            Game.EmitSound("CommsWindow_Open");
            this.CreateLargeTooltip(description);
        });

        // Allow positioning tooltip entirely outside dummy
        this.tooltipContainer = panel.FindChildTraverse("TooltipContainer") as Panel;
        this.tooltip = panel.FindChildTraverse("Tooltip") as LabelPanel;

        // Arrow pointing to incident target
        this.tooltipDummy.SetPanelEvent("onmouseover", () => {
            targets.forEach(t => this.arrows.push(new Arrow(t)));
        });

        this.tooltipDummy.SetPanelEvent("onmouseout", () => {
            this.arrows.forEach(a => a.panel.DeleteAsync(0));
            this.arrows = [];

        });

        // Styles and effects
        this.name.text = name;
        this.tooltip.text = description;
        this.Style(colour);
        this.Glow(colour);
    }

    CreateLargeTooltip(text: string) {
        const tooltipLarge = $.CreatePanel("Label", $.GetContextPanel(), "TooltipLarge");
        tooltipLarge.BLoadLayoutSnippet("TooltipLarge");
        tooltipLarge.text = text;

        // Close tooltip/incident
        (<TextButton>tooltipLarge.FindChild("Close")).SetPanelEvent("onactivate", () => {
            Game.EmitSound("CommsWindow_Close");
            tooltipLarge.DeleteAsync(0);
            ui.Delete(this);
        });

        // Move camera to relevant target and close tooltip/incident
        (<TextButton>tooltipLarge.FindChild("Jump")).SetPanelEvent("onactivate", () => {
            Game.EmitSound("CommsWindow_Close");
            GameUI.MoveCameraToEntity(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()));
            tooltipLarge.DeleteAsync(0);
            ui.Delete(this);
        });
    }

    Style(colour: string) {
        const _WIDTH = 76; // Original letter width
        const _HEIGHT = 60; // Original letter height
        const SCALING = 0.75;
        const WIDTH = _WIDTH * SCALING
        const HEIGHT = _HEIGHT * SCALING
        const MARGIN = 20;

        this.panel.style.height = `${HEIGHT}px`;
        this.panel.style.margin = `${MARGIN / 2}px 0px`;

        this.letter.style.washColor = `${colour}`
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
    Glow(colour: string) {
        this.letter.style.boxShadow = `${colour}00 100px 0px 250px 0px`;
        $.Schedule(1, () => {
            this.letter.style.boxShadow = `${colour}60 100px 0px 450px 0px`;
            $.Schedule(1, () =>
                this.letter.style.boxShadow = `${colour}00 100px 0px 250px 0px`
            );
        });
    }
}

class Arrow {
    panel: ImagePanel;
    target: EntityIndex;
    latched: boolean = true; // Cleanup when attaching/detaching

    constructor(target: EntityIndex) {
        this.panel = $.CreatePanel("Image", $.GetContextPanel(), "Arrow");
        this.panel.BLoadLayoutSnippet("Arrow");
        this.target = target;
        this.Update();
    }

    Update() {
        if (!this.panel.IsValid()) return;

        const r = 0.25 * Game.GetScreenHeight(); // Arrow pivot radius
        const cam = Vec(...GameUI.GetCameraLookAtPosition()); // Camera pos
        const ent = Vec(...Entities.GetAbsOrigin(this.target)); // Target pos
        const dir = Vector.sub(ent, cam); // ent - cam
        const dist = Math.sqrt(dir.x**2 + dir.y**2); // |dir|

        if (dist > r+350) {
            // Centre arrow after detaching
            if (this.latched) {
                this.latched = false;
                this.panel.SetPositionInPixels(
                    (1920 - this.panel.actuallayoutwidth)/2,
                    (1080 - this.panel.actuallayoutheight)/2,
                    0
                );
            };

            // deg: Angle between ent-cam and the y vector
            let deg = Math.acos(dir.y / Math.sqrt(dir.x**2 + dir.y**2));
            deg *= 180/Math.PI;
            deg *= Math.sign(dir.x);

            this.panel.style.transform = `translateY(-${r}px) rotateZ(${deg}deg)`;
        } else {
            this.latched = true;
            this.panel.style.transform = null;
            MovePanelToWorldPos(this.panel, ent);
        }

        $.Schedule(0.01, () => this.Update());
    }
}
