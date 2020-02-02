"
I'm a callout builder for Objective-C methods.
"
Class {
	#name : #ObjCCalloutMethodBuilder,
	#superclass : #FFICalloutMethodBuilder,
	#category : #'ObjectiveC-Builder'
}

{ #category : #'builder api' }
ObjCCalloutMethodBuilder class >> buildMethod: objCMethod sender: aContext [

	^ self new 
		sender: aContext;
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
	spec resolveUsing: self requestor.
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
	arguments := spec arguments collect: [ :each | each tfExternalTypeWithArity ].
	spec returnType isTypeStructure ifTrue: [ 
		arguments := arguments copyWithFirst: spec returnType tfExternalType asPointerType.
		return := FFIVoid externalType ].
	
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
	functionSpec arguments do: [ :each | each emitArgument: builder context: sender inCallout: self requestor ].
	"create the array"
	builder pushConsArray: functionSpec arguments size.
	"send call and store into result"
	builder send: #invokeFunction:withArguments:.
	
	functionSpec arguments do: [ :each | each emitReturnArgument: builder context: sender ].
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

{ #category : #private }
ObjCCalloutMethodBuilder >> msgSendFunctionForReturnType: aType [
	aType isTypeStructure ifTrue: [ ^ 'objc_msgSend_stret' ].
	aType isTypeFloat ifTrue: [ ^ 'objc_msgSend_fpret' ].
	^ 'objc_msgSend'
]
