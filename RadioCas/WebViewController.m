//
//  WebViewController.m
//  RadioCas
//
//  Created by Tomas Vanek on 6/8/13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webview, progres;

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
    webview.delegate = self;
	[webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.radiocas.cz"]]];
    
    self.canDisplayBannerAds = true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [progres startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [progres stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadWeb:(id)sender{
    [webview reload];
}

-(void)stopLoad:(id)sender{
    [webview stopLoading];
    [progres stopAnimating];
}

@end
