//
//  gridView.m
//  simplelife
//
//  Created by Douglas Sartori on 2013-07-18.
//
//

#import "GridView.h"

@implementation GridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        touchedCells = [[NSMutableArray alloc] init];
        
        _viewPortOrigin = CGPointMake(0, 0);
        _zoomLevel = 2;
        _maxZoom = 4;
        
        _cellZoomLevels = [[NSArray alloc] initWithArray:@[@10,@15,@20,@30,@40]];
        }
    
    
    return self;
}

-(void)increaseZoomLevel{
    
    if (self.zoomLevel < self.maxZoom){
        self.zoomLevel++;
        NSLog(@"%d",self.zoomLevel);
        [self adjustZoom];
    }
    
}

-(void)decreaseZoomLevel{
    if (self.zoomLevel > 0 ){
        self.zoomLevel--;
        NSLog(@"%d",self.zoomLevel);
        [self adjustZoom];
    }
}


-(void)adjustZoom{
    
        self.cellWidth = [[self.cellZoomLevels objectAtIndex:self.zoomLevel] intValue];
    
        self.cellHeight = self.cellWidth;
        self.viewPortSize = CGPointMake([[[self.graphZoomLevels objectAtIndex:self.zoomLevel] objectAtIndex:0] floatValue],
                                        [[[self.graphZoomLevels objectAtIndex:self.zoomLevel] objectAtIndex:1] floatValue]);
        
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1);

    int yMax = self.viewPortSize.y + self.viewPortOrigin.y;
    int xMax = self.viewPortSize.x + self.viewPortOrigin.x;
    
    for (int rowIndex = self.viewPortOrigin.y; rowIndex < yMax; rowIndex++){
        //self.gameGrid.gridYsize ; rowIndex++) {
		for (int colIndex = self.viewPortOrigin.x; colIndex < xMax; colIndex++){
            //self.viewPortOrigin.x; colIndex < self.gameGrid.gridXsize ; colIndex++) {
			
            // subtract origin coordinates from index values to get viewport coordinates
            int scrCol = colIndex - self.viewPortOrigin.x;
            int scrRow = rowIndex - self.viewPortOrigin.y;
			
			GOLCell *myCell = [[self.gameGrid.cellGrid objectAtIndex:rowIndex] objectAtIndex:colIndex];
			
            
			bool cellState = myCell.state;
            if (cellState) {
                CGContextSetRGBFillColor(context, 0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 1.0);
            }else{
                CGContextSetRGBFillColor(context, 255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 1.0);
            }
            CGContextBeginPath(context);
            CGContextAddRect(context,CGRectMake((self.cellWidth * scrCol) + self.offset, (self.cellHeight * scrRow)+self.offset, self.cellWidth, self.cellHeight));
            CGContextFillPath(context);
            
            CGContextSetRGBStrokeColor(context, 204.0 / 255.0, 204.0 / 255.0, 204.0 / 255.0, 1.0);
            
            CGContextMoveToPoint(context, (self.cellWidth * scrCol) + self.offset, (self.cellHeight * scrRow)+self.offset);
            CGContextAddLineToPoint(context, (self.cellWidth * scrCol) + self.offset + self.cellWidth, (self.cellHeight * scrRow)+self.offset);
            CGContextAddLineToPoint(context, (self.cellWidth * scrCol) + self.offset + self.cellWidth, (self.cellHeight * scrRow)+self.offset + self.cellHeight);
            CGContextAddLineToPoint(context, (self.cellWidth * scrCol) + self.offset, (self.cellHeight * scrRow)+self.offset + self.cellHeight);
            CGContextAddLineToPoint(context, (self.cellWidth * scrCol) + self.offset , (self.cellHeight * scrRow)+self.offset );
            CGContextStrokePath(context);
            
        }
    }
}

-(void)toggleCellAtX:(int)x Y:(int)y{
    GOLCell *tmpCell = [[self.gameGrid.cellGrid objectAtIndex:y] objectAtIndex:x];
    
    
    if ([touchedCells indexOfObject:tmpCell] == NSNotFound){
        bool cellState = tmpCell.state;
        if (cellState){
            [tmpCell setState:0];
        }else {
            [tmpCell setState:1];
        }
        [self setNeedsDisplay];
        [touchedCells addObject:tmpCell];
    }

    
    
    [self.gameGrid clearCellCache];
    //NSLog(@"%d,%d",x,y);

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    
    int x = location.x / self.cellWidth;
    int y = location.y / self.cellHeight;
    
    if ((touches.count < 2 ) &! self.gameState)
        [self toggleCellAtX:x Y:y];
    
       
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint prevLocation = [touch previousLocationInView:self];
    int x = location.x / self.cellWidth;
    int y = location.y / self.cellHeight;
    
    NSLog(@"%d",touches.count);
    if ((touches.count < 2) &! self.gameState)
        [self toggleCellAtX:x Y:y];
    
    if (touches.count == 2){  // support two-finger panning
        
        if (location.x - prevLocation.x < 0){ // touch went right
            
            if ((self.viewPortOrigin.x + self.viewPortSize.x) < self.gameGrid.gridXsize){
                self.viewPortOrigin = CGPointMake(self.viewPortOrigin.x+1,self.viewPortOrigin.y);
          
            }
        }
    if (location.x - prevLocation.x > 0){  // touch went left
        if (self.viewPortOrigin.x > 0){
            self.viewPortOrigin = CGPointMake(self.viewPortOrigin.x-1,self.viewPortOrigin.y);
            }
        }
        
        if (location.y - prevLocation.y < 0){ // touch went down
            
            if ((self.viewPortOrigin.y + self.viewPortSize.y) < self.gameGrid.gridYsize){
                self.viewPortOrigin = CGPointMake(self.viewPortOrigin.x,self.viewPortOrigin.y+1);

            }
        }
        
        if (location.y - prevLocation.y > 0){// touch went up
            if ((self.viewPortOrigin.y) > 0){
                self.viewPortOrigin = CGPointMake(self.viewPortOrigin.x,self.viewPortOrigin.y-1);
            }
        }
        NSLog(@"%f,%f",self.viewPortOrigin.x,self.viewPortOrigin.y);
        [self setNeedsDisplay];
    }
    
    

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [touchedCells removeAllObjects];
}
@end
