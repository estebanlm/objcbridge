Class {
	#name : #ObjCLibrary,
	#superclass : #FFILibrary,
	#classVars : [
		'ObjCTypes'
	],
	#category : #ObjectiveC
}

{ #category : #private }
ObjCLibrary class >> createObjCTypes [
	^ Dictionary newFromPairs: #(
		Method 	ObjCMethod
		Class 		ObjCClass
		SEL 		ObjCSelector
		id 			oop
		IMP 		oop
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
