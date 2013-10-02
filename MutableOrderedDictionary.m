//
//  MutableOrderedDictionary.m
//
//  Created by Heitor Ferreira on 9/21/12.
//
//

#import "MutableOrderedDictionary.h"

@interface MutableOrderedDictionary ()
@property(nonatomic,strong) NSMutableArray *orderedKeys;
@property(nonatomic,strong) NSMutableDictionary *store;
@end

@implementation MutableOrderedDictionary

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization
////////////////////////////////////////////////////////////////////////////////////////////////////
+ (MutableOrderedDictionary *)dictionaryWithCapacity:(NSUInteger)capacity
{
    return [[MutableOrderedDictionary alloc] initWithCapacity:capacity];
}

- (id)init
{
    return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity
{
    if(self = [super init]) {
        _orderedKeys = [NSMutableArray arrayWithCapacity:capacity];
        _store = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Access
////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger)count
{
    return [self.orderedKeys count];
}

- (BOOL)containsKey:(id<NSCopying>)aKey
{
    return ([self.store objectForKey:aKey] != nil);
}

- (NSArray *)allValues
{
    return [self.store allValues];
}

- (NSArray *)orderedValues
{
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:self.store.count];
    [self.orderedKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [values addObject:[self.store objectForKey:obj]];
    }];
    return [values copy];
}


- (NSDictionary*)dictionary
{
    return [self.store copy];
}

- (NSEnumerator *)keyEnumerator
{
    return self.orderedKeys.objectEnumerator;
}

- (NSSet *)keySet
{
    return [NSSet setWithArray:self.orderedKeys];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectForKey:(id)aKey
{
    return [self.store objectForKey:aKey];
}

- (id)objectForKeyedSubscript:(id)aKey
{
    return [self.store objectForKey:aKey];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectAtIndex:(NSUInteger)index
{
    return [self.store objectForKey:[self.orderedKeys objectAtIndex:index]];
}

- (id)objectAtIndexedSubscript:(NSInteger)index
{
    return [self objectAtIndex:index];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutation
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if([self.store objectForKey:aKey]) {
        [self.orderedKeys removeObject:aKey];
    }
    [self.store setObject:anObject forKey:aKey];
    [self.orderedKeys addObject:aKey];
}

- (void)setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey
{
    [self setObject:anObject forKey:aKey];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeObjectForKey:(id<NSCopying>)aKey
{
    if([self.store objectForKey:aKey] != nil) {
        [self.store removeObjectForKey:aKey];
        [self.orderedKeys removeObject:aKey];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    id key = [self.orderedKeys objectAtIndex:index];
    if(key) {
        [self.orderedKeys removeObjectAtIndex:index];
        [self.store removeObjectForKey:key];
    }

}

- (void)removeAllObjects
{
    [self.store removeAllObjects];
    [self.orderedKeys removeAllObjects];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSMutableCopying
////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)mutableCopyWithZone:(NSZone *)zone
{
    MutableOrderedDictionary *copy = [[MutableOrderedDictionary allocWithZone:zone] init];
    copy.store = [self.store mutableCopyWithZone:zone];
    copy.orderedKeys = [self.orderedKeys mutableCopyWithZone:zone];
    return copy;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSFastEnumeration
//////////////////////////////////////////////////////////////////////////////////////////////////// 
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [self.orderedKeys countByEnumeratingWithState:state objects:buffer count:len];
}

@end
