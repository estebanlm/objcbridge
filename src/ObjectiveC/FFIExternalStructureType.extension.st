Extension { #name : #FFIExternalStructureType }

{ #category : #'*ObjectiveC' }
FFIExternalStructureType >> isTypeStructure [
	^ true
]

{ #category : #'*ObjectiveC' }
FFIExternalStructureType >> objCSignatureType [
	^ '{', self objectClass name, '}'
]
