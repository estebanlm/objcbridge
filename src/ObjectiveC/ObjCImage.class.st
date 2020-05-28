Class {
	#name : #ObjCImage,
	#superclass : #Object,
	#instVars : [
		'macLibraryFile'
	],
	#category : #'ObjectiveC-Core'
}

{ #category : #'instance creation' }
ObjCImage class >> named: aString [
	^ self new
			macLibraryFile: aString asFileReference;
			yourself
]

{ #category : #accessing }
ObjCImage >> macLibraryFile [
	^ macLibraryFile
]

{ #category : #accessing }
ObjCImage >> macLibraryFile: anObject [
	macLibraryFile := anObject
]
