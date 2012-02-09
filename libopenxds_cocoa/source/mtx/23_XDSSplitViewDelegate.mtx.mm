..		Split View Delegate

This class extends the Cocoa CFSplitView class to provide some constraints on the position of the divider.

~!include/openxds.cocoa/XDSSplitViewDelegate.h~
#import <Cocoa/Cocoa.h>
~

~include/openxds.cocoa/XDSSplitViewDelegate.h~
@interface XDSSplitViewDelegate : NSObject <NSSplitViewDelegate>
{}

+ (id)   constrain: (NSView*) aView;

- (id)               init;
- (void) dontAdjustSizeOf: (NSView*) aView;

- (BOOL)                 splitView: (NSSplitView*) splitView
         shouldAdjustSizeOfSubview: (NSView*)      subview;

- (BOOL)                 splitView: (NSSplitView*) splitView
                canCollapseSubview: (NSView*)      subview;

@end
~

~!source/objective-c++/XDSSplitViewDelegate.mm~
#import "openxds.cocoa/XDSSplitViewDelegate.h"
#import "openxds.cocoa/XDSView.h"
~

~source/objective-c++/XDSSplitViewDelegate.mm~
@implementation XDSSplitViewDelegate
{
	NSView* refConstrainedView;
}
~

~source/objective-c++/XDSSplitViewDelegate.mm~
+ (id) constrain: (NSView*) aView
{
	XDSSplitViewDelegate* d = [[XDSSplitViewDelegate alloc] init];
	[d dontAdjustSizeOf: aView];
	return d;
}
~


~source/objective-c++/XDSSplitViewDelegate.mm~
- (id) init
{
	self = [super init];
	if ( self )
	{
		self->refConstrainedView = nil;
	}
	return self;
}
~

~source/objective-c++/XDSSplitViewDelegate.mm~
- (void) dontAdjustSizeOf: (NSView*) aView
{
	self->refConstrainedView = aView;
}
~

~source/objective-c++/XDSSplitViewDelegate.mm~
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
~

~source/objective-c++/XDSSplitViewDelegate.mm~
- (BOOL)                 splitView: (NSSplitView*) splitView
                canCollapseSubview: (NSView*)      subview
{
	return YES;
}
~




~source/objective-c++/XDSSplitViewDelegate.mm~
- (void) splitViewDidResizeSubviews:(NSNotification *) aNotification
{
}
~




~source/objective-c++/XDSSplitViewDelegate.mm~
@end
~
