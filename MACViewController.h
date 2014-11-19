//
//  MACViewController.h
//  TAH Motion Control
//
//  Created by Dhiraj on 24/08/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "TAHble.h"


@class CBPeripheral;
@class TAHble;

@interface MACViewController : UIViewController<BTSmartSensorDelegate>
{
    IBOutlet UILabel *ConnectionStatusLabel;

    
}


@property (strong, nonatomic) CMMotionManager *motionManager;


@property (strong, nonatomic) TAHble *sensor;
@property (strong, nonatomic) CBPeripheral *peripheral;



@end
