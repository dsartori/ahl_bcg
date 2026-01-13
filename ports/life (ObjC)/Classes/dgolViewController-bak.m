//
//  dgolViewController.m
//  dgol
//
//  Created by Douglas Sartori on 10-09-04.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "dgolViewController.h"
#import "GOLCell.h"
#import "GOLGrid.h"

#define kCellSize 20
#define kRandomCells 40
@implementation dgolViewController

@synthesize gameGrid, gameState, myCell, emptyCell,populatedCell, cellImageArray, cellButtonArray, buttonSize, buttonHeight, offset, fullspeed, speedcounter;


/*

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization

    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	

	

}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	gameState = 0;
	speedcounter = 0;
	
	cellImageArray =[[NSMutableArray alloc] init];
    cellButtonArray =[ [NSMutableArray alloc] init];
	
	emptyCell = [UIImage imageNamed:@"empty20.png"];
	populatedCell = [UIImage imageNamed:@"cell20.png"];
	
	[populatedCell retain];
	[emptyCell retain];
	
	NSLog(@"creating grid instance");
	
	UIFont *btfont;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)  // iPad
	{ 
		gameGrid = [[GOLGrid alloc] initWithGridX:38 Y:48];
		buttonSize = 153;
		buttonHeight = 58;
		offset = 4;
		
		btfont = [UIFont fontWithName:@"Helvetica" size:20.0];
		[gameGrid randomizeGrid:kRandomCells * 4];
	}else{													   // iPhone
		gameGrid = [[GOLGrid alloc] initWithGridX:16 Y:21];
		buttonSize = 64;
		buttonHeight = 50;
		offset = 0;
		
		btfont = [UIFont fontWithName:@"Helvetica" size:14.0];
		[gameGrid randomizeGrid:kRandomCells];
	}
		

	
	int i,j,k;
	
	k=0;
	
	
	
	for (i=0; i<gameGrid.gridYsize; i++){
		for (j=0; j<gameGrid.gridXsize; j++){
			
			// Set up the array of UIImageViews to hold cell images
			UIImageView *iv = [[UIImageView alloc] initWithImage:emptyCell];
			CGRect frame = iv.frame;
			frame.origin.x = (frame.size.width * j) + offset ;
			frame.origin.y = (frame.size.height * i) + offset ;
			iv.frame = frame;
			[self.view addSubview:iv];
			[cellImageArray addObject:iv];

			// Set up the array of UIButtons to take touch events
			UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
			b.frame = iv.frame;
						   
			// Set button's tag = array index
			b.tag = k;
			[b addTarget:self action:@selector(cellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];			   
						   
			[self.view addSubview:b];
			[cellButtonArray addObject:b];

			k++;
			 
		}
	}
	


	
	// Start button UIBarButtonSystemItemPlay / Pause
	UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
	startButton.frame = CGRectMake(0, (gameGrid.gridYsize * kCellSize)+5, buttonSize, buttonHeight);
	startButton.titleLabel.font = btfont;
	[[startButton layer] setCornerRadius:4.0f];
	[[startButton layer] setMasksToBounds:YES];
	[[startButton layer] setBorderWidth:2.0f];
	[[startButton layer] setBackgroundColor:[[UIColor grayColor] CGColor]];
	[startButton setTitle:@"Start/Stop" forState:UIControlStateNormal];
	[startButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:startButton];
	
	// Fwd button UIBarButtonSystemItemFastForward
	UIButton *fwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
	fwdButton.frame = CGRectMake(buttonSize, (gameGrid.gridYsize * kCellSize)+5, buttonSize, buttonHeight);
	fwdButton.titleLabel.font = btfont;
	[[fwdButton layer] setCornerRadius:4.0f];
	[[fwdButton layer] setMasksToBounds:YES];
	[[fwdButton layer] setBorderWidth:2.0f];
	[[fwdButton layer] setBackgroundColor:[[UIColor grayColor] CGColor]];
	[fwdButton setTitle:@"Fast/Slow" forState:UIControlStateNormal];
	[fwdButton addTarget:self action:@selector(fwdButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:fwdButton];

	// Step Button 
	UIButton *stepButton = [UIButton buttonWithType:UIButtonTypeCustom];
	stepButton.frame = CGRectMake(buttonSize*2, (gameGrid.gridYsize * kCellSize)+5, buttonSize, buttonHeight);
	stepButton.titleLabel.font = btfont;
	[[stepButton layer] setCornerRadius:4.0f];
	[[stepButton layer] setMasksToBounds:YES];
	[[stepButton layer] setBorderWidth:2.0f];
	[[stepButton layer] setBackgroundColor:[[UIColor grayColor] CGColor]];
	[stepButton setTitle:@"Step" forState:UIControlStateNormal];
	[stepButton addTarget:self action:@selector(stepButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:stepButton];
	
	// Reset Button 
	UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
	resetButton.frame = CGRectMake(buttonSize * 3, (gameGrid.gridYsize * kCellSize)+5, buttonSize, buttonHeight);
	resetButton.titleLabel.font = btfont;
	[[resetButton layer] setCornerRadius:4.0f];
	[[resetButton layer] setMasksToBounds:YES];
	[[resetButton layer] setBorderWidth:2.0f];
	[[resetButton layer] setBackgroundColor:[[UIColor grayColor] CGColor]];
	[stepButton setTitle:@"Step" forState:UIControlStateNormal];
	[resetButton setTitle:@"Random" forState:UIControlStateNormal];
	[resetButton addTarget:self action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:resetButton];

	// Clear Button
	UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
	clearButton.frame = CGRectMake(buttonSize * 4, (gameGrid.gridYsize * kCellSize)+5, buttonSize, buttonHeight);
	clearButton.titleLabel.font = btfont;
	[[clearButton layer] setCornerRadius:4.0f];
	[[clearButton layer] setMasksToBounds:YES];
	[[clearButton layer] setBorderWidth:2.0f];
	[[clearButton layer] setBackgroundColor:[[UIColor grayColor] CGColor]];
	[clearButton setTitle:@"Clear" forState:UIControlStateNormal];
	[clearButton addTarget:self action:@selector(clearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	[self.view addSubview:clearButton];
	

	
	
	// Draw initial state
	[self drawGrid];


	[NSTimer scheduledTimerWithTimeInterval:0.125 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];

	
}

			

- (void)cellButtonPressed:(id)sender{
	UIButton* button = sender;
	int x,y;
	x = (button.frame.origin.x - offset) / kCellSize;
	y = (button.frame.origin.y - offset) / kCellSize;
	
	GOLCell *tmpCell = [[gameGrid.cellGrid objectAtIndex:y] objectAtIndex:x];

	bool cellState = tmpCell.state;
	
	
	if (!gameState){
		if (cellState){
			[tmpCell setState:0];
		}else {
			[tmpCell setState:1];
		}
	[self drawGrid];
	}
}

						   
- (void)startButtonPressed:(id)sender{
	if (gameState == 1){
		gameState = 0;
	}else {
		gameState = 1;
	}

}

- (void)fwdButtonPressed:(id)sender{
	if (fullspeed){
		fullspeed = 0;
	}else{
		fullspeed = 1;
	}
}


- (void)resetButtonPressed{
	gameState = 0;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [gameGrid randomizeGrid:(kRandomCells * 4)];
	}else {
		[gameGrid randomizeGrid:kRandomCells];
	}

	[self drawGrid];
}

- (void)stepButtonPressed{
	gameState = 2;
	//[gameGrid logNeighbours];
	//NSLog(@"--------------------");
}

- (void)clearButtonPressed{
	gameState = 0;
	[gameGrid zeroGrid];
	[self drawGrid];
}

- (void)drawGrid{
	int k = 0;
	
	for (int rowIndex = 0; rowIndex < gameGrid.gridYsize ; rowIndex++) {
		for (int colIndex = 0; colIndex < gameGrid.gridXsize ; colIndex++) {
			;
			
			myCell = [[gameGrid.cellGrid objectAtIndex:rowIndex] objectAtIndex:colIndex];
			
			UIImageView *iv = [cellImageArray objectAtIndex:k];
			bool cellState = myCell.state;
			
			

			if (cellState){
				iv.image = populatedCell;
			}
			else {
				iv.image = emptyCell;
			}
	
			k++;
			

		}
	}
}

- (void)gameLoop{

	if (gameState){
		
		if (fullspeed || speedcounter > 4){
		
			speedcounter = 0;
			[gameGrid nextStep];
			[self drawGrid];
		
		
			// Handle "step" state
			if (gameState == 2){
				gameState = 0;
			}
		}
		speedcounter++;
	}	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
