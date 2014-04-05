//
//  CPGrowingViewController.m
//  CPKenburnsView-Demo
//
//  Created by Muukii on 4/4/14.
//  Copyright (c) 2014 Muukii. All rights reserved.
//

#import "CPGrowingViewController.h"
#import "CPKenburnsView.h"
@interface CPGrowingViewController ()

@end

@implementation CPGrowingViewController
{
    CPKenburnsView *kenbunrsView;
}
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
    kenbunrsView = [[CPKenburnsView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    kenbunrsView.image = [UIImage imageNamed:@"2.png"];
    [self.view addSubview:kenbunrsView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sliderValueChanged:(id)sender {
    CGRect rect = kenbunrsView.frame;
    rect.size.height = 200 + [(UISlider *)sender value] *320;
    kenbunrsView.frame = rect;
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

@end
