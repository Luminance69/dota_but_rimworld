interface SendIncidentLetterEvent {
    name: string;
    description: string;
    severity: string;
    sounds: string | Record<number, string>;
    targets: EntityIndex | Record<number, EntityIndex>;
}

class UI {
    container: Panel;
    iContainer: Panel;
    pContainer: Panel;
    incidents: Incident[] = [];
    problems: Problem[] = [];

    constructor(panel: Panel) {
        this.container = panel.FindChild("Container")!;
        this.iContainer = panel.FindChildTraverse("Incidents")!;
        this.pContainer = panel.FindChildTraverse("Problems")!;

        GameEvents.Subscribe<SendIncidentLetterEvent>("send_incident_letter", (event) => this.NewIncident(event));
        GameEvents.Subscribe<PlayerChatEvent>("player_chat", (event) => this.OnPlayerChat(event));
    }

    // Create a new problem alarm
    NewProblem(name: string) {
        this.problems.push(new Problem(this.pContainer, name))
    }

    // Create a new incident letter
    NewIncident(event: SendIncidentLetterEvent) {
        const inc = new Incident(
            this.iContainer,
            event.name,
            event.description,
            event.severity,
            ParseLuaArray<EntityIndex>(event.targets),
        );

        this.incidents.push(inc);
        ParseLuaArray<string>(event.sounds).forEach(s => Game.EmitSound(s));
    }

    // Remove and cleanup incident letter
    Delete(incident: Incident) {
        this.incidents.splice(this.incidents.indexOf(incident), 1);
        incident.panel.DeleteAsync(0);
    }

    OnPlayerChat(event: PlayerChatEvent) {
        if (!event.text.startsWith("?")) return;

        const args = ParseChatArgs(event.text);
        switch(args[0]) {
            // Add a new event
            case "?incident":
                this.NewIncident({
                    name: args[1] || "Siege",
                    description: args[2] || "A group of pirates from The Mantiss of Oppression have arrived nearby.<br><br>It looks like they want to besiege the colony and pound you with mortars from a distance. You can try to wait them out - or go get them.",
                    severity: args[3] || "#ca7471",
                    sounds: args[4] || "LetterArriveBadUrgentBig",
                    targets:
                        args[5]
                        ? args[5].split(" ").reduce((o,v,i) => (Object.assign(o, {[i]: Entities.GetAllEntitiesByName("npc_dota_hero_"+v)[0]})), {})
                        : Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()),
                });

                $.Msg("Added new incident: " + args[1]);
                break;

            case "?problem":
                this.NewProblem(args[1]);
                $.Msg("Added new problem: " + args[1])
                break;

            // Clear all events
            case "?clear":
                this.incidents = [];
                this.problems = []
                this.iContainer.RemoveAndDeleteChildren();
                this.pContainer.RemoveAndDeleteChildren();

                $.Msg("Cleared all events");
                break;
        }
    }
}

let ui = new UI($.GetContextPanel());
