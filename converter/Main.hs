{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Maybe
import qualified Data.Aeson as J
import qualified Nix as N
import qualified Nix.Pretty as NP
import qualified Data.Scientific as DS
import GHC.Exts
import qualified Data.Text as T
import qualified Data.ByteString.Lazy.Char8 as BS

atomJSONToNix :: J.Value -> N.NExpr
atomJSONToNix (J.String x) = N.mkStr x
atomJSONToNix (J.Number x) = case DS.isInteger x of
                               True -> N.mkInt $ DS.coefficient x * 10 ^ DS.base10Exponent x
                               False -> error "Cannot convert JSON float to Nix integer"
atomJSONToNix (J.Bool x) = N.mkBool x
atomJSONToNix (J.Null) = N.mkNull
atomJSONToNix  (J.Object x) =
   N.mkNonRecSet $ map (\(key, value) -> T.pack (show key) N.$= atomJSONToNix value) (toList x)
atomJSONToNix _ = error "Cannot convert JSON value to Nix value"
-- panelJSONToNix _ = fail "wrong type"

-- mkPanel panelJSON = (typeToFunc (panelType panelJSON))
--   $ NAttrs { ... }
--
-- mkAnnotation annotationJSON = (nixFun "lib.annotation.new")
--   (nAttrs annotationJSON)

convert :: BS.ByteString -> BS.ByteString
convert input = BS.pack $ show $ NP.prettyNix $ atomJSONToNix $ fromJust $ J.decode input

main :: IO ()
main = BS.interact convert
