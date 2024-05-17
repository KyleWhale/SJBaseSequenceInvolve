//
//  SJBaseSequenceInvolve+TestLog.h
//  SJBaseSequenceInvolve
//
//  Created by 畅三江 on 2019/9/11.
//

#ifdef SJDEBUG
#import "SJBaseSequenceInvolve.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJBaseSequenceInvolve (TestLog)
- (void)showLog_TimeControlStatus;
- (void)showLog_reserveStatus;
@end
NS_ASSUME_NONNULL_END
#endif
