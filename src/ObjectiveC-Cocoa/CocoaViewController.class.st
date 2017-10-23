Class {
	#name : #CocoaViewController,
	#superclass : #ObjCProxyObject,
	#pools : [
		'CocoaConstants'
	],
	#category : #ObjectiveC-Cocoa
}

{ #category : #private }
CocoaViewController class >> objCSuperclassName [
	^ 'NSViewController'
]

{ #category : #'as yet unclassified' }
CocoaViewController >> subviewWithIdentifier: aString in: view [
	^ self 
		subviewWithIdentifierNSString: aString asNSString autoRelease
		in: view
]

{ #category : #'as yet unclassified' }
CocoaViewController >> subviewWithIdentifierNSString: identifier in: view [
	| subviews count traversed |
	
	traversed := OrderedCollection new.
	subviews := view subviews.
	count := subviews count.
	0 to: count - 1 do: [ :index | | subview |
		subview := subviews objectAtIndex: index.
		(subview identifier compare: identifier) = NSOrderedSame
			ifTrue: [ ^ subview ].
		traversed add: subview ].
	"not found, look in subviews"
	traversed do: [ :eachSubview |
		(self subviewWithIdentifierNSString: identifier in: eachSubview)
			ifNotNil: [ :aSubview | ^ aSubview ] ].
		
	^ nil
]

{ #category : #'as yet unclassified' }
CocoaViewController >> subviewWithTag: aNumber in: view [
	^ view viewWithTag: aNumber
]
