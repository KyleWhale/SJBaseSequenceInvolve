//
//  SJReachabilityObserver.m
//  Project
//
//  Created by 畅三江 on 2018/12/28.
//  Copyright © 2018 changsanjiang. All rights reserved.
//

#import "SJReachability.h"
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "NSTimer+SJAssetAdd.h"

#pragma mark - _Reachability

#import <SystemConfiguration/SystemConfiguration.h>

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class _Reachability;

typedef void (^NetworkReachable) (_Reachability * reachability);
typedef void (^NetworkUnreachable) (_Reachability * reachability);


@interface _Reachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+ (_Reachability*)reachabilityWithHostname:(NSString*)hostname;
+ (_Reachability*)reachabilityWithHostName:(NSString*)hostname;
+ (_Reachability*)reachabilityForInternetConnection;
+ (_Reachability*)reachabilityWithAddress:(void *)hostAddress;
+ (_Reachability*)reachabilityForLocalWiFi;

- (_Reachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)placementReachable;
-(BOOL)wideReachableViaWWAN;
-(BOOL)specificReachableViaWiFi;

-(BOOL)busyConnectionRequired;
-(BOOL)connectionRequired;
-(BOOL)busyConnectionOnDemand;
-(BOOL)dragInterventionRequired;

-(NetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;

@end

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


static NSString *const kReachabilityChangedNotification = @"_kReachabilityChangedNotification";


@interface _Reachability ()

@property (nonatomic, assign) SCNetworkReachabilityRef  reachabilityRef;
@property (nonatomic, strong) dispatch_queue_t          reachabilitySerialQueue;
@property (nonatomic, strong) id                        reachabilityObject;

-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flags;
-(BOOL)inverseReachableWithFlags:(SCNetworkReachabilityFlags)flags;

@end


static NSString *reachabilityFlags(SCNetworkReachabilityFlags flags)
{
    return [NSString stringWithFormat:@"%c%c %c%c%c%c%c%c%c",
#if    TARGET_OS_IPHONE
            (flags & kSCNetworkReachabilityFlagsIsWWAN)               ? 'W' : '-',
#else
            'X',
#endif
            (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'];
}

static void TMReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target)

    _Reachability *reachability = ((__bridge _Reachability*)info);

    @autoreleasepool
    {
        [reachability reachabilityChanged:flags];
    }
}


@implementation _Reachability

#pragma mark -

+ (_Reachability*)reachabilityWithHostName:(NSString*)hostname
{
    return [_Reachability reachabilityWithHostname:hostname];
}

+ (_Reachability*)reachabilityWithHostname:(NSString*)hostname
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    if (ref)
    {
        id reachability = [[self alloc] initWithReachabilityRef:ref];

        return reachability;
    }
    
    return nil;
}

+ (_Reachability *)reachabilityWithAddress:(void *)hostAddress
{
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
    if (ref)
    {
        id reachability = [[self alloc] initWithReachabilityRef:ref];
        
        return reachability;
    }
    
    return nil;
}

+ (_Reachability *)reachabilityForInternetConnection
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress:&zeroAddress];
}

+ (_Reachability*)reachabilityForLocalWiFi
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len            = sizeof(localWifiAddress);
    localWifiAddress.sin_family         = AF_INET;
    localWifiAddress.sin_addr.s_addr    = htonl(IN_LINKLOCALNETNUM);
    
    return [self reachabilityWithAddress:&localWifiAddress];
}

- (_Reachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref
{
    self = [super init];
    if (self != nil)
    {
        self.reachableOnWWAN = YES;
        self.reachabilityRef = ref;
        self.reachabilitySerialQueue = dispatch_queue_create("com.tonymillion.reachability", NULL);
    }
    
    return self;
}

-(void)dealloc
{
    [self stopNotifier];

    if(self.reachabilityRef)
    {
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }

    self.reachableBlock          = nil;
    self.unreachableBlock        = nil;
    self.reachabilitySerialQueue = nil;
}

#pragma mark - Notifier Methods

-(BOOL)startNotifier
{
    if(self.reachabilityObject && (self.reachabilityObject == self))
    {
        return YES;
    }


    SCNetworkReachabilityContext    context = { 0, NULL, NULL, NULL, NULL };
    context.info = (__bridge void *)self;

    if(SCNetworkReachabilitySetCallback(self.reachabilityRef, TMReachabilityCallback, &context))
    {
        if(SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilitySerialQueue))
        {
            self.reachabilityObject = self;
            return YES;
        }
        else
        {
#ifdef DEBUG
            NSLog(@"SCNetworkReachabilitySetDispatchQueue() failed: %s", SCErrorString(SCError()));
#endif

            SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
        }
    }
    else
    {
#ifdef DEBUG
        NSLog(@"SCNetworkReachabilitySetCallback() failed: %s", SCErrorString(SCError()));
#endif
    }

    self.reachabilityObject = nil;
    return NO;
}

-(void)stopNotifier
{
    SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
    
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, NULL);

    self.reachabilityObject = nil;
}

#pragma mark -
#define testcase (kSCNetworkReachabilityFlagsConnectionRequired | kSCNetworkReachabilityFlagsTransientConnection)

-(BOOL)inverseReachableWithFlags:(SCNetworkReachabilityFlags)flags
{
    BOOL connectionUP = YES;
    
    if(!(flags & kSCNetworkReachabilityFlagsReachable))
        connectionUP = NO;
    
    if( (flags & testcase) == testcase )
        connectionUP = NO;
    
#if    TARGET_OS_IPHONE
    if(flags & kSCNetworkReachabilityFlagsIsWWAN)
    {
        if(!self.reachableOnWWAN)
        {
            connectionUP = NO;
        }
    }
#endif
    
    return connectionUP;
}

-(BOOL)placementReachable
{
    SCNetworkReachabilityFlags flags;
    
    if(!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        return NO;
    
    return [self inverseReachableWithFlags:flags];
}

-(BOOL)wideReachableViaWWAN
{
#if    TARGET_OS_IPHONE

    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        if(flags & kSCNetworkReachabilityFlagsReachable)
        {
            if(flags & kSCNetworkReachabilityFlagsIsWWAN)
            {
                return YES;
            }
        }
    }
#endif
    
    return NO;
}

-(BOOL)specificReachableViaWiFi
{
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        if((flags & kSCNetworkReachabilityFlagsReachable))
        {
#if    TARGET_OS_IPHONE
            if((flags & kSCNetworkReachabilityFlagsIsWWAN))
            {
                return NO;
            }
#endif
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)busyConnectionRequired
{
    return [self connectionRequired];
}

-(BOOL)connectionRequired
{
    SCNetworkReachabilityFlags flags;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
    }
    
    return NO;
}

-(BOOL)busyConnectionOnDemand
{
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
                (flags & (kSCNetworkReachabilityFlagsConnectionOnTraffic | kSCNetworkReachabilityFlagsConnectionOnDemand)));
    }
    
    return NO;
}

-(BOOL)dragInterventionRequired
{
    SCNetworkReachabilityFlags flags;
    
    if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        return ((flags & kSCNetworkReachabilityFlagsConnectionRequired) &&
                (flags & kSCNetworkReachabilityFlagsInterventionRequired));
    }
    
    return NO;
}


#pragma mark -

-(NetworkStatus)currentReachabilityStatus
{
    if([self placementReachable])
    {
        if([self specificReachableViaWiFi])
            return ReachableViaWiFi;
        
#if    TARGET_OS_IPHONE
        return ReachableViaWWAN;
#endif
    }
    
    return NotReachable;
}

-(SCNetworkReachabilityFlags)reachabilityFlags
{
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        return flags;
    }
    
    return 0;
}

-(NSString*)currentReachabilityString
{
    NetworkStatus temp = [self currentReachabilityStatus];
    
    if(temp == ReachableViaWWAN)
    {
        return NSLocalizedString(@"Cellular", @"");
    }
    if (temp == ReachableViaWiFi)
    {
        return NSLocalizedString(@"WiFi", @"");
    }
    
    return NSLocalizedString(@"No Connection", @"");
}

-(NSString*)currentReachabilityFlags
{
    return reachabilityFlags([self reachabilityFlags]);
}

#pragma mark -

-(void)reachabilityChanged:(SCNetworkReachabilityFlags)flags
{
    if([self inverseReachableWithFlags:flags])
    {
        if(self.reachableBlock)
        {
            self.reachableBlock(self);
        }
    }
    else
    {
        if(self.unreachableBlock)
        {
            self.unreachableBlock(self);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification
                                                            object:self];
    });
}

#pragma mark -

- (NSString *) description
{
    NSString *description = [NSString stringWithFormat:@"<%@: %p (%@)>",
                             NSStringFromClass([self class]), self, [self currentReachabilityFlags]];
    return description;
}

@end


#pragma mark -

NS_ASSUME_NONNULL_BEGIN
static NSNotificationName const GSDownloadNetworkSpeedNotificationKey = @"__GSDownloadNetworkSpeedNotificationKey";
static NSNotificationName const GSUploadNetworkSpeedNotificationKey = @"__GSUploadNetworkSpeedNotificationKey";

static NSNotificationName const SJReachabilityNetworkStatusDidChangeNotification = @"SJReachabilityNetworkStatusDidChange";

@interface __DJNetworkSpeedObserver : NSObject {
    NSTimer *_Nullable _timer;
     
    @public
    uint32_t _speed;
}

- (NSString *)speedString;
@end

@interface __DJNetworkSpeedObserver ()
@property uint32_t iBytes;
@end

@implementation __DJNetworkSpeedObserver
- (void)dealloc {
    [self stop];
}

- (void)start {
    if ( _timer == nil ) {
        __weak typeof(self) _self = self;
        _timer = [NSTimer assetAdd_timerWithTimeInterval:1 block:^(NSTimer *timer) {
            __strong typeof(_self) self = _self;
            if ( !self ) {
                [timer invalidate];
                return;
            }
            [self checkNetworkSpeed];
        } repeats:YES];
        [_timer assetAdd_fire];
        [NSRunLoop.mainRunLoop addTimer:_timer forMode:NSRunLoopCommonModes];
        self.iBytes = 0;
    }
}

- (void)stop{
    if ( [_timer isValid] ) {
        [_timer invalidate];
        _timer = nil;
        self.iBytes = 0;
    }
}

- (NSString*)speedString {
    // B
    if ( _speed < 1024 )
        return @"0KB";
    // KB
    else if (_speed >= 1024 && _speed < 1024 * 1024)
        return [NSString stringWithFormat:@"%.fKB/s", (double)_speed / 1024];
    // MB
    else if (_speed >= 1024 * 1024 && _speed < 1024 * 1024 * 1024)
        return [NSString stringWithFormat:@"%.1fMB/s", (double)_speed / (1024 * 1024)];
    // GB
    else
        return [NSString stringWithFormat:@"%.1fGB/s", (double)_speed / (1024 * 1024 * 1024)];
}

- (void)checkNetworkSpeed{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        struct ifaddrs *ifa_list = 0, *ifa;
        if ( getifaddrs(&ifa_list) == -1 )
            return;
        uint32_t iBytes = 0;
        
        for ( ifa = ifa_list ; ifa ; ifa = ifa->ifa_next ) {
            if (AF_LINK != ifa->ifa_addr->sa_family)
                continue;
            if (!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
                continue;
            if (ifa->ifa_data == 0)
                continue;
            // network
            if (strncmp(ifa->ifa_name, "lo", 2)) {
                struct if_data* if_data = (struct if_data*)ifa->ifa_data;
                iBytes += if_data->ifi_ibytes;
            }
        }
        freeifaddrs(ifa_list);
        
        uint32_t __iBytes = self.iBytes;
        if ( __iBytes != 0 ) {
            
            uint32_t speed = iBytes - __iBytes;
            if ( speed < 0 ) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_speed = speed;
                [[NSNotificationCenter defaultCenter] postNotificationName:GSDownloadNetworkSpeedNotificationKey object:self];
            });
        }
        self.iBytes = iBytes;
    });
}
@end

@interface SJReachabilityObserver : NSObject<SJReachabilityObserver>
- (instancetype)initWithReachability:(SJReachability *)reachability;
@end

@interface SJReachability ()
@property (nonatomic) SJNetworkStatus networkStatus;
@property (nonatomic, strong, readonly) __DJNetworkSpeedObserver *networkSpeedObserver;
@end

@implementation SJReachability
+ (instancetype)shared {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self new];
    });
    return _instance;
}

- (id<SJReachabilityObserver>)getObserver {
    return [[SJReachabilityObserver alloc] initWithReachability:self];
}

static _Reachability *_reachability;
- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    [self _initializeReachability];
    [self _initializeSpeedObserver];
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (NSString *)networkSpeedStr {
    return [_networkSpeedObserver speedString];
}

- (void)_initializeReachability {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachability = [_Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
    });
    
    [self _updateNetworkStatus];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:_reachability];
}

- (void)reachabilityChanged {
    [self _updateNetworkStatus];
}

- (void)_updateNetworkStatus {
    self.networkStatus = (NSInteger)[_reachability currentReachabilityStatus];
}

- (void)_initializeSpeedObserver {
    _networkSpeedObserver = [[__DJNetworkSpeedObserver alloc] init];
}

- (void)startRefresh {
    [_networkSpeedObserver start];
}

- (void)stopRefresh {
    [_networkSpeedObserver stop];
}

- (void)setNetworkStatus:(SJNetworkStatus)networkStatus {
    _networkStatus = networkStatus;
    [NSNotificationCenter.defaultCenter postNotificationName:SJReachabilityNetworkStatusDidChangeNotification object:self];
}
@end

@implementation SJReachabilityObserver {
    __weak SJReachability *_reachability;
}
@synthesize networkStatusDidChangeExeBlock = _networkStatusDidChangeExeBlock;
@synthesize networkSpeedDidChangeExeBlock = _networkSpeedDidChangeExeBlock;
- (instancetype)initWithReachability:(SJReachability *)reachability {
    self = [super init];
    if ( !self ) return nil;
    _reachability = reachability;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(networkStatusDidChange:) name:SJReachabilityNetworkStatusDidChangeNotification object:reachability];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(networkSpeedDidChange:) name:GSDownloadNetworkSpeedNotificationKey object:reachability.networkSpeedObserver];
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)networkStatusDidChange:(NSNotification *)note {
    id<SJReachability> mgr = note.object;
    if ( _networkStatusDidChangeExeBlock )
        _networkStatusDidChangeExeBlock(mgr);
}
- (void)networkSpeedDidChange:(NSNotification *)note {
    if ( _networkSpeedDidChangeExeBlock ) _networkSpeedDidChangeExeBlock(_reachability);
}
@end
NS_ASSUME_NONNULL_END
