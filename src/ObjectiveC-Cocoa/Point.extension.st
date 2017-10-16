Extension { #name : #Point }

{ #category : #'*ObjectiveC-Cocoa' }
Point >> asNSPoint [
	^ NSPoint x: self x y: self y
]

{ #category : #'*ObjectiveC-Cocoa' }
Point >> asNSSize [
	^ self asNSPoint
]
