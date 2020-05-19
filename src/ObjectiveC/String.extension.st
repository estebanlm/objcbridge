Extension { #name : #String }

{ #category : #'*ObjectiveC' }
String >> adaptToObjC [
	| str |
	self flag: #todo. "I don't know why, strings smaller than 12 length are crashing the VM"
	str := UTF8TextConverter new convertFromSystemString: self.
	^ str "^ str size >= 12 
		ifTrue: [ str ]
		ifFalse: [ str padRightTo: 12 with: Character space ]"
	
		
]

{ #category : #'*ObjectiveC' }
String >> asObjCFourCharCode [
	"Adapted from https://stackoverflow.com/a/31321444"

	^ self inject: 0 into: [ :sum :e | (sum << 8) + e asciiValue ]
]

{ #category : #'*ObjectiveC' }
String >> inObjC [
	^ ObjCClass lookup: self asString
]

{ #category : #'*ObjectiveC' }
String >> inObjCFramework: frameworkName [
	^ ObjCClass lookup: self inFramework: frameworkName
]
