import Constructors
import HTML
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
        listFlow,
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
            let table =
                fixture()

            let output =
                try proveComponentOutputProviding(
                    table
                )

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

    static let listFlow = TestFlow(
        "markup.list",
        title: "Generic ordered and unordered semantic lists",
        tags: ["markup", "list", "html", "component", "regression"]
    ) {
        Step("unordered list retains semantic HTML without dependencies") {
            let list = Markup.List(items: ["Alpha", "Beta"])
            let output = try proveComponentOutputProviding(list)
            try proveReusable(list)

            let html = output.content.body.snippet()
            try Expect.equal(html.contains("<ul"), true, "markup.list.unordered")
            try Expect.equal(html.contains("<li"), true, "markup.list.items")
            try Expect.equal(html.contains("Alpha"), true, "markup.list.text")
            try Expect.equal(output.dependencies.styles.contributions.count, 0, "markup.list.no-styles")
            try Expect.equal(output.dependencies.scripts.contributions.count, 0, "markup.list.no-scripts")
            try Expect.equal(list.nodes.body.count, output.content.body.count, "markup.list.compatibility")
        }

        Step("ordered and empty lists retain their container kind") {
            let ordered = Markup.List(items: ["First", "Second"], kind: .ordered)
            let empty = Markup.List(items: [])

            try Expect.equal(ordered.output.content.body.snippet().contains("<ol"), true, "markup.list.ordered")
            try Expect.equal(empty.output.content.body.snippet().contains("<ul"), true, "markup.list.empty")
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

private func proveComponentOutputProviding<Component>(
    _ component:
        Component
) throws -> ComponentOutput
where
    Component:
        ComponentOutputProviding
{
    try Expect.equal(
        component.output.dependencies.scripts.contributions.count,
        0,
        "markup.component-output-providing.no-scripts"
    )

    return component.output
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
