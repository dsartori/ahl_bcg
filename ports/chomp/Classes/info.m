//
//  info.m
//  chocolateChomp
//
//  Created by Douglas Sartori on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "info.h"


@implementation info

@synthesize infoWeb,OK;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        infoWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height - 40)];
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];		
		[infoWeb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
		
		OK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		OK.frame = CGRectMake(400, frame.size.height - 40, 80, 40);
		[OK setTitle:@"OK" forState:UIControlStateNormal];
		[OK addTarget:self action:@selector(OKPressed) forControlEvents:UIControlEventTouchUpInside];
		/*UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"instructionpaper.jpg"]];
		self.backgroundColor = background;
		[background release];
		*/

		self.backgroundColor = [[UIColor alloc] initWithRed:227.0 / 255 green: 227.0 / 255 blue:227.0 / 255 alpha:1.0];
		infoWeb.backgroundColor = [UIColor clearColor];
		infoWeb.opaque=NO;


		
		[self addSubview:infoWeb];
		[self addSubview:OK];
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}

-(void)OKPressed{
	self.hidden = YES;
}

@end
