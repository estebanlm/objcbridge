"
I represent an Objective-C instance.
"
Class {
	#name : #ObjCObject,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#instVars : [
		'isa'
	],
	#classVars : [
		'OBJ_PTR'
	],
	#category : #'ObjectiveC-Core'
}

{ #category : #finalization }
ObjCObject class >> finalizeResourceData: handle [
	handle isNull ifTrue: [ ^ self ].
	(ObjCObject fromHandle: handle) release.
	handle asExternalAddress beNull
]

{ #category : #libraries }
ObjCObject class >> lookup: symbol inLibrary: libraryName [
	^ self loadSymbol: symbol module: libraryName
]

{ #category : #accessing }
ObjCObject class >> nil [ 
	"ObjC uses nil as NULL"
	^ self null
]

{ #category : #private }
ObjCObject >> class: aClass getInstanceMethod: aName [
	^ self ffiCall: #(Method class_getInstanceMethod(Class aClass, SEL aName))
]

{ #category : #accessing }
ObjCObject >> descriptionString [ 
	^ self description UTF8String
]

{ #category : #private }
ObjCObject >> doGetInstanceVariable: aName in: returnValue [
	
	self ffiCall: #(void* object_getInstanceVariable(self, char * aName, void* returnValue))
]

{ #category : #private }
ObjCObject >> doSetInstanceVariable: aName to: aValue [
	
	self ffiCall: #(void* object_setInstanceVariable(self, char * aName, void* aValue))
]

{ #category : #'reflective operations' }
ObjCObject >> doesNotUnderstand: aMessage [
	| shadowMethod arguments |

	shadowMethod := self installedMethodForMessage: aMessage sender: thisContext sender.
	shadowMethod ifNil: [ ^ super doesNotUnderstand: aMessage ].
	arguments := aMessage arguments collect: [ :each | each adaptToObjC ].
	^ shadowMethod 
		valueWithReceiver: self
		arguments: arguments
]

{ #category : #private }
ObjCObject >> getInstanceVariable: aName [

	| returnValue |
	OBJ_PTR := FFIExternalValueHolder ofType: 'void *'.
	returnValue := OBJ_PTR new value: ExternalAddress null.	

	self doGetInstanceVariable: aName in: returnValue.
	
	^ ObjCObject fromHandle: returnValue value.
]

{ #category : #private }
ObjCObject >> innerStructure [
	"The inner structure from this object"
	^ ObjCObjectStructure fromHandle: (self getHandle asExternalAddress pointerAt: 1) asExternalAddress
]

{ #category : #private }
ObjCObject >> installMethodAt: aSelector implementation: aMethod [
	^ self isa
		methodAt: aSelector
		put: aMethod
]

{ #category : #private }
ObjCObject >> installedMethodAt: aSelector [
	^ self isa
		methodAt: aSelector 
		ifAbsent: [ nil ]
]

{ #category : #private }
ObjCObject >> installedMethodForMessage: aMessage sender: aContext [
	| method objCMethod |

	method := self installedMethodAt: aMessage selector.
	method ifNotNil: [ ^ method ].

	objCMethod := self objCMethodForSelector: aMessage selector.
	(objCMethod isNil or: [ objCMethod isNull ]) 
		ifTrue: [ ^ nil ].
		
	^ self 
		installMethodAt: aMessage selector
		implementation: ((ObjCCalloutMethodBuilder 
				buildMethod: objCMethod 
				message: aMessage 
				sender: aContext)
			selector: aMessage selector;
			methodClass: self class;
			yourself)
]

{ #category : #accessing }
ObjCObject >> isa [
	^ isa ifNil: [
		| classHandle |
		classHandle := (self objCPerform: #class asObjCSelector) getHandle.
		isa := ObjCSessionCache current 
			classAt: classHandle
			ifAbsentPut: [ ObjCClass fromHandle: classHandle ] ]
	"^ isa ifNil: [ | inner |
		inner := self innerStructure.
		isa := ObjCSessionCache current 
			classAt: inner getHandle
			ifAbsentPut: [ inner isa ] ]"
]

{ #category : #private }
ObjCObject >> objCMethodForSelector: aSelector [
	^ self 
		class: self isa
		getInstanceMethod: aSelector asObjCSelector
]

{ #category : #private }
ObjCObject >> objCPerform: aSEL [
	^ self ffiCall: #(id objc_msgSend(self, SEL aSEL))
]

{ #category : #accessing }
ObjCObject >> release [

	self objCPerform: #release asObjCSelector
]

{ #category : #private }
ObjCObject >> setInstanceVariable: aName to: aValue [

	self doSetInstanceVariable: aName to: aValue.
	
	^ self
]
