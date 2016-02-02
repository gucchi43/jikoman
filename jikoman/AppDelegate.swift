/*
 * "Hello Swift, Goodbye Obj-C."
 * Converted by 'objc2swift'
 *
 * https://github.com/yahoojapan/objc2swift
 */

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyObject: AnyObject]) -> Bool {
        Parse.enableLocalDatastore()
        Parse.setApplicationId("evjYkJPJKiD8SsEZzR4WaG28LshKbLgG1CC53kWU", clientKey: "PSMA7YSfyHYaSWO8yElOD67Uxdhk643E0bUd6Rgv")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }
}
