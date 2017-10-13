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
	#category : #ObjectiveC-Core
}

{ #category : #libraries }
ObjCObject class >> lookup: symbol inLibrary: libraryName [
	^ self loadSymbol: symbol module: libraryName
]

{ #category : #private }
ObjCObject >> class: aClass getInstanceMethod: aName [
	^ self ffiCall: #(Method class_getInstanceMethod(Class aClass, SEL aName))
]

{ #category : #accessing }
ObjCObject >> descriptionString [ 
	^ self description UTF8String
]

{ #category : #'reflective operations' }
ObjCObject >> doesNotUnderstand: aMessage [
	| objCMethod shadowMethod arguments |
	
	objCMethod := self objCMethodForSelector: aMessage selector.
	(objCMethod isNil or: [ objCMethod isNull ]) 
		ifTrue: [ ^ super doesNotUnderstand: aMessage ].
	shadowMethod := ObjCSessionCache current
		methodAt: objCMethod getHandle
		ifAbsentPut: [
			(ObjCCalloutMethodBuilder buildMethod: objCMethod)
				selector: aMessage selector;
				methodClass: self class;
				yourself ].
	arguments := ({ self. objCMethod method_getName }, (aMessage arguments collect: #adaptToObjC)).
	^ shadowMethod 
		valueWithReceiver: self
		arguments: arguments

]

{ #category : #private }
ObjCObject >> innerStructure [
	"The inner structure from this object"
	^ ObjCObjectStructure fromHandle: (self getHandle asExternalAddress pointerAt: 1) asExternalAddress
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

{ #category : #'as yet unclassified' }
ObjCObject >> release [
	self flag: #todo.
	"Is it correct to avoid freeing pointers of objective-c?"
]
