//
//  SJContactIntegrateContentDataController.h
//  Project
//
//  Created by 畅三江 on 2018/8/10.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#ifndef SJCompanyContentDataProtocol_h
#define SJCompanyContentDataProtocol_h
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SJContactIntegrateLatencyStatusDefines.h"
#import "SJPictureInPictureControllerDefines.h"

@protocol SJContactIntegrateBackControllerDelegate, SJCompanyModelProtocol;

typedef AVLayerVideoGravity SJLatencyBoundary;

typedef struct {
    BOOL isSeeking;
    CMTime time;
} SJSeekingInfo;

NS_ASSUME_NONNULL_BEGIN
@protocol SJContactIntegrateHomebackController<NSObject>
@required
@property (nonatomic) NSTimeInterval periodicTimeInterval; 
@property (nonatomic) NSTimeInterval minBufferedDuration;
@property (nonatomic, strong, readonly, nullable) NSError *error;
@property (nonatomic, weak, nullable) id<SJContactIntegrateBackControllerDelegate> delegate;

@property (nonatomic, readonly) SJDevelopbackType developBackType;
@property (nonatomic, strong, readonly) __kindof UIView *composeMindView;
@property (nonatomic, strong, nullable) id<SJCompanyModelProtocol> company;
@property (nonatomic, strong) SJLatencyBoundary latencyBoundary;
@property (nonatomic, readonly) SJDuplicateStatus reserveStatus;
@property (nonatomic, readonly) SJTimeControlVaryStatus timeControlStatus;
@property (nonatomic, readonly, nullable) SJWaitingReason reasonForWaitingCompose;

@property (nonatomic, readonly) NSTimeInterval contentTime;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) NSTimeInterval playableDuration;
@property (nonatomic, readonly) NSTimeInterval durationWatched;
@property (nonatomic, readonly) CGSize presentationSize;
@property (nonatomic, readonly, getter=isReadyForDisplay) BOOL readyForDisplay;

@property (nonatomic) float volume;
@property (nonatomic) float rate;
@property (nonatomic, getter=isMuted) BOOL muted;

@property (nonatomic, readonly) BOOL consoleReceive;
@property (nonatomic, readonly, getter=cordOperate) BOOL replayed;
@property (nonatomic, readonly) BOOL scktContentFinished;
@property (nonatomic, readonly, nullable) SJFinishedReason finishedReason;
- (void)prepareToPlay;
- (void)replay;
- (void)refresh;
- (void)play;
@property (nonatomic) BOOL pauseWhenAppDidEnterBackground;
- (void)pause;
- (void)stop;
- (void)seekToTime:(NSTimeInterval)secs completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^ __nullable)(BOOL))completionHandler;
- (nullable UIImage *)screenshot;
- (void)switchVideoDefinition:(id<SJCompanyModelProtocol>)company;

- (BOOL)seekPictureInPictureSupported API_AVAILABLE(ios(14.0));
@property (nonatomic) BOOL requiresLinearContentDataInPictureInPicture API_AVAILABLE(ios(14.0));
@property (nonatomic) BOOL canStartPictureInPictureAutomaticallyFromInline API_AVAILABLE(ios(14.2));
@property (nonatomic, readonly) SJPictureInPictureStatus pictureInPictureStatus API_AVAILABLE(ios(14.0));
@property (nonatomic, copy, nullable) void(^restoreUserInterfaceForPictureInPictureStop)(id<SJContactIntegrateHomebackController> controller, void(^completionHandler)(BOOL restored));
- (void)startPictureInPicture API_AVAILABLE(ios(14.0));
- (void)stopPictureInPicture API_AVAILABLE(ios(14.0));
- (void)cancelPictureInPicture API_AVAILABLE(ios(14.0));
@end

@protocol SJCompanyContentDataScreenshotController
- (void)screenshotWithTime:(NSTimeInterval)time
                      size:(CGSize)size
                completion:(void(^)(id<SJContactIntegrateHomebackController> controller, UIImage * __nullable image, NSError *__nullable error))block;
@end


@protocol SJCompanyContentDataExportController
- (void)exportWithBeginTime:(NSTimeInterval)beginTime
                   duration:(NSTimeInterval)duration
                 presetName:(nullable NSString *)presetName
                   progress:(void(^)(id<SJContactIntegrateHomebackController> controller, float progress))progress
                 completion:(void(^)(id<SJContactIntegrateHomebackController> controller, NSURL * __nullable saveURL, UIImage * __nullable thumbImage))completion
                    failure:(void(^)(id<SJContactIntegrateHomebackController> controller, NSError * __nullable error))failure;

- (void)generateGIFWithBeginTime:(NSTimeInterval)beginTime
                        duration:(NSTimeInterval)duration
                     maximumSize:(CGSize)maximumSize
                        interval:(float)interval
                     gifSavePath:(NSURL *)gifSavePath
                        progress:(void(^)(id<SJContactIntegrateHomebackController> controller, float progress))progressBlock
                      completion:(void(^)(id<SJContactIntegrateHomebackController> controller, UIImage *imageGIF, UIImage *screenshot))completion
                         failure:(void(^)(id<SJContactIntegrateHomebackController> controller, NSError *error))failure;

- (void)cancelExportOperation;
- (void)cancelGenerateGIFOperation;
@end


@protocol SJContactIntegrateBackControllerDelegate<NSObject>

@optional
#pragma mark -
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller reserveStatusDidChange:(SJDuplicateStatus)status;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller timeControlStatusDidChange:(SJTimeControlVaryStatus)status;
#pragma mark -


- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller volumeDidChange:(float)volume;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller rateDidChange:(float)rate;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller mutedDidChange:(BOOL)isMuted;

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller contentDataDidFinish:(SJFinishedReason)reason;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller durationDidChange:(NSTimeInterval)duration;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller timeDidChange:(NSTimeInterval)time;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller presentationSizeDidChange:(CGSize)presentationSize;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller developBackTypeDidChange:(SJDevelopbackType)developBackType;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller playableDurationDidChange:(NSTimeInterval)playableDuration;
- (void)contentDataControllerIsReadyForDisplay:(id<SJContactIntegrateHomebackController>)controller;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller switchingDefinitionStatusDidChange:(SJDefinitionOppositeStatus)status company:(id<SJCompanyModelProtocol>)company;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller didReplay:(id<SJCompanyModelProtocol>)company;

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller pictureInPictureStatusDidChange:(SJPictureInPictureStatus)status API_AVAILABLE(ios(14.0));

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller willSeekToTime:(CMTime)time;
- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller didSeekToTime:(CMTime)time;

- (void)applicationWillEnterForegroundWithContentDataController:(id<SJContactIntegrateHomebackController>)controller;
- (void)applicationDidBecomeActiveWithContentDataController:(id<SJContactIntegrateHomebackController>)controller;
- (void)applicationWillResignActiveWithContentDataController:(id<SJContactIntegrateHomebackController>)controller;
- (void)applicationDidEnterBackgroundWithContentDataController:(id<SJContactIntegrateHomebackController>)controller;
@end


@protocol SJCompanyModelProtocol
@property (nonatomic, strong, nullable) NSURL *companyURL;

@property (nonatomic) NSTimeInterval startPosition;

@property (nonatomic) NSTimeInterval trialEndPosition;
@end
NS_ASSUME_NONNULL_END

#endif /* SJCompanyContentDataProtocol_h */
