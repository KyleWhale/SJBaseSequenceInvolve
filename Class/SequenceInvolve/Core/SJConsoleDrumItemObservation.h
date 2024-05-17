//
//  SJConsoleDrumItemObservation.h
//  player
//
//  Created by 畅三江 on 2023/8/8.
//

#import <AVFoundation/AVFoundation.h>
@protocol SJAVPlayerItemObserver;

NS_ASSUME_NONNULL_BEGIN
@interface SJConsoleDrumItemObservation : NSObject
- (instancetype)initWithPlayerItem:(AVPlayerItem *)playerItem observer:(id<SJAVPlayerItemObserver>)observer;

@property (nonatomic, weak, readonly, nullable) id<SJAVPlayerItemObserver> observer;
@end

@protocol SJAVPlayerItemObserver <NSObject>
- (void)playerItem:(AVPlayerItem *)playerItem statusDidChange:(AVPlayerItemStatus)playerItemStatus;
- (void)playerItem:(AVPlayerItem *)playerItem loadedReserveSameRangesDidChange:(NSArray<NSValue *> *)loadedTimeRanges;
- (void)playerItem:(AVPlayerItem *)playerItem didIncorrectPlusTime:(NSNotification *)notification;
- (void)playerItemNewAccessLogDidEntry:(AVPlayerItem *)playerItem;
@end
NS_ASSUME_NONNULL_END
