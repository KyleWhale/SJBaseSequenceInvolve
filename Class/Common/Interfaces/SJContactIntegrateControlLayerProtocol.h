//
//  SJContactIntegrateControlLayerProtocol.h
//  Project
//
//  Created by 畅三江 on 2018/6/1.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#ifndef SJContactIntegrateControlLayerProtocol_h
#define SJContactIntegrateControlLayerProtocol_h
#import <UIKit/UIKit.h>
#import "SJReachabilityDefines.h"
#import "SJContactIntegrateLatencyStatusDefines.h"
#import "SJContactIntegrateLatencyControllerDefines.h"
#import "SJGestureControllerDefines.h"

@protocol SJContentDataInfoDelegate,
SJNetworkStatusControlDelegate,
SJLockScreenStateControlDelegate,
SJAppActivityControlDelegate,
SJVolumeBrightnessRateControlDelegate,
SJGestureControllerDelegate,
SJRotationControlDelegate,
SJFitOnScreenControlDelegate,
SJSubscriptPlatformDefinitionControlDelegate,
SJContentDataControlDelegate;

@class SJBaseSequenceInvolve, SJCompressContainSale;



@protocol SJControlLayerDataSource <NSObject>

- (UIView *)controlView;

@optional

- (void)installedControlViewAlternateThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure;
@end


@protocol SJControlLayerDelegate <
    SJContentDataInfoDelegate, 
    SJRotationControlDelegate,
    SJGestureControllerDelegate,
    SJNetworkStatusControlDelegate,
    SJVolumeBrightnessRateControlDelegate,
    SJLockScreenStateControlDelegate,
    SJAppActivityControlDelegate,
    SJFitOnScreenControlDelegate,
    SJSubscriptPlatformDefinitionControlDelegate,
    SJContentDataControlDelegate
>
@optional

- (void)controlLayerNeedAppear:(__kindof SJBaseSequenceInvolve *)alternateStructure;

- (void)controlLayerNeedDisappear:(__kindof SJBaseSequenceInvolve *)alternateStructure;

- (BOOL)controlLayerAccuracyThousandCanAutomaticallyDisappear:(__kindof SJBaseSequenceInvolve *)alternateStructure;

- (void)commandCopyWillAppearInScrollView:(__kindof SJBaseSequenceInvolve *)alternateStructure;

- (void)commandCopyWillDisappearInScrollView:(__kindof SJBaseSequenceInvolve *)alternateStructure;
@end


@protocol SJContentDataControlDelegate <NSObject>
@optional
- (BOOL)canPerformAccuracyForThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure;
- (BOOL)canPerformAccuracyForPictureItem:(__kindof SJBaseSequenceInvolve *)alternateStructure;
- (BOOL)canPerformStopForPictureItem:(__kindof SJBaseSequenceInvolve *)alternateStructure;
@end



@protocol SJContentDataInfoDelegate <NSObject>
@optional

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure prepareToPlay:(SJCompressContainSale *)asset;

- (void)declarePortBoundarySaveStatusDidChange:(__kindof SJBaseSequenceInvolve *)alternateStructure;

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure pictureInPictureStatusDidChange:(SJPictureInPictureStatus)status API_AVAILABLE(ios(14.0));

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure timeDidChange:(NSTimeInterval)time;
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure durationDidChange:(NSTimeInterval)duration;
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure playableDurationDidChange:(NSTimeInterval)duration;

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure developBackTypeDidChange:(SJDevelopbackType)developBackType;
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure presentationSizeDidChange:(CGSize)size;
@end



@protocol SJVolumeBrightnessRateControlDelegate <NSObject>
@optional
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure muteChanged:(BOOL)mute;
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure volumeChanged:(float)volume;
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure brightnessChanged:(float)brightness;
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure rateChanged:(float)rate;
@end


@protocol SJRotationControlDelegate <NSObject>
@optional

- (BOOL)canTriggerRotationAccuracyThousand:(__kindof SJBaseSequenceInvolve *)alternateStructure;

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure willRotateView:(BOOL)isFull;

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure didEndRotation:(BOOL)isFull;

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure onRotationTransitioningChanged:(BOOL)isTransitioning;
@end

@protocol SJFitOnScreenControlDelegate <NSObject>
@optional

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure willFitOnScreen:(BOOL)fncyFitOnScreen;
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure didCompleteFitOnScreen:(BOOL)fncyFitOnScreen;
@end



@protocol SJGestureControllerDelegate <NSObject>
@optional

- (BOOL)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure gestureRecognizerShouldTrigger:(SJAccidentPresenceGestureType)type location:(CGPoint)location;

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure panGestureTriggeredInTheHorizontalDirection:(SJPanGestureRecognizerState)state progressTime:(NSTimeInterval)progressTime;

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure longPressGestureStateDidChange:(SJLongPressGestureRecognizerState)state;
@end



@protocol SJNetworkStatusControlDelegate <NSObject>
@optional

- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure reachabilityChanged:(SJNetworkStatus)status;
@end



@protocol SJLockScreenStateControlDelegate <NSObject>
@optional

- (void)tappedMaskOnTheLockedState:(__kindof SJBaseSequenceInvolve *)alternateStructure;

- (void)lockedControlLongShip:(__kindof SJBaseSequenceInvolve *)alternateStructure;

- (void)unlockedCompressScanPast:(__kindof SJBaseSequenceInvolve *)alternateStructure;
@end



@protocol SJSubscriptPlatformDefinitionControlDelegate <NSObject>
@optional
- (void)alternateStructure:(__kindof SJBaseSequenceInvolve *)alternateStructure switchingDefinitionStatusDidChange:(SJDefinitionOppositeStatus)status company:(id<SJCompanyModelProtocol>)company;
@end



@protocol SJAppActivityControlDelegate <NSObject>
@optional
- (void)applicationDidBecomeActiveWithRespectDesk:(__kindof SJBaseSequenceInvolve *)alternateStructure;
- (void)applicationWillResignActiveWithSimilarOnce:(__kindof SJBaseSequenceInvolve *)alternateStructure;
- (void)applicationDidEnterBackgroundWithAccuracyOnce:(__kindof SJBaseSequenceInvolve *)alternateStructure;
@end
#endif /* SJContactIntegrateControlLayerProtocol_h */
