//
//  UVArticle.h
//  UserVoice
//
//  Created by Austin Taylor on 5/8/12.
//  Copyright (c) 2012 UserVoice Inc. All rights reserved.
//

#import "UVBaseModel.h"

@class UVHelpTopic;

@interface UVArticle : UVBaseModel

+ getInstantAnswers:(NSString *)query delegate:(id<UVModelDelegate>)delegate;
+ (id)getArticlesWithTopicId:(NSInteger)topicId page:(NSInteger)page delegate:(id<UVModelDelegate>)delegate;
+ (id)getArticlesWithPage:(NSInteger)page delegate:(id<UVModelDelegate>)delegate;

// Added by DR on 7 Jan 2016 so we can show specific articles directly
// Based on PR 138 by mronkko from here:
// https://github.com/uservoice/uservoice-ios-sdk/pull/138/files
+ (id)getArticleWithId:(NSInteger)topicId delegate:(id)delegate;
@property (nonatomic, assign) NSInteger topicId;

@property (nonatomic, retain) NSString *topicName;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSString *answerHTML;
@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, assign) NSInteger weight;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
