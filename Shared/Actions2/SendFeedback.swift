import AppIntents

struct SendFeedback: AppIntent, CustomIntentMigratedAppIntent {
	static let intentClassName = "SendFeedbackIntent"

	static let title: LocalizedStringResource = "Send Feedback"

	static let description = IntentDescription(
		"Lets you send feedback, action ideas, bug reports, etc, directly to the developer of the Actions app. You can also email me at sindresorhus@gmail.com if you prefer that.",
		categoryName: "Miscellaneous"
	)

	@Parameter(title: "Message", inputOptions: .init(multiline: true))
	var message: String

	@Parameter(
		title: "Your Email",
		inputOptions: .init(
			keyboardType: .URL,
			capitalizationType: .none,
			smartQuotes: false,
			smartDashes: false
		)
	)
	var email: String

	static var parameterSummary: some ParameterSummary {
		Summary("Send feedback to the developer of the Actions app") {
			\.$email
			\.$message
		}
	}

	func perform() async throws -> some IntentResult & ReturnsValue<String> {
		guard
			let email = email.trimmed.nilIfEmpty,
			email.contains("@")
		else {
			throw NSError.appError("Invalid email address.")
		}

		guard let message = message.nilIfEmptyOrWhitespace else {
			throw NSError.appError("Write a message.")
		}

		try await SSApp.sendFeedback(email: email, message: message)

		return .result(value: "Thanks for your feedback 🙌")
	}
}
