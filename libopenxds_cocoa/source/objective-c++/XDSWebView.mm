#include "openxds.cocoa/XDSWebView.h"

@implementation XDSWebView
{
	NSSize preferredSize;
}

- (id) initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame frameName:nil groupName:nil];
	if ( self )
	{
	}
	return self;
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

	return preferred;
}

- (void) resize
{
//	self->preferredSize = [[[[self mainFrame] webFrame]frameView]frame].size;
}

@end

