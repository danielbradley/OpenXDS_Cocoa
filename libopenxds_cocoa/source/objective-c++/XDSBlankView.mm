#include "openxds.cocoa/XDSBlankView.h"

@implementation XDSBlankView
{
	NSSize preferredSize;
}

- (void) refresh
{
}

- (void) setPreferredSize:(NSSize)pSize
{
	self->preferredSize = pSize;
}

- (NSSize) preferredSize:(NSSize)suggested
{
	NSSize preferred;
	
	preferred.width  = fmax( suggested.width,  self->preferredSize.width  );
	preferred.height = fmax( suggested.height, self->preferredSize.height );

	#ifdef DEBUG_XDSBLANKVIEW
	NSLog( @"XDSBlankView::preferredSize: %f:%f", preferred.width, preferred.height );
	#endif

	return preferred;
}

@end

