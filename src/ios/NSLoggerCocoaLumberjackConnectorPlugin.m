//
//  NSLoggerCocoaLumberjackConnectorPlugin.m
//

#import "DDFileLogger.h"
#import "DDTTYLogger.h"
#import "DDNSLoggerLogger.h"

int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface NSLoggerCocoaLumberjackConnectorPlugin ()

@property (nonatomic) DDFileLogger *fileLogger;

@end

@implementation NSLoggerCocoaLumberjackConnectorPlugin

#pragma mark Initialization

- (void)pluginInitialize {
        
    // initialize before HockeySDK, so the delegate can access the file logger!
    self.fileLogger = [[DDFileLogger alloc] init];
    self.fileLogger.maximumFileSize = (1024 * 64); // 64 KByte
    self.fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    [self.fileLogger rollLogFileWithCompletionBlock:nil];
    [DDLog addLogger:self.fileLogger];
        
        
    // add Xcode console logger if not running in the App Store
    if (![self isAppStoreEnvironment]) {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];
    }
    
    DDLogInfo(@"NSLoggerCocoaLumberjackConnectorPlugin Plugin initialized");
}

- (BOOL)isAppStoreEnvironment {
    // cribbed from HockeyApp SDK
    BOOL appStoreEnvironment=NO;
#if !TARGET_IPHONE_SIMULATOR
    // check if we are really in an app store environment
    if (![[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"]) {
      appStoreEnvironment = YES;
    }
#endif
    return appStoreEnvironment;
}

@end
