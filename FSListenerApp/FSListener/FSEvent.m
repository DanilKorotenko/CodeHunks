//
//  FSEvent.m
//
//

#import "FSEvent.h"

@implementation FSEvent

- (id)initWithEventId:(NSUInteger)anIdentifier
	eventPath:(NSString *)aPath
	eventFlags:(FSEventStreamEventFlags)aFlags
{
	if ((self = [super init]))
	{
		_eventId = anIdentifier;
		_eventPath = aPath;
		_eventFlags = aFlags;
	}

	return self;
}

- (void)dealloc
{
	_eventPath = nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ { eventId = %ld, eventPath = %@, eventFlags = %ld } >", 
		[self className], ((unsigned long)self.eventId), self.eventPath,
		((unsigned long)self.eventFlags)];
}

@end
