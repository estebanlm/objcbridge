Class {
	#name : #ObjCBlockFunction,
	#superclass : #FFICallback,
	#category : #'ObjectiveC-Core'
}

{ #category : #initialization }
ObjCBlockFunction >> signature: signature block: aBlock [
	| parser |

	parser := self newParser.
	functionSpec := parser parseAnonymousFunction: signature.
	functionSpec arguments addFirst: (FFIVariableArgument name: '_blk' typeName: 'ObjCBlockStructure' arity: 1).

	functionSpec resolveUsing: parser requestor.

	block := aBlock
]

{ #category : #evaluating }
ObjCBlockFunction >> valueWithArguments: args [

	^ block valueWithArguments: args allButFirst
]
