.	View

~!include/openxds.cocoa/XDSView.h~
#ifndef OPENXDS_COCOA_XDSVIEW_H
#define OPENXDS_COCOA_XDSVIEW_H

#import <Cocoa/Cocoa.h>
#import "openxds.cocoa.h"

@protocol XDSView<NSObject>

- (void) refresh;

@end

#endif
~