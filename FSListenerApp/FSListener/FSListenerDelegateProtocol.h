//
//  FSListenerDelegateProtocol.h
//
//

#ifndef FSListenerDelegateProtocol_h
#define FSListenerDelegateProtocol_h

@class FSListener;
@class FSEvent;

@protocol FSListenerDelegate

- (void)fsListener:(FSListener *)anFSListener eventOccurred:(FSEvent *)event;

@end

#endif /* FSListenerDelegateProtocol_h */
