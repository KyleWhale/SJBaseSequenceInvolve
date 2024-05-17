//
//  SJSmallViewFloatingController.h
//  Pods
//
//  Created by 畅三江 on 2019/6/6.
//

#import <UIKit/UIKit.h>
#import "SJSmallViewFloatingControllerDefines.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SJSmallViewLayoutPosition) {
    SJSmallViewLayoutPositionTopLeft,
    SJSmallViewLayoutPositionTopRight,
    SJSmallViewLayoutPositionBottomLeft,
    SJSmallViewLayoutPositionBottomRight,
};

@interface SJSmallViewFloatingController : NSObject<SJSmallViewFloatingController>

@property (nonatomic) SJSmallViewLayoutPosition layoutPosition;
@property (nonatomic) UIEdgeInsets layoutInsets;
@property (nonatomic) CGSize layoutSize;
@property (nonatomic) BOOL ignoreSafeAreaInsets API_AVAILABLE(ios(11.0));
@property (nonatomic) BOOL addFloatViewToKeyWindow;
@end
NS_ASSUME_NONNULL_END
