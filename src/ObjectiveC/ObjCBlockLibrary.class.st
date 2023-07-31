Class {
	#name : #ObjCBlockLibrary,
	#superclass : #FFILibrary,
	#category : #'ObjectiveC-Core'
}

{ #category : #converting }
ObjCBlockLibrary >> calloutAPIClass [

	^ TFCalloutAPI
]

{ #category : #converting }
ObjCBlockLibrary >> runner [

	^ TFWorker default
]
