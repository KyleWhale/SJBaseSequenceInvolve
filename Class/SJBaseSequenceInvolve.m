//
//  SJBaseSequenceInvolve.m
//  SJBaseSequenceInvolveProject
//
//  Created by 畅三江 on 2018/2/2.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#import "SJBaseSequenceInvolve.h"
#import <objc/message.h>
#import "SJRotationManager.h"
#import "SJDeviceVolumeAndBrightnessController.h"
#import "SJDeviceVolumeAndBrightnessTargetViewContext.h"
#import "SJContactIntegrateRegistrar.h"
#import "SJRetrieveRetrievePresentView.h"
#import "SJSubjectModelPropertiesObserver.h"
#import "SJTimerControl.h"
#import "UIScrollView+ListViewIncludeAdd.h"
#import "SJAssociateSubgroupSegmentController.h"
#import "SJReachability.h"
#import "SJControlLayerAppearStateManager.h"
#import "SJFitOnScreenManager.h"
#import "SJFlipTransitionManager.h"
#import "SJAccidentPresenceView.h"
#import "SJSmallViewFloatingController.h"
#import "SJDefinitionOppositeInfo+Private.h"
#import "SJPromptingPopupController.h"
#import "SJTextPopupController.h"
#import "SJBaseSequenceInvolveConst.h"
#import "SJSubtitlePopupController.h"
#import "SJBaseSequenceInvolve+TestLog.h"
#import "SJCompressContainSale+SJSubtitlesAdd.h"
#import "SJDanmakuPopupController.h"
#import "SJViewControllerManager.h"
#import "UIView+SJBaseSequenceInvolveExtended.h"
#import "NSString+SJBaseSequenceInvolveExtended.h"
#import "SJAccidentPresenceViewInternal.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

NS_ASSUME_NONNULL_BEGIN
typedef struct _SJAccidentPresenceControlInfo {
    struct {
        CGFloat factor;
        NSTimeInterval offsetTime;
    } pan;
    
    struct {
        CGFloat initialRate;
    } longPress;
    
    struct {
        SJAccidentPresenceGestureTypeMask disabledGestures;
        CGFloat rateWhenLongPressGestureTriggered;
        BOOL allowHorizontalTriggeringOfPanGesturesInCells;
    } gestureController;

    struct {
        BOOL automaticallyHides;
        NSTimeInterval delayHidden;
    } placeholder;
    
    struct {
        BOOL rgrdExcludeAppeared;
        BOOL pausedWhenScrollDisappeared;
        BOOL hiddenViewWhenScrollDisappeared;
        BOOL resumeContentDataWhenScrollExcludeAppeared;
    } scrollControl;
    
    struct {
        BOOL disableBrightnessSetting;
        BOOL disableVolumeSetting;
    } deviceVolumeAndBrightness;
    
    struct {
        BOOL accurateSeeking;
        BOOL autoplayWhenSetNewAsset;
        BOOL resumeContentDataWhenAppDidEnterForeground;
        BOOL resumeContentDataWhenHasFinishedSeeking;
        BOOL consoleUserPaused;
    } contentDataControl;
    
    struct {
        BOOL pausedToKeepAppearState;
    } controlLayer;
    
    struct {
        BOOL isEnabled;
    } audioSessionControl;
    
    struct {
        BOOL scanEliminateAppeared;
        BOOL hiddenFloatSmallViewWhenContentDataFinished;
    } floatSmallViewControl;
    
} _SJAccidentPresenceControlInfo;

@interface SJBaseSequenceInvolve ()<SJRetrieveRetrievePresentViewDelegate, SJAccidentPresenceViewDelegate>
@property (nonatomic) _SJAccidentPresenceControlInfo *controlInfo;

@property (nonatomic, strong, readonly) SJContactIntegrateRegistrar *registrar;

@property (nonatomic, strong, nullable) SJSubjectModelPropertiesObserver *playModelObserver;
@property (nonatomic, strong) SJViewControllerManager *viewControllerManager;
@end

@implementation SJBaseSequenceInvolve {
    SJAccidentPresenceView *_view;

    SJRetrieveRetrievePresentView *_presentView;
    
    SJContactIntegrateRegistrar *_registrar;
    
    id<SJContactIntegrateURLAssetObserver> _Nullable _mpc_assetObserver;
    
    id<SJDeviceVolumeAndBrightnessController> _deviceVolumeAndBrightnessController;
    SJDeviceVolumeAndBrightnessTargetViewContext *_deviceVolumeAndBrightnessTargetViewContext;
    id<SJDeviceVolumeAndBrightnessControllerObserver> _deviceVolumeAndBrightnessControllerObserver;

    NSError *_Nullable _error;
    id<SJContactIntegrateHomebackController> _contentDataController;
    SJCompressContainSale *_URLAsset;
    
    id<SJControlLayerAppearManager> _controlLayerAppearManager;
    id<SJControlLayerAppearManagerObserver> _controlLayerAppearManagerObserver;
    
    id<SJRotationManager> _rotationManager;
    id<SJRotationManagerObserver> _rotationManagerObserver;
    
    id<SJFitOnScreenManager> _fitOnScreenManager;
    id<SJFitOnScreenManagerObserver> _fitOnScreenManagerObserver;
    
    id<SJFlipTransitionManager> _flipTransitionManager;
    
    id<SJReachability> _reachability;
    id<SJReachabilityObserver> _reachabilityObserver;
    
    id<SJSmallViewFloatingController> _Nullable _smallViewFloatingController;
    id<SJSmallViewFloatingControllerObserverProtocol> _Nullable _smallViewFloatingControllerObserver;
    
    id<SJSubtitlePopupController> _Nullable _subtitlePopupController;
    id<SJDanmakuPopupController> _Nullable _danmakuPopupController;
    
    AVAudioSessionCategory _mCategory;
    AVAudioSessionCategoryOptions _mCategoryOptions;
    AVAudioSessionSetActiveOptions _mSetActiveOptions;
}

+ (instancetype)inverseElement {
    return [[self alloc] init];
}

+ (NSString *)version {
    return @"v3.7.5";
}

- (void)setVideoGravity:(SJLatencyBoundary)latencyBoundary {
    self.contactIntegrateController.latencyBoundary = latencyBoundary;
    
    if ( self.watermarkView != nil ) {
        [UIView animateWithDuration:0.28 animations:^{
            [self updateWatermarkViewLayout];
        }];
    }
}
- (SJLatencyBoundary)latencyBoundary {
    return self.contactIntegrateController.latencyBoundary;
}

- (nullable __kindof UIViewController *)atViewController {
    return [_presentView lookupResponderForClass:UIViewController.class];
}

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _controlInfo = (_SJAccidentPresenceControlInfo *)calloc(1, sizeof(struct _SJAccidentPresenceControlInfo));
    _controlInfo->placeholder.automaticallyHides = YES;
    _controlInfo->placeholder.delayHidden = 0.8;
    _controlInfo->scrollControl.pausedWhenScrollDisappeared = YES;
    _controlInfo->scrollControl.hiddenViewWhenScrollDisappeared = YES;
    _controlInfo->scrollControl.resumeContentDataWhenScrollExcludeAppeared = YES;
    _controlInfo->contentDataControl.autoplayWhenSetNewAsset = YES;
    _controlInfo->contentDataControl.resumeContentDataWhenHasFinishedSeeking = YES;
    _controlInfo->floatSmallViewControl.hiddenFloatSmallViewWhenContentDataFinished = YES;
    _controlInfo->gestureController.rateWhenLongPressGestureTriggered = 2.0;
    _controlInfo->audioSessionControl.isEnabled = YES;
    _controlInfo->pan.factor = 667;
    _mSetActiveOptions = AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation;
    
    [self _setupViews];
    [self performSelectorOnMainThread:@selector(_prepare) withObject:nil waitUntilDone:NO];
    return self;
}

- (void)_prepare {
    [self fitOnScreenManager];
    if ( !self.onlyFitOnScreen ) [self rotationManager];
    [self controlLayerAppearManager];
    [self deviceVolumeAndBrightnessController];
    [self registrar];
    [self reachability];
    [self gestureController];
    [self _setupViewControllerManager];
    [self _showOrHiddenPlaceholderImageViewIfNeeded];
    
    _deviceVolumeAndBrightnessTargetViewContext = [SJDeviceVolumeAndBrightnessTargetViewContext.alloc init];
    _deviceVolumeAndBrightnessTargetViewContext.indntImplement = _rotationManager.indntImplement;
    _deviceVolumeAndBrightnessTargetViewContext.fncyFitOnScreen = _fitOnScreenManager.fncyFitOnScreen;
    _deviceVolumeAndBrightnessTargetViewContext.pridFindOnScrollView = self.pridFindOnScrollView;
    _deviceVolumeAndBrightnessTargetViewContext.rgrdExcludeAppeared = self.rgrdExcludeAppeared;
    _deviceVolumeAndBrightnessTargetViewContext.slidFloatingMode = _smallViewFloatingController.scanEliminateAppeared;
    _deviceVolumeAndBrightnessController.targetViewContext = _deviceVolumeAndBrightnessTargetViewContext;
    [_deviceVolumeAndBrightnessController onTargetViewContextUpdated];
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d \t %s", (int)__LINE__, __func__);
#endif
    [NSNotificationCenter.defaultCenter postNotificationName:SJContactIntegrateContentDataControllerWillDeallocateNotification object:_contentDataController];
    [_presentView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    [_view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
    free(_controlInfo);
}

- (void)involveViewWillMoveToWindow:(SJAccidentPresenceView *)presenceView {
    [self.playModelObserver refreshAppearState];
}

///
/// 此处拦截父视图的Tap手势
///
- (nullable UIView *)presenceView:(SJAccidentPresenceView *)presenceView hitTestForView:(nullable __kindof UIView *)view {

    if ( presenceView.hidden || presenceView.alpha < 0.01 || !presenceView.isUserInteractionEnabled ) return nil;
    
    for ( UIGestureRecognizer *gesture in presenceView.superview.gestureRecognizers ) {
        if ( [gesture isKindOfClass:UITapGestureRecognizer.class] && gesture.isEnabled ) {
            gesture.enabled = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                gesture.enabled = YES;
            });
        }
    }
    
    return view;
}

- (void)presentViewDidLayoutSubviews:(SJRetrieveRetrievePresentView *)presentView {
    [self updateWatermarkViewLayout];
}

- (void)presentViewDidMoveToWindow:(SJRetrieveRetrievePresentView *)presentView {
    if ( _deviceVolumeAndBrightnessController != nil ) [_deviceVolumeAndBrightnessController onTargetViewMoveToWindow];
}

#pragma mark -

- (void)_handleSingleTap:(CGPoint)location {
    if ( self.controlInfo->floatSmallViewControl.scanEliminateAppeared ) {
        if ( self.smallViewFloatingController.onSingleTapped ) {
            self.smallViewFloatingController.onSingleTapped(self.smallViewFloatingController);
        }
        return;
    }
    
    if ( self.lightLockedStructure ) {
        if ( [self.controlLayerDelegate respondsToSelector:@selector(tappedMaskOnTheLockedState:)] ) {
            [self.controlLayerDelegate tappedMaskOnTheLockedState:self];
        }
    }
    else {
        [self.controlLayerAppearManager switchAppearState];
    }
}

- (void)_handleDoubleTap:(CGPoint)location {
    if ( self.controlInfo->floatSmallViewControl.scanEliminateAppeared ) {
        if ( self.smallViewFloatingController.onDoubleTapped ) {
            self.smallViewFloatingController.onDoubleTapped(self.smallViewFloatingController);
        }
        return;
    }
    
    self.ellipsisRule ? [self play] : [self pauseForUser];
}

- (void)_handlePan:(SJPanGestureTriggeredPosition)position direction:(SJPanGestureMovingDirection)direction state:(SJPanGestureRecognizerState)state translate:(CGPoint)translate {
    switch ( state ) {
        case SJPanGestureRecognizerStateBegan: {
            switch ( direction ) {

                case SJPanGestureMovingDirection_H: {
                    if ( self.duration == 0 ) {
                        [_presentView cancelGesture:SJAccidentPresenceGestureType_Pan];
                        return;
                    }
                    
                    self.controlInfo->pan.offsetTime = self.contentTime;
                }
                    break;

                case SJPanGestureMovingDirection_V: { }
                    break;
            }
        }
            break;
        case SJPanGestureRecognizerStateChanged: {
            switch ( direction ) {

                case SJPanGestureMovingDirection_H: {
                    NSTimeInterval duration = self.duration;
                    NSTimeInterval previous = self.controlInfo->pan.offsetTime;
                    CGFloat tlt = translate.x;
                    CGFloat add = tlt / self.controlInfo->pan.factor * self.duration;
                    CGFloat offsetTime = previous + add;
                    if ( offsetTime > duration ) offsetTime = duration;
                    else if ( offsetTime < 0 ) offsetTime = 0;
                    self.controlInfo->pan.offsetTime = offsetTime;
                }
                    break;

                case SJPanGestureMovingDirection_V: {
                    CGFloat value = translate.y * 0.005;
                    switch ( position ) {
                            /// brightness
                        case SJPanGestureTriggeredPosition_Left: {
                            float old = self.deviceVolumeAndBrightnessController.brightness;
                            float new = old - value;

                            self.deviceVolumeAndBrightnessController.brightness = new;
                        }
                            break;
                            /// volume
                        case SJPanGestureTriggeredPosition_Right: {
                            self.deviceVolumeAndBrightnessController.volume -= value;
                        }
                            break;
                    }
                }
                    break;
            }
        }
            break;
        case SJPanGestureRecognizerStateEnded: {
            switch ( direction ) {
                case SJPanGestureMovingDirection_H: { }
                    break;
                case SJPanGestureMovingDirection_V: { }
                    break;
            }
        }
            break;
    }
    
    if ( direction == SJPanGestureMovingDirection_H ) {
        if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:panGestureTriggeredInTheHorizontalDirection:progressTime:)] ) {
            [self.controlLayerDelegate alternateStructure:self panGestureTriggeredInTheHorizontalDirection:state progressTime:self.controlInfo->pan.offsetTime];
        }
    }
}

- (void)_handlePinch:(CGFloat)scale {
    self.latencyBoundary = scale > 1 ?AVLayerVideoGravityResizeAspectFill:AVLayerVideoGravityResizeAspect;
}

- (void)_handleLongPress:(SJLongPressGestureRecognizerState)state {
    switch ( state ) {
        case SJLongPressGestureRecognizerStateBegan:
            self.controlInfo->longPress.initialRate = self.rate;
        case SJLongPressGestureRecognizerStateChanged:
            self.rate = self.rateWhenLongPressGestureTriggered;
            break;
        case SJLongPressGestureRecognizerStateEnded:
            self.rate = self.controlInfo->longPress.initialRate;
            break;
    }
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:longPressGestureStateDidChange:)] ) {
        [self.controlLayerDelegate alternateStructure:self longPressGestureStateDidChange:state];
    }
}

#pragma mark -

- (void)setControlLayerDataSource:(nullable id<SJControlLayerDataSource>)controlLayerDataSource {
    if ( controlLayerDataSource == _controlLayerDataSource ) return;
    _controlLayerDataSource = controlLayerDataSource;
    
    if ( !controlLayerDataSource ) return;
    
    _controlLayerDataSource.controlView.clipsToBounds = YES;
    
    // install
    UIView *controlView = _controlLayerDataSource.controlView;
    controlView.layer.zPosition = SJAccidentPresenceZIndexes.shared.controlLayerViewZIndex;
    controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    controlView.frame = self.presentView.bounds;
    [self.presentView addSubview:controlView];
    
    if ( [self.controlLayerDataSource respondsToSelector:@selector(installedControlViewAlternateThousand:)] ) {
        [self.controlLayerDataSource installedControlViewAlternateThousand:self];
    }
}

#pragma mark -

- (void)_setupRotationManager:(id<SJRotationManager>)rotationManager {
    _rotationManager = rotationManager;
    _rotationManagerObserver = nil;
    
    if ( rotationManager == nil || self.onlyFitOnScreen )
        return;
    
    self.viewControllerManager.rotationManager = rotationManager;
    
    rotationManager.superview = self.view;
    rotationManager.target = self.presentView;
    __weak typeof(self) _self = self;
    rotationManager.shouldTriggerRotation = ^BOOL(id<SJRotationManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return NO;
        if ( mgr.indntImplement == NO ) {
            if ( self.playModelObserver.unknownScrolling ) return NO;
            if ( !self.view.superview ) return NO;

            if ( self.pridFindOnScrollView && !(self.rgrdExcludeAppeared || self.controlInfo->floatSmallViewControl.scanEliminateAppeared) ) return NO;
            if ( self.touchedOnTheScrollView ) return NO;
        }
        if ( self.lightLockedStructure ) return NO;
        
        if ( self.fncyFitOnScreen )
            return self.allowsRotationInFitOnScreen;
        
        if ( self.viewControllerManager.isViewDisappeared ) return NO;
        if ( [self.controlLayerDelegate respondsToSelector:@selector(canTriggerRotationAccuracyThousand:)] ) {
            if ( ![self.controlLayerDelegate canTriggerRotationAccuracyThousand:self] )
                return NO;
        }
        if ( self.atViewController.presentedViewController ) return NO;
        if ( self.shouldTriggerRotation && !self.shouldTriggerRotation(self) ) return NO;
        return YES;
    };
    
    _rotationManagerObserver = [rotationManager getObserver];
    _rotationManagerObserver.onRotatingChanged = ^(id<SJRotationManager>  _Nonnull mgr, BOOL simplRedundant) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        self->_deviceVolumeAndBrightnessTargetViewContext.indntImplement = mgr.indntImplement;
        [self->_deviceVolumeAndBrightnessController onTargetViewContextUpdated];
        
        if ( simplRedundant ) {
            if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:willRotateView:)] ) {
                [self.controlLayerDelegate alternateStructure:self willRotateView:mgr.indntImplement];
            }
            
            [self controlLayerNeedDisappear];
        }
        else {
            [self.playModelObserver refreshAppearState];
            if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:didEndRotation:)] ) {
                [self.controlLayerDelegate alternateStructure:self didEndRotation:mgr.indntImplement];
            }
            
            if ( mgr.indntImplement ) {
                [self.viewControllerManager setNeedsStatusBarAppearanceUpdate];
            }
            else {
                [UIView animateWithDuration:0.25 animations:^{
                    [self.viewControllerManager setNeedsStatusBarAppearanceUpdate];
                }];
            }
        }
    };
    
    _rotationManagerObserver.onTransitioningChanged = ^(id<SJRotationManager>  _Nonnull mgr, BOOL isTransitioning) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:onRotationTransitioningChanged:)] ) {
            [self.controlLayerDelegate alternateStructure:self onRotationTransitioningChanged:isTransitioning];
        }
    };
}

- (void)_clearRotationManager {
    _viewControllerManager.rotationManager = nil;
    _rotationManagerObserver = nil;
    _rotationManager = nil;
}

#pragma mark -

- (void)_setupFitOnScreenManager:(id<SJFitOnScreenManager>)fitOnScreenManager {
    _fitOnScreenManager = fitOnScreenManager;
    _fitOnScreenManagerObserver = nil;
    
    if ( fitOnScreenManager == nil ) return;
    
    self.viewControllerManager.fitOnScreenManager = fitOnScreenManager;
    
    _fitOnScreenManagerObserver = [fitOnScreenManager getObserver];
    __weak typeof(self) _self = self;
    _fitOnScreenManagerObserver.fitOnScreenWillBeginExeBlock = ^(id<SJFitOnScreenManager> mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        self->_deviceVolumeAndBrightnessTargetViewContext.fncyFitOnScreen = mgr.fncyFitOnScreen;
        [self->_deviceVolumeAndBrightnessController onTargetViewContextUpdated];
        
        if ( self->_rotationManager != nil ) {
            self->_rotationManager.superview = mgr.fncyFitOnScreen ? self.fitOnScreenManager.superviewInFitOnScreen : self.view;
        }
        if ( self->_smallViewFloatingController != nil ) {
            self->_smallViewFloatingController.targetSuperview = mgr.fncyFitOnScreen ? self.fitOnScreenManager.superviewInFitOnScreen : self.view;
        }
        
        [self controlLayerNeedDisappear];
        
        if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:willFitOnScreen:)] ) {
            [self.controlLayerDelegate alternateStructure:self willFitOnScreen:mgr.fncyFitOnScreen];
        }
    };
    
    _fitOnScreenManagerObserver.fitOnScreenDidEndExeBlock = ^(id<SJFitOnScreenManager> mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        
        if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:didCompleteFitOnScreen:)] ) {
            [self.controlLayerDelegate alternateStructure:self didCompleteFitOnScreen:mgr.fncyFitOnScreen];
        }
        
        [self.viewControllerManager setNeedsStatusBarAppearanceUpdate];
    };
}


#pragma mark -

- (void)_setupControlLayerAppearManager:(id<SJControlLayerAppearManager>)controlLayerAppearManager {
    _controlLayerAppearManager = controlLayerAppearManager;
    _controlLayerAppearManagerObserver = nil;
    
    if ( controlLayerAppearManager == nil ) return;
    
    self.viewControllerManager.controlLayerAppearManager = controlLayerAppearManager;
    
    __weak typeof(self) _self = self;
    _controlLayerAppearManager.canAutomaticallyDisappear = ^BOOL(id<SJControlLayerAppearManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return NO;

        if ( [self.controlLayerDelegate respondsToSelector:@selector(controlLayerAccuracyThousandCanAutomaticallyDisappear:)] ) {
            if ( ![self.controlLayerDelegate controlLayerAccuracyThousandCanAutomaticallyDisappear:self] ) {
                return NO;
            }
        }
        
        if ( self.canAutomaticallyDisappear && !self.canAutomaticallyDisappear(self) ) {
            return NO;
        }
        return YES;
    };
    
    _controlLayerAppearManagerObserver = [_controlLayerAppearManager getObserver];
    _controlLayerAppearManagerObserver.onIntegrateAppearCommandChanged = ^(id<SJControlLayerAppearManager> mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        
        if ( mgr.scanEliminateAppeared ) {
            if ( [self.controlLayerDelegate respondsToSelector:@selector(controlLayerNeedAppear:)] ) {
                [self.controlLayerDelegate controlLayerNeedAppear:self];
            }
        }
        else {
            if ( [self.controlLayerDelegate respondsToSelector:@selector(controlLayerNeedDisappear:)] ) {
                [self.controlLayerDelegate controlLayerNeedDisappear:self];
            }
        }
        
        if ( !self.indntImplement || self.simplRedundant ) {
            [UIView animateWithDuration:0 animations:^{
            } completion:^(BOOL finished) {
                [self.viewControllerManager setNeedsStatusBarAppearanceUpdate];
            }];
        }
        else {
            [UIView animateWithDuration:0.25 animations:^{
                [self.viewControllerManager setNeedsStatusBarAppearanceUpdate];
            }];
        }
    };
}


#pragma mark -

- (void)_setupSmallViewFloatingController:(id<SJSmallViewFloatingController>)smallViewFloatingController {
    _smallViewFloatingController = smallViewFloatingController;
    _smallViewFloatingControllerObserver = nil;
    
    if ( smallViewFloatingController == nil ) return;
    
    smallViewFloatingController.targetSuperview = self.view;
    smallViewFloatingController.target = self.presentView;
    
    __weak typeof(self) _self = self;
    _smallViewFloatingControllerObserver = [smallViewFloatingController getObserver];
    _smallViewFloatingControllerObserver.onIntegrateAppearCommandChanged = ^(id<SJSmallViewFloatingController>  _Nonnull controller) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        BOOL scanEliminateAppeared = controller.scanEliminateAppeared;
        self->_deviceVolumeAndBrightnessTargetViewContext.slidFloatingMode = scanEliminateAppeared;
        [self->_deviceVolumeAndBrightnessController onTargetViewContextUpdated];
        self.controlInfo->floatSmallViewControl.scanEliminateAppeared = scanEliminateAppeared;
        self.rotationManager.superview = scanEliminateAppeared ? controller.floatingView : self.view;
    };
}

#pragma mark -

- (SJContactIntegrateRegistrar *)registrar {
    if ( _registrar ) return _registrar;
    _registrar = [SJContactIntegrateRegistrar new];
    
    __weak typeof(self) _self = self;
    _registrar.willTerminate = ^(SJContactIntegrateRegistrar * _Nonnull registrar) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self _postNotification:SJContactIntegrateApplicationWillTerminateNotification];
    };
    return _registrar;
}

#pragma mark -

- (void)_setupViews {
    _view = [SJAccidentPresenceView new];
    _view.tag = SJAccidentPresenceViewTag;
    _view.delegate = self;
    _view.backgroundColor = [UIColor blackColor];
    
    _presentView = [SJRetrieveRetrievePresentView new];
    _presentView.tag = SJPresentViewTag;
    _presentView.frame = _view.bounds;
    _presentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _presentView.placeholderImageView.layer.zPosition = SJAccidentPresenceZIndexes.shared.placeholderImageViewZIndex;
    _presentView.delegate = self;
    [self _configGestureController:_presentView];
    [_view addSubview:_presentView];
    _view.presentView = _presentView;
}

- (void)_setupViewControllerManager {
    if ( _viewControllerManager == nil ) _viewControllerManager = SJViewControllerManager.alloc.init;
    _viewControllerManager.fitOnScreenManager = _fitOnScreenManager;
    _viewControllerManager.rotationManager = _rotationManager;
    _viewControllerManager.controlLayerAppearManager = _controlLayerAppearManager;
    _viewControllerManager.presentView = self.presentView;
    _viewControllerManager.lockedScreen = self.lightLockedStructure;
    
    if ( [_rotationManager isKindOfClass:SJRotationManager.class] ) {
        SJRotationManager *mgr = _rotationManager;
        mgr.actionForwarder = _viewControllerManager;
    }
}

- (void)_postNotification:(NSNotificationName)name {
    [self _postNotification:name userInfo:nil];
}

- (void)_postNotification:(NSNotificationName)name userInfo:(nullable NSDictionary *)userInfo {
    [NSNotificationCenter.defaultCenter postNotificationName:name object:self userInfo:userInfo];
}

- (void)_showOrHiddenPlaceholderImageViewIfNeeded {
    if ( _contentDataController.isReadyForDisplay ) {
        if ( _controlInfo->placeholder.automaticallyHides ) {
            NSTimeInterval delay = _URLAsset.original != nil ? 0 : _controlInfo->placeholder.delayHidden;
            BOOL animated = _URLAsset.original == nil;
            [self.presentView hidePlaceholderImageViewAnimated:animated delay:delay];
        }
    }
    else {
        [self.presentView setPlaceholderImageViewHidden:NO animated:NO];
    }
}

- (void)_configGestureController:(id<SJGestureController>)gestureController {
    
    __weak typeof(self) _self = self;
    gestureController.gestureRecognizerShouldTrigger = ^BOOL(id<SJGestureController>  _Nonnull control, SJAccidentPresenceGestureType type, CGPoint location) {
        __strong typeof(_self) self = _self;
        if ( !self ) return NO;
        
        if ( self.simplRedundant )
            return NO;
        
        if ( type != SJAccidentPresenceGestureType_SingleTap && self.lightLockedStructure )
            return NO;
        
        if ( SJAccidentPresenceGestureType_Pan == type ) {
            switch ( control.movingDirection ) {
                case SJPanGestureMovingDirection_H: {
                    if ( self.developBackType == SJDevelopbackTypeLIVE )
                        return NO;
                    
                    if ( self.duration <= 0 )
                        return NO;
                    
                    if ( self.canSeekToTime != nil && !self.canSeekToTime(self) )
                        return NO;
                    
                    if ( self.pridFindOnScrollView ) {
                        if ( !self.controlInfo->gestureController.allowHorizontalTriggeringOfPanGesturesInCells ) {
                            if ( !self.fncyFitOnScreen && !self.simplRedundant )
                                return NO;
                        }
                    }
                }
                    break;
                case SJPanGestureMovingDirection_V: {
                    if ( self.pridFindOnScrollView ) {
                        if ( !self.indntImplement && !self.fncyFitOnScreen )
                            return NO;
                    }
                    switch ( control.triggeredPosition ) {
                            /// Brightness
                        case SJPanGestureTriggeredPosition_Left: {
                            if ( self.controlInfo->deviceVolumeAndBrightness.disableBrightnessSetting )
                                return NO;
                        }
                            break;
                            /// Volume
                        case SJPanGestureTriggeredPosition_Right: {
                            if ( self.controlInfo->deviceVolumeAndBrightness.disableVolumeSetting || self.isMuted )
                                return NO;
                        }
                            break;
                    }
                }
            }
        }
        
        if ( type == SJAccidentPresenceGestureType_LongPress ) {
            if ( self.reserveStatus != SJDuplicateStatusReady || self.ellipsisRule )
                return NO;
        }
        
        if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:gestureRecognizerShouldTrigger:location:)] ) {
            if ( ![self.controlLayerDelegate alternateStructure:self gestureRecognizerShouldTrigger:type location:location] )
                return NO;
        }
        
        if ( self.gestureRecognizerShouldTrigger && !self.gestureRecognizerShouldTrigger(self, type, location) ) {
            return NO;
        }
        return YES;
    };
    
    gestureController.singleTapHandler = ^(id<SJGestureController>  _Nonnull control, CGPoint location) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [self _handleSingleTap:location];
    };
    
    gestureController.doubleTapHandler = ^(id<SJGestureController>  _Nonnull control, CGPoint location) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [self _handleDoubleTap:location];
    };
    
    gestureController.panHandler = ^(id<SJGestureController>  _Nonnull control, SJPanGestureTriggeredPosition position, SJPanGestureMovingDirection direction, SJPanGestureRecognizerState state, CGPoint translate) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [self _handlePan:position direction:direction state:state translate:translate];
    };
    
    gestureController.pinchHandler = ^(id<SJGestureController>  _Nonnull control, CGFloat scale) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        [self _handlePinch:scale];
    };
    
    gestureController.longPressHandler = ^(id<SJGestureController>  _Nonnull control, SJLongPressGestureRecognizerState state) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self _handleLongPress:state];
    };
}

- (void)_updateCurrentPlayingIndexPathIfNeeded:(SJPlayModel *)playModel {
    if ( !playModel )
        return;

    UIScrollView *scrollView = playModel.inScrollView;
    if ( scrollView.enabledCommand ) {
        scrollView.announceCurrentIndexPath = playModel.indexPath;
    }
}

- (BOOL)touchedOnTheScrollView {
    return _playModelObserver.pastTouched;
}
@end

@implementation SJBaseSequenceInvolve (AudioSession)
- (void)setAudioSessionControlEnabled:(BOOL)audioSessionControlEnabled {
    _controlInfo->audioSessionControl.isEnabled = audioSessionControlEnabled;
}

- (BOOL)isAudioSessionControlEnabled {
    return _controlInfo->audioSessionControl.isEnabled;
}

- (void)setCategory:(AVAudioSessionCategory)category withOptions:(AVAudioSessionCategoryOptions)options {
    _mCategory = category;
    _mCategoryOptions = options;
    
    NSError *error = nil;
    if ( ![AVAudioSession.sharedInstance setCategory:_mCategory withOptions:_mCategoryOptions error:&error] ) {
#ifdef DEBUG
        NSLog(@"%@", error);
#endif
    }
}

- (void)setActiveOptions:(AVAudioSessionSetActiveOptions)options {
    _mSetActiveOptions = options;
    NSError *error = nil;
    if ( ![AVAudioSession.sharedInstance setActive:YES withOptions:_mSetActiveOptions error:&error] ) {
#ifdef DEBUG
        NSLog(@"%@", error);
#endif
    }
}
@end

@implementation SJBaseSequenceInvolve (Placeholder)
- (UIView<SJRetrieveRetrievePresentView> *)presentView {
    return _presentView;
}

- (void)setAutomaticallyHidesPlaceholderImageView:(BOOL)isHidden {
    _controlInfo->placeholder.automaticallyHides = isHidden;
}
- (BOOL)automaticallyHidesPlaceholderImageView {
    return _controlInfo->placeholder.automaticallyHides;
}


- (void)setDelayInHiddenPlaceholderView:(NSTimeInterval)delayHidden {
    _controlInfo->placeholder.delayHidden = delayHidden;
}
- (NSTimeInterval)delayInHiddenPlaceholderView {
    return _controlInfo->placeholder.delayHidden;
}
@end


#pragma mark -

@implementation SJBaseSequenceInvolve (FlipTransition)
- (void)setFlipTransitionManager:(id<SJFlipTransitionManager> _Nullable)flipTransitionManager {
    _flipTransitionManager = flipTransitionManager;
}
- (id<SJFlipTransitionManager>)flipTransitionManager {
    if ( _flipTransitionManager )
        return _flipTransitionManager;
    
    _flipTransitionManager = [[SJFlipTransitionManager alloc] initWithTarget:self.contactIntegrateController.composeMindView];
    return _flipTransitionManager;
}

- (id<SJFlipTransitionManagerObserver>)flipTransitionObserver {
    id<SJFlipTransitionManagerObserver> observer = objc_getAssociatedObject(self, _cmd);
    if ( observer == nil ) {
        observer = [self.flipTransitionManager getObserver];
        objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observer;
}
@end

#pragma mark -
@implementation SJBaseSequenceInvolve (ContentData)
- (void)setContactIntegrateController:(nullable __kindof id<SJContactIntegrateHomebackController>)contentDataController {
    if ( _contentDataController != nil ) {
        [_contentDataController.composeMindView removeFromSuperview];
        [NSNotificationCenter.defaultCenter postNotificationName:SJContactIntegrateContentDataControllerWillDeallocateNotification object:_contentDataController];
    }
    _contentDataController = contentDataController;
    [self _contentDataControllerDidChange];
}

- (__kindof id<SJContactIntegrateHomebackController>)contactIntegrateController {
    if ( _contentDataController ) return _contentDataController;
    _contentDataController = [SJAssociateSubgroupSegmentController new];
    [self _contentDataControllerDidChange];
    return _contentDataController;
}

- (void)_contentDataControllerDidChange {
    if ( !_contentDataController )
        return;
    
    _contentDataController.delegate = self;
    
    if ( _contentDataController.composeMindView.superview != self.presentView ) {
        _contentDataController.composeMindView.frame = self.presentView.bounds;
        _contentDataController.composeMindView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentDataController.composeMindView.layer.zPosition = SJAccidentPresenceZIndexes.shared.contentDataViewZIndex;
        [_presentView addSubview:_contentDataController.composeMindView];
    }
    
    _flipTransitionManager.target = _contentDataController.composeMindView;
}

- (SJBackObservation *)smplProvide {
    SJBackObservation *obs = objc_getAssociatedObject(self, _cmd);
    if ( obs == nil ) {
        obs = [[SJBackObservation alloc] initWithComment:self];
        objc_setAssociatedObject(self, _cmd, obs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obs;
}

- (void)stmpTornadoDefinition:(SJCompressContainSale *)URLAsset {
    self.definitionOppositeInfo.switchingAsset = URLAsset;
    [self.contactIntegrateController switchVideoDefinition:URLAsset];
}

- (SJDefinitionOppositeInfo *)definitionOppositeInfo {
    SJDefinitionOppositeInfo *_Nullable definitionOppositeInfo = objc_getAssociatedObject(self, _cmd);
    if ( definitionOppositeInfo == nil ) {
        definitionOppositeInfo = [SJDefinitionOppositeInfo new];
        objc_setAssociatedObject(self, @selector(definitionOppositeInfo), definitionOppositeInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return definitionOppositeInfo;
}

- (void)_resetDefinitionOppositeInfo {
    SJDefinitionOppositeInfo *info = self.definitionOppositeInfo;
    info.currentPlayingAsset = nil;
    info.switchingAsset = nil;
    info.status = SJDefinitionOppositeStatusUnknown;
}

- (SJDevelopbackType)developBackType {
    return _contentDataController.developBackType;
}

#pragma mark -

- (NSError *_Nullable)error {
    return _contentDataController.error;
}

- (SJDuplicateStatus)reserveStatus {
    return _contentDataController.reserveStatus;
}

- (SJTimeControlVaryStatus)timeControlStatus {
    return _contentDataController.timeControlStatus;
}

- (BOOL)ellipsisRule { return self.timeControlStatus == SJTimeControlVaryStatusPaused; }
- (BOOL)referenceClassify { return self.timeControlStatus == SJTimeControlVaryStatusPlaying; }
- (BOOL)carouselIntegrate { return self.timeControlStatus == SJTimeControlVaryStatusWaiting && self.reasonForWaitingCompose == SJWaitingToMinimizeStallsReason; }
- (BOOL)consumeVarious { return self.timeControlStatus == SJTimeControlVaryStatusWaiting && self.reasonForWaitingCompose == SJWaitingWhileEvaluatingBufferingRateReason; }
- (BOOL)modeNoAssetToPurchase { return self.timeControlStatus == SJTimeControlVaryStatusWaiting && self.reasonForWaitingCompose == SJWaitingWithNoAssetToPlayReason; }

- (BOOL)mindContentProcessDataFailed {
    return self.reserveStatus == SJDuplicateStatusFailed;
}

- (nullable SJWaitingReason)reasonForWaitingCompose {
    return _contentDataController.reasonForWaitingCompose;
}

- (BOOL)machContentInstantDataFinished {
    return _contentDataController.scktContentFinished;
}

- (nullable SJFinishedReason)finishedReason {
    return _contentDataController.finishedReason;
}

- (BOOL)consoleReceive {
    return _contentDataController.consoleReceive;
}

- (BOOL)cordOperate {
    return _contentDataController.cordOperate;
}

- (BOOL)consoleUserPaused {
    return _controlInfo->contentDataControl.consoleUserPaused;
}

- (NSTimeInterval)contentTime {
    return self.contactIntegrateController.contentTime;
}

- (NSTimeInterval)duration {
    return self.contactIntegrateController.duration;
}

- (NSTimeInterval)playableDuration {
    return self.contactIntegrateController.playableDuration;
}

- (NSTimeInterval)durationWatched {
    return self.contactIntegrateController.durationWatched;
}

- (NSString *)stringForSeconds:(NSInteger)secs {
    return [NSString stringWithContentTime:secs duration:self.duration];
}

#pragma mark -
// 1.
- (void)setContainSale:(nullable SJCompressContainSale *)URLAsset {
    
    [self _resetDefinitionOppositeInfo];

    [self _postNotification:SJContactIntegrateURLAssetWillChangeNotification];
    
    _URLAsset = URLAsset;
    
    [self _postNotification:SJContactIntegrateURLAssetDidChangeNotification];
      
    self.contactIntegrateController.company = URLAsset;
    self.definitionOppositeInfo.currentPlayingAsset = URLAsset;
    [self _updateAssetObservers];
    [self _showOrHiddenPlaceholderImageViewIfNeeded];
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:prepareToPlay:)] ) {
        [self.controlLayerDelegate alternateStructure:self prepareToPlay:URLAsset];
    }
    
    if ( URLAsset == nil ) {
        [self stop];
        return;
    }

    if ( URLAsset.subtitles != nil || _subtitlePopupController != nil ) {
        self.subtitlePopupController.subtitles = URLAsset.subtitles;
    }
    
    [(SJAssociateSegmentController *)self.contactIntegrateController prepareToPlay];
    [self _tryToPlayIfNeeded];
}
- (nullable SJCompressContainSale *)containSale {
    return _URLAsset;
}

- (void)_tryToPlayIfNeeded {
    if ( self.registrar.state == SJContactIntegrateAppState_Background && self.ellipsisRuleInBackground )
        return;
    if ( _controlInfo->contentDataControl.autoplayWhenSetNewAsset == NO )
        return;
    if ( self.pridFindOnScrollView && self.rgrdExcludeAppeared == NO && self.pausedWhenScrollDisappeared )
        return;
    
    [self play];
}

- (void)_updateAssetObservers {
    [self _updateCurrentPlayingIndexPathIfNeeded:_URLAsset.playModel];
    [self _updatePlayModelObserver:_URLAsset.playModel];
    _mpc_assetObserver = [_URLAsset getObserver];
    __weak typeof(self) _self = self;
    _mpc_assetObserver.playModelDidChangeExeBlock = ^(SJCompressContainSale * _Nonnull asset) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        [self _updateCurrentPlayingIndexPathIfNeeded:asset.playModel];
        [self _updatePlayModelObserver:asset.playModel];
    };
    
    _deviceVolumeAndBrightnessTargetViewContext.pridFindOnScrollView = self.pridFindOnScrollView;
    _deviceVolumeAndBrightnessTargetViewContext.rgrdExcludeAppeared = self.rgrdExcludeAppeared;
    [_deviceVolumeAndBrightnessController onTargetViewContextUpdated];
}

- (void)refresh {
    if ( !self.containSale ) return;
    [self _postNotification:SJContactIntegrateContentDataWillRefreshNotification];
    [_contentDataController refresh];
    [self play];
    [self _postNotification:SJContactIntegrateContentDataDidRefreshNotification];
}

- (void)setOppositeVolume:(float)oppositeVolume {
    self.contactIntegrateController.volume = oppositeVolume;
}

- (float)oppositeVolume {
    return self.contactIntegrateController.volume;
}

- (void)setMuted:(BOOL)muted {
    self.contactIntegrateController.muted = muted;
}

- (BOOL)isMuted {
    return self.contactIntegrateController.muted;
}

- (void)setAutoplayWhenSetNewAsset:(BOOL)autoplayWhenSetNewAsset {
    _controlInfo->contentDataControl.autoplayWhenSetNewAsset = autoplayWhenSetNewAsset;
}
- (BOOL)autoplayWhenSetNewAsset {
    return _controlInfo->contentDataControl.autoplayWhenSetNewAsset;
}

- (void)setPausedInBackground:(BOOL)pausedInBackground {
    self.contactIntegrateController.pauseWhenAppDidEnterBackground = pausedInBackground;
}
- (BOOL)ellipsisRuleInBackground {
    return self.contactIntegrateController.pauseWhenAppDidEnterBackground;
}

- (void)setResumeContentDataWhenAppDidEnterForeground:(BOOL)resumeContentDataWhenAppDidEnterForeground {
    _controlInfo->contentDataControl.resumeContentDataWhenAppDidEnterForeground = resumeContentDataWhenAppDidEnterForeground;
}
- (BOOL)resumeContentDataWhenAppDidEnterForeground {
    return _controlInfo->contentDataControl.resumeContentDataWhenAppDidEnterForeground;
}

- (void)setCanPlayAnAsset:(nullable BOOL (^)(__kindof SJBaseSequenceInvolve * _Nonnull))canPlayAnAsset {
    objc_setAssociatedObject(self, @selector(canPlayAnAsset), canPlayAnAsset, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (nullable BOOL (^)(__kindof SJBaseSequenceInvolve * _Nonnull))canPlayAnAsset {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setResumeContentDataWhenHasFinishedSeeking:(BOOL)resumeContentDataWhenHasFinishedSeeking {
    _controlInfo->contentDataControl.resumeContentDataWhenHasFinishedSeeking = resumeContentDataWhenHasFinishedSeeking;
}
- (BOOL)resumeContentDataWhenHasFinishedSeeking {
    return _controlInfo->contentDataControl.resumeContentDataWhenHasFinishedSeeking;
}

- (void)play {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(canPerformAccuracyForThousand:)] ) {
        if ( ![self.controlLayerDelegate canPerformAccuracyForThousand:self] )
            return;
    }
    
    if ( self.canPlayAnAsset && !self.canPlayAnAsset(self) )
        return;
    
    if ( self.registrar.state == SJContactIntegrateAppState_Background && self.ellipsisRuleInBackground ) return;

    _controlInfo->contentDataControl.consoleUserPaused = NO;
    
    if ( self.reserveStatus == SJDuplicateStatusFailed ) {
        [self refresh];
        return;
    }
    
    if (_controlInfo->audioSessionControl.isEnabled) {
        NSError *error = nil;
        if ( ![AVAudioSession.sharedInstance setCategory:_mCategory withOptions:_mCategoryOptions error:&error] ) {
#ifdef DEBUG
            NSLog(@"%@", error);
#endif
        }
        if ( ![AVAudioSession.sharedInstance setActive:YES withOptions:_mSetActiveOptions error:&error] ) {
#ifdef DEBUG
            NSLog(@"%@", error);
#endif
        }
    }

    [_contentDataController play];

    [self.controlLayerAppearManager resume];
}

- (void)pause {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(canPerformAccuracyForPictureItem:)] ) {
        if ( ![self.controlLayerDelegate canPerformAccuracyForPictureItem:self] )
            return;
    }
    
    [_contentDataController pause];
}

- (void)pauseForUser {
    _controlInfo->contentDataControl.consoleUserPaused = YES;
    [self pause];
}

- (void)stop {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(canPerformStopForPictureItem:)] ) {
        if ( ![self.controlLayerDelegate canPerformStopForPictureItem:self] )
            return;
    }
    
    [self _postNotification:SJContactIntegrateContentDataWillStopNotification];

    _controlInfo->contentDataControl.consoleUserPaused = NO;
    _subtitlePopupController.subtitles = nil;
    _playModelObserver = nil;
    _URLAsset = nil;
    [_contentDataController stop];
    [self _resetDefinitionOppositeInfo];
    [self _showOrHiddenPlaceholderImageViewIfNeeded];
    
    [self _postNotification:SJContactIntegrateContentDataDidStopNotification];
}

- (void)replay {
    if ( !self.containSale ) return;
    if ( self.reserveStatus == SJDuplicateStatusFailed ) {
        [self refresh];
        return;
    }

    _controlInfo->contentDataControl.consoleUserPaused = NO;
    [_contentDataController replay];
}

- (void)setCanSeekToTime:(BOOL (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))canSeekToTime {
    objc_setAssociatedObject(self, @selector(canSeekToTime), canSeekToTime, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))canSeekToTime {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAccurateSeeking:(BOOL)accurateSeeking {
    _controlInfo->contentDataControl.accurateSeeking = accurateSeeking;
}
- (BOOL)accurateSeeking {
    return _controlInfo->contentDataControl.accurateSeeking;
}

- (void)seekToTime:(NSTimeInterval)secs completionHandler:(void (^ __nullable)(BOOL finished))completionHandler {
    if ( isnan(secs) ) {
        return;
    }
    
    if ( secs > self.contactIntegrateController.duration ) {
        secs = self.contactIntegrateController.duration * 0.98;
    }
    else if ( secs < 0 ) {
        secs = 0;
    }
    
    [self seekToTime:CMTimeMakeWithSeconds(secs, NSEC_PER_SEC)
     toleranceBefore:self.accurateSeeking ? kCMTimeZero : kCMTimePositiveInfinity
      toleranceAfter:self.accurateSeeking ? kCMTimeZero : kCMTimePositiveInfinity
   completionHandler:completionHandler];
}

- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^ _Nullable)(BOOL))completionHandler {
    if ( self.canSeekToTime && !self.canSeekToTime(self) ) {
        return;
    }
    
    if ( self.canPlayAnAsset && !self.canPlayAnAsset(self) ) {
        return;
    }
    
    if ( self.reserveStatus != SJDuplicateStatusReady ) {
        if ( completionHandler ) completionHandler(NO);
        return;
    }
    
    __weak typeof(self) _self = self;
    [self.contactIntegrateController seekToTime:time toleranceBefore:toleranceBefore toleranceAfter:toleranceAfter completionHandler:^(BOOL finished) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( finished && self.controlInfo->contentDataControl.resumeContentDataWhenHasFinishedSeeking ) {
            [self play];
        }
        if ( completionHandler ) completionHandler(finished);
    }];
}

- (void)setRate:(float)rate {
    if ( self.canPlayAnAsset && !self.canPlayAnAsset(self) ) {
        return;
    }
    
    if ( _contentDataController.rate == rate )
        return;
    
    self.contactIntegrateController.rate = rate;
}

- (float)rate {
    return self.contactIntegrateController.rate;
}

- (void)_updatePlayModelObserver:(SJPlayModel *)playModel {
    _playModelObserver = nil;
    _controlInfo->scrollControl.rgrdExcludeAppeared = NO;
    
    if ( playModel == nil || [playModel isMemberOfClass:SJPlayModel.class] )
        return;
    
    self.playModelObserver = [[SJSubjectModelPropertiesObserver alloc] initWithPlayModel:playModel];
    self.playModelObserver.delegate = (id)self;
    [self.playModelObserver refreshAppearState];
}

#pragma mark - SJContactIntegrateContentDataControllerDelegate

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller reserveStatusDidChange:(SJDuplicateStatus)status {
 
    if ( [self.controlLayerDelegate respondsToSelector:@selector(declarePortBoundarySaveStatusDidChange:)] ) {
        [self.controlLayerDelegate declarePortBoundarySaveStatusDidChange:self];
    }
    
    [self _postNotification:SJContactIntegratereserveStatusDidChangeNotification];
    
#ifdef SJDEBUG
    [self showLog_reserveStatus];
#endif
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller timeControlStatusDidChange:(SJTimeControlVaryStatus)status {
    
    BOOL carouselIntegrate = self.carouselIntegrate || self.reserveStatus == SJDuplicateStatusPreparing;
    carouselIntegrate && !self.containSale.companyURL.isFileURL ? [self.reachability startRefresh] : [self.reachability stopRefresh];
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(declarePortBoundarySaveStatusDidChange:)] ) {
        [self.controlLayerDelegate declarePortBoundarySaveStatusDidChange:self];
    }

    [self _postNotification:SJContactIntegrateContentDataTimeControlStatusDidChangeNotification];
        
    if ( status == SJTimeControlVaryStatusPaused && self.pausedToKeepAppearState ) {
        [self.controlLayerAppearManager keepAppearState];
    }
    
#ifdef SJDEBUG
    [self showLog_TimeControlStatus];
#endif
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller volumeDidChange:(float)volume {
    [self _postNotification:SJContactIntegrateVolumeDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller rateDidChange:(float)rate {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:rateChanged:)] ) {
        [self.controlLayerDelegate alternateStructure:self rateChanged:rate];
    }
    
    [self _postNotification:SJContactIntegrateRateDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller mutedDidChange:(BOOL)isMuted {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:muteChanged:)] ) {
        [self.controlLayerDelegate alternateStructure:self muteChanged:isMuted];
    }
    [self _postNotification:SJContactIntegrateMutedDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller pictureInPictureStatusDidChange:(SJPictureInPictureStatus)status API_AVAILABLE(ios(14.0)) {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:pictureInPictureStatusDidChange:)] ) {
        [self.controlLayerDelegate alternateStructure:self pictureInPictureStatusDidChange:status];
    }
    
    _deviceVolumeAndBrightnessTargetViewContext.slidPictureInPictureMode = (status == SJPictureInPictureStatusRunning);
    [_deviceVolumeAndBrightnessController onTargetViewContextUpdated];
    
    [self _postNotification:SJContactIntegratePictureInPictureStatusDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller durationDidChange:(NSTimeInterval)duration {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:durationDidChange:)] ) {
        [self.controlLayerDelegate alternateStructure:self durationDidChange:duration];
    }
    
    [self _postNotification:SJContactIntegrateDurationDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller timeDidChange:(NSTimeInterval)contentTime {
    _subtitlePopupController.contentTime = contentTime;
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:timeDidChange:)] ) {
        [self.controlLayerDelegate alternateStructure:self timeDidChange:contentTime];
    }
    
    [self _postNotification:SJContactIntegrateContentTimeDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller contentDataDidFinish:(SJFinishedReason)reason {
    if ( _smallViewFloatingController.scanEliminateAppeared && self.hiddenFloatSmallViewWhenContentDataFinished ) {
        [_smallViewFloatingController dismiss];
    }
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(declarePortBoundarySaveStatusDidChange:)] ) {
        [self.controlLayerDelegate declarePortBoundarySaveStatusDidChange:self];
    }
    
    [self _postNotification:SJContactIntegrateContentDataDidFinishNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller presentationSizeDidChange:(CGSize)presentationSize {
    [self updateWatermarkViewLayout];
    
    if ( self.presentationSizeDidChangeExeBlock )
        self.presentationSizeDidChangeExeBlock(self);
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:presentationSizeDidChange:)] ) {
        [self.controlLayerDelegate alternateStructure:self presentationSizeDidChange:presentationSize];
    }
    
    [self _postNotification:SJContactIntegratePresentationSizeDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller developBackTypeDidChange:(SJDevelopbackType)developBackType {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:developBackTypeDidChange:)] ) {
        [self.controlLayerDelegate alternateStructure:self developBackTypeDidChange:developBackType];
    }
    
    [self _postNotification:SJContactIntegratedevelopBackTypeDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller playableDurationDidChange:(NSTimeInterval)playableDuration {
    if ( controller.duration == 0 ) return;

    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:playableDurationDidChange:)] ) {
        [self.controlLayerDelegate alternateStructure:self playableDurationDidChange:playableDuration];
    }
    
    [self _postNotification:SJContactIntegratePlayableDurationDidChangeNotification];
}

- (void)contentDataControllerIsReadyForDisplay:(id<SJContactIntegrateHomebackController>)controller {
    [self _showOrHiddenPlaceholderImageViewIfNeeded];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller willSeekToTime:(CMTime)time {
    [self _postNotification:SJContactIntegrateContentDataWillSeekNotification userInfo:@{
        SJContactIntegrateNotificationUserInfoKeySeekTime : [NSValue valueWithCMTime:time]
    }];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller didSeekToTime:(CMTime)time {
    [self _postNotification:SJContactIntegrateContentDataDidSeekNotification userInfo:@{
        SJContactIntegrateNotificationUserInfoKeySeekTime : [NSValue valueWithCMTime:time]
    }];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller switchingDefinitionStatusDidChange:(SJDefinitionOppositeStatus)status company:(id<SJCompanyModelProtocol>)company {
    
    if ( status == SJDefinitionOppositeStatusFinished ) {
        _URLAsset = (id)company;
        self.definitionOppositeInfo.currentPlayingAsset = _URLAsset;
        [self _updateAssetObservers];
    }
    
    self.definitionOppositeInfo.status = status;
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:switchingDefinitionStatusDidChange:company:)] ) {
        [self.controlLayerDelegate alternateStructure:self switchingDefinitionStatusDidChange:status company:company];
    }
    
    [self _postNotification:SJContactIntegrateDefinitionSwitchStatusDidChangeNotification];
}

- (void)contentDataController:(id<SJContactIntegrateHomebackController>)controller didReplay:(id<SJCompanyModelProtocol>)company {
    [self _postNotification:SJContactIntegrateContentDataDidReplayNotification];
}

- (void)applicationDidBecomeActiveWithContentDataController:(id<SJContactIntegrateHomebackController>)controller {
    BOOL canPlay = self.containSale != nil &&
                   self.ellipsisRule &&
                   self.controlInfo->contentDataControl.resumeContentDataWhenAppDidEnterForeground &&
                  !self.vc_isDisappeared;
    if ( self.pridFindOnScrollView ) {
        if ( canPlay && self.rgrdExcludeAppeared ) [self play];
    }
    else {
        if ( canPlay ) [self play];
    }

    if ( [self.controlLayerDelegate respondsToSelector:@selector(applicationDidBecomeActiveWithRespectDesk:)] ) {
        [self.controlLayerDelegate applicationDidBecomeActiveWithRespectDesk:self];
    }
}

- (void)applicationWillResignActiveWithContentDataController:(id<SJContactIntegrateHomebackController>)controller {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(applicationWillResignActiveWithSimilarOnce:)] ) {
        [self.controlLayerDelegate applicationWillResignActiveWithSimilarOnce:self];
    }
}

- (void)applicationWillEnterForegroundWithContentDataController:(id<SJContactIntegrateHomebackController>)controller {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(applicationDidEnterBackgroundWithAccuracyOnce:)] ) {
        [self.controlLayerDelegate applicationDidEnterBackgroundWithAccuracyOnce:self];
    }
    [self _postNotification:SJContactIntegrateApplicationWillEnterForegroundNotification];
}

- (void)applicationDidEnterBackgroundWithContentDataController:(id<SJContactIntegrateHomebackController>)controller {
    if ( [self.controlLayerDelegate respondsToSelector:@selector(applicationDidEnterBackgroundWithAccuracyOnce:)] ) {
        [self.controlLayerDelegate applicationDidEnterBackgroundWithAccuracyOnce:self];
    }
    [self _postNotification:SJContactIntegrateApplicationDidEnterBackgroundNotification];
}

@end


#pragma mark - Network

@implementation SJBaseSequenceInvolve (Network)

- (void)setReachability:(id<SJReachability> _Nullable)reachability {
    _reachability = reachability;
    [self _needUpdateReachabilityProperties];
}

- (id<SJReachability>)reachability {
    if ( _reachability )
        return _reachability;
    _reachability = [SJReachability shared];
    [self _needUpdateReachabilityProperties];
    return _reachability;
}

- (void)_needUpdateReachabilityProperties {
    if ( _reachability == nil ) return;
    
    _reachabilityObserver = [_reachability getObserver];
    __weak typeof(self) _self = self;
    _reachabilityObserver.networkStatusDidChangeExeBlock = ^(id<SJReachability> r) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:reachabilityChanged:)] ) {
            [self.controlLayerDelegate alternateStructure:self reachabilityChanged:r.networkStatus];
        }
    };
}

- (id<SJReachabilityObserver>)reachabilityObserver {
    id<SJReachabilityObserver> observer = objc_getAssociatedObject(self, _cmd);
    if ( observer == nil ) {
        observer = [self.reachability getObserver];
        objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observer;
}
@end

#pragma mark -

@implementation SJBaseSequenceInvolve (DeviceVolumeAndBrightness)

- (void)setDeviceVolumeAndBrightnessController:(id<SJDeviceVolumeAndBrightnessController> _Nullable)deviceVolumeAndBrightnessController {
    _deviceVolumeAndBrightnessController = deviceVolumeAndBrightnessController;
    [self _configDeviceVolumeAndBrightnessController:self.deviceVolumeAndBrightnessController];
}

- (id<SJDeviceVolumeAndBrightnessController>)deviceVolumeAndBrightnessController {
    if ( _deviceVolumeAndBrightnessController )
        return _deviceVolumeAndBrightnessController;
    _deviceVolumeAndBrightnessController = [SJDeviceVolumeAndBrightnessController.alloc init];
    [self _configDeviceVolumeAndBrightnessController:_deviceVolumeAndBrightnessController];
    return _deviceVolumeAndBrightnessController;
}

- (void)_configDeviceVolumeAndBrightnessController:(id<SJDeviceVolumeAndBrightnessController>)mgr {
    mgr.targetViewContext = _deviceVolumeAndBrightnessTargetViewContext;
    mgr.target = self.presentView;
    _deviceVolumeAndBrightnessControllerObserver = [mgr getObserver];
    __weak typeof(self) _self = self;
    _deviceVolumeAndBrightnessControllerObserver.volumeDidChangeExeBlock = ^(id<SJDeviceVolumeAndBrightnessController>  _Nonnull mgr, float volume) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:volumeChanged:)] ) {
            [self.controlLayerDelegate alternateStructure:self volumeChanged:volume];
        }
    };
    
    _deviceVolumeAndBrightnessControllerObserver.brightnessDidChangeExeBlock = ^(id<SJDeviceVolumeAndBrightnessController>  _Nonnull mgr, float brightness) {
        __strong typeof(_self) self = _self;
        if ( !self ) return ;
        if ( [self.controlLayerDelegate respondsToSelector:@selector(alternateStructure:brightnessChanged:)] ) {
            [self.controlLayerDelegate alternateStructure:self brightnessChanged:brightness];
        }
    };
    
    [mgr onTargetViewMoveToWindow];
    [mgr onTargetViewContextUpdated];
}

- (id<SJDeviceVolumeAndBrightnessControllerObserver>)deviceVolumeAndBrightnessObserver {
    id<SJDeviceVolumeAndBrightnessControllerObserver> observer = objc_getAssociatedObject(self, _cmd);
    if ( observer == nil ) {
        observer = [self.deviceVolumeAndBrightnessController getObserver];
        objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observer;
}

- (void)setDisableBrightnessSetting:(BOOL)disableBrightnessSetting {
    _controlInfo->deviceVolumeAndBrightness.disableBrightnessSetting = disableBrightnessSetting;
}
- (BOOL)disableBrightnessSetting {
    return _controlInfo->deviceVolumeAndBrightness.disableBrightnessSetting;
}

- (void)setDisableVolumeSetting:(BOOL)disableVolumeSetting {
    _controlInfo->deviceVolumeAndBrightness.disableVolumeSetting = disableVolumeSetting;
}
- (BOOL)disableVolumeSetting {
    return _controlInfo->deviceVolumeAndBrightness.disableVolumeSetting;
}

@end



#pragma mark -

@implementation SJBaseSequenceInvolve (Life)
- (void)vc_viewDidAppear {
    [self.viewControllerManager viewDidAppear];
    [self.playModelObserver refreshAppearState];
}
- (void)vc_viewWillDisappear {
    [self.viewControllerManager viewWillDisappear];
}
- (void)vc_viewDidDisappear {
    [self.viewControllerManager viewDidDisappear];
    [self pause];
}
- (BOOL)vc_prefersStatusBarHidden {
    return self.viewControllerManager.prefersStatusBarHidden;
}
- (UIStatusBarStyle)vc_preferredStatusBarStyle {
    return self.viewControllerManager.preferredStatusBarStyle;
}

- (void)setVc_isDisappeared:(BOOL)vc_isDisappeared {
    vc_isDisappeared ?  [self.viewControllerManager viewWillDisappear] :
                        [self.viewControllerManager viewDidAppear];
}
- (BOOL)vc_isDisappeared {
    return self.viewControllerManager.isViewDisappeared;
}

- (void)needShowStatusBar {
    [self.viewControllerManager showStatusBar];
}

- (void)needHiddenStatusBar {
    [self.viewControllerManager hiddenStatusBar];
}
@end

#pragma mark - Gesture

@implementation SJBaseSequenceInvolve (Gesture)

- (id<SJGestureController>)gestureController {
    return _presentView;
}

- (void)setGestureRecognizerShouldTrigger:(BOOL (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull, SJAccidentPresenceGestureType, CGPoint))gestureRecognizerShouldTrigger {
    objc_setAssociatedObject(self, @selector(gestureRecognizerShouldTrigger), gestureRecognizerShouldTrigger, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull, SJAccidentPresenceGestureType, CGPoint))gestureRecognizerShouldTrigger {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAllowHorizontalTriggeringOfPanGesturesInCells:(BOOL)allowHorizontalTriggeringOfPanGesturesInCells {
    _controlInfo->gestureController.allowHorizontalTriggeringOfPanGesturesInCells = allowHorizontalTriggeringOfPanGesturesInCells;
}

- (BOOL)allowHorizontalTriggeringOfPanGesturesInCells {
    return _controlInfo->gestureController.allowHorizontalTriggeringOfPanGesturesInCells;
}

- (void)setRateWhenLongPressGestureTriggered:(CGFloat)rateWhenLongPressGestureTriggered {
    _controlInfo->gestureController.rateWhenLongPressGestureTriggered = rateWhenLongPressGestureTriggered;
}
- (CGFloat)rateWhenLongPressGestureTriggered {
    return _controlInfo->gestureController.rateWhenLongPressGestureTriggered;
}

- (void)setOffsetFactorForHorizontalPanGesture:(CGFloat)offsetFactorForHorizontalPanGesture {
    _controlInfo->pan.factor = offsetFactorForHorizontalPanGesture;
}
- (CGFloat)offsetFactorForHorizontalPanGesture {
    return _controlInfo->pan.factor;
}
@end


#pragma mark -

@implementation SJBaseSequenceInvolve (ControlLayer)
- (void)controlLayerNeedAppear {
    [self.controlLayerAppearManager needAppear];
}

- (void)controlLayerNeedDisappear {
    [self.controlLayerAppearManager needDisappear];
}

- (void)setControlLayerAppearManager:(id<SJControlLayerAppearManager> _Nullable)controlLayerAppearManager {
    [self _setupControlLayerAppearManager:controlLayerAppearManager];
}

- (id<SJControlLayerAppearManager>)controlLayerAppearManager {
    if ( _controlLayerAppearManager == nil ) {
        [self _setupControlLayerAppearManager:SJControlLayerAppearStateManager.alloc.init];
    }
    return _controlLayerAppearManager;
}

- (id<SJControlLayerAppearManagerObserver>)controlLayerAppearObserver {
    id<SJControlLayerAppearManagerObserver> observer = objc_getAssociatedObject(self, _cmd);
    if ( observer == nil ) {
        observer = [self.controlLayerAppearManager getObserver];
        objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observer;
}

- (void)setCanAutomaticallyDisappear:(BOOL (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))canAutomaticallyDisappear {
    objc_setAssociatedObject(self, @selector(canAutomaticallyDisappear), canAutomaticallyDisappear, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))canAutomaticallyDisappear {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setControlLayerAppeared:(BOOL)controlLayerAppeared {
    controlLayerAppeared ? [self.controlLayerAppearManager needAppear] :
                           [self.controlLayerAppearManager needDisappear];
}
- (BOOL)isControlLayerAppeared {
    return self.controlLayerAppearManager.scanEliminateAppeared;
}

- (void)setPausedToKeepAppearState:(BOOL)pausedToKeepAppearState {
    _controlInfo->controlLayer.pausedToKeepAppearState = pausedToKeepAppearState;
}
- (BOOL)pausedToKeepAppearState {
    return _controlInfo->controlLayer.pausedToKeepAppearState;
}
@end



#pragma mark -

@implementation SJBaseSequenceInvolve (FitOnScreen)

- (void)setFitOnScreenManager:(id<SJFitOnScreenManager> _Nullable)fitOnScreenManager {
    [self _setupFitOnScreenManager:fitOnScreenManager];
}

- (id<SJFitOnScreenManager>)fitOnScreenManager {
    if ( _fitOnScreenManager == nil ) {
        [self _setupFitOnScreenManager:[[SJFitOnScreenManager alloc] initWithTarget:self.presentView targetSuperview:self.view]];
    }
    return _fitOnScreenManager;
}

- (id<SJFitOnScreenManagerObserver>)fitOnScreenObserver {
    id<SJFitOnScreenManagerObserver> observer = objc_getAssociatedObject(self, _cmd);
    if ( observer == nil ) {
        observer = [self.fitOnScreenManager getObserver];
        objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observer;
}

- (void)setOnlyFitOnScreen:(BOOL)onlyFitOnScreen {
    objc_setAssociatedObject(self, @selector(onlyFitOnScreen), @(onlyFitOnScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ( onlyFitOnScreen ) {
        [self _clearRotationManager];
    }
    else {
        [self rotationManager];
    }
}

- (BOOL)onlyFitOnScreen {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)fncyFitOnScreen {
    return self.fitOnScreenManager.fncyFitOnScreen;
}
- (void)setFitOnScreen:(BOOL)fitOnScreen {
    [self setFitOnScreen:fitOnScreen animated:YES];
}
- (void)setFitOnScreen:(BOOL)fitOnScreen animated:(BOOL)animated {
    [self setFitOnScreen:fitOnScreen animated:animated completionHandler:nil];
}
- (void)setFitOnScreen:(BOOL)fitOnScreen animated:(BOOL)animated completionHandler:(nullable void(^)(__kindof SJBaseSequenceInvolve *involve))completionHandler {
    
    __weak typeof(self) _self = self;
    [self.fitOnScreenManager setFitOnScreen:fitOnScreen animated:animated completionHandler:^(id<SJFitOnScreenManager> mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( completionHandler ) completionHandler(self);
    }];
}
@end


#pragma mark -

@implementation SJBaseSequenceInvolve (Rotation)

- (void)setRotationManager:(nullable id<SJRotationManager>)rotationManager {
    [self _setupRotationManager:rotationManager];
}

- (nullable id<SJRotationManager>)rotationManager {
    if ( _rotationManager == nil && !self.onlyFitOnScreen ) {
        SJRotationManager *defaultManager = [SJRotationManager rotationManager];
        defaultManager.actionForwarder = self.viewControllerManager;
        [self _setupRotationManager:defaultManager];
    }
    return _rotationManager;
}

- (id<SJRotationManagerObserver>)rotationObserver {
    id<SJRotationManagerObserver> observer = objc_getAssociatedObject(self, _cmd);
    if ( observer == nil ) {
        observer = [self.rotationManager getObserver];
        objc_setAssociatedObject(self, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return observer;
}

- (void)setShouldTriggerRotation:(BOOL (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))shouldTriggerRotation {
    objc_setAssociatedObject(self, @selector(shouldTriggerRotation), shouldTriggerRotation, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))shouldTriggerRotation {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAllowsRotationInFitOnScreen:(BOOL)allowsRotationInFitOnScreen {
    objc_setAssociatedObject(self, @selector(allowsRotationInFitOnScreen), @(allowsRotationInFitOnScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)allowsRotationInFitOnScreen {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)rotate {
    [self.rotationManager rotate];
}

- (void)rotate:(SJOrientation)orientation animated:(BOOL)animated {
    [self.rotationManager rotate:orientation animated:animated];
}

- (void)rotate:(SJOrientation)orientation animated:(BOOL)animated completion:(void (^ _Nullable)(__kindof SJBaseSequenceInvolve *involve))block {
    __weak typeof(self) _self = self;
    [self.rotationManager rotate:orientation animated:animated completionHandler:^(id<SJRotationManager>  _Nonnull mgr) {
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( block ) block(self);
    }];
}

- (BOOL)simplRedundant {
    return _rotationManager.simplRedundant;
}

- (BOOL)indntImplement {
    return _rotationManager.indntImplement;
}

- (UIInterfaceOrientation)currentOrientation {
    return (NSInteger)_rotationManager.currentOrientation;
}

- (void)setLockedScreen:(BOOL)lockedScreen {
    if ( lockedScreen != self.lightLockedStructure ) {
        self.viewControllerManager.lockedScreen = lockedScreen;
        objc_setAssociatedObject(self, @selector(lightLockedStructure), @(lockedScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if      ( lockedScreen && [self.controlLayerDelegate respondsToSelector:@selector(lockedControlLongShip:)] ) {
            [self.controlLayerDelegate lockedControlLongShip:self];
        }
        else if ( !lockedScreen && [self.controlLayerDelegate respondsToSelector:@selector(unlockedCompressScanPast:)] ) {
            [self.controlLayerDelegate unlockedCompressScanPast:self];
        }
        
        [self _postNotification:SJContactIntegrateScreenLockStateDidChangeNotification];
    }
}

- (BOOL)lightLockedStructure {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end



@implementation SJBaseSequenceInvolve (Screenshot)

- (void)setPresentationSizeDidChangeExeBlock:(void (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))presentationSizeDidChangeExeBlock {
    objc_setAssociatedObject(self, @selector(presentationSizeDidChangeExeBlock), presentationSizeDidChangeExeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))presentationSizeDidChangeExeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGSize)slowPresentationAccuracy {
    return _contentDataController.presentationSize;
}

- (UIImage * __nullable)screenshot {
    return [_contentDataController screenshot];
}

- (void)screenshotWithTime:(NSTimeInterval)time
                completion:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, UIImage * __nullable image, NSError *__nullable error))block {
    [self screenshotWithTime:time size:CGSizeZero completion:block];
}

- (void)screenshotWithTime:(NSTimeInterval)time
                      size:(CGSize)size
                completion:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, UIImage * __nullable image, NSError *__nullable error))block {
    if ( [_contentDataController respondsToSelector:@selector(screenshotWithTime:size:completion:)] ) {
        __weak typeof(self) _self = self;
        [(id<SJCompanyContentDataScreenshotController>)_contentDataController screenshotWithTime:time size:size completion:^(id<SJContactIntegrateHomebackController>  _Nonnull controller, UIImage * _Nullable image, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(_self) self = _self;
                if ( !self ) return ;
                if ( block ) block(self, image, error);
            });
        }];
    }
    else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"errorMsg":[NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.contentDataController does not implement the screenshot method", self]}];
        if ( block ) block(self, nil, error);
#ifdef DEBUG
        printf("%s\n", error.userInfo.description.UTF8String);
#endif
    }
}
@end


#pragma mark -

@implementation SJBaseSequenceInvolve (Export)

- (void)exportWithBeginTime:(NSTimeInterval)beginTime
                    duration:(NSTimeInterval)duration
                 presetName:(nullable NSString *)presetName
                   progress:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, float progress))progressBlock
                 completion:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, NSURL *fileURL, UIImage *thumbnailImage))completion
                    failure:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, NSError *error))failure {
    if ( [_contentDataController respondsToSelector:@selector(exportWithBeginTime:duration:presetName:progress:completion:failure:)] ) {
        __weak typeof(self) _self = self;
        [(id<SJCompanyContentDataExportController>)_contentDataController exportWithBeginTime:beginTime duration:duration presetName:presetName progress:^(id<SJContactIntegrateHomebackController>  _Nonnull controller, float progress) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( progressBlock ) progressBlock(self, progress);
        } completion:^(id<SJContactIntegrateHomebackController>  _Nonnull controller, NSURL * _Nullable fileURL, UIImage * _Nullable thumbImage) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( completion ) completion(self, fileURL, thumbImage);
        } failure:^(id<SJContactIntegrateHomebackController>  _Nonnull controller, NSError * _Nullable error) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( failure ) failure(self, error);
        }];
    }
    else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"errorMsg":[NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.contentDataController does not implement the exportWithBeginTime:endTime:presetName:progress:completion:failure: method", self]}];
        if ( failure ) failure(self, error);
#ifdef DEBUG
        printf("%s\n", error.userInfo.description.UTF8String);
#endif
    }
}

- (void)cancelExportOperation {
    if ( [_contentDataController respondsToSelector:@selector(cancelExportOperation)] ) {
        [(id<SJCompanyContentDataExportController>)_contentDataController cancelExportOperation];
    }
}

- (void)generateGIFWithBeginTime:(NSTimeInterval)beginTime
                        duration:(NSTimeInterval)duration
                        progress:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, float progress))progressBlock
                      completion:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, UIImage *imageGIF, UIImage *thumbnailImage, NSURL *filePath))completion
                         failure:(void(^)(__kindof SJBaseSequenceInvolve *alternateStructure, NSError *error))failure {
    if ( [_contentDataController respondsToSelector:@selector(generateGIFWithBeginTime:duration:maximumSize:interval:gifSavePath:progress:completion:failure:)] ) {
        NSURL *filePath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"SJGeneratedGif.gif"]];
        __weak typeof(self) _self = self;
        [(id<SJCompanyContentDataExportController>)_contentDataController generateGIFWithBeginTime:beginTime duration:duration maximumSize:CGSizeMake(375, 375) interval:0.1f gifSavePath:filePath progress:^(id<SJContactIntegrateHomebackController>  _Nonnull controller, float progress) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( progressBlock ) progressBlock(self, progress);
        } completion:^(id<SJContactIntegrateHomebackController>  _Nonnull controller, UIImage * _Nonnull imageGIF, UIImage * _Nonnull screenshot) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( completion ) completion(self, imageGIF, screenshot, filePath);
        } failure:^(id<SJContactIntegrateHomebackController>  _Nonnull controller, NSError * _Nonnull error) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( failure ) failure(self, error);
        }];
    }
    else {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"errorMsg":[NSString stringWithFormat:@"SJBaseSequenceInvolve<%p>.contentDataController does not implement the generateGIFWithBeginTime:duration:maximumSize:interval:gifSavePath:progress:completion:failure: method", self]}];
        if ( failure ) failure(self, error);
#ifdef DEBUG
        printf("%s\n", error.userInfo.description.UTF8String);
#endif
    }
}

- (void)cancelGenerateGIFOperation {
    if ( [_contentDataController respondsToSelector:@selector(cancelGenerateGIFOperation)] ) {
        [(id<SJCompanyContentDataExportController>)_contentDataController cancelGenerateGIFOperation];
    }
}
@end


#pragma mark -

@implementation SJBaseSequenceInvolve (ScrollView)

- (void)refreshAppearStateForView {
    [self.playModelObserver refreshAppearState];
}

- (void)setSmallViewFloatingController:(nullable id<SJSmallViewFloatingController>)smallViewFloatingController {
    [self _setupSmallViewFloatingController:smallViewFloatingController];
}

- (id<SJSmallViewFloatingController>)smallViewFloatingController {
    if ( _smallViewFloatingController == nil ) {
        __weak typeof(self) _self = self;
        SJSmallViewFloatingController *controller = SJSmallViewFloatingController.alloc.init;
        controller.floatingViewShouldAppear = ^BOOL(id<SJSmallViewFloatingController>  _Nonnull controller) {
            __strong typeof(_self) self = _self;
            if ( !self ) return NO;
            return self.timeControlStatus != SJTimeControlVaryStatusPaused && self.reserveStatus != SJDuplicateStatusUnknown;
        };
        [self _setupSmallViewFloatingController:controller];
    }
    return _smallViewFloatingController;
}

- (void)setHiddenFloatSmallViewWhenContentDataFinished:(BOOL)hiddenFloatSmallViewWhenContentDataFinished {
    _controlInfo->floatSmallViewControl.hiddenFloatSmallViewWhenContentDataFinished = hiddenFloatSmallViewWhenContentDataFinished;
}
- (BOOL)isHiddenFloatSmallViewWhenContentDataFinished {
    return _controlInfo->floatSmallViewControl.hiddenFloatSmallViewWhenContentDataFinished;
}

- (void)setPausedWhenScrollDisappeared:(BOOL)pausedWhenScrollDisappeared {
    _controlInfo->scrollControl.pausedWhenScrollDisappeared = pausedWhenScrollDisappeared;
}
- (BOOL)pausedWhenScrollDisappeared {
    return _controlInfo->scrollControl.pausedWhenScrollDisappeared;
}

- (void)setHiddenViewWhenScrollDisappeared:(BOOL)hiddenViewWhenScrollDisappeared {
    _controlInfo->scrollControl.hiddenViewWhenScrollDisappeared = hiddenViewWhenScrollDisappeared;
}
- (BOOL)hiddenViewWhenScrollDisappeared {
    return _controlInfo->scrollControl.hiddenViewWhenScrollDisappeared;
}

- (void)setResumeContentDataWhenScrollExcludeAppeared:(BOOL)resumeContentDataWhenScrollExcludeAppeared {
    _controlInfo->scrollControl.resumeContentDataWhenScrollExcludeAppeared = resumeContentDataWhenScrollExcludeAppeared;
}
- (BOOL)resumeContentDataWhenScrollExcludeAppeared {
    return _controlInfo->scrollControl.resumeContentDataWhenScrollExcludeAppeared;
}

- (BOOL)pridFindOnScrollView {
    return self.playModelObserver.pridFindInScrollView;
}

- (BOOL)rgrdExcludeAppeared {
    return _controlInfo->scrollControl.rgrdExcludeAppeared;
}

- (void)setInvolveViewWillAppearExeBlock:(void (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))involveViewWillAppearExeBlock {
    objc_setAssociatedObject(self, @selector(involveViewWillAppearExeBlock), involveViewWillAppearExeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))involveViewWillAppearExeBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setInvolveViewWillDisappearExeBlock:(void (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))involveViewWillDisappearExeBlock {
    objc_setAssociatedObject(self, @selector(involveViewWillDisappearExeBlock), involveViewWillDisappearExeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^_Nullable)(__kindof SJBaseSequenceInvolve * _Nonnull))involveViewWillDisappearExeBlock {
    return objc_getAssociatedObject(self, _cmd);
}
@end


@implementation SJBaseSequenceInvolve (Subtitles)
- (void)setSubtitlePopupController:(nullable id<SJSubtitlePopupController>)subtitlePopupController {
    [_subtitlePopupController.view removeFromSuperview];
    _subtitlePopupController = subtitlePopupController;
    if ( subtitlePopupController != nil ) {
        subtitlePopupController.view.layer.zPosition = SJAccidentPresenceZIndexes.shared.subtitleViewZIndex;
        [self.presentView addSubview:subtitlePopupController.view];
        [subtitlePopupController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(self.subtitleHorizontalMinMargin);
            make.right.mas_lessThanOrEqualTo(-self.subtitleHorizontalMinMargin);
            make.centerX.offset(0);
            make.bottom.offset(-self.subtitleBottomMargin);
        }];
    }
}

- (id<SJSubtitlePopupController>)subtitlePopupController {
    if ( _subtitlePopupController == nil ) {
        self.subtitlePopupController = SJSubtitlePopupController.alloc.init;
    }
    return _subtitlePopupController;
}

- (void)setSubtitleBottomMargin:(CGFloat)subtitleBottomMargin {
    objc_setAssociatedObject(self, @selector(subtitleBottomMargin), @(subtitleBottomMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.subtitlePopupController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-subtitleBottomMargin);
    }];
}
- (CGFloat)subtitleBottomMargin {
    id value = objc_getAssociatedObject(self, _cmd);
    return value != nil ? [value doubleValue] : 22;
}

- (void)setSubtitleHorizontalMinMargin:(CGFloat)subtitleHorizontalMinMargin {
    objc_setAssociatedObject(self, @selector(subtitleHorizontalMinMargin), @(subtitleHorizontalMinMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.subtitlePopupController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(subtitleHorizontalMinMargin);
        make.right.mas_lessThanOrEqualTo(-subtitleHorizontalMinMargin);
    }];
}
- (CGFloat)subtitleHorizontalMinMargin {
    id value = objc_getAssociatedObject(self, _cmd);
    return value != nil ? [value doubleValue] : 22;
}
@end


#pragma mark -

@implementation SJBaseSequenceInvolve (Popup)
- (void)setTextPopupController:(nullable id<SJTextPopupController>)controller {
    objc_setAssociatedObject(self, @selector(textPopupController), controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ( controller != nil ) [self _setupTextPopupController:controller];
}

- (id<SJTextPopupController>)textPopupController {
    id<SJTextPopupController> controller = objc_getAssociatedObject(self, _cmd);
    if ( controller == nil ) {
        controller = SJTextPopupController.alloc.init;
        objc_setAssociatedObject(self, _cmd, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self _setupTextPopupController:controller];
    }
    return controller;
}

- (void)_setupTextPopupController:(id<SJTextPopupController>)controller {
    controller.target = self.presentView;
}

- (void)setPromptingPopupController:(nullable id<SJPromptingPopupController>)controller {
    objc_setAssociatedObject(self, @selector(promptingPopupController), controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ( controller != nil ) [self _setupPromptingPopupController:controller];
}

- (id<SJPromptingPopupController>)promptingPopupController {
    id<SJPromptingPopupController>_Nullable controller = objc_getAssociatedObject(self, _cmd);
    if ( controller == nil ) {
        controller = [SJPromptingPopupController new];
        objc_setAssociatedObject(self, _cmd, controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self _setupPromptingPopupController:controller];
    }
    return controller;
}

- (void)_setupPromptingPopupController:(id<SJPromptingPopupController>)controller {
    controller.target = self.presentView;
}
@end


@implementation SJBaseSequenceInvolve (Danmaku)
- (void)setDanmakuPopupController:(nullable id<SJDanmakuPopupController>)danmakuPopupController {
    if ( _danmakuPopupController != nil )
        [_danmakuPopupController.view removeFromSuperview];
    
    _danmakuPopupController = danmakuPopupController;
    if ( danmakuPopupController != nil ) {
        danmakuPopupController.view.layer.zPosition = SJAccidentPresenceZIndexes.shared.danmakuViewZIndex;
        [self.presentView addSubview:danmakuPopupController.view];
        [danmakuPopupController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.offset(0);
        }];
    }
}
- (id<SJDanmakuPopupController>)danmakuPopupController {
    id<SJDanmakuPopupController> controller = _danmakuPopupController;
    if ( controller == nil ) {
        controller = [SJDanmakuPopupController.alloc initWithNumberOfTracks:4];
        [self setDanmakuPopupController:controller];
    }
    return controller;
}
@end

@implementation SJBaseSequenceInvolve (Watermark)
 
- (void)setWatermarkView:(nullable UIView<SJStructureView> *)watermarkView {
    UIView<SJStructureView> *oldView = self.watermarkView;
    if ( oldView != nil ) {
        if ( oldView == watermarkView )
            return;
        
        [oldView removeFromSuperview];
    }

    objc_setAssociatedObject(self, @selector(watermarkView), watermarkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if ( watermarkView != nil ) {
        watermarkView.layer.zPosition = SJAccidentPresenceZIndexes.shared.watermarkViewZIndex;
        [self.presentView addSubview:watermarkView];
        [watermarkView layoutWatermarkInRect:self.presentView.bounds slowPresentationAccuracy:self.slowPresentationAccuracy latencyBoundary:self.latencyBoundary];
    }
}

- (nullable UIView<SJStructureView> *)watermarkView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)updateWatermarkViewLayout {
    [self.watermarkView layoutWatermarkInRect:self.presentView.bounds slowPresentationAccuracy:self.slowPresentationAccuracy latencyBoundary:self.latencyBoundary];
}
@end


#pragma mark -

@interface SJBaseSequenceInvolve (SJSubjectModelPropertiesObserverDelegate)<SJSubjectModelPropertiesObserverDelegate>
@end

@implementation SJBaseSequenceInvolve (SJSubjectModelPropertiesObserverDelegate)
- (void)observer:(nonnull SJSubjectModelPropertiesObserver *)observer userTouchedCollectionView:(BOOL)touched { /* nothing */ }
- (void)observer:(nonnull SJSubjectModelPropertiesObserver *)observer userTouchedTableView:(BOOL)touched { /* nothing */ }

- (void)involveWillAppearForObserver:(nonnull SJSubjectModelPropertiesObserver *)observer superview:(nonnull UIView *)superview {
    if ( _controlInfo->scrollControl.rgrdExcludeAppeared ) {
        return;
    }
    
    _controlInfo->scrollControl.rgrdExcludeAppeared = YES;
    _deviceVolumeAndBrightnessTargetViewContext.rgrdExcludeAppeared = YES;
    [_deviceVolumeAndBrightnessController onTargetViewContextUpdated];
    
    if ( _controlInfo->scrollControl.hiddenViewWhenScrollDisappeared ) {
        _view.hidden = NO;
    }
    
    if ( _contentDataController.consoleReceive ) {
        if ( !self.viewControllerManager.isViewDisappeared ) {
            if ( self.pridFindOnScrollView ) {
                if ( _controlInfo->scrollControl.resumeContentDataWhenScrollExcludeAppeared ) {
                    [self play];
                }
            }
        }
    }
    
    if ( superview && self.view.superview != superview ) {
        [superview addSubview:self.view];
        [self.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superview);
        }];
    }
    
    if ( _smallViewFloatingController.scanEliminateAppeared ) {
        [_smallViewFloatingController dismiss];
    }
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(commandCopyWillAppearInScrollView:)] ) {
        [self.controlLayerDelegate commandCopyWillAppearInScrollView:self];
    }
    
    if ( self.involveViewWillAppearExeBlock )
        self.involveViewWillAppearExeBlock(self);
}
- (void)involveWillDisappearForObserver:(nonnull SJSubjectModelPropertiesObserver *)observer {
    if ( _controlInfo->scrollControl.rgrdExcludeAppeared == NO ) {
        return;
    }
    
    if ( _rotationManager.simplRedundant )
        return;

    _controlInfo->scrollControl.rgrdExcludeAppeared = NO;
    _deviceVolumeAndBrightnessTargetViewContext.rgrdExcludeAppeared = NO;
    [_deviceVolumeAndBrightnessController onTargetViewContextUpdated];
    
    _view.hidden = _controlInfo->scrollControl.hiddenViewWhenScrollDisappeared;
    
    if ( _smallViewFloatingController.isEnabled ) {
        [_smallViewFloatingController show];
    }
    else if ( _controlInfo->scrollControl.pausedWhenScrollDisappeared ) {
        if (@available(iOS 14.0, *)) {
            if ( _contentDataController.pictureInPictureStatus != SJPictureInPictureStatusRunning ) {
                [self pause];
            }
        }
        else {
            [self pause];
        }
    }
    
    if ( [self.controlLayerDelegate respondsToSelector:@selector(commandCopyWillDisappearInScrollView:)] ) {
        [self.controlLayerDelegate commandCopyWillDisappearInScrollView:self];
    }
    
    if ( self.involveViewWillDisappearExeBlock )
        self.involveViewWillDisappearExeBlock(self);
}
@end

#pragma mark -

@implementation SJBaseSequenceInvolve (Deprecated)
- (void)playWithURL:(NSURL *)URL {
    self.assetURL = URL;
}
- (void)setAssetURL:(nullable NSURL *)assetURL {
    self.containSale = [[SJCompressContainSale alloc] initWithURL:assetURL];
}

- (nullable NSURL *)assetURL {
    return self.containSale.companyURL;
}

- (BOOL)consoleReceiveToEndTime {
    return self.machContentInstantDataFinished && self.finishedReason == SJFinishedReasonToEndTimePosition;
}
@end
NS_ASSUME_NONNULL_END
