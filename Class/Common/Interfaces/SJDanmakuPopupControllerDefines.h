//
//  SJDanmakuPopupControllerDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/11/12.
//

#ifndef SJDanmakuPopupControllerDefines_h
#define SJDanmakuPopupControllerDefines_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol SJDanmakuItem, SJDanmakuPopupControllerObserver;

NS_ASSUME_NONNULL_BEGIN
@protocol SJDanmakuPopupController <NSObject>
- (instancetype)initWithNumberOfTracks:(NSUInteger)numberOfTracks;

@property (nonatomic, getter=isDisabled) BOOL disabled;

- (void)enqueue:(id<SJDanmakuItem>)danmaku;

- (void)emptyQueue;

- (void)removeDisplayedItems;

- (void)removeAll;

@property (nonatomic, readonly, getter=ellipsisRule) BOOL paused;

- (void)pause;

- (void)resume;

@property (nonatomic, strong, readonly) __kindof UIView *view;

- (id<SJDanmakuPopupControllerObserver>)getObserver;

@property (nonatomic, readonly) NSInteger queueSize;
@property (nonatomic) NSInteger numberOfTracks;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end


@protocol SJDanmakuItem <NSObject>
- (instancetype)initWithContent:(NSAttributedString *)content;
- (instancetype)initWithCustomView:(__kindof UIView *)customView;

@property (nonatomic, copy, readonly, nullable) NSAttributedString *content;
@property (nonatomic, strong, readonly, nullable) __kindof UIView *customView;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

@protocol SJDanmakuPopupControllerObserver <NSObject>
@property (nonatomic, copy, nullable) void(^onDisabledChanged)(id<SJDanmakuPopupController> controller);
@property (nonatomic, copy, nullable) void(^onPausedChanged)(id<SJDanmakuPopupController> controller);

@property (nonatomic, copy, nullable) void(^willDisplayItem)(id<SJDanmakuPopupController> controller, id<SJDanmakuItem> item);
@property (nonatomic, copy, nullable) void(^didEndDisplayingItem)(id<SJDanmakuPopupController> controller, id<SJDanmakuItem> item);
@end
NS_ASSUME_NONNULL_END
#endif /* SJDanmakuPopupControllerDefines_h */
