"
I represent the Objective-C Runtime's Ivar data type. See documention at https://developer.apple.com/documentation/objectivec/ivar?language=objc
"
Class {
	#name : #ObjCInstanceVariable,
	#superclass : #FFIExternalObject,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #'ObjectiveC-Core'
}

{ #category : #displaying }
ObjCInstanceVariable >> displayString [
	^ self getName
]

{ #category : #'objective-c run-time' }
ObjCInstanceVariable >> getName [
	"https://developer.apple.com/documentation/objectivec/1418922-ivar_getname?language=objc"
	^ self ffiCall: #(const char * ivar_getName(Ivar self))
]

{ #category : #'objective-c run-time' }
ObjCInstanceVariable >> getOffset [
	"https://developer.apple.com/documentation/objectivec/1418976-ivar_getoffset?language=objc"
	^ self ffiCall: #(ptrdiff_t ivar_getOffset(Ivar self))
]

{ #category : #'objective-c run-time' }
ObjCInstanceVariable >> getTypeEncoding [
	"https://developer.apple.com/documentation/objectivec/1418569-ivar_gettypeencoding?language=objc"
	^ self ffiCall: #(const char * ivar_getTypeEncoding(Ivar self))
]

{ #category : #inspecting }
ObjCInstanceVariable >> gtInspectorRuntimeIn: composite [
	<gtInspectorPresentationOrder: 10>
	composite fastTreeTable
		title: 'Runtime (ObjC)';
		hasChildren: [ :e | e value isArray and: [ e isKindOf: Association ] ];
		display: [ { 
			'Name' -> self getName.
			'Offset' -> self getOffset.
			'Type Encoding' -> self getTypeEncoding } ];
		column: 'Field' translated evaluated: [  :e | (e isKindOf: Association) ifTrue: [ e key ] ifFalse: [ e displayString ] ];
		column: 'Value' translated evaluated: [  :e | 
			e value isArray 
				ifTrue: [ e value size asString, ' items' ] 
				ifFalse: [ 
					((e value respondsTo: #isNull) and: [ e value isNull ]) 
						ifTrue: [ 'null' ] 
						ifFalse: [ e value ] ] ];
		children: [ :e | e value ];
		send: #value
]

{ #category : #printing }
ObjCInstanceVariable >> printOn: aStream [
	super printOn: aStream.
	aStream 
		space;
		nextPutAll: self getName
]
