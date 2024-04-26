"
I represent an item  of a Cocoa menu.
I can hold menu items or submenus. 
"
Class {
	#name : #CocoaMenuItem,
	#superclass : #Object,
	#instVars : [
		'action',
		'shortcut',
		'title',
		'target',
		'nsTitle',
		'nsShortcut',
		'menuItem'
	],
	#category : #'ObjectiveC-Cocoa-Menus'
}

{ #category : #accessing }
CocoaMenuItem >> action: aBlock [

	action := aBlock
]

{ #category : #adding }
CocoaMenuItem >> addToMenu: aCocoaMenu [
	<ignoreNotImplementedSelectors: #(#addItemWithTitle:action:keyEquivalent: #setTarget: #setEnabled:)>

	nsTitle := title asNSString.
	nsShortcut := shortcut asNSString.

	menuItem := aCocoaMenu nsMenu 
		addItemWithTitle: nsTitle
		action: #execute asObjCSelector
		keyEquivalent: nsShortcut.

	target := CocoaMenuTarget new
		          block: action;
		          yourself.
	ObjCProxyClass newFor: target.
	menuItem setTarget: target.
	menuItem setEnabled: true

]

{ #category : #accessing }
CocoaMenuItem >> shortcut: aString [ 

	shortcut := aString
]

{ #category : #accessing }
CocoaMenuItem >> title: aString [ 

	title := aString
]
