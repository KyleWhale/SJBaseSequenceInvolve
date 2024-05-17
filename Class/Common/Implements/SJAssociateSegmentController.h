//
//  SJAssociateSegmentController.h
//  Pods
//
//  Created by 畅三江 on 2020/2/17.
//

#import <Foundation/Foundation.h>
#import "SJContactIntegrateLatencyControllerDefines.h"
#import "SJCompressContainSale.h"
@protocol SJVariousInverse, SJVariousInverseView;

NS_ASSUME_NONNULL_BEGIN
@interface SJAssociateSegmentController : NSObject<SJContactIntegrateHomebackController>
@property (nonatomic, strong, nullable) SJCompressContainSale *company;

@property (nonatomic, strong, readonly, nullable) id<SJVariousInverse> currentMindCompose;
@property (nonatomic, strong, readonly, nullable) __kindof UIView<SJVariousInverseView> *currentMindComposeView;

- (void)variousWithInverse:(SJCompressContainSale *)company completionHandler:(void(^)(id<SJVariousInverse> _Nullable player))completionHandler;

- (UIView<SJVariousInverseView> *)preventViewWithThousand:(id<SJVariousInverse>)player;

- (void)receivedApplicationDidBecomeActiveNotification;
- (void)receivedApplicationWillResignActiveNotification;
- (void)receivedApplicationWillEnterForegroundNotification;
- (void)receivedApplicationDidEnterBackgroundNotification;

@property (nonatomic, copy, nullable) void(^restoreUserInterfaceForPictureInPictureStop)(id<SJContactIntegrateHomebackController> controller, void(^completionHandler)(BOOL restored));
@end

extern NSNotificationName const SJVariousInversereserveStatusDidChangeNotification;
extern NSNotificationName const SJVariousInverseTimeControlStatusDidChangeNotification;
extern NSNotificationName const SJVariousInversePresentationSizeDidChangeNotification;
extern NSNotificationName const SJVariousInverseContentDataDidFinishNotification;
extern NSNotificationName const SJVariousInverseDidReplayNotification;
extern NSNotificationName const SJVariousInverseDurationDidChangeNotification;
extern NSNotificationName const SJVariousInversePlayableDurationDidChangeNotification;
extern NSNotificationName const SJVariousInverseRateDidChangeNotification;
extern NSNotificationName const SJVariousInverseVolumeDidChangeNotification;
extern NSNotificationName const SJVariousInverseMutedDidChangeNotification;

extern NSNotificationName const SJVariousInverseViewReadyForDisplayNotification;

@protocol SJVariousInverseView <NSObject>
@property (nonatomic) SJLatencyBoundary latencyBoundary;
@property (nonatomic, readonly, getter=isReadyForDisplay) BOOL readyForDisplay;
@end

@protocol SJVariousInverse <NSObject>
@property (nonatomic, strong, readonly, nullable) NSError *error;
@property (nonatomic, readonly, nullable) SJWaitingReason reasonForWaitingCompose;
@property (nonatomic, readonly) SJTimeControlVaryStatus timeControlStatus;
@property (nonatomic, readonly) SJDuplicateStatus reserveStatus;
@property (nonatomic, readonly) SJSeekingInfo seekingInfo;
@property (nonatomic, readonly) CGSize presentationSize;
@property (nonatomic, readonly) BOOL cordOperate;
@property (nonatomic, readonly) BOOL consoleReceive;
@property (nonatomic, readonly) BOOL scktContentFinished;
@property (nonatomic, readonly, nullable) SJFinishedReason finishedReason;
@property (nonatomic) NSTimeInterval trialEndPosition;
@property (nonatomic) float rate;
@property (nonatomic) float volume;
@property (nonatomic, getter=isMuted) BOOL muted;

- (void)seekToTime:(CMTime)time completionHandler:(nullable void (^)(BOOL finished))completionHandler;

@property (nonatomic, readonly) NSTimeInterval contentTime;
@property (nonatomic, readonly) NSTimeInterval duration;    
@property (nonatomic, readonly) NSTimeInterval playableDuration;

- (void)play;
- (void)pause;

- (void)replay;
- (void)report;

- (nullable UIImage *)screenshot;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

extern NSNotificationName const SJVariousInversedevelopBackTypeDidChangeNotification;


@interface SJAssociateSegmentController (SJSwitchDefinitionExtended)

- (void)replaceCompanyForDefinitionCompany:(SJCompressContainSale *)definitionCompany NS_REQUIRES_SUPER;
@end
NS_ASSUME_NONNULL_END
