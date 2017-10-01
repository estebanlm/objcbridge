Class {
	#name : #ObjCClassStructure,
	#superclass : #ObjCStructure,
	#classVars : [
		'OFFSET_CACHE',
		'OFFSET_INFO',
		'OFFSET_INSTANCE_SIZE',
		'OFFSET_ISA',
		'OFFSET_IVARS',
		'OFFSET_METHODLISTS',
		'OFFSET_NAME',
		'OFFSET_PROTOCOLS',
		'OFFSET_SUPER_CLASS',
		'OFFSET_VERSION'
	],
	#category : #ObjectiveC
}

{ #category : #'field definition' }
ObjCClassStructure class >> fieldsDesc [
"struct objc_class {
    struct objc_class *isa;
    struct objc_class *super_class;
    const char *name;
    long version;
    long info;
    long instance_size;
    struct objc_ivar_list *ivars;

    struct objc_method_list **methodLists;

    struct objc_cache *cache;
    struct objc_protocol_list *protocols;
};
"

	^ #(
	void *isa;
	void *super_class;
	String name;
	long version;
	long info;
	long instance_size;
	"From here, TODO"
	void *ivars;
	void **methodLists;
	void *cache;
	void *protocols;
)
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> cache [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_CACHE) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> cache: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_CACHE put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> info [
	"This method was automatically generated"
	^handle platformLongAt: OFFSET_INFO
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> info: anObject [
	"This method was automatically generated"
	^handle platformLongAt: OFFSET_INFO put: anObject
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> instance_size [
	"This method was automatically generated"
	^handle platformLongAt: OFFSET_INSTANCE_SIZE
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> instance_size: anObject [
	"This method was automatically generated"
	^handle platformLongAt: OFFSET_INSTANCE_SIZE put: anObject
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> isa [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_ISA) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> isa: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_ISA put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> ivars [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_IVARS) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> ivars: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_IVARS put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> methodLists [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_METHODLISTS) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> methodLists: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_METHODLISTS put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> name [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_NAME) type: ExternalType char asPointerType
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> name: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_NAME put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> protocols [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_PROTOCOLS) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> protocols: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_PROTOCOLS put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> super_class [
	"This method was automatically generated"
	^ExternalData fromHandle: (handle pointerAt: OFFSET_SUPER_CLASS) type: ExternalType void asPointerType
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> super_class: anObject [
	"This method was automatically generated"
	handle pointerAt: OFFSET_SUPER_CLASS put: anObject getHandle.
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> version [
	"This method was automatically generated"
	^handle platformLongAt: OFFSET_VERSION
]

{ #category : #'accessing structure variables' }
ObjCClassStructure >> version: anObject [
	"This method was automatically generated"
	^handle platformLongAt: OFFSET_VERSION put: anObject
]
