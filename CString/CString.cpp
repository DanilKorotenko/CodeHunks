//
//  CString.cpp
//

#include "CString.h"

#include "StringUtilities.h"

CString::CString()
{
	_string = NULL;
}

CString::CString(const wchar_t *aWideCharString)
{
    _string = CFStringCreateFromWideChar(aWideCharString);
}

CString::CString(const CString &aCString)
{
	_string = CFStringCreateCopy(kCFAllocatorDefault, aCString._string);
}

CString::~CString()
{
    if (_string)
    {
        CFRelease(_string);
		_string = NULL;
    }
}

#pragma mark Operators

CString &CString::operator=(const std::wstring aWString)
{
    if (_string)
    {
        CFRelease(_string);
		_string = NULL;
    }
    _string = CFStringCreateFromWide(aWString);
    return *this;
}

CString &CString::operator=(const wchar_t *aWString)
{
    if (_string)
    {
        CFRelease(_string);
    }
    _string = CFStringCreateFromWideChar(aWString);
    return *this;
}

void CString::operator+(const CString &aString)
{
	CString copy(*this);
	copy += aString;
}

CString &CString::operator+=(const CString &aString)
{
    if (_string)
    {
        CFRelease(_string);
    }
	_string = CFStringCreateWithFormat(kCFAllocatorDefault, NULL,
		CFSTR("%@%@"), _string, aString._string);
    return *this;
}

#pragma mark -

void CString::Format(const char *format, ...)
{
    CFStringRef formatRef = CFStringCreateWithCString(kCFAllocatorDefault,
        format, kCFStringEncodingUTF8);
    va_list argList;
    va_start(argList, format);
    _string = CFStringCreateWithFormatAndArguments(kCFAllocatorDefault, NULL,
        formatRef, argList);
	CFRelease(formatRef);
    va_end(argList);
}

const wchar_t *CString::GetString() const
{
    return WideFromCFStringRef(_string).c_str();
}

bool CString::IsEmpty()
{
    return _string == NULL ? true : CFStringGetLength(_string) == 0;
}
