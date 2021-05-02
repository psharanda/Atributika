//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let tbc = UITabBarController()

        var tabs = [UIViewController]()

        func addTab(_ vc: UIViewController, name: String, iconName: String) {
            let icon: UIImage?

            if #available(iOS 13.0, *) {
                icon = UIImage(systemName: iconName)
            } else {
                icon = nil
            }

            vc.tabBarItem = UITabBarItem(
                title: name,
                image: icon,
                selectedImage: nil
            )
            tabs.append(UINavigationController(rootViewController: vc))
        }

        addTab(SnippetsViewController(), name: "Snippets", iconName: "list.clipboard")
        addTab(AttributedLabelDemoViewController(), name: "Snippets", iconName: "list.bullet")
        addTab(UIStoryboard(name: "IB", bundle: nil).instantiateViewController(withIdentifier: "ib"), name: "Storyboard", iconName: "macwindow")
        addTab(BrowserViewController(), name: "Browser", iconName: "arrow.clockwise.icloud")

        if #available(iOS 13.0, *) {
            addTab(SwiftUIDemoViewController(rootView: ContentView()), name: "SwiftUI", iconName: "swift")
        }

        if #available(iOS 13.0, *) {
            addTab(MarkdownViewController(), name: "Markdown", iconName: "text.alignleft")
        }

        tbc.viewControllers = tabs

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
