//
//  NWBlueToothManager.m
//  ThimbleBioGen
//
//  Created by Nicholas Wargnier on 11/1/13.
//  Copyright (c) 2013 Nicholas Wargnier. All rights reserved.
//

#import "NWBlueToothManager.h"

@implementation NWBlueToothManager


+(id)sharedInstance
{
    static dispatch_once_t once;
    static NWBlueToothManager *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}
@end
