//
//  InterfaceController.m
//  CCellMobile WatchKit Extension
//
//  Created by Christian Lysne on 19/05/15.
//  Copyright (c) 2015 Christian Lysne. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()


@property (weak, nonatomic) IBOutlet WKInterfaceLabel *speedLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *animationImage;
@property (strong, nonatomic) NSTimer *updateTimer;
@property (nonatomic, assign) BOOL isAnimationShowing;
@property (nonatomic, assign) CGFloat lastLatitude;
@property (nonatomic, assign) CGFloat lastLongitude;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    self.isAnimationShowing = NO;
    [self requestLocationFromPhone];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                    target:self
                                                  selector:@selector(requestLocationFromPhone)
                                                  userInfo:nil
                                                   repeats:TRUE];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    
    [self.updateTimer invalidate];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:@"moveSegue"]) {
        NSDictionary *contextData = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithFloat: self.lastLatitude], [NSNumber numberWithFloat:self.lastLongitude ]] forKeys:@[@"lastLatitude", @"lastLongitude"]];
        return contextData;
    } else {
        return nil;
    }
}

- (void)toggleRunAnimation {
    if (self.isAnimationShowing) {
        [self.animationImage stopAnimating];
        self.isAnimationShowing = NO;
        [self.animationImage setHidden:YES];
    } else {
        [self.animationImage startAnimating];
        self.isAnimationShowing = YES;
        [self.animationImage setHidden:NO];
    }
    
    //Send count to parent application
    NSString *stateString = [NSString stringWithFormat:@"%@", self.isAnimationShowing ? @"Running" : @"Relaxing"];
    NSDictionary *applicationData = [[NSDictionary alloc] initWithObjects:@[stateString] forKeys:@[@"animationState"]];
    
    //Handle reciever in app delegate of parent app
    [WKInterfaceController openParentApplication:applicationData reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"%@ %@",replyInfo, error);
    }];
}

- (void)requestLocationFromPhone {
    [WKInterfaceController openParentApplication:@{@"request":@"location"}
                                           reply:^(NSDictionary *replyInfo, NSError *error) {
                                               
        // the request was successful
        if(error == nil) {
            
            // get the serialized location object
            NSDictionary *location = replyInfo[@"location"];
                                                   
            // pull out the speed (it's an NSNumber)
            NSNumber *speed = location[@"speed"];
            
            NSLog(@"Speed: %@", speed);
            if ((speed.floatValue > 0 && !self.isAnimationShowing) || (speed.floatValue <= 0 && self.isAnimationShowing)) {
                [self toggleRunAnimation];
            }
                                                   
            // and convert it to a string for our label
            NSString *speedString = [NSString stringWithFormat:@"Speed: %.02f m/s", speed.floatValue];
            
            // update our label with the newest location's speed
            [self.speedLabel setText:speedString];
                                                   
            // next, get the lat/lon
            NSNumber *latitude = location[@"latitude"];
            NSNumber *longitude = location[@"longitude"];
                                                   
            self.lastLatitude = latitude.floatValue;
            self.lastLongitude = longitude.floatValue;
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)handleActionWithIdentifier:(NSString *)identifier
             forRemoteNotification:(NSDictionary *)remoteNotification {
    NSLog(@"Handling remote notification: %@ with identifier: %@", remoteNotification, identifier);
}
@end



