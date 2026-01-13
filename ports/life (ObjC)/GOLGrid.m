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

@synthesize gridXsize, gridYsize, cellGrid, nextGrid, gridWraps;

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
		nextGrid = [[NSMutableArray alloc] initWithArray:nxtGrid copyItems:YES];

		liveCellsAndNeighbours = [[NSMutableArray alloc] init];

		
		// repeat now that we have instantiated and ID neighbours

		int i,j,k,l = 0;
		
		for (i = 0;  i< gridYsize; i++){
			
			for ( j = 0 ;  j<gridXsize; j++){
			 
			// The cell will have 8 neighbours.  Grid wraps
			 
				for ( k = -1; k < 2; k++){
					for ( l = -1;l < 2; l++){
						if (k != 0 || l !=0){
							
							int nY = i+k;
							
							if (nY > (gridYsize -1)){
								nY=0;
							}
							if (nY < 0){
								nY=(gridYsize - 1);
							}
							
							int nX = j+l;
							if (nX > (gridXsize -1)){
								nX=0;
							}
							if (nX < 0){
								nX=(gridXsize -1);
							}
							
							[[[cellGrid objectAtIndex:i] objectAtIndex:j] addNeighbour:[[cellGrid objectAtIndex:nY] objectAtIndex:nX]];

						}																	 
					}
				}
			}
		}

	}
	
    gridWraps = YES;
	return self;
}

-(void)nextStep{
	
	bool tmpState;
	GOLCell *myCell;
	GOLCell *currCell;

	int i,j = 0;

	
	
	
	// walk grid and set "next state" based on current neighbours
	for (i = 0; i < gridYsize; i++){
		for (j = 0; j<gridXsize; j++){
			
			myCell = [[nextGrid objectAtIndex:i] objectAtIndex:j];
			
			if ([liveCellsAndNeighbours containsObject:[[cellGrid objectAtIndex:i] objectAtIndex:j]] || ([liveCellsAndNeighbours count] < 1) ){
				tmpState = [[[cellGrid objectAtIndex:i] objectAtIndex:j] getNextState];
				[myCell setState:tmpState];
			}
		}
	}
	
	// clear the array of cells we need to check 
	[liveCellsAndNeighbours removeAllObjects];
	
	// walk grid and set state based on "next state"
	for (i = 0; i < gridYsize; i++){
		for (j = 0; j<gridXsize; j++){
			
			currCell = [[cellGrid objectAtIndex:i] objectAtIndex:j];
        
			
			
			// set current cell to next state
			myCell = [[nextGrid objectAtIndex:i] objectAtIndex:j];
			tmpState = myCell.state;
			
			[[[cellGrid objectAtIndex:i] objectAtIndex:j] setState:tmpState];
			
			if (tmpState == 1){
				myCell = [[cellGrid objectAtIndex:i] objectAtIndex:j];
				
				for (GOLCell *neighbour in myCell.neighbours)
				{
					if (![liveCellsAndNeighbours containsObject:neighbour]){
						[liveCellsAndNeighbours addObject:neighbour];
					}
				}
				[liveCellsAndNeighbours addObject:myCell];
			}
			
			
		}
	}	
	
	//int cc = [liveCellsAndNeighbours count];
	//NSLog(@"%d",cc);
}

- (void) clearCellCache{
	[liveCellsAndNeighbours removeAllObjects];
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

- (void)logNeighbours{
	
	int x,y;
	GOLCell *myCell;
	
	for (y=0; y<gridYsize; y++){
		
		NSString *rowString = @"";
		for (x= 0; x< gridXsize ; x++){
			
			myCell = [[cellGrid objectAtIndex:y] objectAtIndex:x];
			
			int cellNeighbours = myCell.countActiveNeighbours;
			
			rowString = [rowString stringByAppendingFormat:@"%d",cellNeighbours];
			
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
	[liveCellsAndNeighbours removeAllObjects];
}



- (void)randomizeGrid:(int)population{

	[self zeroGrid];
	int x,y;
	
	for (int i = 0; i<population; i++){
	
		x = arc4random() % (gridXsize );
		y = arc4random() % (gridYsize );
	

		[[[cellGrid objectAtIndex:y] objectAtIndex: x] setState:1];
	
	}
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
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dataPath];
    
    if (fileExists) {
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
