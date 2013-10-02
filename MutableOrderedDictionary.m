//
//  MutableOrderedDictionary.m
//
//  Created by Heitor Ferreira on 9/21/12.
//
//

#import "MutableOrderedDictionary.h"

@interface MutableOrderedDictionary ()
@property(nonatomic,retain) NSMutableArray *_orderedKeys;
@property(nonatomic,retain) NSMutableDictionary *_dictionary;
@end

@implementation MutableOrderedDictionary

@synthesize _orderedKeys;
@synthesize _dictionary;

+ (MutableOrderedDictionary *)dictionaryWithCapacity:(NSUInteger)capacity
{
    return [[[MutableOrderedDictionary alloc] initWithCapacity:capacity] autorelease];
}

- (id)init
{
    return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity
{
    if(self = [super init]) {
        self._orderedKeys = [NSMutableArray arrayWithCapacity:capacity];
        self._dictionary = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

- (void)dealloc
{
    [_orderedKeys release];
    [_dictionary release];
    [super dealloc];
}

- (NSUInteger)count
{
    return [self._orderedKeys count];
}

- (id)objectForKey:(id<NSCopying>)aKey
{
    return [self._dictionary objectForKey:aKey];
}


- (id)objectAtIndex:(NSUInteger)index
{
    return [self._dictionary objectForKey:[self._orderedKeys objectAtIndex:index]];
}

- (BOOL)containsKey:(id<NSCopying>)aKey
{
    return ([self._dictionary objectForKey:aKey] != nil);
}

- (NSArray *)allValues
{
    return [self._dictionary allValues];
}

- (NSArray *)orderedValues
{
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:self._dictionary.count];
    [self._orderedKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [values addObject:[self._dictionary objectForKey:obj]];
    }];
    return [[values copy] autorelease];
}

- (NSSet *)keySet
{
    return [NSSet setWithArray:self._orderedKeys];
}

- (NSDictionary*)dictionary
{
    return [[self._dictionary copy] autorelease];
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if([self._dictionary objectForKey:aKey]) {
        [self._orderedKeys removeObject:aKey];
    }
    [self._dictionary setObject:anObject forKey:aKey];
    [self._orderedKeys addObject:aKey];
}


- (void)removeObjectForKey:(id<NSCopying>)aKey
{
    if([self._dictionary objectForKey:aKey] != nil) {
        [self._dictionary removeObjectForKey:aKey];
        [self._orderedKeys removeObject:aKey];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    id key = [self._orderedKeys objectAtIndex:index];
    if(key) {
        [self._orderedKeys removeObjectAtIndex:index];
        [self._dictionary removeObjectForKey:key];
    }

}

- (void)removeAllObjects
{
    [self._dictionary removeAllObjects];
    [self._orderedKeys removeAllObjects];
}

- (NSEnumerator *)keyEnumerator
{
    return self._orderedKeys.objectEnumerator;
}

#pragma mark NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone
{
    MutableOrderedDictionary *copy = [[MutableOrderedDictionary allocWithZone:zone] init];
    copy._dictionary = [self._dictionary mutableCopyWithZone:zone];
    copy._orderedKeys = [self._orderedKeys mutableCopyWithZone:zone];
    return copy;
}

#pragma mark NSFastEnumeration
 
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id [])buffer count:(NSUInteger)len
{
    return [self._orderedKeys countByEnumeratingWithState:state objects:buffer count:len];
}

@end
