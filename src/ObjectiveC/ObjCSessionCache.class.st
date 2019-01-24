"
I'm a cache of elements created in ObjC side.
I keep selectors, classes, and shadow methods created.
"
Class {
	#name : #ObjCSessionCache,
	#superclass : #Object,
	#instVars : [
		'selectors',
		'proxies',
		'classesByName',
		'classesByAddress'
	],
	#classVars : [
		'Current'
	],
	#category : #'ObjectiveC-Core'
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

{ #category : #'system startup' }
ObjCSessionCache class >> startUp: resuming [
	resuming ifFalse: [ ^ self ].
	Current := nil.
]

{ #category : #accessing }
ObjCSessionCache >> classAt: anAddress [
	^ classesByAddress
		at: anAddress asInteger
		ifAbsent: [ NotFound signalFor: anAddress ]
]

{ #category : #accessing }
ObjCSessionCache >> classAt: anAddress ifAbsent: aBlock [
	^ classesByAddress
		at: anAddress asInteger
		ifAbsent: aBlock
]

{ #category : #accessing }
ObjCSessionCache >> classAt: anAddress ifAbsentPut: aBlock [
	^ classesByAddress
		at: anAddress asInteger
		ifAbsentPut: [ | theClass |
			theClass := aBlock value.
			classesByName at: theClass name asSymbol put: theClass.
			theClass ]
]

{ #category : #accessing }
ObjCSessionCache >> classNamed: aName [
	^ classesByName
		at: aName asSymbol
		 ifAbsent: [ NotFound signalFor: aName ]
]

{ #category : #accessing }
ObjCSessionCache >> classNamed: aName ifAbsent: aBlock [
	^ classesByName
		at: aName asSymbol
		ifAbsent: aBlock
]

{ #category : #accessing }
ObjCSessionCache >> classNamed: aName ifAbsentPut: aBlock [
	^ classesByName
		at: aName asSymbol
		ifAbsentPut: [ | theClass |
			theClass := aBlock value.
			classesByAddress at: theClass getHandle asInteger put: theClass.
			theClass ]
]

{ #category : #initialization }
ObjCSessionCache >> initialize [
	super initialize.
	selectors := Dictionary new.
	proxies := Dictionary new.
	classesByName := Dictionary new.	
	classesByAddress := Dictionary new
]

{ #category : #accessing }
ObjCSessionCache >> proxyAt: aName [
	^ proxies
		at: aName
		ifAbsent: [ NotFound signalFor: aName ]
]

{ #category : #accessing }
ObjCSessionCache >> proxyAt: aName ifAbsent: aBlock [
	^ proxies 
		at: aName 
		ifAbsent: aBlock
]

{ #category : #accessing }
ObjCSessionCache >> proxyAt: aName ifAbsentPut: aBlock [
	^ proxies 
		at: aName 
		ifAbsentPut: aBlock
]

{ #category : #accessing }
ObjCSessionCache >> proxyAt: aName put: anObjCClass [
	^ proxies
		at: aName
		put: anObjCClass
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
