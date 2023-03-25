import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String,
                           platform: Platform,
                           organizationName: String,
                           bundleShot: InfoPlist.Value,
                           bundleVersion: InfoPlist.Value,
                           externalTargets: [String]) -> Project {
        
        let extenalTargets = externalTargets.map {
            TargetDependency.external(name: $0)
        }
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     organizationName: organizationName,
                                     bundleShot: bundleShot,
                                     bundleVersion: bundleVersion,
                                     dependencies: extenalTargets)
        return Project(name: name,
                       organizationName: "jjw",
                       targets: targets)
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String,
                                       platform: Platform,
                                       organizationName: String,
                                       bundleShot: InfoPlist.Value,
                                       bundleVersion: InfoPlist.Value,
                                       dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
        let organizationName = organizationName
        
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": bundleShot,
            "CFBundleVersion": bundleVersion,
            "UIMainStoryboardFile": "Main",
            "UILaunchStoryboardName": "LaunchScreen"
        ]
        
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(organizationName).\(name)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            infoPlist: .default,
            sources: ["\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}
