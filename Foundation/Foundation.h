//
//  Foundation.h
//

#ifndef Foundation_h
#define Foundation_h

#include <CoreFoundation/CoreFoundation.h>

extern "C" void EnumerateStringLinesWithBlock(CFStringRef aString,
	void (^block)(CFStringRef aLine));

#endif /* Foundation_h */
