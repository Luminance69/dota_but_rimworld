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
        color: "#E0864F",
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
    CreepDisease:
    {
        name: "Creep Disease",
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
        name: "Gift From {Patron}",
        severity: IncidentSeverity.Good,
        description:
        {
            main:
            {
                0: "Benefactors from <span color='#01b8f5'>{patron}</span> have left you a gift:<br>",
                1: "<br>&nbsp;&nbsp;- {gold} gold.",
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
                2: "<br>&nbsp;&nbsp;- <span color='#bf8f5b'>{t}</span>",
            },
        },
    },

    SolarEclipse:
    {
        name: "Solar Eclipse",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: "A rogue moon has passed in front of your sun, causing the battlefield to be engulfed in darkness for a short time.",
            },
            repeat: {},
        },
    },

    MadNeutral:
    {
        name: "Mad {T}",
        severity: IncidentSeverity.Bad,
        description:
        {
            main:
            {
                0: "A local {t} has gone mad. It will attack everyone it sees.",
            },
            repeat: {},
        },
    },

    MadNeutralAncient:
    {
        name: "Mad {T}",
        severity: IncidentSeverity.Special,
        description:
        {
            main:
            {
                0: "A local {t} has gone mad. It will attack everyone it sees.",
            },
            repeat: {},
        },
    },

    MassNeutralInsanity:
    {
        name: "Mad Neutrals ({xn})",
        severity: IncidentSeverity.MassInsanity,
        description:
        {
            main:
            {
                0: "Some sort of psychic wave has swept over the landscape. Your heroes are okay, but...",
                1: "<br><br>It seems many of the neutrals in the area have been driven insane.",
            },
            repeat: {},
        },
    },

    PsychicDrone:
    {
        name: "Psychic Drone: {Intensity} ({Gender})",
        severity: IncidentSeverity.PsychicDrone,
        description:
        {
            main:
            {
                0: "Every {gender} hero feels a wave of anxiety and anger!",
                1: "<br><br>Some distant engine of hatred is stirring. It is projecting a psychic drone onto this battlefield through an orbital amplifier, tuned to only affect {gender}s. For a few days, some people's mood will be quite a bit worse.",
                2: "<br><br>The drone level is {intensity}.",
            },
            repeat: {},
        },
    },

    PsychicSoothe:
    {
        name: "Psychic Soothe: {Gender}",
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

    AllyZzztt:
    {
        name: "Zzztt...",
        severity: IncidentSeverity.Bad,
        description:
        {
            main:
            {
                0: "One of your towers has had a short circuit, probably because fUCKing DAVE LEFT IT OUT IN THE RAIN.",
                1: "<br><br>All {power} Wd of energy stored in the tower has been discharged in an explosion.",
            },
            repeat: {},
        },
    },

    EnemyZzztt:
    {
        name: "Zzztt...",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: "One of the enemy towers has had a short circuit.",
                1: "<br><br>All {power} Wd of energy stored in the tower has been discharged in an explosion.",
            },
            repeat: {},
        },
    },
    
    ColdSnap:
    {
        name: "Cold Snap",
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
    
    HeatWave:
    {
        name: "Heat Wave",
        severity: IncidentSeverity.Special,
        description:
        {
            main:
            {
                0: "An unusual heat wave has set in.",
                1: "<br><br>Heat waves can quickly kill by heatstroke. Be sure to stay cool by seeking shelter near your buildings and Ancient.",
            },
            repeat: {},
        },
    },

    CargoPod:
    {
        name: "Cargo Pods ({item_type})",
        severity: IncidentSeverity.Good,
        description:
        {
            main:
            {
                0: "Cargo pods from a passing ship has crashed to the ground.",
            },
            repeat: {},
        },
    },

    DeathDeny:
    {
        name: "Death: {T}",
        severity: IncidentSeverity.Neutral,
        description:
        {
            main:
            {
                0: "{T} was denied.<br>Alexa, play Despacito 2.",
            },
            repeat: {},
        },
    },

    Death:
    {
        name: "Death: {T}",
        severity: IncidentSeverity.Bad,
        description:
        {
            main:
            {
                0: "{T} has died at the hands of the enemy.",
            },
            repeat: {},
        },
    },

    BirthdayBad:
    {
        name: "Birthday",
        severity: IncidentSeverity.Bad,
        description:
        {
            main:
            {
                0: "{T} has reached the biological age of {age}.",
                1: "<br><br>Unfortunately, {T} has gained the following illness due to aging:",
                2: "<br>&nbsp;&nbsp;- {illness}",
            },
            repeat: {},
        },
    },

    BirthdayGift:
    {
        name: "Birthday",
        severity: IncidentSeverity.Good,
        description:
        {
            main:
            {
                0: "{T} has reached the biological age of {age}.",
                1: "<br><br>{T} has received a gift of {gold} gold.",
            },
            repeat: {},
        },
    },

    BirthdayWisdom:
    {
        name: "Birthday",
        severity: IncidentSeverity.Good,
        description:
        {
            main:
            {
                0: "{T} has reached the biological age of {age}.",
                1: "<br><br>{T} has become wise with age, and gained {exp} xp.",
            },
            repeat: {},
        },
    },

    BirthdayHeartAttack:
    {
        name: "Heart Attack!",
        severity: IncidentSeverity.Threat,
        description:
        {
            main:
            {
                0: "{T} is having a heart attack!",
                1: "<br>Get them a healing salve quickly or they may die.",
            },
            repeat: {},
        },
    },
};
