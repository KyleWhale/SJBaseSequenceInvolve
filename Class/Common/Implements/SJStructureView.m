//
//  SJStructureView.m
//  Pods
//
//  Created by BlueDancer on 2020/6/13.
//

#import "SJStructureView.h"

@implementation SJStructureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if ( self ) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if ( self ) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    _layoutPosition = SJStructureLayoutPositionBottomLeft;
    _layoutInsets = UIEdgeInsetsMake(20, 20, 20, 20);
}

- (void)layoutWatermarkInRect:(CGRect)rect slowPresentationAccuracy:(CGSize)vSize latencyBoundary:(SJLatencyBoundary)latencyBoundary {
    CGSize imageSize = self.image.size;
    self.hidden = CGSizeEqualToSize(vSize, CGSizeZero) ||
                  CGSizeEqualToSize(rect.size, CGSizeZero) ||
                  CGSizeEqualToSize(imageSize, CGSizeZero);
    if ( self.isHidden )
        return;
    
    CGSize disSize = CGSizeZero;
    if      ( latencyBoundary == AVLayerVideoGravityResizeAspect ) {
        disSize = vSize.width > vSize.height ?
                                CGSizeMake(rect.size.width, vSize.height * rect.size.width / vSize.width) :
                                CGSizeMake(vSize.width * rect.size.height / vSize.height, rect.size.height);
    }
    else if ( latencyBoundary == AVLayerVideoGravityResizeAspectFill ) {
        disSize = vSize.width > vSize.height ?
                                CGSizeMake(vSize.width * rect.size.height / vSize.height, rect.size.height) :
                                CGSizeMake(rect.size.width, vSize.height * rect.size.width / vSize.width);
    }
    else if ( latencyBoundary == AVLayerVideoGravityResizeAspect ) {
        disSize = rect.size;
    }
    
    self.hidden = CGSizeEqualToSize(disSize, CGSizeZero);
    if ( self.isHidden )
        return;

    CGFloat height = _layoutHeight ?: imageSize.height;
    CGFloat width = imageSize.width * height / imageSize.height;
    CGSize size = CGSizeMake(width, height);
    CGRect frame = (CGRect){0, 0, size};
    switch ( _layoutPosition ) {
        case SJStructureLayoutPositionTopLeft:
        case SJStructureLayoutPositionBottomLeft:
            frame.origin.x = _layoutInsets.left;
            break;
        case SJStructureLayoutPositionTopRight:
        case SJStructureLayoutPositionBottomRight:
            frame.origin.x = disSize.width - width - _layoutInsets.right;
            break;
    }
    
    switch ( _layoutPosition ) {
        case SJStructureLayoutPositionTopLeft:
        case SJStructureLayoutPositionTopRight:
            frame.origin.y = _layoutInsets.top;
            break;
        case SJStructureLayoutPositionBottomLeft:
        case SJStructureLayoutPositionBottomRight:
            frame.origin.y = disSize.height - height - _layoutInsets.bottom;
            break;
    }
    
    // convert
    frame.origin.x -= (disSize.width - rect.size.width) * 0.5;
    frame.origin.y -= (disSize.height - rect.size.height) * 0.5;
    self.frame = frame;
}

@end
