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
			initWithContentRect: (NSRect x: 0 y: 0 width: 600 height: 400)
			styleMask: NSTitledWindowMask 
				| NSClosableWindowMask 
				| NSMiniaturizableWindowMask
				| NSResizableWindowMask 
				| NSTexturedBackgroundWindowMask
			backing: NSBackingStoreBuffered
			defer: 0.
	window setTitle: 'Table!' asNSString.
	
	delegate := self new. 
	window setDelegate: (delegate := (ObjCProxyClass newFor: self new)).
	delegate inspect. "Just to prevent GC"
	
	window center.
	window makeKeyAndOrderFront: nil.
	pool release.
]

{ #category : #'event handling' }
MacOSXWindowDelegate >> windowDidMove: notification [
	<objCSignature: 'v@:@'>
	
	Transcript show: 'OK!!!!'; cr.
]
