//
//  comAppDelegate.m
//  Rádio Čas
//
//  Created by Jan Damek on 29.04.13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import "comAppDelegate.h"

@implementation comAppDelegate

@synthesize player = _player, akt_radio_kontakt;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    kontakt = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *adr = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
    @"studio@radiocas.cz", @"mailto", @"776612800" , @"sms", @"12800", @"tel"
                                , nil];
    [kontakt addObject:adr];
    adr = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
    @"studio@radiocas.cz", @"mailto", @"725055055" , @"sms", @"725055055", @"tel"
                                , nil];
    [kontakt addObject:adr];
    
    _player = [[comPlayer alloc] init];
    
    //zakomentovane vlastni pozadi tabbaru, dela neplechu v iPadu
    //UITabBar *tabBar = [UITabBar appearance];
    //[tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bar_bg_with_ico"]];
    
//    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                               [UIColor blackColor],UITextAttributeTextColor,
//                                               [UIColor lightGrayColor], UITextAttributeTextShadowColor,
//                                               [NSValue valueWithUIOffset:UIOffsetMake(-1, 0)], UITextAttributeTextShadowOffset, nil];
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];

    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(NSString*)mailto{
    return [[kontakt objectAtIndex:akt_radio_kontakt] valueForKey:@"mailto"];
}

-(NSString*)tel{
    return [[kontakt objectAtIndex:akt_radio_kontakt] valueForKey:@"tel"];
}

-(NSString*)sms{
     return [[kontakt objectAtIndex:akt_radio_kontakt] valueForKey:@"sms"];
}

@end
