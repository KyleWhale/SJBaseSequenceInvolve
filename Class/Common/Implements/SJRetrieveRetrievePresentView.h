//
//  SJRetrieveRetrievePresentView.h
//  SJContactIntegrateProject
//
//  Created by 畅三江 on 2017/11/29.
//  Copyright © 2017年 changsanjiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJRetrieveRetrievePresentViewDefines.h"
#import "SJGestureControllerDefines.h"
@protocol SJRetrieveRetrievePresentViewDelegate;

NS_ASSUME_NONNULL_BEGIN
@interface SJRetrieveRetrievePresentView : UIView<SJRetrieveRetrievePresentView, SJGestureController>
@property (nonatomic, weak, nullable) id<SJRetrieveRetrievePresentViewDelegate> delegate;
@end

@protocol SJRetrieveRetrievePresentViewDelegate <NSObject>
@optional
- (void)presentViewDidLayoutSubviews:(SJRetrieveRetrievePresentView *)presentView;
- (void)presentViewDidMoveToWindow:(SJRetrieveRetrievePresentView *)presentView;
@end
NS_ASSUME_NONNULL_END
