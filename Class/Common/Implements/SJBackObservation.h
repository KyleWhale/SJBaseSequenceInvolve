//
//  SJBackObservation.h
//  Pods
//
//  Created by 畅三江 on 2019/8/27.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVTime.h>
@class SJBaseSequenceInvolve;

NS_ASSUME_NONNULL_BEGIN

@interface SJBackObservation : NSObject
- (instancetype)initWithComment:(__kindof SJBaseSequenceInvolve *)player;

@property (nonatomic, copy, nullable) void(^backStatusDidChangeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^contentDataDidFinishExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^reserveStatusDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^timeControlStatusDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^pictureInPictureStatusDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player) API_AVAILABLE(ios(14.0));

@property (nonatomic, copy, nullable) void(^willSeekToTimeExeBlock)(__kindof SJBaseSequenceInvolve *player, CMTime time);

@property (nonatomic, copy, nullable) void(^didSeekToTimeExeBlock)(__kindof SJBaseSequenceInvolve *player, CMTime time);

@property (nonatomic, copy, nullable) void(^didReplayExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^definitionSwitchStatusDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^contentTimeDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^durationDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^playableDurationDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^presentationSizeDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^developBackTypeDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^screenLockStateDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^mutedDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^playerVolumeDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, copy, nullable) void(^rateDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *player);

@property (nonatomic, weak, readonly, nullable) __kindof SJBaseSequenceInvolve *player;

@property (nonatomic, copy, nullable) void(^didPlayToEndTimeExeBlock)(__kindof SJBaseSequenceInvolve *player) __deprecated_msg("use `contentDataDidFinishExeBlock`");

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END
