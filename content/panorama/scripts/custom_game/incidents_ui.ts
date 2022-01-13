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

        GameEvents.Subscribe<SendIncidentLetterEvent>("send_incident_letter", (event) => this.NewIncident(event));
        GameEvents.Subscribe<UpdateProblemAlarmEvent>("update_problem_alarm", (event) => this.UpdateProblem(event));
        GameEvents.Subscribe<PlayerChatEvent>("player_chat", (event) => this.OnPlayerChat(event));
    }

    // Increment/decrement a problem alarm
    UpdateProblem(event: UpdateProblemAlarmEvent) {
        const problem = this.problems[event.type];

        if (problem) {
            const old = problem.targets;
            const [name, description, targets, major] = this.ConstructProblem(event, old);
            problem.UpdateTargets(
                name,
                description,
                targets,
                major,
            );
        } else {
            const [name, description, targets, major] = this.ConstructProblem(event);
            this.problems[event.type] = new Problem(
                major ? this.pMajor : this.pMinor,
                event.type,
                name,
                description,
                targets,
                major,
            );
        };
    }

    ConstructProblem(event: UpdateProblemAlarmEvent, oldTargets?: EntityIndex[]): [string, string, EntityIndex[], boolean] {
        const data = ProblemData[event.type];
        let targets = ParseLuaArray(event.targets);

        // Increment/decrement targets
        if (oldTargets) {
            event.increment
            ? targets = oldTargets.concat(targets)
            : targets = oldTargets.filter(t => !targets.includes(t));
        };

        // Replace all enumerators in name
        let name = "";
        const n = targets.length;
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
        let description = Object.values(main).join("");
        description += "<br><br>(Click to jump to problem)";

        return [name, description, targets, Boolean(event.major)];
    }

    // Remove and cleanup problem alarm
    DeleteProblem(problem: Problem) {
        delete this.problems[problem.type];
        problem.panel.DeleteAsync(0);
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
    DeleteIncident(incident: Incident) {
        this.incidents.splice(this.incidents.indexOf(incident), 1);
        incident.panel.DeleteAsync(0);
    }

    // Debug commands
    OnPlayerChat(event: PlayerChatEvent) {
        if (!event.text.startsWith("?")) return;

        const args = ParseChatArgs(event.text);
        switch(args[0]) {
            // Add a new incident
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
