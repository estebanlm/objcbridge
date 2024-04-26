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

{ #category : #converting }
ObjCLibrary >> calloutAPIClass [ 

	^ TFCalloutAPI
]

{ #category : #'objc - creating' }
ObjCLibrary >> class_addMethodClass: cls selector: name implementation: imp signature: types [

	^ self ffiCall: #(int class_addMethod(void* cls, void* name, void* imp, const char *types))
]

{ #category : #'accessing platform' }
ObjCLibrary >> ffiBindingOf: aName [
	^ self class ffiBindingOf: aName
]

{ #category : #'objc - accessing' }
ObjCLibrary >> lookupClass: aString [

	^ self ffiCall: #(void* objc_lookUpClass(char *aString))
]

{ #category : #'objc - accessing' }
ObjCLibrary >> lookupSelector: aString [

	^ self ffiCall: #(void* sel_registerName(const char *aString))
]

{ #category : #'accessing platform' }
ObjCLibrary >> macLibraryName [
	^ 'libobjc.dylib'
]

{ #category : #'objc - converting' }
ObjCLibrary >> nsStringOf: aString [

	| class encoded param |

	encoded := aString utf8Encoded.
	param := ByteArray new: encoded size + 1.
	param pinInMemory.

	LibC memCopy: encoded to: param size: encoded size.
	param at: encoded size + 1 put: 0.

	class := self lookupClass: 'NSString'.
	^ self sendMessageNamed: 'stringWithUTF8String:' to: class with: param
]

{ #category : #'objc - creating' }
ObjCLibrary >> objc_allocateClassPairSuperclass: superclass name: name extraBytes: extraBytes [
	
	^ self ffiCall: #(void* objc_allocateClassPair(void* superclass, const char *name, size_t extraBytes))
]

{ #category : #'objc - creating' }
ObjCLibrary >> objc_registerClassPair: cls [
	"Registers a class that was allocated using objc_allocateClassPair"
	
	self ffiCall: #(void objc_registerClassPair(void* cls))
]

{ #category : #'objc - releasing' }
ObjCLibrary >> release: aObjCObject [

	self sendMessageNamed: 'release' to: aObjCObject
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

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessage: sel to: cls [

	^ self ffiCall: #(void* objc_msgSend(void* cls, void* sel))
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessage: sel to: rcv with: aParam [
	
	^ self ffiCall: #(void* objc_msgSend(void* rcv, void* sel, void* aParam))
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessage: sel to: rcv with: aParam1 with: aParam2 [

	^ self ffiCall: #(void* objc_msgSend(void* rcv, void* sel, void* aParam1, void* aParam2))
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessage: sel to: rcv with: aParam1 with: aParam2 with: aParam3 [

	^ self ffiCall: #(void* objc_msgSend(void* rcv, void* sel, void* aParam1, void* aParam2, void* aParam3))
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessage: sel to: rcv withInteger: aParam [
	
	^ self ffiCall: #(void* objc_msgSend(void* rcv, void* sel, int aParam))
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessageNamed: selectorName to: cls [

	^ self sendMessage: (self lookupSelector: selectorName) to: cls
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessageNamed: selectorName to: rcv with: aParam [
	| sel |
	
	sel := self lookupSelector: selectorName.
	^ self sendMessage: sel to: rcv with: aParam
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessageNamed: selectorName to: rcv with: aParam1 with: aParam2 [
	| sel |
	
	sel := self lookupSelector: selectorName.
	^ self sendMessage: sel to: rcv with: aParam1 with: aParam2
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessageNamed: selectorName to: rcv with: aParam1 with: aParam2 with: aParam3 [
	| sel |
	
	sel := self lookupSelector: selectorName.
	^ self sendMessage: sel to: rcv with: aParam1 with: aParam2 with: aParam3
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessageNamed: selectorName to: rcv withInteger: aParam [
	| sel |
	
	sel := self lookupSelector: selectorName.
	^ self sendMessage: sel to: rcv withInteger: aParam
]

{ #category : #'objc - message sending' }
ObjCLibrary >> sendMessageNamed: selectorName toClassNamed: className [

	^ self sendMessage: (self lookupSelector: selectorName) to: (self lookupClass: className)
]

{ #category : #'objc - accessing' }
ObjCLibrary >> sharedApplication [

	^ self
		  sendMessageNamed: 'sharedApplication'
		  toClassNamed: 'NSApplication'
]
