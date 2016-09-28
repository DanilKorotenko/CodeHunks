//
//  DrivesMountingWatching.m
//

#ifdef _OS_MAC
// This is mac os x only file

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <CoreFoundation/CoreFoundation.h>

#include "DrivesMountingWatchingDefinitions.h"
#include "DriveMountingWatcher.h"

void MountingWatchingSetOnMountCallbackBlock(OnMountCallbackBlock callbackBlock)
{
	@autoreleasepool
	{
		[[DriveMountingWatcher sharedMountingWatcher] setOnMountBlock:callbackBlock];
	}
}

void StartMountingWatching()
{
	@autoreleasepool
	{
		[[DriveMountingWatcher sharedMountingWatcher] startWatching];
	}
}

void StopMountingWatching()
{
	@autoreleasepool
	{
		[[DriveMountingWatcher sharedMountingWatcher] stopWatching];
	}
}

#endif //_OS
