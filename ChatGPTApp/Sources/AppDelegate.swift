//
//  AppDelegate.swift
//  OpenAIApp
//
//  Created by jun wook on 2023/01/07.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let st = UIStoryboard(name: "Main", bundle: nil)
          let vc = st.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.view.backgroundColor = .white
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        return true
    }

}

