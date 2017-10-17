Class {
	#name : #CocoaApplication,
	#superclass : #Object,
	#classVars : [
		'Current'
	],
	#pools : [
		'CocoaConstants'
	],
	#category : #ObjectiveC-Cocoa
}

{ #category : #accessing }
CocoaApplication class >> current [
	^ Current
]

{ #category : #running }
CocoaApplication >> run [
	"sub... here put main menu, etc."
	Current := self
]
