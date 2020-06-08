"
I represent the Objective-C Runtime's Method data type. See documention at https://developer.apple.com/documentation/objectivec/method?language=objc
"
Class {
	#name : #ObjCMethod,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary + TObjCInspectable',
	#classTraits : 'TObjCLibrary classTrait + TObjCInspectable classTrait',
	#category : #'ObjectiveC-Core'
}

{ #category : #accessing }
ObjCMethod >> argumentTypeDescriptions [
	^ self argumentTypes collect: [ :e | e objCDecodeType ]
]

{ #category : #accessing }
ObjCMethod >> argumentTypes [
	| types numArgs |
	numArgs := self numArgs.
	types := (Array new: numArgs) writeStream.
	0 to: (numArgs - 1) do: [ :index | types nextPut: (self getArgumentTypeAt: index) ].
	^ types contents
]

{ #category : #'objective-c run-time' }
ObjCMethod >> copyArgumentType: index [
	"
	Return value - a type code. See https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100.
	
	Function doc: 
	https://developer.apple.com/documentation/objectivec/1418832-method_copyargumenttype?language=objc"
	self error: 'How do we free the returned string?'.
	"^ self ffiCall: #(char * method_copyArgumentType(Method self, uint index))"
]

{ #category : #'objective-c run-time' }
ObjCMethod >> copyReturnType [
	"
	Return value - a type code. See https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100.
	
	Function doc: 
	https://developer.apple.com/documentation/objectivec/1418777-method_copyreturntype?language=objc"
	self error: 'How do we free the returned string?'.
	"^ self ffiCall: #(char * method_copyReturnType(Method self))"
]

{ #category : #printing }
ObjCMethod >> displayString [
	^ self selector name
]

{ #category : #'objective-c run-time' }
ObjCMethod >> exchangeImplementations [
	"https://developer.apple.com/documentation/objectivec/1418769-method_exchangeimplementations?language=objc"
	^ self shouldBeImplemented 
]

{ #category : #private }
ObjCMethod >> externalCharArrayDuring: aBlock [

	| charArray result |
	charArray := FFIArray externalNewType: #char size: 256.
	aBlock value: charArray.
	result := (charArray as: String) copyUpTo: Character null.
	charArray getHandle free.
	^ result
]

{ #category : #'objective-c run-time' }
ObjCMethod >> getArgumentTypeAt: index [
	"https://developer.apple.com/documentation/objectivec/1418607-method_getargumenttype?language=objc"

	^ self externalCharArrayDuring: [ :array | self getArgumentTypeAt: index writeTo: array upToLength: array size ].
]

{ #category : #private }
ObjCMethod >> getArgumentTypeAt: index writeTo: charArray upToLength: charArraySize [
	"https://developer.apple.com/documentation/objectivec/1418607-method_getargumenttype?language=objc"
	^ self ffiCall: #(void method_getArgumentType(Method self, uint index, char *charArray, size_t charArraySize))
]

{ #category : #'objective-c run-time' }
ObjCMethod >> getDescription [
	"https://developer.apple.com/documentation/objectivec/1418545-method_getdescription?language=objc"
	^ self ffiCall: #(struct objc_method_description * method_getDescription(Method self))
]

{ #category : #'objective-c run-time' }
ObjCMethod >> getImplementation [
	"https://developer.apple.com/documentation/objectivec/1418551-method_getimplementation?language=objc"
	^ self ffiCall: #(IMP method_getImplementation(Method self))
]

{ #category : #'objective-c run-time' }
ObjCMethod >> getName [
	"https://developer.apple.com/documentation/objectivec/1418758-method_getname?language=objc"
	^ self ffiCall: #(SEL method_getName(Method self))
]

{ #category : #'objective-c run-time' }
ObjCMethod >> getReturnType [
	"https://developer.apple.com/documentation/objectivec/1418591-method_getreturntype?language=objc"

	^ self externalCharArrayDuring: [ :array | self getReturnType: array upTo: array size ].
]

{ #category : #private }
ObjCMethod >> getReturnType: charArray upTo: charArraySize [
	"https://developer.apple.com/documentation/objectivec/1418591-method_getreturntype?language=objc"
	^ self ffiCall: #(void method_getReturnType(Method self, char *charArray, size_t charArraySize))
]

{ #category : #'objective-c run-time' }
ObjCMethod >> getTypeEncoding [
	"https://developer.apple.com/documentation/objectivec/1418488-method_gettypeencoding?language=objc"
	^ self ffiCall: #(const char * method_getTypeEncoding(Method self))
]

{ #category : #inspecting }
ObjCMethod >> gtInspectorRuntimeIn: composite [
	<gtInspectorPresentationOrder: 10>
	
	self 
		gtInspectorObjCRuntimeFields: { 
			'Name' -> self getName.
			'Argument Types' -> (self argumentTypeDescriptions allButFirst: 2).
			"'Implementation' -> (self getImplementation CALLOUT NOT WORKING)."
			'Num. Arguments' -> (self numArgs - 2).
			'Return Type' -> self returnType objCDecodeType.
			'Type Encoding' -> self getTypeEncoding }
		in: composite
]

{ #category : #'objective-c run-time' }
ObjCMethod >> invoke [
	"https://developer.apple.com/documentation/objectivec/1456726-method_invoke?language=objc"
	self flag: 'In the header, the signature is `id _Nullable
method_invoke(id _Nullable receiver, Method _Nonnull m, ...)`, but in the docs, it''s `void method_invoke(void)`'.
	^ self shouldBeImplemented
]

{ #category : #'objective-c run-time' }
ObjCMethod >> invoke_Stret [
	"https://developer.apple.com/documentation/objectivec/1456726-method_invoke?language=objc"
	self flag: 'In the header, the signature is `id _Nullable
method_invoke(id _Nullable receiver, Method _Nonnull m, ...)`, but in the docs, it''s `void method_invoke(void)`'.
	^ self shouldBeImplemented
]

{ #category : #accessing }
ObjCMethod >> name [
	^ self getName name
]

{ #category : #'objective-c run-time' }
ObjCMethod >> numArgs [
	"https://developer.apple.com/documentation/objectivec/1418968-method_getnumberofarguments?language=objc"
	^ self ffiCall: #(uint method_getNumberOfArguments(Method self))
]

{ #category : #printing }
ObjCMethod >> printOn: aStream [
	super printOn: aStream.
	aStream 
		space;
		nextPutAll: self selector name
]

{ #category : #accessing }
ObjCMethod >> returnType [
	"https://developer.apple.com/documentation/objectivec/1418777-method_copyreturntype?language=objc"
	^ self getReturnType
]

{ #category : #accessing }
ObjCMethod >> selector [
	^ self getName
]

{ #category : #'objective-c run-time' }
ObjCMethod >> setImplementation [
	"https://developer.apple.com/documentation/objectivec/1418707-method_setimplementation?language=objc"
	^ self shouldBeImplemented 
]
