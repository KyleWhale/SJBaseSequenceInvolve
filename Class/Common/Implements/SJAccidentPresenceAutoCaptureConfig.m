//
//  SJAccidentPresenceAutoCaptureConfig.m
//  Masonry
//
//  Created by 畅三江 on 2018/7/10.
//

#import "SJAccidentPresenceAutoCaptureConfig.h"

@interface SJAccidentPresenceAutoCaptureConfig ()
@property (nonatomic) NSInteger selectorSuperviewTag __deprecated;
@end

@implementation SJAccidentPresenceAutoCaptureConfig
+ (instancetype)configWithPlayerSuperviewSelector:(nullable SEL)playerSuperviewSelector autoplayDelegate:(id<SJAccidentPresenceAutoCaptureDelegate>)delegate {
    NSParameterAssert(delegate != nil);
    
    SJAccidentPresenceAutoCaptureConfig *config = [[self alloc] init];
    config->_autoCaptureDelegate = delegate;
    config->_captureSuperviewSelector = playerSuperviewSelector;
    return config;
}
@end


@implementation SJAccidentPresenceAutoCaptureConfig (SJDeprecated)
+ (instancetype)configWithAutoplayDelegate:(id<SJAccidentPresenceAutoCaptureDelegate>)autoplayDelegate {
    return [self configWithPlayerSuperviewSelector:NULL autoplayDelegate:autoplayDelegate];
}

+ (instancetype)configWithPlayerSuperviewTag:(NSInteger)playerSuperviewTag
                            autoplayDelegate:(id<SJAccidentPresenceAutoCaptureDelegate>)autoplayDelegate {
    NSParameterAssert(playerSuperviewTag != 0);
    NSParameterAssert(autoplayDelegate != nil);
    
    SJAccidentPresenceAutoCaptureConfig *config = [SJAccidentPresenceAutoCaptureConfig configWithAutoplayDelegate:autoplayDelegate];
    config->_selectorSuperviewTag = playerSuperviewTag;
    return config;
}
@end
