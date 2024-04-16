"
I represent an item of a Cocoa Menu.
I can hold items or submenus.
"
Class {
	#name : #CocoaMenu,
	#superclass : #Object,
	#instVars : [
		'nsMenu',
		'items',
		'title',
		'nsTitle',
		'menuItem'
	],
	#classVars : [
		'MainMenu'
	],
	#category : #'ObjectiveC-Cocoa-Menus'
}

{ #category : #'instance creation' }
CocoaMenu class >> with: aNSMenu [

	^ self new
		setMenu: aNSMenu;
		yourself
]

{ #category : #adding }
CocoaMenu >> addItemWithTitle: aString action: aBlock [ 
	
	^ self addItemWithTitle: aString action: aBlock shortcut: ''
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
CocoaMenu >> addSeparator [

	items add: CocoaMenuSeparator new
]

{ #category : #adding }
CocoaMenu >> addServicesMenu [

	items add: CocoaServicesMenu new
]

{ #category : #adding }
CocoaMenu >> addSubmenu: aTitle with: builderBlock [ 
	
	| menu |
	menu := self class new.
	menu title: aTitle.
	builderBlock value: menu.
	items add: menu.
	^ menu
]

{ #category : #private }
CocoaMenu >> addToMenu: aCocoaMenu [
	<ignoreNotImplementedSelectors: #(#addItemWithTitle:action:keyEquivalent: #setSubmenu:forItem:)>

	self buildNSMenu.
	menuItem := aCocoaMenu nsMenu 
		addItemWithTitle: nsTitle
		action: ObjCObject nil
		keyEquivalent: '' asNSString.
	
	aCocoaMenu nsMenu setSubmenu: nsMenu forItem: menuItem.

]

{ #category : #configuring }
CocoaMenu >> beMainMenu [

	self buildNSMenu.
	#NSApplication inObjC sharedApplication setMainMenu: nsMenu.
	MainMenu := self
]

{ #category : #private }
CocoaMenu >> buildNSMenu [
	<ignoreNotImplementedSelectors: #(#initWithTitle:)>
	
	nsTitle := (title ifNil: [ '' ]) asNSString.
	nsMenu := #NSMenu inObjC alloc initWithTitle: nsTitle.
	items do: [ :item | item addToMenu: self ].
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

{ #category : #printing }
CocoaMenu >> printOn: aStream [
	aStream << self class name << '(' << (title ifNil: [ '' ]) << ')'
]

{ #category : #removing }
CocoaMenu >> removeAllItems [

	nsMenu removeAllItems.
	
	self flag: 'TODO: release ObjC menu items'.
	items := OrderedCollection new.
	
]

{ #category : #private }
CocoaMenu >> setMenu: aNSMenu [

	nsMenu := aNSMenu
]

{ #category : #accessing }
CocoaMenu >> title: aString [ 

	title := aString
]
