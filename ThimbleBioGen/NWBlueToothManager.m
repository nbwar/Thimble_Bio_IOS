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
    NSLog(@"Init");
    if (self) {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.devices = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Instance methods
-(void)startScanningForDevices
{
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}


#pragma mark - CBCentralMangerDelegate

//////////////////////////////////////////////////////////
//////////////// CBCentralManagerDelegate ////////////////
//////////////////////////////////////////////////////////

 -(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat:@"CoreBluetooth return state: %d",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
        
}

//////////////////////////////////////////////////////////
////////////////// CBPeriheralDelegate ///////////////////
//////////////////////////////////////////////////////////



@end
