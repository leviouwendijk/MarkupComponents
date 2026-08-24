import Constructors
import CSS
import HTML

extension Markup {
    public struct Table:
        ReusableComponent
    {
        public enum Alignment:
            String,
            Sendable,
            Hashable
        {
            case leading
            case center
            case trailing
        }

        public struct Column:
            Sendable,
            Hashable
        {
            public let title: String
            public let alignment: Alignment

            public init(
                _ title: String,
                alignment: Alignment = .leading
            ) {
                self.title = title
                self.alignment = alignment
            }
        }

        public struct Row:
            Sendable,
            Hashable
        {
            public let cells: [String]

            public init(
                _ cells: [String]
            ) {
                self.cells = cells
            }
        }

        public static let block =
            "markup-table"

        private static let styleContributionIdentifier:
            CSSContributionIdentifier =
                "markup.table.styles"

        public let columns: [Column]
        public let rows: [Row]

        public init(
            columns: [Column],
            rows: [Row]
        ) {
            self.columns = columns
            self.rows = rows
        }

        public var output:
            ComponentOutput
        {
            ComponentOutput(
                content:
                    ComponentContent(
                        body:
                            componentBody
                    ),
                dependencies:
                    ComponentDependencies(
                        styles:
                            CSSContributions(
                                [
                                    Self.styleContribution(),
                                ]
                            )
                    )
            )
        }

        public var nodes:
            ReusableComponentNodes
        {
            .body(
                output.content.body,
                stylesheets: [
                    Self.stylesheet(),
                ]
            )
        }

        private var componentBody:
            HTMLFragment
        {
            [
                HTML.table(
                    [
                        "class":
                            Self.block,
                    ]
                ) {
                    HTML.thead {
                        HTML.tr {
                            for column in columns {
                                HTML.th(
                                    [
                                        "class":
                                            Self.cellClass(
                                                kind:
                                                    "heading",
                                                alignment:
                                                    column.alignment
                                            ),
                                        "scope":
                                            "col",
                                    ]
                                ) {
                                    HTML.text(
                                        column.title
                                    )
                                }
                            }
                        }
                    }

                    HTML.tbody {
                        for row in rows {
                            HTML.tr {
                                for (
                                    index,
                                    value
                                ) in row.cells.enumerated() {
                                    HTML.td(
                                        [
                                            "class":
                                                Self.cellClass(
                                                    kind:
                                                        "cell",
                                                    alignment:
                                                        alignment(
                                                            at: index
                                                        )
                                                ),
                                        ]
                                    ) {
                                        HTML.text(
                                            value
                                        )
                                    }
                                }
                            }
                        }
                    }
                },
            ]
        }

        private func alignment(
            at index: Int
        ) -> Alignment {
            guard columns.indices.contains(
                index
            ) else {
                return .leading
            }

            return columns[index].alignment
        }

        private static func cellClass(
            kind: String,
            alignment: Alignment
        ) -> String {
            [
                "\(block)__\(kind)",
                "\(block)__\(kind)--\(alignment.rawValue)",
            ]
            .joined(
                separator: " "
            )
        }

        private static func styleContribution()
            -> CSSContribution
        {
            CSS.contribution(
                styleContributionIdentifier
            ) {
                CSS.rule(
                    CSSSelector.class(
                        block
                    ),
                    CSS.decl(
                        "width",
                        "100%"
                    ),
                    CSS.decl(
                        "border-collapse",
                        "collapse"
                    ),
                    CSS.decl(
                        "border-spacing",
                        "0"
                    )
                )

                CSS.rule(
                    CSSSelector.class(
                        "\(block)__heading"
                    ),
                    CSS.decl(
                        "padding",
                        "8px 10px"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "1px solid #d8dde3"
                    ),
                    CSS.decl(
                        "font-weight",
                        "600"
                    ),
                    CSS.decl(
                        "vertical-align",
                        "bottom"
                    )
                )

                CSS.rule(
                    CSSSelector.class(
                        "\(block)__cell"
                    ),
                    CSS.decl(
                        "padding",
                        "8px 10px"
                    ),
                    CSS.decl(
                        "border-bottom",
                        "1px solid #eceff2"
                    ),
                    CSS.decl(
                        "vertical-align",
                        "top"
                    )
                )

                CSS.rule(
                    CSSSelector.class(
                        "\(block)__heading--leading"
                    ),
                    CSS.decl(
                        "text-align",
                        "left"
                    )
                )

                CSS.rule(
                    CSSSelector.class(
                        "\(block)__cell--leading"
                    ),
                    CSS.decl(
                        "text-align",
                        "left"
                    )
                )

                CSS.rule(
                    CSSSelector.class(
                        "\(block)__heading--center"
                    ),
                    CSS.decl(
                        "text-align",
                        "center"
                    )
                )

                CSS.rule(
                    CSSSelector.class(
                        "\(block)__cell--center"
                    ),
                    CSS.decl(
                        "text-align",
                        "center"
                    )
                )

                CSS.rule(
                    CSSSelector.class(
                        "\(block)__heading--trailing"
                    ),
                    CSS.decl(
                        "text-align",
                        "right"
                    )
                )

                CSS.rule(
                    CSSSelector.class(
                        "\(block)__cell--trailing"
                    ),
                    CSS.decl(
                        "text-align",
                        "right"
                    )
                )
            }
        }

        public static func stylesheet()
            -> CSSStyleSheet
        {
            styleContribution()
                .content
                .sheet
        }
    }
}
