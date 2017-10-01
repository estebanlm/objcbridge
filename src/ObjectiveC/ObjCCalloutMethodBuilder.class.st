Class {
	#name : #ObjCCalloutMethodBuilder,
	#superclass : #Object,
	#category : #ObjectiveC
}

{ #category : #'builder api' }
ObjCCalloutMethodBuilder >> buildMethod: objCMethod [
	| spec |
	spec := ObjCSpecParser new parseMethod: objCMethod.
	self generateMethodFromSpec: spec.
]

{ #category : #'builder api' }
ObjCCalloutMethodBuilder >> generateMethodFromSpec: spec [
	| ir |
	ir := IRBuilder buildIR: [ :builder | 
		self generateFFICallout: builder spec: spec ].
	^ ir generate
]
