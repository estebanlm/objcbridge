Class {
	#name : #UNNotificationPresentationOptions,
	#superclass : #FFIEnumeration,
	#classVars : [
		'UNNotificationPresentationOptionBadge',
		'UNNotificationPresentationOptionBanner',
		'UNNotificationPresentationOptionList',
		'UNNotificationPresentationOptionSound'
	],
	#category : #'ObjectiveC-Cocoa-Notifications'
}

{ #category : #'accessing enum' }
UNNotificationPresentationOptions class >> UNNotificationPresentationOptionBadge [
	"This method was automatically generated"
	^ UNNotificationPresentationOptionBadge
]

{ #category : #'accessing enum' }
UNNotificationPresentationOptions class >> UNNotificationPresentationOptionBanner [
	"This method was automatically generated"
	^ UNNotificationPresentationOptionBanner
]

{ #category : #'accessing enum' }
UNNotificationPresentationOptions class >> UNNotificationPresentationOptionList [
	"This method was automatically generated"
	^ UNNotificationPresentationOptionList
]

{ #category : #'accessing enum' }
UNNotificationPresentationOptions class >> UNNotificationPresentationOptionSound [
	"This method was automatically generated"
	^ UNNotificationPresentationOptionSound
]

{ #category : #'enum declaration' }
UNNotificationPresentationOptions class >> enumDecl [
	"
	self initializeEnumeration
	"

	^ #(
		UNNotificationPresentationOptionBadge 	1
		UNNotificationPresentationOptionBanner 	16
		UNNotificationPresentationOptionList		8
		UNNotificationPresentationOptionSound 	2
	)
]
