Class {
	#name : #CocoaConstants,
	#superclass : #SharedPool,
	#classVars : [
		'NSSquareStatusItemLength',
		'NSVariableStatusItemLength'
	],
	#category : #ObjectiveC-Cocoa
}

{ #category : #'class initialization' }
CocoaConstants class >> initialize [
	NSVariableStatusItemLength := -1.
	NSSquareStatusItemLength := -2.	
]
