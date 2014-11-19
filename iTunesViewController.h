//
//  iTunesViewController.h
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

@interface iTunesViewController : UIViewController<BTSmartSensorDelegate>
{
    IBOutlet UILabel *ConnectionStatusLabel;
    
    IBOutlet UIButton *play;
    IBOutlet UIButton *next;
    IBOutlet UIButton *previous;

    IBOutlet UILabel *volumesilkscreen;
    
  
    
    IBOutlet UIImageView *volumeupimage;
    IBOutlet UIImageView *volumedownimage;
    IBOutlet UIButton *volume;

    
}




@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;


- (IBAction)VolumeTouchDown:(id)sender;
- (IBAction)VolumeTouchInside:(id)sender;




@end
