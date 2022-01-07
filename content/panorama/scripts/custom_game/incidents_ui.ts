interface SendIncidentLetterEvent {
    name: string;
    description: string;
    severity: string;
    target: EntityIndex;
}

class UI {
    container: Panel;
    incidents: Incident[] = [];

    constructor(panel: Panel) {
        $.Msg("UI loaded!", panel);

        this.container = panel.FindChild("Incidents")!;

        GameEvents.Subscribe<SendIncidentLetterEvent>("send_incident_letter", (event) => this.New(event));
        GameEvents.Subscribe<PlayerChatEvent>("player_chat", (event) => this.OnPlayerChat(event));
    }

    // Create a new incident letter
    New(event: SendIncidentLetterEvent) {
        const inc = new Incident(
            this.container,
            event.name,
            event.description,
            event.severity,
            event.target,
        );

        this.incidents.push(inc);
    }

    // Remove and cleanup incident notifications
    Delete(incident: Incident) {
        this.incidents.splice(this.incidents.indexOf(incident), 1);
        incident.panel.DeleteAsync(0);
    }

    OnPlayerChat(event: PlayerChatEvent) {
        if (!event.text.startsWith("?")) return;

        const args = event.text.split(" ");
        switch(args[0]) {
            // Add a new event
            case "?event":
                const severity = args[1];
                const name = args.slice(2).join(" ");
                this.incidents.push(new Incident(
                    this.container,
                    name,
                    "description",
                    severity,
                    Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
                ));

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
