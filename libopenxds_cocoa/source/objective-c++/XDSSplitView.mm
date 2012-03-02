#include "openxds.cocoa/XDSSplitView.h"

@implementation XDSSplitView
{
	NSMutableArray* userSizes;
}

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

- (BOOL) isFlipped
{
	return YES;
}

- (void) addSubview:(NSView*)aView
{
	[super addSubview:aView];
	[self->userSizes addObject:[NSNumber numberWithFloat:0.0]];
}

- (void) resizeSubviewsWithOldSize:(NSSize)oldSize
{
	#ifdef DEBUG_XDSSPLITVIEW
	NSLog( @"XDSSplitView::resizeSubviewsWithOldSize" );
	#endif

	bool is_vertical = [self isVertical];

	NSSize size = [self bounds].size;
	
	float x = 0.0;
	float y = 0.0;
	float w = size.width;
	float h = size.height;
	
	NSArray* subviews = [self subviews];
	NSInteger len = [subviews count];
	for ( NSInteger i=0; i < len; i++ )
	{
		float user_size = [[self->userSizes objectAtIndex:i]floatValue];
		id view  = [subviews objectAtIndex:i];

		if ( user_size )
		{
			if ( is_vertical )
			{
				[view setFrame:NSMakeRect( x, y, user_size, h )];
				x += (user_size + [self dividerThickness]);

				size.width -= user_size;
			}
			else
			{
				[view setFrame:NSMakeRect( x, y, w, user_size )];
				y += (user_size + [self dividerThickness]);

				size.height -= user_size;
			}
		}
		else
		{
			NSSize pref;
			if ( is_vertical )
			{
				pref = [view preferredSize:NSMakeSize(0.0,h)];
				[view setFrame:NSMakeRect( x, y, pref.width, h )];
				x += (pref.width + [self dividerThickness]);

				size.width -= pref.width;
			}
			else
			{
				pref = [view preferredSize:NSMakeSize(w,0.0)];
				[view setFrame:NSMakeRect( x, y, w, pref.height )];
				y += (pref.height + [self dividerThickness]);

				size.height -= pref.height;
			}
		}
	}

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

- (void) drawRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor]set];
	
	NSRect bounds = [self bounds];
	NSRectFill( bounds );

	[super drawRect:dirtyRect];
}

- (NSColor*) dividerColor
{
	return [NSColor colorWithCalibratedRed:0.929 green:0.929 blue:0.929 alpha:1.0];
}

- (NSSize) preferredSize:(NSSize)suggested
{
	NSInteger count     = [[self subviews]count];
	NSSize    preferred = NSMakeSize(0.0,0.0);
	
	if ( [self isVertical] )
	{
		preferred.width  = ((count-1) * [self dividerThickness]) + 20.0;
		preferred.height = suggested.height;
	}
	else
	{
		preferred.width  = suggested.width;
		preferred.height = ((count-1) * [self dividerThickness]) + 20.0;
	}
	  
	for ( NSInteger i=0; i < count; i++ )
	{
		float  user_size = [[self->userSizes objectAtIndex:i]floatValue];
		id     subview   = [[self subviews]objectAtIndex:i];
		NSSize preferred_subview;

		if ( [self isVertical] )
		{
			preferred_subview  = [subview preferredSize:NSMakeSize(0.0,suggested.height)];
			preferred.height   = fmax( preferred.height, preferred_subview.height );

			if ( user_size )
			{
				preferred.width += user_size;
			} else {
				preferred.width += preferred_subview.width;
			}
		}
		else
		{
			preferred_subview  = [subview preferredSize:NSMakeSize(suggested.width,0.0)];
			preferred.width    = fmax( preferred.width, preferred_subview.width );

			if ( user_size )
			{
				preferred.height += user_size;
			} else {
				preferred.height += preferred_subview.height;
			}
		}
	}

	#ifdef DEBUG_XDSSPLITVIEW
	NSLog( @"XDSSplitView::preferredSize: %f:%f", preferred.width, preferred.height );
	#endif
	
	return preferred;
}

- (void) refresh
{
}

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

- (BOOL) splitView:(NSSplitView*) splitView shouldAdjustSizeOfSubview: (NSView*) subview
{
	#ifdef DEBUG_XDSSPLITVIEW
	NSLog( @"XDSSplitView::splitView shouldAdjustSizeOfSubview" );
	#endif
	
	return YES;
}

@end

