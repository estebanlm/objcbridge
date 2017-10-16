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

{ #category : #'reflective operations' }
ObjCObject >> doesNotUnderstand: aMessage [
	| shadowMethod arguments |

	shadowMethod := self installedMethodForMessage: aMessage.
	shadowMethod ifNil: [ ^ super doesNotUnderstand: aMessage ].
	arguments := ({ self. aMessage selector asObjCSelector }, (aMessage arguments collect: #adaptToObjC)).
	^ shadowMethod 
		valueWithReceiver: self
		arguments: arguments
]

{ #category : #private }
ObjCObject >> innerStructure [
	"The inner structure from this object"
	^ ObjCObjectStructure fromHandle: (self getHandle asExternalAddress pointerAt: 1) asExternalAddress
]

{ #category : #private }
ObjCObject >> installMethodAt: aSelector implementation: aMethod [
	self isa
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
ObjCObject >> installedMethodForMessage: aMessage [
	| method objCMethod |

	method := self installedMethodAt: aMessage selector.
	method ifNotNil: [ ^ method ].

	objCMethod := self objCMethodForSelector: aMessage selector.
	(objCMethod isNil or: [ objCMethod isNull ]) 
		ifTrue: [ ^ nil ].
	^ self isa 
		methodAt: aMessage selector
		put: ((ObjCCalloutMethodBuilder buildMethod: objCMethod)
				selector: ((aMessage numArgs = 0
					ifTrue: [ aMessage selector, #_rec:_sel: ]
					ifFalse: [ #_rec:_sel:, aMessage selector ])
					asSymbol);
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

{ #category : #'as yet unclassified' }
ObjCObject >> release [
	self flag: #todo.
	"Is it correct to avoid freeing pointers of objective-c?"
]
