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

#import "CPKenburnsView.h"
@interface CPKenburnsImageView : UIImageView

@end

@implementation CPKenburnsImageView

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [self.layer addAnimation:[CATransition animation] forKey:kCATransition];
}
@end

@interface CPKenburnsView ()
@property (nonatomic, strong) CPKenburnsImageView * imageView;
@property (nonatomic, assign) CGRect initRect;
@property (nonatomic, assign) CGAffineTransform startTransform;
@property (nonatomic, assign) CGRect moveRect;
@property (nonatomic, assign) CGAffineTransform endTransform;
@property (nonatomic, assign) CGRect restartRect;
@end
@implementation CPKenburnsView
{
    CGSize initImageViewSize;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
        [self configureAnimation];
    }
    return self;
}

- (void)configureView
{
    self.imageView = [[CPKenburnsImageView alloc] initWithFrame:self.bounds];
    self.autoresizesSubviews = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageView];
    self.clipsToBounds = YES;
}

- (void)setFrame:(CGRect)frame
{
    self.restartRect = [self.imageView.layer.presentationLayer frame];
    NSLog(@"%@",NSStringFromCGRect(self.restartRect));
    [super setFrame:frame];
//    [self initImageViewSize:self.imageView.image];
//    [self resetTransforms];
//    self.imageView.frame = self.initRect;
//    [self motion];
}

- (void)configureAnimation
{
    self.animationDuration = 15.f;
}

- (void)configureTransforms
{
    CPKenburnsImageViewZoomCourse cource = self.course ? self.course : (CPKenburnsImageViewZoomCourse)arc4random()%4 + 1;
    self.course = cource;
    [self setZoomRects:cource];
    self.restartRect = self.initRect;
    self.imageView.frame = self.initRect;
}

- (void)resetTransforms
{
    [self setZoomRects:self.course];
}

- (void)setZoomRects:(CPKenburnsImageViewZoomCourse)cource
{
    switch (cource) {
        case CPKenburnsImageViewZoomCourseUpperLeftToLowerRight:
            self.initRect = [self zoomRect:CPKenburnsImageViewZoomPointUpperLeft zoomRate:1.3];
            self.moveRect = [self zoomRect:CPKenburnsImageViewZoomPointLowerRight zoomRate:1.1];
            break;
        case CPKenburnsImageViewZoomCourseUpperRightToLowerLeft:
            self.initRect = [self zoomRect:CPKenburnsImageViewZoomPointUpperRight zoomRate:1.35];
            self.moveRect = [self zoomRect:CPKenburnsImageViewZoomPointLowerLeft zoomRate:1.12];
            break;
        case CPKenburnsImageViewZoomCourseLowerLeftToUpperRight:
            self.initRect = [self zoomRect:CPKenburnsImageViewZoomPointLowerLeft zoomRate:1.2];
            self.moveRect = [self zoomRect:CPKenburnsImageViewZoomPointUpperRight zoomRate:1.3];
            break;
        case CPKenburnsImageViewZoomCourseLowerRightToUpperLeft:
            self.initRect = [self zoomRect:CPKenburnsImageViewZoomPointLowerRight zoomRate:1.23];
            self.moveRect = [self zoomRect:CPKenburnsImageViewZoomPointUpperLeft zoomRate:1.1];
            break;
        case CPKenburnsImageViewZoomCourseRandom:
            [self configureTransforms];
            break;
    }
}

- (void)setImage:(UIImage *)image
{
    [self initImageViewSize:image];
    [self configureTransforms];
    [self motion];
}

- (void)initImageViewSize:(UIImage *)image
{
    const CGSize imageSize = image.size;
    const CGFloat width = CGRectGetWidth(self.bounds);
    const CGFloat height = CGRectGetHeight(self.bounds);

    CGFloat power;
    CGSize resizedImageSize;
    const CGFloat selfLongSize = MAX(CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds));

        //写真のサイズに合わせる
    if (imageSize.width > imageSize.height) {
            //横長
        power = selfLongSize / imageSize.height;
        resizedImageSize = CGSizeMake(imageSize.width * power, imageSize.height * power);
    } else if (imageSize.width == imageSize.height) {
            //正方形
        power = height / imageSize.height;
        resizedImageSize = CGSizeMake(width, height);
    } else {
            //縦長
        power = selfLongSize / imageSize.width;
        resizedImageSize = CGSizeMake(imageSize.width * power, imageSize.height * power);
    }
    CGRect imageViewRect = self.imageView.bounds;
    imageViewRect.size = resizedImageSize;
    self.imageView.bounds = imageViewRect;
    self.imageView.image = image;
    initImageViewSize = resizedImageSize;
}

- (void)restartMotion
{
    [self configureTransforms];
    [self motion];
}
- (void)motion
{
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        self.imageView.transform = translatedAndScaledTransformUsingViewRect(self.moveRect,self.imageView.frame);
    } completion:^(BOOL finished) {
    }];
}

- (CGRect)zoomRect:(CPKenburnsImageViewZoomPoint)zoomPoint zoomRate:(CGFloat)zoomRate
{
    CGSize imageSize = initImageViewSize;
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
    return zoomRect;
}

CGAffineTransform
translatedAndScaledTransformUsingViewRect(CGRect viewRect,CGRect fromRect)
{
    CGSize scales = CGSizeMake(viewRect.size.width/fromRect.size.width, viewRect.size.height/fromRect.size.height);
    CGPoint offset = CGPointMake(CGRectGetMidX(viewRect) - CGRectGetMidX(fromRect), CGRectGetMidY(viewRect) - CGRectGetMidY(fromRect));
    return CGAffineTransformMake(scales.width, 0, 0, scales.height, offset.x, offset.y);
}

CGAffineTransform
scaleFromSizeToSize(CGSize fromSize,CGSize toSize)
{
    CGSize scales = CGSizeMake(toSize.width/fromSize.width, toSize.height/fromSize.height);
    return CGAffineTransformMakeScale(scales.width,scales.height);
}

@end
