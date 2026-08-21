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
            "Generic table contributes HTML and CSS without browser behavior",
        tags: [
            "markup",
            "table",
            "html",
            "css",
            "component",
            "regression",
        ]
    ) {
        Step(
            "table satisfies ReusableComponent"
        ) {
            let table =
                fixture()

            try proveReusable(
                table
            )
        }

        Step(
            "table contributes body and stylesheet without scripts"
        ) {
            let nodes =
                fixture()
                    .nodes

            try Expect.equal(
                nodes.body.count,
                1,
                "markup.table.body-count"
            )

            try Expect.equal(
                nodes.stylesheets.count,
                1,
                "markup.table.stylesheet-count"
            )

            try Expect.equal(
                nodes.scripts.count,
                0,
                "markup.table.script-count"
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
