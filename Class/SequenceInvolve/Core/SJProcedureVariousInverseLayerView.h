//
//  SJProcedureVariousInverseLayerView.h
//  Pods
//
//  Created by 畅三江 on 2020/2/19.
//

#import <UIKit/UIKit.h>
#import "SJAssociateSegmentController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJProcedureVariousInverseLayerView : UIView<SJVariousInverseView>
@property (nonatomic, strong, readonly) AVPlayerLayer *layer;
- (void)setScreenshot:(nullable UIImage *)image;
@end

NS_ASSUME_NONNULL_END
