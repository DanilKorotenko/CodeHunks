//
//  DrivesMountingWatching.h
//

#ifndef DrivesMountingWatching_h
#define DrivesMountingWatching_h

#ifdef _OS_MAC
// This is mac os x only file

#include "DrivesMountingWatchingDefinitions.h"

extern "C" void MountingWatchingSetOnMountCallbackBlock(OnMountCallbackBlock callbackBlock);

extern "C" void StartMountingWatching();

extern "C" void StopMountingWatching();


#endif //_OS

#endif /* DrivesMountingWatching_h */
