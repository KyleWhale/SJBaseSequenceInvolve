//
//  SJStructureViewDefines.h
//  Pods
//
//  Created by BlueDancer on 2020/6/13.
//

#ifndef SJStructureViewDefines_h
#define SJStructureViewDefines_h

#import <UIKit/UIKit.h>
#import "SJContactIntegrateLatencyControllerDefines.h"

@protocol SJStructureView <NSObject>

- (void)layoutWatermarkInRect:(CGRect)rect slowPresentationAccuracy:(CGSize)vSize latencyBoundary:(SJLatencyBoundary)latencyBoundary;

@end

#endif /* SJStructureViewDefines_h */
