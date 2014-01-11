//
//  comAppDelegate.h
//  Rádio Čas
//
//  Created by Jan Damek on 29.04.13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "comPlayer.h"

@interface comAppDelegate : UIResponder <UIApplicationDelegate, comPlayerDelegate>{
    NSMutableArray *kontakt;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong) comPlayer *player;

@property (strong) NSString *akt_radio;

@property int akt_radio_kontakt;

-(NSString*)mailto;
-(NSString*)tel;
-(NSString*)sms;

@end
