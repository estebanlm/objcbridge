Class {
	#name : #ObjCObjectStructure,
	#superclass : #ObjCStructure,
	#classVars : [
		'OFFSET_ISA'
	],
	#category : #ObjectiveC
}

{ #category : #'fields description' }
ObjCObjectStructure class >> fieldsDesc [
"
struct objc_object {
    struct objc_class *isa;
};
"
	^ #(
	ObjCClass *isa
	)

]

{ #category : #'accessing structure variables' }
ObjCObjectStructure >> isa [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_ISA) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCObjectStructure >> isa: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_ISA put: anObject getHandle.
]
