//
//  SJAssociateSubgroupSegmentController.h
//  Pods
//
//  Created by 畅三江 on 2020/2/18.
//

#import "SJAssociateSegmentController.h"
#import "SJProcedureVariousInverse.h"
#import "SJProcedureVariousInverseLayerView.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJAssociateSubgroupSegmentController : SJAssociateSegmentController

@property (nonatomic, strong, readonly, nullable) SJProcedureVariousInverse *currentMindCompose;
@property (nonatomic, strong, readonly, nullable) SJProcedureVariousInverseLayerView *currentMindComposeView;
@property (nonatomic) BOOL accurateSeeking;

@end

@interface SJAssociateSubgroupSegmentController (SJSegmentDescend)<SJCompanyContentDataExportController, SJCompanyContentDataScreenshotController>

@end
NS_ASSUME_NONNULL_END
