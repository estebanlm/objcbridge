Class {
	#name : #ObjCBlock,
	#superclass : #FFIExternalObject,
	#instVars : [
		'block',
		'callback',
		'blockStruct',
		'blockDescriptor'
	],
	#category : #'ObjectiveC-Core'
}

{ #category : #initialization }
ObjCBlock class >> signature: aSignature block: aBlock [ 
	
	^ self new
		signature: aSignature block: aBlock;
		yourself
]

{ #category : #initialization }
ObjCBlock >> signature: aSignature block: aBlock [ 
	
	block := aBlock.
	
	blockDescriptor := ObjCBlockDescriptorStructure externalNew autoRelease; yourself.
	blockStruct := ObjCBlockStructure externalNew autoRelease; yourself.

	blockStruct isa: (ExternalAddress loadSymbol: '_NSConcreteStackBlock').
	blockStruct flags: (1<<29).
	blockStruct descriptor: blockDescriptor.
	blockDescriptor size: blockStruct class byteSize.

	self setHandle: blockStruct getHandle.

	callback := ObjCBlockFunction signature: aSignature block: aBlock.
	callback ffiLibrary: ObjCBlockLibrary.
	blockStruct invoke: callback.


]
