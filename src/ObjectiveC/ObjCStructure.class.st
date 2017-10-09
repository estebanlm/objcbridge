"
I'm an Objective-C inner structure. 
Tipically, classes, methods and selectors in Objective-C are no more than structures that the compiler knows how to ""traduce"" from message sends to regular function calls.

Anyway, we have access to those structures and sometimes is useful to economise calls (we should not abuse it anyway)
"
Class {
	#name : #ObjCStructure,
	#superclass : #FFIExternalStructure,
	#traits : 'TObjCLibrary',
	#classTraits : 'TObjCLibrary classTrait',
	#category : #ObjectiveC-Inner
}
