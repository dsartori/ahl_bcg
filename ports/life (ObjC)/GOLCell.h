//
//  GOLCell.h
//  dgol
//
//  Created by Douglas Sartori on 10-09-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GOLCell : NSObject {

	bool state, lastState;
	NSMutableArray *neighbours;
	
}

@property (readwrite,assign) bool state, lastState;
@property (readwrite,assign) NSMutableArray *neighbours;

- (int)countActiveNeighbours;
- (bool)getNextState;
- (void)addNeighbour:(GOLCell *) neighbour;

@end
