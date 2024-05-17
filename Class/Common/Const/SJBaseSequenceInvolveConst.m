//
//  SJBaseSequenceInvolveConst.m
//  Pods
//
//  Created by 畅三江 on 2019/8/6.
//

#import "SJBaseSequenceInvolveConst.h"
#import "SJContactIntegrateLatencyStatusDefines.h"

NS_ASSUME_NONNULL_BEGIN

NSInteger const SJAccidentPresenceViewTag = 0xFFFFFFF0;
NSInteger const SJPresentViewTag = 0xFFFFFFF1;

@implementation SJAccidentPresenceZIndexes
+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] _init];
    });
    return instance;
}

- (instancetype)_init {
    self = [super init];
    if ( self ) {
        _textPopupViewZIndex = -10;
        _promptingPopupViewZIndex = -20;
        _controlLayerViewZIndex = -30;
        _danmakuViewZIndex = -40;
        _placeholderImageViewZIndex = -50;
        _watermarkViewZIndex = -60;
        _subtitleViewZIndex = -70;
        _contentDataViewZIndex = -80;
    }
    return self;
}
@end

NSNotificationName const SJContactIntegratereserveStatusDidChangeNotification = @"SJContactIntegratereserveStatusDidChangeNotification";

NSNotificationName const SJContactIntegrateDefinitionSwitchStatusDidChangeNotification = @"SJContactIntegrateDefinitionSwitchStatusDidChangeNotification";

NSNotificationName const SJContactIntegrateURLAssetWillChangeNotification = @"SJContactIntegrateURLAssetWillChangeNotification";

NSNotificationName const SJContactIntegrateURLAssetDidChangeNotification = @"SJContactIntegrateURLAssetDidChangeNotification";

NSNotificationName const SJContactIntegrateApplicationDidEnterBackgroundNotification = @"SJContactIntegrateApplicationDidEnterBackgroundNotification";

NSNotificationName const SJContactIntegrateApplicationWillEnterForegroundNotification = @"SJContactIntegrateApplicationWillEnterForegroundNotification";

NSNotificationName const SJContactIntegrateApplicationWillTerminateNotification = @"SJContactIntegrateApplicationWillTerminateNotification";

NSNotificationName const SJContactIntegrateContentDataControllerWillDeallocateNotification = @"SJContactIntegrateContentDataControllerWillDeallocateNotification";

NSNotificationName const SJContactIntegrateContentDataTimeControlStatusDidChangeNotification = @"SJContactIntegrateContentDataTimeControlStatusDidChangeNotification";

NSNotificationName const SJContactIntegratePictureInPictureStatusDidChangeNotification = @"SJContactIntegratePictureInPictureStatusDidChangeNotification";

NSNotificationName const SJContactIntegrateContentDataDidFinishNotification = @"SJContactIntegrateContentDataDidFinishNotification";

NSNotificationName const SJContactIntegrateContentDataDidReplayNotification = @"SJContactIntegrateContentDataDidReplayNotification";

NSNotificationName const SJContactIntegrateContentDataWillStopNotification = @"SJContactIntegrateContentDataWillStopNotification";

NSNotificationName const SJContactIntegrateContentDataDidStopNotification = @"SJContactIntegrateContentDataDidStopNotification";

NSNotificationName const SJContactIntegrateContentDataWillRefreshNotification = @"SJContactIntegrateContentDataWillRefreshNotification";

NSNotificationName const SJContactIntegrateContentDataDidRefreshNotification = @"SJContactIntegrateContentDataDidRefreshNotification";

NSNotificationName const SJContactIntegrateContentDataWillSeekNotification = @"SJContactIntegrateContentDataWillSeekNotification";

NSNotificationName const SJContactIntegrateContentDataDidSeekNotification = @"SJContactIntegrateContentDataDidSeekNotification";

NSNotificationName const SJContactIntegrateContentTimeDidChangeNotification = @"SJContactIntegrateContentTimeDidChangeNotification";

NSNotificationName const SJContactIntegrateDurationDidChangeNotification = @"SJContactIntegrateDurationDidChangeNotification";

NSNotificationName const SJContactIntegratePlayableDurationDidChangeNotification = @"SJContactIntegratePlayableDurationDidChangeNotification";

NSNotificationName const SJContactIntegratePresentationSizeDidChangeNotification = @"SJContactIntegratePresentationSizeDidChangeNotification";

NSNotificationName const SJContactIntegratedevelopBackTypeDidChangeNotification = @"SJContactIntegratedevelopBackTypeDidChangeNotification";

NSNotificationName const SJContactIntegrateScreenLockStateDidChangeNotification = @"SJContactIntegrateScreenLockStateDidChangeNotification";

NSNotificationName const SJContactIntegrateMutedDidChangeNotification = @"SJContactIntegrateMutedDidChangeNotification";

NSNotificationName const SJContactIntegrateVolumeDidChangeNotification = @"SJContactIntegrateVolumeDidChangeNotification";

NSNotificationName const SJContactIntegrateRateDidChangeNotification = @"SJContactIntegrateRateDidChangeNotification";


SJWaitingReason const SJWaitingToMinimizeStallsReason = @"AVPlayerWaitingToMinimizeStallsReason";
SJWaitingReason const SJWaitingWhileEvaluatingBufferingRateReason = @"AVPlayerWaitingWhileEvaluatingBufferingRateReason";
SJWaitingReason const SJWaitingWithNoAssetToPlayReason = @"AVPlayerWaitingWithNoItemToPlayReason";

SJFinishedReason const SJFinishedReasonToEndTimePosition = @"SJFinishedReasonToEndTimePosition";
SJFinishedReason const SJFinishedReasonToTrialEndPosition = @"SJFinishedReasonToTrialEndPosition";

NSString *const SJContactIntegrateNotificationUserInfoKeySeekTime = @"time";
NS_ASSUME_NONNULL_END
