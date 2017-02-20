{-# LANGUAGE TemplateHaskell #-}
module Buffer (Buffer(Buffer),
               drawBuffer,
               charAt,
               lineAt,
               insertCharAt,
               deleteCharAt,
               insertLineAt,
               deleteLineAt) where

import Data.Label
import Data.List
import qualified Brick.Types as T
import Brick.Widgets.Core

data Buffer =
  Buffer { _lns :: [String]
         , _path :: String
         }

mkLabel ''Buffer

drawBuffer :: Buffer -> T.Widget n
drawBuffer buffer = str (unlines (get lns buffer))

charAt :: Buffer -> (Int, Int) -> Char
charAt buffer (x, y) = ((get lns buffer)!!y)!!x

lineAt :: Buffer -> (t, Int) -> String
lineAt buffer (x, y) = (get lns buffer)!!y

insertLineAt :: Buffer -> (t, Int) -> Buffer
insertLineAt buffer (x, y) =
  let (as, bs) = splitAt (y + 1) (get lns buffer)
  in set lns (as ++ [[]] ++ bs) buffer

deleteLineAt :: Buffer -> (t, Int) -> Buffer
deleteLineAt buffer (x, y) =
  let (as, bs) = splitAt (y + 1) (get lns buffer)
  in set lns ((init as) ++ bs) buffer

insertCharAt :: Buffer -> Char -> (Int, Int) -> Buffer
insertCharAt buffer char (x, y) =
  let (as, bs) = splitAt y (get lns buffer)
  in let (ys, zs) = splitAt x (lineAt buffer (x, y))
     in set lns (as ++ [ys ++ [char] ++ zs] ++ (tail bs)) buffer

deleteCharAt :: Buffer -> (Int, Int) -> Buffer
deleteCharAt buffer (x, y) =
  let (as, bs) = splitAt y (get lns buffer)
  in let (ys, zs) = splitAt x (lineAt buffer (x, y))
     in set lns (as ++ [ys ++ (tail zs)] ++ (tail bs)) buffer

