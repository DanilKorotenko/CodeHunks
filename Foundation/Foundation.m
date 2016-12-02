//
//  Foundation.m
//

#import <Foundation/Foundation.h>

void EnumerateStringLinesWithBlock(CFStringRef aString,
	void (^block)(CFStringRef aLine))
{
	@autoreleasepool
	{
		NSArray *lines = [(NSString *)aString componentsSeparatedByCharactersInSet:
			[NSCharacterSet newlineCharacterSet]];
		[lines enumerateObjectsUsingBlock:
			^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
			{
				block((CFStringRef)obj);
			}];
	}
}

