//
//  FSEvent.h
//
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

// This class represents a single file system event
@interface FSEvent : NSObject

- (id)initWithEventId:(NSUInteger)anIdentifier
	eventPath:(NSString *)aPath
	eventFlags:(FSEventStreamEventFlags)aFlags;

@property (readonly) NSUInteger					eventId;
@property (readonly) NSString					*eventPath;
@property (readonly) FSEventStreamEventFlags	eventFlags;

@end
