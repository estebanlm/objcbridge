"
I'm an Objective-C method structure.


"
Class {
	#name : #ObjCMethodStructure,
	#superclass : #ObjCStructure,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#classVars : [
		'OFFSET_METHOD_IMP',
		'OFFSET_METHOD_NAME',
		'OFFSET_METHOD_TYPES'
	],
	#category : #'ObjectiveC-Inner'
}

{ #category : #'field definition' }
ObjCMethodStructure class >> fieldsDesc [
	^ #(
    SEL method_name;
    char *method_types;
    IMP method_imp;
	)	

"struct objc_method {
    SEL method_name;
    char *method_types;
    IMP method_imp;
};"
]

{ #category : #'accessing structure variables' }
ObjCMethodStructure >> method_imp [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_METHOD_IMP) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCMethodStructure >> method_imp: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_METHOD_IMP put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCMethodStructure >> method_name [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_METHOD_NAME) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCMethodStructure >> method_name: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_METHOD_NAME put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCMethodStructure >> method_types [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_METHOD_TYPES) type: ExternalType char asPointerType
]

{ #category : #'accessing structure variables' }
ObjCMethodStructure >> method_types: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_METHOD_TYPES put: anObject getHandle.
]

{ #category : #accessing }
ObjCMethodStructure >> name [
	^ self method_name readStringUTF8 asSymbol
]

{ #category : #accessing }
ObjCMethodStructure >> types [
	^ self method_types readStringUTF8
]
