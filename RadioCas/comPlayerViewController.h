//
//  comPlayerViewController.h
//  RadioCas
//
//  Created by Jan Damek on 04.06.13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "comPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <iAd/iAd.h>

@interface comPlayerViewController : UIViewController <comPlayerDelegate, UIAlertViewDelegate, ADBannerViewDelegate>{
    NSTimer *interval;
    MPVolumeView *volumeView;
    
    BOOL volej;
}

@property (retain, nonatomic) IBOutlet UILabel *hraje;
@property (retain, nonatomic) IBOutlet UILabel *hralo;

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *ani;
@property (retain, nonatomic) IBOutlet UISlider *hlasitost;

-(IBAction)playBtn:(id)sender;
-(IBAction)stopBtn:(id)sender;

-(IBAction)emailBtn:(id)sender;
-(IBAction)smsBtn:(id)sender;
-(IBAction)telBtn:(id)sender;

@end
