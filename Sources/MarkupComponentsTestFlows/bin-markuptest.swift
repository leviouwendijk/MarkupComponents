import Constructors
import MarkupComponents
import TestFlows

@main
enum MarkupComponentsFlowTestMain {
    static func main() async {
        await TestFlowCLI.run(
            suite:
                MarkupComponentsFlowSuite.self
        )
    }
}

enum MarkupComponentsFlowSuite:
    TestFlowRegistry
{
    static let title =
        "MarkupComponents flows"

    static let flows: [TestFlow] = [
        tableFlow,
    ]

    static let tableFlow = TestFlow(
        "markup.table",
        title:
            "Generic table retains semantic HTML and identified CSS without browser behavior",
        tags: [
            "markup",
            "table",
            "html",
            "css",
            "component",
            "semantic",
            "regression",
        ]
    ) {
        Step(
            "semantic output owns HTML and identified CSS without scripts"
        ) {
            let output =
                fixture()
                    .output

            try Expect.equal(
                output.content.body.count,
                1,
                "markup.table.output.body-count"
            )

            try Expect.equal(
                output.dependencies.styles.contributions.count,
                1,
                "markup.table.output.style-contribution-count"
            )

            try Expect.equal(
                output.dependencies.styles.contributions[0]
                    .identifier.rawValue,
                "markup.table.styles",
                "markup.table.output.style-identity"
            )

            try Expect.equal(
                output.dependencies.scripts.contributions.count,
                0,
                "markup.table.output.script-contribution-count"
            )

            try Expect.equal(
                output.dependencies.styles.contributions[0]
                    .content.sheet,
                Markup.Table.stylesheet(),
                "markup.table.output.stylesheet-compatibility"
            )
        }

        Step(
            "legacy ReusableComponent view remains derived-compatible"
        ) {
            let table =
                fixture()

            try proveReusable(
                table
            )

            let nodes =
                table.nodes

            try Expect.equal(
                nodes.body.count,
                table.output.content.body.count,
                "markup.table.compatibility.body-count"
            )

            try Expect.equal(
                nodes.stylesheets.count,
                1,
                "markup.table.compatibility.stylesheet-count"
            )

            try Expect.equal(
                nodes.scripts.count,
                0,
                "markup.table.compatibility.script-count"
            )
        }
    }

    private static func fixture()
        -> Markup.Table
    {
        Markup.Table(
            columns: [
                .init(
                    "Omschrijving"
                ),
                .init(
                    "Bedrag",
                    alignment:
                        .trailing
                ),
            ],
            rows: [
                .init(
                    [
                        "Gedragsbegeleiding",
                        "€ 250,00",
                    ]
                ),
                .init(
                    [
                        "Btw",
                        "€ 43,39",
                    ]
                ),
            ]
        )
    }
}

private func proveReusable<Component>(
    _ component: Component
) throws
where
    Component:
        ReusableComponent
{
    try Expect.equal(
        component.nodes.scripts.count,
        0,
        "markup.reusable-component.no-scripts"
    )
}
