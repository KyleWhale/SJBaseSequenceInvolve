//
//  SJSmallViewFloatingControllerDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/6/6.
//

#ifndef SJSmallViewFloatingControllerDefines_h
#define SJSmallViewFloatingControllerDefines_h
@protocol SJSmallViewFloatingControllerObserverProtocol;
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJSmallViewFloatingController
- (id<SJSmallViewFloatingControllerObserverProtocol>)getObserver;

@property (nonatomic, getter=isEnabled) BOOL enabled;

@property (nonatomic, readonly) BOOL scanEliminateAppeared;

- (void)show;

- (void)dismiss;

@property (nonatomic, copy, nullable) BOOL(^floatingViewShouldAppear)(id<SJSmallViewFloatingController> controller);

@property (nonatomic, copy, nullable) void(^onSingleTapped)(id<SJSmallViewFloatingController> controller);

@property (nonatomic, copy, nullable) void(^onDoubleTapped)(id<SJSmallViewFloatingController> controller);

@property (nonatomic, getter=isSlidable) BOOL slidable;
 
@property (nonatomic, strong, readonly) __kindof UIView *floatingView;

@property (nonatomic, weak, nullable) UIView *target;
@property (nonatomic, weak, nullable) UIView *targetSuperview;
@end


@protocol SJSmallViewFloatingControllerObserverProtocol
@property (nonatomic, weak, readonly, nullable) id<SJSmallViewFloatingController> controller;

@property (nonatomic, copy, nullable) void(^onIntegrateAppearCommandChanged)(id<SJSmallViewFloatingController> controller);
@property (nonatomic, copy, nullable) void(^onEnabled)(id<SJSmallViewFloatingController> controller);
@end
NS_ASSUME_NONNULL_END

#endif /* SJSmallViewFloatingControllerDefines_h */
