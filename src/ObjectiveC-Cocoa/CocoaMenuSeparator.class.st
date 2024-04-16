"
A Cocoa menu separator. I'm also a menu item.
"
Class {
	#name : #CocoaMenuSeparator,
	#superclass : #Object,
	#category : #'ObjectiveC-Cocoa-Menus'
}

{ #category : #adding }
CocoaMenuSeparator >> addToMenu: aCocoaMenu [ 
	<ignoreNotImplementedSelectors: #(#separatorItem)>
	
	| separator |
	separator := #NSMenuItem inObjC separatorItem.
	aCocoaMenu nsMenu addItem: separator
]
