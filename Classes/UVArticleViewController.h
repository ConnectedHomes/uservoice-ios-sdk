//
//  UVArticleViewController.h
//  UserVoice
//
//  Created by Austin Taylor on 5/8/12.
//  Copyright (c) 2012 UserVoice Inc. All rights reserved.
//

#import "UVBaseViewController.h"
#import "UVArticle.h"

@interface UVArticleViewController : UVBaseViewController<UIActionSheetDelegate, UIWebViewDelegate>

// Added by DR on 7 Jan 2016 so we can show specific articles directly
// Based on PR 138 by mronkko from here:
// https://github.com/uservoice/uservoice-ios-sdk/pull/138/files
- (id)initWithArticle:(UVArticle *)theArticle helpfulPrompt:(NSString *)theHelpfulPrompt returnMessage:(NSString *)theReturnMessage;

@property (nonatomic, retain) UVArticle *article;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *helpfulPrompt;
@property (nonatomic, retain) NSString *returnMessage;
@property (nonatomic, retain) NSString *deflectingType;

@end
