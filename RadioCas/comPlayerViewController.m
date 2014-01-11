//
//  comPlayerViewController.m
//  RadioCas
//
//  Created by Jan Damek on 04.06.13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import "comPlayerViewController.h"
#import "comAppDelegate.h"
#import "XMLReader.h"

@implementation comPlayerViewController

@synthesize hlasitost, hraje, hralo, ani;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect r = hlasitost.bounds;
    volumeView = [[MPVolumeView alloc] initWithFrame:r];
    [self.view addSubview:volumeView];
    
    volumeView.center= hlasitost.center;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    d.player.delegate = self;
    
    self.navigationItem.title = d.akt_radio;
    
    if (d.player.isPlaying){
        [self startPlaying:nil];
    }
    
    volumeView.bounds = hlasitost.bounds;
    volumeView.frame = hlasitost.frame;
    [volumeView setShowsRouteButton:YES];
    
    for (id current in volumeView.subviews) {
        if ([current isKindOfClass:[UISlider class]]) {
            UISlider *volumeSlider = (UISlider *)current;
            volumeSlider.minimumTrackTintColor = [UIColor colorWithRed:255 green:204 blue:0 alpha:0.8];
            volumeSlider.maximumTrackTintColor = [UIColor lightGrayColor];
            volumeSlider.thumbTintColor = [UIColor colorWithRed:255 green:204 blue:0 alpha:0.8];
        }
    }
    
    hlasitost.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    d.player.delegate = d;
    [self stopPlaying:nil];
}

-(IBAction)playBtn:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player play];
}

-(IBAction)stopBtn:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    [d.player stop];
}

-(void)nactiXML{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSURL *url;
    if ([d.akt_radio isEqualToString:@"Brněnsko"]){
        url = [NSURL URLWithString:@"http://www.casrock.cz/nowplaying/brnoonair.php"];
    } else
    url = [NSURL URLWithString:@"http://www.casrock.cz/nowplaying/casonair.php"];
    
    NSError *error;
    NSStringEncoding encoding=NSWindowsNTOperatingSystem;
    NSString *pageData = [NSString stringWithContentsOfURL:url encoding:encoding error:&error];
    
    NSString *skladbyData = pageData;
    
    NSMutableCharacterSet *toRemove = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    [toRemove addCharactersInString:@"\t"];
//    [toRemove addCharactersInString:@"\n"];
    
    skladbyData = [skladbyData stringByTrimmingCharactersInSet:toRemove];
                                                                 
    NSDictionary *skladby = [XMLReader dictionaryForXMLString:skladbyData error:nil];
    
    NSMutableArray *play = [[skladby valueForKey:@"STATUS"] valueForKey:@"PLAY"];
    
    for (NSDictionary *item in play) {
        if ([[item valueForKey:@"INDEX"] integerValue] == 0){
            NSString *h = [NSString stringWithFormat:@"%@ - %@" ,
                           [[item valueForKey:@"ARTIST"] valueForKey:@"text"],
                           [[item valueForKey:@"TITLE"] valueForKey:@"text"]];
            h = [h stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            h = [h stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            h =  [h stringByTrimmingCharactersInSet:toRemove];

//            hraje.text = h;
            hraje.text = [d.player decodeCZ:h];
        }else
            if ([[item valueForKey:@"INDEX"] integerValue] == -1){
                NSString *h = [NSString stringWithFormat:@"%@ - %@" ,
                               [[item valueForKey:@"ARTIST"] valueForKey:@"text"],
                               [[item valueForKey:@"TITLE"] valueForKey:@"text"]];
                h = [h stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                h = [h stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                h =  [h stringByTrimmingCharactersInSet:toRemove];
//                hralo.text = h;
                hralo.text = [d.player decodeCZ:h];
            }
    }
}
-(void)preparePlay:(comPlayer *)player{
    hralo.text = @"";
    hraje.text = @"";
    [ani startAnimating];
}

-(void)startPlaying:(comPlayer *)player{
    [self nactiXML];
    interval = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(nactiXML) userInfo:nil repeats:YES];
    [ani stopAnimating];
}
-(void)stopPlaying:(comPlayer *)player{
    [interval invalidate];
    [ani stopAnimating];
    hralo.text = hraje.text;
    hraje.text = @"";
}

-(IBAction)emailBtn:(id)sender{
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    d.player.delegate = d;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@" , [d mailto]]]];
}

-(IBAction)smsBtn:(id)sender{
    volej = NO;

    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    d.player.delegate = d;
    
    NSString *s = [NSString stringWithFormat:@"Opravdu poslat sms na %@ ?" , [d sms]];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Zaslat SMS do studia"
                                                   message: s
                                                  delegate: self
                                         cancelButtonTitle:@"Ne"
                                         otherButtonTitles:@"Ano",nil];

    [alert show];
}

-(IBAction)telBtn:(id)sender{
    volej = YES;
    
    comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
    d.player.delegate = d;
    
    NSString *s = [NSString stringWithFormat:@"Opravdu vytočit %@ ?" , [d tel]];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Volat do studia"
                                                   message: s
                                                  delegate: self
                                         cancelButtonTitle:@"Ne"
                                         otherButtonTitles:@"Ano",nil];
    
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        //zmackuno ne
    }else{
        if (volej){
            //tel
            comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
            d.player.delegate = d;
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@" , [d tel]]]];
        }else{
            //sms
            comAppDelegate *d = (comAppDelegate*)[[UIApplication sharedApplication]delegate];
            d.player.delegate = d;
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@" , [d sms]]]];
        }
    }
}


@end
