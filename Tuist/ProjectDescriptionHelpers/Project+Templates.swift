import ProjectDescription

extension Project {
    public static func app(name: String,
                           destinations: Destinations,
                           organizationName: String,
                           bundleShot: Plist.Value,
                           bundleVersion: Plist.Value,
                           externalTargets: [String]) -> Project {
        
        let extenalTargets = externalTargets.map {
            TargetDependency.external(name: $0)
        }
        let targets = makeAppTargets(name: name,
                                     destinations: destinations,
                                     organizationName: organizationName,
                                     bundleShot: bundleShot,
                                     bundleVersion: bundleVersion,
                                     dependencies: extenalTargets)
        return Project(
            name: name,
            organizationName: "jjw",
            targets: targets
        )
    }

    private static func makeAppTargets(name: String,
                                       destinations: Destinations,
                                       organizationName: String,
                                       bundleShot: Plist.Value,
                                       bundleVersion: Plist.Value,
                                       dependencies: [TargetDependency]) -> [Target] {
        
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": bundleShot,
            "CFBundleVersion": bundleVersion,
            "UILaunchStoryboardName": "LaunchScreen",
            "UIApplicationSceneManifest": [
                "UIApplicationSupportsMultipleScenes": false,
                "UISceneConfigurations": [
                    "UIWindowSceneSessionRoleApplication": [
                        [
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                            "UISceneStoryboardFile": "Main"
                        ]
                    ]
                ]
            ]
        ]
        
        let mainTarget: Target = .target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "\(organizationName).\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            dependencies: dependencies,
            settings: .settings(base: ["OTHER_LDFLAGS": ["-ObjC"]])
        )

        let testTarget: Target = .target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            infoPlist: .default,
            sources: ["\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ]
        )
        return [mainTarget, testTarget]
    }
}
