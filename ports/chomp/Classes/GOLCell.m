//
//  GOLCell.m
//  dgol
//
//  Created by Douglas Sartori on 10-09-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GOLCell.h"


@implementation GOLCell

@synthesize state;

- (id)init{
	self = [super init];
	
	if (self){
	
		self.state = 1;
		}
	return self;
	
}




@end
