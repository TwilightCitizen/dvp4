/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window    : UIWindow?
    internal var game      : Game!

    func application(
        _                                 application : UIApplication,
        supportedInterfaceOrientationsFor window      : UIWindow?
    ) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func application(
        _                             application   : UIApplication,
        didFinishLaunchingWithOptions launchOptions : [ UIApplication.LaunchOptionsKey : Any ]?
    ) -> Bool {
        // Customizations
        return true
    }

    func applicationWillResignActive( _ application : UIApplication ) {
        // Pause Game
        if game.running { game.stop() }
    }

    func applicationDidEnterBackground( _ application : UIApplication ) {
        // Pause Game
        // Save Game State
        // Invalidate Timers
        // Release Resources
        if game.running { game.stop() }
    }

    func applicationWillEnterForeground( _ application : UIApplication ) {
        // Restore Game State
        // Restore Timers
        // Leave Game Paused
    }

    func applicationDidBecomeActive( _ application : UIApplication ) {
        // Leave Game Paused
    }

    func applicationWillTerminate( _ application : UIApplication ) {
        game.stop()
    }
}

