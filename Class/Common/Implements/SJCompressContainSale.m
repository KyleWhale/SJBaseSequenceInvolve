//
//  SJCompressContainSale.m
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/1/29.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#import "SJCompressContainSale.h"
#import <objc/message.h>
#if __has_include(<SJUIKit/NSObject+SJObserverHelper.h>)
#import <SJUIKit/NSObject+SJObserverHelper.h>
#else
#import "NSObject+SJObserverHelper.h"
#endif

NS_ASSUME_NONNULL_BEGIN
@interface SJContactIntegrateURLAssetObserver : NSObject<SJContactIntegrateURLAssetObserver>
- (instancetype)initWithAsset:(SJCompressContainSale *)asset;
@end
@implementation SJContactIntegrateURLAssetObserver
@synthesize playModelDidChangeExeBlock = _playModelDidChangeExeBlock;

- (instancetype)initWithAsset:(SJCompressContainSale *)asset {
    self = [super init];
    if ( !self ) return nil;
    [asset sj_addObserver:self forKeyPath:@"playModel"];
    return self;
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change context:(nullable void *)context {
    if ( _playModelDidChangeExeBlock ) _playModelDidChangeExeBlock(object);
}
@end

@implementation SJCompressContainSale
@synthesize companyURL = _companyURL; 

- (nullable instancetype)initWithURL:(NSURL *)URL startPosition:(NSTimeInterval)startPosition playModel:(__kindof SJPlayModel *)playModel {
    if ( !URL ) return nil;
    self = [super init];
    if ( !self ) return nil;
    _companyURL = URL;
    _startPosition = startPosition;
    _playModel = playModel?:[SJPlayModel new];
    _isM3u8 = [_companyURL.pathExtension containsString:@"m3u8"];
    return self;
}
- (nullable instancetype)initWithURL:(NSURL *)URL startPosition:(NSTimeInterval)startPosition {
    return [self initWithURL:URL startPosition:startPosition playModel:[SJPlayModel new]];
}
- (nullable instancetype)initWithURL:(NSURL *)URL playModel:(__kindof SJPlayModel *)playModel {
    return [self initWithURL:URL startPosition:0 playModel:playModel];
}
- (nullable instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURL:URL startPosition:0];
}
- (void)setCompanyURL:(nullable NSURL *)companyURL {
    _companyURL = companyURL;
    _isM3u8 = [companyURL.pathExtension containsString:@"m3u8"];
}
- (SJPlayModel *)playModel {
    if ( _playModel )
        return _playModel;
    return _playModel = [SJPlayModel new];
}
- (id<SJContactIntegrateURLAssetObserver>)getObserver {
    return [[SJContactIntegrateURLAssetObserver alloc] initWithAsset:self];
}
@end
NS_ASSUME_NONNULL_END
