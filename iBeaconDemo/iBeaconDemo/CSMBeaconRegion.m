//
//  CSMBeaconRegion.m
//  iBeacons_Demo
//
//  Created by Christopher Mann on 9/16/13.
//  Copyright (c) 2013 Christopher Mann. All rights reserved.
//

#import "CSMBeaconRegion.h"
#import "CSMAppDelegate.h"


static CSMBeaconRegion *_sharedInstance = nil;

@implementation CSMBeaconRegion

+ (instancetype)targetRegion {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CSMBeaconRegion alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *posX = [prefs objectForKey:@"posX"];
    NSString *posY = [prefs objectForKey:@"posY"];
    NSString *iName = [prefs objectForKey:@"iName"];
    // initialize a new CLBeaconRegion with application-specific UUID and human-readable identifier
    //self = [super initWithProximityUUID:[CSMAppDelegate appDelegate].myUUID
      //                                        identifier:kUniqueRegionIdentifier];

    self = [super initWithProximityUUID:[CSMAppDelegate appDelegate].myUUID major:[posX doubleValue] minor:[posY doubleValue] identifier:iName];
    
    if (self) {
        self.notifyEntryStateOnDisplay = YES;     // only notify user if app is active
        self.notifyOnEntry = YES;                 // don't notify user on region entrance
        self.notifyOnExit = YES;                 // notify user on region exit
    }
    return self;
}

@end
