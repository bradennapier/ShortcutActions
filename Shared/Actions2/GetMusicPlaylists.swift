import AppIntents
import MediaPlayer

@available(macOS, unavailable)
struct GetMusicPlaylists: AppIntent, CustomIntentMigratedAppIntent {
	static let intentClassName = "GetMusicPlaylistsIntent"

	static let title: LocalizedStringResource = "Get Music Playlists (iOS-only)"

	static let description = IntentDescription(
		"Returns the names of the playlists in your Music library.",
		categoryName: "Music"
	)

	func perform() async throws -> some IntentResult & ReturnsValue<[String]> {
		let playlists = MPMediaQuery.playlists().collections as? [MPMediaPlaylist]
		let playlistNames = playlists?.compactMap(\.name) ?? []

		// This is intentionally after so we don't have to explicitly request access before checking.
		guard MPMediaLibrary.authorizationStatus() == .authorized else {
			throw NSError.appError("No access to the Music library. You can grant access in “Settings › Actions”.")
		}

		return .result(value: playlistNames)
	}
}
