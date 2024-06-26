//
//  SJProcedureVariousInverse.h
//  SJBaseSequenceInvolve
//
//  Created by 畅三江 on 2024/3/18.
//

#import "SJAssociateSegmentController.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJProcedureVariousInverse : NSObject<SJVariousInverse>
- (instancetype)initWithAVPlayer:(AVPlayer *)player startPosition:(NSTimeInterval)time;

@property (nonatomic) NSTimeInterval trialEndPosition;
@property (nonatomic, strong, readonly) AVPlayer *reflectMean;
@property (nonatomic, readonly) SJDevelopbackType developBackType;
@property (nonatomic) NSTimeInterval minBufferedDuration;
@property (nonatomic) BOOL accurateSeeking;
@property (nonatomic) BOOL pauseWhenAppDidEnterBackground;

- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^_Nullable)(BOOL))completionHandler;
@end
NS_ASSUME_NONNULL_END
