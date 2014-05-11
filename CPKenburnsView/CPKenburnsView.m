    //
    //CPKenburnsImageView.m
    //
    //The MIT License (MIT)
    //Copyright © 2014 Muukii (www.muukii.me)
    //
    //Permission is hereby granted, free of charge, to any person obtaining a copy
    //of this software and associated documentation files (the “Software”), to deal
    //in the Software without restriction, including without limitation the rights
    //to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    //copies of the Software, and to permit persons to whom the Software is
    //furnished to do so, subject to the following conditions:
    //
    //The above copyright notice and this permission notice shall be included in
    //all copies or substantial portions of the Software.
    //
    //THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    //IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    //FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    //AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    //LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    //OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    //THE SOFTWARE.

#import "CPKenBurnsView.h"


@implementation CPKenburnsImageView

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [self.layer addAnimation:[CATransition animation] forKey:kCATransition];
}
@end

@interface CPKenburnsView ()
@property (nonatomic) CGAffineTransform startTransform;
@property (nonatomic) CGAffineTransform endTransform;
@property (nonatomic, strong) UIImageView *reduceImageView;
@end
@implementation CPKenburnsView
{
    CGRect initImageViewFrame;
    CGRect currentImageViewRect;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initParams];
        [self configureView];
        [self configureReduceImageView];
        [self configureAnimation];
    }
    return self;
}

- (void)configureView
{
    [self.imageView removeFromSuperview];
    self.imageView = [[CPKenburnsImageView alloc] initWithFrame:self.bounds];
    self.startTransform = CGAffineTransformIdentity;
    self.endTransform = CGAffineTransformIdentity;
    self.autoresizesSubviews = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.imageView];
}

- (void)configureReduceImageView
{
    if (self.reduceImageView) {
        self.imageView.hidden = NO;
        [self.reduceImageView setImage:nil];
        [self.reduceImageView removeFromSuperview];
        [self stopImageViewAnimation:NO];
        self.reduceImageView = nil;
    }
    self.reduceImageView = [[UIImageView alloc] init];
    self.reduceImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)initParams
{
    self.startZoomRate = 1.2;
    self.endZoomRate = 1.4;
    self.padding = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)configureAnimation
{
    self.animationDuration = 15.f;
}

- (void)configureTransforms
{
    self.course = self.course == CPKenburnsImageViewZoomCourseRandom ? ((CPKenburnsImageViewZoomCourse)arc4random_uniform(4)) + 1 : self.course;
    [self setZoomRects:self.course];
}

- (void)resetTransforms
{
    [self setZoomRects:self.course];
}

- (void)setZoomRects:(CPKenburnsImageViewZoomCourse)cource
{
    CGRect startRect;
    CGRect endRect;
    switch (cource) {
        case CPKenburnsImageViewZoomCourseUpperLeftToLowerRight:
            startRect = [self zoomRect:CPKenburnsImageViewZoomPointUpperLeft zoomRate:adjustZoomRate(self.startZoomRate, self.zoomRatio)];
            endRect = [self zoomRect:CPKenburnsImageViewZoomPointLowerRight zoomRate:adjustZoomRate(self.endZoomRate, self.zoomRatio)];
            break;
        case CPKenburnsImageViewZoomCourseUpperRightToLowerLeft:
            startRect = [self zoomRect:CPKenburnsImageViewZoomPointUpperRight zoomRate:adjustZoomRate(self.startZoomRate, self.zoomRatio)];
            endRect = [self zoomRect:CPKenburnsImageViewZoomPointLowerLeft zoomRate:adjustZoomRate(self.endZoomRate, self.zoomRatio)];
            break;
        case CPKenburnsImageViewZoomCourseLowerLeftToUpperRight:
            startRect = [self zoomRect:CPKenburnsImageViewZoomPointLowerLeft zoomRate:adjustZoomRate(self.startZoomRate, self.zoomRatio)];
            endRect = [self zoomRect:CPKenburnsImageViewZoomPointUpperRight zoomRate:adjustZoomRate(self.endZoomRate, self.zoomRatio)];
            break;
        case CPKenburnsImageViewZoomCourseLowerRightToUpperLeft:
            startRect = [self zoomRect:CPKenburnsImageViewZoomPointLowerRight zoomRate:adjustZoomRate(self.startZoomRate, self.zoomRatio)];
            endRect = [self zoomRect:CPKenburnsImageViewZoomPointUpperLeft zoomRate:adjustZoomRate(self.endZoomRate, self.zoomRatio)];
            break;
        case CPKenburnsImageViewZoomCourseRandom:
            NSAssert(@"Random is not support", nil);
            return;
    }
    self.startTransform = translatedAndScaledTransformUsingViewRect(startRect, initImageViewFrame);
    self.endTransform = translatedAndScaledTransformUsingViewRect(endRect, initImageViewFrame);
}

- (void)setImage:(UIImage *)image
{
    if (image == nil) {
        self.imageView.image = nil;
        return;
    }
    _image = image;
    [self initImageViewSize:image];
    [self configureReduceImageView];
    [self configureTransforms];
    [self motion];
}

- (void)setStartZoomRate:(CGFloat)startZoomRate
{
    _startZoomRate = startZoomRate;
    [self initImageViewSize:self.image];
    [self configureTransforms];
    [self motion];
}

- (void)setEndZoomRate:(CGFloat)endZoomRate
{
    _endZoomRate = endZoomRate;
    [self initImageViewSize:self.image];
    [self configureTransforms];
    [self motion];
}

- (void)setPadding:(UIEdgeInsets)padding
{
    _padding = padding;
}

- (void)setAnimationDuration:(CGFloat)animationDuration
{
    _animationDuration = animationDuration;
    [self restartMotion];
}

- (void)initImageViewSize:(UIImage *)image
{
    if (!image) {
        return;
    }

    CGSize imageSize = image.size;
    CGFloat power;
    CGSize resizedImageSize;
    CGFloat selfLongSide = MAX(CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds));

        //adjust to image size
    if (imageSize.width >= imageSize.height) {
        //width > height
        power = selfLongSide / imageSize.height;
        resizedImageSize = CGSizeMake(imageSize.width * power, imageSize.height * power);
    } else {
        //height > width
        power = selfLongSide / imageSize.width;
        resizedImageSize = CGSizeMake(imageSize.width * power, imageSize.height * power);
    }

    self.imageView.transform = CGAffineTransformIdentity;
    CGRect imageViewRect = self.imageView.bounds;
    imageViewRect.size = resizedImageSize;
    self.imageView.frame = imageViewRect;
    self.imageView.image = image;
    initImageViewFrame = self.imageView.frame;
}

- (void)restartMotion
{
    [self initImageViewSize:self.image];
    [self configureTransforms];
    [self motion];
}
- (void)motion
{
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.imageView.transform = self.startTransform;
        self.imageView.transform = self.endTransform;
    } completion:^(BOOL finished) {
    
    }];
}

- (CGRect)zoomRect:(CPKenburnsImageViewZoomPoint)zoomPoint zoomRate:(CGFloat)zoomRate
{
    CGSize imageSize = initImageViewFrame.size;
    CGSize zoomSize;
    CGPoint point;
    zoomSize = CGSizeMake(imageSize.width*zoomRate,imageSize.height*zoomRate);

    CGFloat y = -(fabs(zoomSize.height - CGRectGetHeight(self.bounds)));
    CGFloat x = -(fabs(zoomSize.width - CGRectGetWidth(self.bounds)));

    switch (zoomPoint) {
        case CPKenburnsImageViewZoomPointLowerLeft:
            point = CGPointMake(0, y);
            break;
        case CPKenburnsImageViewZoomPointLowerRight:
            point = CGPointMake(x, y);
            break;
        case CPKenburnsImageViewZoomPointUpperLeft:
            point = CGPointMake(0,0);
            break;
        case CPKenburnsImageViewZoomPointUpperRight:
            point = CGPointMake(x, 0);
            break;
    }
    CGRect zoomRect;
    zoomRect.size = zoomSize;
    zoomRect.origin = point;

    UIEdgeInsets padding;

    padding.bottom = -self.padding.bottom;
    padding.left = -self.padding.left;
    padding.top = -self.padding.top;
    padding.right = -self.padding.right;

    zoomRect = UIEdgeInsetsInsetRect(zoomRect, padding);
    return zoomRect;
}

CGFloat
adjustZoomRate(CGFloat zoomRate,CGFloat ratio)
{
    return zoomRate;
}

CGAffineTransform
translatedAndScaledTransformUsingViewRect(CGRect viewRect,CGRect fromRect)
{
    CGSize scales = CGSizeMake(viewRect.size.width/fromRect.size.width, viewRect.size.height/fromRect.size.height);
    CGPoint offset = CGPointMake(CGRectGetMidX(viewRect) - CGRectGetMidX(fromRect), CGRectGetMidY(viewRect) - CGRectGetMidY(fromRect));
    return CGAffineTransformMake(scales.width, 0, 0, scales.width, offset.x, offset.y);
}

- (void)showWholeImage
{
    //image view animation pause
    [self stopImageViewAnimation:YES];
    //reduced image view
    CALayer *imageLayer = [self.imageView.layer presentationLayer];
    currentImageViewRect = imageLayer.frame;
    self.reduceImageView.frame = currentImageViewRect;
    self.reduceImageView.image = self.image;
    [self addSubview:self.reduceImageView];
    self.imageView.hidden = YES;
    //calc reductionRation
    CGFloat reductionRatio;
    if (self.image.size.width >= self.image.size.height) {
         reductionRatio = self.bounds.size.width / initImageViewFrame.size.width;
        if (CGRectApplyAffineTransform(initImageViewFrame, CGAffineTransformMakeScale(reductionRatio, reductionRatio)).size.height >= self.bounds.size.height) {
            reductionRatio = self.bounds.size.height / initImageViewFrame.size.height;
        }
    }else {
        reductionRatio = self.bounds.size.height / initImageViewFrame.size.height;
        if (CGRectApplyAffineTransform(initImageViewFrame, CGAffineTransformMakeScale(reductionRatio, reductionRatio)).size.width >= self.bounds.size.width) {
            reductionRatio = self.bounds.size.width / initImageViewFrame.size.width;
        }
    }
    //imageView reduction with animation
    [UIView animateWithDuration:.35f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reduceImageView.bounds = CGRectApplyAffineTransform(initImageViewFrame, CGAffineTransformMakeScale(reductionRatio, reductionRatio));
        self.reduceImageView.center = self.center;
    }completion:^(BOOL finished){
        if (finished){
            [UIView animateWithDuration:.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.reduceImageView.bounds = CGRectApplyAffineTransform(initImageViewFrame, CGAffineTransformMakeScale(reductionRatio + .03f, reductionRatio + .03f));
            }completion:^(BOOL finished) {
                if (finished){
                    [UIView animateWithDuration:.1f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.reduceImageView.bounds = CGRectApplyAffineTransform(initImageViewFrame, CGAffineTransformMakeScale(reductionRatio, reductionRatio));
                    } completion:nil
                     ];}
            }];
        }}];
}

- (void)zoomAndRestartAnimation
{
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.reduceImageView.frame = currentImageViewRect;
    }completion:^(BOOL finished) {
        if (finished){
            self.imageView.hidden = NO;
            [self.reduceImageView setImage:nil];
            [self.reduceImageView removeFromSuperview];
            [self stopImageViewAnimation:NO];}
    }];
}
- (void)stopImageViewAnimation:(BOOL)stop
{
    if (stop)
    {
        CFTimeInterval stoppedTime = [self.imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.imageView.layer.speed = 0;
        self.imageView.layer.timeOffset = stoppedTime;
    }
    else
    {
        CFTimeInterval stoppedTime = self.imageView.layer.timeOffset;
        self.imageView.layer.speed = 1.0f;
        self.imageView.layer.beginTime = 0;
        self.imageView.layer.timeOffset = 0;
        CFTimeInterval timeSinceStopped = [self.imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - stoppedTime;
        self.imageView.layer.beginTime = timeSinceStopped;
    }
}

@end
