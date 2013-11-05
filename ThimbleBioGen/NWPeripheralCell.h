//
//  NWPeripheralCell.h
//  ThimbleBioGen
//
//  Created by Nicholas Wargnier on 11/5/13.
//  Copyright (c) 2013 Nicholas Wargnier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWPeripheralCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end
