//
//  SceneDelegate.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let windowScene = scene as? UIWindowScene {
            
            let window = UIWindow(windowScene: windowScene)
            window.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
            
            let rootVC = ViewController()
            let navigationController = UINavigationController(rootViewController: rootVC)
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            self.window = window
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) { }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}


