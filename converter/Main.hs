{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.Maybe as M
import qualified GHC.Exts as E
import qualified Data.List.NonEmpty as NE
import qualified Data.Aeson as J
import qualified Nix as N
import qualified Nix.Pretty as NP
import qualified Data.Scientific as DS

import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as BS
import qualified Data.Fix as F

atomJSONToNix :: J.Value -> N.NExpr
atomJSONToNix (J.String x) = N.mkStr x
atomJSONToNix (J.Number x) = case DS.isInteger x of
                               True -> N.mkInt $ DS.coefficient x * 10 ^ DS.base10Exponent x
                               False -> error "Cannot convert JSON float to Nix integer"
atomJSONToNix (J.Bool x) = N.mkBool x
atomJSONToNix (J.Null) = N.mkNull
atomJSONToNix  (J.Object x) =
   N.mkNonRecSet $ map (\(key, value) -> T.pack (show key) N.$= atomJSONToNix value) (toList x)
atomJSONToNix (J.Array x) = N.mkList $ map atomJSONToNix $ E.toList x
atomJSONToNix _ = error "Cannot convert JSON value to Nix value"
-- panelJSONToNix _ = fail "wrong type"

-- mkPanel panelJSON = (typeToFunc (panelType panelJSON))
--   $ NAttrs { ... }
--
-- mkAnnotation annotationJSON = (nixFun "lib.annotation.new")
--   (nAttrs annotationJSON)

getPanel (Fix x) = getPanel $ F.unFix x
getPanel (NSet _ xs) = head $ filter (\(NamedVar (StaticKey (VarName n) NE.:| []) _) -> )

createDashboard :: N.NExpr -> N.NExpr
createDashboard args = N.mkFunction
  (N.mkParamSet deps
  (N.mkLets (T.Pack "lib") mergedLib (
      Fix (N.NBinary N.NApp (mkSym "lib.dashboard.new") (args))
  ))
  where
    deps = [
      (T.pack "grafonnix", Nothing),
      (T.pack "POP", Nothing)
    ]
    mergedLib = N.mkSym "grafonnix.lib" N.$// N.mkSym "POP.lib"


convert :: BS.ByteString -> BS.ByteString
convert input = BS.pack $ show $ NP.prettyNix $ atomJSONToNix $ M.fromJust $ J.decode input

main :: IO ()
main = BS.interact convert
