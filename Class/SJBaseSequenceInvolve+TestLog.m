//
//  SJBaseSequenceInvolve+TestLog.m
//  SJBaseSequenceInvolve
//
//  Created by 畅三江 on 2019/9/11.
//

#ifdef SJDEBUG
#import "SJBaseSequenceInvolve+TestLog.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJBaseSequenceInvolve (TestLog)
- (void)showLog_TimeControlStatus {
    SJTimeControlVaryStatus status = self.timeControlStatus;
    NSString *statusStr = nil;
    switch ( status ) {
        case SJTimeControlVaryStatusPaused: {
            statusStr = [NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.TimeControlStatus.Paused\n", self];
        }
            break;
        case SJTimeControlVaryStatusWaiting: {
            NSString *reasonStr = nil;
            if      ( self.reasonForWaitingToPlay == SJWaitingToMinimizeStallsReason ) {
                reasonStr = @"WaitingToMinimizeStallsReason";
            }
            else if ( self.reasonForWaitingToPlay == SJWaitingWhileEvaluatingBufferingRateReason ) {
                reasonStr = @"WaitingWhileEvaluatingBufferingRateReason";
            }
            else if ( self.reasonForWaitingToPlay == SJWaitingWithNoAssetToPlayReason ) {
                reasonStr = @"WaitingWithNoAssetToPlayReason";
            }
            statusStr = [NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.TimeControlStatus.WaitingToPlay(Reason: %@)\n", self, reasonStr];
        }
            break;
        case SJTimeControlVaryStatusPlaying: {
            statusStr = [NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.TimeControlStatus.Playing\n", self];
        }
            break;
    }
    
    printf("%s", statusStr.UTF8String);
}
- (void)showLog_reserveStatus {
    SJDuplicateStatus status = self.reserveStatus;
    NSString *statusStr = nil;
    switch ( status ) {
        case SJDuplicateStatusUnknown:
            statusStr = [NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.reserveStatus.Unknown\n", self];
            break;
        case SJDuplicateStatusPreparing:
            statusStr = [NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.reserveStatus.Preparing\n", self];
            break;
        case SJDuplicateStatusReady:
            statusStr = [NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.reserveStatus.ReadyToPlay\n", self];
            break;
        case SJDuplicateStatusFailed:
            statusStr = [NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.reserveStatus.Failed\n", self];
            break;
    }
    
    printf("%s", statusStr.UTF8String);
}
@end
NS_ASSUME_NONNULL_END
#endif
