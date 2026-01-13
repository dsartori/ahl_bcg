//
//  gridView.h
//  simplelife
//
//  Created by Douglas Sartori on 2013-07-18.
//
//

#import "GOLGrid.h"
#import "GOLCell.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GridView : UIView{
    
    NSMutableArray *touchedCells;
}

@property GOLGrid *gameGrid;
@property int offset;
@property int cellHeight;
@property int cellWidth;
@property CGPoint viewPortSize;
@property CGPoint viewPortOrigin;
@property NSArray *cellZoomLevels;
@property NSArray *graphZoomLevels;
@property int zoomLevel;
@property int maxZoom;
@property int gameState;

-(void)increaseZoomLevel;
-(void)decreaseZoomLevel;
-(void)adjustZoom;
@end
