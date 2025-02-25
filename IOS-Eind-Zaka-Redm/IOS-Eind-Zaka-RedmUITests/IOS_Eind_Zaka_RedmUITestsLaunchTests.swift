//
//  IOS_Eind_Zaka_RedmUITestsLaunchTests.swift
//  IOS-Eind-Zaka-RedmUITests
//
//  Created by Redmar Alkema on 19/02/2025.
//

import XCTest

final class IOS_Eind_Zaka_RedmUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
