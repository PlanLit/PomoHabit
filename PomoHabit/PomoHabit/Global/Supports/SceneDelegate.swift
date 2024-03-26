//
//  SceneDelegate.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/02/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let coreDataManager = CoreDataManager.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let timerState = UserDefaultsManager.shared.loadTimerState()
        
        let rootViewController: UIViewController = {
            if let _ = try? coreDataManager.fetchUser()?.nickname {
                
                return  TabBarController()
            } else {
                
                return UINavigationController(rootViewController: OnboardingLoginViewController())
            }
        }()
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) { }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let timerViewController = window?.rootViewController as? TimerViewController else { return }
        timerViewController.loadTimerState()
    }
    
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func sceneWillEnterForeground(_ scene: UIScene) { }
    
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
