//
//  AppDelegate.h
//
//

#import <Cocoa/Cocoa.h>

#import "FSListenerDelegateProtocol.h"

@class FSListener;

@interface AppDelegate : NSObject <NSApplicationDelegate, FSListenerDelegate>
{
@private
	FSListener *_listener;
}

@end
