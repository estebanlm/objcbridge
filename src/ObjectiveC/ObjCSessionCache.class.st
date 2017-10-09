"
I'm a cache of elements created in ObjC side.
I keep selectors, classes, and shadow methods created.
"
Class {
	#name : #ObjCSessionCache,
	#superclass : #Object,
	#instVars : [
		'selectors',
		'methods',
		'classes'
	],
	#classVars : [
		'Current'
	],
	#category : #ObjectiveC-Core
}

{ #category : #accessing }
ObjCSessionCache class >> current [
	^ Current ifNil: [ Current := self basicNew initialize ]
]

{ #category : #'class initialization' }
ObjCSessionCache class >> initialize [ 
	SessionManager default registerUserClassNamed: self name
]

{ #category : #'instance creation' }
ObjCSessionCache class >> new [
	self error: 'Use #current'
]

{ #category : #'system startup' }
ObjCSessionCache class >> shutDown: quitting [
	quitting ifFalse: [ ^ self ].
	Current := nil
]

{ #category : #accessing }
ObjCSessionCache >> classAt: anAddress [
	^ classes
		at: anAddress asInteger
		ifAbsent: [ NotFound signalFor: anAddress ]
]

{ #category : #accessing }
ObjCSessionCache >> classAt: anAddress ifAbsent: aBlock [
	^ classes
		at: anAddress asInteger
		ifAbsent: aBlock
]

{ #category : #accessing }
ObjCSessionCache >> classAt: anAddress ifAbsentPut: aBlock [
	^ classes
		at: anAddress asInteger
		ifAbsentPut: aBlock
]

{ #category : #initialization }
ObjCSessionCache >> initialize [
	super initialize.
	selectors := Dictionary new.
	methods := Dictionary new.
	classes := Dictionary new
]

{ #category : #accessing }
ObjCSessionCache >> methodAt: anAddress [
	^ methods
		at: anAddress asInteger
		ifAbsent: [ NotFound signalFor: anAddress ]
]

{ #category : #accessing }
ObjCSessionCache >> methodAt: anAddress ifAbsent: aBlock [
	^ methods
		at: anAddress asInteger
		ifAbsent: aBlock
]

{ #category : #accessing }
ObjCSessionCache >> methodAt: anAddress ifAbsentPut: aBlock [
	^ methods
		at: anAddress asInteger
		ifAbsentPut: aBlock
]

{ #category : #initialization }
ObjCSessionCache >> reset [
	self initialize
]

{ #category : #accessing }
ObjCSessionCache >> selectorAt: aSymbol [
	^ selectors 
		at: aSymbol 
		ifAbsent: [ NotFound signalFor: aSymbol ]
]

{ #category : #accessing }
ObjCSessionCache >> selectorAt: aSymbol ifAbsent: aBlock [
	^ selectors 
		at: aSymbol 
		ifAbsent: aBlock
]

{ #category : #accessing }
ObjCSessionCache >> selectorAt: aSymbol ifAbsentPut: aBlock [
	^ selectors 
		at: aSymbol 
		ifAbsentPut: aBlock
]
