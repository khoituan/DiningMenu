//
//  ViewController.m
//  HTMLToString
//
//  Created by Khoi Tuan Nguyen on 4/4/14.
//  Copyright (c) 2014 Khoi Tuan Nguyen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadDiningMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadDiningMenu
{
    NSURL *menuURL = [NSURL URLWithString:@"https://www.bates.edu/dining/menu/"];
    //Read html file from URL as a String
    NSString *html = [NSString stringWithContentsOfURL:menuURL encoding:NSUTF8StringEncoding error:NULL];
    //Trim the End
    NSString *trimmedString;
    NSScanner *trimEnd = [NSScanner scannerWithString: html];
    [trimEnd scanUpToString:@"<!--Start Scrape Footer-->" intoString:&trimmedString];
    NSScanner *sc = [NSScanner scannerWithString:trimmedString];
    
    //Trim the beginning
    NSString *daySplit = @"<div class=\"menu-day\"><h3>";
    [sc scanUpToString:daySplit intoString: nil];
    //Scan for the day
    while (![sc isAtEnd])
    {
        //Skip the day separator tag
        [sc scanString:daySplit intoString:nil];
        
        //Declare string day which includes all the info needed for one day
        NSString *day = nil;
        if ([sc scanUpToString:daySplit intoString:&day]) //the variable day needs a "&" sign because it is strong
        {
            //NSLog(day);
            NSLog(@"-----------------------------------------------------------");
            [self loadDay:day];
        }
    }
}

//load the content of day
- (void) loadDay:(NSString *)day
{
    NSString *mealSplit = @"<div class=\"menu-meal\"><h3>";
    NSString *dateSplit = @"<div class=\"menu-date\">";
    //String include the current day of today
    NSString *today;
    //Declare a new scanner for string day
    NSScanner *sc = [NSScanner scannerWithString:day];
    [sc scanUpToString:@"<" intoString:&today];
    
    
    NSString *todayDate;
    [sc scanUpToString:dateSplit intoString:nil];
    [sc scanString:dateSplit intoString:nil]; //skip the separator
    [sc scanUpToString:@"</div" intoString:&todayDate];
    //Printing out date
    NSLog(@"%@, %@.",today,todayDate);
    
    //Stop right before the meal
    [sc scanUpToString:mealSplit intoString:nil];
    
    while (![sc isAtEnd])
    {
        //Skip the meal separator
        [sc scanString:mealSplit intoString:nil];
        NSString *meal;
        [sc scanUpToString:mealSplit intoString:&meal];
        //load meal
        [self loadMeal:meal];
    }

}

-(void) loadMeal:(NSString *)meal
{
    //Declare another new scanner
    NSScanner *sc = [NSScanner scannerWithString:meal];
    //Declare the current meal
    NSString *mealCurrent;
    
    [sc scanUpToString:@"</h3>" intoString:&mealCurrent];
    //Print the current meal
    NSLog(@"    %@",mealCurrent);
    
    //Declare STATION separator
    NSString *stationSplit = @"<div class=\"menu-station\">";
    //Stop right before the station
    [sc scanUpToString:stationSplit intoString:nil];
    while(![sc isAtEnd])
    {
        //Skip the separator tag
        [sc scanString:stationSplit intoString:nil];
        NSString *station;
        [sc scanUpToString:stationSplit intoString:&station];
        //NSLog(station);
        //load station
        [self loadStation:station];
    }
}


//correct until here

-(void) loadStation: (NSString *)station
{
    //Delcare another another new new scanner
    NSScanner *sc = [NSScanner scannerWithString:station];
    //Delcare current station
    NSString *stationCurrent;
    
    [sc scanUpToString:@"</div><div class=\"menu-list\"><ul>" intoString:&stationCurrent];
    //Print the current station
    NSLog(@"        %@",stationCurrent);
    
    //Declare DISH separator
    NSString *dishSplit = @"<li>";
    NSString *dishStop = @"</li>";
    //NSLog(station);
    //Stop right before the dish
    [sc scanUpToString:dishSplit intoString:nil];
    
    while (![sc isAtEnd])
    {
        //Skip the DISH TAG
        [sc scanString:dishSplit intoString:nil];
        //Declare the dish name
        NSString *dishCurrent;
        [sc scanUpToString:dishStop intoString:&dishCurrent];
        NSLog(@"            %@",dishCurrent);
        //Move the cursor to just before the next dish
        [sc scanUpToString:dishSplit intoString:nil];
    }
}


@end
