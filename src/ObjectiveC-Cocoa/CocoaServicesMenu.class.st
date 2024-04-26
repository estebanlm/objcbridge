"
I represent the Mac os ""Services"" menu.
You can use me to add a ""Services"" entry to your app menu.
"
Class {
	#name : #CocoaServicesMenu,
	#superclass : #CocoaMenu,
	#category : #'ObjectiveC-Cocoa-Menus'
}

{ #category : #configuring }
CocoaServicesMenu >> beServicesMenu [
	<ignoreNotImplementedSelectors: #(#setServicesMenu:)>

	#NSApplication inObjC sharedApplication setServicesMenu: nsMenu
]

{ #category : #private }
CocoaServicesMenu >> buildNSMenu [
	
	nsMenu := self servicesMenu.
	nsMenu isNull 
		ifTrue: [ 
			super buildNSMenu.
			self beServicesMenu ]
		ifFalse: [ nsTitle := title asNSString ].
	^ nsMenu
]

{ #category : #initialization }
CocoaServicesMenu >> initialize [ 

	super initialize.
	title := 'Services'
]

{ #category : #accessing }
CocoaServicesMenu >> servicesMenu [
	"Get the Application services menu if set or null"

	^ #NSApplication inObjC sharedApplication servicesMenu
]
