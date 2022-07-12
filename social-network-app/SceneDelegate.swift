//
//  SceneDelegate.swift
//  social-network-app
//
//  Created by user on 29/6/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static weak var shared: SceneDelegate?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        setupRootControllerIfNeeded(validUser: true)
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func setupRootControllerIfNeeded(validUser: Bool) {
        let nc = UINavigationController()
 
        let rootViewController = validUser
            ? getRootViewControllerForValidUser()
            : getRootViewControllerForInvalidUser()
        
        nc.viewControllers = [rootViewController]
        
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
    }
    
    func getRootViewControllerForValidUser() -> UIViewController {
        let tabBarVC = UITabBarController()
        tabBarVC.view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBarVC.tabBar.tintColor = UIColor(named: "primary")
        
        tabBarVC.viewControllers = [
            createNavController(for: PostListViewController(), title: "Explore", image: UIImage(systemName: "house.fill")!),
            createNavController(for: ChatListViewController(), title: "Chats", image: UIImage(systemName: "message.fill")!),
            createNavController(for: ProfileViewController(), title: "Profile", image: UIImage(systemName: "person.circle.fill")!),
            createNavController(for: SettingsViewController(), title: "Settings", image: UIImage(systemName: "gearshape.fill")!)
        ]
        
        return tabBarVC
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage)-> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image

        //navController.navigationBar.prefersLargeTitles = true
        //navController.navigationBar.backgroundColor = UIColor(named: "primary")
        navController.navigationBar.tintColor = UIColor(named: "primary")
        
        
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "primary")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        
        navController.modalPresentationStyle = .overFullScreen
        
        
        rootViewController.navigationItem.title = title
        
        
        return navController
    }

    func getRootViewControllerForInvalidUser() -> UIViewController {
        LoginViewController()
        //createNavController(for: SignUpViewController(), title: "Sign In", image: UIImage(systemName: "newspaper.fill"))
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

