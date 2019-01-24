"
I'm an Objective-C object structure.
"
Class {
	#name : #ObjCObjectStructure,
	#superclass : #ObjCStructure,
	#classVars : [
		'OFFSET_ISA'
	],
	#category : #'ObjectiveC-Inner'
}

{ #category : #'fields description' }
ObjCObjectStructure class >> fieldsDesc [
"
struct objc_object {
    struct objc_class *isa;
};
"
	^ #(
	ObjCClass isa
	)

]

{ #category : #'accessing structure variables' }
ObjCObjectStructure >> isa [
	"This method was automatically generated"
	^ObjCClass fromHandle: (handle pointerAt: OFFSET_ISA)
]

{ #category : #'accessing structure variables' }
ObjCObjectStructure >> isa: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_ISA put: anObject getHandle.
]
