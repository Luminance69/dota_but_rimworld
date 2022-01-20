type LuaArray<T> = Record<number, T>;
type EventArray<T> = T | LuaArray<T>;

// I feel like I don't need all of these types...
type ProblemType = keyof typeof ProblemTypes;
type IncidentType = keyof typeof IncidentTypes;
type Severity = typeof IncidentSeverity[keyof typeof IncidentSeverity];
type Description = {main: LuaArray<string>, repeat: LuaArray<string>};

interface SendIncidentLetterEvent {
    type: IncidentType;
    targets: EventArray<EntityIndex>;
    special?: {
        main?: Record<string, string>,
        repeat?: Record<string, EventArray<string>>,
    }
}

interface UpdateProblemAlarmEvent {
    type: ProblemType;
    targets: EventArray<EntityIndex>;
    major: 0 | 1;
    increment: 0 | 1;
}

class UI {
    container: Panel;
    iContainer: Panel;
    pMajor: Panel;
    pMinor: Panel;
    forecast: LabelPanel;
    date: LabelPanel;
    incidents: Incident[] = [];
    problems: Record<string, Problem> = {};

    constructor(panel: Panel) {
        this.container = panel.FindChild("Container")!;
        this.iContainer = panel.FindChildTraverse("Incidents")!;
        this.pMajor = panel.FindChildTraverse("Major")!;
        this.pMinor = panel.FindChildTraverse("Minor")!;
        this.forecast = panel.FindChildTraverse("Forecast") as LabelPanel;
        this.date = panel.FindChildTraverse("Date") as LabelPanel;

        GameEvents.Subscribe<SendIncidentLetterEvent>("send_incident_letter", event => this.NewIncident(event));
        GameEvents.Subscribe<UpdateProblemAlarmEvent>("update_problem_alarm", event => this.UpdateProblem(event));
        GameEvents.Subscribe<PlayerChatEvent>("player_chat", event => this.OnPlayerChat(event));

        // UI forecast
        this.forecast.text = "Clear 30C";
        this.forecast.SetPanelEvent("onmouseover", () => {
            // Create tooltip after delay
            const id = $.Schedule(0.5, () => {
                const tooltip = CreateSmallTooltip(this.forecast, "A clear day. No penalties or modifiers.", -1, 1);
                this.forecast.SetPanelEvent("onmouseout", () => tooltip.DeleteAsync(0));
            });
            this.forecast.SetPanelEvent("onmouseout", () => $.CancelScheduled(id));
        });

        // UI date and time
        (function UpdateTime(date) {
            date.text = `${Math.floor((Game.GetDOTATime(false, false)+150) % 600 / 25)}h<br>Spring, 5500`;
            $.Schedule(1, () => UpdateTime(date));
        })(this.date);

        this.date.SetPanelEvent("onmouseover", () => {
            // Create tooltip after delay
            const id = $.Schedule(0.5, () => {
                const tooltip = CreateSmallTooltip(this.date, "Days passed since your arrival: 5<br>Current quadrum: Aprimay<br>Local season: Spring", -1, -1);
                this.date.SetPanelEvent("onmouseout", () => tooltip.DeleteAsync(0));
            });
            this.date.SetPanelEvent("onmouseout", () => $.CancelScheduled(id));
        });
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

    // TODO: Stop the function input being so long...
    ConstructData(name: string, description: Description, targets: EntityIndex[], special?: SendIncidentLetterEvent["special"]): string[] {
        const loc = targets.map(t => $.Localize(Entities.GetUnitName(t)));
        const n = targets.length;

        // Replace x-type enumerators in name
        n > 1
        ? name = name.replace(/{xn}/g, ` x${n}`)
        : name = name.replace(/{xn}/g, "");

        // Replace placeholders and duplicate repeatable strings
        const regexRepeat: Record<string, LuaArray<string>> = {t: loc};
        if (special) Object.assign(regexRepeat, special.repeat);

        let repeated: Record<number, string> = {};
        for (const k in description.repeat) {
            // Match the first {} and use it as the iterable
            repeated[k] = "";
            const match = description.repeat[k]!.match(/{\w+}/)![0];
            const array = ParseLuaArray(regexRepeat[match.slice(1,-1)]);

            array.forEach(a =>
                repeated[k] += description.repeat[k]!.replace(match, a)
            );
        };

        // Combine updated strings
        Object.assign(description.main, repeated);
        let combined = Object.values(description.main).join("");

        // Replace any baked and special placeholders
        const regexMain: Record<string, string> = {n: String(n), t: loc[0]};
        if (special) Object.assign(regexMain, special.main);

        for (const e in regexMain) {
            const lower = new RegExp(`{${e}}`, "g");
            name = name.replace(lower, regexMain[e]);
            combined = combined.replace(lower, regexMain[e]);

            const upper = new RegExp(`{${Capitalise(e)}}`, "g")
            name = name.replace(upper, Capitalise(regexMain[e]));
            combined = combined.replace(upper, Capitalise(regexMain[e]));
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
                    type:
                        args[1] as IncidentType || "CreepDisease",
                    targets:
                        args[2]
                        ? args[2].split(" ").reduce((o,v,i) => (Object.assign(o, {[i]: Entities.GetAllEntitiesByName("npc_dota_hero_"+v)[0]})), {})
                        : Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()),
                    special: {
                        main: {patron: "The Masked Ones", tier: "low", gender:"female"},
                        repeat: {gift: {0: "Tangoes x16", 1: "Divine rapier", 2: "Vitality booster"}},
                    },
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
if (!($.GetContextPanel().GetParent()!.id === "HUDElements"))
    $.GetContextPanel().SetParent($.GetContextPanel().GetParent()!.GetParent()!.GetParent()!.FindChild("HUDElements")!);
