//
//  DriveMountingWatcher.m
//

#import "DriveMountingWatcher.h"

#import <AppKit/AppKit.h>

////////////////////////////////////////////////////////////////////////////////
// Static variables
static DriveMountingWatcher *sharedMountingWatcher = nil;

////////////////////////////////////////////////////////////////////////////////
// Class implementation
@implementation DriveMountingWatcher

#pragma mark Singleton Methods

+ (id)sharedMountingWatcher
{
	@synchronized(self)
	{
		if(sharedMountingWatcher == nil)
		{
			sharedMountingWatcher = [[super allocWithZone:NULL] init];
		}
	}
	return sharedMountingWatcher;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self sharedMountingWatcher] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (NSUInteger)retainCount
{
	return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release
{
	// never release
}

- (id)autorelease
{
	return self;
}

- (id)init
{
	if (self = [super init])
	{

	}
	return self;
}

- (void)dealloc
{
	Block_release(_onMountBlock);

	[super dealloc];
}

#pragma mark -

- (void)setOnMountBlock:(OnMountCallbackBlock)aBlock
{
	_onMountBlock = Block_copy(aBlock);
}

#pragma mark -

- (void)startWatching
{
	// Notification for Mounting the USB device
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
        selector:@selector(deviceMounted:)
        name:NSWorkspaceDidMountNotification
        object: nil];

    // Notification for Un-Mounting the USB device
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
        selector:@selector(deviceUnmounted:)
        name:NSWorkspaceDidUnmountNotification
        object:nil];
}

- (void)stopWatching
{
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
}

#pragma mark -

- (void)deviceMounted:(NSNotification *)aNotification
{
    NSLog(@"device Mounted: %@", aNotification);

    NSString *mountedPath = [[aNotification userInfo] objectForKey:@"NSDevicePath"];

	_onMountBlock((CFStringRef)mountedPath);
}

- (void)deviceUnmounted:(NSNotification *)aNotification
{
    NSLog(@"device Unmounted: %@", aNotification);

//    NSString *unmountedPath = [[aNotification userInfo] objectForKey:@"NSDevicePath"];

}

@end
