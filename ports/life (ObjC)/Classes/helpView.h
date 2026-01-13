//
//  helpView.h
//  simplelife
//
//  Created by Douglas Sartori on 11-09-29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface helpView : UIView <UIWebViewDelegate>{
    UIWebView *helpWeb;
}

@property (nonatomic, retain) UIWebView *helpWeb;

@end
