Extension { #name : #String }

{ #category : #'*ObjectiveC-Cocoa' }
String >> asNSString [

	<ignoreNotImplementedSelectors: #( #initWithUTF8String: )>
	| encoded param |
	encoded := self utf8Encoded.
	param := ByteArray new: encoded size + 1.
	param pinInMemory.

	LibC memCopy: encoded to: param size: encoded size.
	param at: encoded size + 1 put: 0.

	^ #NSString inObjC alloc initWithUTF8String: param
]
