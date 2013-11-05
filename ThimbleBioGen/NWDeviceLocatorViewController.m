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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NotificationCenter method

-(void)foundPeripheral:(NSNotification *)notification
{
    if([[notification name] isEqualToString:@"foundPeripheral"])
        NSLog(@"Peripheral found called via notification center");
}

#pragma mark - Table view data source

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
            NSLog(@"SHOULD BE SPINNING");
            [cell.activityIndicatorView startAnimating];
        }

    } else {
        static NSString *CellIdentifier = @"PeripheralCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        CBPeripheral *peripheral = [self.peripherals objectAtIndex:indexPath.row];
        cell.nameLabel.text = peripheral.name;
    }
    
    // Configure the cell...
    
    return cell;
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
