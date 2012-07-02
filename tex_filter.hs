#!/usr/bin/env runghc

import Data.Generics
import Text.Pandoc
import Text.JSON.Generic

apply :: Data a => (a -> a) -> Pandoc -> Pandoc
apply f = everywhere (mkT f) -- see 'Scrap Your Boilerplate' reference.

convert_raw_block :: Block -> Block
convert_raw_block (RawBlock "latex" content) = RawBlock "html" content
convert_raw_block other = other 

convert_raw_inline :: Inline -> Inline
convert_raw_inline (RawInline "tex" content) = RawInline "html" content
convert_raw_inline other = other
-- need to patch the output to support those references on the mathjax side
-- see: https://github.com/mathjax/MathJax/issues/71
-- basically, need in the preamble:
--
--     <script type="text/x-mathjax-config">
--     MathJax.Hub.Config({
--       TeX: { equationNumbers: { autoNumber: "AMS" } }
--     });
--     </script>
--     <script 
--       type="text/javascript"
--       src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
--     </script>
--
-- try with tagsoup ? http://hackage.haskell.org/packages/archive/tagsoup/latest/doc/html/Text-HTML-TagSoup.html
-- 
main = do
    input <- getContents
    let output = (encodeJSON . (apply convert_raw_block) . (apply convert_raw_inline) . decodeJSON) input
    putStr output


  
