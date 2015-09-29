//
//  ViewController.m
//  DemoDatabase
//
//  Created by ECEP2010 on 9/29/15.
//  Copyright (c) 2015 ECEP. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
 NSString *docsDir;
 NSArray *dirPaths;

    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // build the path to keep the database
  _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"myProduct2.sqlite"]];
   //  _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"productdb1.sqlite"]];
   NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:_databasePath] == NO){
 
        const char *dbpath = [_databasePath UTF8String];
        
        NSLog(@"ok0");
        NSLog(@"%s", dbpath);
        NSLog(@"%@",_DB);
        if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
            NSLog(@"ok1");
            char *errorMessage;
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS products (ID INTEGER PRIMARY KEY AUTOINCREMENT, product_name TEXT, product_price TEXT)";
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK){
                    [self showUIAlertWithMessage:@"Failed to create the table" andTitle:@"Error"];
            }
                    sqlite3_close(_DB);
        }

        else{
            [self showUIAlertWithMessage:@"Failed to open/create the table" andTitle:@"Error"];
        }
    }
}

- (void) showUIAlertWithMessage:(NSString*)message andTitle:(NSString*)title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getRecord:(NSString *)filePath where:(NSString *)whereStmt{

    NSMutableArray *arrProducts = [[NSMutableArray alloc] init];
    sqlite3 *db = NULL;
    sqlite3_stmt *statement = NULL;
    int rc = 0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY, NULL);
    if(SQLITE_OK != rc)
    {
    
        sqlite3_close(db);
        NSLog(@"Failed to open database connection");
    }
    else{
    
        NSString *query = @"SELECT * from products";
        if (whereStmt) {
            query = [query stringByAppendingFormat:@"WHERE %@",whereStmt];
        }
        rc = sqlite3_prepare_v2(db, [query UTF8String],  -1,  &statement, NULL);
        if (rc == SQLITE_OK) {
            
            while (sqlite3_step(statement) == SQLITE_ROW) { // get each row in loop
                NSString *productName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSInteger productPrice = sqlite3_column_int(statement, 2);
                NSDictionary *product = [NSDictionary dictionaryWithObjectsAndKeys:productName,@"product_Name",[NSNumber numberWithInteger:productPrice], @"product_Price", nil];
                [arrProducts addObject:product];
                NSLog(@"productName: %@, price: %ld",productName,(long) productPrice);
            }
            NSLog(@"Done");
            sqlite3_finalize(statement);
        }
        else{
        
             NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return arrProducts;
}

- (IBAction)save:(id)sender{

    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
       NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO products (product_name, product_price) VALUES (\"%@\", \"%@\")", _productName.text, _productPrice.text];
        
        const char *insert_statement = [insertSQL UTF8String];
        
        NSLog(@"%s",insert_statement);
    
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);

        if (sqlite3_step(statement) == SQLITE_DONE) {
            [self showUIAlertWithMessage:@"Product added to the database" andTitle:@"Message"];
            _productPrice.text = @"";
            _productName.text = @"";
            NSLog(@"Added success");
        }
        else{
        
            [self showUIAlertWithMessage:@"Failed to add the product" andTitle:@"Error"];
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
}



@end
