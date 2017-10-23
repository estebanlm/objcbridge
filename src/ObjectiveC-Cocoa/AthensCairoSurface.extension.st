Extension { #name : #AthensCairoSurface }

{ #category : #'*ObjectiveC-Cocoa' }
AthensCairoSurface class >> newCGContext: ctx width: aWidth height: aHeight [
	^ (self primCGContext: ctx width: aWidth height: aHeight+1) initialize
]

{ #category : #'*ObjectiveC-Cocoa' }
AthensCairoSurface class >> primCGContext: ctx width: aWidth height: aHeight [
	^self ffiCall: #(AthensCairoSurface cairo_quartz_surface_create_for_cg_context (
		void *ctx,
		int aWidth,
		int aHeight))
]
