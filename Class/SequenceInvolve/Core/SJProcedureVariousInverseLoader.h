//
//  SJProcedureVariousInverseLoader.h
//  Pods
//
//  Created by 畅三江 on 2019/4/10.
//

#import <Foundation/Foundation.h>
#import "SJCompressContainSale.h"
#import "SJProcedureVariousInverse.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJProcedureVariousInverseLoader : NSObject

+ (nullable SJProcedureVariousInverse *)loadCommentForCompany:(SJCompressContainSale *)company;

+ (void)clearPlayerForCompany:(SJCompressContainSale *)company;

@end
NS_ASSUME_NONNULL_END
