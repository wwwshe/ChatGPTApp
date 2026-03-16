import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "ChatGPTApp",
                          destinations: .iOS,
                          organizationName: "jjw",
                          bundleShot: "1.0",
                          bundleVersion: "1",
                          externalTargets: [
                            "RxSwift",
                            "RxCocoa",
                            "RxKeyboard",
                            "RxGesture",
                            "Toast",
                            "NetworkKit"
                          ])
