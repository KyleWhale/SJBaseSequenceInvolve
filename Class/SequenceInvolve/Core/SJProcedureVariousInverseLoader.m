//
//  SJProcedureVariousInverseLoader.m
//  Pods
//
//  Created by 畅三江 on 2019/4/10.
//

#import "SJProcedureVariousInverseLoader.h"
#import "SJCompressContainSale+SJSegmentDescend.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation SJProcedureVariousInverseLoader
static void *kPlayer = &kPlayer;

+ (nullable SJProcedureVariousInverse *)loadCommentForCompany:(SJCompressContainSale *)company {
#ifdef DEBUG
    NSParameterAssert(company);
#endif
    if ( company == nil )
        return nil;
    
    SJCompressContainSale *target = company.original ?: company;
    SJProcedureVariousInverse *__block _Nullable player = objc_getAssociatedObject(target, kPlayer);
    if ( player != nil && player.reserveStatus != SJDuplicateStatusFailed ) {
        return player;
    }
    
    AVPlayer *avPlayer = target.reflectMean;
    if ( avPlayer == nil ) {
        AVPlayerItem *item = target.reflectMeanItem;
        if (item != nil && item.status != AVPlayerStatusUnknown) {
            NSURL *URL = nil;
            if ( [item.asset isKindOfClass:AVURLAsset.class] ) {
                URL = [(AVURLAsset *)item.asset URL];
            }
            if ( URL == nil )
                return nil;
            item = [AVPlayerItem playerItemWithURL:URL];
            target.reflectMeanItem = item;
        }
        
        if ( item == nil ) {
            AVAsset *avAsset = target.reflectAsset;
            if ( avAsset == nil ) {
                avAsset = [AVURLAsset URLAssetWithURL:target.companyURL options:nil];
            }
            item = [AVPlayerItem playerItemWithAsset:avAsset];
        }
        avPlayer = [AVPlayer playerWithPlayerItem:item];
    }
    
    player = [SJProcedureVariousInverse.alloc initWithAVPlayer:avPlayer startPosition:company.startPosition];
    objc_setAssociatedObject(target, kPlayer, player, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return player;
}

+ (void)clearPlayerForCompany:(SJCompressContainSale *)company {
    if ( company != nil ) {
        id<SJCompanyModelProtocol> target = company.original ?: company;
        objc_setAssociatedObject(target, kPlayer, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
@end
NS_ASSUME_NONNULL_END
