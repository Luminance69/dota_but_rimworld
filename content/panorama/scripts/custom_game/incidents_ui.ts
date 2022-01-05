class UI {
    container: Panel;
    incidents: Incident[] = [];

    constructor(panel: Panel) {
        $.Msg("UI loaded!", panel);

        this.container = panel.FindChild("Incidents")!;

        GameEvents.Subscribe<PlayerChatEvent>("player_chat", (event) => this.OnPlayerChat(event));
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
                this.incidents.push(new Incident(this.container, severity, name));

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
