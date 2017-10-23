Class {
	#name : #CoreGraphicsLibrary,
	#superclass : #FFILibrary,
	#category : #ObjectiveC-Cocoa
}

{ #category : #'accessing platform' }
CoreGraphicsLibrary >> macModuleName [
	^ ObjCClass frameworkLibraryNameFor: 'CoreGraphics'
]
