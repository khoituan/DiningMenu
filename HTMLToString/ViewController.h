//
//  ViewController.h
//  HTMLToString
//
//  Created by Khoi Tuan Nguyen on 4/4/14.
//  Copyright (c) 2014 Khoi Tuan Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

//declare method to get the name of the day
- (NSString *) getDays:(NSInteger) indexOfArray;

@property NSMutableArray *ans;
@property NSInteger increment;


@property (strong, nonatomic) IBOutlet UITableView *tableView;



@end
