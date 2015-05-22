//
//  ViewController.h
//  CCellMobile
//
//  Created by Christian Lysne on 19/05/15.
//  Copyright (c) 2015 Christian Lysne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

- (NSDictionary *)getSerializedLocation;

@end

