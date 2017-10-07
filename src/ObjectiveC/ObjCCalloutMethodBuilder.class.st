Class {
	#name : #ObjCCalloutMethodBuilder,
	#superclass : #FFICalloutMethodBuilder,
	#category : #ObjectiveC
}

{ #category : #'builder api' }
ObjCCalloutMethodBuilder class >> buildMethod: objCMethod [
	^ self new 
		requestor: (FFICallout new
			requestor: ObjCLibrary;
			yourself);
		buildMethod: objCMethod
]

{ #category : #'builder api' }
ObjCCalloutMethodBuilder >> buildMethod: objCMethod [
	| spec |
	spec := ObjCSpecParser new parseMethod: objCMethod.
	spec functionName: 'method_invoke'.
	^ self generateMethodFromSpec: spec.

]

{ #category : #'builder api' }
ObjCCalloutMethodBuilder >> callType [
	^ 0 "cdecl"
]

{ #category : #'builder api' }
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
	spec arguments withIndexDo: [ :each :index | 
		each 
			loader: (FFIMethodArgument new argName: 'arg', index asString);
			emitArgument: builder context: nil ].
	"create the array"
	builder pushConsArray: numArgs.
	"send call and store into result"
	builder send: #invokeWithArguments:.
	spec arguments
		do: [ :each | each emitReturnArgument: builder context: nil ].
	"convert in case return type needs it. And return reseult"
	^ spec returnType
		emitReturn: builder
		resultTempVar: #result
		context: sender
]

{ #category : #'builder api' }
ObjCCalloutMethodBuilder >> generateMethodFromSpec: spec [
	| ir |
	ir := IRBuilder buildIR: [ :builder | 
		self generateFFICallout: builder spec: spec ].
	^ ir generate
]

{ #category : #'builder api' }
ObjCCalloutMethodBuilder >> moduleName [
	^ ObjCLibrary uniqueInstance moduleName
]
