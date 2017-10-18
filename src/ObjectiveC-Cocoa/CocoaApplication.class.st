Class {
	#name : #CocoaApplication,
	#superclass : #Object,
	#classVars : [
		'Current'
	],
	#pools : [
		'CocoaConstants'
	],
	#category : #ObjectiveC-Cocoa
}

{ #category : #accessing }
CocoaApplication class >> current [
	^ Current
]

{ #category : #'class initialization' }
CocoaApplication class >> initialize [
	SessionManager default registerUserClassNamed: self name
]

{ #category : #'system startup' }
CocoaApplication class >> startUp: resuming [
	resuming ifFalse: [ ^ self ].
	Current := nil
]

{ #category : #utils }
CocoaApplication class >> withAutoreleasePoolDo: aBlock [
	| pool |
	pool := #NSAutoreleasePool inObjC alloc init.
	aBlock ensure: [ pool release ]
]

{ #category : #running }
CocoaApplication >> run [
	"sub... here put main menu, etc."
	Current := self.
	"Smalltalk at: #CocoaApp put: self."
	
]
