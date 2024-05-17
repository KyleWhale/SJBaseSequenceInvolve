//
//  SJContactIntegrateLatencyStatusDefines.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2017/11/29.
//  Copyright © 2017年 changsanjiang. All rights reserved.
//

#ifndef SJContactIntegrateLatencyStatusDefines_h
#define SJContactIntegrateLatencyStatusDefines_h
@class SJBaseSequenceInvolve;

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SJDevelopbackType) {
    SJDevelopbackTypeUnknown,
    SJDevelopbackTypeLIVE,
    SJDevelopbackTypeVOD,
    SJDevelopbackTypeFILE
};

typedef NS_ENUM(NSInteger, SJDuplicateStatus) {

    SJDuplicateStatusUnknown,

    SJDuplicateStatusPreparing,

    SJDuplicateStatusReady,

    SJDuplicateStatusFailed
};

typedef NS_ENUM(NSInteger, SJTimeControlVaryStatus) {

    SJTimeControlVaryStatusPaused,

    SJTimeControlVaryStatusWaiting,

    SJTimeControlVaryStatusPlaying
};


#pragma mark -


typedef NSString *SJWaitingReason;

extern SJWaitingReason const SJWaitingToMinimizeStallsReason;

extern SJWaitingReason const SJWaitingWhileEvaluatingBufferingRateReason;

extern SJWaitingReason const SJWaitingWithNoAssetToPlayReason;


#pragma mark -


typedef NSString *SJFinishedReason;

extern SJFinishedReason const SJFinishedReasonToEndTimePosition;

extern SJFinishedReason const SJFinishedReasonToTrialEndPosition;


#pragma mark -


typedef NS_ENUM(NSInteger, SJDefinitionOppositeStatus) {
    SJDefinitionOppositeStatusUnknown,
    SJDefinitionOppositeStatusSwitching,
    SJDefinitionOppositeStatusFinished,
    SJDefinitionOppositeStatusFailed,
};
NS_ASSUME_NONNULL_END
#endif /* SJContactIntegrateLatencyStatusDefines_h */
