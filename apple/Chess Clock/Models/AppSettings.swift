// AppSettings.swift
// Chess Clock
//
// Created by Allister Isaiah Harvey on 2026.09.02.
//

import SwiftUI
import SwiftData

@Model
final class AppSettings {
    @Attribute(.unique) var id: String
    var isStatusBarHidden: Bool
    var isDarkModeEnabled: Bool
    var isSoundEnabled: Bool
    var appThemeColor: ThemeColor

    init(
        id: String = "default_settings",
        isStatusBarHidden: Bool = false,
        isDarkModeEnabled: Bool = false,
        isSoundEnabled: Bool = true,
        appThemeColor: ThemeColor = .blue
    ) {
        self.id = id
        self.isStatusBarHidden = isStatusBarHidden
        self.isDarkModeEnabled = isDarkModeEnabled
        self.isSoundEnabled = isSoundEnabled
        self.appThemeColor = appThemeColor
    }
}
