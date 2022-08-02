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
    private var tabBarVC = UITabBarController()
    private var nc = UINavigationController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = self.window
        guard let _ = (scene as? UIWindowScene) else { return }

        Self.shared = self
        let isValidUser = !DefaultsManager.shared.readUser().id.isEmpty
        setupRootControllerIfNeeded(validUser: isValidUser)
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func setupRootControllerIfNeeded(validUser: Bool) {
        let rootViewController = validUser
            ? getRootViewControllerForValidUser()
            : getRootViewControllerForInvalidUser()

        nc.viewControllers = [rootViewController]

        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
    }
    
    func getRootViewControllerForValidUser() -> UIViewController {
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
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}

