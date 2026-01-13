//
//  GOLGrid.h
//  dgol
//
//  Created by Douglas Sartori on 10-09-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GOLGrid : NSObject {
	
	int gridXsize;
	int gridYsize;
	NSMutableArray *cellGrid;	
	
}

@property (readwrite,assign) int gridXsize;
@property (readwrite,assign) int gridYsize;
@property (readwrite,assign) NSMutableArray *cellGrid;



-(id)initWithGridX:(int)gridX Y:(int)gridY;
-(void)logGrid;
-(void)zeroGrid;
-(void)fillGrid;
-(void)loadGridFromFile:(NSString *)fileName local:(bool)local;
-(void)writeGridToFile:(NSString *)fileName;
-(NSMutableArray *)serializeBoard;
-(CGPoint)getNextMove;
-(int)farthestDown:(int)row;
-(int)farthestLeft:(int)row;
@end
