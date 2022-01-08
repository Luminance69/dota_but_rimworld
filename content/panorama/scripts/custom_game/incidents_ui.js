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
        const inc = new Incident(this.container, event.name, event.description, event.severity, event.target);
        this.incidents.push(inc);
        Game.EmitSound(event.sound);
    }
    // Remove and cleanup incident notifications
    Delete(incident) {
        this.incidents.splice(this.incidents.indexOf(incident), 1);
        incident.panel.DeleteAsync(0);
    }
    OnPlayerChat(event) {
        if (!event.text.startsWith("?"))
            return;
        const args = event.text.split(" ");
        switch (args[0]) {
            // Add a new event
            case "?event":
                const severity = args[1];
                const name = args.slice(2).join(" ");
                this.New({
                    name: name,
                    description: "Default description.",
                    severity: severity,
                    sound: "LetterArriveBadUrgentBig",
                    target: Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()),
                });
                $.Msg("Added new incident: " + name);
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
