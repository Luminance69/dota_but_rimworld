"use strict";
class Incident {
    constructor(parent, name, description, colour, target) {
        const panel = $.CreatePanel("Panel", parent, "Incident");
        panel.BLoadLayoutSnippet("Incident");
        this.panel = panel;
        this.letter = panel.FindChild("Letter");
        this.name = panel.FindChild("Name");
        // Hover and click detection
        this.tooltipDummy = panel.FindChild("TooltipDummy");
        this.tooltipDummy.SetPanelEvent("oncontextmenu", () => ui.Delete(this));
        this.tooltipDummy.SetPanelEvent("onmouseactivate", () => this.OnLeftClick(description));
        // Allow positioning tooltip entirely outside dummy
        this.tooltipContainer = panel.FindChildTraverse("TooltipContainer");
        this.tooltip = panel.FindChildTraverse("Tooltip");
        // Arrow pointing to incident target
        this.arrow = $.GetContextPanel().FindChildTraverse("Arrow");
        this.tooltipDummy.SetPanelEvent("onmouseover", () => {
            this.arrow.enabled = true;
            this.WhileHover(target);
        });
        this.tooltipDummy.SetPanelEvent("onmouseout", () => {
            this.arrow.enabled = false;
            this.arrow.style.transform = null;
            // Why does this work??
            this.arrow.SetPositionInPixels((1920 - 50) / 2, (1080 - 50) / 2, 0);
        });
        // Styles and effects
        this.name.text = name;
        this.tooltip.text = description;
        this.Style(colour);
        this.Glow(colour);
    }
    WhileHover(target) {
        if (!this.arrow.enabled)
            return;
        const r = 0.2 * Game.GetScreenHeight(); // Arrow pivot radius
        const cam = Vec(...GameUI.GetCameraLookAtPosition()); // Camera pos
        const ent = Vec(...Entities.GetAbsOrigin(target)); // Target pos
        const dir = Vector.sub(ent, cam); // ent - cam
        const dist = Math.sqrt(dir.x ** 2 + dir.y ** 2); // |dir|
        if (dist > r + 300) {
            // deg: Angle between ent-cam and the y vector
            let deg = Math.acos(dir.y / Math.sqrt(dir.x ** 2 + dir.y ** 2));
            deg *= 180 / Math.PI;
            deg *= Math.sign(dir.x);
            this.arrow.style.transform = `translateY(-${r}px) rotateZ(${deg}deg)`;
        }
        else {
            this.arrow.style.transform = null;
            MovePanelToWorldPos(this.arrow, ent);
        }
        $.Schedule(0.01, () => this.WhileHover(target));
    }
    OnLeftClick(text) {
        const tooltipLarge = $.CreatePanel("Label", $.GetContextPanel(), "TooltipLarge");
        tooltipLarge.BLoadLayoutSnippet("TooltipLarge");
        tooltipLarge.text = text;
        // Close tooltip and notification
        tooltipLarge.FindChild("Close").SetPanelEvent("onactivate", () => {
            tooltipLarge.DeleteAsync(0);
            ui.Delete(this);
        });
        // Move camera to relevant target and close incident
        tooltipLarge.FindChild("Jump").SetPanelEvent("onactivate", () => {
            GameUI.MoveCameraToEntity(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()));
            tooltipLarge.DeleteAsync(0);
            ui.Delete(this);
        });
    }
    Style(colour) {
        const _WIDTH = 76; // Original letter width
        const _HEIGHT = 60; // Original letter height
        const SCALING = 0.75;
        const WIDTH = _WIDTH * SCALING;
        const HEIGHT = _HEIGHT * SCALING;
        const MARGIN = 20;
        this.panel.style.height = `${HEIGHT}px`;
        this.panel.style.margin = `${MARGIN / 2}px 0px`;
        this.letter.style.washColor = `${colour}`;
        this.letter.style.width = `${WIDTH}px`;
        this.letter.style.marginRight = `${MARGIN}px`;
        this.tooltipDummy.style.width = `${WIDTH}px`;
        this.tooltipDummy.style.marginRight = `${MARGIN}px`;
        this.tooltipContainer.style.width = `${WIDTH + MARGIN}px`;
        this.tooltipContainer.style.marginRight = `${MARGIN}px`;
        // Awful hack to centre text while allowing overflow into margin
        (function centre(panel) {
            !panel.actuallayoutwidth
                ? $.Schedule(0.1, () => centre(panel))
                : panel.style.width = `${panel.actuallayoutwidth + 25}px`;
        })(this.panel);
    }
    // Simulates a keyframe with dynamic colouring
    Glow(colour) {
        this.letter.style.boxShadow = `${colour}00 100px 0px 250px 0px`;
        $.Schedule(1, () => {
            this.letter.style.boxShadow = `${colour}60 100px 0px 450px 0px`;
            $.Schedule(1, () => this.letter.style.boxShadow = `${colour}00 100px 0px 250px 0px`);
        });
    }
}
