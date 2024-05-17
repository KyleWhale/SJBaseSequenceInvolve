//
//  SJCompressContainSale.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2018/1/29.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJPlayModel.h"
#import "SJContactIntegrateLatencyControllerDefines.h"

@protocol SJContactIntegrateURLAssetObserver;

NS_ASSUME_NONNULL_BEGIN

@interface SJCompressContainSale : NSObject<SJCompanyModelProtocol>
- (nullable instancetype)initWithURL:(NSURL *)URL startPosition:(NSTimeInterval)startPosition playModel:(__kindof SJPlayModel *)playModel;
- (nullable instancetype)initWithURL:(NSURL *)URL startPosition:(NSTimeInterval)startPosition;
- (nullable instancetype)initWithURL:(NSURL *)URL playModel:(__kindof SJPlayModel *)playModel;
- (nullable instancetype)initWithURL:(NSURL *)URL;

@property (nonatomic) NSTimeInterval startPosition;

@property (nonatomic) NSTimeInterval trialEndPosition;

@property (nonatomic, strong, null_resettable) SJPlayModel *playModel;
- (id<SJContactIntegrateURLAssetObserver>)getObserver;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@property (nonatomic) BOOL isM3u8;
@end


@protocol SJContactIntegrateURLAssetObserver <NSObject>
@property (nonatomic, copy, nullable) void(^playModelDidChangeExeBlock)(SJCompressContainSale *asset);
@end
NS_ASSUME_NONNULL_END
