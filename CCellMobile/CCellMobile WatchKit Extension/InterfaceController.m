//
//  InterfaceController.m
//  CCellMobile WatchKit Extension
//
//  Created by Christian Lysne on 19/05/15.
//  Copyright (c) 2015 Christian Lysne. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceButton *animationButton;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *animationImage;
@property (nonatomic, assign) BOOL isAnimationShowing;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)tappedRunButton {
    if (self.isAnimationShowing) {
        [self.animationImage stopAnimating];
        self.isAnimationShowing = NO;
        [self.animationImage setHidden:YES];
        [self.animationButton setTitle:@"Run dude!"];
    } else {
        [self.animationImage startAnimating];
        self.isAnimationShowing = YES;
        [self.animationImage setHidden:NO];
        [self.animationButton setTitle:@"Take a break"];
    }
    
    //Send count to parent application
    NSString *stateString = [NSString stringWithFormat:@"%@", self.isAnimationShowing ? @"Running" : @"Relaxing"];
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[stateString] forKeys:@[@"animationState"]];
    
    //Handle reciever in app delegate of parent app
    [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"%@ %@",replyInfo, error);
    }];
}
@end



