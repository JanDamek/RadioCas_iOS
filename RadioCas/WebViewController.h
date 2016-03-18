//
//  WebViewController.h
//  RadioCas
//
//  Created by Tomas Vanek on 6/8/13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface WebViewController : UIViewController<UIWebViewDelegate,ADBannerViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webview;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *progres;

-(IBAction)reloadWeb:(id)sender;
-(IBAction)stopLoad:(id)sender;

@end
