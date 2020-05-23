Trait {
	#name : #TObjCInspectable,
	#category : #'ObjectiveC-Core'
}

{ #category : #inspecting }
TObjCInspectable >> gtInspectorObjCRuntimeFields: anArray in: composite [
	
	composite fastTreeTable
		title: 'Runtime (ObjC)';
		hasChildren: [ :e | e value isArray and: [ e isKindOf: Association ] ];
		display: [ anArray ];
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
