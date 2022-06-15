# Grafonnix

Implementation of [grafonnet](https://github.com/grafana/grafonnet-lib) in nix.

## Usage

Most functions return [POP](https://github.com/divnix/POP) objects that are extendable with functions within the object or any other POP extension methods.

For example to create a new row:

``` nix
r = lib.row.new {}
```

Then panels can be added with:

```
r.addPanel { { ... } }
```

## Implementation

The goal is for the code to be as close to grafonnet as possible within the feature set of nix. POP is used to return objects wherever possible, because nix doesn't have a native object system like jsonnet does.
