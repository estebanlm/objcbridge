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
	ObjCClassStructure *isa
	)

]

{ #category : #'accessing structure variables' }
ObjCObjectStructure >> isa [
	"This method was automatically generated"
	^ObjCClassStructure fromHandle: (handle getHandle pointerAt: OFFSET_ISA)
]

{ #category : #'accessing structure variables' }
ObjCObjectStructure >> isa: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_ISA put: anObject getHandle.
]
