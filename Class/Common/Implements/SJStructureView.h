//
//  SJStructureView.h
//  Pods
//
//  Created by BlueDancer on 2020/6/13.
//

#import "SJStructureViewDefines.h"

typedef NS_ENUM(NSUInteger, SJStructureLayoutPosition) {
    SJStructureLayoutPositionTopLeft,
    SJStructureLayoutPositionTopRight,
    SJStructureLayoutPositionBottomLeft,
    SJStructureLayoutPositionBottomRight
};

NS_ASSUME_NONNULL_BEGIN

@interface SJStructureView : UIImageView<SJStructureView>

@property (nonatomic) SJStructureLayoutPosition layoutPosition;
@property (nonatomic) UIEdgeInsets layoutInsets;
@property (nonatomic) CGFloat layoutHeight;

- (void)layoutWatermarkInRect:(CGRect)rect slowPresentationAccuracy:(CGSize)vSize latencyBoundary:(SJLatencyBoundary)latencyBoundary;

@end

NS_ASSUME_NONNULL_END
