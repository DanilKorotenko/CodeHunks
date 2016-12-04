//
//  AppDelegate.m
//
//

#import "AppDelegate.h"

#import "FSListener.h"
#import "FSEvent.h"

@interface AppDelegate ()

@property(readonly) FSListener *listener;

@end

@implementation AppDelegate

- (void)dealloc
{
	_listener = nil;
}

#pragma mark -

- (void)deviceMounted:(NSNotification *)aNotification
{
	NSLog(@"device Mounted: %@", aNotification);

	NSString *mountedPath = [[aNotification userInfo] objectForKey:@"NSDevicePath"];

	[self.listener stopWatching];
	[self.listener addPathToWatch:mountedPath];
	[self.listener startWatching];
}

- (void)deviceUnmounted:(NSNotification *)aNotification
{
	NSLog(@"device Unmounted: %@", aNotification);

	NSString *unmountedPath = [[aNotification userInfo] objectForKey:@"NSDevicePath"];

	[self.listener stopWatching];
	[self.listener removeWatchedPath:unmountedPath];
	[self.listener startWatching];
}

- (void)listenAlreadyMountedDrives
{
	NSLog(@"listenAlreadyMountedDrives");

	NSArray *mountedVolumes = [[NSWorkspace sharedWorkspace]
		mountedRemovableMedia];

	[self.listener stopWatching];

	for (NSString *path in mountedVolumes)
	{
		NSLog(@"Path: %@", path);

		[self.listener addPathToWatch:path];
	}

	[self.listener startWatching];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Notification for Mountingthe USB device
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
		selector:@selector(deviceMounted:)
		name:NSWorkspaceDidMountNotification
		object: nil];

	// Notification for Un-Mountingthe USB device
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
		selector:@selector(deviceUnmounted:)
		name:NSWorkspaceDidUnmountNotification
		object:nil];

	[self listenAlreadyMountedDrives];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];

	[self.listener stopWatching];
}

#pragma mark -

- (FSListener *)listener
{
	if (_listener == nil)
	{
		_listener = [[FSListener alloc] initWithDelegate:self];
	}
	return _listener;
}

- (void)fsListener:(FSListener *)anFSListener
	eventOccurred:(FSEvent *)anEvent
{
	NSLog(@"Event occured: %@", anEvent);

	NSAlert *alert = [NSAlert alertWithMessageText:@"USB event occured."
		defaultButton:nil alternateButton:nil otherButton:nil
		informativeTextWithFormat:@"%@", [anEvent description]];

	[NSApp activateIgnoringOtherApps:YES];

	[alert runModal];
}

@end
