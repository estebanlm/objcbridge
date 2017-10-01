Trait {
	#name : #TObjCLibrary,
	#category : #ObjectiveC
}

{ #category : #accessing }
TObjCLibrary classSide >> ffiBindingOf: aName [
	^ ObjCLibrary ffiBindingOf: aName
]

{ #category : #accessing }
TObjCLibrary classSide >> ffiLibraryName [
	^ ObjCLibrary
]

{ #category : #accessing }
TObjCLibrary >> ffiBindingOf: aName [
	^ self class ffiBindingOf: aName
]

{ #category : #accessing }
TObjCLibrary >> ffiLibraryName [
	^ ObjCLibrary
]
