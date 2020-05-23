"
I point to libobjc and I provide mapping to it's types.
"
Class {
	#name : #ObjCLibrary,
	#superclass : #FFILibrary,
	#traits : 'TObjCInspectable',
	#classTraits : 'TObjCInspectable classTrait',
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
							
		"https://developer.apple.com/documentation/objectivec/objective-c_runtime/imp?language=objc"
		IMP 					ObjCProxyCallback
		Method 				ObjCMethod
		objc_property_t 	ObjCProperty
		Protocol 				ObjCProtocol
		
		"typedef for __darwin_ptrdiff_t, a long on MacOS 64-bit (see _types.h)"				
		ptrdiff_t 			long
		SEL 					ObjCSelector
							
		"Drill down from https://developer.apple.com/documentation/kernel/uint8_t?language=objc"
		uint8_t 				uchar
	)
]

{ #category : #'encoding types' }
ObjCLibrary class >> decodeType: aString [
	^ self typeEncodings at: aString ifAbsent: [ '?' ]
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

{ #category : #'encoding types' }
ObjCLibrary class >> typeEncodings [
	"See https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100"
	^ Dictionary newFromPairs: #( 
			c char
			i int
			s short
			l long "l is treated as a 32-bit quantity on 64-bit programs."
			q 'long long'
			C 'unsigned char'
			I 'unsigned int'
			S 'unsigned short'
			L 'unsigned long'
			Q 'unsigned long long'
			f float
			d double
			B 'C++ bool or a C99 _Bool'
			v void
			* 'character string (char *)'
			@ 'object (whether statically typed or typed id)'
			'#' 'class object (Class)'
			: 'method selector (SEL)'
			? 'unknown type') "(among other things, this code is used for function pointers)"
]

{ #category : #converting }
ObjCLibrary >> calloutAPIClass [ 

	^ TFCalloutAPI
]

{ #category : #'objective-c run-time' }
ObjCLibrary >> copyClassNamesForImage: pathString [
	| outCount names result |
	outCount := FFIUInt32 newBuffer.
	names := self copyClassNamesForImage: pathString outCount: outCount.
	result := [ names getHandle isNull
		ifTrue: [ ^ Array new ].
	names getHandle
		readArrayOf: FFIExternalString new
		until: [ :e | e isNil ] ]
		ensure: [ names getHandle free ].
	^ result
]

{ #category : #'objective-c run-time' }
ObjCLibrary >> copyClassNamesForImage: pathString outCount: outCount [
	"https://developer.apple.com/documentation/objectivec/1418970-objc_copyimagenames?language=objc"
	^ self ffiCall: #(const char ** objc_copyClassNamesForImage(const char *pathString, uint *outCount))
]

{ #category : #'objective-c run-time' }
ObjCLibrary >> copyImageNames [
	| outCount names result |
	outCount := FFIUInt32 newBuffer.
	names := self copyImageNames: outCount.
	result := [ names getHandle isNull
		ifTrue: [ ^ Array new ].
	names getHandle
		readArrayOf: FFIExternalString new
		until: [ :e | e isNil ] ]
		ensure: [ names getHandle free ].
	^ result
]

{ #category : #'objective-c run-time' }
ObjCLibrary >> copyImageNames: outCount [
	"https://developer.apple.com/documentation/objectivec/1418970-objc_copyimagenames?language=objc"
	^ self ffiCall: #(const char ** objc_copyImageNames(uint *outCount))
]

{ #category : #'accessing platform' }
ObjCLibrary >> ffiBindingOf: aName [
	^ self class ffiBindingOf: aName
]

{ #category : #inspecting }
ObjCLibrary >> gtInspectorRuntimeIn: composite [
	<gtInspectorPresentationOrder: 10>
	
	self 
		gtInspectorObjCRuntimeFields: { 
			'Image Names' -> self copyImageNames }
		in: composite
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
