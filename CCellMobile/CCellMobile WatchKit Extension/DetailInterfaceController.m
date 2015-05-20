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
    
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(59.91317,10.74188);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    
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



