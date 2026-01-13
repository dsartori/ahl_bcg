//
//  info.h
//  chocolateChomp
//
//  Created by Douglas Sartori on 10-11-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface info : UIView {
	UIWebView *infoWeb;
	UIButton *OK;
}
@property (nonatomic, retain) UIWebView *infoWeb;
@property (nonatomic, retain) UIButton *OK;
@end
