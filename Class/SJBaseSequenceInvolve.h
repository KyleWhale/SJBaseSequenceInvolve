//
//  SJBaseSequenceInvolve.h
//  SJBaseSequenceInvolveProject


#import <UIKit/UIKit.h>
#import "SJFitOnScreenManagerDefines.h"
#import "SJRotationManagerDefines.h"
#import "SJContactIntegrateControlLayerProtocol.h"
#import "SJControlLayerAppearManagerDefines.h"
#import "SJFlipTransitionManagerDefines.h"
#import "SJContactIntegrateLatencyControllerDefines.h"
#import "SJCompressContainSale+SJSegmentDescend.h"
#import "SJGestureControllerDefines.h"
#import "SJDeviceVolumeAndBrightnessControllerDefines.h"
#import "SJSmallViewFloatingControllerDefines.h"
#import "SJDefinitionOppositeInfo.h"
#import "SJPromptingPopupControllerDefines.h"
#import "SJBackObservation.h"
#import "SJRetrieveRetrievePresentViewDefines.h"
#import "SJSubtitlePopupControllerDefines.h"
#import "SJDanmakuPopupControllerDefines.h"
#import "SJTextPopupControllerDefines.h"
#import "SJStructureViewDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJBaseSequenceInvolve : NSObject
+ (NSString *)version;
+ (instancetype)inverseElement;
- (instancetype)init;


@property (nonatomic) SJLatencyBoundary latencyBoundary;
@property (nonatomic, strong, readonly) __kindof UIView *view;
@property (nonatomic, weak, nullable) id <SJControlLayerDataSource> controlLayerDataSource;
@property (nonatomic, weak, nullable) id <SJControlLayerDelegate> controlLayerDelegate;

@end


@interface SJBaseSequenceInvolve (AudioSession)

@property (nonatomic, getter=isAudioSessionControlEnabled) BOOL audioSessionControlEnabled;

- (void)setCategory:(AVAudioSessionCategory)category withOptions:(AVAudioSessionCategoryOptions)options;
- (void)setActiveOptions:(AVAudioSessionSetActiveOptions)options;
@end


#pragma mark - present view

@interface SJBaseSequenceInvolve (Placeholder)

@property (nonatomic, strong, readonly) UIView<SJRetrieveRetrievePresentView> *presentView;

@property (nonatomic) BOOL automaticallyHidesPlaceholderImageView;

@property (nonatomic) NSTimeInterval delayInHiddenPlaceholderView;
@end

#pragma mark -

@interface SJBaseSequenceInvolve (FlipTransition)

@property (nonatomic, strong, null_resettable) id<SJFlipTransitionManager> flipTransitionManager;

@property (nonatomic, strong, readonly) id<SJFlipTransitionManagerObserver> flipTransitionObserver;
@end



#pragma mark -

@interface SJBaseSequenceInvolve (ContentData)<SJContactIntegrateBackControllerDelegate>

@property (nonatomic, strong, null_resettable) __kindof id<SJContactIntegrateHomebackController> contactIntegrateController;

@property (nonatomic, strong, readonly) SJBackObservation *smplProvide;

@property (nonatomic, strong, nullable) SJCompressContainSale *containSale;

@property (nonatomic, readonly) SJDuplicateStatus reserveStatus;

@property (nonatomic, readonly) SJTimeControlVaryStatus timeControlStatus;

@property (nonatomic, readonly, nullable) SJWaitingReason reasonForWaitingCompose;

@property (nonatomic, readonly) BOOL ellipsisRule;
@property (nonatomic, readonly) BOOL referenceClassify;
@property (nonatomic, readonly) BOOL carouselIntegrate;
@property (nonatomic, readonly) BOOL consumeVarious;
@property (nonatomic, readonly) BOOL modeNoAssetToPurchase;

@property (nonatomic, readonly) BOOL mindContentProcessDataFailed;
@property (nonatomic, readonly) BOOL machContentInstantDataFinished;
@property (nonatomic, readonly, nullable) SJFinishedReason finishedReason;

- (void)play;
- (void)pause;
- (void)pauseForUser;
- (void)refresh;
- (void)replay;
- (void)stop;

@property (nonatomic, getter=isMuted) BOOL muted;
@property (nonatomic) float oppositeVolume;
@property (nonatomic) float rate;

@property (nonatomic, readonly) NSTimeInterval contentTime;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic, readonly) NSTimeInterval playableDuration;
@property (nonatomic, readonly) NSTimeInterval durationWatched;

@property (nonatomic, readonly) BOOL consoleUserPaused;
@property (nonatomic, readonly) BOOL consoleReceive;
@property (nonatomic, readonly) BOOL cordOperate;
@property (nonatomic, readonly) SJDevelopbackType developBackType;
- (NSString *)stringForSeconds:(NSInteger)secs;

@property (nonatomic, getter=ellipsisRuleInBackground) BOOL pausedInBackground;
@property (nonatomic) BOOL autoplayWhenSetNewAsset;
@property (nonatomic) BOOL resumeContentDataWhenAppDidEnterForeground;
@property (nonatomic) BOOL resumeContentDataWhenHasFinishedSeeking;


@property (nonatomic, copy, nullable) BOOL(^canPlayAnAsset)(__kindof SJBaseSequenceInvolve *involve);

@property (nonatomic, copy, nullable) BOOL(^canSeekToTime)(__kindof SJBaseSequenceInvolve *involve);

@property (nonatomic) BOOL accurateSeeking;

- (void)seekToTime:(NSTimeInterval)secs completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;
- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^ __nullable)(BOOL finished))completionHandler;


- (void)stmpTornadoDefinition:(SJCompressContainSale *)URLAsset;

@property (nonatomic, strong, readonly) SJDefinitionOppositeInfo *definitionOppositeInfo;

@property (nonatomic, strong, readonly, nullable) NSError *error;
@end


#pragma mark - 设置 设备的音量和亮度

@interface SJBaseSequenceInvolve (DeviceVolumeAndBrightness)

@property (nonatomic, strong, null_resettable) id<SJDeviceVolumeAndBrightnessController> deviceVolumeAndBrightnessController;

@property (nonatomic, strong, readonly) id<SJDeviceVolumeAndBrightnessControllerObserver> deviceVolumeAndBrightnessObserver;

@property (nonatomic) BOOL disableBrightnessSetting;

@property (nonatomic) BOOL disableVolumeSetting;
@end


#pragma mark -

@interface SJBaseSequenceInvolve (Life)

- (void)vc_viewDidAppear;
- (void)vc_viewWillDisappear;
- (void)vc_viewDidDisappear;
- (BOOL)vc_prefersStatusBarHidden;
- (UIStatusBarStyle)vc_preferredStatusBarStyle;

@property (nonatomic) BOOL vc_isDisappeared;

- (void)needShowStatusBar;

- (void)needHiddenStatusBar;
@end




#pragma mark -

@interface SJBaseSequenceInvolve (Network)

@property (nonatomic, strong, null_resettable) id<SJReachability> reachability;

@property (nonatomic, strong, readonly) id<SJReachabilityObserver> reachabilityObserver;
@end





#pragma mark -

@interface SJBaseSequenceInvolve (Popup)

@property (nonatomic, strong, null_resettable) id<SJTextPopupController> textPopupController;

@property (nonatomic, strong, null_resettable) id<SJPromptingPopupController> promptingPopupController;
@end



#pragma mark -

@interface SJBaseSequenceInvolve (Gesture)

@property (nonatomic, strong, readonly) id<SJGestureController> gestureController;

@property (nonatomic, copy, nullable) BOOL(^gestureRecognizerShouldTrigger)(__kindof SJBaseSequenceInvolve *involve, SJAccidentPresenceGestureType type, CGPoint location);

@property (nonatomic) BOOL allowHorizontalTriggeringOfPanGesturesInCells;

@property (nonatomic) CGFloat rateWhenLongPressGestureTriggered;

@property (nonatomic) CGFloat offsetFactorForHorizontalPanGesture;
@end


#pragma mark -

@interface SJBaseSequenceInvolve (ControlLayer)

@property (nonatomic, strong, null_resettable) id<SJControlLayerAppearManager> controlLayerAppearManager;

@property (nonatomic, strong, readonly) id<SJControlLayerAppearManagerObserver> controlLayerAppearObserver;

@property (nonatomic, getter=isControlLayerAppeared) BOOL controlLayerAppeared;

@property (nonatomic, copy, nullable) BOOL(^canAutomaticallyDisappear)(__kindof SJBaseSequenceInvolve *involve);

- (void)controlLayerNeedAppear;

- (void)controlLayerNeedDisappear;

@property (nonatomic) BOOL pausedToKeepAppearState;
@end


#pragma mark -

@interface SJBaseSequenceInvolve (FitOnScreen)

@property (nonatomic, strong, null_resettable) id<SJFitOnScreenManager> fitOnScreenManager;

@property (nonatomic, strong, readonly) id<SJFitOnScreenManagerObserver> fitOnScreenObserver;

@property (nonatomic, getter=fncyFitOnScreen) BOOL fitOnScreen;

@property (nonatomic) BOOL onlyFitOnScreen;

- (void)setFitOnScreen:(BOOL)fitOnScreen animated:(BOOL)animated;

- (void)setFitOnScreen:(BOOL)fitOnScreen animated:(BOOL)animated completionHandler:(nullable void(^)(__kindof SJBaseSequenceInvolve *involve))completionHandler;
@end

#pragma mark -


@interface SJBaseSequenceInvolve (Rotation)

@property (nonatomic, strong, nullable) id<SJRotationManager> rotationManager;

@property (nonatomic, strong, readonly) id<SJRotationManagerObserver> rotationObserver;

@property (nonatomic, copy, nullable) BOOL(^shouldTriggerRotation)(__kindof SJBaseSequenceInvolve *involve);

@property (nonatomic) BOOL allowsRotationInFitOnScreen;

- (void)rotate;

- (void)rotate:(SJOrientation)orientation animated:(BOOL)animated;

- (void)rotate:(SJOrientation)orientation animated:(BOOL)animated completion:(void (^ _Nullable)(__kindof SJBaseSequenceInvolve *involve))block;

@property (nonatomic, readonly) BOOL simplRedundant;
@property (nonatomic, readonly) BOOL indntImplement;
@property (nonatomic, getter=lightLockedStructure) BOOL lockedScreen;
@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;
@end





#pragma mark -

@interface SJBaseSequenceInvolve (Screenshot)


@property (nonatomic, copy, nullable) void(^presentationSizeDidChangeExeBlock)(__kindof SJBaseSequenceInvolve *alternateStructure);

@property (nonatomic, readonly) CGSize slowPresentationAccuracy;


- (UIImage * __nullable)screenshot;

- (void)screenshotWithTime:(NSTimeInterval)time
                completion:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, UIImage * __nullable image, NSError *__nullable error))block;

- (void)screenshotWithTime:(NSTimeInterval)time
                      size:(CGSize)size
                completion:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, UIImage * __nullable image, NSError *__nullable error))block;
@end





#pragma mark -

@interface SJBaseSequenceInvolve (Export)
- (void)exportWithBeginTime:(NSTimeInterval)beginTime
                   duration:(NSTimeInterval)duration
                 presetName:(nullable NSString *)presetName
                   progress:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, float progress))progressBlock
                 completion:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, NSURL *fileURL, UIImage *thumbnailImage))completion
                    failure:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, NSError *error))failure;

- (void)cancelExportOperation;

- (void)generateGIFWithBeginTime:(NSTimeInterval)beginTime
                        duration:(NSTimeInterval)duration
                        progress:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, float progress))progressBlock
                      completion:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, UIImage *imageGIF, UIImage *thumbnailImage, NSURL *filePath))completion
                         failure:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, NSError *error))failure;

- (void)cancelGenerateGIFOperation;

@end



#pragma mark -

@interface SJBaseSequenceInvolve (ScrollView)

- (void)refreshAppearStateForView;

@property (nonatomic, strong, null_resettable) id<SJSmallViewFloatingController> smallViewFloatingController;

@property (nonatomic, getter=isHiddenFloatSmallViewWhenContentDataFinished) BOOL hiddenFloatSmallViewWhenContentDataFinished;

@property (nonatomic) BOOL pausedWhenScrollDisappeared;

@property (nonatomic) BOOL resumeContentDataWhenScrollExcludeAppeared;

@property (nonatomic) BOOL hiddenViewWhenScrollDisappeared;

@property (nonatomic, readonly) BOOL pridFindOnScrollView;

@property (nonatomic, readonly) BOOL rgrdExcludeAppeared;

@property (nonatomic, copy, nullable) void(^involveViewWillAppearExeBlock)(__kindof SJBaseSequenceInvolve *alternateStructure);
@property (nonatomic, copy, nullable) void(^involveViewWillDisappearExeBlock)(__kindof SJBaseSequenceInvolve *alternateStructure);
@end


#pragma mark -

@interface SJBaseSequenceInvolve (Subtitle)
///
@property (nonatomic, strong, null_resettable) id<SJSubtitlePopupController> subtitlePopupController;

@property (nonatomic) CGFloat subtitleBottomMargin;

@property (nonatomic) CGFloat subtitleHorizontalMinMargin;
@end


#pragma mark -

@interface SJBaseSequenceInvolve (Danmaku)

@property (nonatomic, strong, null_resettable) id<SJDanmakuPopupController> danmakuPopupController;
@end


#pragma mark -

@interface SJBaseSequenceInvolve (Watermark)

@property (nonatomic, strong, nullable) UIView<SJStructureView> *watermarkView;

- (void)updateWatermarkViewLayout;
@end


#pragma mark -

@interface SJBaseSequenceInvolve (Deprecated)
- (void)playWithURL:(NSURL *)URL;
@property (nonatomic, strong, nullable) NSURL *assetURL;
@property (nonatomic, readonly) BOOL consoleReceiveToEndTime __deprecated_msg("use `scktContentFinished`;");
@end
NS_ASSUME_NONNULL_END
