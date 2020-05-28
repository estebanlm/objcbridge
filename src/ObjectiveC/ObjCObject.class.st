"
I represent an Objective-C instance.
"
Class {
	#name : #ObjCObject,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary + TObjCInspectable',
	#classTraits : 'TObjCLibrary classTrait + TObjCInspectable classTrait',
	#instVars : [
		'isa'
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

{ #category : #accessing }
ObjCObject >> descriptionString [ 
	^ self description UTF8String
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

{ #category : #'objective-c run-time' }
ObjCObject >> getClass [
	"https://developer.apple.com/documentation/objectivec/1418629-object_getclass?language=objc"
	^ self ffiCall: #(Class object_getClass(self))
]

{ #category : #'objective-c run-time' }
ObjCObject >> getClassName [
	"https://developer.apple.com/documentation/objectivec/1418547-object_getclassname?language=objc"
	^ self ffiCall: #(const char * object_getClassName(id self))
]

{ #category : #'objective-c run-time' }
ObjCObject >> getInstanceVariable [
	"https://developer.apple.com/documentation/objectivec/1441499-object_getinstancevariable?language=objc"
	^ self ffiCall: #(Ivar object_getInstanceVariable(self, const char *name, void **outValue))
]

{ #category : #'objective-c run-time' }
ObjCObject >> getInstanceVariable: aString [
	"https://developer.apple.com/documentation/objectivec/1441499-object_getinstancevariable?language=objc"
	| outValue |
	outValue := FFIOop newBuffer.
	^ { self getInstanceVariable: aString value: outValue. outValue }
]

{ #category : #'objective-c run-time' }
ObjCObject >> getInstanceVariable: name value: outValue [
	"https://developer.apple.com/documentation/objectivec/1441499-object_getinstancevariable?language=objc"
	^ self ffiCall: #(Ivar object_getInstanceVariable(id self, const char *name, void **outValue))
]

{ #category : #'objective-c run-time' }
ObjCObject >> getInstanceVariableValue: aString [
	"https://developer.apple.com/documentation/objectivec/1441499-object_getinstancevariable?language=objc"
	| outValue |
	outValue := ExternalAddress new.
	^ { self getInstanceVariable: aString value: outValue. outValue }
]

{ #category : #inspecting }
ObjCObject >> gtInspectorRuntimeFields [
	^ { 
		'Class' -> self getClass.
		'Class Name' -> self getClassName. }
]

{ #category : #inspecting }
ObjCObject >> gtInspectorRuntimeIn: composite [
	<gtInspectorPresentationOrder: 10>
	
	self getHandle isNull ifTrue: [ ^ self ].
	self 
		gtInspectorObjCRuntimeFields: self gtInspectorRuntimeFields
		in: composite
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
	^ self isa getInstanceMethod: aSelector asObjCSelector
]

{ #category : #private }
ObjCObject >> objCPerform: aSEL [
	^ self ffiCall: #(id objc_msgSend(self, SEL aSEL))
]

{ #category : #'message performing' }
ObjCObject >> objCSend: aMessage [
	"Force a message to be sent on the Obj-C side. This is useful when there is a message with the same selector on the Pharo side (e.g. #class), which would otherwise intercept it"
	^ self doesNotUnderstand: aMessage
]

{ #category : #'message performing' }
ObjCObject >> performObjC: selector withArguments: argArray [ 
	"See objCSend: comment"
	^ self objCSend: (Message selector: selector arguments: argArray)
]

{ #category : #accessing }
ObjCObject >> release [
	self objCPerform: #release asObjCSelector
]
