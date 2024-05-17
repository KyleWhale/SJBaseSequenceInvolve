//
//  SJAccidentPresenceAutoCaptureConfig.h
//  Masonry
//
//  Created by 畅三江 on 2018/7/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJAccidentPresenceAutoCaptureDelegate;

@interface SJAccidentPresenceAutoCaptureConfig : NSObject
+ (instancetype)configWithPlayerSuperviewSelector:(nullable SEL)captureSuperviewSelector autoplayDelegate:(id<SJAccidentPresenceAutoCaptureDelegate>)delegate;

@property (nonatomic, nullable) SEL captureSuperviewSelector;

@property (nonatomic, weak, nullable, readonly) id<SJAccidentPresenceAutoCaptureDelegate> autoCaptureDelegate;

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic) UIEdgeInsets playableAreaInsets;
@end

@protocol SJAccidentPresenceAutoCaptureDelegate <NSObject>
- (void)involveNeedNewReflectAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SJAccidentPresenceAutoCaptureConfig (SJDeprecated)
+ (instancetype)configWithAutoplayDelegate:(id<SJAccidentPresenceAutoCaptureDelegate>)autoCaptureDelegate  __deprecated_msg("use `configWithPlayerSuperviewSelector:autoplayDelegate:`;");
+ (instancetype)configWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
                            autoplayDelegate:(id<SJAccidentPresenceAutoCaptureDelegate>)autoCaptureDelegate __deprecated_msg("use `configWithPlayerSuperviewSelector:autoplayDelegate:`;");
@property (nonatomic, readonly) NSInteger selectorSuperviewTag __deprecated_msg("use `config.scrollViewSelector`");
@end
NS_ASSUME_NONNULL_END
