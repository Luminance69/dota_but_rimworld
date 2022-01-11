// No json import allowed by default ;;;;;
const ProblemData =
{
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
        major: true,
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
        major: false,
    },
}
