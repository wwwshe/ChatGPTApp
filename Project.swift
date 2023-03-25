import ProjectDescription
import ProjectDescriptionHelpers

/*
                +-------------+
                |             |
                |     App     | Contains ChatGPTApp App target and ChatGPTApp unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

let organizationName = "jjw"
let bundleShot: InfoPlist.Value = "1.0"
let bundleVersion: InfoPlist.Value = "1"

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "ChatGPTApp",
                          platform: .iOS,
                          organizationName: organizationName,
                          bundleShot: bundleShot,
                          bundleVersion: bundleVersion,
                          externalTargets: [
                            "RxSwift",
                            "RxCocoa",
                            "RxKeyboard",
                            "RxGesture",
                            "Toast",
                            "Network"
                          ])
