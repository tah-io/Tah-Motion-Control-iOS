//
//  PresentationViewController.h
//  TAH Motion Control
//
//  Created by Dhiraj on 22/09/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"



@class CBPeripheral;
@class TAHble;

@interface PresentationViewController : UIViewController<BTSmartSensorDelegate>

{

    IBOutlet UILabel *ConnectionStatusLabel;
    
    IBOutlet UISwipeGestureRecognizer *leftswipe;
    IBOutlet UISwipeGestureRecognizer *rightswipe;
    IBOutlet UISwipeGestureRecognizer *upswipe;
    IBOutlet UISwipeGestureRecognizer *downswipe;
    

    
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

- (IBAction)leftswipe:(id)sender;

- (IBAction)rightswipe:(id)sender;

- (IBAction)upswipe:(id)sender;

- (IBAction)downswipe:(id)sender;

@end
