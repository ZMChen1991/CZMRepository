//
//  TestViewController.m
//  testDemo
//
//  Created by lm on 16/9/27.
//  Copyright © 2016年 Czm. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titleArray = @[@"one",@"two",@"stree",@"four", @"five", @"six", @"seven"];
    
    UITableViewController *oneVC = [[UITableViewController alloc] init];
    UIViewController *twoVC = [[UIViewController alloc] init];
    UITableViewController *threeVC = [[UITableViewController alloc] init];
    UIViewController *fourVC = [[UIViewController alloc] init];
    UITableViewController *fiveVC = [[UITableViewController alloc] init];
    UIViewController *sixVC = [[UIViewController alloc] init];
    UITableViewController *sevenVC = [[UITableViewController alloc] init];
    
    self.controllerArray = @[oneVC, twoVC, threeVC, fourVC, fiveVC, sixVC, sevenVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
