//
//  NWBlueToothManager.h
//  ThimbleBioGen
//
//  Created by Nicholas Wargnier on 11/1/13.
//  Copyright (c) 2013 Nicholas Wargnier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NWBlueToothManager : NSObject < CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBPeripheral *connectedPeripheral;
@property (strong,nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) NSMutableArray *devices;


-(void)startScanningForDevices;

+(id)sharedInstance;

@end
