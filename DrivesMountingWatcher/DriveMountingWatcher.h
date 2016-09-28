//
//  DriveMountingWatcher.h
//

#import <Foundation/Foundation.h>

#import "DrivesMountingWatchingDefinitions.h"

@interface DriveMountingWatcher : NSObject
{
@private
	OnMountCallbackBlock _onMountBlock;
}

+ (id)sharedMountingWatcher;

#pragma mark -

- (void)setOnMountBlock:(OnMountCallbackBlock)aBlock;

#pragma mark -

- (void)startWatching;
- (void)stopWatching;

@end
