//
//  GOLGrid.m
//  dgol
//
//  Created by Douglas Sartori on 10-09-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GOLGrid.h"
#import "GOLCell.h"

@implementation GOLGrid

@synthesize gridXsize, gridYsize, cellGrid ;

-(id)initWithGridX:(int)gridX Y:(int)gridY{
    
	self = [super init];
	
	gridXsize = gridX;
	gridYsize = gridY;
	
	
	if (self){

		NSMutableArray *tmpGrid = [NSMutableArray array];
		
		int m,n = 0;
		
		for ( m = 0;  m < gridYsize ; m++){

			NSMutableArray *tmpRow = [NSMutableArray array];
			for ( n = 0;  n < gridXsize ; n++){
				GOLCell *cell = [[GOLCell alloc] init];
				[tmpRow addObject:cell];
				[cell autorelease];
			}

			[tmpGrid addObject:tmpRow];

		}
		
		cellGrid = [[NSMutableArray alloc] initWithArray:tmpGrid copyItems:YES];
		
		NSMutableArray *nxtGrid = [NSMutableArray array];
		
		for ( m = 0;  m < gridYsize ; m++){
			
			NSMutableArray *nxtRow = [NSMutableArray array];
			for ( n = 0;  n < gridXsize ; n++){
				GOLCell *cell = [[GOLCell alloc] init];
				[nxtRow addObject:cell];
				[cell autorelease];
			}
			
			[nxtGrid addObject:nxtRow];
			
		}

		}


	
	return self;
}

- (void)logGrid{
	
	int x,y;
	GOLCell *myCell;
	
	for (y=0; y<gridYsize; y++){
		
		NSString *rowString = @"";
		for (x= 0; x< gridXsize ; x++){
			
			myCell = [[cellGrid objectAtIndex:y] objectAtIndex:x];
			
			bool cellState = myCell.state;
			
			rowString = [rowString stringByAppendingFormat:@"%d",cellState];
			
		}
		NSLog(@"%@",rowString);
	}
	
}

- (void)zeroGrid{
	int x,y;
	GOLCell *myCell;
	
	for (y=0; y<gridYsize; y++){
		for (x=0; x<gridXsize; x++) {
			myCell = [[cellGrid objectAtIndex:y] objectAtIndex:x];
			
			myCell.state = 0;
		}
	}
}

- (void)fillGrid{
	int x,y;
	GOLCell *myCell;
	
	for (y=0; y<gridYsize; y++){
		for (x=0; x<gridXsize; x++) {
			myCell = [[cellGrid objectAtIndex:y] objectAtIndex:x];
			
			myCell.state = 1;
		}
	}
}

-(int)isSquare{
	int max;
	int isSquare = 0;
	
	if (gridXsize > gridYsize) {
		max = gridYsize ;
	}else {
		max = gridXsize ;
	}
	GOLCell *tmpCell = nil;
	GOLCell *topCell = nil;
	GOLCell *leftCell = nil;
	for (int i=max-1; i > 0; i--) {

		tmpCell = [[cellGrid objectAtIndex:i] objectAtIndex:i];
		if (i < (gridXsize-1)) {
			topCell = [[cellGrid objectAtIndex:0] objectAtIndex:i + 1];
		}else {
			topCell = nil;
		}
		if (i < (gridYsize -1)) {
			leftCell = [[cellGrid objectAtIndex:i+1] objectAtIndex:0];
		}
		if (tmpCell.state == 1){
			bool tc = 0;
			bool lc = 0;
		
			if (topCell) {
				if (topCell.state == 1) {
					tc = 1;
				}
			}
			if (leftCell) {
				if (leftCell.state ==1) {
					lc=1;
				}
			}
			if (!tc && !lc){
				isSquare = i;
			}
			break;
		}
	}
	return isSquare;
}

-(int)thinChomp{
	// returns 0 if not thin, 1 if x = 2, 2 if y = 2

	int thinChomp = 0;
	 
	GOLCell *endCell;
	GOLCell *startCell;
	
	startCell = [[cellGrid objectAtIndex:2] objectAtIndex:0];
	for (int i = gridXsize-1;i > 1;i--)
	{
		endCell = [[cellGrid objectAtIndex:1] objectAtIndex:i];
		if (endCell.state == 1 && startCell.state !=1) {
			thinChomp = 2;
		}
	}
	
	startCell = [[cellGrid objectAtIndex:0] objectAtIndex:2];
	for (int i = gridYsize - 1; i > 1; i--) {
			endCell = [[cellGrid objectAtIndex:i] objectAtIndex:1];

	
	if (endCell.state == 1 && startCell.state!=1) {
		thinChomp = 1;
		}
	}

return thinChomp;
}

-(int)farthestLeft:(int)row{
    int farthestLeft = 0;
	GOLCell *tmpCell;
	for (int i=0; i< gridYsize - 1; i++) {
		tmpCell = [[cellGrid objectAtIndex:i] objectAtIndex:row];
		if (tmpCell.state == 1){
			farthestLeft = i;
		}
	}
	return farthestLeft;
}


-(int)farthestDown:(int)col{
	int farthestDown = 0;
		GOLCell *tmpCell;
	for (int i=0; i< gridXsize - 1; i++) {
		tmpCell = [[cellGrid objectAtIndex:col] objectAtIndex:i];
		if (tmpCell.state == 1){
			farthestDown = i;
		}
	}
	return farthestDown;
}

-(CGPoint)getNextMove{

	CGPoint result;  // default is the losing move
	GOLCell *downCell;
	GOLCell *rightCell;
	
	downCell = [[cellGrid objectAtIndex:0] objectAtIndex:1];
	rightCell = [[cellGrid objectAtIndex:1] objectAtIndex:0];
	
	// endgame strategy
	if (downCell.state !=1 && rightCell.state ==1) {
		result = CGPointMake(0,1);
	}
	if (rightCell.state !=1 && downCell.state==1) {
		result = CGPointMake(1,0);
	}
	
	// random selection. 
	if (rightCell.state ==1 && downCell.state ==1) { 
		NSArray *tmpBoard = [NSArray arrayWithArray:[self serializeBoard]];
		bool flag = 0;
			while(!flag){
				int rnd = arc4random() % ([tmpBoard count]);
				int x,y;
				x = [[[tmpBoard objectAtIndex:rnd] objectAtIndex:1] intValue];
				y = [[[tmpBoard objectAtIndex:rnd] objectAtIndex:0] intValue];
				
				if (!(x == 1 && y ==0) && !(x==0 && y==1) && !(x ==0 && y ==0)) {
					result = CGPointMake(x, y);
					flag = YES;
				}else {
					if ([tmpBoard count] < 4 && !(x==0 && y==0)) {
						result = CGPointMake(x, y);
						flag = YES;
					}
				}

			}

	}
	// chomp a square grid at 1,1
	int sq = [self isSquare];
	if (sq > 0) {
		result = CGPointMake(1, 1);
	}
	
	// take m-1,n where n=2
	int c=[self thinChomp];
	if (c == 1) {
		result = CGPointMake(1, [self farthestLeft:1]);
	}
	if (c == 2) {
		result = CGPointMake([self farthestDown:1], 1);
	}
	
	// if we have chomped 1,1 - even the two arms
	GOLCell *corner = [[cellGrid objectAtIndex:1] objectAtIndex:1];
	
	if (corner.state !=1) {
		int l = [self farthestLeft:0];
		int d = [self farthestDown:0];
		
		if (l > d && d > 0){
			result = CGPointMake(0, d+1);
		}
		if (d > l && l > 0) {
			result = CGPointMake(l+1, 0);
		}

		
	}
	
	// shit. No other choice; chomp the poison.
	if(rightCell.state!=1 && downCell.state!=1) {
		result = CGPointMake(0, 0);
	}
	
	

	return result;
}

-(NSMutableArray *)serializeBoard{
	int x,y;
	GOLCell *myCell;	
	NSMutableArray *gridPoints = [NSMutableArray array];
	
	for (y=0; y<gridYsize;y++){
		for (x=0; x<gridXsize;x++ ) {
			myCell = [[cellGrid objectAtIndex:y] objectAtIndex:x];
		
			if (myCell.state == 1){
				NSArray *tmpArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:y],[NSNumber numberWithInt:x],nil];
				[gridPoints addObject:tmpArray];
			}
		}

	}

	return gridPoints;
}

-(void)loadGridFromFile:(NSString *)fileName local:(bool)local{

	[self zeroGrid];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path;
	
	if (local){
		path = [paths objectAtIndex:0];
	}
	else {
		path = [[NSBundle mainBundle] resourcePath]; 
	}
	
	NSString *dataPath = [path stringByAppendingPathComponent:fileName];
	
	NSMutableArray *gridPoints = [NSMutableArray arrayWithContentsOfFile:dataPath];
	
	int pointCount = [gridPoints count];
	int i;
	
	for (i = 0; i<pointCount; i++) {
		
		int x,y;
		
		y = [[[gridPoints objectAtIndex:i] objectAtIndex:0] intValue];
		x = [[[gridPoints objectAtIndex:i] objectAtIndex:1] intValue];
		
		[[[cellGrid objectAtIndex:y] objectAtIndex:x] setState:1];
		
	}
	
}

- (void)writeGridToFile:(NSString *)fileName{
	// get path to Documents folder
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	
	NSString *dataPath = [path stringByAppendingPathComponent:fileName];
	
	NSMutableArray *gridPoints = [NSMutableArray array];
	
	// walk grid and find "live" cells
	
	int x,y;
	GOLCell *myCell;
	
	for (y=0; y<gridYsize;y++){
		for (x=0; x<gridXsize;x++ ) {
			myCell = [[cellGrid objectAtIndex:y] objectAtIndex:x];
			
			if (myCell.state){
					
				NSArray *tmpArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:y],[NSNumber numberWithInt:x],nil];
				
				[gridPoints addObject:tmpArray];
			}
		}
		[gridPoints writeToFile:dataPath atomically:YES];
	}
	
	
}

-(void)dealloc{
	[cellGrid release];
	[super dealloc];
}

@end
