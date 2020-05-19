"
I point to libobjc and I provide mapping to it's types.
"
Class {
	#name : #ObjCLibrary,
	#superclass : #FFILibrary,
	#instVars : [
		'runner',
		'session'
	],
	#classVars : [
		'ObjCTypes'
	],
	#category : #'ObjectiveC-Core'
}

{ #category : #private }
ObjCLibrary class >> createObjCTypes [
	^ Dictionary newFromPairs: #(
		BOOL 					bool
		CGFloat 				double "float in 32bits"
		Class 					ObjCClass
		id 						ObjCObject
		Ivar 					ObjCInstanceVariable
		IMP 					ObjCProxyCallback
		Method 				ObjCMethod
		objc_property_t 	ObjCProperty
		Protocol 				ObjCProtocol
		ptrdiff_t 			long "typedef for __darwin_ptrdiff_t, a long on 64-bit (see _types.h)"
		SEL 					ObjCSelector
		uint8_t 				uchar "Drill down from https://developer.apple.com/documentation/kernel/uint8_t?language=objc"
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

{ #category : #converting }
ObjCLibrary >> calloutAPIClass [ 

	^ TFCalloutAPI
]

{ #category : #'accessing platform' }
ObjCLibrary >> ffiBindingOf: aName [
	^ self class ffiBindingOf: aName
]

{ #category : #'accessing platform' }
ObjCLibrary >> macLibraryName [
	^ 'libobjc.dylib'
]

{ #category : #accessing }
ObjCLibrary >> runner [
 
	(session = Smalltalk session) ifFalse: [
		session :=  Smalltalk session. 
		runner := Smalltalk vm isRunningInWorkerThread  
			ifTrue: [ TFMainThreadRunner uniqueInstance ]
			ifFalse: [ TFSameThreadRunner uniqueInstance ] ].

	^ runner
]
