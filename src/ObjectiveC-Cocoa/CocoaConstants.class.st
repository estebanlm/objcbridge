Class {
	#name : #CocoaConstants,
	#superclass : #SharedPool,
	#classVars : [
		'NSOrderedAscending',
		'NSOrderedDescending',
		'NSOrderedSame',
		'NSSquareStatusItemLength',
		'NSVariableStatusItemLength'
	],
	#category : #'ObjectiveC-Cocoa'
}

{ #category : #'class initialization' }
CocoaConstants class >> initialize [
	"NSStatusBar.h"
	"Status item positioning length"
	NSVariableStatusItemLength := -1.
	NSSquareStatusItemLength := -2.	
	
	"NSComparisonResult"
	NSOrderedAscending := -1.
	NSOrderedSame := 0.
	NSOrderedDescending := 1.
]
