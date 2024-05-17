//
//  SJEditPictureInPictureController.m
//  SJBaseSequenceInvolve
//
//  Created by BlueDancer on 2020/9/26.
//

#import "SJEditPictureInPictureController.h"
#import <AVKit/AVPictureInPictureController.h>

@interface SJEditPictureInPictureController ()<AVPictureInPictureControllerDelegate>
@property (nonatomic, strong) AVPictureInPictureController *pictureInPictureController;
@property (nonatomic) SJPictureInPictureStatus status;
@end

@implementation SJEditPictureInPictureController
@synthesize delegate = _delegate;
static NSString *kPictureInPicturePossible = @"pictureInPicturePossible";

- (nullable instancetype)initWithLayer:(AVPlayerLayer *)layer delegate:(id<SJPictureInPictureControllerDelegate>)delegate {
    if ( !SJEditPictureInPictureController.isPictureInPictureSupported ) return nil;
    self = [super init];
    if ( self ) {
        _delegate = delegate;
        _pictureInPictureController = [AVPictureInPictureController.alloc initWithPlayerLayer:layer];
        _pictureInPictureController.delegate = self;
        [_pictureInPictureController addObserver:self forKeyPath:kPictureInPicturePossible options:NSKeyValueObservingOptionNew context:&kPictureInPicturePossible];
    }
    return self;
}

- (void)dealloc {
    
    [_pictureInPictureController removeObserver:self forKeyPath:kPictureInPicturePossible context:&kPictureInPicturePossible];
    if ( _status != SJPictureInPictureStatusStopping ||
         _status != SJPictureInPictureStatusStopped ) {
        [self _stopPictureInPicture];
    }
}

- (void)setRequiresLinearContentData:(BOOL)requiresLinearContentData {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
    _pictureInPictureController.requiresLinearPlayback = requiresLinearContentData;
#endif
}

- (BOOL)requiresLinearContentData {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000
    return _pictureInPictureController.requiresLinearPlayback;
#else
    return NO;
#endif
}

- (void)setCanStartPictureInPictureAutomaticallyFromInline:(BOOL)canStartPictureInPictureAutomaticallyFromInline API_AVAILABLE(ios(14.2)) {
    _pictureInPictureController.canStartPictureInPictureAutomaticallyFromInline = canStartPictureInPictureAutomaticallyFromInline;
}

- (BOOL)canStartPictureInPictureAutomaticallyFromInline API_AVAILABLE(ios(14.2)) {
    return _pictureInPictureController.canStartPictureInPictureAutomaticallyFromInline;
}

- (BOOL)isAvailable {
    return _status != SJPictureInPictureStatusStopping && _status != SJPictureInPictureStatusStopped;
}

- (BOOL)isEnabled {
    return _status == SJPictureInPictureStatusStarting || _status == SJPictureInPictureStatusRunning;
}

+ (BOOL)isPictureInPictureSupported {
    return AVPictureInPictureController.isPictureInPictureSupported;
}

- (void)startPictureInPicture {

    _wantsPictureInPictureStart = YES;

    switch ( self.status ) {
        case SJPictureInPictureStatusStarting:
        case SJPictureInPictureStatusRunning:
            /* return */
            return;
        case SJPictureInPictureStatusUnknown:
        case SJPictureInPictureStatusStopping:
        case SJPictureInPictureStatusStopped: {
            self.status = SJPictureInPictureStatusStarting;
            [self _startPictureInPictureIfReady];
        }
            break;
    }
}

- (void)stopPictureInPicture {

    _wantsPictureInPictureStart = NO;
    
    switch ( self.status ) {
        case SJPictureInPictureStatusStopping:
        case SJPictureInPictureStatusStopped:
            /* return */
            return;
        case SJPictureInPictureStatusUnknown:
        case SJPictureInPictureStatusStarting:
        case SJPictureInPictureStatusRunning: {
            self.status = SJPictureInPictureStatusStopping;
            [self _stopPictureInPicture];
        }
            break;
    }
}

#pragma mark -

- (void)_startPictureInPictureIfReady {
    BOOL ready = (_status == SJPictureInPictureStatusStarting) && _pictureInPictureController.isPictureInPicturePossible;
    
    if ( ready ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_pictureInPictureController startPictureInPicture];
        });
    }
}

- (void)_stopPictureInPicture {
    [self->_pictureInPictureController stopPictureInPicture];
}

- (void)setStatus:(SJPictureInPictureStatus)status {
    _status = status;
    if ( [self.delegate respondsToSelector:@selector(pictureInPictureController:statusDidChange:)] ) {
        [self.delegate pictureInPictureController:self statusDidChange:status];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( context == &kPictureInPicturePossible ) {
            [self _startPictureInPictureIfReady];
        }
    });
}

- (void)pictureInPictureControllerDidStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    self.status = SJPictureInPictureStatusRunning;
}

- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController failedToStartPictureInPictureWithError:(NSError *)error {
    [self _stopPictureInPicture];
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    self.status = SJPictureInPictureStatusStopped;
}
 
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler {
    if ( self.delegate != nil ) {
        [self.delegate pictureInPictureController:self restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:completionHandler];
    }
    else { 
        completionHandler(NO);
    }
}
@end
