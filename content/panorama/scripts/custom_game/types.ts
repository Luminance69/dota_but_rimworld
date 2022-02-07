// Probably bloated

type LuaArray<T> = Record<number, T>;
type EventArray<T> = T | LuaArray<T>;

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
