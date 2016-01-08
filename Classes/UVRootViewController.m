//
//  UVWelcomeViewController.m
//  UserVoice
//
//  Created by UserVoice on 12/15/09.
//  Copyright 2009 UserVoice Inc. All rights reserved.
//

#include <QuartzCore/QuartzCore.h>
#import "UVRootViewController.h"
#import "UVClientConfig.h"
#import "UVAccessToken.h"
#import "UVRequestToken.h"
#import "UVSession.h"
#import "UVUser.h"
#import "UVWelcomeViewController.h"
#import "UVSuggestionListViewController.h"
#import "UVConfig.h"
#import "UVStyleSheet.h"
#import "UVInitialLoadManager.h"
#import "UVPostIdeaViewController.h"
#import "UVContactViewController.h"
#import "UVBabayaga.h"

// File modifed by DR on 7 Jan 2016 so we can show specific articles directly
// Based on PR 138 by mronkko from here:
// https://github.com/uservoice/uservoice-ios-sdk/pull/138/files
#import "UVArticle.h"
#import "UVArticleViewController.h"
#import "UVHelpTopic.h"
#import "UVHelpTopicViewController.h"
//

@implementation UVRootViewController

- (id)initWithViewToLoad:(NSString *)theViewToLoad {
    if (self = [super init]) {
        _viewToLoad = theViewToLoad;
    }
    return self;
}

- (void)dismiss {
    _firstController = YES;
    _loader.dismissed = YES;
    [super dismiss];
}

- (void)pushNextView {
    [UVBabayaga track:VIEW_CHANNEL];
    UVSession *session = [UVSession currentSession];
    if ((![UVAccessToken exists] || session.user) && session.clientConfig && [self.navigationController.viewControllers count] == 1) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        UVBaseViewController *next = nil;
        
        NSInteger articleId = [self.viewToLoad integerValue];
        if (articleId == 0) {
            
            if ([_viewToLoad isEqualToString:@"welcome"])
                next = [UVWelcomeViewController new];
            else if ([_viewToLoad isEqualToString:@"suggestions"])
                next = [UVSuggestionListViewController new];
            else if ([_viewToLoad isEqualToString:@"new_suggestion"])
                next = [UVPostIdeaViewController new];
            else if ([_viewToLoad isEqualToString:@"new_ticket"])
                next = [UVContactViewController new];
            
            [self pushViewsAndAnimate:[NSArray arrayWithObject:next]];
            
        } else {
            // Article ID is set, load specific article
            [UVArticle getArticleWithId:articleId delegate:self];
        }
    }
}

#pragma mark ===== Additions from PR135 so we can show specific articles directly

- (void)pushViewsAndAnimate:(NSArray *)viewControllers {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    BOOL first = TRUE;
    
    for(UVBaseViewController* viewController in viewControllers){
        viewController.firstController = first;
        first = FALSE;
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

- (void)didRetrieveIndividualArticle:(UVArticle *)article {
    
    UVArticleViewController *articleViewController = [[UVArticleViewController alloc] initWithArticle:article helpfulPrompt:nil returnMessage:nil];
    if (articleViewController) {
        [self pushViewsAndAnimate:@[articleViewController]];
    } else {
        UIViewController *welcomeViewController = [[UVWelcomeViewController alloc] init];
        [self pushViewsAndAnimate:@[welcomeViewController]];
    }
}

#pragma mark ===== Basic View Methods =====

- (void)loadView {
    [super loadView];

    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Feedback & Support", @"UserVoice", [UserVoice bundle], nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Close", @"UserVoice", [UserVoice bundle], nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismiss)];

    self.view = [[UIView alloc] initWithFrame:[self contentFrame]];
    self.view.backgroundColor = [UVStyleSheet instance].loadingViewBackgroundColor;

    UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width, 100)];
    loading.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([activity respondsToSelector:@selector(setColor:)]) {
        [activity setColor:[UIColor grayColor]];
    } else {
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    activity.center = CGPointMake(loading.bounds.size.width/2, 40);
    [loading addSubview:activity];
    [activity startAnimating];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, loading.frame.size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedStringFromTableInBundle(@"Loading...", @"UserVoice", [UserVoice bundle], nil);
    [label sizeToFit];
    label.center = CGPointMake(loading.bounds.size.width/2, 85);
    [loading addSubview:label];
    [loading sizeToFit];
    [self.view addSubview:loading];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _loader = [UVInitialLoadManager loadWithDelegate:self action:@selector(pushNextView)];
}

@end
