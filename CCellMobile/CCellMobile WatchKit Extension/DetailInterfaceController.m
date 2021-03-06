//
//  DetailInterfaceController.m
//  CCellMobile
//
//  Created by Christian Lysne on 19/05/15.
//  Copyright (c) 2015 Christian Lysne. All rights reserved.
//

#import "DetailInterfaceController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailInterfaceController ()

@property (weak, nonatomic) IBOutlet WKInterfaceMap *map;

@end

@implementation DetailInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
    NSNumber *latitude = context[@"lastLatitude"];
    NSNumber *longitude = context[@"lastLongitude"];
    
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude.floatValue,longitude.floatValue);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    
    // Other colors include red and green pins
    [self.map addAnnotation:coordinates withPinColor: WKInterfaceMapPinColorPurple];
    
    [self.map setRegion:(MKCoordinateRegionMake(coordinates, span))];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



