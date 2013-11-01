//
//  NWBlueToothManager.m
//  ThimbleBioGen
//
//  Created by Nicholas Wargnier on 11/1/13.
//  Copyright (c) 2013 Nicholas Wargnier. All rights reserved.
//

#import "NWBlueToothManager.h"

@implementation NWBlueToothManager


#pragma mark - Initializtion
+(id)sharedInstance
{
    static dispatch_once_t once;
    static NWBlueToothManager *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}


-(id)init
{
    self = [super init];
    if (self) {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.devices = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Instance methods
-(void)startScanningForDevices
{
    
}


#pragma mark - CBCentralMangerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{

}
@end
