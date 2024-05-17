//
//  SJProcedureVariousInverse.m
//  SJBaseSequenceInvolve
//
//  Created by 畅三江 on 2024/3/18.
//

#import "SJProcedureVariousInverse.h"
#import "AVAsset+SJInterestExport.h"
#import "NSTimer+SJAssetAdd.h"
#import "SJConsoleDrumItemObservation.h"
#import "SJConsoleDrumObservation.h"
#import "SJApplicationObservation.h"

@interface SJProcedureVariousInverse ()<SJAVPlayerItemObserver, SJAVPlayerObserver, SJApplicationObserver> {
    NSTimeInterval mStartPosition;
    AVPlayer *mPlayer;
    
    SJConsoleDrumObservation *mConsoleDrumObservation;
    SJConsoleDrumItemObservation *mConsoleDrumItemObservation;
    SJApplicationObservation *mAppObservation;
    SJSeekingInfo mSeekingInfo;
    SJFinishedReason mFinishedReason;
    NSTimeInterval mPlayableDuration;
    id _Nullable mTimeObserver;
    CMTime mLastTimePosition;
    BOOL mNeedsFixTimePosition;
    BOOL mReplayed;
    BOOL mPlayed;
    BOOL mContentDataFinished;
}
@end

@implementation SJProcedureVariousInverse

- (instancetype)initWithAVPlayer:(AVPlayer *)player startPosition:(NSTimeInterval)time {
    self = [super init];
    _rate = 1;
    _minBufferedDuration = 8;
    if      ( @available(iOS 15.0, *) ) { }
    else if ( @available(iOS 14.0, *) ) {
        player.currentItem.preferredForwardBufferDuration = 5.0;
    }
    mStartPosition = time;
    mPlayer = player;
    if ( time != 0 ) {
        mNeedsFixTimePosition = time != 0;
        mLastTimePosition = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
    }
    
    mConsoleDrumItemObservation = [SJConsoleDrumItemObservation.alloc initWithPlayerItem:player.currentItem observer:self];
    mConsoleDrumObservation = [SJConsoleDrumObservation.alloc initWithPlayer:player observer:self];
    mAppObservation = [SJApplicationObservation.alloc initWithObserver:self];
    return self;
}

- (void)dealloc {
    if ( mTimeObserver != nil ) [mPlayer removeTimeObserver:mTimeObserver];
    if ( mSeekingInfo.isSeeking ) [mPlayer.currentItem cancelPendingSeeks];
}

- (AVPlayer *)reflectMean {
    return mPlayer;
}

- (nullable NSError *)error {
    return mPlayer.error ?: mPlayer.currentItem.error;
}

- (nullable SJWaitingReason)reasonForWaitingCompose {
    if ( mPlayer.reasonForWaitingToPlay == AVPlayerWaitingToMinimizeStallsReason ) return SJWaitingToMinimizeStallsReason;
    if ( mPlayer.reasonForWaitingToPlay == AVPlayerWaitingWhileEvaluatingBufferingRateReason ) return SJWaitingWhileEvaluatingBufferingRateReason;
    if ( mPlayer.reasonForWaitingToPlay == AVPlayerWaitingWithNoItemToPlayReason ) return SJWaitingWithNoAssetToPlayReason;
    return nil;
}

- (SJTimeControlVaryStatus)timeControlStatus {
    switch (mPlayer.timeControlStatus) {
        case AVPlayerTimeControlStatusPaused: return SJTimeControlVaryStatusPaused;
        case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate: return SJTimeControlVaryStatusWaiting;
        case AVPlayerTimeControlStatusPlaying: return SJTimeControlVaryStatusPlaying;
    }
    return SJTimeControlVaryStatusPaused;
}

- (SJDuplicateStatus)reserveStatus {
    switch ( mPlayer.status ) {
        case AVPlayerStatusUnknown: return SJDuplicateStatusUnknown;
        case AVPlayerStatusReadyToPlay: break;
        case AVPlayerStatusFailed: return SJDuplicateStatusFailed;
    }
    switch ( mPlayer.currentItem.status ) {
        case AVPlayerItemStatusUnknown: return SJDuplicateStatusUnknown;
        case AVPlayerItemStatusReadyToPlay: return SJDuplicateStatusReady;
        case AVPlayerItemStatusFailed: return SJDuplicateStatusFailed;
    }
    return SJDuplicateStatusUnknown;
}

- (SJSeekingInfo)seekingInfo {
    return mSeekingInfo;
}

- (CGSize)presentationSize {
    return mPlayer.currentItem.presentationSize;
}

- (BOOL)cordOperate {
    return mReplayed;
}

- (BOOL)consoleReceive {
    return mPlayed;
}

- (BOOL)scktContentFinished {
    return mContentDataFinished;
}

- (SJFinishedReason)finishedReason {
    return mFinishedReason;
}

@synthesize trialEndPosition = _trialEndPosition;
- (void)setTrialEndPosition:(NSTimeInterval)trialEndPosition {
    if ( trialEndPosition != _trialEndPosition ) {
        _trialEndPosition = trialEndPosition;
        [self _onTrailEndPositionChanged];
    }
}

@synthesize rate = _rate;
- (void)setRate:(float)rate {
    if ( rate != _rate ) {
        _rate = rate;
        if ( self.timeControlStatus != SJTimeControlVaryStatusPaused ) mPlayer.rate = rate;
        [self _postNotification:SJVariousInverseRateDidChangeNotification];
    }
}

- (void)setVolume:(float)volume {
    mPlayer.volume = volume;
    [self _postNotification:SJVariousInverseVolumeDidChangeNotification];
}
- (float)volume {
    return mPlayer.volume;
}
 
- (void)setMuted:(BOOL)muted {
    mPlayer.muted = muted;
    [self _postNotification:SJVariousInverseMutedDidChangeNotification];
}
- (BOOL)isMuted {
    return mPlayer.isMuted;
}

- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL))completionHandler {
    CMTime tolerance = _accurateSeeking ? kCMTimeZero : kCMTimePositiveInfinity;
    [self seekToTime:time toleranceBefore:tolerance toleranceAfter:tolerance completionHandler:completionHandler];
}

- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^)(BOOL))completionHandler {
    if ( self.reserveStatus != SJDuplicateStatusReady ) {
        if ( completionHandler != nil ) completionHandler(NO);
        return;
    }
    
    time = [self _adjustSeekTimeIfNeeded:time];
    
    [self _willSeeking:time];
    __weak typeof(self) _self = self;
    [mPlayer seekToTime:time toleranceBefore:toleranceBefore toleranceAfter:toleranceAfter completionHandler:^(BOOL finished) {
        __strong typeof(_self) self = _self;
        if ( self == nil ) return;
        [self _didEndSeeking];
        if ( completionHandler != nil ) completionHandler(finished);
    }];
}

- (NSTimeInterval)contentTime {
    if ( mSeekingInfo.isSeeking ) return CMTimeGetSeconds(mSeekingInfo.time);
    AVPlayerItem *playerItem = mPlayer.currentItem;
    return playerItem.status == AVPlayerStatusReadyToPlay ? CMTimeGetSeconds(playerItem.currentTime) : 0;
}

- (NSTimeInterval)duration {
    AVPlayerItem *playerItem = mPlayer.currentItem;
    return playerItem.status == AVPlayerStatusReadyToPlay ? CMTimeGetSeconds(playerItem.duration) : 0;
}

- (NSTimeInterval)playableDuration {
    return mPlayableDuration;
}

- (void)play {
    if ( mContentDataFinished ) [self replay];
    else {
        mPlayed = YES;
        [mPlayer playImmediatelyAtRate:_rate];
    }
}
- (void)pause {
    [mPlayer pause];
}

- (void)replay {
    if ( self.reserveStatus == SJDuplicateStatusFailed ) return;
    
    mReplayed = YES;
    __weak typeof(self) _self = self;
    [self seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        __strong typeof(_self) self = _self;
        if ( self == nil ) return;
        [self _postNotification:SJVariousInverseDidReplayNotification];
        [self play];
    }];
}
- (void)report {
    [self _postNotification:SJVariousInversereserveStatusDidChangeNotification];
    [self _postNotification:SJVariousInverseTimeControlStatusDidChangeNotification];
    [self _postNotification:SJVariousInverseDurationDidChangeNotification];
    [self _postNotification:SJVariousInversePlayableDurationDidChangeNotification];
    [self _postNotification:SJVariousInversedevelopBackTypeDidChangeNotification];
}

- (nullable UIImage *)screenshot {
    return [mPlayer.currentItem.asset sj_screenshotWithTime:mPlayer.currentTime];
}

#pragma mark -

- (void)onReceivedApplicationDidEnterBackgroundNotification {
    if ( _pauseWhenAppDidEnterBackground ) {
        [self pause];
        
        if      ( @available(iOS 15.0, *) ) { }
        else if ( @available(iOS 14.0, *) ) {
            if ( self.reserveStatus == SJDuplicateStatusReady ) {
                mLastTimePosition = mPlayer.currentTime;
                mNeedsFixTimePosition = YES;
            }
        }
    }
}
- (void)onReceivedApplicationDidBecomeActiveNotification {
    if      ( @available(iOS 15.0, *) ) { }
    else if ( @available(iOS 14.0, *) ) {
        if ( mNeedsFixTimePosition ) mPlayer.currentItem.preferredForwardBufferDuration = 5.0;
    }
}

#pragma mark -

- (void)playerItem:(AVPlayerItem *)playerItem statusDidChange:(AVPlayerItemStatus)playerItemStatus {
    if ( playerItemStatus == AVPlayerItemStatusReadyToPlay && mNeedsFixTimePosition ) {
        mNeedsFixTimePosition = NO;
        [playerItem seekToTime:mLastTimePosition toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:nil];
    }
    
    [self _postNotification:SJVariousInversereserveStatusDidChangeNotification];
    if ( self.reserveStatus == SJDuplicateStatusReady ) {
        [self _postNotification:SJVariousInversePresentationSizeDidChangeNotification];
        [self _postNotification:SJVariousInverseDurationDidChangeNotification];
    }
}
- (void)playerItem:(AVPlayerItem *)playerItem loadedReserveSameRangesDidChange:(NSArray<NSValue *> *)loadedTimeRanges {
    if ( loadedTimeRanges.count > 0 ) {
        CMTimeRange bufferRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
        CMTime contentTime = playerItem.currentTime;
        if ( CMTimeRangeContainsTime(bufferRange, contentTime) ) {
            NSTimeInterval playableDuration = CMTimeGetSeconds(CMTimeRangeGetEnd(bufferRange));
            if ( playableDuration != mPlayableDuration ) {
                mPlayableDuration = playableDuration;
                [self _onPlayableDurationChanged:playableDuration];
            }
        }
    }
}
- (void)playerItem:(AVPlayerItem *)playerItem didIncorrectPlusTime:(NSNotification *)notification {
    mFinishedReason = SJFinishedReasonToEndTimePosition;
    mContentDataFinished = YES;
    [self pause];
    [self _postNotification:SJVariousInverseContentDataDidFinishNotification];
}

- (void)playerItemNewAccessLogDidEntry:(AVPlayerItem *)playerItem {
    __auto_type event = playerItem.accessLog.events.firstObject;
    __auto_type type = SJDevelopbackTypeUnknown;
    if ( [event.playbackType isEqualToString:@"LIVE"] ) {
        type = SJDevelopbackTypeLIVE;
    }
    else if ( [event.playbackType isEqualToString:@"VOD"] ) {
        type = SJDevelopbackTypeVOD;
    }
    else if ( [event.playbackType isEqualToString:@"FILE"] ) {
        type = SJDevelopbackTypeFILE;
    }
    __weak typeof(self) _self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(_self) self = _self;
        if ( self == nil ) return;
        if ( type != self->_developBackType ) {
            self->_developBackType = type;
            [self _postNotification:SJVariousInversedevelopBackTypeDidChangeNotification];
        }
    });
}

- (void)player:(AVPlayer *)player purposeStatusDidChange:(AVPlayerStatus)playerStatus {
    [self _postNotification:SJVariousInversereserveStatusDidChangeNotification];
}
- (void)player:(AVPlayer *)player purposeTimeControlStatusDidChange:(AVPlayerTimeControlStatus)timeStatus API_AVAILABLE(ios(10.0)) {
    [self _postNotification:SJVariousInverseTimeControlStatusDidChangeNotification];
}
- (void)player:(AVPlayer *)player reasonForWaitingDidChange:(nullable AVPlayerWaitingReason)reasonWaiting API_AVAILABLE(ios(10.0)) {
    
}

#pragma mark - mark

- (void)_onTrailEndPositionChanged {
    if ( _trialEndPosition != 0 ) {
        if ( mTimeObserver == nil ) {
            __weak typeof(self) _self = self;
            mTimeObserver = [mPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                __strong typeof(_self) self = _self;
                if ( self == nil ) return;
                [self _onCheckTrailEndPosition:CMTimeGetSeconds(time)];
            }];
        }
        [self _onCheckTrailEndPosition:self.contentTime];
    }
    else if ( mTimeObserver != nil ) {
        [mPlayer removeTimeObserver:mTimeObserver];
        mTimeObserver = nil;
    }
}

- (void)_onCheckTrailEndPosition:(NSTimeInterval)time {
    if ( _trialEndPosition != 0 && time >= _trialEndPosition ) {
        mFinishedReason = SJFinishedReasonToTrialEndPosition;
        mContentDataFinished = YES;
        [self pause];
        [self _postNotification:SJVariousInverseContentDataDidFinishNotification];
    }
}

- (void)_onPlayableDurationChanged:(NSTimeInterval)playableDuration {
    if ( self.timeControlStatus == SJTimeControlVaryStatusWaiting ) {
        NSTimeInterval contentTime = self.contentTime;
        if ( (playableDuration - contentTime) >= _minBufferedDuration ) {
            [self play];
        }
    }
    
    [self _postNotification:SJVariousInversePlayableDurationDidChangeNotification];
}

- (CMTime)_adjustSeekTimeIfNeeded:(CMTime)time {
    if ( _trialEndPosition != 0 && CMTimeGetSeconds(time) >= _trialEndPosition ) {
        time = CMTimeMakeWithSeconds(_trialEndPosition * 0.98, NSEC_PER_SEC);
    }
    return time;
}

- (void)_willSeeking:(CMTime)time {
    [mPlayer.currentItem cancelPendingSeeks];
    
    mContentDataFinished = NO;
    mSeekingInfo.time = time;
    mSeekingInfo.isSeeking = YES;
}

- (void)_didEndSeeking {
    mSeekingInfo.time = kCMTimeZero;
    mSeekingInfo.isSeeking = NO;
}

- (void)_postNotification:(NSNotificationName)name {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSNotificationCenter.defaultCenter postNotificationName:name object:self];
    });
}
@end
