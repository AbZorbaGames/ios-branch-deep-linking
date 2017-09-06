//
//  BNCSpotlightService.h
//  Branch-SDK
//
//  Created by Parth Kalavadia on 8/10/17.
//  Copyright © 2017 Branch Metrics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchUniversalObject.h"

@interface BNCSpotlightService : NSObject

//Indexing API
//indexPublicaly
- (void)indexPubliclyWithBranchUniversalObject:(BranchUniversalObject* _Nonnull)universalObject
                                linkProperties:(BranchLinkProperties* _Nullable)linkProperties
                                      callback:(void (^_Nullable)(BranchUniversalObject * _Nullable universalObject,
                                                                  NSString* _Nullable url,
                                                                  NSError * _Nullable error))completion;
//indexWithBranchShareLink
- (void)indexPrivatelyWithBranchUniversalObject:(BranchUniversalObject* _Nonnull)universalObject
                                       callback:(void (^_Nullable)(BranchUniversalObject * _Nullable universalObject,
                                                                   NSString* _Nullable url,
                                                                   NSError * _Nullable error))completion;

- (void)indexPrivatelyWithBranchUniversalObjects:(NSArray<BranchUniversalObject*>* _Nonnull)universalObjects
                                      completion:(void (^_Nullable) (NSArray<BranchUniversalObject*>* _Nullable,
                                                                     NSError* _Nullable))completion;

//Remove indexing API
- (void)removeSearchableItemsWithIdentifier:(NSString * _Nonnull)identifier
                                   callback:(void (^_Nullable)(NSError * _Nullable error))completion;

- (void)removeSearchableItemsWithIdentifiers:(NSArray<NSString *> *_Nonnull)identifiers
                                    callback:(void (^_Nullable)(NSError * _Nullable error))completion;

- (void)removeAllBranchSearchableItemsByBranchSpotlightDomainWithCallback:(void (^_Nullable)(NSError * _Nullable error))completion;
@end
