//
//  GOLCell.m
//  dgol
//
//  Created by Douglas Sartori on 10-09-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GOLCell.h"


@implementation GOLCell

@synthesize state, lastState,neighbours;

- (id)init{
	self = [super init];
	
	if (self){
	
		self.state = 0;
		neighbours = [[NSMutableArray alloc] init];
	}
	return self;
	
}

- (void)addNeighbour:(GOLCell *)neighbour{

	[neighbours addObject:neighbour];
}

- (int)countActiveNeighbours{
	
	int activeCount = 0;
	
	for (GOLCell *neighbour in neighbours){
	
		if (neighbour.state == 1){
			activeCount++;
		}
		

	}

	return activeCount;
}


- (bool)getNextState{
	bool nextState = self.state;
	
	int activeNeighbours = [self countActiveNeighbours];
	
	// rule 1: underpopulation
	if (self.state && activeNeighbours < 2)
	{
		nextState = 0;
	}
	
	// rule 2: overcrowding
	if (self.state && activeNeighbours > 3)
	{
		nextState = 0;
	}
	
	// rule 4: reproduction
	if (self.state == 0 && activeNeighbours == 3)
	{
		nextState = 1;
		
	}
	
	return nextState;
	
}



@end
