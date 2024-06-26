//
//  SJCompressContainSalePrefetcher.m
//  Pods
//
//  Created by 畅三江 on 2019/3/28.
//

#import "SJCompressContainSalePrefetcher.h"
#import "SJProcedureVariousInverseLoader.h"
#define __SJPrefetchMaxCount  (3)

NS_ASSUME_NONNULL_BEGIN
@interface SJCompressContainSalePrefetcher ()
@property (nonatomic, strong, readonly) NSMutableArray<SJCompressContainSale *> *m;
@end

@implementation SJCompressContainSalePrefetcher
+ (instancetype)shared {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}
- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _maxCount = 3;
    _m = [NSMutableArray array];
    return self;
}
- (SJPrefetchIdentifier)prefetchAsset:(SJCompressContainSale *)asset {
    if ( asset ) {
        NSInteger idx = [self _indexOfAsset:asset];
        if ( idx == NSNotFound ) {
            if ( _m.count > _maxCount ) {
                [_m removeObjectAtIndex:0];
            }
            // load asset
            [SJProcedureVariousInverseLoader loadCommentForCompany:asset];
            [_m addObject:asset];
        }
    }
    return (NSInteger)asset;
}
- (SJCompressContainSale *_Nullable)assetForURL:(NSURL *)URL {
    if ( URL ) {
        for ( SJCompressContainSale *asset in _m ) {
            if ( [asset.companyURL isEqual:URL] )
                return asset;
        }
    }
    return nil;
}
- (SJCompressContainSale *_Nullable)assetForIdentifier:(SJPrefetchIdentifier)identifier {
    for ( SJCompressContainSale *asset in _m ) {
        if ( (NSInteger)asset == identifier )
            return asset;
    }
    return nil;
}
- (void)removeAsset:(SJCompressContainSale *)asset {
    NSInteger idx = [self _indexOfAsset:asset];
    if ( idx != NSNotFound )
        [_m removeObjectAtIndex:idx];
}
- (NSInteger)_indexOfAsset:(SJCompressContainSale *)asset {
    if (  asset ) {
        for ( NSInteger i = 0 ; i < _m.count ; ++ i ) {
            SJCompressContainSale *a = _m[i];
            if ( a == asset || [a.companyURL isEqual:asset.companyURL] ) {
                return i;
            }
        }
    }
    return NSNotFound;
}
@end
NS_ASSUME_NONNULL_END
