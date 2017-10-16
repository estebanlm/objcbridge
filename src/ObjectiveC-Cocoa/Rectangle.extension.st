Extension { #name : #Rectangle }

{ #category : #'*ObjectiveC-Cocoa' }
Rectangle >> asNSRect [
	^ NSRect 
		x: self origin x 
		y: self origin y
		width: self extent x 
		height: self extent y
]
