"
I point to libobjc and I provide mapping to it's types.
"
Class {
	#name : #ObjCLibrary,
	#superclass : #FFILibrary,
	#classVars : [
		'ObjCTypes'
	],
	#category : #ObjectiveC-Core
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
	)
]

{ #category : #private }
ObjCLibrary class >> ffiBindingOf: aName [
	^ ObjCTypes 
		at: aName
		ifAbsent: [ super ffiBindingOf: aName ]
]

{ #category : #'class initialization' }
ObjCLibrary class >> initialize [
	ObjCTypes := self createObjCTypes
]

{ #category : #'accessing platform' }
ObjCLibrary >> ffiBindingOf: aName [
	^ self class ffiBindingOf: aName
]

{ #category : #'accessing platform' }
ObjCLibrary >> macModuleName [
	^ 'libobjc.dylib'
]
