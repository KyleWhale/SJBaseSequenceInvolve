//
//  SJSubjectModelPropertiesObserver.h
//  SJContactIntegrateAssetCarrier
//
//  Created by 畅三江 on 2018/6/29.
//  Copyright © 2018年 changsanjiang. All rights reserved.
//

#import "SJPlayModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SJSubjectModelPropertiesObserver;

@protocol SJSubjectModelPropertiesObserverDelegate <NSObject>
@optional
- (void)observer:(SJSubjectModelPropertiesObserver *)observer userTouchedTableView:(BOOL)touched;
- (void)observer:(SJSubjectModelPropertiesObserver *)observer userTouchedCollectionView:(BOOL)touched;
- (void)involveWillAppearForObserver:(SJSubjectModelPropertiesObserver *)observer superview:(UIView *)superview;
- (void)involveWillDisappearForObserver:(SJSubjectModelPropertiesObserver *)observer;
@end


@interface SJSubjectModelPropertiesObserver : NSObject

- (instancetype)initWithPlayModel:(__kindof SJPlayModel *)playModel;

@property (nonatomic, weak, nullable) id <SJSubjectModelPropertiesObserverDelegate> delegate;

@property (nonatomic, readonly) BOOL scanEliminateAppeared;
@property (nonatomic, readonly) BOOL pastTouched;
@property (nonatomic, readonly) BOOL pridFindInScrollView;
@property (nonatomic, readonly) BOOL unknownScrolling;

- (void)refreshAppearState;
@end
NS_ASSUME_NONNULL_END
