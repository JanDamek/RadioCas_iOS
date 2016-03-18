//
//  FaceBookViewController.m
//  RadioCas
//
//  Created by Tomas Vanek on 6/8/13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import "FaceBookViewController.h"

@interface FaceBookViewController ()

@end

@implementation FaceBookViewController

@synthesize facebook, progres;

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
    facebook.delegate = self;
	[facebook loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.facebook.com/casradio.cz"]]];
    
    self.canDisplayBannerAds = true;
}

- (void)webViewDidStartLoad:(UIWebView *)facebook
{
    [progres startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)facebook
{
    [progres stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadWeb:(id)sender{
    [facebook reload];
}

-(void)stopLoad:(id)sender{
    [facebook stopLoading];
    [progres stopAnimating];
}


@end
