Class {
	#name : #ObjCObject,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #ObjectiveC
}

{ #category : #libraries }
ObjCObject class >> lookup: symbol inLibrary: libraryName [
	^ self loadSymbol: symbol module: libraryName
]

{ #category : #private }
ObjCObject >> class_getInstanceMethod: name [
	^ self ffiCall: #(Method class_getInstanceMethod(self, SEL name))
]

{ #category : #accessing }
ObjCObject >> descriptionString [ 
	^ self description UTF8String
]

{ #category : #'reflective operations' }
ObjCObject >> doesNotUnderstand: aMessage [
	| objCMethod |
	
	objCMethod := self objCMethodForSelector: aMessage selector.
	objCMethod ifNil: [ ^ super doesNotUnderstand: aMessage ].
	^ (ObjCSessionCache current
		methodAt: objCMethod getHandle asInteger
		ifAbsentPut: [ ObjCCalloutMethodBuilder buildMethod: objCMethod ])
		valueWithReceiver: self
		arguments: ({ self. objCMethod method_getName }, (aMessage arguments))

]

{ #category : #private }
ObjCObject >> innerStructure [
	"The inner structure from this object"
	^ ObjCObjectStructure fromHandle: (self getHandle asExternalAddress pointerAt: 1)
]

{ #category : #accessing }
ObjCObject >> isa [
	^ self innerStructure isa
]

{ #category : #private }
ObjCObject >> objCMethodForSelector: aSelector [
	^ self class_getInstanceMethod: aSelector asObjCSelector
]

{ #category : #'as yet unclassified' }
ObjCObject >> release [
	self flag: #todo.
	"Is it correct to avoid freeing pointers of objective-c?"
]
