const IncidentSeverity =
{
    Good:
    {
        color: "#79afdb",
        sounds: ["LetterArriveGood"],
        tGlow: 90,
    },

    Neutral:
    {
        color: "#ffffff",
        sounds: ["LetterArrive"],
        tGlow: 90,
    },

    Bad:
    {
        color: "#ccc47f",
        sounds: ["LetterArriveBadUrgentSmall"],
        tGlow: 15,
    },

    Threat:
    {
        color: "#ca7471",
        sounds: ["LetterArriveBadUrgentBig"],
        tGlow: 6,
        tBounce: 5,
    },

    Special:
    {
        color: "#cc9b7d",
        sounds: ["LetterArriveBadUrgent"],
        tGlow: 15,
        tBounce: 5,
    },
};

const IncidentTypes =
{
    ColdSnap:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },

    CreepDisease:
    {
        name: "Creep Disease",
        severity: IncidentSeverity.Bad,
        description:
        {
            main:
            {
                0: "Many of your creeps have been infected with a deadly illness."
            },
            repeat: {},
        },
    },

    Gift:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },

    HeroSickness:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },

    InvertDay:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },

    MadNeutral:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },

    MassNeutralInsanity:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },

    PsychicDrone:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },

    PsychicSoothe:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },

    Zzztt:
    {
        name: "",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: ""
            },
            repeat: {},
        },
    },
};
