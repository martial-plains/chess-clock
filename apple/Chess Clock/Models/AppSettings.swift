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
    var isSoundEnabled: Bool
    var isHapticsEnabled: Bool
    var isLowTimeHapticsEnabled: Bool
    var appThemeColor: ThemeColor

    init(
        id: String = "default_settings",
        isStatusBarHidden: Bool = false,
        isSoundEnabled: Bool = true,
        isHapticsEnabled: Bool = true,
        isLowTimeHapticsEnabled: Bool = true,
        appThemeColor: ThemeColor = .blue
    ) {
        self.id = id
        self.isStatusBarHidden = isStatusBarHidden
        self.isSoundEnabled = isSoundEnabled
        self.isHapticsEnabled = isHapticsEnabled
        self.isLowTimeHapticsEnabled = isLowTimeHapticsEnabled
        self.appThemeColor = appThemeColor
    }
}
