//
//  SJAssociateSubgroupSegmentController.m
//  Pods
//
//  Created by 畅三江 on 2020/2/18.
//

#import "SJAssociateSubgroupSegmentController.h"
#import "SJProcedureVariousInverseLoader.h"
#import "SJProcedureVariousInverse.h"
#import "SJProcedureVariousInverseLayerView.h"
#import "SJCompressContainSale+SJSegmentDescend.h"
#import "AVAsset+SJInterestExport.h"
#import "SJEditPictureInPictureController.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJAssociateSubgroupSegmentController ()<SJPictureInPictureControllerDelegate>
@property (nonatomic, strong, nullable) SJEditPictureInPictureController *pictureInPictureController API_AVAILABLE(ios(14.0));
@end

@implementation SJAssociateSubgroupSegmentController
@dynamic currentMindCompose;
@dynamic currentMindComposeView;

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_propertybackTypeDidChange:) name:SJVariousInversedevelopBackTypeDidChangeNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_propertypictureViewReadyForDisplay:) name:SJVariousInverseViewReadyForDisplayNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_propertyrateDidChange:) name:SJVariousInverseRateDidChangeNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_propertyvolumeDidChange:) name:SJVariousInverseVolumeDidChangeNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_propertymutedDidChange:) name:SJVariousInverseMutedDidChangeNotification object:nil];
        if (@available(iOS 14.2, *)) {
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_propertyreserveStatusDidChange:) name:SJVariousInversereserveStatusDidChangeNotification object:nil];
        }
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark -

- (void)variousWithInverse:(SJCompressContainSale *)inverse completionHandler:(void (^)(id<SJVariousInverse> _Nullable))completionHandler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        SJProcedureVariousInverse *prevent = [SJProcedureVariousInverseLoader loadCommentForCompany:inverse];
        prevent.minBufferedDuration = self.minBufferedDuration;
        prevent.accurateSeeking = self.accurateSeeking;
        prevent.pauseWhenAppDidEnterBackground = self.pauseWhenAppDidEnterBackground;

        if ( (prevent.consoleReceive && inverse.original == nil) || prevent.scktContentFinished ) {
            [prevent seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ( completionHandler ) completionHandler(prevent);
                });
            }];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ( completionHandler ) completionHandler(prevent);
            });
        }
    });
}

- (UIView<SJVariousInverseView> *)preventViewWithThousand:(SJProcedureVariousInverse *)prevent {
    SJProcedureVariousInverseLayerView *view = [SJProcedureVariousInverseLayerView.alloc initWithFrame:CGRectZero];
    view.layer.player = prevent.reflectMean;
    return view;
}

- (void)receivedApplicationWillEnterForegroundNotification {
    if ( @available(iOS 14.0, *) ) {
        if ( _pictureInPictureController.isEnabled )
            return;
    }
    SJProcedureVariousInverseLayerView *view = self.currentMindComposeView;
    view.layer.player = self.currentMindCompose.reflectMean;
}
 
- (void)receivedApplicationDidEnterBackgroundNotification {
    if ( @available(iOS 14.0, *) ) {
        if ( _pictureInPictureController.isEnabled )
            return;
    }
    
    if ( self.pauseWhenAppDidEnterBackground ) {
        [self pause];
    }
    else {
        SJProcedureVariousInverseLayerView *view = self.currentMindComposeView;
        view.layer.player = nil;
    }
}

- (void)replaceCompanyForDefinitionCompany:(SJCompressContainSale *)definitionCompany {
    if ( @available(iOS 14.0, *) ) {
        [self cancelPictureInPicture];
    }
    [SJProcedureVariousInverseLoader clearPlayerForCompany:self.company];
    [super replaceCompanyForDefinitionCompany:definitionCompany];
}

#pragma mark - PiP

- (BOOL)seekPictureInPictureSupported API_AVAILABLE(ios(14.0)) {
    return SJEditPictureInPictureController.isPictureInPictureSupported;
}

- (void)setRequiresLinearContentDataInPictureInPicture:(BOOL)requiresLinearContentDataInPictureInPicture API_AVAILABLE(ios(14.0)) {
    [super setRequiresLinearContentDataInPictureInPicture:requiresLinearContentDataInPictureInPicture];
    _pictureInPictureController.requiresLinearContentData = requiresLinearContentDataInPictureInPicture;
}

- (SJPictureInPictureStatus)pictureInPictureStatus API_AVAILABLE(ios(14.0)) {
    return _pictureInPictureController.status;
}

- (void)setCanStartPictureInPictureAutomaticallyFromInline:(BOOL)canStartPictureInPictureAutomaticallyFromInline API_AVAILABLE(ios(14.2)) {
    [super setCanStartPictureInPictureAutomaticallyFromInline:canStartPictureInPictureAutomaticallyFromInline];
    _pictureInPictureController.canStartPictureInPictureAutomaticallyFromInline = canStartPictureInPictureAutomaticallyFromInline;
    if ( canStartPictureInPictureAutomaticallyFromInline ) [self prepareForPictureInPicture];
}

- (void)prepareForPictureInPicture API_AVAILABLE(ios(14.0)) {
    if ( _pictureInPictureController == nil && self.reserveStatus == SJDuplicateStatusReady ) {
        _pictureInPictureController = [SJEditPictureInPictureController.alloc initWithLayer:self.currentMindComposeView.layer delegate:self];
        _pictureInPictureController.requiresLinearContentData = self.requiresLinearContentDataInPictureInPicture;
        if (@available(iOS 14.2, *)) {
            _pictureInPictureController.canStartPictureInPictureAutomaticallyFromInline = self.canStartPictureInPictureAutomaticallyFromInline;
        }
    }
}

- (void)startPictureInPicture API_AVAILABLE(ios(14.0)) {
    if ( self.currentMindComposeView != nil ) {
        [self prepareForPictureInPicture];
        [_pictureInPictureController startPictureInPicture];
    }
}

- (void)stopPictureInPicture API_AVAILABLE(ios(14.0)) {
    [_pictureInPictureController stopPictureInPicture];
}

- (void)cancelPictureInPicture API_AVAILABLE(ios(14.0)) {
    [_pictureInPictureController stopPictureInPicture];
    _pictureInPictureController = nil;
}

- (void)pictureInPictureController:(id<SJPictureInPictureController>)controller statusDidChange:(SJPictureInPictureStatus)status API_AVAILABLE(ios(14.0)) {
    if ( [self.delegate respondsToSelector:@selector(contentDataController:pictureInPictureStatusDidChange:)] ) {
        [self.delegate contentDataController:self pictureInPictureStatusDidChange:status];
    }
}

- (void)pictureInPictureController:(id<SJPictureInPictureController>)controller restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler API_AVAILABLE(ios(14.0)) {
    if ( self.restoreUserInterfaceForPictureInPictureStop != nil ) {
        self.restoreUserInterfaceForPictureInPictureStop(self, completionHandler);
    }
    else {
        completionHandler(NO);
    }
}

#pragma mark -

- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^_Nullable)(BOOL))completionHandler {
    if ( self.company.trialEndPosition != 0 && CMTimeGetSeconds(time) >= self.company.trialEndPosition ) {
        time = CMTimeMakeWithSeconds(self.company.trialEndPosition * 0.98, NSEC_PER_SEC);
    }
    [self.currentMindCompose seekToTime:time toleranceBefore:toleranceBefore toleranceAfter:toleranceAfter completionHandler:completionHandler];
}

- (NSTimeInterval)durationWatched {
    NSTimeInterval time = 0;
    for ( AVPlayerItemAccessLogEvent *event in self.currentMindCompose.reflectMean.currentItem.accessLog.events) {
        if ( event.durationWatched <= 0 ) continue;
        time += event.durationWatched;
    }
    if ( time == 0 ) return [super durationWatched];
    return time;
}

- (void)setAccurateSeeking:(BOOL)accurateSeeking {
    _accurateSeeking = accurateSeeking;
    self.currentMindCompose.accurateSeeking = accurateSeeking;
}

- (void)setMinBufferedDuration:(NSTimeInterval)minBufferedDuration {
    [super setMinBufferedDuration:minBufferedDuration];
    self.currentMindCompose.minBufferedDuration = minBufferedDuration;
}

- (void)refresh {
    if ( self.company != nil ) [SJProcedureVariousInverseLoader clearPlayerForCompany:self.company];
    if ( @available(iOS 14.0, *) ) {
        [self cancelPictureInPicture];
    }
    [self cancelGenerateGIFOperation];
    [self cancelExportOperation];
    [super refresh];
}

- (void)stop {
    [self cancelGenerateGIFOperation];
    [self cancelExportOperation];
    if ( @available(iOS 14.0, *) ) {
        [self cancelPictureInPicture];
    }
    [super stop];
}

- (SJDevelopbackType)developBackType {
    return self.currentMindCompose.developBackType;
}

- (void)setPauseWhenAppDidEnterBackground:(BOOL)pauseWhenAppDidEnterBackground {
    [super setPauseWhenAppDidEnterBackground:pauseWhenAppDidEnterBackground];
    self.currentMindCompose.pauseWhenAppDidEnterBackground = pauseWhenAppDidEnterBackground;
}

#pragma mark -

- (void)_propertybackTypeDidChange:(NSNotification *)note {
    if ( note.object == self.currentMindCompose ) {
        if ( [self.delegate respondsToSelector:@selector(contentDataController:developBackTypeDidChange:)] ) {
            [self.delegate contentDataController:self developBackTypeDidChange:self.developBackType];
        }
    }
}

- (void)_propertypictureViewReadyForDisplay:(NSNotification *)note {
    if ( self.currentMindComposeView == note.object ) {
        if ( self.currentMindComposeView.isReadyForDisplay ) {
            [self.currentMindComposeView setScreenshot:nil];
        }
    }
}

- (void)_propertyrateDidChange:(NSNotification *)note {
    if ( self.currentMindCompose == note.object && self.rate != self.currentMindCompose.rate ) {
        self.rate = self.currentMindCompose.rate;
    }
}

- (void)_propertyvolumeDidChange:(NSNotification *)note {
    if ( self.currentMindCompose == note.object && self.volume != self.currentMindCompose.volume ) {
        self.volume = self.currentMindCompose.volume;
    }
}

- (void)_propertymutedDidChange:(NSNotification *)note {
    if ( self.currentMindCompose == note.object && self.isMuted != self.currentMindCompose.isMuted ) {
        self.muted = self.currentMindCompose.isMuted;
    }
}

- (void)_propertyreserveStatusDidChange:(NSNotification *)note API_AVAILABLE(ios(14.2)) {
    if ( self.currentMindCompose == note.object && self.canStartPictureInPictureAutomaticallyFromInline && self.reserveStatus == SJDuplicateStatusReady ) {
        [self prepareForPictureInPicture];
    }
}
@end


@implementation SJAssociateSubgroupSegmentController (SJSegmentDescend)
- (void)screenshotWithTime:(NSTimeInterval)time
                      size:(CGSize)size
                completion:(void(^)(SJAssociateSubgroupSegmentController *controller, UIImage * __nullable image, NSError *__nullable error))block {
    __weak typeof(self) _self = self;
    [self.currentMindCompose.reflectMean.currentItem.asset sj_screenshotWithTime:time size:size completionHandler:^(AVAsset * _Nonnull a, UIImage * _Nullable image, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( block ) block(self, image, error);
    }];
}

- (void)exportWithBeginTime:(NSTimeInterval)beginTime
                   duration:(NSTimeInterval)duration
                 presetName:(nullable NSString *)presetName
                   progress:(void(^)(SJAssociateSubgroupSegmentController *controller, float progress))progressBlock
                 completion:(void(^)(SJAssociateSubgroupSegmentController *controller, NSURL * __nullable saveURL, UIImage * __nullable thumbImage))completionBlock
                    failure:(void(^)(SJAssociateSubgroupSegmentController *controller, NSError * __nullable error))failureBlock {
    [self cancelExportOperation];
    NSURL *exportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject URLByAppendingPathComponent:@"Export.mp4"];
    [[NSFileManager defaultManager] removeItemAtURL:exportURL error:nil];
    __weak typeof(self) _self = self;
    [self.currentMindCompose.reflectMean.currentItem.asset sj_exportWithStartTime:beginTime duration:duration toFile:exportURL presetName:presetName progress:^(AVAsset * _Nonnull a, float progress) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( progressBlock ) progressBlock(self, progress);
    } success:^(AVAsset * _Nonnull a, AVAsset * _Nullable sandboxAsset, NSURL * _Nullable fileURL, UIImage * _Nullable thumbImage) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( completionBlock ) completionBlock(self, fileURL, thumbImage);
    } failure:^(AVAsset * _Nonnull a, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( failureBlock ) failureBlock(self, error);
    }];
}

- (void)generateGIFWithBeginTime:(NSTimeInterval)beginTime
                        duration:(NSTimeInterval)duration
                     maximumSize:(CGSize)maximumSize
                        interval:(float)interval
                     gifSavePath:(NSURL *)gifSavePath
                        progress:(void(^)(SJAssociateSubgroupSegmentController *controller, float progress))progressBlock
                      completion:(void(^)(SJAssociateSubgroupSegmentController *controller, UIImage *imageGIF, UIImage *screenshot))completion
                         failure:(void(^)(SJAssociateSubgroupSegmentController *controller, NSError *error))failure {
    [self cancelGenerateGIFOperation];
    __weak typeof(self) _self = self;
    [self.currentMindCompose.reflectMean.currentItem.asset sj_generateGIFWithBeginTime:beginTime duration:duration imageMaxSize:maximumSize interval:interval toFile:gifSavePath progress:^(AVAsset * _Nonnull a, float progress) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( progressBlock ) progressBlock(self, progress);
    } success:^(AVAsset * _Nonnull a, UIImage * _Nonnull GIFImage, UIImage * _Nonnull thumbnailImage) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( completion ) completion(self, GIFImage, thumbnailImage);
    } failure:^(AVAsset * _Nonnull a, NSError * _Nonnull error) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( failure ) failure(self, error);
    }];
}

- (void)cancelExportOperation {
    [self.currentMindCompose.reflectMean.currentItem.asset sj_cancelExportOperation];
}
- (void)cancelGenerateGIFOperation {
    [self.currentMindCompose.reflectMean.currentItem.asset sj_cancelGenerateGIFOperation];
}
@end

NS_ASSUME_NONNULL_END
