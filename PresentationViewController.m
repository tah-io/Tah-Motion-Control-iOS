//
//  PresentationViewController.m
//  TAH Motion Control
//
//  Created by Dhiraj on 22/09/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "PresentationViewController.h"

@interface PresentationViewController ()

@end

@implementation PresentationViewController

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
    
    // Keeps the app awake in Presentation mode
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}


-(void)viewDidDisappear:(BOOL)animated
{
 // Turn off App Awake mode    
 [UIApplication sharedApplication].idleTimerDisabled = NO;
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



- (IBAction)leftswipe:(id)sender {
    
    NSLog(@"Left Swipe");
    
    
    NSString *command = @"10M";
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
    
    
}



- (IBAction)rightswipe:(id)sender {
    
    NSLog(@"Right Swipe");
    
    NSString *command = @"20M";
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
    
    
    
}

- (IBAction)upswipe:(id)sender {
    
    NSLog(@"Up Swipe");
    
    NSString *command = @"50M";
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
    
    
    
}

- (IBAction)downswipe:(id)sender {
    
    NSLog(@"Down Swipe");
    
    NSString *command = @"40M";
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
    
    
    
}


@end
