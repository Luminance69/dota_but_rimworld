"use strict";
class UI {
    constructor(panel) {
        this.incidents = [];
        this.container = panel.FindChild("Incidents");
        GameEvents.Subscribe("send_incident_letter", (event) => this.New(event));
        GameEvents.Subscribe("player_chat", (event) => this.OnPlayerChat(event));
    }
    // Create a new incident letter
    New(event) {
        const inc = new Incident(this.container, event.name, event.description, event.severity, ParseLuaArray(event.targets));
        this.incidents.push(inc);
        ParseLuaArray(event.sounds).forEach(s => Game.EmitSound(s));
    }
    // Remove and cleanup incident letter
    Delete(incident) {
        this.incidents.splice(this.incidents.indexOf(incident), 1);
        incident.panel.DeleteAsync(0);
    }
    OnPlayerChat(event) {
        if (!event.text.startsWith("?"))
            return;
        const args = ParseChatArgs(event.text);
        switch (args[0]) {
            // Add a new event
            case "?incident":
                this.New({
                    name: args[1] || "Siege",
                    description: args[2] || "A group of pirates from The Mantiss of Oppression have arrived nearby.<br><br>It looks like they want to besiege the colony and pound you with mortars from a distance. You can try to wait them out - or go get them.",
                    severity: args[3] || "#ca7471",
                    sounds: args[4] || "LetterArriveBadUrgentBig",
                    targets: args[5]
                        ? args[5].split(" ").reduce((o, v, i) => (Object.assign(o, { [i]: Entities.GetAllEntitiesByName("npc_dota_hero_" + v)[0] })), {})
                        : Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()),
                });
                $.Msg("Added new incident: " + args[1]);
                break;
            // Clear all events
            case "?clear":
                this.incidents = [];
                this.container.RemoveAndDeleteChildren();
                $.Msg("Cleared all events");
                break;
        }
    }
}
let ui = new UI($.GetContextPanel());
