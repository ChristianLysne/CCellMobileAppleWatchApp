//
//  ViewController.m
//  CCellMobile
//
//  Created by Christian Lysne on 19/05/15.
//  Copyright (c) 2015 Christian Lysne. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // set up our persistent location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)getSerializedLocation {
    // get the latest location from our GPS
    CLLocation *location = self.locationManager.location;
    
    // extract the coordinate
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    float speed = location.speed;
    
    if (location.speed < 0) {
        speed = 0;
    }
    
    // return a serialized dictionary with the current location attributes
    return @{
             @"latitude":   [NSNumber numberWithFloat:coordinate.latitude],
             @"longitude":  [NSNumber numberWithFloat:coordinate.longitude],
             @"altitude":   [NSNumber numberWithFloat:location.altitude],
             @"speed":      [NSNumber numberWithFloat:speed]
             };
}

#pragma mark - Location Delegates
- (void)locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error {
    // print the error to log
    NSLog(@"Error retrieving location: %@", error);
}

- (void)locationManager:(CLLocationManager*)manager
     didUpdateToLocation:(CLLocation*)newLocation
            fromLocation:(CLLocation*)oldLocation {
    
    self.speedLabel.text = [NSString stringWithFormat:@"%g", newLocation.speed];
}


- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // print to console
    NSLog(@"Location authorization status changed: %d", status);
    
    // if we are not authorized, stop tracking (in case we were)
    if(status < kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager stopUpdatingLocation];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

# pragma mark - Interface Actions

- (IBAction)initiateLocationTracking:(id)sender {
    
    // check to see if we have access yet
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        // we don't, so ask the user for it
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        } else {
            [self.locationManager startUpdatingLocation];
        }
    }
    
    // the user denied it or shut it off via settings
    else if([CLLocationManager authorizationStatus] < kCLAuthorizationStatusAuthorizedAlways) {
        
        // tell the user to go to settings
        NSString *msg = @"Location access is not available. Ensure your Location Services are on and go to your iPhone Settings > Privacy > Location Services and find this app. Make sure the 'Allow Location Access' is set to 'Always'";
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:msg
                                   delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil] show];
    } else {
        [self.locationManager startUpdatingLocation];
    }
    
}


@end
