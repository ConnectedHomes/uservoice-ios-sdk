//
//  UVModelDelegate.h
//  UserVoice
//
//  Created by Austin Taylor on 2/14/14.
//  Copyright (c) 2014 UserVoice Inc. All rights reserved.
//

@class UVRequestContext, UVClientConfig, UVSuggestion, UVComment, UVForum, UVAccessToken, UVTicket, UVHelpTopic, UVRequestToken, UVUser, UVArticle;

@protocol UVModelDelegate <NSObject>
@optional

- (void)didReceiveError:(NSError *)error;
- (void)didReceiveError:(NSError *)error context:(UVRequestContext *)requestContext;
- (void)didRetrieveClientConfig:(UVClientConfig *)clientConfig;
- (void)didRetrieveSuggestions:(NSArray *)suggestions;
- (void)didSearchSuggestions:(NSArray *)suggestions;
- (void)didSubscribe:(UVSuggestion *)suggestion;
- (void)didUnsubscribe:(UVSuggestion *)suggestion;
- (void)didRetrieveComments:(NSArray *)comments;
- (void)didCreateComment:(UVComment *)comment;
- (void)didRetrieveForum:(UVForum *)forum;
- (void)didRetrieveAccessToken:(UVAccessToken *)accessToken;
- (void)didCreateTicket:(UVTicket *)ticket;
- (void)didRetrieveArticles:(NSArray *)articles;
- (void)didRetrieveInstantAnswers:(NSArray *)instantAnswers;
- (void)didRetrieveRequestToken:(UVRequestToken *)requestToken;
- (void)didRetrieveHelpTopics:(NSArray *)topics;
- (void)didRetrieveHelpTopic:(UVHelpTopic *)topic;
- (void)didDiscoverUser:(UVUser *)user;
- (void)didRetrieveCurrentUser:(UVUser *)user;
- (void)didCreateUser:(UVUser *)user;
- (void)didSendForgotPassword:(UVUser *)user;
- (void)didIdentifyUser:(UVUser *)user;
- (void)didCreateSuggestion:(UVSuggestion *)user;

// Added by DR on 7 Jan 2016 so we can show specific articles directly
// Based on PR 138 by mronkko from here:
// https://github.com/uservoice/uservoice-ios-sdk/pull/138/files
- (void)didRetrieveIndividualArticle:(UVArticle *)article;

@end
