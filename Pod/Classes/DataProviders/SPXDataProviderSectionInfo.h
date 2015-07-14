/*
   Copyright (c) 2014 Snippex. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY Snippex `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Snippex OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <CoreData/CoreData.h>


/**
 *  Provides a common object for dealing with section info in data providers
 */
@interface SPXDataProviderSectionInfo : NSObject


/* Name of the section
 */
@property (nonatomic, readonly) NSString *name;


/* Title of the section (used when displaying the index)
 */
@property (nonatomic, readonly) NSString *indexTitle;


/* Number of objects in section
 */
@property (nonatomic, readonly) NSUInteger numberOfObjects;


/* Returns the array of objects in the section.
 */
@property (nonatomic, readonly) NSArray *objects;


/**
 *  Returns a new instance, mapped to the fetched results section info
 *
 *  @param sectionInfo The section info object
 *
 *  @return A pre-configured SPXDataProviderSectionInfo instance
 */
+ (instancetype)sectionInfoFromFetchedResultsSectionInfo:(id <NSFetchedResultsSectionInfo>)sectionInfo;


@end

