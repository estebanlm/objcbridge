Class {
	#name : #ObjCSpecParser,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#classVars : [
		'MethodTypeMap',
		'TypeQualifiers'
	],
	#category : #ObjectiveC
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

{ #category : #parsing }
ObjCSpecParser >> parseArguments [
	| arguments |
	
	arguments := Array new writeStream.
	[ stream atEnd ] whileFalse: [ 
		arguments nextPut: self parseType ].
	^ arguments contents

]

{ #category : #parsing }
ObjCSpecParser >> parseMethod: aMethod [
	^ FFIFunctionSpec new
		returnType: (self parseType: aMethod returnType);
		arguments: (aMethod argumentTypes collect: [ :each | each ifNotNil: [ self parseType: each ] ]);
		yourself.
	
]

{ #category : #parsing }
ObjCSpecParser >> parseReturn [
	^ self parseType
]

{ #category : #parsing }
ObjCSpecParser >> parseType: aString [
	| ch typeStream |
	typeStream := aString readStream.
	[ TypeQualifiers includes: (ch := typeStream next) ] whileTrue. 
	^ FFICallout new 
		requestor: ObjCLibrary;
		resolveType: (MethodTypeMap at: ch)
]
