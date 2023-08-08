Class {
	#name : #CocoaMenu,
	#superclass : #Object,
	#instVars : [
		'nsMenu',
		'title',
		'nsTitle',
		'items',
		'menuItem'
	],
	#classVars : [
		'MainMenu'
	],
	#category : #'ObjectiveC-Cocoa-Menus'
}

{ #category : #adding }
CocoaMenu >> addItemWithTitle: aString action: aFullBlockClosure [ 
	
	^ self addItemWithTitle: aString action: aFullBlockClosure shortcut: ''
]

{ #category : #adding }
CocoaMenu >> addItemWithTitle: aTitle action: actionBlock shortcut: shortcutString [ 
	
	items add: (CocoaMenuItem new
						title: aTitle;
						action: actionBlock;
						shortcut: shortcutString;
						yourself)
]

{ #category : #adding }
CocoaMenu >> addSubmenu: aTitle with: builderBlock [ 
	
	| m |
	m := self class new.
	m title: aTitle.
	builderBlock value: m.
	items add: m.
	^ m
]

{ #category : #adding }
CocoaMenu >> addToMenu: aCocoaMenu [ 
	
	self buildNSMenu.
	
	menuItem := aCocoaMenu nsMenu addItemWithTitle: nsTitle action: ObjCObject nil keyEquivalent:'' asNSString.
	
	aCocoaMenu nsMenu setSubmenu: nsMenu forItem: menuItem.

]

{ #category : #building }
CocoaMenu >> buildNSMenu [
	
	nsTitle := title asNSString.
	nsMenu := #NSMenu inObjC alloc initWithTitle: nsTitle.
	
	items do: [ :i | i addToMenu: self ].
	
	^ nsMenu
]

{ #category : #initialization }
CocoaMenu >> initialize [ 
	
	super initialize.
	items := OrderedCollection new
]

{ #category : #accessing }
CocoaMenu >> nsMenu [
	^ nsMenu
]

{ #category : #initialization }
CocoaMenu >> setAsMainMenu [
	
	self buildNSMenu.
	#NSApplication inObjC sharedApplication setMainMenu: nsMenu.

	MainMenu := self
]

{ #category : #accessing }
CocoaMenu >> title: aString [ 
	title := aString
]
