//
//  SJPromptingPopupController.h
//  Pods
//
//  Created by 畅三江 on 2019/7/12.
//

#ifndef SJPromptingPopupControllerProtocol_h
#define SJPromptingPopupControllerProtocol_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJPromptingPopupController <NSObject>
@property (nonatomic) UIEdgeInsets contentInset;
- (void)show:(NSAttributedString *)title;
- (void)show:(NSAttributedString *)title duration:(NSTimeInterval)duration;

- (void)showCustomView:(UIView *)view;
- (void)showCustomView:(UIView *)view duration:(NSTimeInterval)duration;
- (BOOL)isShowingWithCustomView:(UIView *)view;

- (void)remove:(UIView *)view;
- (void)clear;
@property (nonatomic) CGFloat leftMargin;
@property (nonatomic) CGFloat bottomMargin;
@property (nonatomic) CGFloat itemSpacing;

@property (nonatomic, copy, readonly, nullable) __kindof NSArray<UIView *> *displayingViews;

@property (nonatomic) BOOL automaticallyAdjustsLeftInset;
@property (nonatomic) BOOL automaticallyAdjustsBottomInset;

@property (nonatomic, weak, nullable) UIView *target;
@end
NS_ASSUME_NONNULL_END

#endif /* SJPromptingPopupControllerProtocol_h */
