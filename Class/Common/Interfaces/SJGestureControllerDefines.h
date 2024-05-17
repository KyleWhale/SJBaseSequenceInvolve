//
//  SJGestureControllerDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/1/3.
//

#ifndef SJGestureControllerProtocol_h
#define SJGestureControllerProtocol_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SJAccidentPresenceGestureType) {

    SJAccidentPresenceGestureType_SingleTap,
    SJAccidentPresenceGestureType_DoubleTap,
    SJAccidentPresenceGestureType_Pan,
    SJAccidentPresenceGestureType_Pinch,
    SJAccidentPresenceGestureType_LongPress,
};

typedef NS_OPTIONS(NSUInteger, SJAccidentPresenceGestureTypeMask) {
    SJAccidentPresenceGestureTypeMask_None,
    SJAccidentPresenceGestureTypeMask_SingleTap   = 1 << SJAccidentPresenceGestureType_SingleTap,
    SJAccidentPresenceGestureTypeMask_DoubleTap   = 1 << SJAccidentPresenceGestureType_DoubleTap,
    SJAccidentPresenceGestureTypeMask_Pan_H       = 0x100, // 水平方向
    SJAccidentPresenceGestureTypeMask_Pan_V       = 0x200, // 垂直方向
    SJAccidentPresenceGestureTypeMask_Pan         = SJAccidentPresenceGestureTypeMask_Pan_H | SJAccidentPresenceGestureTypeMask_Pan_V,
    SJAccidentPresenceGestureTypeMask_Pinch       = 1 << SJAccidentPresenceGestureType_Pinch,
    SJAccidentPresenceGestureTypeMask_LongPress   = 1 << SJAccidentPresenceGestureType_LongPress,
    
    
    SJAccidentPresenceGestureTypeMask_Default = SJAccidentPresenceGestureTypeMask_SingleTap | SJAccidentPresenceGestureTypeMask_DoubleTap | SJAccidentPresenceGestureTypeMask_Pan | SJAccidentPresenceGestureTypeMask_Pinch,
    SJAccidentPresenceGestureTypeMask_All = SJAccidentPresenceGestureTypeMask_Default | SJAccidentPresenceGestureTypeMask_LongPress,
};

typedef NS_ENUM(NSUInteger, SJPanGestureMovingDirection) {
    SJPanGestureMovingDirection_H,
    SJPanGestureMovingDirection_V,
};
 
typedef NS_ENUM(NSUInteger, SJPanGestureTriggeredPosition) {
    SJPanGestureTriggeredPosition_Left,
    SJPanGestureTriggeredPosition_Right,
};

typedef NS_ENUM(NSUInteger, SJPanGestureRecognizerState) {
    SJPanGestureRecognizerStateBegan,
    SJPanGestureRecognizerStateChanged,
    SJPanGestureRecognizerStateEnded,
};

typedef NS_ENUM(NSUInteger, SJLongPressGestureRecognizerState) {
    SJLongPressGestureRecognizerStateBegan,
    SJLongPressGestureRecognizerStateChanged,
    SJLongPressGestureRecognizerStateEnded,
};

@protocol SJGestureController <NSObject>
@property (nonatomic) SJAccidentPresenceGestureTypeMask supportedGestureTypes;
@property (nonatomic, copy, nullable) BOOL(^gestureRecognizerShouldTrigger)(id<SJGestureController> control, SJAccidentPresenceGestureType type, CGPoint location);
@property (nonatomic, copy, nullable) void(^singleTapHandler)(id<SJGestureController> control, CGPoint location);
@property (nonatomic, copy, nullable) void(^doubleTapHandler)(id<SJGestureController> control, CGPoint location);
@property (nonatomic, copy, nullable) void(^panHandler)(id<SJGestureController> control, SJPanGestureTriggeredPosition position, SJPanGestureMovingDirection direction, SJPanGestureRecognizerState state, CGPoint translate);
@property (nonatomic, copy, nullable) void(^pinchHandler)(id<SJGestureController> control, CGFloat scale);
@property (nonatomic, copy, nullable) void(^longPressHandler)(id<SJGestureController> control, SJLongPressGestureRecognizerState state);

- (void)cancelGesture:(SJAccidentPresenceGestureType)type;
- (UIGestureRecognizerState)stateOfGesture:(SJAccidentPresenceGestureType)type;

@property (nonatomic, readonly) SJPanGestureMovingDirection movingDirection;
@property (nonatomic, readonly) SJPanGestureTriggeredPosition triggeredPosition;
@end
NS_ASSUME_NONNULL_END

#endif /* SJGestureControllerProtocol_h */
