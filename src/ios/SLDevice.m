/********* SLDevice.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import "FCUUID.h"

@interface SLDevice : CDVPlugin {
  // Member variables go here.
}

- (void) isGenuine:(CDVInvokedUrlCommand*)command;
- (void) uuidForDevice:(CDVInvokedUrlCommand*)command;

@end

@implementation SLDevice

- (void) isGenuine:(CDVInvokedUrlCommand*)command{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *pluginResult;
        
        @try
        {
            bool jailbroken = [self jailbroken];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:jailbroken];
        }
        @catch (NSException *exception)
        {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
        }
        @finally
        {
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    }];
}

- (bool) jailbroken {
    
#if !(TARGET_IPHONE_SIMULATOR)
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"])
    {
        return YES;
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"])
    {
        return YES;
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"])
    {
        return YES;
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"])
    {
        return YES;
    }
    else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"])
    {
        return YES;
    }
    
    NSError *error;
    NSString *testWriteText = @"Jailbreak test";
    NSString *testWritePath = @"/private/jailbreaktest.txt";
    
    [testWriteText writeToFile:testWritePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    if (error == nil)
    {
        [[NSFileManager defaultManager] removeItemAtPath:testWritePath error:nil];
        return YES;
    }
    else
    {
        [[NSFileManager defaultManager] removeItemAtPath:testWritePath error:nil];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]])
    {
        return YES;
    }
    
#endif
    
    return NO;
}

- (void) uuidForDevice:(CDVInvokedUrlCommand*)command{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *pluginResult;
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[FCUUID uuidForDevice]];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
