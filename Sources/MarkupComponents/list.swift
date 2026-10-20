import Constructors
import HTML

extension Markup {
    public struct List:
        ComponentOutputProviding,
        ReusableComponent
    {
        public enum Kind: Sendable {
            case unordered
            case ordered
        }

        public let items: [String]
        public let kind: Kind

        public init(
            items: [String],
            kind: Kind = .unordered
        ) {
            self.items = items
            self.kind = kind
        }

        public var output: ComponentOutput {
            ComponentOutput(
                content: ComponentContent(
                    body: componentBody
                )
            )
        }

        public var nodes: ReusableComponentNodes {
            .body(output.content.body)
        }

        private var componentBody: HTMLFragment {
            switch kind {
            case .unordered:
                return [
                    HTML.ul {
                        for item in items {
                            HTML.li {
                                HTML.text(item)
                            }
                        }
                    }
                ]

            case .ordered:
                return [
                    HTML.ol {
                        for item in items {
                            HTML.li {
                                HTML.text(item)
                            }
                        }
                    }
                ]
            }
        }
    }
}
