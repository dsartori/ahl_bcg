//
//  chocolateChompAppDelegate.h
//  chocolateChomp
//
//  Created by Douglas Sartori on 10-11-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class chocolateChompViewController;

@interface chocolateChompAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    chocolateChompViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet chocolateChompViewController *viewController;

@end

