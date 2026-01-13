//
//  helpView.m
//  simplelife
//
//  Created by Douglas Sartori on 11-09-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "helpView.h"

@implementation helpView

@synthesize helpWeb;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        helpWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height )];
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];		
		[helpWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        
        
		self.backgroundColor = [[UIColor alloc] initWithRed:0.0 / 255 green: 0.0 / 255 blue:0.0 / 255 alpha:0.5];
		helpWeb.backgroundColor = [UIColor clearColor];
		helpWeb.opaque=NO;
        
        
		helpWeb.delegate = self;
		[self addSubview:helpWeb];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
