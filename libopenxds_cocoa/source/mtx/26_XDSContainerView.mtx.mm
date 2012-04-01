.	View

~!include/openxds.cocoa/XDSContainerView.h~
#ifndef OPENXDS_COCOA_XDSCONTAINERVIEW_H
#define OPENXDS_COCOA_XDSCONTAINERVIEW_H

#import <Cocoa/Cocoa.h>
#import "openxds.cocoa.h"
#import "openxds.cocoa/XDSView.h"

@interface XDSContainerView : NSView<XDSView>

- (id)                 initWithFrame:(NSRect)frame;
- (void)           setVerticalLayout:(BOOL)vertical;
- (void)                     refresh;
- (void)                      resize;
- (NSSize)             preferredSize:(NSSize)unused;
- (void)   resizeSubviewsWithOldSize:(NSSize)oldSize;
- (BOOL)                   isFlipped;


@end

#endif
~


~!source/objective-c++/XDSContainerView.mm~
#include "openxds.cocoa/XDSContainerView.h"

@implementation XDSContainerView
{
	BOOL      isVertical;
}

- (id) initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self->isVertical = FALSE;
		
		[self setAutoresizingMask:NSViewNotSizable];
		[self setAutoresizesSubviews:YES];
	}
	return self;
}

- (void) setVerticalLayout:(BOOL)vertical
{
	self->isVertical = vertical;
}

- (void) refresh
{
	[self resize];
//	[self resizeSubviewsWithOldSize:NSMakeSize(0,0)];
}

- (void) resize
{
	NSSize super_size = [[self superview]frame].size;
	NSSize preferred  = [self preferredSize:super_size];

	[self setFrameSize:preferred];
}

- (NSSize) preferredSize:(NSSize)suggested
{
	id   array = [self subviews];
	long len   = [array   count];

	#ifdef DEBUG_OPENXDS_COCOA_XDSCONTAINER_H
	NSLog( @"XDSContainer::preferredSize" );
	#endif

	NSSize preferred = suggested;

	if ( self->isVertical )
	{
		suggested.height = 0.0;
		preferred.height = 0.0;
	
		for ( long i=0; i < len; i++ )
		{
			NSSize child_preferred = [[array objectAtIndex:i] preferredSize:suggested];
			
			preferred.height += child_preferred.height;
			preferred.width   = fmax( preferred.width, child_preferred.width );
		}
	}
	else
	{
		suggested.width = 0.0;
		preferred.width = 0.0;
	
		for ( long i=0; i < len; i++ )
		{
			NSSize child_preferred = [[array objectAtIndex:i] preferredSize:suggested];
			
			preferred.width += child_preferred.width;
			preferred.height = fmax( preferred.height, child_preferred.height );
		}
	}

	return preferred;
}

- (void) resizeSubviewsWithOldSize:(NSSize)oldSize
{
	id   array = [self subviews];
	long len   = [array   count];

	#ifdef DEBUG_OPENXDS_COCOA_XDSCONTAINER_H
	NSLog( @"XDSContainer::resizeSubviewsWithOldSize" );
	#endif
	
	NSRect frame = [self frame];

	float x = frame.origin.x;
	float y = frame.origin.y;
	float w = frame.size.width;
	float h = frame.size.height;
	//float l = self->isVertical ? frame.size.height : frame.size.width;

	if ( self->isVertical )
	{
		NSSize suggested = NSMakeSize( w, 0.0 );

		for ( long i=0; i < len; i++ )
		{
			id     child           = [array objectAtIndex:i];
			NSSize child_preferred = [child preferredSize:suggested];

			[child setFrame:NSMakeRect( x, y, w, child_preferred.height )];
			[child setNeedsDisplay:YES];

			y += child_preferred.height;
			//l -= child_preferred.height;
		}
		
		//l = fmax( l, 20.0 );
		//[[array objectAtIndex:(len-1)]setFrame:NSMakeRect( x, y, w, l )];
	}
	else
	{
		NSSize suggested = NSMakeSize( 0.0, h );

		for ( long i=0; i < len; i++ )
		{
			id     child           = [array objectAtIndex:i];
			NSSize child_preferred = [child preferredSize:suggested];

			[child setFrame:NSMakeRect( x, y, child_preferred.width, h )];
			[child setNeedsDisplay:YES];

			x += child_preferred.width;
			//l -= child_preferred.width;
		}

		//l = fmax( l, 20.0 );
		//[[array objectAtIndex:(len-1)]setFrame:NSMakeRect( x, y, l, h )];
	}
}

- (BOOL) isFlipped
{
	return YES;
}

@end
~