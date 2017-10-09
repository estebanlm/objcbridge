Extension { #name : #String }

{ #category : #'*ObjectiveC' }
String >> adaptToObjC [
	^ self asUTF8String
]

{ #category : #'*ObjectiveC' }
String >> asUTF8String [
	^ UTF8TextConverter new convertFromSystemString: self
]

{ #category : #'*ObjectiveC' }
String >> inObjC [
	^ ObjCClass lookup: self asString
]

{ #category : #'*ObjectiveC' }
String >> inObjCFramework: frameworkName [
	^ ObjCClass lookup: self inFramework: frameworkName
]
