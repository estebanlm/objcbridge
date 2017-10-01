Class {
	#name : #ObjCSessionCache,
	#superclass : #Object,
	#instVars : [
		'selectors'
	],
	#classInstVars : [
		'current'
	],
	#category : #ObjectiveC
}

{ #category : #accessing }
ObjCSessionCache class >> current [
	^ current ifNil: [ current := self basicNew initialize ]
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
	current := nil
]

{ #category : #initialization }
ObjCSessionCache >> initialize [
	super initialize.
]

{ #category : #accessing }
ObjCSessionCache >> selectorAt: aSymbol ifAbsentPut: aBlock [
	^ selectors 
		at: aSymbol 
		ifAbsentPut: aBlock
]
