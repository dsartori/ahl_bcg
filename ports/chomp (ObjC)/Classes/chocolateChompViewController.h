//
//  chocolateChompViewController.h
//  chocolateChomp
//
//  Created by Douglas Sartori on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gameView.h"
#import "info.h"

@interface chocolateChompViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    gameView *gameVC;
	info *infoView;
	bool cpu1;
	bool cpu2;
	UIPickerView *sizePicker;
	UIButton *infoButton;
	NSMutableArray *rowChoices;
	NSMutableArray *colChoices;
	UIButton *start1P;
	UILabel *p1;
	UILabel *p2;
	int barX;
	int barY;
	UISwitch *p1CPU;
	UISwitch *p2CPU;
	bool iPadLandscape;
	bool iPadFullscreen;

}

@property (nonatomic, retain) IBOutlet gameView *gameVC;
@property(nonatomic) bool cpu1;
@property(nonatomic) bool cpu2;
@property(nonatomic) int barX;
@property(nonatomic) int barY;
@property(nonatomic) bool iPadLandscape;
@property(nonatomic) bool iPadFullscreen;
@property (nonatomic, retain) UIButton *start1P;
@property (nonatomic, retain) UILabel *p1;
@property (nonatomic, retain) UILabel *p2;
@property (nonatomic, retain) NSMutableArray *rowChoices;
@property (nonatomic, retain) NSMutableArray *colChoices;
@property(nonatomic, retain) IBOutlet info *infoView;
@property(nonatomic, retain) IBOutlet UIButton *infoButton;
@property(nonatomic, retain) IBOutlet UIPickerView *sizePicker;
@property(nonatomic, retain) IBOutlet UISwitch *p1CPU;
@property(nonatomic, retain) IBOutlet UISwitch *p2CPU;

-(void)getBoardBounds;
-(void)infoPressed;
-(void)start1Pressed;
-(void)portrait;
-(void)landscape;
-(void)fullscreen;
@end

