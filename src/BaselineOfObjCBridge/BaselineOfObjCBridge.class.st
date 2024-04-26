Class {
	#name : #BaselineOfObjCBridge,
	#superclass : #BaselineOf,
	#category : #BaselineOfObjCBridge
}

{ #category : #baselines }
BaselineOfObjCBridge >> baseline: spec [
	<baseline>
	
	spec for: #common do: [
		spec package: 'ObjectiveC'.
		spec package: 'ObjectiveC-Cocoa'].
]
