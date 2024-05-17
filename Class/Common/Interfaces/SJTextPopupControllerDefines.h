//
//  SJTextPopupControllerDefines.h
//  Pods
//
//  Created by 畅三江 on 2019/9/15.
//

#ifndef SJTextPopupControllerDefines_h
#define SJTextPopupControllerDefines_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJTextPopupController <NSObject>
- (void)show:(NSAttributedString *)title;
- (void)show:(NSAttributedString *)title duration:(NSTimeInterval)duration;
- (void)show:(NSAttributedString *)title duration:(NSTimeInterval)duration completionHandler:(nullable void(^)(void))completionHandler;
- (void)hidden;

@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic, strong, nullable) UIColor *backgroundColor;
@property (nonatomic) CGFloat maxLayoutWidth;

@property (nonatomic, weak, nullable) UIView *target;
@end
NS_ASSUME_NONNULL_END
#endif /* SJTextPopupControllerDefines_h */
