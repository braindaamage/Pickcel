//
//  AppDelegate.m
//  Pickcel
//
//  Created by Leonardo on 09-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"

NSString *const FBSessionStateChangedNotification = @"cl.reframe.Pickcel:FBSessionStateChangedNotification";

@interface AppDelegate ()

@property (strong, nonatomic) TabBarViewController *mainController;
@property (strong, nonatomic) LoginViewController* login;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainController = _mainController;
@synthesize login = _login;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self customizeInterface];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainController = (TabBarViewController *) [mainStoryboard instantiateViewControllerWithIdentifier:@"tabBarID"];
    self.window.rootViewController = self.mainController;
    
    [self.window makeKeyAndVisible];
    
    if (![self verificarCuenta]) {
        self.login = [[LoginViewController alloc] init];
        [self.mainController presentViewController:self.login animated:NO completion:nil];
    }
    
    
    return YES;
}

- (BOOL) verificarCuenta {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    NSArray *accounts = [accountStore accounts];
    if ([accounts count] > 0) {
        return YES;
    } else {
        if ([self openSessionWithAllowLoginUI:NO]) {
            return YES;
        } else {
            return NO;
        }
    }
    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [FBSession.activeSession close];
}

- (void)customizeInterface
{
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
}

// Facebook metodos

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                if (self.login != nil) {
                    [self.login dismissViewControllerAnimated:YES completion:nil];
                    self.login = nil;
                }
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_about_me",
                            nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

@end

