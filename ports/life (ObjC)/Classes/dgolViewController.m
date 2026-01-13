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
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@implementation dgolViewController

@synthesize gameGrid, gameState, myCell;
@synthesize  fullspeed, speedcounter;
@synthesize lastLocal;



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

    lastScale = 1.0;
	iPad = NO;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){  // iPad
		iPad = YES;
	}
    [super viewDidLoad];
	
	gridView.gameState = 0;
	speedcounter = 0;
    int offset = 0;
    lastScale = 1.0;
    
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pgr.delegate = self;
    
    
	
	//cellImageArray =[[NSMutableArray alloc] init];
    //cellButtonArray =[ [NSMutableArray alloc] init];

	
	// NSLog(@"creating grid instance");
	
    
    if (iPad)
	{ 
		//gameGrid = [[GOLGrid alloc] initWithGridX:38 Y:49];
		offset = 4;

		
	}else{
        
        if(IS_WIDESCREEN){
        //    gameGrid = [[GOLGrid alloc] initWithGridX:16 Y:26];
        }else{
        //    gameGrid = [[GOLGrid alloc] initWithGridX:16 Y:22];

        }
        offset = 0;
	}
    
    gameGrid = [[GOLGrid alloc] initWithGridX:120 Y:120];
	
    gridView = [[GridView alloc] initWithFrame:self.view.frame];
    [gridView setMultipleTouchEnabled:YES];
    gridView.gameGrid = gameGrid;
    gridView.offset = offset;
    gridView.cellHeight = 20;
    gridView.cellWidth = 20;
    gridView.viewPortOrigin = CGPointMake(0,0);
    if (iPad)
	{
		gridView.viewPortSize=CGPointMake(38,49);
        gridView.graphZoomLevels = [[NSArray alloc] initWithArray:@[@[@76,@100],@[@57,@73],@[@38,@49],@[@28,@36],@[@19,@25]]];
    }else{
        if(IS_WIDESCREEN){
            gridView.viewPortSize=CGPointMake(16,26);
            gridView.graphZoomLevels = [[NSArray alloc] initWithArray:@[@[@32,@52],@[@24,@39],@[@16,@26],@[@12,@19],@[@8,@13]]];
        }else{
            gridView.viewPortSize=CGPointMake(16,22);
            gridView.graphZoomLevels = [[NSArray alloc] initWithArray:@[@[@32,@44],@[@24,@33],@[@16,@22],@[@12,@16],@[@8,@11]]];
        }
	}

    [gridView addGestureRecognizer:pgr];
    [pgr release];

	//int i,j,k;
	
	//k=0;
	
    gridChoices = [[NSMutableArray alloc] init];
    
    [gridChoices addObject:@"Blank Grid"];
    [gridChoices addObject:@"Baker"];
    [gridChoices addObject:@"Bun"];
    [gridChoices addObject:@"Clock"];
    [gridChoices addObject:@"Eater 1"];
    [gridChoices addObject:@"f Pentomino"];
    if (iPad) {
        [gridChoices addObject:@"Gosper Glider Gun"];
    }
    [gridChoices addObject:@"Pentadecathlon"];
    [gridChoices addObject:@"Phoenix"];
    if (iPad){

        [gridChoices addObject:@"Pulsar"];
    }
    [gridChoices addObject:@"Quadpole"];
    if (iPad){
        
        [gridChoices addObject:@"Schick Engine"];
    }
    [gridChoices addObject:@"Spaceship"];
    [gridChoices addObject:@"Tumbler"];
    if (iPad){
        
        [gridChoices addObject:@"Weekender"];
    }
    
    gridPicker = [[UIPickerView alloc] init];
    gridPicker.dataSource = self;
    gridPicker.delegate = self;
    gridPicker.showsSelectionIndicator = YES;
	gridPicker.hidden = YES;
	
    

    toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlack;
    [toolbar sizeToFit];
    CGFloat toolbarHeight = [toolbar frame].size.height-5;
    if (IS_WIDESCREEN){
        toolbarHeight = [toolbar frame].size.height+5;
    }
    CGRect rootViewBounds = self.view.bounds;
    CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
    CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
    
    CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
    [toolbar setFrame:rectArea];
	
	
	UIImage *startIcon = [UIImage imageNamed:@"play.png"];
	UIImage *fwdIcon = [UIImage imageNamed:@"fastforward.png"];
	UIImage *stepIcon = [UIImage imageNamed:@"step.png"];
	UIImage *resetIcon = [UIImage imageNamed:@"rewindtostart.png"];
	UIImage *loadIcon = [UIImage imageNamed:@"folder.png"];
	UIImage *pauseIcon = [UIImage imageNamed:@"pause.png"];
    UIImage *helpIcon = [UIImage imageNamed:@"info.png"];
    UIImage *gridIcon = [UIImage imageNamed:@"refresh.png"];
	
    
    startButton =[[UIBarButtonItem alloc] initWithImage:startIcon style:UIBarButtonItemStylePlain target:self action:@selector(startButtonPressed:)];
	pauseButton =[[UIBarButtonItem alloc] initWithImage:pauseIcon style:UIBarButtonItemStylePlain target:self action:@selector(pauseButtonPressed)];
    fwdButton = [[UIBarButtonItem alloc] initWithImage:fwdIcon style:UIBarButtonItemStylePlain target:self action:@selector(fwdButtonPressed:)];
    stepButton = [[UIBarButtonItem alloc] initWithImage:stepIcon style:UIBarButtonItemStylePlain target:self action:@selector(stepButtonPressed)];
    resetButton = [[UIBarButtonItem alloc] initWithImage:resetIcon style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonPressed)];

    gridButton = [[UIBarButtonItem alloc] initWithImage:gridIcon style:UIBarButtonItemStylePlain target:self action:@selector(gridButtonPressed)];
	loadButton = [[UIBarButtonItem alloc] initWithImage:loadIcon style:UIBarButtonItemStylePlain target:self action:@selector(actionButtonPressed)];

    helpButton = [[UIBarButtonItem alloc] initWithImage:helpIcon style:
                  UIBarButtonItemStylePlain target:self action:@selector(helpButtonPressed)];
    
    spacer =	[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil ];                                                                                                                                                
                                                                                                                                            
							
	int buttonWidth = 30;
    if (iPad) {
        buttonWidth = 44;
    }

	startButton.width = buttonWidth;
	pauseButton.width = buttonWidth;
	fwdButton.width = buttonWidth;
	stepButton.width = buttonWidth;
	resetButton.width = buttonWidth;
    helpButton.width = buttonWidth;
    gridButton.width = buttonWidth;
    
	loadButton.width = buttonWidth;
    if (iPad) {
		[toolbar setItems:[NSArray arrayWithObjects:resetButton,pauseButton,startButton,stepButton,fwdButton,spacer,gridButton,loadButton,nil]];
    }else{
        [toolbar setItems:[NSArray arrayWithObjects:resetButton,pauseButton,startButton,stepButton,fwdButton,spacer,gridButton,loadButton,nil]];
    }
	
    [self.view addSubview:gridView];
    [self.view addSubview:toolbar];
    pauseButton.enabled = NO;
    fwdButton.enabled = NO;

    // add help view
    
    CGRect helpFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-39);
    help = [[helpView alloc] initWithFrame:helpFrame];
    [self.view addSubview:help];
    help.hidden = YES;
    //
    
    NSMutableString *gridTitle = [NSMutableString stringWithString:@"Select Starting Pattern\n\n\n\n\n\n\n\n\n"];
    
    if (iPad) {
        [gridTitle setString:@"          Select Starting Pattern\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"];
    }
    
    gridSheet = [[UIActionSheet alloc]
                 initWithTitle:gridTitle
                 delegate:nil
                 cancelButtonTitle:nil
                 destructiveButtonTitle:nil
                 otherButtonTitles: nil];
    gridSheet.actionSheetStyle = UIActionSheetStyleDefault;
    gridSheet.frame = CGRectMake(0, 0, 220, 216);
    [gridSheet addSubview:gridPicker];
    
    closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (iPad){
        closeButton.frame = CGRectMake(200,235,80.0f,44.0f);
    }else {
        closeButton.frame = CGRectMake(215,215,80.0f,44.0f);
    }
    [closeButton setTitle:@"Reset" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [[closeButton layer] setCornerRadius:8.0f];
    [[closeButton layer] setMasksToBounds:YES];
    [[closeButton layer] setBorderWidth:2.0f];
    [[closeButton layer] setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [gridSheet addSubview:closeButton];
	
    if (!iPad) {
        cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelButton.frame = CGRectMake(25, 215, 80.0f, 44.0f);
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [[cancelButton layer] setCornerRadius:8.0f];
        [[cancelButton layer] setMasksToBounds:YES];
        [[cancelButton layer] setBorderWidth:2.0f];
        [[cancelButton layer] setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        [gridSheet addSubview:cancelButton];
    }

    lastfile = [[NSMutableString alloc] initWithString:@""];
	[self loadInitialState];
	
	// Draw initial state
	[gridView setNeedsDisplay];


	[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];

	
}

- (void)helpButtonPressed{
    if (help.hidden) {
        [self.view bringSubviewToFront:help];
        help.hidden = NO;
    }else
    {
        [self.view sendSubviewToBack:help];
        help.hidden = YES;
    }
    
}


-(void)dismissActionSheet:(id) sender{
    [gridSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    NSMutableString *suffix = [NSMutableString stringWithString:@""];
    if (iPad) {
        [suffix setString:@"-ipad"];
    }
    NSString *fileName=[NSString stringWithFormat:@"%@%@.plist",[gridChoices objectAtIndex:[gridPicker selectedRowInComponent:0]],suffix];
    
    //@"r-pentomino.plist" ;
    [gameGrid loadGridFromFile:fileName local:NO];
    [lastfile setString:fileName];
    lastLocal = 0;
    
	[gridView setNeedsDisplay];
    
}

-(void)cancelActionSheet:(id)sender{
    [gridSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)loadInitialState{
    
    if (iPad)
	{ 
		
		NSString *fileName=@"Gosper Glider Gun-ipad.plist";
		
        [gameGrid loadGridFromFile:fileName local:NO];
		[lastfile setString:fileName];
		lastLocal = 0;
		
	}else{				
		
		NSString *fileName=@"f Pentomino.plist" ;
        [gameGrid loadGridFromFile:fileName local:NO];
		[lastfile setString:fileName];
		lastLocal = 0;
	}
}

-(void)pauseButtonPressed{
	

	gridView.gameState = 0;
	stepButton.enabled = YES;
	resetButton.enabled = YES;
	saveButton.enabled = YES;
	loadButton.enabled = YES;
	clearButton.enabled = YES;
	startButton.enabled = YES;
    gridButton.enabled = YES;
    helpButton.enabled = YES;
	pauseButton.enabled = NO;
	fwdButton.enabled = NO;
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];

}

- (void)startButtonPressed:(id)sender{
	gridView.gameState = 1;
	stepButton.enabled = NO;
	resetButton.enabled = NO;
	clearButton.enabled = NO;
	loadButton.enabled = NO;
	saveButton.enabled = NO;
	startButton.enabled = NO;
    gridButton.enabled = NO;
    helpButton.enabled = NO;
	pauseButton.enabled = YES;
	fwdButton.enabled = YES;
	fullspeed = 0; // set normal speed
	
	// disable display sleep while running
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES]; 
}



- (void)fwdButtonPressed:(id)sender{
	fullspeed = 1;
	pauseButton.enabled = YES;
	startButton.enabled = YES;
	fwdButton.enabled = NO;
}


- (void)resetButtonPressed{
	gridView.gameState = 0;
	
	[gameGrid loadGridFromFile:lastfile local:lastLocal];

	
    
	[gridView setNeedsDisplay];
}

- (void)stepButtonPressed{
	gridView.gameState = 2;
}

- (void)actionButtonPressed{

	UIActionSheet *fileActions = [[UIActionSheet alloc]
								  initWithTitle:nil
								  delegate:self 
								  cancelButtonTitle:@"Cancel" 
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Save Current State",@"Load Saved State",nil];
	
	fileActions.actionSheetStyle = UIActionSheetStyleDefault;
	[fileActions showInView:self.view];
	[fileActions release];
	
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

	if (buttonIndex == 0) {
		[self saveButtonPressed];
	}
	if (buttonIndex == 1) {
		[self loadButtonPressed];
	}
//	if (buttonIndex == 0) {
//		[self clearButtonPressed];
//	}
    
}

- (void)loadButtonPressed{
	
	gridView.gameState = 0;
	[gameGrid loadGridFromFile:@"user.plist" local:YES];
	lastLocal = YES;
	[lastfile setString:@"user.plist"];
    
	[gridView setNeedsDisplay];
	
}

-(void)gridButtonPressed{
    gridView.gameState = 0;

    gridPicker.hidden = NO;
    [gridSheet showInView:self.view];
    if(iPad){
        
        [gridSheet setBounds:CGRectMake(0, 0, 320, 300)];
        CGRect pickerFrame = CGRectMake(40, 30, 240, 180);
        gridPicker.frame = pickerFrame;
        
    }else
    {
        [gridSheet setBounds:CGRectMake(0, 0, 320, 345)];
        CGRect pickerFrame = CGRectMake(25, 30, 270, 180);
        gridPicker.frame = pickerFrame;
        
    }
    
    //[self loadInitialState];
    
	[gridView setNeedsDisplay];
}

- (void)saveButtonPressed{
	gridView.gameState = 0;
	[gameGrid writeGridToFile:@"user.plist"];
	lastLocal = YES;
	[lastfile setString:@"user.plist"];
}
- (void)clearButtonPressed{
	gridView.gameState = 0;
	[gameGrid zeroGrid];
	//lastLocal = NO;
	//lastFile = @"empty.plist";
    
	[gridView setNeedsDisplay];
}



- (void)gameLoop{

	if (gridView.gameState){
		
		if (fullspeed || speedcounter > 5){ // delay loop
		
			speedcounter = 0;
			[gameGrid nextStep];
            [gridView setNeedsDisplay ];
			//[self drawGrid];
		
		
			// Handle "step" state
			if (gridView.gameState == 2){
				gridView.gameState = 0;
			}
		}
		speedcounter++;
        
        //[gridView setUserInteractionEnabled:FALSE];
	}else{
       //[gridView setUserInteractionEnabled:TRUE];
    }
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    CGFloat factor = [(UIPinchGestureRecognizer *)pinchGestureRecognizer scale];
    
        
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded){
        lastScale = 1.0;
    }
    
    
    if (factor < lastScale)
        [gridView decreaseZoomLevel];
    
    if (factor > lastScale)
        [gridView increaseZoomLevel];
        
    lastScale = factor;
    
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	
	if (iPad) {
		if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
			return YES;
		}

	}
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [gridChoices count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [gridChoices objectAtIndex:row];
}

- (void)dealloc {
    [super dealloc];
}

@end
