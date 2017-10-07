Class {
	#name : #ObjCObject,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#instVars : [
		'isa'
	],
	#category : #ObjectiveC
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
	objCMethod ifNil: [ ^ super doesNotUnderstand: aMessage ].
	shadowMethod := ObjCSessionCache current
		methodAt: objCMethod getHandle asInteger
		ifAbsentPut: [ 
			(ObjCCalloutMethodBuilder buildMethod: objCMethod)
				selector: aMessage selector;
				methodClass: self class;
				yourself ].
	arguments := ({ self. objCMethod method_getName }, (aMessage arguments)).
	^ shadowMethod 
		valueWithReceiver: self
		arguments: arguments

]

{ #category : #private }
ObjCObject >> innerStructure [
	"The inner structure from this object"
	^ ObjCObjectStructure fromHandle: (ExternalData 
		fromHandle: (self getHandle asExternalAddress pointerAt: 1) 
		type: ExternalType void asPointerType)
]

{ #category : #accessing }
ObjCObject >> isa [
	^ isa ifNil: [ isa := self innerStructure isa ]
]

{ #category : #private }
ObjCObject >> objCMethodForSelector: aSelector [
	^ self 
		class: self isa 
		getInstanceMethod: aSelector asObjCSelector
]

{ #category : #'as yet unclassified' }
ObjCObject >> release [
	self flag: #todo.
	"Is it correct to avoid freeing pointers of objective-c?"
]
