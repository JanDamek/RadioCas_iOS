//
//  comRadioSelectViewController.m
//  RadioCas
//
//  Created by Jan Damek on 04.06.13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import "comRadioSelectViewController.h"
#import "comAppDelegate.h"

@interface comRadioSelectViewController ()

@end

@implementation comRadioSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
// Do any additional setup after loading the view, typically from a nib.
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 63, 50)];
    UIImage *image = [UIImage imageNamed: @"logo_small_nav_bar"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    [imageView setFrame:CGRectMake(0, 5, 53, 40)];
    [view addSubview:imageView];
    
    self.navigationItem.titleView = view;
    self.canDisplayBannerAds = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ostrava:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
    d.player.streamURL = @"http://icecast1.play.cz:8000/casradio32aac";
    d.akt_radio = @"Ostravsko";
    d.akt_radio_kontakt = 0;
    [d.player play];
}

-(IBAction)slezko:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
    d.player.streamURL = @"http://icecast1.play.cz:8000/casradio32aac";
    d.akt_radio = @"Slezsko";
    d.akt_radio_kontakt = 0;
    [d.player play];
}

-(IBAction)valazsko:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
    d.player.streamURL = @"http://icecast1.play.cz:8000/casradio32aac";
    d.akt_radio = @"Valasško";
    d.akt_radio_kontakt = 0;
    [d.player play];
}

-(IBAction)zlinsko:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
    d.player.streamURL = @"http://icecast7.play.cz/casradiozlin64.mp3";
    d.akt_radio = @"Zlínsko";
    d.akt_radio_kontakt = 0;
    [d.player play];
}

-(IBAction)olomouc:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
    d.player.streamURL = @"http://icecast7.play.cz/casradioolomouc64.mp3";
    d.akt_radio = @"Olomoucko";
    d.akt_radio_kontakt = 0;
    [d.player play];
}

-(IBAction)brnensko:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
    d.player.streamURL = @"http://icecast1.play.cz/CasBrno32aac";
    d.akt_radio = @"Brněnsko";
    d.akt_radio_kontakt = 0;
    [d.player play];
}

-(IBAction)slovacko:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
    d.player.streamURL = @"http://icecast7.play.cz/dyje64.mp3";
    d.akt_radio = @"Slovácko";
    d.akt_radio_kontakt = 0;
    [d.player play];
}

@end
