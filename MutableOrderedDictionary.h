//
//  MutableOrderedDictionary.h
//
//  Created by Heitor Ferreira on 9/21/12.
//
//

#import <Foundation/Foundation.h>

@interface MutableOrderedDictionary : NSObject<NSMutableCopying,NSFastEnumeration>

+ (MutableOrderedDictionary *)dictionaryWithCapacity:(NSUInteger)capacity;
- (id)initWithCapacity:(NSUInteger)capacity;


- (NSUInteger)count;
- (id)objectForKey:(id<NSCopying>)aKey;
- (id)objectAtIndex:(NSUInteger)index;
- (BOOL)containsKey:(id<NSCopying>)aKey;
- (NSArray*)allValues;
- (NSArray *)orderedValues;
- (NSSet*)keySet;
- (NSDictionary*)dictionary;

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)removeObjectForKey:(id<NSCopying>)aKey;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeAllObjects;

- (NSEnumerator *)keyEnumerator;
@end
