"
I'm a callout builder for Objective-C methods.
"
Class {
	#name : #ObjCCalloutMethodBuilder,
	#superclass : #FFICalloutMethodBuilder,
	#category : #'ObjectiveC-Builder'
}

{ #category : #'builder api' }
ObjCCalloutMethodBuilder class >> buildMethod: objCMethod [
	^ self new 
		requestor: (FFICallout new
			requestor: ObjCLibrary;
			yourself);
		buildMethod: objCMethod
]

{ #category : #private }
ObjCCalloutMethodBuilder >> adaptSpecToReturnType: aSpec [
	aSpec functionName: (self msgSendFunctionForReturnType: aSpec returnType)
]

{ #category : #'builder api' }
ObjCCalloutMethodBuilder >> buildMethod: objCMethod [
	| spec |
	spec := ObjCSpecParser new parseMethod: objCMethod.
	self adaptSpecToReturnType: spec.
	^ self generateMethodFromSpec: spec
]

{ #category : #accessing }
ObjCCalloutMethodBuilder >> callType [
	^ 0 "cdecl"
]

{ #category : #'private factory' }
ObjCCalloutMethodBuilder >> createFFICalloutLiteralFromSpec: spec [
	| externalFunction return arguments |
	
	return := spec returnType externalTypeWithArity.
	arguments := spec arguments collect: #externalTypeWithArity.
	spec returnType isTypeStructure ifTrue: [ 
		arguments := arguments copyWithFirst: spec returnType externalType asPointerType.
		return := FFIVoid externalType ].
	
	externalFunction := ExternalLibraryFunction
		name: spec functionName
		module: self libraryName
		callType: self callType
		returnType: return
		argumentTypes: arguments.
	
	functionResolutionStrategies
		detect: [ :each | each isApplicableFor: self requestor ]
		ifFound: [ :each | each resolve: externalFunction ].
		
	^ externalFunction
]

{ #category : #private }
ObjCCalloutMethodBuilder >> generateFFICallout: builder spec: spec [
	| numArgs |

	numArgs := spec arguments size.
	"Builds a method call"
	builder
		numArgs: numArgs;
		addTemps: ((1 to: numArgs) collect: [ :index | 'arg', index asString ]), #(result).
	
	"save ffi call as literal"
	builder pushLiteral: (self createFFICalloutLiteralFromSpec: spec).
	"iterate arguments in order (in the function) to create the function call"
	"if we have a structure, create and push it"
	spec returnType isTypeStructure 
		ifTrue: [ 
			builder 
				pushLiteralVariable: spec returnType objectClass binding;
				"send: #externalNew;
				send: #autoRelease;"
				send: #new;
				storeTemp: #result ].
	spec arguments withIndexDo: [ :each :index | 
		each 
			loader: (FFIMethodArgument new argName: 'arg', index asString);
			emitArgument: builder context: nil ].
	"create the array"
	builder pushConsArray: (spec returnType isTypeStructure 
		ifTrue: [ numArgs + 1 ]
		ifFalse: [ numArgs ]).
	"send call and store into result"
	builder send: #invokeWithArguments:.
	spec arguments
		do: [ :each | each emitReturnArgument: builder context: nil ].

	"Return result if this is a struct (it was passed as parameter)"
	spec returnType isTypeStructure ifTrue: [ 
		^ builder 
			pushTemp: #result;
			returnTop ].

	"convert in case return type needs it. And return reseult"
	^ spec returnType
		emitReturn: builder
		resultTempVar: #result
		context: sender
]

{ #category : #private }
ObjCCalloutMethodBuilder >> generateMethodFromSpec: spec [
	| ir |
	ir := IRBuilder buildIR: [ :builder | 
		self generateFFICallout: builder spec: spec ].
	^ ir generate
]

{ #category : #accessing }
ObjCCalloutMethodBuilder >> libraryName [
	^ ObjCLibrary uniqueInstance libraryName
]

{ #category : #private }
ObjCCalloutMethodBuilder >> msgSendFunctionForReturnType: aType [
	aType isTypeStructure ifTrue: [ ^ 'objc_msgSend_stret' ].
	aType isTypeFloat ifTrue: [ ^ 'objc_msgSend_fpret' ].
	^ 'objc_msgSend'
]
