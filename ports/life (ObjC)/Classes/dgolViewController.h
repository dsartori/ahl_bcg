//
//  dgolViewController.h
//  dgol
//
//  Created by Douglas Sartori on 10-09-04.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GOLCell.h"
#import "GOLGrid.h"
#import "helpView.h"
#import "GridView.h"



@interface dgolViewController : UIViewController <UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>{
	GOLGrid *gameGrid;
    GridView *gridView;
    helpView *help;

	bool fullspeed;
	bool iPad;
	bool lastLocal;
	int speedcounter;
	GOLCell *myCell;
	
	NSMutableString *lastfile;

	NSMutableArray *toolbarButtons;
    NSMutableArray *gridChoices;
    
    UIToolbar *toolbar;
    UIBarButtonItem *startButton;
	UIBarButtonItem *pauseButton;
    UIBarButtonItem *fwdButton;
    UIBarButtonItem *stepButton;
    UIBarButtonItem *resetButton;
	UIBarButtonItem *loadButton;
	UIBarButtonItem *saveButton;
    UIBarButtonItem *clearButton;
    UIBarButtonItem *helpButton;
    UIBarButtonItem *spacer;
    UIBarButtonItem *gridButton;
    
    UIButton *cancelButton;
    UIButton *closeButton;
    UIPickerView *gridPicker;
    UIActionSheet *gridSheet;
    
    float lastScale;    

}

@property(nonatomic,retain) GOLGrid *gameGrid;
@property(nonatomic) int gameState;
@property(nonatomic) int offset;
@property(nonatomic) bool fullspeed;
@property(nonatomic) int speedcounter;
@property(nonatomic) bool lastLocal;
@property(nonatomic,retain) GOLCell *myCell;


// - (void)addNeighbour:(GOLCell *) neighbour;

- (void)cellButtonPressed:(id)sender;
- (void)startButtonPressed:(id)sender;
- (void)pauseButtonPressed;
- (void)resetButtonPressed;
- (void)clearButtonPressed;
- (void)stepButtonPressed;
- (void)loadButtonPressed;
- (void)saveButtonPressed;
-(void)actionButtonPressed;
-(void)helpButtonPressed;
-(void)loadInitialState;
-(void)gridButtonPressed;
- (void)fwdButtonPressed:(id)sender;
-(void)handlePinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer;
@end

