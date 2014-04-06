CPKenburnsImageView
===================
### Ken Bunrs Effect

```
pod 'CPKenbunrsView', '~> 0.6.0'
```

#### Screen shots
![screenshot1](screenshot1.png)
![screenshot1](screenshot2.png)


### How to use
#### Example

```Objective-C
    CPKenburnsView *kenburnsView = [[CPKenburnsView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    kenburnsView.image = [UIImage imageNamed:@"2.png"];
    [self.view addSubview:kenbunrsView];
```

#### Options

```Objective-C
typedef NS_ENUM(NSInteger, CPKenburnsImageViewZoomCourse) {
    CPKenburnsImageViewZoomCourseRandom                = 0,
    CPKenburnsImageViewZoomCourseUpperLeftToLowerRight = 1,
    CPKenburnsImageViewZoomCourseUpperRightToLowerLeft = 2,
    CPKenburnsImageViewZoomCourseLowerLeftToUpperRight = 3,
    CPKenburnsImageViewZoomCourseLowerRightToUpperLeft = 4
};
```

```Objective-C
@interface CPKenburnsView : UIView
@property (nonatomic, copy) UIImage * image;
@property (nonatomic, assign) CGFloat animationDuration;  //default is 13.f
@property (nonatomic, assign) CGFloat zoomRatio; // default 0.1  0 ~ 1
@property (nonatomic, assign) CGFloat maxZoomRate; // default 1.2
@property (nonatomic, assign) CGFloat minZoomRate; // default 1.3
@property (nonatomic, assign) CPKenburnsImageViewZoomCourse course; // default is 0

- (void)restartMotion;
@end
```
