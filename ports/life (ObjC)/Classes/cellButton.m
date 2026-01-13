//
//  cellButton.m
//  simplelife
//
//  Created by Douglas Sartori on 11-09-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cellButton.h"

@implementation cellButton

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
   return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event]; 
}

@end
