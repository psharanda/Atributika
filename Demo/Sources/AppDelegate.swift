//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let tbc = UITabBarController()

        let vc1 = SnippetsViewController()
        vc1.tabBarItem = UITabBarItem(
            title: "Snippets",
            image: UIImage(systemName: "list.clipboard"),
            selectedImage: nil
        )

        let vc2 = AttributedLabelDemoViewController()
        vc2.tabBarItem = UITabBarItem(
            title: "AttributedLabel",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: nil
        )

        let vc3 = UIStoryboard(name: "IB", bundle: nil).instantiateViewController(withIdentifier: "ib")
        vc3.tabBarItem = UITabBarItem(
            title: "Storyboard",
            image: UIImage(systemName: "macwindow"),
            selectedImage: nil
        )

        let vc4 = BrowserViewController()
        vc4.tabBarItem = UITabBarItem(
            title: "Browser",
            image: UIImage(systemName: "arrow.clockwise.icloud"),
            selectedImage: nil
        )

        let vc5: UIViewController
        vc5 = SwiftUIDemoViewController(rootView: ContentView())
        vc5.tabBarItem = UITabBarItem(
            title: "SwiftUI",
            image: UIImage(systemName: "swift"),
            selectedImage: nil
        )

        let vc6 = MarkdownViewController()
        vc6.tabBarItem = UITabBarItem(
            title: "Markdown",
            image: UIImage(systemName: "text.alignleft"),
            selectedImage: nil
        )

        tbc.viewControllers = [
            UINavigationController(rootViewController: vc1),
            UINavigationController(rootViewController: vc2),
            UINavigationController(rootViewController: vc3),
            UINavigationController(rootViewController: vc4),
            UINavigationController(rootViewController: vc5),
            UINavigationController(rootViewController: vc6),
        ]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tbc
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
