FX Versions are an important part of a resource manifest and there is very little context about what they mean. Below will be a list of versions and how they are differentiated. Typically the default resource manifest version for any **fxmanifest.lua** created from this date forward should be **cerulean**. Occasionally check [here](https://docs.fivem.net/docs/scripting-reference/resource-manifest/resource-manifest/#fxv2-versions) in case new versions are released.

## FX version `cerulean` (2020-05)
- Loads NUI resources in a 'secure context' to support WASM and fetch APIs, but requires callbacks to be changed to https:// instead of http://.

## FX version `bodacious` (2020-02)
- Implies clr_disable_task_scheduler being specified for server library compatibility.
- Does not define window in JS contexts for library compatibility.

## FX version `adamant` (2019-12)
- Equivalent to 44febabe-d386-4d18-afbe-5e627f4af937 in FXv1.
- Requires a game to be specified, and is mandatory for RedM.
