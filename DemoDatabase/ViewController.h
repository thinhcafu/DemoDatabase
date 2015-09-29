//
//  ViewController.h
//  DemoDatabase
//
//  Created by ECEP2010 on 9/29/15.
//  Copyright (c) 2015 ECEP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSString *databasePath;

@property (nonatomic) sqlite3 *DB;

@property (weak, nonatomic) IBOutlet UITextField *productName;

@property (weak, nonatomic) IBOutlet UITextField *productPrice;


- (IBAction)save:(id)sender;

- (NSArray *) getRecord: (NSString *) filePath where:(NSString *)whereStmt;


@end

