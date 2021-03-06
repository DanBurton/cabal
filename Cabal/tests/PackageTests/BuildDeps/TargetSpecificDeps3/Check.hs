module PackageTests.BuildDeps.TargetSpecificDeps3.Check where

import Test.Tasty.HUnit
import PackageTests.PackageTester
import System.FilePath
import Data.List
import qualified Control.Exception as E
import Text.Regex.Posix


suite :: FilePath -> Assertion
suite ghcPath = do
    let spec = PackageSpec
            { directory = "PackageTests" </> "BuildDeps" </> "TargetSpecificDeps3"
            , configOpts = []
            , distPref = Nothing
            }
    result <- cabal_build spec ghcPath
    do
        assertEqual "cabal build should fail - see test-log.txt" False (successful result)
        assertBool "error should be in lemon.hs" $
            "lemon.hs:" `isInfixOf` outputText result
        assertBool "error should be \"Could not find module `System.Time\"" $
            (intercalate " " $ lines $ outputText result)
            =~ "Could not find module.*System.Time"
      `E.catch` \exc -> do
        putStrLn $ "Cabal result was "++show result
        E.throwIO (exc :: E.SomeException)
