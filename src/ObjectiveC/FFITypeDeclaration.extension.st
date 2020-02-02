Extension { #name : #FFITypeDeclaration }

{ #category : #'*ObjectiveC' }
FFITypeDeclaration >> objCSignatureType [

	^ self resolvedType objCSignatureType
]
