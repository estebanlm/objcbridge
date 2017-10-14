Extension { #name : #FFIExternalReferenceType }

{ #category : #'*ObjectiveC' }
FFIExternalReferenceType >> objCSignatureType [
	^ ObjCSpecParser reverseType: self objectClass theNonMetaClass
]
