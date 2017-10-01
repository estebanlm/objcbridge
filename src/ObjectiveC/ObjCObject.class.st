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
	^ (self methodFromObjCMethod: objCMethod)
		valueWithReceiver: self
		arguments: ({ self. objCMethod method_name }, (aMessage arguments))	

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
ObjCObject >> methodFromObjCMethod: method [
	^ ObjCCalloutMethodBuilder new buildMethod: method
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
