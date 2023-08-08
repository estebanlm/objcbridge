Class {
	#name : #CocoaMenuItem,
	#superclass : #Object,
	#instVars : [
		'title',
		'action',
		'shortcut',
		'target',
		'nsTitle',
		'nsShortcut',
		'menuItem'
	],
	#category : #'ObjectiveC-Cocoa-Menus'
}

{ #category : #accessing }
CocoaMenuItem >> action: aFullBlockClosure [ 
	action := aFullBlockClosure
]

{ #category : #adding }
CocoaMenuItem >> addToMenu: aCocoaMenu [ 

	target := CocoaMenuTarget new block: action; yourself.
	ObjCProxyClass newFor: target.

	nsTitle := title asNSString.
	nsShortcut := shortcut asNSString.
	
	menuItem := aCocoaMenu nsMenu addItemWithTitle: nsTitle action: #execute asObjCSelector keyEquivalent: nsShortcut.
	menuItem setTarget: target.
	menuItem setEnabled: true.

]

{ #category : #accessing }
CocoaMenuItem >> shortcut: aString [ 
	shortcut := aString
]

{ #category : #accessing }
CocoaMenuItem >> title: aString [ 
	title := aString
]
