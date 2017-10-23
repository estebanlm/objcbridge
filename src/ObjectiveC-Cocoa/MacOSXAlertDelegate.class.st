Class {
	#name : #MacOSXAlertDelegate,
	#superclass : #Object,
	#instVars : [
		'proxy'
	],
	#category : #ObjectiveC-Cocoa-Examples
}

{ #category : #example }
MacOSXAlertDelegate class >> example [
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

	app := #NSApplication inObjC sharedApplication.
	pool := #NSAutoreleasePool inObjC alloc init.

	win := #NSWindow inObjC alloc
		initWithContentRect: (250.0@150.0 extent: 600.0@600.0) asNSRect
		styleMask: 
			NSTitledWindowMask 
			| NSClosableWindowMask 
			| NSMiniaturizableWindowMask
			| NSResizableWindowMask 
			| NSTexturedBackgroundWindowMask
		backing: NSBackingStoreBuffered
		defer: 0.
		
	win setTitle: 'Hello!' asNSString.
	alert := #NSAlert inObjC alloc init
		setMessageText: 'Be Alert!' asNSString;
		setInformativeText: 'some string' asNSString;
		addButtonWithTitle: 'Lerts' asNSString;
		addButtonWithTitle: 'We' asNSString;
		addButtonWithTitle: 'Need' asNSString;
		yourself.

	alert 
		beginSheetModalForWindow: win
		modalDelegate: (ObjCProxyClass newFor: self new) proxy
		didEndSelector: #alertDidEnd:returnCode:contextInfo: asObjCSelector
		contextInfo: ExternalAddress null.

	rc := app runModalForWindow: win.
	win close.
	pool release.
	
	^rc
]

{ #category : #example }
MacOSXAlertDelegate class >> exampleModal [
	"self example"
	| app win pool alert rc |
	
	pool := #NSAutoreleasePool inObjC alloc init.

	alert := #NSAlert inObjC alloc init
		setMessageText: 'Be Alert!' asNSString;
		setInformativeText: 'some string' asNSString;
		addButtonWithTitle: 'Cancel' asNSString;
		addButtonWithTitle: 'Ok' asNSString;
		yourself.

	rc := alert runModal.

	pool release.
	
	^rc
]

{ #category : #example }
MacOSXAlertDelegate class >> exampleWithFunction [
	"self example"
	| NSTitledWindowMask NSClosableWindowMask
	  NSMiniaturizableWindowMask NSResizableWindowMask
	  NSTexturedBackgroundWindowMask
	  NSBackingStoreBuffered
	  app win pool alert rc function |
	
	NSTitledWindowMask := 1 << 0.
	NSClosableWindowMask := 1 << 1.
	NSMiniaturizableWindowMask := 1 << 2.
	NSResizableWindowMask := 1 << 3.
	NSTexturedBackgroundWindowMask := 1 << 8.
	NSBackingStoreBuffered := 2.

	app := #NSApplication inObjC sharedApplication.
	pool := #NSAutoreleasePool inObjC alloc init.

	win := #NSWindow inObjC alloc
		initWithContentRect: (250.0@150.0 extent: 600.0@600.0) asNSRect
		styleMask: 
			NSTitledWindowMask 
			| NSClosableWindowMask 
			| NSMiniaturizableWindowMask
			| NSResizableWindowMask 
			| NSTexturedBackgroundWindowMask
		backing: NSBackingStoreBuffered
		defer: 0.
	win setTitle: 'Hello!' asNSString.

	alert := #NSAlert inObjC alloc init
		setMessageText: 'Be Alert!' asNSString;
		setInformativeText: 'some string' asNSString;
		addButtonWithTitle: 'Cancel' asNSString;
		addButtonWithTitle: 'Ok' asNSString;
		yourself.

	alert 
		beginSheetModalForWindow: win
		completionHandler: (function := FFICallback 
			signature: #(void (int result)) 
			block: [ :args |
				Transcript crShow: 'OK!'.
				app stopModalWithCode: 1000 ]).

	{win. alert. function} inspect. 
	rc := app runModalForWindow: win.
	win close.
	pool release.
	
	^rc
]

{ #category : #'event handling' }
MacOSXAlertDelegate >> alertDidEnd: alert  returnCode: returnCode contextInfo: contextInfo [
	<objCSignature: #(void (id alert, int returnCode, void* contextInfo))>

	#NSApplication inObjC sharedApplication stopModalWithCode: returnCode
]

{ #category : #accessing }
MacOSXAlertDelegate >> proxy [
	^ proxy
]
