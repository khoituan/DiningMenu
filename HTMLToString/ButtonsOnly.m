//
//  ButtonsOnly.m
//  HTMLToString
//
//  Created by Khoi Tuan Nguyen on 4/11/14.
//  Copyright (c) 2014 Khoi Tuan Nguyen. All rights reserved.
//

#import "ButtonsOnly.h"
#import "ViewController.h"
#import "ViewController.m"

@interface ButtonsOnly ()

@end

@implementation ButtonsOnly

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
    [self setUpTheButtons];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpTheButtons
{
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", segue.identifier);
    //All segue identifier are in the form button# where # is the number of the day
    NSString *buttonPressed = [segue.identifier substringFromIndex:5];
    NSLog(buttonPressed);
    
}

@end
