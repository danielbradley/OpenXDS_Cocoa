#import "openxds.cocoa/XDSSplitViewDelegate.h"
#import "openxds.cocoa/XDSView.h"

@implementation XDSSplitViewDelegate
{
	NSView* refConstrainedView;
}

+ (id) constrain: (NSView*) aView
{
	XDSSplitViewDelegate* d = [[XDSSplitViewDelegate alloc] init];
	[d dontAdjustSizeOf: aView];
	return d;
}

- (id) init
{
	self = [super init];
	if ( self )
	{
		self->refConstrainedView = nil;
	}
	return self;
}

- (void) dontAdjustSizeOf: (NSView*) aView
{
	self->refConstrainedView = aView;
}

- (BOOL)                 splitView: (NSSplitView*) splitView
         shouldAdjustSizeOfSubview: (NSView*)      subview
{
	if ( subview == refConstrainedView )
	{
		return NO;
	} else {
		return YES;
	}
}

- (BOOL)                 splitView: (NSSplitView*) splitView
                canCollapseSubview: (NSView*)      subview
{
	return YES;
}

- (void) splitViewDidResizeSubviews:(NSNotification *) aNotification
{
}

@end

