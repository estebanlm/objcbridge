Class {
	#name : #ObjCSessionCache,
	#superclass : #Object,
	#instVars : [
		'selectors',
		'methods'
	],
	#classVars : [
		'Current'
	],
	#category : #ObjectiveC
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

{ #category : #initialization }
ObjCSessionCache >> initialize [
	super initialize.
	selectors := Dictionary new.
	methods := Dictionary new
]

{ #category : #accessing }
ObjCSessionCache >> methodAt: aSymbol ifAbsentPut: aBlock [
	^ methods
		at: aSymbol 
		ifAbsentPut: aBlock
]

{ #category : #accessing }
ObjCSessionCache >> selectorAt: aSymbol ifAbsentPut: aBlock [
	^ selectors 
		at: aSymbol 
		ifAbsentPut: aBlock
]
