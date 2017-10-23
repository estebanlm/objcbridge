Class {
	#name : #CocoaWindowController,
	#superclass : #Object,
	#traits : 'TObjCProxyClass',
	#classTraits : 'TObjCProxyClass classTrait',
	#pools : [
		'CocoaConstants'
	],
	#category : #ObjectiveC-Cocoa
}

{ #category : #private }
CocoaWindowController class >> objCSuperclassName [
	^ 'NSWindowController'
]
