//
//  Person.h
//  SPXDataSources
//
//  Created by Shaps Mohsenin on 11/03/2015.
//  Copyright (c) 2015 Shaps Mohsenin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identifier;

@end
