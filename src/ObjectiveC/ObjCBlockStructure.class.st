Class {
	#name : #ObjCBlockStructure,
	#superclass : #ObjCStructure,
	#classVars : [
		'OFFSET_DESCRIPTOR',
		'OFFSET_FLAGS',
		'OFFSET_INVOKE',
		'OFFSET_ISA',
		'OFFSET_RESERVED'
	],
	#category : #'ObjectiveC-Inner'
}

{ #category : #'field definition' }
ObjCBlockStructure class >> fieldsDesc [

	"
	self rebuildFieldAccessors
	"


	^ #(
	void* isa;
	int flags;
	int reserved;
	FFICallback invoke;
	ObjCBlockDescriptorStructure* descriptor
	)

]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> descriptor [
	"This method was automatically generated"
	^ObjCBlockDescriptorStructure fromHandle: (handle pointerAt: OFFSET_DESCRIPTOR)
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> descriptor: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_DESCRIPTOR put: anObject getHandle.
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> flags [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_FLAGS
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> flags: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_FLAGS put: anObject
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> invoke [
	"This method was automatically generated"
	^FFICallback forAddress: ((handle pointerAt: OFFSET_INVOKE) asInteger)
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> invoke: anObject [
	"This method was automatically generated"
	handle 
		pointerAt: OFFSET_INVOKE
		put: (anObject 
			ifNotNil: [ anObject thunk asExternalAddress ]
			ifNil: [ ExternalAddress null ])
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> invokeAddress [
	^ handle pointerAt: OFFSET_INVOKE
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> isa [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_ISA) type: ExternalType void asPointerType
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> isa: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_ISA put: anObject getHandle.
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> reserved [
	"This method was automatically generated"
	^handle signedLongAt: OFFSET_RESERVED
]

{ #category : #'accessing - structure variables' }
ObjCBlockStructure >> reserved: anObject [
	"This method was automatically generated"
	handle signedLongAt: OFFSET_RESERVED put: anObject
]

{ #category : #accessing }
ObjCBlockStructure >> thunk [
	
	^ self getHandle tfPointerAddress 
]
