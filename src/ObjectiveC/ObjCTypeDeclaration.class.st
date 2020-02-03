Class {
	#name : #ObjCTypeDeclaration,
	#superclass : #FFITypeDeclaration,
	#category : #'ObjectiveC-Builder'
}

{ #category : #'instance creation' }
ObjCTypeDeclaration class >> newType: aResolvedType [

	^ self new 
		resolvedType: aResolvedType;
		yourself
]

{ #category : #'emitting code' }
ObjCTypeDeclaration >> emitArgument: anIRBuilder context: aContext inCallout: aCallout [

	self resolvedType emitArgument: anIRBuilder context: aContext inCallout: aCallout
]

{ #category : #'emitting code' }
ObjCTypeDeclaration >> emitReturnArgument: anIRBuilder context: aContext [

	self resolvedType
		emitReturnArgument: anIRBuilder
		context: aContext
]

{ #category : #testing }
ObjCTypeDeclaration >> isTypeFloat [
	
	^ self resolvedType isTypeFloat
]

{ #category : #testing }
ObjCTypeDeclaration >> isTypeStructure [
	
	^ self resolvedType isTypeStructure
]

{ #category : #accessing }
ObjCTypeDeclaration >> loader: aLoader [
	
	self resolvedType loader: aLoader
]

{ #category : #resolution }
ObjCTypeDeclaration >> resolveUsing: aRequestor [
	"not used, I already solved it"
]

{ #category : #accessing }
ObjCTypeDeclaration >> resolvedType: aResolvedType [

	resolvedType := aResolvedType
]
