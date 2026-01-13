//
//  gameViewController.h
//  chocolateChomp
//
//  Created by Douglas Sartori on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOLCell.h"
#import "GOLGrid.h"
#import <AudioToolbox/AudioServices.h>

@interface gameView: UIView {
	GOLGrid *gameGrid;
	int gameState;
	int buttonSize;
	int buttonHeight;
	int xOffset;
	int yOffset;
	bool iPad;
	GOLCell *myCell;
	UIImage *emptyCell;
	UIImage *emptyCrumb;
	UIImage *populatedCell;
	UIImage *poisonCell;
	UILabel *alert;
	int turn;
	bool cpu1;
	bool cpu2;
	NSTimer *myTimer; 
	SystemSoundID chompID;
	NSMutableArray *cellImageArray;
	NSMutableArray *cellButtonArray;
	float cellSize;
	int cellRows;
	int cellCols;
	UIImageView *wrapper;
}


@property(nonatomic,retain) GOLGrid *gameGrid;
@property(nonatomic) int gameState;
@property(nonatomic) int buttonSize;
@property(nonatomic) int buttonHeight;
@property(nonatomic) int turn;
@property(nonatomic) int cellRows;
@property(nonatomic) int cellCols;
@property(nonatomic) float cellSize;
@property(nonatomic) bool cpu1;
@property(nonatomic) bool cpu2;
@property(nonatomic) bool iPad;
@property(nonatomic,retain) UIImage *emptyCell;
@property(nonatomic,retain) UIImage *emptyCrumb;
@property(nonatomic,retain) UIImage *populatedCell;
@property(nonatomic,retain) UIImage *poisonCell;
@property(nonatomic,retain) UIImageView *wrapper;
@property(nonatomic,retain) UILabel *alert;
@property(nonatomic,retain) GOLCell *myCell;
@property(nonatomic) 	SystemSoundID chompID;
@property(nonatomic,retain) NSMutableArray *cellImageArray;
@property(nonatomic,retain) NSMutableArray *cellButtonArray;
@property(nonatomic) int xOffset;
@property(nonatomic) int yOffset;

// - (void)addNeighbour:(GOLCell *) neighbour;

- (void)cellButtonPressed:(id)sender;
- (void)drawGrid;
- (void)resetGame;
-(void)chompX:(int)x Y:(int)y;
-(void)nextTurn;
-(void)sizeCells;
@end

