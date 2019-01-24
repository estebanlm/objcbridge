"
I define a class as part of the ObjC infrastructure.
"
Trait {
	#name : #TObjCLibrary,
	#category : #'ObjectiveC-Core'
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
