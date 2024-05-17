//
//  SJDeviceVolumeAndBrightnessControllerProtocol.h
//  Pods
//
//  Created by 畅三江 on 2019/1/5.
//

#ifndef SJDeviceVolumeAndBrightnessControllerProtocol_h
#define SJDeviceVolumeAndBrightnessControllerProtocol_h
#import <UIKit/UIKit.h>
@protocol SJDeviceVolumeAndBrightnessTargetViewContext, SJDeviceVolumeAndBrightnessControllerObserver;

NS_ASSUME_NONNULL_BEGIN
@protocol SJDeviceVolumeAndBrightnessController <NSObject>
- (id<SJDeviceVolumeAndBrightnessControllerObserver>)getObserver;
@property (nonatomic) float volume;
@property (nonatomic) float brightness;

@property (nonatomic, weak, nullable) UIView *target;
@property (nonatomic, strong, nullable) id<SJDeviceVolumeAndBrightnessTargetViewContext> targetViewContext;

- (void)onTargetViewMoveToWindow;
- (void)onTargetViewContextUpdated;
@end

@protocol SJDeviceVolumeAndBrightnessTargetViewContext <NSObject>
@property (nonatomic, readonly) BOOL indntImplement;
@property (nonatomic, readonly) BOOL fncyFitOnScreen;
@property (nonatomic, readonly) BOOL pridFindOnScrollView;
@property (nonatomic, readonly) BOOL rgrdExcludeAppeared;
@property (nonatomic, readonly) BOOL slidFloatingMode;
@property (nonatomic, readonly) BOOL slidPictureInPictureMode;
@end

@protocol SJDeviceVolumeAndBrightnessControllerObserver
@property (nonatomic, copy, nullable) void(^volumeDidChangeExeBlock)(id<SJDeviceVolumeAndBrightnessController> mgr, float volume);
@property (nonatomic, copy, nullable) void(^brightnessDidChangeExeBlock)(id<SJDeviceVolumeAndBrightnessController> mgr, float brightness);
@end
NS_ASSUME_NONNULL_END
#endif /* SJDeviceVolumeAndBrightnessControllerProtocol_h */
