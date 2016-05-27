//
//  DBManager.m
//  iosintership
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import "DBManager.h"
#import "sqlite3.h"


@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;


- (void)copyDatabaseIntoDocumentsDirectory;
- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager

#pragma mark - Initialization

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        self.databaseFilename = dbFilename;
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}


#pragma mark - Private method implementation

- (void)copyDatabaseIntoDocumentsDirectory
{
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
    {
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                toPath:destinationPath
                                                 error:&error];
        
        if (error != nil)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}



- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable
{
	sqlite3 *sqlite3Database;
	NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    if (self.arrResults != NULL)
    {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
	self.arrResults = [[NSMutableArray alloc] init];
    
    if (self.arrColumnNames != nil)
    {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    
    int openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
	if(openDatabaseResult == SQLITE_OK)
    {
		sqlite3_stmt *compiledStatement;
        int prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
		if(prepareStatementResult == SQLITE_OK)
        {
			if (!queryExecutable)
            {
                NSMutableArray *arrDataRow;
                NSMutableDictionary *itemsList = [NSMutableDictionary new];
                NSMutableArray *items = [NSMutableArray new];
                
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    arrDataRow = [[NSMutableArray alloc] init];
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
					for (int i=0; i<totalColumns; i++)
                    {
						char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        if (dbDataAsChars != NULL)
                        {
							[arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
						}
                        
                        if (self.arrColumnNames.count != totalColumns)
                        {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        
                }
                    }
                    
                
					if (arrDataRow.count > 0)
                    {
                        [self.arrResults addObject:arrDataRow];
					}
                    NSString *studentId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                    NSString *firstName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                    NSString *lastName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                    NSString *email = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                    NSString *phone = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                    NSString *createdDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                    NSString *updatedDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                    NSString *imageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                    NSString *group = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                    
                    Student *student = [Student studentWithId:studentId firstName:firstName lastName:lastName email:email phone:phone createdDate:createdDate updatedDate:updatedDate imageName:imageName image:nil group:group];
                    
                    itemsList = [NSMutableDictionary dictionaryWithObjectsAndKeys:student.studentId,@"id",student.firstName,@"first_name",student.lastName,@"last_name",student.email,@"email",student.phone,@"phone_number",student.created,@"created_date", student.updated,@"updated_date", student.imageName,@"photo", student.group,@"section", nil];
                    
                    [items addObject:student];

                                 }
                
                _studentsList = [items copy];
            
                NSLog(@"student list = %@", _studentsList);
                
                
            }
            
            
            
			else
            {
               
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE)
                {
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
				}
				else
                {
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
				}
			}
		}
		else
        {
			NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
		}
		sqlite3_finalize(compiledStatement);
		
	}
        sqlite3_close(sqlite3Database);
}


#pragma mark - Public method implementation

- (NSArray *)loadDataFromDB:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray *)self.arrResults;
}


- (void)executeQuery:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
