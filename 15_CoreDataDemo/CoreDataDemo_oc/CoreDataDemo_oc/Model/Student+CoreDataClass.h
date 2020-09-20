//
//  Student.h
//  CoreDataDemo_oc
//
//  Created by sunke on 2020/9/20.
//  Copyright © 2020 KentSun. All rights reserved.
//

/*
 Xcode 8 adds support for automatic Core Data subclass generation, which you can read about in the document What's New in Core Data in macOS 10.12, iOS 10.0, tvOS 10.0, and watchOS 3.0. New projects have automatic code generation turned on so when you created NSManagedObject subclasses manually, you created duplicates, which is causing the compiler error.

 There are two ways to fix this. First, you could remove the NSManagedObject subclasses you manually created. Second you can turn off automatic code generation for your data model from the Data Model inspector by choosing Manual/None from the Codegen menu. If you're following a tutorial, I recommend the second option because the tutorial was most likely written before Apple added automatic Core Data subclass generation.
 
 
 */
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Student+CoreDataProperties.h"
