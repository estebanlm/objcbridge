"
I represent a Cocoa menu target, i.e. the ObjectiveC object that will receive the callbacks.
"
Class {
	#name : #CocoaMenuTarget,
	#superclass : #Object,
	#instVars : [
		'proxy',
		'block'
	],
	#category : #'ObjectiveC-Cocoa-Menus'
}

{ #category : #accessing }
CocoaMenuTarget >> block [

	^ block
]

{ #category : #accessing }
CocoaMenuTarget >> block: anObject [

	block := anObject
]

{ #category : #execution }
CocoaMenuTarget >> execute [
	<objCSignature: #(void ())>

	block value
]

{ #category : #accessing }
CocoaMenuTarget >> proxy [

	^ proxy
]

{ #category : #accessing }
CocoaMenuTarget >> proxy: anObject [

	proxy := anObject
]
