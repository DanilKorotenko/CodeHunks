//
//  StringUtilities.cpp
//

#include "StringUtilities.h"

CFStringRef CFStringCreateFromWideChar(const wchar_t *aWideCharString)
{
    CFStringEncoding encoding =
        (CFByteOrderLittleEndian == CFByteOrderGetCurrent()) ?
            kCFStringEncodingUTF32LE : kCFStringEncodingUTF32BE;

    size_t widecharvarLen = wcslen(aWideCharString);

    CFStringRef result = CFStringCreateWithBytes(kCFAllocatorDefault,
        (const UInt8 *)aWideCharString,
        (widecharvarLen * sizeof(wchar_t)),
        encoding, false);

    return result;
}

CFStringRef CFStringCreateFromWide(std::wstring aWideString)
{
    CFStringRef result = CFStringCreateFromWideChar(aWideString.c_str());

    return result;
}

CFStringRef CFStringCreateFromChar(const char *aCharString)
{
    CFStringRef result = CFStringCreateWithCString(kCFAllocatorDefault,
        aCharString, kCFStringEncodingUTF8);

    return result;
}

#pragma mark -

std::wstring WideFromCFStringRef(CFStringRef aStringRef)
{
	if (aStringRef == NULL || CFStringGetLength(aStringRef) == 0)
	{
		return std::wstring();
	}

	CFStringEncoding encoding =
		(CFByteOrderLittleEndian == CFByteOrderGetCurrent()) ?
			kCFStringEncodingUTF32LE : kCFStringEncodingUTF32BE;

	CFDataRef dataRef = CFStringCreateExternalRepresentation(
		kCFAllocatorDefault, aStringRef, encoding, 0);

	std::wstring result;

	if (dataRef != NULL)
	{
		const UInt8 *dataPtr = CFDataGetBytePtr(dataRef);

		if (*dataPtr != '\0')
		{
			result = std::wstring(
				(const wchar_t *)dataPtr,
					CFDataGetLength(dataRef) / sizeof(wchar_t));
		}

		CFRelease(dataRef);
	}

	return result;
}

std::wstring CleanWideString(std::wstring aWideString)
{
	std::wstring result;

	for (int charIndex = 0; charIndex < aWideString.length(); charIndex++)
	{
		wchar_t aCharacter = aWideString[charIndex];
		if (iswgraph(aCharacter))
		{
			result += aCharacter;
		}
	}
	return result;
}

std::string StringFromCFStringRef(CFStringRef aStringRef)
{
    size_t length = CFStringGetLength(aStringRef) + 1;
    char *buffer = (char*)malloc(length);

    Boolean result = CFStringGetCString(aStringRef, buffer, length, 0);

    if (!result)
    {
		free(buffer);
        return std::string();
    }

    std::string output(buffer);

	free(buffer);

    return output;
}

char *CFStringCopyUTF8String(CFStringRef aString)
{
    if (aString == NULL)
    {
        return NULL;
    }

    CFIndex length = CFStringGetLength(aString);
    CFIndex maxSize =
        CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8) + 1;

    char *buffer = (char *)malloc(maxSize);
    if (CFStringGetCString(aString, buffer, maxSize, kCFStringEncodingUTF8))
    {
        return buffer;
    }

	free(buffer);

    return NULL;
}

std::string StringFromWideStringConstRef(const std::wstring &aWideString)
{
    std::string result;

    CFStringRef stringRef = CFStringCreateFromWide(aWideString);

    char *cString = CFStringCopyUTF8String(stringRef);
    if (NULL != cString)
    {
        result = std::string(cString);
		free(cString);
    }

	if (stringRef != NULL)
	{
		CFRelease(stringRef);
	}

    return result;
}

std::wstring WideStringFromCString(const char *aCString)
{
    CFStringRef stringRef = CFStringCreateFromChar(aCString);

    std::wstring result = WideFromCFStringRef(stringRef);

	if (stringRef != NULL)
	{
		CFRelease(stringRef);
	}

    return result;
}
