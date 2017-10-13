Class {
	#name : #MacOSXWindowDelegate,
	#superclass : #Object,
	#category : #ObjectiveC-Examples
}

{ #category : #example }
MacOSXWindowDelegate class >> example [
	"self example"
	| NSTitledWindowMask NSClosableWindowMask
	  NSMiniaturizableWindowMask NSResizableWindowMask
	  NSTexturedBackgroundWindowMask
	  NSBackingStoreBuffered
	  pool window delegate |
	
	NSTitledWindowMask := 1 << 0.
	NSClosableWindowMask := 1 << 1.
	NSMiniaturizableWindowMask := 1 << 2.
	NSResizableWindowMask := 1 << 3.
	NSTexturedBackgroundWindowMask := 1 << 8.
	NSBackingStoreBuffered := 2.

	pool := ('NSAutoreleasePool' inObjCFramework: 'Foundation') alloc init.

	window := ('NSWindow' inObjCFramework: 'AppKit') alloc 
			initWithContentRect: (NSRect x: 100.0 y: 100.0 width: 600.0 height: 400.0)
			styleMask: NSTitledWindowMask 
				| NSClosableWindowMask 
				| NSMiniaturizableWindowMask
				| NSResizableWindowMask 
				| NSTexturedBackgroundWindowMask
			backing: NSBackingStoreBuffered
			defer: 0 asCharacter.
	window setTitle: 'Table!' asNSString.
	window setMinSize: (NSPoint width: 500 height: 500).
	window autorelease.
	
	delegate := ObjCProxyClass newFor: self new.
	window setDelegate: delegate proxy.
	{window. delegate} inspect. "Just to prevent GC"
	window center.
	window makeKeyAndOrderFront: ObjCObject null.
	pool release.
]

{ #category : #'event handling' }
MacOSXWindowDelegate >> windowDidMove: notification [
	<objCSignature: 'v@:@'>
	
	Transcript show: 'OK!!!!'; cr.
]
