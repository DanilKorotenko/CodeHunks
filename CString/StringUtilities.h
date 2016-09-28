//
//  StringUtilities.hpp
//

#ifndef StringUtilities_h
#define StringUtilities_h

#include <stdio.h>
#include <string>

#include <CoreFoundation/CoreFoundation.h>

CFStringRef CFStringCreateFromWide(std::wstring aWideString);
CFStringRef CFStringCreateFromWideChar(const wchar_t *aWideCharString);
CFStringRef CFStringCreateFromChar(const char *aCharString);

std::wstring WideFromCFStringRef(CFStringRef aStringRef);
std::wstring CleanWideString(std::wstring aWideString);
std::wstring WideStringFromCString(const char *aCString);

std::string StringFromCFStringRef(CFStringRef aStringRef);
std::string StringFromWideStringConstRef(const std::wstring &aWideString);

char *CFStringCopyUTF8String(CFStringRef aString);

#endif /* StringUtilities_h */
