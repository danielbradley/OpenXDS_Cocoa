,	Appendix A - XDSTree

This class implements a basic Tree datastructure for use with the NSOutlineView

,,		API

~!include/openxds.cocoa/XDSTree.h~
#import <Cocoa/Cocoa.h>

@interface XDSTreeNode : NSObject

+ (id)          newWithValue:(NSString*) aValue;
- (id)                  init;
- (void)            setValue:(NSString*) aValue;
- (XDSTreeNode*)    addChild:(NSString*) aValue;

- (NSString*)          value;
- (id)                 child:(NSInteger) index;
- (BOOL)        isExpandable;
- (NSInteger)     nrChildren;

@end

@interface XDSTree : NSObject <NSOutlineViewDataSource>

- (id)                    init;
- (void)                  node:(XDSTreeNode*)    aNode                       setValue:(NSString*)       aValue;
- (XDSTreeNode*)         addTo:(XDSTreeNode*)    aNode                        newNode:(NSString*)       aValue;
- (XDSTreeNode&)   findOrAddTo:(XDSTreeNode*)    aNode                      nodeValue:(NSString*)       aValue;

- (id)                    root;

- (id)             outlineView:(NSOutlineView*) outlineView                     child:(NSInteger)       index       ofItem: (id) item;
- (BOOL)           outlineView:(NSOutlineView*) outlineView          isItemExpandable:(id)              item;
- (NSInteger)      outlineView:(NSOutlineView*) outlineView    numberOfChildrenOfItem:(id)              item;
- (id)             outlineView:(NSOutlineView*) outlineView objectValueForTableColumn:(NSTableColumn *) tableColumn byItem: (id) item;

@end
~

,,		Tree Node

~!source/objective-c++/XDSTree.mm~
#import "openxds.cocoa/XDSTree.h"

@implementation XDSTreeNode
{
	XDSTreeNode*     parent;
	NSMutableArray* children;
	NSString*       value;
}

+ (id) newWithValue: (NSString*) aValue
{
	 self = [[XDSTreeNode alloc] init];
	[self setValue: aValue];
	return self;
}

- (id) init
{
	self = [super init];
	if ( self )
	{
		self->parent   = nil;
		self->children = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) setValue: (NSString*) aValue
{
	[self->value release];
	 self->value = [aValue retain];
}

- (XDSTreeNode*) addChild: (NSString*) aValue
{
	XDSTreeNode* node = [XDSTreeNode newWithValue: aValue];
	[self->children addObject: node];
	return node;
}


- (NSString*) value
{
	return self->value;
}

- (id) child: (NSInteger) index
{
	return [self->children objectAtIndex: index];
}

- (BOOL) isExpandable
{
	return (0 < [self->children count]);
}

- (NSInteger) nrChildren
{
	return [self->children count];
}

@end
~

,,		

~source/objective-c++/XDSTree.mm~
@implementation XDSTree
{
	XDSTreeNode*    root;
	NSTableColumn*   tc;
}

- (id) init
{
	self = [super init];
	if ( self )
	{
		self->root = nil;//[XDSTreeNode newWithValue: @"Empty"];
		self->tc   = nil;
	}
	return self;
}

- (void) node:(XDSTreeNode*) aNode setValue:(NSString*) aValue
{
	[aNode setValue: aValue];
}

- (XDSTreeNode*) addTo:(XDSTreeNode*) aNode newNode:(NSString*) aValue
{
	if ( nil == aNode )
	{
		#ifdef DEBUG_OPENXDS_COCOA
		NSLog( @"Replacing root" );
		#endif
		
		if ( self->root )
		{
			[self->root release];
			self->root = nil;
		}
		self->root = [XDSTreeNode newWithValue: aValue];
		return self->root;
	}
	else
	{
		return [aNode addChild: aValue];
	}
}

- (XDSTreeNode&) findOrAddTo:(XDSTreeNode*)aNode nodeValue:(NSString*) aValue
{
	long nr_children = [aNode nrChildren];
	for ( long i=0; i < nr_children; i++ )
	{
		if ( [[[aNode child:i]value]isEqualTo:aValue] )
		{
			return *[aNode child:i];
		}
	}
	return *[self addTo:aNode newNode:aValue];
}

- (id) root
{
	return self->root;
}

//	Implementation of NSOutlineView

- (id) outlineView:(NSOutlineView*) outlineView child:(NSInteger) index ofItem: (id) item
{
	return (nil == item) ? self->root : [item child: index];
}

- (BOOL) outlineView:(NSOutlineView*) outlineView isItemExpandable:(id) item
{
	BOOL   is_expandable = [item isExpandable];
	return is_expandable;
}

- (NSInteger) outlineView:(NSOutlineView*) outlineView numberOfChildrenOfItem:(id) item
{
	NSInteger nr = 0;
	if ( nil == item )
	{
		nr = (nil != root) ? 1 : 0;
	}
	else
	{
		nr = [item nrChildren];
	}
	return nr;
}

- (id) outlineView:(NSOutlineView*) outlineView objectValueForTableColumn:(NSTableColumn *) tableColumn byItem: (id) item
{
	NSString* value = nil;
	{
		if ( nil == self->tc ) self->tc = tableColumn;

		[tableColumn setEditable: NO];
		
		if ( self->tc == tableColumn )
		{
			value = [item value];
		} else {
			[tableColumn setHidden: YES];
		}
	}
	return value;
}


@end
~
