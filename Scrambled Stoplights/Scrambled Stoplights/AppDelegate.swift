/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application( _ application : UIApplication, supportedInterfaceOrientationsFor window : UIWindow? ) -> UIInterfaceOrientationMask
    {
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
    }

    func applicationDidEnterBackground( _ application : UIApplication ) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // Pause Game
        // Save Game State
        // Invalidate Timers
        // Release Resources
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        // Scrambled Stoplights Persistent Container
        let container = NSPersistentContainer( name : CoreData.scrambledStoplights.description )
        container.loadPersistentStores( completionHandler : { ( storeDescription, error ) in
            if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
        } )
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        // Scrambled Stoplights Context
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

