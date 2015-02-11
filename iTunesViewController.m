//
//  iTunesViewController.m
//  TAH Motion Control
//
//  Created by Dhiraj on 24/08/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "iTunesViewController.h"


@interface iTunesViewController ()
{
    NSString *command;
}
@end

@implementation iTunesViewController

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
    
    // Initialize command string
    command = @" ";
    
    // Starts gyro updates
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;
    self.motionManager.gyroUpdateInterval = .1;
    
    [self updateall];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



-(void)viewWillAppear:(BOOL)animated
{
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
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
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self MotionPad:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
    
    
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
    

    
    if (rotation.x >= 6.0  && !volume.touchInside)
    {
        
        NSLog(@"Right to Left");
        [sensor TAHTrackPad:sensor.activePeripheral Swipe:Left];
        
    }
    
    
    else if (rotation.x <= -6.0  &&  !volume.touchInside)
    {
        
        NSLog(@"Left to Right");
        [sensor TAHTrackPad:sensor.activePeripheral Swipe:Right];
        
    }
    
    else if (previous.touchInside)
    {
        
        NSLog(@"Left Arrow Key");
        [sensor TAHkeyPress:sensor.activePeripheral Press:KEY_LEFT_ARROW];
        
    }
    
    if (next.touchInside)
    {
        
        NSLog(@"Right Arrow key");
        [sensor TAHkeyPress:sensor.activePeripheral Press:KEY_RIGHT_ARROW];
    }
    
    
    
    else if (rotation.z >= 6.0  && !volume.touchInside )
    {
        
        NSLog(@"Up to Down");
        [sensor TAHTrackPad:sensor.activePeripheral Swipe:Down];
        
    }
    
    else if (play.touchInside)
    {
        
        NSLog(@"Space Bar");
        [sensor TAHkeyPress:sensor.activePeripheral Press:KEY_SPACE];
        
    }
    
    
    else if (rotation.z <= -6.0)
    {
        
        NSLog(@"Down to Up");
        [sensor TAHTrackPad:sensor.activePeripheral Swipe:Up];
    }
    
    
   else if(!volume.touchInside)
    {
        command = @"0,0,0,0M";
        NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
        [sensor write:sensor.activePeripheral data:data];

    }

    
}




- (void)MotionPad:(CMAcceleration)acceleration
{
   /*
    NSLog(@"X acceleration:%.2f",acceleration.x);
    NSLog(@"Y acceleration:%.2f",acceleration.y);
    NSLog(@"Z acceleration:%.2f",acceleration.z);
*/
    
    if (volume.touchInside  && acceleration.x > 0.6)
    {
 
        [self volumeupanimate];
        [volumedownimage stopAnimating];
        [sensor TAHkeyPress:sensor.activePeripheral Press:VolumeUp];
    }
    
    
    else if (volume.touchInside  && acceleration.x < -0.6)
    {
        
        [self volumedownanimate];
        [volumeupimage stopAnimating];
        [sensor TAHkeyPress:sensor.activePeripheral Press:VolumeDown];
    }
    
    [self updateall];
    
}

-(void)volumeupanimate
{
    volumeupimage.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"up red.png"],
                                 [UIImage imageNamed:@"up white.png"],nil];
    [volumeupimage setAnimationRepeatCount:-1];
    volumeupimage.animationDuration = 0.5;
    [volumeupimage startAnimating];
}


-(void)volumedownanimate
{
    volumedownimage.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"down red.png"],
                                     [UIImage imageNamed:@"down white.png"],nil];
    [volumedownimage setAnimationRepeatCount:-1];
    volumedownimage.animationDuration = 0.5;
    [volumedownimage startAnimating];
}






- (IBAction)VolumeTouchDown:(id)sender {
    
    volumesilkscreen.hidden = NO;
    volumeupimage.hidden = NO;
    volumedownimage.hidden = NO;


}

- (IBAction)VolumeTouchInside:(id)sender {
    
    volumesilkscreen.hidden = YES;
    volumeupimage.hidden = YES;
    volumedownimage.hidden = YES;
    
    [volumeupimage stopAnimating];
    [volumedownimage stopAnimating];
    
}
@end
