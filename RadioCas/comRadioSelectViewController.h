//
//  comRadioSelectViewController.h
//  RadioCas
//
//  Created by Jan Damek on 04.06.13.
//  Copyright (c) 2013 digitalscope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface comRadioSelectViewController : UIViewController<ADBannerViewDelegate>

-(IBAction)ostrava:(id)sender;
-(IBAction)slezko:(id)sender;
-(IBAction)valazsko:(id)sender;
-(IBAction)zlinsko:(id)sender;
-(IBAction)olomouc:(id)sender;
-(IBAction)brnensko:(id)sender;
-(IBAction)slovacko:(id)sender;

@end
