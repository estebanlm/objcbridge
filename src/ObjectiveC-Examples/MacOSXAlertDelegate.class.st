Class {
	#name : #MacOSXAlertDelegate,
	#superclass : #Object,
	#category : #ObjectiveC-Examples
}

{ #category : #example }
MacOSXAlertDelegate >> example [
	"self example"
	| NSTitledWindowMask NSClosableWindowMask
	  NSMiniaturizableWindowMask NSResizableWindowMask
	  NSTexturedBackgroundWindowMask
	  NSBackingStoreBuffered
	  app win pool alert rc |
	
	NSTitledWindowMask := 1 << 0.
	NSClosableWindowMask := 1 << 1.
	NSMiniaturizableWindowMask := 1 << 2.
	NSResizableWindowMask := 1 << 3.
	NSTexturedBackgroundWindowMask := 1 << 8.
	NSBackingStoreBuffered := 2.

	app := (#NSApplication inObjCFramework: 'AppKit') sharedApplication.
	pool := (#NSAutoreleasePool inObjCFramework: 'Foundation') alloc init.

	win := (#NSWindow inObjCFramework: 'AppKit') alloc
		initWithContentRect: (NSRect x: 250.0 y: 150.0 width: 600.0 height: 600.0)
		styleMask: 
			NSTitledWindowMask 
			| NSClosableWindowMask 
			| NSMiniaturizableWindowMask
			| NSResizableWindowMask 
			| NSTexturedBackgroundWindowMask
		backing: NSBackingStoreBuffered
		defer: 0.
		
	win setTitle: 'Hello!' asNSString.
	alert := (#NSAlert inObjCFramework: 'AppKit')
		alertWithMessageText: 'Be Alert!' asNSString
		defaultButton: 'Lerts' asNSString
		alternateButton: 'We' asNSString
		otherButton: 'Need' asNSString
		informativeTextWithFormat: 'some %s & %@' asNSString
		_with: 'text' asAlien pointer
		_with: 'string' asNSString.

	alert 
		beginSheetModalForWindow: win
		modalDelegate: (ObjCProxyClass newFor: self new)
		didEndSelector: #alertDidEnd:returnCode:contextInfo: asObjCSelector
		contextInfo: nil.
	rc := app runModalForWindow: win.
	win close.
	pool release.
	
	^rc
]
