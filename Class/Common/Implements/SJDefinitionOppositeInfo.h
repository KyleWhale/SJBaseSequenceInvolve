//
//  SJDefinitionOppositeInfo.h
//  Pods
//
//  Created by 畅三江 on 2019/7/12.
//

#import <Foundation/Foundation.h>
#import "SJCompressContainSale.h"
#import "SJContactIntegrateLatencyControllerDefines.h"
@class SJConfirmDefinitionOppositeInfoObserver;

NS_ASSUME_NONNULL_BEGIN

@interface SJDefinitionOppositeInfo : NSObject

- (SJConfirmDefinitionOppositeInfoObserver *)getObserver;

@property (nonatomic, weak, readonly, nullable) SJCompressContainSale *currentPlayingAsset;

@property (nonatomic, weak, readonly, nullable) SJCompressContainSale *switchingAsset;

@property (nonatomic, readonly) SJDefinitionOppositeStatus status;

@end



@interface SJConfirmDefinitionOppositeInfoObserver: NSObject

@property (nonatomic, copy, nullable) void(^statusDidChangeExeBlock)(SJDefinitionOppositeInfo *info);

@end

NS_ASSUME_NONNULL_END
