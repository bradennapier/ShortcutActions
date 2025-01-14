import SwiftUI
import AppIntents

struct ApplyCaptureDate: AppIntent, CustomIntentMigratedAppIntent {
	static let intentClassName = "ApplyCaptureDateIntent"

	static let title: LocalizedStringResource = "Apply Capture Date"

	static let description = IntentDescription(
"""
Applies the original capture date and time of the photo (from Exif metadata) to the file's creation and modification date.

If an image does not have a capture date metadata, the file is just passed through.

This action can be useful to run after the built-in "Convert Image" action (ensure "Preserve Metadata" is checked).
""",
	categoryName: "File"
	)

	@Parameter(title: "Images", supportedTypeIdentifiers: ["public.image"])
	var images: [IntentFile]

	@Parameter(
		title: "Also Set Modification Date",
		default: false,
		displayName: .init(true: "Creation Date", false: "Creation & Modification Date")
	)
	var setModificationDate: Bool

	static var parameterSummary: some ParameterSummary {
		// TODO: iOS 16 issue
//		Summary("Set the \(\.$setModificationDate) of \(\.$images) to the original capture date and time")
		Summary("Set the creation date of \(\.$images) to the original capture date and time") {
			\.$setModificationDate
		}
	}

	func perform() async throws -> some IntentResult & ReturnsValue<[IntentFile]> {
		let result = try images.map { file in
			guard let captureDate = CGImage.captureDate(ofImage: file.data) else {
				return file
			}

			return try file.modifyingFileAsURL { url in
				try url.setResourceValues {
					$0.creationDate = captureDate

					if setModificationDate {
						$0.contentModificationDate = captureDate
					}
				}

				return url
			}
		}

		return .result(value: result)
	}
}
