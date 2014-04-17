//
//  ViewController.m
//  HTMLToString
//
//  Created by Khoi Tuan Nguyen on 4/4/14.
//  Copyright (c) 2014 Khoi Tuan Nguyen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSString *days[7]; //name of the days
    NSInteger start[7];
    NSInteger end[7];
    NSInteger pos;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Init memory space to the answer array
    _ans = [[NSMutableArray alloc] init];
    //set the starting position to zero
    pos = 0;
    
	// Do any additional setup after loading the view, typically from a nib.
    [self loadDiningMenu];
    //[self printAns];
    [self loadView];
  
}

- (void)loadView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    
    self.view = tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // this method is called for each cell and returns height
    NSString * text = [_ans objectAtIndex:indexPath.row];
    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize: 12.0] forWidth:[tableView frame].size.width - 40.0 lineBreakMode:UILineBreakModeWordWrap];
    // return either default height or height to fit the text
    return textSize.height < 44.0 ? 44.0 : textSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"YourTableCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellIdentifier];
        
        [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
        [[cell textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[cell textLabel] setFont:[UIFont systemFontOfSize: 12.0]];
    }
    // Set up the cell
    cell.textLabel.text = [_ans objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows
    return [_ans count];
}



-(void) printAns
{
    for(NSString *i in _ans)
    {
        NSLog(@"%@",i);
    }
}

- (NSString *) getDays:(NSInteger) indexOfArray
{
    return days[indexOfArray];
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
        NSString *day;
        if ([sc scanUpToString:daySplit intoString:&day]) //the variable day needs a "&" sign because it is strong
        {
            NSLog(@"-----------------------------------------------------------");
            [_ans addObject:@"------------------------------------------"];
            [self loadDay:day];
            pos++;
        }
    }
    end[6]=[_ans count];
    
    for (int i = 0; i<7; i++)
    {
        NSLog(days[i]);
        NSLog(@"%d",start[i]);
        NSLog(@"%d",end[i]);
    }
    NSLog(@"END");
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
    
    //set up the variables for the 3 arrays days, start and end
    days[pos]=today;
    start[pos]=[_ans count];
    if(pos>0)
    {
        end[pos-1]=start[pos]-1;
    }
    //add to answer array
    [_ans addObject:[NSString stringWithFormat:@"%@, %@",today, todayDate]];
    
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
    
    //add to answer
    [_ans addObject:[NSString stringWithFormat:@"   %@", mealCurrent]];
    
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
    
    //add to answer array
    [_ans addObject:[NSString stringWithFormat:@"       %@", stationCurrent]];
    
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
        NSString *dishCurrent=@"";
        [sc scanUpToString:dishStop intoString:&dishCurrent];
        
        NSLog(@"            %@",dishCurrent);
        
        //add to the answer array
        if ([dishCurrent length]>0)
        {
            [_ans addObject:[NSString stringWithFormat:@"           %@", dishCurrent]];
        }
        //Move the cursor to just before the next dish
        [sc scanUpToString:dishSplit intoString:nil];
    }
}




@end
