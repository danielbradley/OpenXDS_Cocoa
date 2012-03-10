.	XDS Web View

~!include/openxds.cocoa/XDSWebView.h~
#ifndef OPENXDS_COCOA_XDSWEBVIEW_H
#define OPENXDS_COCOA_XDSWEBVIEW_H

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "openxds.cocoa.h"
#import "openxds.cocoa/XDSView.h"

@interface XDSWebView : WebView<XDSView>

- (id)      initWithFrame:(NSRect)frame;
- (void) setPreferredSize:(NSSize)pSize;
- (void) resize;

//	XDSView
- (void)         refresh;
- (NSSize) preferredSize:(NSSize)unused;

@end

#endif
~


~!source/objective-c++/XDSWebView.mm~
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
~