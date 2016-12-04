//
//  FSListener.h
//
//

#import <Foundation/Foundation.h>

#import <CoreServices/CoreServices.h>

#import "FSListenerDelegateProtocol.h"

@class FSEvent;

// This class represents an Objective-C wrapper for the FSEvents C API.
@interface FSListener : NSObject
{
	CFRunLoopRef			_runLoop;
	FSEventStreamRef		_eventStream;

	pthread_mutex_t			_eventsLock;

	NSMutableArray			*_watchedPaths;
}

- (id)initWithDelegate:(id<FSListenerDelegate>)aDelegate;

@property (readonly) BOOL isWatchingPaths;
@property (readonly) NSArray *watchedPaths;

- (void)addPathToWatch:(NSString *)aPath;
- (void)removeWatchedPath:(NSString *)aPath;

- (BOOL)startWatching;

- (BOOL)stopWatching;

@end
