{lib}: let
  unpopRecursive = item:
    if lib.isAttrs item
    then
      if lib.hasAttr "__unpop__" item
      then lib.mapAttrs (n: v: unpopRecursive v) item.__unpop__
      else lib.mapAttrs (n: v: unpopRecursive v) item
    else if lib.isList item
    then map unpopRecursive item
    else item;
in {
  recursiveUnpop = lib.pop {
    extension = self: super: {
      __unpop__ = unpopRecursive (lib.unpop self);
    };
  };
}
