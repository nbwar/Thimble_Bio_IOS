//
//  NWDeviceLocatorViewController.m
//  ThimbleBioGen
//
//  Created by Nicholas Wargnier on 11/1/13.
//  Copyright (c) 2013 Nicholas Wargnier. All rights reserved.
//

#import "NWDeviceLocatorViewController.h"
#import "NWBlueToothManager.h"
#import "NWPeripheralCell.h"

@interface NWDeviceLocatorViewController ()

@property (strong, nonatomic) NSMutableArray *peripherals;
@property (nonatomic) BOOL isScanning;
@end

@implementation NWDeviceLocatorViewController



//////////////////////////////////////////////////////////
//////////////////// Instantiation ///////////////////////
//////////////////////////////////////////////////////////

-(NSMutableArray *)peripherals
{
    if (!_peripherals) _peripherals = [[NSMutableArray alloc] init];
    return _peripherals;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundPeripheral:) name:@"foundPeripheral" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectedToPeripheral:) name:@"connectedToPeripheral" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - NotificationCenter method
//////////////////////////////////////////////////////////
///////////////// Notification Center ////////////////////
//////////////////////////////////////////////////////////

-(void)foundPeripheral:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"foundPeripheral"]) {
        NSLog(@"Peripheral found called via notification center %@", notification.object);
        [self.peripherals addObject:notification.object];
        [self.tableView reloadData];
    }
    
    
}

-(void)connectedToPeripheral:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"connectedToPeripheral"]) {
        NSLog(@"Connected to peripheral via notification center");
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source
//////////////////////////////////////////////////////////
///////////////////// Table View /////////////////////////
//////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else
    {
        return self.peripherals.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NWPeripheralCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"ScanCell" forIndexPath:indexPath];
        
        if (self.isScanning == YES) {
            [cell.activityIndicatorView startAnimating];
        }

    } else {
        static NSString *CellIdentifier = @"PeripheralCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
        cell.nameLabel.text = peripheral.name;
        
        if ([[NWBlueToothManager sharedInstance] connectedPeripheral] == peripheral) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }


    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CBPeripheral *peripheral = self.peripherals[indexPath.row];
        [[NWBlueToothManager sharedInstance] connectToPeripheral:peripheral];
        [self.tableView reloadData];
        NWPeripheralCell *cell = (NWPeripheralCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.activityIndicatorView startAnimating];
    }

    
    
}


#pragma mark - IBActions

//////////////////////////////////////////////////////////
////////////////////// IBActions /////////////////////////
//////////////////////////////////////////////////////////

- (IBAction)backButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didToggleScanSwitch:(UISwitch *)sender
{
    UISwitch *scanSwitch = sender;
    if (scanSwitch.on == YES) {
        self.isScanning = YES;
        [[NWBlueToothManager sharedInstance] startScanningForDevices];

    } else {
        self.isScanning = NO;
        [[NWBlueToothManager sharedInstance] stopScanningForDevices];
    }
    [self.tableView reloadData];
}

@end
