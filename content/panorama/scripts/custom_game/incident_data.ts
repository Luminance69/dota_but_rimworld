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

    PsychicSoothe:
    {
        color: "#79afdb",
        sounds: ["LetterArriveGood", "PsychicSoothe"],
        tGlow: 90,
    },

    PsychicDrone:
    {
        color: "#ccc47f",
        sounds: ["LetterArriveBadUrgentSmall", "PsychicDrone"],
        tGlow: 15,
    },

    MassInsanity:
    {
        color: "#ca7471",
        sounds: ["LetterArriveBadUrgentBig", "PsychicDrone"],
        tGlow: 6,
        tBounce: 5,
    },
};

const IncidentTypes =
{
    ColdSnap:
    {
        name: "Cold snap",
        severity: IncidentSeverity.Special,
        description:
        {
            main:
            {
                0: "An unusual cold snap has set in.",
                1: "<br><br>Cold snaps can quickly kill by hypothermia. Be sure to stay warm by seeking shelter near your buildings and Ancient.",
            },
            repeat: {},
        },
    },

    CreepDisease:
    {
        name: "Creep disease",
        severity: IncidentSeverity.Special,
        description:
        {
            main:
            {
                0: "Many of your creeps have been infected with a deadly illness.",
            },
            repeat: {},
        },
    },

    Gift:
    {
        name: "Gift from {Patron}",
        severity: IncidentSeverity.Good,
        description:
        {
            main:
            {
                0: "Benefactors from <span color='#01b8f5'>{patron}</span> have left you a gift:",
                1: "<br><br>&nbsp;&nbsp;- {gift}",
            },
            repeat: {},
        },
    },

    HeroSickness:
    {
        name: "Disease: {Disease}",
        severity: IncidentSeverity.Bad,
        description:
        {
            main:
            {
                0: "{n} of your heroes have gotten sick from {disease}.",
                1: "<br><br>The following heroes have gotten sick:<br>",
            },
            repeat:
            {
                2: "<br>&nbsp;&nbsp;- <span color: '#bf8f5b'>{t}</span>",
            },
        },
    },

    InvertDay:
    {
        name: "Solar eclipse",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: "A rogue moon has passed in front of your sun, causing the battlefield to be engulfed in darkness for a short time.",
                1: "<br><br>The eclipse is expected to last for {duration} days.",
            },
            repeat: {},
        },
    },

    MadNeutral:
    {
        name: "Mad {neutral}",
        severity: IncidentSeverity.Special,
        description:
        {
            main:
            {
                0: "A local {neutral} has gone mad. It will attack everyone it sees.",
            },
            repeat: {},
        },
    },

    MassNeutralInsanity:
    {
        name: "Mad {neutral}s",
        severity: IncidentSeverity.MassInsanity,
        description:
        {
            main:
            {
                0: "Some sort of psychic wave has swept over the landscape. Your heroes are okay, but...",
                1: "<br><br>It seems many of the {neutral}s in the area have been driven insane.",
            },
            repeat: {},
        },
    },

    PsychicDrone:
    {
        name: "Psychic drone: {Tier} ({gender})",
        severity: IncidentSeverity.PsychicDrone,
        description:
        {
            main:
            {
                0: "Every {gender} hero feels a wave of anxiety and anger!",
                1: "<br><br>Some distant engine of hatred is stirring. It is projecting a psychic drone onto this battlefield through an orbital amplifier, tuned to only affect {gender}s. For a few days, some people's mood will be quite a bit worse.",
                2: "<br><br>The drone level is {tier}.",
            },
            repeat: {},
        },
    },

    PsychicSoothe:
    {
        name: "Psychic soothe: {Gender}",
        severity: IncidentSeverity.PsychicSoothe,
        description:
        {
            main:
            {
                0: "Every {gender} hero smiles with contentment!",
                1: "<br><br>Some distant engine of happiness is stirring. It is projecting a psychic drone onto the battlefield through an orbital amplifier, tuned to only affect {gender}s. For a few days, some people's mood will be quite a bit better.",
            },
            repeat: {},
        },
    },

    Zzztt:
    {
        name: "Zzztt...",
        severity: IncidentSeverity.Bad,
        description:
        {
            main:
            {
                0: "One of your towers has had a short circuit, probably because fUCKing DAVE LEFT IT OUT IN THE RAIN.",
                1: "<br><br>All {power} W of energy stored in the tower has been discharged in a magical explosion.",
                2: "<br><br>Your tower will be out of service while it performs self-repairs, taking increased external damage.",
            },
            repeat: {},
        },
    },
};
