
.	XDSSplitView

~!include/openxds.cocoa/XDSSplitView.h~
#ifndef OPENXDS_COCOA_XDSSPLITVIEW_H
#define OPENXDS_COCOA_XDSSPLITVIEW_H

#import  <Cocoa/Cocoa.h>
#include "openxds.cocoa.h"
#include "openxds.cocoa/XDSView.h"

@interface XDSSplitView : NSSplitView<XDSView,NSSplitViewDelegate>

- (id)                     initWithFrame:(NSRect)frame;
- (void) changeUserSizeDueToMovedDivider:(NSInteger)index;
- (void)                  resetUserSizes;
- (void)                          resize;

//	NSView
- (BOOL)                       isFlipped;
- (void)                      addSubview:(NSView*)aView;
- (void)       resizeSubviewsWithOldSize:(NSSize)oldSize;
- (void)                        drawRect:(NSRect)dirtyRect;

//	NSSplitView
- (NSColor*)                dividerColor;

//	XDSView
- (NSSize)                 preferredSize:(NSSize)suggested;
- (void)                         refresh;

//	NSSplitViewDelegate
- (void)      splitViewDidResizeSubviews:(NSNotification *) aNotification;
- (BOOL)                       splitView:(NSSplitView*)splitView shouldAdjustSizeOfSubview:(NSView*) subview;

@end

#endif
~




~source/objective-c++/XDSSplitView.mm~
#include "openxds.cocoa/XDSSplitView.h"
~




~source/objective-c++/XDSSplitView.mm~
@implementation XDSSplitView
{
	NSMutableArray* userSizes;
}
~




~source/objective-c++/XDSSplitView.mm~
- (id) initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self->userSizes = [[NSMutableArray alloc]init];
		
		[self setAutoresizesSubviews:YES];
		[self            setDelegate:self];
	}
	return self;
}
~




~source/objective-c++/XDSSplitView.mm~
- (void) resetUserSizes
{
	[self->userSizes release];
	self->userSizes = [[NSMutableArray alloc]init];
}
~




~source/objective-c++/XDSSplitView.mm~
- (void) changeUserSizeDueToMovedDivider:(NSInteger)index
{
	id    view = [[self subviews]objectAtIndex:index];
	float size = 0.0;
	
	if ( [self isVertical] )
	{
		size = [view frame].size.width;
	}
	else
	{
		size = [view frame].size.height;
	}

	[self->userSizes replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:size]];
}
~




~source/objective-c++/XDSSplitView.mm~
- (void) resize
{
	#ifdef DEBUG_XDSSPLITVIEW
	NSLog( @"XDSSplitView::resize" );
	#endif
	
	[self setFrameSize:[self preferredSize:[self frame].size]];
	[self setNeedsDisplay:YES];

	SEL resize_selector = @selector(resize);
	Class superview_class = [[self superview] class];
	
	if ( [superview_class respondsToSelector:resize_selector] )
	{
		NSLog( @"\t calling [supeview resize]" );
		id superview = [self superview];
		[superview resize];
	}
	else
	{
		//	This does not seem to be needed.
		//[self setNeedsDisplayInRect:[self bounds]];
		[[self superview]setNeedsDisplay:YES];
	}
}
~




NSView

~source/objective-c++/XDSSplitView.mm~
- (BOOL) isFlipped
{
	return YES;
}
~




~source/objective-c++/XDSSplitView.mm~
- (void) addSubview:(NSView*)aView
{
	[super addSubview:aView];
	[self->userSizes addObject:[NSNumber numberWithFloat:0.0]];
}
~




~source/objective-c++/XDSSplitView.mm~
- (void) resizeSubviewsWithOldSize:(NSSize)oldSize
{
	#ifdef DEBUG_XDSSPLITVIEW
	NSLog( @"XDSSplitView::resizeSubviewsWithOldSize" );
	#endif

	id subviews = [self subviews];
	long last   = [subviews count] - 1;

	NSRect frame     = [self frame];
	NSRect bounds    = [self bounds];
	NSSize suggested = frame.size;
	NSSize none      = NSMakeSize(0,0);
	
	float x = 0;
	float y = 0;
	float w = frame.size.width;
	float h = frame.size.height;
	float d = [self dividerThickness];

	if ( [self isVertical] )
	{
		for ( long i=0; i < last; i++ )
		{
			id subview = [subviews objectAtIndex:i];
			
			float user_size = [[self->userSizes objectAtIndex:i]floatValue];
			float width     = user_size ? user_size : [subview preferredSize:none].width;

			[subview setFrame:NSMakeRect( x, y, width, h )];
			
			suggested.width -= (width + d);
			              x += (width + d);
		}
		id subview = [subviews objectAtIndex:last];
		[subview setFrame:NSMakeRect( x, y, suggested.width, h )];
	}
	else
	{
		for ( long i=0; i < last; i++ )
		{
			id subview = [subviews objectAtIndex:i];
			
			float user_size = [[self->userSizes objectAtIndex:i]floatValue];
			float height    = user_size ? user_size : [subview preferredSize:none].height;

			[subview setFrame:NSMakeRect( x, y, w, height )];
			
			suggested.height -= (height + d);
			               y += (height + d);
		}
		id subview = [subviews objectAtIndex:last];
		[subview setFrame:NSMakeRect( x, y, w, suggested.height )];
	}
	
//	NSInteger len = [subviews count];
//	for ( NSInteger i=0; i < len; i++ )
//	{
//		float user_size = [[self->userSizes objectAtIndex:i]floatValue];
//		id view  = [subviews objectAtIndex:i];
//
//		if ( user_size )
//		{
//			if ( is_vertical )
//			{
//				[view setFrame:NSMakeRect( x, y, user_size, h )];
//				x += (user_size + [self dividerThickness]);
//
//				size.width -= user_size;
//			}
//			else
//			{
//				[view setFrame:NSMakeRect( x, y, w, user_size )];
//				y += (user_size + [self dividerThickness]);
//
//				size.height -= user_size;
//			}
//		}
//		else
//		{
//			NSSize pref;
//			if ( is_vertical )
//			{
//				pref = [view preferredSize:NSMakeSize(0.0,h)];
//				[view setFrame:NSMakeRect( x, y, pref.width, h )];
//				x += (pref.width + [self dividerThickness]);
//
//				size.width -= pref.width;
//			}
//			else
//			{
//				pref = [view preferredSize:NSMakeSize(w,0.0)];
//				[view setFrame:NSMakeRect( x, y, w, pref.height )];
//				y += (pref.height + [self dividerThickness]);
//
//				size.height -= pref.height;
//			}
//		}
//	}

//	Does not fix the bounds problem.
//	And causes a new problem with expanding width.

//	id view  = [subviews objectAtIndex:(len-1)];
//	if ( is_vertical )
//	{
//		[view setFrame:NSMakeRect( x, y, size.width, h )];
//	}
//	else
//	{
//		[view setFrame:NSMakeRect( x, y, w, size.height )];
//	}
}
~




~source/objective-c++/XDSSplitView.mm~
- (void) drawRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor]set];
	
	NSRect bounds = [self bounds];
	NSRectFill( bounds );

	[super drawRect:dirtyRect];
}
~




NSSplitView methods

~source/objective-c++/XDSSplitView.mm~
- (NSColor*) dividerColor
{
	return [NSColor colorWithCalibratedRed:0.929 green:0.929 blue:0.929 alpha:1.0];
}
~




XDSView protocol methods





~source/objective-c++/XDSSplitView.mm~
- (NSSize) preferredSize:(NSSize)suggested
{
	NSSize    none      = NSMakeSize(0,0);
	NSSize    preferred = none;
	NSInteger last      = [[self subviews]count] - 1;
	float     dividers  = [self dividerThickness]*last;

	if ( [self isVertical] )
	{
		preferred.width  = dividers;
		suggested.width -= dividers;
	}
	else
	{
		preferred.height  = dividers;
		suggested.height -= dividers;
	}
	  
	if ( [self isVertical] )
	{
		for ( NSInteger i=0; i < last; i++ )
		{
			float  user_size     = [[self->userSizes objectAtIndex:i]floatValue];
			BOOL   has_user_size = (0.0 != user_size);
			id     subview       = [[self subviews]objectAtIndex:i];

			NSSize preferred_subview = [subview preferredSize:none];

			float width = has_user_size ? user_size : preferred_subview.width;

			preferred.width  += width;
			suggested.width  -= width;
			preferred.height  = fmax( preferred.height, preferred_subview.height );
		}
		
		if ( 0 <= last )
		{
			id     subview           = [[self subviews]objectAtIndex:last];
			NSSize preferred_subview = [subview preferredSize:suggested];

			preferred.width  += preferred_subview.width;
			preferred.height  = fmax( preferred.height, preferred_subview.height );
		}
	}
	else
	{
		for ( NSInteger i=0; i < last; i++ )
		{
			float  user_size     = [[self->userSizes objectAtIndex:i]floatValue];
			BOOL   has_user_size = (0.0 != user_size);
			id     subview       = [[self subviews]objectAtIndex:i];

			NSSize preferred_subview = [subview preferredSize:none];

			float height = has_user_size ? user_size : preferred_subview.height;

			preferred.width   = fmax( preferred.width, preferred_subview.width );
			preferred.height += height;
			suggested.height -= height;
		}

		if ( 0 <= last )
		{
			id     subview           = [[self subviews]objectAtIndex:last];
			NSSize preferred_subview = [subview preferredSize:suggested];

			preferred.width   = fmax( preferred.width, preferred_subview.width );
			preferred.height += preferred_subview.height;
		}
	}

	#ifdef DEBUG_XDSSPLITVIEW
	NSLog( @"XDSSplitView::preferredSize: %f:%f", preferred.width, preferred.height );
	#endif
	
	return preferred;
}
~




~source/objective-c++/XDSSplitView.mm~
- (void) refresh
{
}
~




NSSplitViewDelegate methods

~source/objective-c++/XDSSplitView.mm~
- (void) splitViewDidResizeSubviews:(NSNotification *) aNotification
{
	#ifdef DEBUG_XDSSPLITVIEW
	NSLog( @"________________________________________" );
	NSLog( @"XDSSplitView::splitViewDidResizeSubviews" );
	#endif

	NSNumber* number = (NSNumber*) [[aNotification userInfo] objectForKey: @"NSSplitViewDividerIndex"];
	NSInteger i = [number integerValue];

	if ( [[self subviews]count] )
	{
		#ifdef DEBUG_XDSSPLITVIEW
		if ( [self isVertical] )
		{
			NSLog( @"\t moved divider:%li width: %f", i, [[[self subviews] objectAtIndex:i]frame].size.width );
		}
		else
		{
			NSLog( @"\t moved divider:%li height: %f", i, [[[self subviews] objectAtIndex:i]frame].size.height );
		}
		#endif

		[self changeUserSizeDueToMovedDivider:i];
		[self resize];
	}
}
~




~source/objective-c++/XDSSplitView.mm~
- (BOOL) splitView:(NSSplitView*) splitView shouldAdjustSizeOfSubview: (NSView*) subview
{
	#ifdef DEBUG_XDSSPLITVIEW
	NSLog( @"XDSSplitView::splitView shouldAdjustSizeOfSubview" );
	#endif
	
	return YES;
}
~




~source/objective-c++/XDSSplitView.mm~
@end
~




