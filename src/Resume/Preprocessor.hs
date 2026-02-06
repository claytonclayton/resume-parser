
module Resume.Preprocessor (preprocess) where

import qualified Data.Text as T
import Data.Text (Text)
import qualified Data.Text.Lazy.Builder as B
import Data.Text.Lazy (toStrict)

-- escaper is NAIVE
-- should check whether the escapees are already escaped
-- or not before escaping
preprocess :: Text -> Text
preprocess = toText . escaper . stripper
  where
    toText   = toStrict . B.toLazyText
    stripper = T.unlines . fmap T.strip . T.lines
    escaper  = T.foldr escape mempty
    escape c
      | c `elem` escapees = (<>) $ B.singleton '\\' <> B.singleton c 
      | otherwise         = (<>) $ B.singleton c
    escapees = ['&', '$', '%']
