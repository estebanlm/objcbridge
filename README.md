# ObjcBridge
Yet another Pharo-ObjectiveC bridge, using UnifiedFFI as backend.

# Install
While in fact this can be used generically on ObjC, for obvious reasons it has been tested just on macOS :)

```Smalltalk
Metacello new 
  repository: 'github://estebanlm/objcbridge/src';
  baseline: 'ObjCBridge';
  load.
```

## Acknowledge
This bridge is largelly inspired on [John McIntosh's](https://github.com/johnmci) previous bridge, but this one was rewritten to use UnifiedFFI (the new backend for FFI). Credits to him and [Eliot Miranda](https://github.com/eliotmiranda) for made this possible.
