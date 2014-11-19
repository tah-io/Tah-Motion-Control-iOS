//
//  WindowsViewController.h
//  TAH Motion Control
//
//  Created by Dhiraj on 24/08/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"


@class CBPeripheral;
@class TAHble;

@interface WindowsViewController : UIViewController<BTSmartSensorDelegate>
{
    IBOutlet UILabel *ConnectionStatusLabel;
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

@end
