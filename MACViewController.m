//
//  MACViewController.m
//  TAH Motion Control
//
//  Created by Dhiraj on 24/08/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import "MACViewController.h"
#import "iTunesViewController.h"
#import "PresentationViewController.h"

@interface MACViewController ()
{
    NSString *command;
}
@end

@implementation MACViewController

@synthesize sensor;
@synthesize peripheral;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Settings Up Sensor Delegate
    self.sensor.delegate = self;
    
     // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
    
    // Starts gyro updates
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = .1;
    
    [self updateall];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    // Starts gyro updates
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;
    self.motionManager.gyroUpdateInterval = .1;
    
    [self updateall];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [self.motionManager stopGyroUpdates];
    [self.motionManager stopAccelerometerUpdates];
    
    NSLog(@"Motion Sensor Stopped");
}



///////////// Update Device Connection Status Image //////////
-(void)UpdateConnectionStatusLabel
{
    
    
    if (sensor.activePeripheral.state)
    {
        
        ConnectionStatusLabel.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    else
    {
        
        ConnectionStatusLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//////////////////////// Preparing Segue for Navigation //////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Changes title of the Back Button in destintion controller
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    
    
    if ([[segue identifier] isEqualToString:@"media"])
    {
        
        iTunesViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        
        detailViewController.title = @"Media Player";
        
    }
    
    
    else if ([[segue identifier] isEqualToString:@"presentation"])
    {
        
        PresentationViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.sensor = self.sensor;
        
        
        detailViewController.title = @"Presentation";
        
    }
    
 

    
    
}

//////////////////////////////////////////////////////////////////////////////////



//recv data
-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@",value);
}



-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    NSLog(@"%@",(__bridge NSString*)s);
    
}

-(void)setDisconnect
{
    [sensor disconnect:sensor.activePeripheral];
    
    NSLog(@"TAH Device Disconnected");
    
    
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    /////////////////////////////////////////////
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
}



-(void) updateall
{
  
        
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMGyroData *gyroData, NSError *error) {
                                            [self outputRotationData:gyroData.rotationRate];
                                        }];
        
        NSLog(@"Motion Sensor Started");


    
    
}


-(void)outputRotationData:(CMRotationRate)rotation
{
    
    
    /*
     NSLog(@"X Rotation: %.2f", rotation.x);
     NSLog(@"Y Rotation: %.2f", rotation.y);
     NSLog(@"Z Rotation: %.2f", rotation.z);
     */
    
    

    

    if (rotation.x >= 6.0) {
        
        
        
        NSLog(@"Right to Left");
        
        NSString *RtoL = @"65M";
        
        command = [NSString stringWithFormat:@"%@",RtoL];
        [self sendCommand];
    }
    
    
    
    
    
    
    else if (rotation.x <= -6.0)
    {
        
        
        NSLog(@"Left to Right");
        
        NSString *LtoR = @"56M";
        
        command = [NSString stringWithFormat:@"%@",LtoR];
        
        [self sendCommand];
        
    }
    


    
    
    
    if (rotation.z >= 6.0) {
        
        
        
        NSLog(@"Up to Down");
        
        
        NSString *UtoD = @"34M";
        
        command = [NSString stringWithFormat:@"%@",UtoD];
        
        [self sendCommand];
        
    }
    
     
    
    else if (rotation.z <= -6.0)
    {
        
        
        
        NSLog(@"Down to Up");
        
        NSString *DtoU = @"43M";
        
        command = [NSString stringWithFormat:@"%@",DtoU];
        
        [self sendCommand];
    }
    
    
}


- (void)sendCommand
{
    
    //////// Bluetoth Data to be Sent will come below ///////////
    
    NSLog(@"%@",command);  // Shows Commans Value in Xcode O/P WIndow
    
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    [sensor write:sensor.activePeripheral data:data];
    
    /////////////////////////////////////////////////////////////
    
    [self updateall];
    
}



@end
