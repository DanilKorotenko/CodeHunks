//
//  CString.h
//

#ifndef CString_h
#define CString_h

#include <stdio.h>
#include <string>

#include <CoreFoundation/CoreFoundation.h>

class CString
{
public:

    CString();
    CString(const wchar_t *aWideCharString);
    CString(const CString &aCString);

    ~CString();

#pragma mark Operators
    CString &operator=(const std::wstring aWString);
    CString &operator=(const wchar_t *aWString);

    void operator+(const CString &aString);
    CString &operator+=(const CString &aString);

#pragma mark -
    void Format(const char *format, ...);

    const wchar_t *GetString() const;

    bool IsEmpty();

protected:
    CFStringRef _string;

};

#endif /* CString_h */
