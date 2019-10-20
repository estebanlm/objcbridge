"
I point to libobjc and I provide mapping to it's types.
"
Class {
	#name : #ObjCLibrary,
	#superclass : #FFILibrary,
	#classVars : [
		'ObjCTypes'
	],
	#category : #'ObjectiveC-Core'
}

{ #category : #private }
ObjCLibrary class >> createObjCTypes [
	^ Dictionary newFromPairs: #(
		Method 	ObjCMethod
		Class 		ObjCClass
		SEL 		ObjCSelector
		id 			ObjCObject
		IMP 		ObjCProxyCallback
		BOOL 		bool
		CGFloat 	double "float in 32bits"
	)
]

{ #category : #private }
ObjCLibrary class >> ffiBindingMaybeObjCStruct: aName [
	ObjCStructure allSubclasses do: [ :each |
		(each ffiStructureAliasOf: aName)
			ifNotNil: [ :binding | ^ binding ] ].
 	^ nil
]

{ #category : #private }
ObjCLibrary class >> ffiBindingOf: aName [
	^ ObjCTypes 
		at: aName
		ifAbsent: [ 
			(self ffiBindingMaybeObjCStruct: aName)
				ifNil: [ super ffiBindingOf: aName ] ]
]

{ #category : #'class initialization' }
ObjCLibrary class >> initialize [
	self initializeObjCTypes

]

{ #category : #'class initialization' }
ObjCLibrary class >> initializeObjCTypes [
	ObjCTypes := self createObjCTypes
]

{ #category : #'accessing platform' }
ObjCLibrary >> ffiBindingOf: aName [
	^ self class ffiBindingOf: aName
]

{ #category : #'accessing platform' }
ObjCLibrary >> macLibraryName [
	^ 'libobjc.dylib'
]
