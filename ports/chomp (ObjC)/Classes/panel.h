//
//  panel.h
//  chocolateChomp
//
//  Created by Douglas Sartori on 10-11-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface panel : UIView {
	UIPickerView *sizePicker;
	UIButton *infoButton;
	NSMutableArray *rowChoices;
	NSMutableArray *colChoices;
	UIButton *start1P;
	UILabel *p1;
	UILabel *p2;
	UISwitch *p1CPU;
	UISwitch *p2CPU;
}
@property (nonatomic, retain) UIButton *start1P;
@property (nonatomic, retain) UILabel *p1;
@property (nonatomic, retain) UILabel *p2;
@property (nonatomic, retain) NSMutableArray *rowChoices;
@property (nonatomic, retain) NSMutableArray *colChoices;
@property(nonatomic, retain) IBOutlet UIButton *infoButton;
@property(nonatomic, retain) IBOutlet UIPickerView *sizePicker;
@property(nonatomic, retain) IBOutlet UISwitch *p1CPU;
@property(nonatomic, retain) IBOutlet UISwitch *p2CPU;

-(void)infoPressed;
-(void)start1Pressed;
@end
