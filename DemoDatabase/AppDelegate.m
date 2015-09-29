//
//  AppDelegate.m
//  DemoDatabase
//
//  Created by ECEP2010 on 9/29/15.
//  Copyright (c) 2015 ECEP. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSString*) filePath{
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // build the path to keep the database
    return [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"myProduct2.sqlite"]];

}

-(void) checkAndCopyDBIfNotExist {
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *pathToDatabase = [self filePath];
    
    success = [fileManager fileExistsAtPath:pathToDatabase];
    
    if (success) {
        // NSLog(@"Database already created");
        return;
    }
    
    // database is not exist
    // copy from resource
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"myProduct2.sqlite"];

    success = [fileManager copyItemAtPath:defaultPath toPath:pathToDatabase error:&error];
    if (success) {
        NSLog(@"database created success");
    }
    
}

- (void)openDatabase
{
    sqlite3 *db;
    NSString *pathToDatabase = [self filePath];
    
    if (sqlite3_open([pathToDatabase UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(0, @"Database failed to open");
    }
}

- (void)closeDatabase
{
    sqlite3 *db;
    sqlite3_close(db);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[self checkAndCopyDBIfNotExist];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
