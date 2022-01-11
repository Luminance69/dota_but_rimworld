type LuaArray<T> = T | Record<number, T>;
type ProblemType = keyof typeof ProblemData;

interface SendIncidentLetterEvent {
    name: string;
    description: string;
    severity: string;
    sounds: LuaArray<string>;
    targets: LuaArray<EntityIndex>;
}

interface UpdateProblemAlarmEvent {
    type: ProblemType;
    targets: LuaArray<EntityIndex>;
    increment: 0 | 1;
}

class UI {
    container: Panel;
    iContainer: Panel;
    pContainer: Panel;
    incidents: Incident[] = [];
    problems: Record<string, Problem> = {};

    constructor(panel: Panel) {
        this.container = panel.FindChild("Container")!;
        this.iContainer = panel.FindChildTraverse("Incidents")!;
        this.pContainer = panel.FindChildTraverse("Problems")!;

        GameEvents.Subscribe<SendIncidentLetterEvent>("send_incident_letter", (event) => this.NewIncident(event));
        GameEvents.Subscribe<UpdateProblemAlarmEvent>("update_problem_alarm", (event) => this.UpdateProblem(event));
        GameEvents.Subscribe<PlayerChatEvent>("player_chat", (event) => this.OnPlayerChat(event));
    }

    // Increment/decrement a problem alarm
    UpdateProblem(event: UpdateProblemAlarmEvent) {
        const [name, description, targets, major] = this.ConstructProblem(event);

        this.problems[event.type]
        ? this.problems[event.type].UpdateTargets(targets, Boolean(event.increment))
        : this.problems[event.type] = new Problem(
            this.pContainer,
            name,
            description,
            targets,
            major,
        );
    }

    ConstructProblem(event: UpdateProblemAlarmEvent): [string, string, EntityIndex[], boolean] {
        const data = ProblemData[event.type];
        const targets = ParseLuaArray(event.targets);
        const n = targets.length;

        // Replace all enumerators in name
        let name = "";
        n > 1
        ? name = data.name.replace(/{xn}/g, ` x${n}`)
        : name = data.name.replace(/{xn}/g, "");
        name = name.replace(/{n}/g, `${n}`);

        // Replace placeholders and duplicate repeatable string for each target
        const repeat: Record<number, string> = data.description.repeat;
        let concat: Record<number, string> = {};
        for (const k in repeat) {
            concat[k] = "";
            targets.forEach(t =>
                concat[k] += repeat[k].replace(/{t}/g, $.Localize(Entities.GetUnitName(t)))
            );
        }

        // Combine updated strings
        let main = data.description.main;
        Object.assign(main, concat);
        const description = Object.values(main).join("");

        return [name, description, targets, data.major];
    }

    // Create a new incident letter
    NewIncident(event: SendIncidentLetterEvent) {
        const inc = new Incident(
            this.iContainer,
            event.name,
            event.description,
            event.severity,
            ParseLuaArray(event.targets),
        );

        this.incidents.push(inc);
        ParseLuaArray(event.sounds).forEach(s => Game.EmitSound(s));
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
                this.UpdateProblem({
                    type: args[1] as ProblemType || "MajorBreak" as ProblemType,
                    targets:
                        args[2]
                        ? args[2].split(" ").reduce((o,v,i) => (Object.assign(o, {[i]: Entities.GetAllEntitiesByName("npc_dota_hero_"+v)[0]})), {})
                        : Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()),
                    increment: Number(args[3] || 1) as 0|1,
                });
                $.Msg("Added new problem: " + args[1])
                break;

            // Clear all events
            case "?clear":
                this.incidents = [];
                this.problems = {};
                this.iContainer.RemoveAndDeleteChildren();
                this.pContainer.RemoveAndDeleteChildren();

                $.Msg("Cleared all events");
                break;
        }
    }
}

let ui = new UI($.GetContextPanel());
