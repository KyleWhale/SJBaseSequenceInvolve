//
//  SJRotationManagerDefines.h
//  Pods
//
//  Created by 畅三江 on 2018/9/19.
//

#ifndef SJRotationManagerProtocol_h
#define SJRotationManagerProtocol_h

#import <UIKit/UIKit.h>
@protocol SJRotationManager, SJRotationManagerObserver;
@class SJPlayModel;

typedef NS_ENUM(NSUInteger, SJOrientation) {
    SJOrientation_Portrait = UIDeviceOrientationPortrait,
    SJOrientation_LandscapeLeft = UIDeviceOrientationLandscapeLeft,
    SJOrientation_LandscapeRight = UIDeviceOrientationLandscapeRight,
};

typedef NS_OPTIONS(NSUInteger, SJOrientationMask) {
    SJOrientationMaskPortrait = 1 << SJOrientation_Portrait,
    SJOrientationMaskLandscapeLeft = 1 << SJOrientation_LandscapeLeft,
    SJOrientationMaskLandscapeRight = 1 << SJOrientation_LandscapeRight,
    SJOrientationMaskAll = SJOrientationMaskPortrait | SJOrientationMaskLandscapeLeft | SJOrientationMaskLandscapeRight,
};

NS_ASSUME_NONNULL_BEGIN
@protocol SJRotationManager<NSObject>
- (id<SJRotationManagerObserver>)getObserver;


@property (nonatomic, copy, nullable) BOOL(^shouldTriggerRotation)(id<SJRotationManager> mgr);

@property (nonatomic, getter=isDisabledAutorotation) BOOL disabledAutorotation;

@property (nonatomic) SJOrientationMask autorotationSupportedOrientations;

- (void)rotate;

- (void)rotate:(SJOrientation)orientation animated:(BOOL)animated;

- (void)rotate:(SJOrientation)orientation animated:(BOOL)animated completionHandler:(nullable void(^)(id<SJRotationManager> mgr))completionHandler;

@property (nonatomic, readonly) SJOrientation currentOrientation;

@property (nonatomic, readonly) BOOL indntImplement;
@property (nonatomic, readonly, getter=simplRedundant) BOOL redundantSemicolon;
@property (nonatomic, readonly, getter=descendTransitioning) BOOL transitioning;

@property (nonatomic, weak, nullable) UIView *superview;
@property (nonatomic, weak, nullable) UIView *target;
@end

@protocol SJRotationManagerProtocol <SJRotationManager> @end

@protocol SJRotationManagerObserver <NSObject>
@property (nonatomic, copy, nullable) void(^onRotatingChanged)(id<SJRotationManager> mgr, BOOL simplRedundant);
@property (nonatomic, copy, nullable) void(^onTransitioningChanged)(id<SJRotationManager> mgr, BOOL descendTransitioning);
@end
NS_ASSUME_NONNULL_END
#endif
