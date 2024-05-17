//
//  SJPictureInPictureControllerDefines.h
//  Pods
//
//  Created by BlueDancer on 2020/9/26.
//

#ifndef SJPictureInPictureControllerDefines_h
#define SJPictureInPictureControllerDefines_h
@protocol SJPictureInPictureControllerDelegate;

typedef NS_ENUM(NSUInteger, SJPictureInPictureStatus) {
    SJPictureInPictureStatusUnknown,
    SJPictureInPictureStatusStarting,
    SJPictureInPictureStatusRunning,
    SJPictureInPictureStatusStopping,
    SJPictureInPictureStatusStopped,
} API_AVAILABLE(ios(14.0));

NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(ios(14.0)) @protocol SJPictureInPictureController <NSObject>
+ (BOOL)isPictureInPictureSupported;

@property (nonatomic) BOOL requiresLinearContentData;
@property (nonatomic) BOOL canStartPictureInPictureAutomaticallyFromInline API_AVAILABLE(ios(14.2));
@property (nonatomic, weak, nullable) id<SJPictureInPictureControllerDelegate> delegate;
@property (nonatomic, readonly) SJPictureInPictureStatus status;
- (void)startPictureInPicture;
- (void)stopPictureInPicture;
@end

API_AVAILABLE(ios(14.0)) @protocol SJPictureInPictureControllerDelegate <NSObject>
- (void)pictureInPictureController:(id<SJPictureInPictureController>)controller statusDidChange:(SJPictureInPictureStatus)status;

- (void)pictureInPictureController:(id<SJPictureInPictureController>)controller restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL restored))completionHandler;
@end
NS_ASSUME_NONNULL_END

#endif /* SJPictureInPictureControllerDefines_h */
