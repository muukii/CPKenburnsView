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
    kenbunrsView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:kenbunrsView];
    
    //long press to show whole image
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showWholeImage:)];
    longPress.minimumPressDuration = .3f;
    [kenbunrsView addGestureRecognizer:longPress];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sliderValueChanged:(id)sender {
    CGRect rect = kenbunrsView.frame;
    rect.size.height = 200 + [(UISlider *)sender value] *280;
    kenbunrsView.frame = rect;
}
- (IBAction)choiceImage:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            kenbunrsView.image = [UIImage imageNamed:@"1.jpg"];
            break;
        case 1:
            kenbunrsView.image = [UIImage imageNamed:@"2.png"];
            break;
        case 2:
            kenbunrsView.image = [UIImage imageNamed:@"3.jpg"];
            break;
        case 3:
            kenbunrsView.image = nil;
            break;
        default:
            break;
    }
}

- (void)showWholeImage:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [kenbunrsView showWholeImage];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [kenbunrsView zoomAndRestartAnimation];
            break;
        default:
            break;
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

@end
