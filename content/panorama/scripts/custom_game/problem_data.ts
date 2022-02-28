// No json import allowed by default ;;;;;
const ProblemTypes =
{
    ExtremeBreak:
    {
        name: "Extreme break risk{xn}",
        description:
        {
            main:
            {
                0: "These heroes are critically stressed and may have an extreme (and possibly violent) mental break at any moment:<br>",
                2: "<br><br>Check these heroes' needs to see what's bothering them.",
            },
            repeat:
            {
                1: "<br>&nbsp;&nbsp;- <span color='#d09b61'>{t}</span>",
            },
        },
    },

    MajorBreak:
    {
        name: "Major break risk{xn}",
        description:
        {
            main:
            {
                0: "These heroes are in a very poor mood and may have a major mental break at any time:<br>",
                2: "<br><br>Check these heroes' needs to see what's bothering them.",
            },
            repeat:
            {
                1: "<br>&nbsp;&nbsp;- <span color='#d09b61'>{t}</span>",
            },
        },
    },

    MinorBreak:
    {
        name: "Minor break risk{xn}",
        description:
        {
            main:
            {
                0: "These heroes are in a poor mood and may have a minor mental break at any time:<br>",
                2: "<br><br>Check these heroes' needs to see what's bothering them.",
            },
            repeat:
            {
                1: "<br>&nbsp;&nbsp;- <span color='#d09b61'>{t}</span>",
            },
        },
    },

    PsychicSoothe_male:
    {
        name: "Psychic Soothe (Male)",
        description:
        {
            main:
            {
                0: "Every male hero smiles with contentment!",
                1: "<br><br>Some distant engine of happiness is stirring. It is projecting a psychic drone onto the battlefield through an orbital amplifier, tuned to only affect males. For a few days, some people's mood will be quite a bit better.",
            },
            repeat: {},
        },
    },

    PsychicSoothe_female:
    {
        name: "Psychic Soothe (Female)",
        description:
        {
            main:
            {
                0: "Every female hero smiles with contentment!",
                1: "<br><br>Some distant engine of happiness is stirring. It is projecting a psychic drone onto the battlefield through an orbital amplifier, tuned to only affect females. For a few days, some people's mood will be quite a bit better.",
            },
            repeat: {},
        },
    },

    PsychicSoothe_neutral:
    {
        name: "Psychic Soothe (Neutral)",
        description:
        {
            main:
            {
                0: "Every gender-nonspecific hero smiles with contentment!",
                1: "<br><br>Some distant engine of happiness is stirring. It is projecting a psychic drone onto the battlefield through an orbital amplifier, tuned to only affect gender-nonspecific heroes. For a few days, some people's mood will be quite a bit better.",
            },
            repeat: {},
        },
    },

    PsychicDrone_male:
    {
        name: "Psychic Drone (Male)",
        description:
        {
            main:
            {
                0: "Every male hero feels a wave of anxiety and anger!",
                1: "<br><br>Some distant engine of hatred is stirring. It is projecting a psychic drone onto this battlefield through an orbital amplifier, tuned to only affect males. For a few days, some people's mood will be quite a bit worse.",
            },
            repeat: {},
        },
    },

    PsychicDrone_female:
    {
        name: "Psychic Drone (Female)",
        description:
        {
            main:
            {
                0: "Every female hero feels a wave of anxiety and anger!",
                1: "<br><br>Some distant engine of hatred is stirring. It is projecting a psychic drone onto this battlefield through an orbital amplifier, tuned to only affect females. For a few days, some people's mood will be quite a bit worse.",
            },
            repeat: {},
        },
    },

    PsychicDrone_neutral:
    {
        name: "Psychic Drone (Neutral)",
        description:
        {
            main:
            {
                0: "Every gender-nonspecific hero feels a wave of anxiety and anger!",
                1: "<br><br>Some distant engine of hatred is stirring. It is projecting a psychic drone onto this battlefield through an orbital amplifier, tuned to only affect gender-nonspecific heroes. For a few days, some people's mood will be quite a bit worse.",
            },
            repeat: {},
        },
    },

    ColdSnap:
    {
        name: "Cold Snap",
        description:
        {
            main:
            {
                0: "A mysterious cold snap has crept into the area.",
                1: "<br><br>Make sure to keep your heroes warm by staying near towers or they may become hypothermic.",
            },
            repeat: {},
        },
    },

    HeatWave:
    {
        name: "Heat Wave",
        description:
        {
            main:
            {
                0: "The sun is being a massive freaking baka",
                1: "<br><br>Make sure to keep your heroes cool by staying near buildings or they may develop heatstroke.",
            },
            repeat: {},
        },
    },

    SolarEclipse:
    {
        name: "Solar Eclipse",
        description:
        {
            main:
            {
                0: "A rogue moon has passed in front of your sun, causing the battlefield to be engulfed in darkness for a short time.",
            },
            repeat: {},
        },
    },
};
