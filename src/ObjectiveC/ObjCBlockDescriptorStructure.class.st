Class {
	#name : #ObjCBlockDescriptorStructure,
	#superclass : #ObjCStructure,
	#classVars : [
		'OFFSET_RESERVED',
		'OFFSET_SIZE'
	],
	#category : #'ObjectiveC-Inner'
}

{ #category : #'field definition' }
ObjCBlockDescriptorStructure class >> fieldsDesc [

	"
	self rebuildFieldAccessors
	"


	^ #(
		ulong reserved;
		ulong size
	)

]

{ #category : #'accessing - structure variables' }
ObjCBlockDescriptorStructure >> reserved [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_RESERVED
]

{ #category : #'accessing - structure variables' }
ObjCBlockDescriptorStructure >> reserved: anObject [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_RESERVED put: anObject
]

{ #category : #'accessing - structure variables' }
ObjCBlockDescriptorStructure >> size [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_SIZE
]

{ #category : #'accessing - structure variables' }
ObjCBlockDescriptorStructure >> size: anObject [
	"This method was automatically generated"
	^handle platformUnsignedLongAt: OFFSET_SIZE put: anObject
]
