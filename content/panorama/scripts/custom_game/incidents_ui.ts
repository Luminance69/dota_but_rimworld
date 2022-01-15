type LuaArray<T> = T | Record<number, T>;

// I feel like I don't need all of these types...
type ProblemType = keyof typeof ProblemTypes;
type IncidentType = keyof typeof IncidentTypes;

type Severity = {
    color: string,
    sounds: string[],
    tGlow: number,
    tBounce?: number,
}

type Description = {
    main: Partial<Record<number, string>>
    repeat: Partial<Record<number, string>>
}

interface SendIncidentLetterEvent {
    type: IncidentType;
    targets: LuaArray<EntityIndex>;
    special?: Record<string, string>;
}

interface UpdateProblemAlarmEvent {
    type: ProblemType;
    targets: LuaArray<EntityIndex>;
    major: 0 | 1;
    increment: 0 | 1;
}

class UI {
    container: Panel;
    iContainer: Panel;
    pMajor: Panel;
    pMinor: Panel;
    incidents: Incident[] = [];
    problems: Record<string, Problem> = {};

    constructor(panel: Panel) {
        this.container = panel.FindChild("Container")!;
        this.iContainer = panel.FindChildTraverse("Incidents")!;
        this.pMajor = panel.FindChildTraverse("Major")!;
        this.pMinor = panel.FindChildTraverse("Minor")!;

        GameEvents.Subscribe<SendIncidentLetterEvent>("send_incident_letter", event => this.NewIncident(event));
        GameEvents.Subscribe<UpdateProblemAlarmEvent>("update_problem_alarm", event => this.UpdateProblem(event));
        GameEvents.Subscribe<PlayerChatEvent>("player_chat", event => this.OnPlayerChat(event));
    }

    // Increment/decrement a problem alarm
    UpdateProblem(event: UpdateProblemAlarmEvent) {
        const problem = this.problems[event.type];
        const data = ProblemTypes[event.type];
        let targets = ParseLuaArray(event.targets);

        if (problem) {
            // Increment/decrement targets
            event.increment
            ? targets = problem.targets.concat(targets)
            : targets = problem.targets.filter(t => !targets.includes(t));

            let [name, description] = this.ConstructData(
                data.name, data.description, targets);
            description += "<br><br>(Click to jump to problem)";

            problem.UpdateTargets(
                event.major ? this.pMajor : this.pMinor,
                name,
                description,
                targets,
            );
        } else {
            let [name, description] = this.ConstructData(
                data.name, data.description, targets);
            description += "<br><br>(Click to jump to problem)";

            this.problems[event.type] = new Problem(
                event.major ? this.pMajor : this.pMinor,
                event.type,
                name,
                description,
                targets,
            );
        };
    }

    // Remove and cleanup problem alarm
    DeleteProblem(problem: Problem) {
        delete this.problems[problem.type];
        problem.panel.DeleteAsync(0);
    }

    // Create a new incident letter
    NewIncident(event: SendIncidentLetterEvent) {
        const data = IncidentTypes[event.type];
        const targets = ParseLuaArray(event.targets);
        const [name, description] = this.ConstructData(
            data.name, data.description, targets, event.special);

        const inc = new Incident(
            this.iContainer,
            name,
            description,
            data.severity,
            targets,
        );

        this.incidents.push(inc);
        data.severity.sounds.forEach(s => Game.EmitSound(s));
    }

    // Remove and cleanup incident letter
    DeleteIncident(incident: Incident) {
        this.incidents.splice(this.incidents.indexOf(incident), 1);
        incident.panel.DeleteAsync(0);
    }

    ConstructData(name: string, description: Description, targets: EntityIndex[], special?: Record<string, string> | undefined): string[] {
        const localised = targets.map(t => $.Localize(Entities.GetUnitName(t)));
        const n = targets.length;
        const regex: Record<string, string> = {n: String(n), t: localised[0]};
        Object.assign(regex, special);

        // Replace x-type enumerators in name
        n > 1
        ? name = name.replace(/{xn}/g, ` x${n}`)
        : name = name.replace(/{xn}/g, "");

        // Replace placeholders and duplicate repeatable string for each target
        let repeat: Record<number, string> = {};
        for (const k in description.repeat) {
            repeat[k] = "";
            localised.forEach(t =>
                repeat[k] += description.repeat[k]!.replace(/{t}/g, t)
            );
        };

        // Combine updated strings
        Object.assign(description.main, repeat);
        let combined = Object.values(description.main).join("");

        // Replace any dangling or special placeholders
        for (const e in regex) {
            const lower = new RegExp(`{${e}}`, "g");
            name = name.replace(lower, regex[e]);
            combined = combined.replace(lower, regex[e]);

            const upper = new RegExp(`{${Capitalise(e)}}`, "g")
            name = name.replace(upper, Capitalise(regex[e]));
            combined = combined.replace(upper, Capitalise(regex[e]));
        };

        return [name, combined];
    }

    // Debug commands
    OnPlayerChat(event: PlayerChatEvent) {
        if (!event.text.startsWith("?")) return;

        const args = ParseChatArgs(event.text);
        switch(args[0]) {
            // Add a new incident
            case "?incident":
                this.NewIncident({
                    type: args[1] as IncidentType || "CreepDisease",
                    targets:
                        args[2]
                        ? args[2].split(" ").reduce((o,v,i) => (Object.assign(o, {[i]: Entities.GetAllEntitiesByName("npc_dota_hero_"+v)[0]})), {})
                        : Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()),
                    special: {},
                });

                $.Msg("Added new incident: " + args[1]);
                break;

            // Update a problem
            case "?problem":
                this.UpdateProblem({
                    type: args[1] as ProblemType || "MajorBreak" as ProblemType,
                    targets:
                        args[2]
                        ? args[2].split(" ").reduce((o,v,i) => (Object.assign(o, {[i]: Entities.GetAllEntitiesByName("npc_dota_hero_"+v)[0]})), {})
                        : Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()),
                    major: Number(args[3] || 1) as 0|1,
                    increment: Number(args[4] || 1) as 0|1,
                });
                $.Msg("Added new problem: " + args[1])
                break;

            // Clear all incidents and problems
            case "?clear":
                this.incidents = [];
                this.problems = {};
                this.iContainer.RemoveAndDeleteChildren();
                this.pMajor.RemoveAndDeleteChildren();
                this.pMinor.RemoveAndDeleteChildren();

                $.Msg("Cleared all events");
                break;
        }
    }
}

const ui = new UI($.GetContextPanel());
// Display UI under the shop by setting the context panel's parent to the HUD
$.GetContextPanel().SetParent($.GetContextPanel().GetParent()!.GetParent()!.GetParent()!.FindChild("HUDElements")!);
