import AppIntents

struct GetUniformTypeIdentifier: AppIntent, CustomIntentMigratedAppIntent {
	static let intentClassName = "GetUniformTypeIdentifierIntent"

	static let title: LocalizedStringResource = "Get Uniform Type Identifier"

	static let description = IntentDescription(
"""
Returns the Uniform Type Identifier (UTI) of the input file.

For example, a JPEG file would return “public.jpeg”.
""",
	categoryName: "File"
	)

	@Parameter(title: "File", supportedTypeIdentifiers: ["public.item"])
	var file: IntentFile

	static var parameterSummary: some ParameterSummary {
		Summary("Get the Uniform Type Identifier of \(\.$file)")
	}

	func perform() async throws -> some IntentResult & ReturnsValue<String> {
		.result(value: file.type?.identifier ?? "public.data")
	}
}
