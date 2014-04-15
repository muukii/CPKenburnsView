//
//  CPViewController.m
//  CPKenburnsView-Demo
//
//  Created by Muukii on 4/3/14.
//  Copyright (c) 2014 Muukii. All rights reserved.
//

#import "CPViewController.h"
#import "CPKenburnsView.h"
@interface CPViewController ()

@end

@implementation CPViewController
{
    CPKenburnsView *kenbunrsView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    kenbunrsView = [[CPKenburnsView alloc] initWithFrame:self.view.bounds];
    kenbunrsView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:kenbunrsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
