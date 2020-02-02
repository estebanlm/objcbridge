Extension { #name : #FFIExternalType }

{ #category : #'*ObjectiveC' }
FFIExternalType >> isTypeFloat [
	^ false
]

{ #category : #'*ObjectiveC' }
FFIExternalType >> isTypeStructure [
	^ false
]

{ #category : #'*ObjectiveC' }
FFIExternalType >> objCSignatureType [

	^ ObjCSpecParser reverseType: self class
]
