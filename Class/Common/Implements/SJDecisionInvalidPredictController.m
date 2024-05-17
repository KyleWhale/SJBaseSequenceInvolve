//
//  SJDecisionInvalidPredictController.m
//  Pods
//
//  Created by 畅三江 on 2020/2/19.
//

#import "SJDecisionInvalidPredictController.h"
#if __has_include(<SJUIKit/SJSQLite3.h>)
#import <SJUIKit/SJSQLite3+Private.h>
#import <SJUIKit/SJSQLite3+RemoveExtended.h>
#import <SJUIKit/SJSQLite3+TableExtended.h>
#else
#import "SJSQLite3+Private.h"
#import "SJSQLite3+RemoveExtended.h"
#import "SJSQLite3+TableExtended.h"
#endif

NS_ASSUME_NONNULL_BEGIN
SJSequenceType const SJAsteriskTypeFailure = @"video";
SJSequenceType const SJCompanyTypeRedefine = @"audio";

@implementation SJLatencyStatementRecord(SJSQLite3Extended)
+ (nullable NSString *)sql_primaryKey {
    return @"id";
}

+ (nullable NSArray<NSString *> *)sql_autoincrementlist {
    return @[@"id"];
}
@end

@interface SJDecisionInvalidPredictController ()
@property (nonatomic, strong, nullable) SJSQLite3 *sqlite;
@end

@implementation SJDecisionInvalidPredictController
+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"com.SJBaseSequenceInvolve.history/sj.db"];
        obj = [SJDecisionInvalidPredictController.alloc initWithPath:path];
    });
    return obj;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if ( self ) {
        self.sqlite = [SJSQLite3.alloc initWithDatabasePath:path];
    }
    return self;
}

- (void)save:(SJLatencyStatementRecord *)record {
    if ( record != nil ) {
        SJLatencyStatementRecord *_Nullable old = [self recordForCompany:record.companyId user:record.userId companyType:record.companyType];
        if ( old != nil ) record.id = old.id;
        else record.createdTime = NSDate.date.timeIntervalSince1970;
        record.updatedTime = NSDate.date.timeIntervalSince1970;
        [_sqlite save:record error:NULL];
    }
}

- (nullable SJLatencyStatementRecord *)recordForCompany:(NSInteger)companyId user:(NSInteger)userId companyType:(SJSequenceType)companyType {
    NSParameterAssert(companyType);
    return [self recordsForConditions:@[
        [SJSQLite3Condition conditionWithColumn:@"companyId" value:@(companyId)],
        [SJSQLite3Condition conditionWithColumn:@"userId" value:@(userId)],
        [SJSQLite3Condition conditionWithColumn:@"companyType" value:companyType]
    ] orderBy:nil].lastObject;
}

- (nullable NSArray<SJLatencyStatementRecord *> *)recordsForUser:(NSInteger)userId companyType:(SJSequenceType)companyType range:(NSRange)range {
    return [self recordsForConditions:@[
        [SJSQLite3Condition conditionWithColumn:@"userId" value:@(userId)],
        [SJSQLite3Condition conditionWithColumn:@"companyType" value:companyType],
    ] orderBy:@[
        [SJSQLite3ColumnOrder orderWithColumn:@"updatedTime" ascending:NO]
    ] range:range];
}

- (nullable NSArray<SJLatencyStatementRecord *> *)recordsForUser:(NSInteger)userId companyType:(SJSequenceType)companyType {
    return [self recordsForUser:userId companyType:companyType range:NSMakeRange(0, NSUIntegerMax)];
}

- (nullable NSArray<SJLatencyStatementRecord *> *)recordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions orderBy:(nullable NSArray<SJSQLite3ColumnOrder *> *)orders {
    return [self recordsForConditions:conditions orderBy:orders range:NSMakeRange(0, NSUIntegerMax)];
}

- (nullable NSArray<SJLatencyStatementRecord *> *)recordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions orderBy:(nullable NSArray<SJSQLite3ColumnOrder *> *)orders range:(NSRange)range {
    return [_sqlite objectsForClass:SJLatencyStatementRecord.class conditions:conditions orderBy:orders range:range error:NULL];
}

- (NSUInteger)countOfRecordsForUser:(NSInteger)userId companyType:(SJSequenceType)companyType {
    return [self countOfRecordsForConditions:@[
        [SJSQLite3Condition conditionWithColumn:@"userId" value:@(userId)],
        [SJSQLite3Condition conditionWithColumn:@"companyType" value:companyType],
    ]];
}

- (NSUInteger)countOfRecordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions {
    return [_sqlite countOfObjectsForClass:SJLatencyStatementRecord.class conditions:conditions error:NULL];
}

- (void)remove:(NSInteger)company user:(NSInteger)userId companyType:(SJSequenceType)companyType {
    NSParameterAssert(companyType);
    SJLatencyStatementRecord *record = [self recordForCompany:company user:userId companyType:companyType];
    if ( record == nil ) return;
    [_sqlite removeObjectsForClass:SJLatencyStatementRecord.class primaryKeyValues:@[@(record.id)] error:NULL];
}

- (void)removeAllRecordsForUser:(NSInteger)userId companyType:(SJSequenceType)companyType {
    NSParameterAssert(companyType);
    [_sqlite removeAllObjectsForClass:SJLatencyStatementRecord.class conditions:@[
        [SJSQLite3Condition conditionWithColumn:@"userId" value:@(userId)],
        [SJSQLite3Condition conditionWithColumn:@"companyType" value:companyType],
    ] error:NULL];
}

- (void)removeForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions {
    [_sqlite removeAllObjectsForClass:SJLatencyStatementRecord.class conditions:conditions error:NULL];
}
@end
NS_ASSUME_NONNULL_END
