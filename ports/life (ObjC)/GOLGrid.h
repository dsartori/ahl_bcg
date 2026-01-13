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
	NSMutableArray *nextGrid;
	NSMutableArray *liveCellsAndNeighbours;
    bool gridWraps;
	
	
}

@property (readwrite,assign) int gridXsize;
@property (readwrite,assign) int gridYsize;
@property (readwrite,assign) NSMutableArray *cellGrid;
@property (readwrite,assign) NSMutableArray *nextGrid;
@property (readwrite,assign) bool gridWraps;

-(id)initWithGridX:(int)gridX Y:(int)gridY;
-(void)logGrid;
-(void)logNeighbours;
-(void)randomizeGrid:(int)population;
-(void)zeroGrid;
-(void)nextStep;
-(void)clearCellCache;
-(void)loadGridFromFile:(NSString *)fileName local:(bool)local;
-(void)writeGridToFile:(NSString *)fileName;
@end
