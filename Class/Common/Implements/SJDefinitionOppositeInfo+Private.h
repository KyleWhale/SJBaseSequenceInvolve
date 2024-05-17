//
//  SJDefinitionOppositeInfo+Private.h
//  Pods
//
//  Created by 畅三江 on 2019/7/12.
//

#import "SJDefinitionOppositeInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJDefinitionOppositeInfo (Private)
@property (nonatomic, weak, nullable) SJCompressContainSale *currentPlayingAsset;

@property (nonatomic, weak, nullable) SJCompressContainSale *switchingAsset;

@property (nonatomic) SJDefinitionOppositeStatus status;
@end

NS_ASSUME_NONNULL_END
