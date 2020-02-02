Extension { #name : #FFIFunctionArgument }

{ #category : #'*ObjectiveC' }
FFIFunctionArgument >> objCSignatureType [

	^ self resolvedType objCSignatureType
]
