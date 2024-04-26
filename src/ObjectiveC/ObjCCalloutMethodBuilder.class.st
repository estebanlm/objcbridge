"
I'm a callout builder for Objective-C methods.
"
Class {
	#name : #ObjCCalloutMethodBuilder,
	#superclass : #FFICalloutMethodBuilder,
	#instVars : [
		'message'
	],
	#category : #'ObjectiveC-Builder'
}

{ #category : #'builder api' }
ObjCCalloutMethodBuilder class >> buildMethod: objCMethod message: aMessage sender: aContext [

	^ self new 
		sender: aContext;
		message: aMessage;
		requestor: (FFICallout new
			requestor: ObjCLibrary;
			yourself);
		buildMethod: objCMethod
]

{ #category : #private }
ObjCCalloutMethodBuilder >> adaptSpecToReturnType: aSpec [

	aSpec functionName: (self msgSendFunctionForReturnType: aSpec returnType)
]

{ #category : #accessing }
ObjCCalloutMethodBuilder >> argumentNames [

	^ self message arguments 
		withIndexCollect: [ :each :index | 'arg', index printString ]
]

{ #category : #'builder api' }
ObjCCalloutMethodBuilder >> buildMethod: objCMethod [
	| spec argumentNames |
	
	spec := ObjCSpecParser new parseMethod: objCMethod.
	spec resolveUsing: self requestor.
	"loader for self"
	spec arguments first loader: (FFISelfArgument new).
	"loader for SEL"
	spec arguments second loader: (FFILiteralArgument value: self message selector asObjCSelector).
	"loader for arguments"
	argumentNames := self argumentNames.
	(spec arguments allButFirst: 2) withIndexDo: [ :each :index |
		each loader: (FFIMethodArgument new
			argName: (argumentNames at: index);
			index: index;
			yourself) ].
		  
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
	
	return := spec returnType tfExternalTypeWithArity.
	arguments := spec arguments collect: [ :each | each tfExternalTypeWithArity ].
	spec returnType isTypeStructure ifTrue: [ 
		arguments := arguments copyWithFirst: spec returnType tfExternalType asPointerType.
		return := FFIVoid new tfExternalType ].
	
	externalFunction := TFExternalFunction
		name: spec functionName
		moduleName: self libraryName
		parameterTypes: arguments
		returnType: return.
	
	functionResolutionStrategies
		detect: [ :each | each isApplicableFor: self requestor ]
		ifFound: [ :each | each resolve: externalFunction ].
		
	^ externalFunction
]

{ #category : #private }
ObjCCalloutMethodBuilder >> generateFFICallout: builder spec: functionSpec [
	| properties |

	"Copy the properties of the old method"
	sender methodProperties ifNotNil: [ 
		properties := sender methodProperties copy.
		properties method: nil.
		builder properties: properties ].

	builder
		numArgs: self argumentNames size;
		addTemps: (self argumentNames copyWith: #result).

	TFCalloutAPI isTracing ifTrue: [ 
		TFCalloutAPI trace: sender. 
		builder 
			pushLiteral: TFCalloutAPI;
			pushLiteral: sender;
			send: #trace: ].

	"Obtain the library to use"
	builder 
		pushReceiver;
		send: #ffiLibrary;
		send: #uniqueInstance.
		
	"Obtain the runner to use."
	builder send: #runner.

	"Builds a method call"
	"save ffi call as literal"
	builder pushLiteral: (self createFFICalloutLiteralFromSpec: functionSpec).
	"iterate arguments in order (in the function) to create the function call"
	functionSpec arguments do: [ :each | 
		each emitArgument: builder context: sender inCallout: self requestor.
		each resolvedType tfExternalTypeWithArity emitMarshallToPrimitive: builder ].

	"create the array"
	builder pushConsArray: functionSpec arguments size.
	builder addTemp: #argumentsArray.
	builder storeTemp: #argumentsArray.

	"send call and store into result"
	builder send: #invokeFunction:withArguments:.
	
	functionSpec arguments withIndexDo: [ :each :index|
		each emitReturnArgument: builder context: sender.
		each resolvedType tfExternalTypeWithArity
			emitFreeIfNeededOfIndex: index
			argumentsArrayTempName: #argumentsArray
			withBuilder: builder  ].

	"Additional marshall in the case of TFFI"
	functionSpec returnType resolvedType tfExternalTypeWithArity emitMarshallFromPrimitive: builder.

	"convert in case return type needs it. And return reseult"

	^ functionSpec returnType
		emitReturn: builder
		resultTempVar: #result
		context: sender
		inCallout: self requestor
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

{ #category : #accessing }
ObjCCalloutMethodBuilder >> message [

	^ message
]

{ #category : #accessing }
ObjCCalloutMethodBuilder >> message: aMessage [

	message := aMessage
]

{ #category : #private }
ObjCCalloutMethodBuilder >> msgSendFunctionForReturnType: aType [

	aType isTypeStructure ifTrue: [ ^ 'objc_msgSend_stret' ].
	aType isTypeFloat ifTrue: [ ^ 'objc_msgSend_fpret' ].
	^ 'objc_msgSend'
]
