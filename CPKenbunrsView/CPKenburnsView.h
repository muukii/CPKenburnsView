//
//  CPKenburnsImageView.h
//  heyday
//
//  Created by Muukii on 3/29/14.
//  Copyright (c) 2014 Muukii. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CPKenburnsImageViewZoomPoint) {
    CPKenburnsImageViewZoomPointLowerLeft,
    CPKenburnsImageViewZoomPointLowerRight,
    CPKenburnsImageViewZoomPointUpperLeft,
    CPKenburnsImageViewZoomPointUpperRight,
};

@interface CPKenburnsView : UIView
@property (nonatomic, copy) UIImage * image;
@property (nonatomic, assign) CGFloat animationDuration;  //default is 13.f

- (void)motion;
- (void)restartMotion;
@end
