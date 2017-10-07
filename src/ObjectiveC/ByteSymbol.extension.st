Extension { #name : #ByteSymbol }

{ #category : #'*ObjectiveC' }
ByteSymbol >> asObjCSelector [
	^ ObjCSelector register: self
]
