//
//  FSListener.m
//
//

#import "FSListener.h"

#import "FSEvent.h"
#import "pthread.h"

// Private methods
@interface FSListener ()

static FSEventStreamRef _create_events_stream(FSListener *watcher,
	CFArrayRef paths, CFTimeInterval latency, FSEventStreamEventId sinceWhen);

static void _events_callback(ConstFSEventStreamRef streamRef,
	void *clientCallBackInfo, size_t numEvents, void *eventPaths,
	const FSEventStreamEventFlags eventFlags[],
	const FSEventStreamEventId eventIds[]);

static CFStringRef _strip_trailing_slash_from_path(CFStringRef path);

@property (readwrite, weak) id <FSListenerDelegate> delegate;

@end

@implementation FSListener

- (id)initWithDelegate:(id<FSListenerDelegate>)aDelegate
{
	if ((self = [super init]))
	{
		_isWatchingPaths = NO;

		pthread_mutex_init(&_eventsLock, NULL);

		self.delegate = aDelegate;

		_watchedPaths = [NSMutableArray array];
	}

	return self;
}

#pragma mark -

- (void)addPathToWatch:(NSString *)aPath
{
	[_watchedPaths addObject:aPath];
}

- (void)removeWatchedPath:(NSString *)aPath
{
	[_watchedPaths removeObject:aPath];
}

#pragma mark -

- (BOOL)startWatching
{
	return [self startWatchingOnRunLoop:[NSRunLoop currentRunLoop]];
}

- (BOOL)startWatchingOnRunLoop:(NSRunLoop *)runLoop
{
	pthread_mutex_lock(&_eventsLock);

	_runLoop = [runLoop getCFRunLoop];

	if ([self.watchedPaths count] == 0 || _isWatchingPaths)
	{
		pthread_mutex_unlock(&_eventsLock);

		return NO;
	}

	_eventStream = _create_events_stream(self,
		((__bridge CFArrayRef)self.watchedPaths));

	// Schedule the event stream on the supplied run loop
	FSEventStreamScheduleWithRunLoop(_eventStream, _runLoop,
		kCFRunLoopDefaultMode);

	// Start the event stream
	FSEventStreamStart(_eventStream);

	_isWatchingPaths = YES;

	pthread_mutex_unlock(&_eventsLock);

	return YES;
}

- (BOOL)stopWatching
{
	pthread_mutex_lock(&_eventsLock);

	if (!_isWatchingPaths)
	{
		pthread_mutex_unlock(&_eventsLock);
		return NO;
	}

	FSEventStreamStop(_eventStream);

	if (_runLoop)
	{
		FSEventStreamUnscheduleFromRunLoop(_eventStream, _runLoop,
			kCFRunLoopDefaultMode);
	}

	FSEventStreamInvalidate(_eventStream);

	if (_eventStream)
	{
		FSEventStreamRelease(_eventStream);
		_eventStream = NULL;
	}

	_isWatchingPaths = NO;

	pthread_mutex_unlock(&_eventsLock);

	return YES;
}

#pragma mark -
#pragma mark Other

- (NSString *)description
{
	pthread_mutex_lock(&_eventsLock);

	NSString *streamDescription = (_isWatchingPaths) ?
	(NSString *)CFBridgingRelease(FSEventStreamCopyDescription(_eventStream)) : nil;

	pthread_mutex_unlock(&_eventsLock);

	return [NSString stringWithFormat:@"<%@ { watchedPaths = %@, streamDescription = %@} >",
			[self className], self.watchedPaths, streamDescription];
}

#pragma mark -

- (void)dealloc
{
	self.delegate = nil;

	// Stop the event stream if it's still running
	if (_isWatchingPaths)
	{
		[self stopWatching];
	}

	pthread_mutex_destroy(&_eventsLock);
}

#pragma mark -
#pragma mark Private API

static FSEventStreamRef _create_events_stream(FSListener *watcher,
	CFArrayRef paths)
{
	FSEventStreamContext callbackInfo;

	callbackInfo.version = 0;
	callbackInfo.info    = (__bridge void *)watcher;
	callbackInfo.retain  = NULL;
	callbackInfo.release = NULL;
	callbackInfo.copyDescription = NULL;


	// IMPORTANT NOTE:
	// On copying big files it may occurs duplicate FSEvents:
	//   on copy begin and copy finish.
	// These double events will both have "Create" and "Modify" flags.
	//
	// To work around this behaviour I recommend to use zero latency and
	//   "NoDefer" flag on FSEventStream creation.
	// In this case the first event will have "Create" flag without "Modify".
	// The second event will have both "Create" and "Modify" flags.
	// You can listen only for events that have "Modify" flag, because that
	// will mean the copying finish and file exist.
	//
	// IMPORTANT NOTE 2:
	// On copying big files, watching for the second "Modify" event - is the
	// only way to determine the copying finish.
	// Watching for processes that uses that file will have no effect, because
	// defferent processes may open and close the file in undefined order.
	// "Finder" may take the file open for a long time after copy finish.
	return FSEventStreamCreate(kCFAllocatorDefault,
		&_events_callback, &callbackInfo, paths,
		kFSEventStreamEventIdSinceNow,
		0,
		kFSEventStreamCreateFlagUseCFTypes |
		kFSEventStreamCreateFlagIgnoreSelf |
		kFSEventStreamCreateFlagFileEvents |
		kFSEventStreamCreateFlagNoDefer);
}

static void _events_callback(ConstFSEventStreamRef streamRef,
	void *clientCallBackInfo,
	size_t numEvents,
	void *eventPaths,
	const FSEventStreamEventFlags eventFlags[],
	const FSEventStreamEventId eventIds[])
{
	CFArrayRef paths = (CFArrayRef)eventPaths;
	FSListener *pathWatcher = (__bridge FSListener *)clientCallBackInfo;

	for (NSUInteger i = 0; i < numEvents; i++)
	{
		CFStringRef eventPath = CFArrayGetValueAtIndex(paths, (CFIndex)i);

		// If present remove the path's trailing slash
		eventPath = _strip_trailing_slash_from_path(eventPath);

		FSEvent *event = [[FSEvent alloc]
			initWithEventId:(NSUInteger)eventIds[i]
			eventPath:(__bridge NSString *)eventPath
			eventFlags:eventFlags[i]];

		[[pathWatcher delegate] fsListener:pathWatcher eventOccurred:event];
	}
}

/**
 * If present, strips the trailing slash from the supplied string.
 *
 * @param string The string that is to be stripped
 *
 @ @return The resulting string
 */
static CFStringRef _strip_trailing_slash_from_path(CFStringRef path)
{
	NSString *string = (__bridge NSString *)path;

	NSUInteger length = [string length];

	return (length > 1 && [string hasSuffix:@"/"]) ?
		(__bridge CFStringRef)[string substringToIndex:length - 1] : path;
}

@end
