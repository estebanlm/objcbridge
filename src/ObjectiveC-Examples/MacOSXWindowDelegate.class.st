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

	pool := 'NSAutoreleasePool' inObjC alloc init.

	window := 'NSWindow' inObjC alloc 
			initWithContentRect: (NSRect x: 0.0 y: 0.0 width: 600.0 height: 400.0)
			styleMask: NSTitledWindowMask 
				| NSClosableWindowMask 
				| NSMiniaturizableWindowMask
				| NSResizableWindowMask 
				| NSTexturedBackgroundWindowMask
			backing: NSBackingStoreBuffered
			defer: 0 asCharacter.
	window setTitle: 'Table!' asNSString.
	window autorelease.
	
	delegate := ObjCProxyClass newFor: self new.
	window setDelegate: delegate proxy.
	{window. delegate} inspect. "Just to prevent GC"
	window center.
	window makeKeyAndOrderFront: ObjCObject null.
	pool release
]

{ #category : #'event handling' }
MacOSXWindowDelegate >> windowDidMove: notification [
	<objCSignature: #(void (id notification))>
	
	Transcript show: 'OK!!!!'; cr.
]
