//
//  SJConfuseRecordSaveHandler.h
//  SJContactIntegrate_Example
//
//  Created by BlueDancer on 2020/2/20.
//  Copyright © 2020 changsanjiang. All rights reserved.
//

#if __has_include(<YYModel/YYModel.h>) || __has_include(<YYKit/YYKit.h>)

#import <Foundation/Foundation.h>
#import "SJDecisionInvalidPredictController.h"
typedef NS_ENUM(NSUInteger, SJAccidentPresenceEvent) {

    SJAccidentPresenceEventURLAssetWillChange,

    SJAccidentPresenceEventContentDataControllerWillDeallocate,

    SJAccidentPresenceEventContentDataDidPause,

    SJAccidentPresenceEventContentDataWillStop,

    SJAccidentPresenceEventContentDataWillRefresh,

    SJAccidentPresenceEventApplicationDidEnterBackground,

    SJAccidentPresenceEventApplicationWillTerminate,
};

typedef NS_OPTIONS(NSUInteger, SJAccidentPresenceEventMask) {
    SJAccidentPresenceEventMaskURLAssetWillChange = 1 << SJAccidentPresenceEventURLAssetWillChange,
    
    SJAccidentPresenceEventMaskContentDataControllerWillDeallocate = 1 << SJAccidentPresenceEventContentDataControllerWillDeallocate,
    SJAccidentPresenceEventMaskContentDataDidPause = 1 << SJAccidentPresenceEventContentDataDidPause,
    SJAccidentPresenceEventMaskContentDataWillStop = 1 << SJAccidentPresenceEventContentDataWillStop,
    SJAccidentPresenceEventMaskContentDataWillRefresh = 1 << SJAccidentPresenceEventContentDataWillRefresh,
    
    SJAccidentPresenceEventMaskApplicationDidEnterBackground = 1 << SJAccidentPresenceEventApplicationDidEnterBackground,
    SJAccidentPresenceEventMaskApplicationWillTerminate = 1 << SJAccidentPresenceEventApplicationWillTerminate,
    
    SJAccidentPresenceEventMaskContentDataEvents = SJAccidentPresenceEventMaskContentDataControllerWillDeallocate | SJAccidentPresenceEventMaskContentDataWillStop | SJAccidentPresenceEventMaskContentDataWillRefresh | SJAccidentPresenceEventMaskContentDataDidPause,
    
    SJAccidentPresenceEventMaskApplicationEvents = SJAccidentPresenceEventMaskApplicationDidEnterBackground | SJAccidentPresenceEventMaskApplicationWillTerminate,
    
    SJAccidentPresenceEventMaskAll = (SJAccidentPresenceEventMaskURLAssetWillChange | SJAccidentPresenceEventMaskContentDataEvents | SJAccidentPresenceEventMaskApplicationEvents),
};
 
NS_ASSUME_NONNULL_BEGIN
@interface SJCompressContainSale (SJConfuseRecordSaveHandlerExtended)
@property (nonatomic, strong, nullable) SJLatencyStatementRecord *record;
@end


@interface SJConfuseRecordSaveHandler : NSObject
+ (instancetype)shared;
- (instancetype)initWithEvents:(SJAccidentPresenceEventMask)events contentDataHistoryController:(id<SJDecisionInvalidPredictController>)controller;

@property (nonatomic) SJAccidentPresenceEventMask events;
@end


@interface SJAccidentPresenceEventObserver : NSObject
- (instancetype)initWithEvents:(SJAccidentPresenceEventMask)events handler:(void(^)(id target, SJAccidentPresenceEvent event))block;
@property (nonatomic) SJAccidentPresenceEventMask events;
@end
NS_ASSUME_NONNULL_END

#endif
