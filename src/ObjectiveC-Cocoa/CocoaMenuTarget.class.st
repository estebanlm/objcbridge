Class {
	#name : #CocoaMenuTarget,
	#superclass : #Object,
	#instVars : [
		'proxy',
		'block'
	],
	#category : #'ObjectiveC-Cocoa'
}

{ #category : #accessing }
CocoaMenuTarget >> block [

	^ block
]

{ #category : #accessing }
CocoaMenuTarget >> block: anObject [

	block := anObject
]

{ #category : #accessing }
CocoaMenuTarget >> execute [
	<objCSignature: #(void ())>

	block value
]

{ #category : #accessing }
CocoaMenuTarget >> proxy [

	^ proxy
]

{ #category : #accessing }
CocoaMenuTarget >> proxy: anObject [

	proxy := anObject
]
