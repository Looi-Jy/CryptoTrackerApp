//
//  Logger.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 14/08/2025.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier

    static let cryptoTrack = Logger(subsystem: subsystem ?? "Unknown", category: "CryptoTrack")
}
