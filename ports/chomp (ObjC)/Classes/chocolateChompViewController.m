//
//  chocolateChompViewController.m
//  chocolateChomp
//
//  Created by Douglas Sartori on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "chocolateChompViewController.h"

@implementation chocolateChompViewController
@synthesize iPadLandscape,iPadFullscreen; gameVC,cpu1,cpu2, infoView, barX,barY,rowChoices,colChoices,sizePicker,p1CPU,p2CPU,infoButton,start1P,p1,p2;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
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
	
	/*
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"wood.jpg"]];
	self.view.backgroundColor = background;
	[background release];
	*/
	self.view.backgroundColor = [[UIColor alloc] initWithRed:227.0 / 255 green: 227.0 / 255 blue:227.0 / 255 alpha:1.0];

	rowChoices = [[NSMutableArray alloc] init];
	colChoices = [[NSMutableArray alloc] init];
	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 250, 60)];
	title.text = @"Chocolate Chomp!";
	title.opaque = NO;
	title.font=[UIFont fontWithName:@"AppleGothic" size:24.0];
	title.backgroundColor = [UIColor clearColor];
	self.cpu1 = NO;
	self.cpu2 = NO;
	
	start1P = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	start1P.frame = CGRectMake(30, 80, 60, 40);
	[start1P setTitle:@"Reset" forState:UIControlStateNormal];
	
	[start1P addTarget:self action:@selector(start1Pressed) forControlEvents:UIControlEventTouchUpInside];
	
	infoButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	infoButton.frame = CGRectMake(30, 140, 60, 40);

	[infoButton setTitle:@"Info" forState:UIControlStateNormal];
	[infoButton addTarget:self action:@selector(infoPressed) forControlEvents:UIControlEventTouchUpInside];



	p1CPU = [[UISwitch alloc] initWithFrame:CGRectMake(190, 80, 100, 40)];
	p2CPU = [[UISwitch alloc ] initWithFrame:CGRectMake(190, 120, 100, 40)];

	p1 = [[UILabel alloc] initWithFrame:CGRectMake(150, 70, 100, 40)];
	p1.text = @"P1 AI";
	p1.opaque = NO;
	p1.backgroundColor = [UIColor clearColor];
	p1.font = [UIFont fontWithName:@"AppleGothic" size:12];
	p2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 110, 100, 40)];
	p2.text = @"P2 AI";
	p2.opaque = NO;
	p2.backgroundColor = [UIColor clearColor];
	p2.font = [UIFont fontWithName:@"AppleGothic" size:12];
	
	

	CGRect gameFrame = CGRectMake(0, 0, 480, 320);
	
	self.gameVC = [[gameView alloc] initWithFrame:gameFrame];

	[self getBoardBounds];
	
	/*UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(330, 40, 100, 40)];
	pickerLabel.text = @"Bar Size";
	pickerLabel.opaque = NO;
	pickerLabel.font=[UIFont fontWithName:@"AppleGothic" size:16.0];
	pickerLabel.backgroundColor = [UIColor clearColor];*/
	
	sizePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(330,80,50,20)];
	sizePicker.dataSource = self;
	sizePicker.delegate = self;
	sizePicker.showsSelectionIndicator = YES;
	
	CGRect pickerFrame = sizePicker.frame;
	
	NSLog(@"%@",NSStringFromCGRect(pickerFrame));
	
	pickerFrame.size.width = 140;
	pickerFrame.size.height =162;
	sizePicker.frame = pickerFrame;
	
	[self.view addSubview:sizePicker];
	//[self.view addSubview:pickerLabel];

	[self.view addSubview:start1P];
	if (!gameVC.iPad) {
		[start1P setTitle:@"Play" forState:UIControlStateNormal];
		[self.view addSubview:title];
		}
	[self.view addSubview:infoButton];
	[self.view addSubview:p1CPU];
	[self.view addSubview:p2CPU];
	[self.view addSubview:p1];
	[self.view addSubview:p2];
	
	if (gameVC.iPad) {
		infoView = [[[info alloc] initWithFrame:CGRectMake(512, 0, 512, 768)] retain];
		[self.view addSubview:gameVC];

	}else{
		infoView = [[info alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
		infoView.hidden = YES;
	}

	[self.view addSubview:infoView];
}

-(void)getBoardBounds{
	CGRect gameViewBounds = gameVC.bounds;
	CGFloat ySize = CGRectGetHeight(gameViewBounds);
	CGFloat xSize = CGRectGetWidth(gameViewBounds);
	[rowChoices removeAllObjects];
	[colChoices removeAllObjects];
	
	int minsize = 50;
	
	if (gameVC.iPad) {
		minsize = 60;
	}
	
	for (int row = 2; row < ((ySize) / minsize); row++) {
		[rowChoices addObject:[NSNumber numberWithInt:row]];
	}

	for (int col = 2; col < ((xSize) / minsize); col++) {
		[colChoices addObject:[NSNumber numberWithInt:col]];
	}
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if (component == 0) {
		return [self.colChoices count];
	}else{
		return [self.rowChoices count];
	}
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	if (component == 0) {
		return [NSString stringWithFormat:@"%i x",[[self.colChoices objectAtIndex:row] intValue]];
	}
	return [NSString stringWithFormat:@"%i",[[self.rowChoices objectAtIndex:row] intValue]];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if (gameVC.iPad || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight){
		return YES;
	}else {
		return NO;
	}

}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[rowChoices release];
	[colChoices release];
}

-(void)start1Pressed{

	if (!gameVC.iPad) {
		[self.view addSubview:gameVC];
	}
	gameVC.cpu1 = p1CPU.on;
	gameVC.cpu2 = p2CPU.on;
	
	gameVC.cellCols = [[colChoices objectAtIndex:[sizePicker selectedRowInComponent:0]] intValue];
	gameVC.cellRows = [[rowChoices objectAtIndex:[sizePicker selectedRowInComponent:1]] intValue];
	
	
	[gameVC resetGame];
}
-(void)fullscreen{
	if (iPadLandscape) {
		
	}else {
		
	}


}

-(void)infoPressed{
	infoView.hidden = NO;
}
-(void)portrait{
		gameVC.frame = CGRectMake(10, 200, 748, 814);
		gameVC.backgroundColor = [UIColor clearColor];
		infoView.hidden = YES;
		infoView.frame = CGRectMake(0, 0, 768, 1024);
		infoView.infoWeb.frame = CGRectMake(0,0, infoView.frame.size.width, infoView.frame.size.height-40);
		[infoView.infoWeb reload];
		infoView.OK.frame = CGRectMake(infoView.frame.size.width - 80, infoView.frame.size.height - 40, 80, 40);
		infoView.OK.hidden = NO;
		infoButton.hidden = NO;
		

		
		[self getBoardBounds];
		[gameVC sizeCells];

		//gameVC.frame = CGRectMake(0, 200, 768, 824);
		//gameVC.frame = CGRectMake(0, 200, gameVC.cellSize * (gameVC.gameGrid.gridYsize) + (gameVC.xOffset * 2),  gameVC.cellSize * (gameVC.gameGrid.gridXsize)+ (gameVC.yOffset * 2));
		[sizePicker selectRow:(gameVC.gameGrid.gridYsize-2) inComponent:0 animated:NO];
		[sizePicker selectRow:(gameVC.gameGrid.gridXsize-2) inComponent:1 animated:NO];
		[gameVC drawGrid];
		
		start1P.frame = CGRectMake(45, 10, 60, 40);
		infoButton.frame = CGRectMake(45, 50, 60, 40);
		p1.frame = CGRectMake(15, 80, 100, 40);
		p2.frame = CGRectMake(15, 120, 100, 40);
		p1CPU.frame = CGRectMake(10, 105, 100, 40);
		p2CPU.frame = CGRectMake(10, 145, 100, 40);
		sizePicker.frame = CGRectMake(130, 10, 140, 162);
		iPadLandscape = NO;

}

-(void)landscape{
		gameVC.frame = CGRectMake(10, 200, 492, 558);
		gameVC.backgroundColor = [UIColor clearColor];
		infoView.frame = CGRectMake(512, 0, 512, 768);
		infoView.infoWeb.frame = CGRectMake(0,0, infoView.frame.size.width, infoView.frame.size.height);
		[infoView.infoWeb reload];
		infoView.hidden = NO;
		infoView.OK.hidden = YES;
		infoButton.hidden = YES;

		[self getBoardBounds];
		[gameVC sizeCells];
		[sizePicker selectRow:(gameVC.gameGrid.gridYsize-2) inComponent:0 animated:NO];
		[sizePicker selectRow:(gameVC.gameGrid.gridXsize-2) inComponent:1 animated:NO];
		[gameVC drawGrid];
		
		start1P.frame = CGRectMake(45, 10, 60, 40);
		infoButton.frame = CGRectMake(45, 50, 60, 40);
		p1.frame = CGRectMake(15, 80, 100, 40);
		p2.frame = CGRectMake(15, 120, 100, 40);
		p1CPU.frame = CGRectMake(10, 105, 100, 40);
		p2CPU.frame = CGRectMake(10, 145, 100, 40);
		sizePicker.frame = CGRectMake(130, 10, 140, 162);
		iPadLandscape = YES;

}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	if ((toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )&& gameVC.iPad) {
		[self portrait];
	}
	if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) && gameVC.iPad) {
		[self landscape];
	}
}

@end
