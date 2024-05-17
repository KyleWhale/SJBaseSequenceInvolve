//
//  SJContactIntegrateRegistrar.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2017/12/5.
//  Copyright © 2017年 changsanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SJContactIntegrateAppState) {
    SJContactIntegrateAppState_Active,
    SJContactIntegrateAppState_Inactive,
    SJContactIntegrateAppState_Background,
};

@interface SJContactIntegrateRegistrar : NSObject

@property (nonatomic, readonly) SJContactIntegrateAppState state;

@property (nonatomic, copy, nullable) void(^willResignActive)(SJContactIntegrateRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^didBecomeActive)(SJContactIntegrateRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^willEnterForeground)(SJContactIntegrateRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^didEnterBackground)(SJContactIntegrateRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^willTerminate)(SJContactIntegrateRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^newDeviceAvailable)(SJContactIntegrateRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^oldDeviceUnavailable)(SJContactIntegrateRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^categoryChange)(SJContactIntegrateRegistrar *registrar);

@property (nonatomic, copy, nullable) void(^audioSessionInterruption)(SJContactIntegrateRegistrar *registrar);

@end

NS_ASSUME_NONNULL_END
