Extension { #name : #String }

{ #category : #'*ObjectiveC-Cocoa' }
String >> asNSString [
	^ self 
		ifNotEmpty: [ #NSString inObjC alloc initWithUTF8String: self ]
		ifEmpty: [ #NSString inObjC string ]
]
