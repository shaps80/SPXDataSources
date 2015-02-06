//
//  SPXDataProviderConfiguration.h
//  Drizzle
//
//  Created by Shaps Mohsenin on 14/11/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

@import Foundation;

@interface SPXDataProviderConfiguration : NSObject <NSCopying>

@property (nonatomic, strong) NSArray *sortDescriptors;
@property (nonatomic, strong) NSPredicate *predicate;
@property (nonatomic, strong) NSString *sectionNameKeyPath;

@end
