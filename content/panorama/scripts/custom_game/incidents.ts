const _WIDTH = 76; // Original letter width
const _HEIGHT = 60; // Original letter height
const SCALING = 0.7;
const WIDTH = _WIDTH * SCALING;
const HEIGHT = _HEIGHT * SCALING;
const MARGIN = 20;

class Incident {
    panel: Panel;
    targets: EntityIndex[];
    letter: ImagePanel;
    name: LabelPanel;
    tooltipDummy: Button;
    tooltipSmall?: LabelPanel;
    arrows: Arrow[] = [];

    constructor(parent: Panel, name: string, description: string, severity: Severity, targets: EntityIndex[]) {
        const panel = $.CreatePanel("Panel", parent, "Incident");
        panel.BLoadLayoutSnippet("Incident");
        this.panel = panel;
        this.targets = targets;
        this.letter = panel.FindChild("Letter") as ImagePanel;
        this.name = panel.FindChild("Name") as LabelPanel;

        // Hover and click detection
        this.tooltipDummy = panel.FindChild("TooltipDummy") as Button;

        // Incident right click
        this.tooltipDummy.SetPanelEvent("oncontextmenu", () => {
            Game.EmitSound("Click");
            ui.DeleteIncident(this);
        });

        // Incident left click
        this.tooltipDummy.SetPanelEvent("onmouseactivate", () => {
            Game.EmitSound("CommsWindow_Open");
            this.CreateLargeTooltip(description);
        });

        // Small tooltip and arrow on hover
        this.tooltipDummy.SetPanelEvent("onmouseover", () => {
            this.tooltipSmall = this.CreateSmallTooltip(description);
            targets.forEach(t => this.arrows.push(new Arrow(t)));
        });

        // Cleanup small tooltip and arrow
        this.tooltipDummy.SetPanelEvent("onmouseout", () => {
            this.tooltipSmall!.DeleteAsync(0);
            this.arrows.forEach(a => a.panel.DeleteAsync(0));
            this.arrows = [];
        });

        // Styles and effects
        this.name.text = name;
        this.Style(severity.color);

        $.Schedule(2, () => {
            this.panel.RemoveClass("Init");
            this.letter.style.boxShadow = `${severity.color}00 100px 0px 250px 0px`;
            this.letter.style.transitionProperty = "box-shadow";
            this.letter.style.transitionDuration = "0.5s";
            this.Glow(severity.tGlow, severity.color);
        });

        if (severity.tBounce) {
            $.Schedule(severity.tBounce, () => {
                this.Bounce(severity.tBounce!);
            });
        };
    }

    CreateSmallTooltip(text: string) {
        const tooltipSmall = $.CreatePanel("Label", $.GetContextPanel(), "TooltipSmall");
        tooltipSmall.BLoadLayoutSnippet("TooltipSmall");
        tooltipSmall.text = text;

        tooltipSmall.SetPanelEvent("onload", () => {
            let {x, y} = this.letter.GetPositionWithinWindow();
            x -= tooltipSmall.actuallayoutwidth + MARGIN;
            y -= tooltipSmall.actuallayoutheight/2;
            tooltipSmall.SetPositionInPixels(x, y, 0);
            tooltipSmall.style.opacity = "1";
        });

        return tooltipSmall;
    }

    CreateLargeTooltip(text: string) {
        const container = $.CreatePanel("Button", $.GetContextPanel(), "");
        container.BLoadLayoutSnippet("TooltipLarge");
        const tooltipLarge = container.FindChild("TooltipLarge") as LabelPanel;
        tooltipLarge.text = text;

        // Close tooltip/incident
        (<TextButton>tooltipLarge.FindChild("Close")).SetPanelEvent("onactivate", () => {
            Game.EmitSound("CommsWindow_Close");
            container.DeleteAsync(0);
            ui.DeleteIncident(this);
        });

        // Move camera to relevant target and close tooltip/incident
        (<TextButton>tooltipLarge.FindChild("Jump")).SetPanelEvent("onactivate", () => {
            Game.EmitSound("CommsWindow_Close");
            GameUI.MoveCameraToEntity(this.targets[0]);
            GameUI.SelectUnit(this.targets[0], false);
            container.DeleteAsync(0);
            ui.DeleteIncident(this);
        });
    }

    Style(color: string) {
        this.panel.style.height = `${HEIGHT}px`;
        this.panel.style.margin = `${MARGIN / 2}px 0px`;

        this.letter.style.washColor = `${color}`
        this.letter.style.width = `${WIDTH}px`;
        this.letter.style.margin = `0px ${MARGIN}px`; // Left margin to centre name

        this.tooltipDummy.style.width = `${WIDTH}px`;
        this.tooltipDummy.style.marginRight = `${MARGIN}px`;
    }

    // Simulates a keyframe with dynamic colouring
    Glow(period: number, colour: string) {
        if (!this.panel.IsValid()) return;

        this.letter.style.boxShadow = `${colour}50 100px 0px 550px 0px`;
        $.Schedule(0.5, () =>
            this.letter.style.boxShadow = `${colour}00 100px 0px 250px 0px`
        );

        // Repeat every <period> seconds
        $.Schedule(period, () => this.Glow(period, colour));
    }

    // Scale margin with bounce animation to correctly render text
    Bounce(period: number) {
        if (!this.panel.IsValid()) return;

        this.panel.ToggleClass("Bounce");

        // Repeat every <period> seconds
        $.Schedule(period, () => this.Bounce(period));
    }
}

class Problem {
    panel: LabelPanel;
    type: string;
    targets: EntityIndex[];
    cycle: number = 0;
    tooltipSmall?: LabelPanel;
    arrows: Arrow[] = [];

    constructor(parent: Panel, type: string, name: string, description: string, targets: EntityIndex[]) {
        const panel = $.CreatePanel("Label", parent, "Problem") as LabelPanel;
        this.panel = panel;
        this.type = type;
        this.targets = targets;

        this.UpdateTargets(parent, name, description, targets);

        Game.EmitSound("TinyBell");
        if (parent.id === "Major") Game.EmitSound("AlertRed");
    }

    // Reapply text and targets to closure
    // Decrementing to 0 targets deletes itself
    UpdateTargets(parent: Panel, name: string, description: string, targets: EntityIndex[]) {
        if (!targets.length) ui.DeleteProblem(this);
        this.targets = targets;

        // Jump on right click
        this.panel.SetPanelEvent("oncontextmenu", () => {
            if (this.cycle > targets.length-1) this.cycle = 0;
            GameUI.MoveCameraToEntity(targets[this.cycle]);
            GameUI.SelectUnit(targets[this.cycle], false);
            ++this.cycle
        });

        // Jump on left click
        this.panel.SetPanelEvent("onactivate", () => {
            if (this.cycle > targets.length-1) this.cycle = 0;
            GameUI.MoveCameraToEntity(targets[this.cycle]);
            GameUI.SelectUnit(targets[this.cycle], false);
            ++this.cycle
        });

        // Small tooltip and arrow on hover
        this.panel.SetPanelEvent("onmouseover", () => {
            this.tooltipSmall = this.CreateSmallTooltip(description);
            targets.forEach(t => this.arrows.push(new Arrow(t)));
        });

        // Cleanup small tooltip and arrow
        this.panel.SetPanelEvent("onmouseout", () => {
            this.tooltipSmall!.DeleteAsync(0);
            this.arrows.forEach(a => a.panel.DeleteAsync(0));
            this.arrows = [];
        });

        this.panel.text = name;
        this.panel.SetParent(parent);
    }

    CreateSmallTooltip(text: string) {
        const tooltipSmall = $.CreatePanel("Label", $.GetContextPanel(), "TooltipSmall");
        tooltipSmall.BLoadLayoutSnippet("TooltipSmall");
        tooltipSmall.text = text;

        tooltipSmall.SetPanelEvent("onload", () => {
            let {x,} = this.panel.GetPositionWithinWindow();
            x -= tooltipSmall.actuallayoutwidth + MARGIN;

            // Lock y-level to cursor y-level
            (function UpdateY() {
                if (!tooltipSmall.IsValid()) return;

                let [,y] = GameUI.GetCursorPosition();
                tooltipSmall.SetPositionInPixels(x, y, 0);

                $.Schedule(0.02, () => UpdateY());
            })();

            tooltipSmall.style.opacity = "1";
        });

        return tooltipSmall;
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

        this.panel.SetPanelEvent("onload", () => {
            this.Update();
            this.panel.style.opacity = "1";
        });
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
                this.Centre();
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

    Centre() {
        this.panel.SetPositionInPixels(
            (1920 - this.panel.actuallayoutwidth)/2,
            (1080 - this.panel.actuallayoutheight)/2,
            0
        );
    }
}
