"
I can parse an ObjCMethod (taking arguments and signature) to produce a FFIFunctionSpec instance (that will later be translated to an UFFI call)
"
Class {
	#name : #ObjCSpecParser,
	#superclass : #Object,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#instVars : [
		'stream'
	],
	#classVars : [
		'MethodTypeMap',
		'ReversedMethodTypeMap',
		'TypeQualifiers'
	],
	#category : #ObjectiveC-Builder
}

{ #category : #'class initialization' }
ObjCSpecParser class >> initialize [
	self initializeMethodTypeMap
]

{ #category : #'class initialization' }
ObjCSpecParser class >> initializeMethodTypeMap [
	MethodTypeMap := IdentityDictionary new: 32.
	MethodTypeMap
		at: $@ "_C_ID"			put: #id;
		at: $# "_C_CLASS"		put: #Class;
		at: $: "_C_SEL"			put: #SEL;
		at: $c "_CHR"			put: #char;
		at: $C "_C_UCHR"		put: #uchar;
		at: $s "_C_SHT"			put: #short;
		at: $S "_C_USHT"		put: #ushort;
		at: $i "_C_INT"			put: #int;
		at: $I "_C_UINT"		put: #uint;
		at: $l "_C_LNG"			put: #long;
		at: $L "_C_ULNG"		put: #ulong;
		at: $q 					put: #longlong;
		at: $Q 					put: #ulonglong;
		at: $f "_C_FLT"			put: #float;
		at: $d "_C_DBL"			put: #double;
		"at: $b" "_C_BFLD"		"put: [];"
		at: $v "_C_VOID"		put: #void;
		"at: $?" "_C_UNDEF"	"put: [];"
		at: $^ "_C_PTR"			put: #oop;
		at: $* "_CHARPTR"		put: #String;
		"at: $[" "_C_ARY_B"	"put: [];"
		"at: $]" "_C_ARY_E"	"put: [];"
		"at: $(" "_C_UNION_B"	"put: [];"
		"at: $)" "_C_UNION_E"	"put: [];"
		at: ${ "_C_STRUCT_B" 	put: #FFIExternalStructure.
		"at: $}" "_C_STRUCT_E""put: []."

	ReversedMethodTypeMap := Dictionary new: 32.
	ReversedMethodTypeMap
		at: ObjCObject					put: $@;
		at: ObjCClass					put: $#;
		at: ObjCSelector				put: $:;
		at: FFICharacterType 			put: $c;
		at: FFIUInt8						put: $C;
		at: FFIInt16 					put: $s;
		at: FFIUInt16 					put: $S;
		at: FFIInt32 					put: $i;
		at: FFIUInt32 					put: $I;
		at: FFILong 						put: $l;
		at: FFIULong 					put: $L;
		at: FFIInt64 					put: $q;
		at: FFIUInt64					put: $Q;
		at: FFIFloat32 					put: $f;
		at: FFIFloat64  				put: $d;
		at: FFIVoid  					put: $v;
		at: FFIOop  						put: $^;
		at: FFIExternalString 		put: $*;
		at: FFIExternalStructure 	put: ${.

"#define _C_CONST			'r'
#define _C_IN				'n'
#define _C_INOUT			'N'
#define _C_OUT			'o'
#define _C_BYCOPY		'O'
#define _C_BYREF			'R'
#define _C_ONEWAY		'V'
#define _C_GCINVISIBLE	'!'
"
	TypeQualifiers := 'nNoOrRV!'.
]

{ #category : #accessing }
ObjCSpecParser class >> reverseType: aTypeClass [
	^ ReversedMethodTypeMap at: aTypeClass
]

{ #category : #private }
ObjCSpecParser >> ffiInstVarArgument: argName generator: generator [
	"Load the instance variable with given name. 
	 It will be ignored anyway in a callback" 
	^ FFIInstVarArgument new 
		argName: argName;
		yourself
]

{ #category : #'private testing' }
ObjCSpecParser >> isStructure: ch [
	^ ch = ${
]

{ #category : #'private factory' }
ObjCSpecParser >> newFunctionParser [
	^ FFIFunctionParser new
		requestor: (FFICallout new
			requestor: self;
			yourself);
		yourself
]

{ #category : #'private parsing' }
ObjCSpecParser >> nextStructure: aStream [
	^ FFICallout new 
		requestor: self;
		resolveType: (aStream upTo: $=)
]

{ #category : #'private parsing' }
ObjCSpecParser >> nextType: aStream [
	| ch |
	[ TypeQualifiers includes: (ch := aStream next) ] whileTrue.
 	(self isStructure: ch) ifTrue: [ ^ self nextStructure: aStream ].
	^ FFICallout new 
		requestor: ObjCLibrary;
		resolveType: (MethodTypeMap at: ch)
]

{ #category : #parsing }
ObjCSpecParser >> parseMethod: anObjCMethod [
	^ FFIFunctionSpec new
		returnType: (self parseType: anObjCMethod returnType);
		arguments: (anObjCMethod argumentTypes 
			collect: [ :each | each ifNotNil: [ self parseType: each ] ]);
		yourself.
	
]

{ #category : #parsing }
ObjCSpecParser >> parseObjCSignature: aString [
	"methods signature is always: return type, object, selector, ..."
	| signatureStream arguments |
	
	arguments := OrderedCollection new.
	signatureStream := aString readStream.
	[ signatureStream atEnd ] 
	whileFalse: [ arguments add: (self nextType: signatureStream) ].
	
	^ FFIFunctionSpec new
		returnType: arguments first;
		arguments: arguments allButFirst asArray;
		yourself.
	
]

{ #category : #parsing }
ObjCSpecParser >> parseSignature: signature [
	| spec |
	
	spec := self newFunctionParser
		parseAnonymousFunction: signature.
		
	spec arguments: { self parseType: '@'. self parseType: ':' }, spec arguments.
	
	^ spec
]

{ #category : #'private parsing' }
ObjCSpecParser >> parseType: aString [
	^ self nextType: aString readStream
]

{ #category : #parsing }
ObjCSpecParser >> reverseParseSignature: spec [
	^ String streamContents: [ :aStream |
		aStream <<spec returnType objCSignatureType.
		spec arguments 
			do: [ :each | aStream << each objCSignatureType ] ].
]

{ #category : #converting }
ObjCSpecParser >> signatureToObjC: anArray [
	^ self reverseParseSignature: (self parseSignature: anArray)
]
