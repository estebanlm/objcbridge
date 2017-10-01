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
		at: $* "_CHARPTR"		put: #oop;
		"at: $[" "_C_ARY_B"	"put: [];"
		"at: $]" "_C_ARY_E"	"put: [];"
		"at: $(" "_C_UNION_B"	"put: [];"
		"at: $)" "_C_UNION_E"	"put: [];"
		at: ${ "_C_STRUCT_B" 	put: #FFIExternalStructure.
		"at: $}" "_C_STRUCT_E""put: []."

#(
	FourByteParameterTypes := '@#:cCsSiIlLf^*'.
	EightByteParameterTypes := 'd'.
).

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
#(				
	MethodTypeResultMap := IdentityDictionary new: 32.
	MethodTypeResultMap
		at: $c "_CHR"			put: [:alien| alien unsignedByteAt: 1];
		at: $C "_C_UCHR"		put: [:alien| alien unsignedByteAt: 1];
		at: $s "_C_SHT"			put: [:alien| alien signedShortAt: 1];
		at: $S "_C_USHT"		put: [:alien| alien unsignedShortAt: 1];
		at: $i "_C_INT"			put: [:alien| alien signedLongAt: 1];
		at: $I "_C_UINT"		put: [:alien| alien unsignedLongAt: 1];
		at: $l "_C_LNG"			put: [:alien| alien signedLongAt: 1];
		at: $L "_C_ULNG"		put: [:alien| alien unsignedLongAt: 1];
		at: $f "_C_FLT"			put: [:alien| alien floatAt: 1];
		at: $d "_C_DBL"		put: [:alien| alien doubleAt: 1].

	MethodTypeCallbackResultMap := IdentityDictionary new: 32.
	MethodTypeCallbackResultMap
		at: $v 					put: [ :value | 0 ] ;
		at: $c "_CHR"			put: [ :value | value asInteger] ;
		at: $C "_C_UCHR"		put: [ :value | value asInteger ];
		at: $s "_C_SHT"		put: [ :value | value asInteger ];
		at: $S "_C_USHT"		put: [ :value | value asInteger ];
		at: $i "_C_INT"			put: [ :value | value asInteger ];
		at: $I "_C_UINT"		put: [ :value | value asInteger ];
		at: $l "_C_LNG"			put: [ :value | value asInteger ];
		at: $L "_C_ULNG"		put: [ :value | value asInteger ];
		at: $f "_C_FLT"			put: [ :value | value asFloat ];
		at: $d "_C_DBL"		put: [ :value | value asFloat ].

	TypeSizes := IdentityDictionary new: 32.
	TypeSizes
		at: $c "_CHR"			put: 4;
		at: $C "_C_UCHR"		put: 4;
		at: $s "_C_SHT"		put: 4;
		at: $S "_C_USHT"		put: 4;
		at: $i "_C_INT"			put: 4;
		at: $I "_C_UINT"		put: 4;
		at: $l "_C_LNG"			put: 4;
		at: $L "_C_ULNG"		put: 4;
		at: $f "_C_FLT"			put: 4;
		at: $d "_C_DBL"		put: 8;
		at: $^					put: 4.
)
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
		functionName: aMethod name;
		returnType: (self parseType: aMethod returnType first);
		arguments: (aMethod argumentTypes collect: [ :each | each ifNotNil: [ self parseType: each first ] ]);
		yourself.
	
]

{ #category : #parsing }
ObjCSpecParser >> parseReturn [
	^ self parseType
]

{ #category : #parsing }
ObjCSpecParser >> parseType [
	| code type |
	
	[ 
		stream atEnd not 
		and: [ TypeQualifiers includes: (code := stream next) ] ] 
	whileTrue.
	type := MethodTypeMap at: code. "This will fail in case of a structure"
	^ FFICallout new 
		requestor: ObjCLibrary;
		resolveType: type
]

{ #category : #parsing }
ObjCSpecParser >> parseType: aCharacter [
	| type |
	type := MethodTypeMap at: aCharacter.
	^ FFICallout new 
		requestor: ObjCLibrary;
		resolveType: type
]
