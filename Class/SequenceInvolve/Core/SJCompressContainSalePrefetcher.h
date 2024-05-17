//
//  SJCompressContainSalePrefetcher.h
//  Pods
//
//  Created by 畅三江 on 2019/3/28.
//

#import <Foundation/Foundation.h>
#import "SJCompressContainSale.h"

NS_ASSUME_NONNULL_BEGIN
typedef NSInteger SJPrefetchIdentifier;

@interface SJCompressContainSalePrefetcher : NSObject
+ (instancetype)shared;
@property (nonatomic) NSUInteger maxCount;

- (SJPrefetchIdentifier)prefetchAsset:(SJCompressContainSale *)asset;
- (SJCompressContainSale *_Nullable)assetForURL:(NSURL *)URL;
- (SJCompressContainSale *_Nullable)assetForIdentifier:(SJPrefetchIdentifier)identifier;
- (void)removeAsset:(SJCompressContainSale *)asset;
@end
NS_ASSUME_NONNULL_END
