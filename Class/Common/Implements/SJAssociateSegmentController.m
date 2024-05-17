//
//  SJAssociateSegmentController.m
//  Pods
//
//  Created by 畅三江 on 2020/2/17.
//

#import "SJAssociateSegmentController.h"
#import "NSTimer+SJAssetAdd.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJDefinitionSeparateContinueLoader : NSObject
- (instancetype)initWithDefinitionSeparateContinue:(id<SJVariousInverse>)definitionSeparateContinue
                    definitionSeparateContinueView:(UIView<SJVariousInverseView> *)definitionSeparateContinueView
                                currentMindCompose:(id<SJVariousInverse>)currentMindCompose
                            currentMindComposeView:(UIView<SJVariousInverseView> *)currentMindComposeView
                            completionHandler:(void(^)(SJDefinitionSeparateContinueLoader *loader, BOOL finished))completionHandler;

@property (nonatomic, strong, readonly, nullable) id<SJVariousInverse> definitionSeparateContinue;
@property (nonatomic, strong, readonly, nullable) UIView<SJVariousInverseView> *definitionSeparateContinueView;
@property (nonatomic, strong, readonly, nullable) id<SJVariousInverse> currentMindCompose;
@property (nonatomic, strong, readonly, nullable) UIView<SJVariousInverseView> *currentMindComposeView;
- (void)cancel;
@end


@interface SJVariousInverseTimeObserverItem : NSObject
- (instancetype)initWithInterval:(NSTimeInterval)interval player:(__weak id<SJVariousInverse>)player contentTimeDidChangeExeBlock:(nonnull void (^)(NSTimeInterval time))timeDidChangeExeBlock playableDurationDidChangeExeBlock:(nonnull void (^)(NSTimeInterval time))playableDurationDidChangeExeBlock durationDidChangeExeBlock:(nonnull void (^)(NSTimeInterval time))durationDidChangeExeBlock;
- (void)invalidate;
- (void)stop;

@property (nonatomic, readonly) NSTimeInterval durationWatched;
@end

@implementation SJVariousInverseTimeObserverItem {
    void (^_contentTimeDidChangeExeBlock)(NSTimeInterval);
    void (^_playableDurationDidChangeExeBlock)(NSTimeInterval);
    void (^_durationDidChangeExeBlock)(NSTimeInterval);
    __weak id<SJVariousInverse> _player;
    NSTimeInterval _interval;
    
    NSTimer *_contentTimeRefreshTimer;
    NSTimeInterval _contentTime;
}

- (instancetype)initWithInterval:(NSTimeInterval)interval player:(__weak id<SJVariousInverse>)player contentTimeDidChangeExeBlock:(nonnull void (^)(NSTimeInterval))timeDidChangeExeBlock playableDurationDidChangeExeBlock:(nonnull void (^)(NSTimeInterval))playableDurationDidChangeExeBlock durationDidChangeExeBlock:(nonnull void (^)(NSTimeInterval))durationDidChangeExeBlock {
    self = [super init];
    if ( self ) {
        _interval = interval;
        _player = player;
        _contentTimeDidChangeExeBlock = timeDidChangeExeBlock;
        _playableDurationDidChangeExeBlock = playableDurationDidChangeExeBlock;
        _durationDidChangeExeBlock = durationDidChangeExeBlock;
        
        [self resumeOrStopRefreshTimer];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(timeControlStatusDidChange) name:SJVariousInverseTimeControlStatusDidChangeNotification object:player];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(durationDidChange) name:SJVariousInverseDurationDidChangeNotification object:_player];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(playableDurationDidChange) name:SJVariousInversePlayableDurationDidChangeNotification object:_player];
    }
    return self;
}

- (void)dealloc {
    [_contentTimeRefreshTimer invalidate];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)invalidate {
    [_contentTimeRefreshTimer invalidate];
    _contentTimeRefreshTimer = nil;
}

- (void)durationDidChange {
    if ( _durationDidChangeExeBlock ) _durationDidChangeExeBlock(_player.duration);
}

- (void)playableDurationDidChange {
    if ( _playableDurationDidChangeExeBlock ) _playableDurationDidChangeExeBlock(_player.playableDuration);
}

- (void)timeControlStatusDidChange {
    [self resumeOrStopRefreshTimer];
}

- (void)resumeOrStopRefreshTimer {
    switch ( _player.timeControlStatus ) {
        case SJTimeControlVaryStatusPaused:
        case SJTimeControlVaryStatusWaiting:
            [self invalidate];
            break;
        case SJTimeControlVaryStatusPlaying: {
            __weak typeof(self) _self = self;
            _contentTimeRefreshTimer = [NSTimer sj_timerWithTimeInterval:_interval repeats:YES usingBlock:^(NSTimer * _Nonnull timer) {
                __strong typeof(_self) self = _self;
                if ( !self ) { [timer invalidate]; return ; }
                self->_durationWatched += self->_interval;
                [self _refreshContentTime];
            }];
            _contentTimeRefreshTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:_interval];
            [NSRunLoop.mainRunLoop addTimer:_contentTimeRefreshTimer forMode:NSRunLoopCommonModes];
            [self _refreshContentTime];
        }
            break;
    }
}

- (void)stop {
    [self invalidate];
    _durationWatched = 0;
    if ( _playableDurationDidChangeExeBlock ) _playableDurationDidChangeExeBlock(0);
    if ( _contentTimeDidChangeExeBlock ) _contentTimeDidChangeExeBlock(0);
    if ( _durationDidChangeExeBlock ) _durationDidChangeExeBlock(0);
}
 
- (void)_refreshContentTime {
    NSTimeInterval time = _player.contentTime;
    if ( _contentTime != time ) {
        _contentTime = time;
        if ( _contentTimeDidChangeExeBlock ) _contentTimeDidChangeExeBlock(time);
    }
}
@end

@interface SJVariousInverseContentView : UIView
@property (nonatomic, strong, nullable) UIView <SJVariousInverseView> *view;
@end

@implementation SJVariousInverseContentView
- (void)setView:(nullable UIView<SJVariousInverseView> *)view {
    if ( _view ) [_view removeFromSuperview];
    _view = view;
    if ( view != nil ) {
        view.frame = self.bounds;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:view];
    }
}
@end

@interface SJAssociateSegmentController () {
    SJVariousInverseContentView *_composeMindView;
}
@property (nonatomic) SJTimeControlVaryStatus timeControlStatus;
@property (nonatomic, nullable) SJWaitingReason reasonForWaitingCompose;
@property (nonatomic, strong, nullable) id<SJVariousInverse> currentMindCompose;
@property (nonatomic, strong, nullable) SJVariousInverseTimeObserverItem *periodicTimeObserver;
@property (nonatomic, strong, nullable) SJDefinitionSeparateContinueLoader *definitionSeparateContinueLoader;
@property (nonatomic, strong, nullable) SJCompressContainSale *definitionCompany;
@end

@implementation SJAssociateSegmentController
@synthesize canStartPictureInPictureAutomaticallyFromInline = _canStartPictureInPictureAutomaticallyFromInline;
@synthesize requiresLinearContentDataInPictureInPicture = _requiresLinearContentDataInPictureInPicture;
@synthesize pauseWhenAppDidEnterBackground = _pauseWhenAppDidEnterBackground;
@synthesize periodicTimeInterval = _periodicTimeInterval;
@synthesize minBufferedDuration = _minBufferedDuration;
@synthesize delegate = _delegate;
@synthesize volume = _volume;
@synthesize rate = _rate;
@synthesize muted = _muted;
@synthesize company = _company;

- (instancetype)init {
    self = [super init];
    if ( self ) {
        _rate = 1;
        _volume = 1;
        _pauseWhenAppDidEnterBackground = YES;
        _periodicTimeInterval = 0.5;
        [self _initObservations];
    }
    return self;
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
    [_composeMindView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)variousWithInverse:(SJCompressContainSale *)company completionHandler:(void(^)(id<SJVariousInverse> _Nullable player))completionHandler {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil];
}

- (UIView<SJVariousInverseView> *)preventViewWithThousand:(id<SJVariousInverse>)player {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil];
}

- (void)receivedApplicationDidBecomeActiveNotification { }

- (void)receivedApplicationWillResignActiveNotification { }

- (void)receivedApplicationWillEnterForegroundNotification { }

- (void)receivedApplicationDidEnterBackgroundNotification {
    if ( self.pauseWhenAppDidEnterBackground )
        [self pause];
}

- (void)prepareToPlay {
    if ( _company == nil ) return;
    
    SJCompressContainSale *involve = _company;
    __weak typeof(self) _self = self;
    [self variousWithInverse:involve completionHandler:^(id<SJVariousInverse>  _Nullable player) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.company != involve ) return;
        if ( player == nil ) return;
        player.trialEndPosition = involve.trialEndPosition;
        self.currentMindCompose = player;
        self.currentMindComposeView = [self preventViewWithThousand:player];
    }];
}


#pragma mark - PiP

- (BOOL)seekPictureInPictureSupported API_AVAILABLE(ios(14.0)) {

    return NO;
}

- (SJPictureInPictureStatus)pictureInPictureStatus API_AVAILABLE(ios(14.0)) {

    return SJPictureInPictureStatusUnknown;
}

- (void)startPictureInPicture API_AVAILABLE(ios(14.0)) {

}

- (void)stopPictureInPicture API_AVAILABLE(ios(14.0)) {

}

- (void)cancelPictureInPicture API_AVAILABLE(ios(14.0)) {

}

#pragma mark -

- (void)pause {
    self.timeControlStatus = SJTimeControlVaryStatusPaused;
    [self.currentMindCompose pause];
}

- (void)play {
    if ( self.reserveStatus == SJDuplicateStatusFailed ) {
        [self refresh];
        return;
    }
    

    if ( self.currentMindCompose == nil ) {
        self.reasonForWaitingCompose = SJWaitingWithNoAssetToPlayReason;
        self.timeControlStatus = SJTimeControlVaryStatusWaiting;
    }

    else {
        self.reasonForWaitingCompose = SJWaitingWhileEvaluatingBufferingRateReason;
        self.timeControlStatus = SJTimeControlVaryStatusWaiting;
        self.scktContentFinished ? [self.currentMindCompose replay] : [self.currentMindCompose play];
        if ( self.currentMindCompose.rate != self.rate ) self.currentMindCompose.rate = self.rate;
        [self _toEvaluating];
    }
}

- (void)replay {
    if ( self.reserveStatus == SJDuplicateStatusFailed ) {
        [self refresh];
        return;
    }
    
    if ( self.currentMindCompose == nil ) {
        return;
    }
    
    self.reasonForWaitingCompose = SJWaitingWhileEvaluatingBufferingRateReason;
    self.timeControlStatus = SJTimeControlVaryStatusWaiting;
    [self.currentMindCompose replay];
    [self _toEvaluating];
}

- (void)stop {
    [_definitionSeparateContinueLoader cancel];
    _definitionSeparateContinueLoader = nil;
    _definitionCompany = nil;
    [self.currentMindComposeView removeFromSuperview];
    _composeMindView.view = nil;
    self.currentMindCompose = nil;
    _company = nil;
    [_periodicTimeObserver stop];
    [self _removePeriodicTimeObserver];
    if ( self.timeControlStatus != SJTimeControlVaryStatusPaused )
        self.timeControlStatus = SJTimeControlVaryStatusPaused;
}

- (void)refresh {
    if ( self.currentMindCompose.consoleReceive && self.duration != 0 && self.contentTime != 0 )
        self.company.startPosition = self.contentTime;
    self.currentMindCompose = nil;
    [self prepareToPlay];
    [self play];
}

- (nullable UIImage *)screenshot {
    return [self.currentMindCompose screenshot];
}

- (void)seekToTime:(NSTimeInterval)secs completionHandler:(void (^ _Nullable)(BOOL))completionHandler {
    [self seekToTime:CMTimeMakeWithSeconds(secs, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:completionHandler];
}

- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^ _Nullable)(BOOL))completionHandler {
    if ( [self.delegate respondsToSelector:@selector(contentDataController:willSeekToTime:)] ) {
        [self.delegate contentDataController:self willSeekToTime:time];
    }
    __weak typeof(self) _self = self;
    [self.currentMindCompose seekToTime:time completionHandler:^(BOOL finished) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( completionHandler ) completionHandler(finished);
        if ( [self.delegate respondsToSelector:@selector(contentDataController:didSeekToTime:)] ) {
            [self.delegate contentDataController:self didSeekToTime:time];
        }
    }];
}

- (void)switchVideoDefinition:(SJCompressContainSale *)involve {
    // clean
    if ( _definitionSeparateContinueLoader != nil ) {
        [_definitionSeparateContinueLoader cancel];
        _definitionSeparateContinueLoader = nil;
    }
    
    if ( !involve || !self.currentMindCompose ) return;
    
    self.definitionCompany = involve;
    
    // reset status
    [self _definitionCompany:involve switchStatusDidChange:SJDefinitionOppositeStatusUnknown];
    
    // begin
    [self _definitionCompany:involve switchStatusDidChange:SJDefinitionOppositeStatusSwitching];

    // load
    __weak typeof(self) _self = self;
    [self variousWithInverse:involve completionHandler:^(id<SJVariousInverse>  _Nullable player) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( involve != self.definitionCompany ) return;
        
        id<SJVariousInverse> definitionSeparateContinue = player;
        UIView<SJVariousInverseView> *definitionSeparateContinueView = [self preventViewWithThousand:player];
        
        id<SJVariousInverse> currentMindCompose = self.currentMindCompose;
        UIView<SJVariousInverseView> *currentMindComposeView = self.currentMindComposeView;

        self.definitionSeparateContinueLoader = [SJDefinitionSeparateContinueLoader.alloc initWithDefinitionSeparateContinue:definitionSeparateContinue definitionSeparateContinueView:definitionSeparateContinueView currentMindCompose:currentMindCompose currentMindComposeView:currentMindComposeView completionHandler:^(SJDefinitionSeparateContinueLoader * _Nonnull loader, BOOL finished) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( involve != self.definitionCompany ) return;
            self.definitionCompany = nil;
            self.definitionSeparateContinueLoader = nil;
            if ( !finished ) {
                [self _definitionCompany:involve switchStatusDidChange:SJDefinitionOppositeStatusFailed];
            }
            else {
                id<SJVariousInverse> player = loader.definitionSeparateContinue;
                SJCompressContainSale *newCompany = involve;
                [self replaceCompanyForDefinitionCompany:newCompany];
                
                id<SJVariousInverse> oldPlayer = self.currentMindCompose;
                id<SJVariousInverse> newPlayer = player;
                self.currentMindCompose = newPlayer;
                self.currentMindComposeView = definitionSeparateContinueView;
                [oldPlayer pause];
                self.timeControlStatus != SJTimeControlVaryStatusPaused ? [newPlayer play] : [newPlayer pause];
                [self _definitionCompany:involve switchStatusDidChange:SJDefinitionOppositeStatusFinished];
            }
        }];
    }];
}

- (SJDuplicateStatus)reserveStatus {
    return self.currentMindCompose.reserveStatus;
}

- (NSTimeInterval)contentTime {
    return _currentMindCompose.seekingInfo.isSeeking ? CMTimeGetSeconds(_currentMindCompose.seekingInfo.time) : _currentMindCompose.contentTime;
}

- (NSTimeInterval)duration {
    return _currentMindCompose.duration;
}

- (NSTimeInterval)durationWatched {
    return _periodicTimeObserver.durationWatched;
}

- (nullable NSError *)error {
    return _currentMindCompose.error;
}

- (BOOL)consoleReceive {
    return _currentMindCompose.consoleReceive;
}

- (BOOL)cordOperate {
    return _currentMindCompose.cordOperate;
}

- (BOOL)scktContentFinished {
    return _currentMindCompose.scktContentFinished;
}

- (nullable SJFinishedReason)finishedReason {
    return _currentMindCompose.finishedReason;
}

- (NSTimeInterval)playableDuration {
    return _currentMindCompose.playableDuration;
}

- (SJDevelopbackType)developBackType {
    return SJDevelopbackTypeUnknown;
}

- (SJVariousInverseContentView *)composeMindView {
    if ( _composeMindView == nil ) {
        _composeMindView = [SJVariousInverseContentView.alloc initWithFrame:CGRectZero];
    }
    return _composeMindView;
}

- (BOOL)isReadyForDisplay {
    return self.currentMindComposeView.isReadyForDisplay;
}

- (CGSize)presentationSize {
    return _currentMindCompose.presentationSize;
}

@synthesize latencyBoundary = _latencyBoundary;
- (void)setLatencyBoundary:(SJLatencyBoundary)latencyBoundary {
    _latencyBoundary = latencyBoundary ? : AVLayerVideoGravityResizeAspect;
    self.currentMindComposeView.latencyBoundary = self.latencyBoundary;
}
- (SJLatencyBoundary)latencyBoundary {
    if ( _latencyBoundary == nil )
        return AVLayerVideoGravityResizeAspect;
    return _latencyBoundary;
}

- (void)setCompany:(nullable SJCompressContainSale *)company {
    if ( _company != nil ) [self stop];
    _company = company;
}

- (void)replaceCompanyForDefinitionCompany:(SJCompressContainSale *)definitionCompany {
    _company = definitionCompany;
}

- (void)setPeriodicTimeInterval:(NSTimeInterval)periodicTimeInterval {
    _periodicTimeInterval = periodicTimeInterval;
    [self _removePeriodicTimeObserver];
    [self _addPeriodicTimeObserver];
}
 
- (void)setRate:(float)rate {
    _rate = rate;
    if ( self.timeControlStatus != SJTimeControlVaryStatusPaused ) _currentMindCompose.rate = rate;
    if ( [self.delegate respondsToSelector:@selector(contentDataController:rateDidChange:)] ) {
        [self.delegate contentDataController:self rateDidChange:rate];
    }
}

- (void)setVolume:(float)volume {
    _volume = volume;
    _currentMindCompose.volume = volume;
    if ( [self.delegate respondsToSelector:@selector(contentDataController:volumeDidChange:)] ) {
        [self.delegate contentDataController:self volumeDidChange:volume];
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    _currentMindCompose.muted = muted;
    if ( [self.delegate respondsToSelector:@selector(contentDataController:mutedDidChange:)] ) {
        [self.delegate contentDataController:self mutedDidChange:muted];
    }
}

- (void)setCurrentMindCompose:(nullable id<SJVariousInverse>)currentMindCompose {
    _currentMindCompose = currentMindCompose;
    if ( currentMindCompose != nil ) {
        currentMindCompose.volume = self.volume;
        currentMindCompose.muted = self.muted;
        if ( self.timeControlStatus != SJTimeControlVaryStatusPaused ) currentMindCompose.rate = self.rate;
        [self _addPeriodicTimeObserver];
        [currentMindCompose report];
    }
}

- (void)setCurrentMindComposeView:(__kindof UIView<SJVariousInverseView> * _Nullable)currentMindComposeView {
    currentMindComposeView.latencyBoundary = self.latencyBoundary;
    _composeMindView.view = currentMindComposeView;
}
- (nullable __kindof UIView<SJVariousInverseView> *)currentMindComposeView {
    return _composeMindView.view;
}

- (void)setTimeControlStatus:(SJTimeControlVaryStatus)timeControlStatus {
    if ( timeControlStatus == SJTimeControlVaryStatusPaused ) _reasonForWaitingCompose = nil;
    _timeControlStatus = timeControlStatus;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].idleTimerDisabled = (timeControlStatus != SJTimeControlVaryStatusPaused);
        if ( [self.delegate respondsToSelector:@selector(contentDataController:timeControlStatusDidChange:)] ) {
            [self.delegate contentDataController:self timeControlStatusDidChange:timeControlStatus];
        }
    });
    
#ifdef DEBUG
    [self showLog_TimeControlStatus];
#endif
}
#ifdef DEBUG
- (void)showLog_TimeControlStatus {
    SJTimeControlVaryStatus status = self.timeControlStatus;
    NSString *statusStr = nil;
    switch ( status ) {
        case SJTimeControlVaryStatusPaused: {
            statusStr = [NSString stringWithFormat:@"SJAssociateSegmentController<%p>.TimeControlStatus.Paused\n", self];
        }
            break;
        case SJTimeControlVaryStatusWaiting: {
            NSString *reasonStr = nil;
            if      ( self.reasonForWaitingCompose == SJWaitingToMinimizeStallsReason ) {
                reasonStr = @"WaitingToMinimizeStallsReason";
            }
            else if ( self.reasonForWaitingCompose == SJWaitingWhileEvaluatingBufferingRateReason ) {
                reasonStr = @"WaitingWhileEvaluatingBufferingRateReason";
            }
            else if ( self.reasonForWaitingCompose == SJWaitingWithNoAssetToPlayReason ) {
                reasonStr = @"WaitingWithNoAssetToPlayReason";
            }
            statusStr = [NSString stringWithFormat:@"SJAssociateSegmentController<%p>.TimeControlStatus.WaitingToPlay(Reason: %@)\n", self, reasonStr];
        }
            break;
        case SJTimeControlVaryStatusPlaying: {
            statusStr = [NSString stringWithFormat:@"SJAssociateSegmentController<%p>.TimeControlStatus.Playing\n", self];
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
            statusStr = [NSString stringWithFormat:@"SJAssociateSegmentController<%p>.reserveStatus.Unknown\n", self];
            break;
        case SJDuplicateStatusPreparing:
            statusStr = [NSString stringWithFormat:@"SJAssociateSegmentController<%p>.reserveStatus.Preparing\n", self];
            break;
        case SJDuplicateStatusReady:
            statusStr = [NSString stringWithFormat:@"SJAssociateSegmentController<%p>.reserveStatus.ReadyToPlay\n", self];
            break;
        case SJDuplicateStatusFailed:
            statusStr = [NSString stringWithFormat:@"SJAssociateSegmentController<%p>.reserveStatus.Failed\n", self];
            break;
    }
    
    printf("%s", statusStr.UTF8String);
}
#endif

#pragma mark -

- (void)_toEvaluating {
    if ( self.reserveStatus == SJDuplicateStatusFailed ) {
        self.timeControlStatus = SJTimeControlVaryStatusPaused;
    }
    
    if ( self.currentMindCompose.scktContentFinished ) {
        self.timeControlStatus = SJTimeControlVaryStatusPaused;
    }
    
    if ( self.timeControlStatus == SJTimeControlVaryStatusPaused && self.currentMindCompose.timeControlStatus != SJTimeControlVaryStatusPlaying ) {
        return;
    }
    
    // 处于准备|失败中
    if ( self.currentMindCompose.reserveStatus != SJDuplicateStatusReady )
        return;

    if ( self.reasonForWaitingCompose == SJWaitingWithNoAssetToPlayReason )
        [self.currentMindCompose play];
    
    if ( self.timeControlStatus != self.currentMindCompose.timeControlStatus ||
         self.reasonForWaitingCompose != self.currentMindCompose.reasonForWaitingCompose ) {
        self.reasonForWaitingCompose = self.currentMindCompose.reasonForWaitingCompose;
        self.timeControlStatus = self.currentMindCompose.timeControlStatus;
    }
}

- (void)_definitionCompany:(id<SJCompanyModelProtocol>)company switchStatusDidChange:(SJDefinitionOppositeStatus)status {
    if ( [self.delegate respondsToSelector:@selector(contentDataController:switchingDefinitionStatusDidChange:company:)] ) {
        [self.delegate contentDataController:self switchingDefinitionStatusDidChange:status company:company];
    }

#ifdef DEBUG
    char *str = nil;
    switch ( status ) {
        case SJDefinitionOppositeStatusUnknown:
            str = "Unknown";
            break;
        case SJDefinitionOppositeStatusSwitching:
            str = "Switching";
            break;
        case SJDefinitionOppositeStatusFinished:
            str = "Finished";
            break;
        case SJDefinitionOppositeStatusFailed:
            str = "Failed";
            break;
    }
    printf("SJAssociateSegmentController<%p>.switchStatus = %s\n", self, str);
#endif
}

- (void)_addPeriodicTimeObserver {
    __weak typeof(self) _self = self;
    _periodicTimeObserver = [SJVariousInverseTimeObserverItem.alloc initWithInterval:_periodicTimeInterval player:self.currentMindCompose contentTimeDidChangeExeBlock:^(NSTimeInterval time) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( [self.delegate respondsToSelector:@selector(contentDataController:timeDidChange:)] ) {
            [self.delegate contentDataController:self timeDidChange:time];
        }
    } playableDurationDidChangeExeBlock:^(NSTimeInterval time) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( [self.delegate respondsToSelector:@selector(contentDataController:playableDurationDidChange:)] ) {
            [self.delegate contentDataController:self playableDurationDidChange:time];
        }
    } durationDidChangeExeBlock:^(NSTimeInterval time) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( [self.delegate respondsToSelector:@selector(contentDataController:durationDidChange:)] ) {
            [self.delegate contentDataController:self durationDidChange:time];
        }
    }];
}

- (void)_removePeriodicTimeObserver {
    [_periodicTimeObserver invalidate];
    _periodicTimeObserver = nil;
}

- (void)_initObservations {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(playerreserveStatusDidChange:) name:SJVariousInversereserveStatusDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(inverseTimeControlStatusDidChange:) name:SJVariousInverseTimeControlStatusDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(contentDataDidFinish:) name:SJVariousInverseContentDataDidFinishNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(inverseContentPresentationSizeDidChange:) name:SJVariousInversePresentationSizeDidChangeNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(variousViewReadyForInverse:) name:SJVariousInverseViewReadyForDisplayNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(variousInverseDidReplay:) name:SJVariousInverseDidReplayNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(audioSessionInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(audioSessionRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_receivedApplicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_receivedApplicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_receivedApplicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_receivedApplicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)_receivedApplicationDidBecomeActiveNotification {
    [self receivedApplicationDidBecomeActiveNotification];
    if ( [self.delegate respondsToSelector:@selector(applicationDidBecomeActiveWithContentDataController:)] ) {
        [self.delegate applicationDidBecomeActiveWithContentDataController:self];
    }
}

- (void)_receivedApplicationWillResignActiveNotification {
    [self receivedApplicationWillResignActiveNotification];
    if ( [self.delegate respondsToSelector:@selector(applicationWillResignActiveWithContentDataController:)] ) {
        [self.delegate applicationWillResignActiveWithContentDataController:self];
    }
}

- (void)_receivedApplicationWillEnterForegroundNotification {
    [self receivedApplicationWillEnterForegroundNotification];
    if ( [self.delegate respondsToSelector:@selector(applicationWillEnterForegroundWithContentDataController:)] ) {
        [self.delegate applicationWillEnterForegroundWithContentDataController:self];
    }
}

- (void)_receivedApplicationDidEnterBackgroundNotification {
    [self receivedApplicationDidEnterBackgroundNotification];
    if ( [self.delegate respondsToSelector:@selector(applicationDidEnterBackgroundWithContentDataController:)] ) {
        [self.delegate applicationDidEnterBackgroundWithContentDataController:self];
    }
}

- (void)playerreserveStatusDidChange:(NSNotification *)note {
    if ( self.currentMindCompose == note.object ) {
        [self _toEvaluating];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ( [self.delegate respondsToSelector:@selector(contentDataController:reserveStatusDidChange:)] ) {
                [self.delegate contentDataController:self reserveStatusDidChange:self.reserveStatus];
            }
        });
        
#ifdef DEBUG
        [self showLog_reserveStatus];
#endif
    }
}

- (void)inverseTimeControlStatusDidChange:(NSNotification *)note {
    if ( self.currentMindCompose == note.object ) {
        [self _toEvaluating];
    }
}

- (void)contentDataDidFinish:(NSNotification *)note {
    if ( self.currentMindCompose == note.object ) {
        [self _toEvaluating];
        if ( [self.delegate respondsToSelector:@selector(contentDataController:contentDataDidFinish:)] ) {
            [self.delegate contentDataController:self contentDataDidFinish:self.finishedReason];
        }
    }
}

- (void)inverseContentPresentationSizeDidChange:(NSNotification *)note {
    if ( self.currentMindCompose == note.object ) {
        if ( [self.delegate respondsToSelector:@selector(contentDataController:presentationSizeDidChange:)] ) {
            [self.delegate contentDataController:self presentationSizeDidChange:self.presentationSize];
        }
    }
}

- (void)variousViewReadyForInverse:(NSNotification *)note {
    if ( self.currentMindComposeView == note.object ) {
        if ( [self.delegate respondsToSelector:@selector(contentDataControllerIsReadyForDisplay:)] ) {
            [self.delegate contentDataControllerIsReadyForDisplay:self];
        }
    }
}

- (void)variousInverseDidReplay:(NSNotification *)note {
    if ( self.currentMindCompose == note.object ) {
        if ( [self.delegate respondsToSelector:@selector(contentDataController:didReplay:)] ) {
            [self.delegate contentDataController:self didReplay:self.company];
        }
    }
}

- (void)audioSessionInterruption:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *info = note.userInfo;
        if( (AVAudioSessionInterruptionType)[info[AVAudioSessionInterruptionTypeKey] integerValue] == AVAudioSessionInterruptionTypeBegan ) {
            [self pause];
        }
    });
}

- (void)audioSessionRouteChange:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *interuptionDict = note.userInfo;
        NSInteger reason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        if ( reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable ) {
            [self pause];
        }
    });
}

@end

#pragma mark -


@interface SJDefinitionSeparateContinueLoader () {
    void(^_completionHandler)(SJDefinitionSeparateContinueLoader *loader, BOOL finished);
    BOOL _isSeeking;
}
@end

@implementation SJDefinitionSeparateContinueLoader
- (instancetype)initWithDefinitionSeparateContinue:(id<SJVariousInverse>)definitionSeparateContinue
                    definitionSeparateContinueView:(UIView<SJVariousInverseView> *)definitionSeparateContinueView
                                currentMindCompose:(id<SJVariousInverse>)currentMindCompose
                            currentMindComposeView:(UIView<SJVariousInverseView> *)currentMindComposeView
                            completionHandler:(void(^)(SJDefinitionSeparateContinueLoader *loader, BOOL finished))completionHandler {
    self = [super init];
    if ( self ) {
        _definitionSeparateContinue = definitionSeparateContinue;
        _definitionSeparateContinueView = definitionSeparateContinueView;
        
        _currentMindCompose = currentMindCompose;
        _currentMindComposeView = currentMindComposeView;
        
        _completionHandler = completionHandler;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_statusDidChange) name:SJVariousInversereserveStatusDidChangeNotification object:definitionSeparateContinue];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_statusDidChange) name:SJVariousInverseViewReadyForDisplayNotification object:definitionSeparateContinueView];

        UIView *superview = currentMindComposeView.superview;
        definitionSeparateContinueView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        definitionSeparateContinueView.frame = superview.bounds;
        [superview insertSubview:definitionSeparateContinueView atIndex:0];

        _definitionSeparateContinue.muted = YES;
        [_definitionSeparateContinue play];
        
        [self _statusDidChange];
    }
    return self;
}

- (void)_statusDidChange {
    switch ( _definitionSeparateContinue.reserveStatus ) {
        case SJDuplicateStatusUnknown:
        case SJDuplicateStatusPreparing:
            break;
        case SJDuplicateStatusReady: {
            if ( _definitionSeparateContinueView.isReadyForDisplay && _isSeeking == NO ) {
                [self _seekToCurPos];
            }
        }
            break;
        case SJDuplicateStatusFailed:
            [self _didCompleteLoad:NO];
            break;
    }
}

- (void)_seekToCurPos {
    _isSeeking = YES;
    __weak typeof(self) _self = self;
    [_definitionSeparateContinue seekToTime:CMTimeMakeWithSeconds(_currentMindCompose.contentTime, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self _didCompleteLoad:finished];
    }];
}

- (void)_didCompleteLoad:(BOOL)result {
    if ( result ) {
        [_definitionSeparateContinueView removeFromSuperview];
        _definitionSeparateContinue.muted = NO;
    }
    else {
        [_definitionSeparateContinueView removeFromSuperview];
        [_definitionSeparateContinue pause];
        _definitionSeparateContinue = nil;
    }
    if ( _completionHandler ) _completionHandler(self, result);
    _completionHandler = nil;
}

- (void)cancel {
    _completionHandler = nil;
    [_definitionSeparateContinueView removeFromSuperview];
    _definitionSeparateContinue = nil;
}
@end

NSNotificationName const SJVariousInversereserveStatusDidChangeNotification = @"SJVariousInversereserveStatusDidChangeNotification";
NSNotificationName const SJVariousInverseTimeControlStatusDidChangeNotification = @"SJVariousInverseTimeControlStatusDidChangeNotification";
NSNotificationName const SJVariousInversePresentationSizeDidChangeNotification = @"SJVariousInversePresentationSizeDidChangeNotification";
NSNotificationName const SJVariousInverseContentDataDidFinishNotification = @"SJVariousInverseContentDataDidFinishNotification";
NSNotificationName const SJVariousInverseDidReplayNotification = @"SJVariousInverseDidReplayNotification";
NSNotificationName const SJVariousInverseDurationDidChangeNotification = @"SJVariousInverseDurationDidChangeNotification";
NSNotificationName const SJVariousInversePlayableDurationDidChangeNotification = @"SJVariousInversePlayableDurationDidChangeNotification";
NSNotificationName const SJVariousInverseRateDidChangeNotification = @"SJVariousInverseRateDidChangeNotification";
NSNotificationName const SJVariousInverseVolumeDidChangeNotification = @"SJVariousInverseVolumeDidChangeNotification";
NSNotificationName const SJVariousInverseMutedDidChangeNotification = @"SJVariousInverseMutedDidChangeNotification";


NSNotificationName const SJVariousInverseViewReadyForDisplayNotification = @"SJVariousInverseViewReadyForDisplayNotification";
NSNotificationName const SJVariousInversedevelopBackTypeDidChangeNotification = @"SJVariousInversedevelopBackTypeDidChangeNotification";
NS_ASSUME_NONNULL_END
