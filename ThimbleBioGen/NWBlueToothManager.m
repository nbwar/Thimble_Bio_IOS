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
//////////////////////////////////////////////////////////
////////////////// Instance Methods //////////////////////
//////////////////////////////////////////////////////////
-(void)startScanningForDevices
{
    [self.manager scanForPeripheralsWithServices:nil options:nil];
}

-(void)stopScanningForDevices
{
    [self.manager stopScan];
}

-(void)connectToPeripheral:(CBPeripheral *)peripheral
{
    [self.manager connectPeripheral:peripheral options:nil];
}

#pragma mark - CBCentralMangerDelegate

//////////////////////////////////////////////////////////
//////////////// CBCentralManagerDelegate ////////////////
//////////////////////////////////////////////////////////

 -(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Did Update State");
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat:@"CoreBluetooth return state: %d",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
    

        
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![self.devices containsObject:peripheral]) {
        NSLog(@"Found a BLE Device : %@",peripheral);
        peripheral.delegate = self;
        
        [self.devices addObject:peripheral];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"foundPeripheral" object:peripheral];
    }
    
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectedToPeripheral" object:peripheral];
    self.connectedPeripheral = peripheral;
    NSLog(@"Connected to peripheral");
}

//////////////////////////////////////////////////////////
////////////////// CBPeriheralDelegate ///////////////////
//////////////////////////////////////////////////////////
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
}



@end
