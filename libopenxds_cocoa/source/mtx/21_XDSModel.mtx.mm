.	Model

~!include/openxds.cocoa/XDSModel.h~
#ifndef OPENXDS_COCOA_XDSMODEL_H
#define OPENXDS_COCOA_XDSMODEL_H

#import  <Cocoa/Cocoa.h>
#include "openxds.cocoa.h"
#include <openxds.cocoa/XDSView.h>

@interface XDSModel : NSObject

- (id)           init;
- (void) registerView:(NSObject<XDSView>&)aView;
- (void)  notifyViews;

@end

#endif
~


~source/objective-c++/XDSModel.mm~
#include "openxds.cocoa/XDSModel.h"
#include "openxds.cocoa/XDSView.h"

@implementation XDSModel
{
	NSMutableArray* views;
}

- (id) init
{
	self = [super init];
	if ( self )
	{
		self->views = [[[NSMutableArray alloc] init] retain];
	}
	return self;
}

- (void) dealloc
{
	[self->views release];
}

- (void) registerView:(NSObject<XDSView>&)aView
{
	[self->views addObject:&aView];
}

- (void) notifyViews
{
	long max = [views count];
	for ( long i=0; i < max; i++ )
	{
		NSObject<XDSView>* view = (NSObject<XDSView>*) [self->views objectAtIndex:i];
		[view refresh];
	}
}

@end
~