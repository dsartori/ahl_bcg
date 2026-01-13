    //
//  gameViewController.m
//  chocolateChomp
//
//  Created by Douglas Sartori on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "gameView.h"


#define kCellSize 40
@implementation gameView

@synthesize gameGrid, gameState, myCell, emptyCell,emptyCrumb,populatedCell,poisonCell, cellImageArray, cellButtonArray;
@synthesize buttonSize, wrapper, buttonHeight, xOffset,yOffset, turn, alert, chompID, cpu1,cpu2, cellRows,cellCols,cellSize, iPad;



- (id)initWithFrame:(CGRect)frame  {
	self = [super initWithFrame:frame];
	
		if (self){
		


		NSString *chompPath = [[NSBundle mainBundle] pathForResource:@"chomp" ofType:@"caf"];
		CFURLRef chompURL = (CFURLRef ) [NSURL fileURLWithPath:chompPath];
		AudioServicesCreateSystemSoundID (chompURL, &chompID);
		
		turn = 1;
		
		iPad = NO;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){  // iPad
			iPad = YES;
		}
		
		gameState = 1;
		
		cellImageArray =[[NSMutableArray alloc] init];
		cellButtonArray =[ [NSMutableArray alloc] init];
		
		emptyCell = [UIImage imageNamed:@"empty40.png"];
		emptyCrumb = [UIImage imageNamed:@"emptycrumb40.png"];
		populatedCell = [UIImage imageNamed:@"cell40.png"];
		poisonCell = [UIImage imageNamed:@"pcell40.png"];

		
		[populatedCell retain];
		[emptyCell retain];
		[poisonCell retain];
		[emptyCrumb retain];
		
		// NSLog(@"creating grid instance");
		
		
		if (iPad)
		{ 
			gameGrid = [[GOLGrid alloc] initWithGridX:10 Y:10];
			xOffset = 4;
			yOffset = 4;
			self.frame = CGRectMake(0, 300, 512, 468);
			cellRows = 10;
			cellCols = 8;

		}else{													   
			gameGrid = [[GOLGrid alloc] initWithGridX:8 Y:14];
			xOffset = 20;
			yOffset = 20;
		}
			

		int i,j,k;
		
		k=0;
		wrapper = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paper.png"]];
		wrapper.frame = CGRectMake(xOffset - 15, yOffset -15, (cellSize * gameGrid.gridYsize) +30 , (cellSize * gameGrid.gridXsize) + 30);
		[self addSubview:wrapper];

		
		for (i=0; i<gameGrid.gridXsize; i++){
			for (j=0; j<gameGrid.gridYsize; j++){
				
				// Set up the array of UIImageViews to hold cell images
				UIImageView *iv = [[UIImageView alloc] initWithImage:emptyCell];
				CGRect frame = iv.frame;
				frame.origin.x = (frame.size.width * j) + xOffset ;
				frame.origin.y = (frame.size.height * i) + yOffset ;
				iv.frame = frame;
				[self addSubview:iv];
				[cellImageArray addObject:iv];

				// Set up the array of UIButtons to take touch events
				UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom]; //custom
				b.frame = iv.frame;
							   
				// Set button's tag = array index
				b.tag = k;
				[b addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];			   
							   
				[self addSubview:b];
				[cellButtonArray addObject:b];



				k++;
				
				
			}
		}
		
		CGRect rootViewBounds = self.bounds;
		CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
		CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
		
		

		
		
		alert = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, rootViewHeight-20, 250, 20)];
		//alert.text = [NSString stringWithFormat:@"Player %i's turn",turn];
		alert.opaque = YES;
		alert.font=[UIFont fontWithName:@"AppleGothic" size:24.0];
		alert.backgroundColor = [UIColor clearColor];
		[self addSubview:alert];
		[self bringSubviewToFront:alert];
		
		// Draw initial state
		//UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"wood.jpg"]];
		//self.backgroundColor = background;
		//[background release];
		self.backgroundColor = [[UIColor alloc] initWithRed:227.0 / 255 green: 227.0 / 255 blue:227.0 / 255 alpha:1.0];
		
		//self.backgroundColor = [UIColor clearColor];
		[self resetGame];
		
		
		
		if (self.cpu1 && self.cpu2) {
			[self nextTurn];
		}
	}
	return self;
}

- (void)drawGrid{
	int k = 0;
	
	for (int rowIndex = 0; rowIndex < gameGrid.gridXsize ; rowIndex++) {
		for (int colIndex = 0; colIndex < gameGrid.gridYsize ; colIndex++) {
			
			
			myCell = [[gameGrid.cellGrid objectAtIndex:colIndex] objectAtIndex:rowIndex];
			

			int cellState = myCell.state;

			
				UIImageView *iv = [cellImageArray objectAtIndex:k];
				if (cellState==1){
					iv.image = populatedCell;
				}
				if (cellState==0){
					iv.image = emptyCell;
				}
				if (cellState==2) {
					iv.image = emptyCrumb;
				}
				if (rowIndex == 0 && colIndex == 0) {
					iv.image = poisonCell;
				}
			
			k++;
			

		}
	}
	
}


-(void)nextTurn{
	if (turn == 1) {
		turn = 2;
	}else {
		turn = 1;
	}

	NSString *alertText = [NSString stringWithFormat:@"Player %i's turn",turn];
	if (cpu1 && turn==1) {
		//
		CGPoint move = [gameGrid getNextMove];
		[self chompX:move.y Y:move.x];


		//NSLog(@"%@",NSStringFromCGPoint(move));
		gameState = 0;
		
		alertText = @"";
	}
	if (cpu2 && turn==2) {

		CGPoint move = [gameGrid getNextMove];
		[self chompX:move.y Y:move.x];

		//NSLog(@"%@",NSStringFromCGPoint(move));
		gameState = 0;
		
		alertText = @"";
	}
	
	alert.text = alertText;

}

- (void)gameLoop{
	if (gameState == 0){
		gameState = 1;
		[self drawGrid];
		[self nextTurn];
	}
}

- (void)cellButtonPressed:(id)sender{
	UIButton* button = sender;
	int x,y;
	x = (button.frame.origin.x - xOffset) / cellSize;
	y = (button.frame.origin.y - yOffset) / cellSize;

	GOLCell *tmpCell = [[gameGrid.cellGrid objectAtIndex:x] objectAtIndex:y];
	int cellState = tmpCell.state;


	
	if (gameState){
		if (cellState == 1){
			
			[self chompX:x Y:y];
			gameState = 0;
			
			}

		}

}

-(void)chompX:(int)x Y:(int)y{

	AudioServicesPlaySystemSound (chompID);
	
	
	
	GOLCell *tmpCell = [[gameGrid.cellGrid objectAtIndex:x] objectAtIndex:y];
	if (x == 0 && y == 0) {
		[myTimer invalidate];
		myTimer = nil;
		UIAlertView *gameover = [[UIAlertView alloc] initWithTitle:@"GAME OVER" message:[NSString stringWithFormat:@"Player %i ate the poison piece",turn] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[gameover show];
		[gameover release];


			
	}else {
		for (int i = x; i<gameGrid.gridYsize;i++) {
			for (int j = y; j < gameGrid.gridXsize; j++) {
			tmpCell = [[gameGrid.cellGrid objectAtIndex:i] objectAtIndex:j];
			
			if (tmpCell.state == 1) {
				[tmpCell setState:0];
			}
			if (i == x && j ==y) {
				[tmpCell setState:2];
			}
			}
		}
	}
	
	[self drawGrid];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex{

		if (!iPad){
			[self removeFromSuperview];
		}
		gameState = 0;
		[self drawGrid];
}

-(void)sizeCells{
		CGRect rootViewBounds = self.bounds;
		CGFloat ySize = CGRectGetHeight(rootViewBounds);
		CGFloat xSize = CGRectGetWidth(rootViewBounds);
		
		int w = (xSize / gameGrid.gridYsize);
		int h = ((ySize - alert.frame.size.height- 20) / gameGrid.gridXsize) ;		
			
		int s;
			
		if (w > h){
			s = h;
		}
		else{
			s = w;
		}
		
		cellSize = s;
		
		xOffset = (self.frame.size.width - (gameGrid.gridYsize * cellSize))/2;
		yOffset = (self.frame.size.height - alert.frame.size.height - (gameGrid.gridXsize * cellSize))/2;
		
		
		NSLog(@"yoffset %i root view bounds %@",yOffset,NSStringFromCGRect(rootViewBounds));
		
		wrapper.frame = CGRectMake(xOffset - 15, yOffset -15, (cellSize * gameGrid.gridYsize) +30 , (cellSize * gameGrid.gridXsize) + 30);
		
		int i,j,k = 0;
		// relocate cell images & buttons to match new bar size
		//NSLog(@"---");
		for (i=0; i<gameGrid.gridXsize; i++){
			for (j=0; j<gameGrid.gridYsize; j++){
			
			UIImageView *iv = [cellImageArray objectAtIndex:k];
			CGRect frame = iv.frame;


			
			frame.size.width = cellSize;
			frame.size.height =cellSize;			
			
			frame.origin.x = (frame.size.width * j) + xOffset ;
			frame.origin.y = (frame.size.height * i) + yOffset ;
			

			iv.frame = frame; 
			

			// Set up the array of UIButtons to take touch events
			
			
			UIButton *b = [cellButtonArray objectAtIndex:k];			
			b.frame = iv.frame;
			// Set button's tag = array index
			b.tag = k;


			k++;
			
			
			}
		}
		
		for (i = k; i < [cellImageArray count]; i++) {  
				UIButton *b = [cellButtonArray objectAtIndex:i];
				UIImageView *iv = [cellImageArray objectAtIndex:i];
				
				b.frame = CGRectMake(-100, -100, kCellSize, kCellSize);
				iv.frame = b.frame;
				b.tag = i;
		}
		
	// reposition alert
		
	alert.frame = CGRectMake(0, ySize-60, 250, 60);
}

-(void)resetGame{
		if (myTimer != nil) {
			[myTimer invalidate];
			myTimer = nil;
		}


		[gameGrid zeroGrid];
		gameGrid.gridXsize = cellRows;
		gameGrid.gridYsize = cellCols;
		[gameGrid fillGrid];
		self.gameState = 1;
		self.turn =0;

	
		[self sizeCells];
		
		[self drawGrid];
		[self nextTurn];
		myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
		target:self
		selector:@selector(gameLoop)
		userInfo:nil
		repeats:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
		return YES;
	}else {
		return NO;
	}

}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
