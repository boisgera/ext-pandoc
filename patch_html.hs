#!/usr/bin/env runghc

import System.IO
import Text.HTML.TagSoup
-- import Text.HTML.TagSoup.Tree


removeScript :: [Tag String] -> [Tag String]
removeScript ((TagOpen "script" _):tags) = removeScript tags
removeScript ((TagClose "script"):tags) = removeScript tags
removeScript (other:tags) = other:(removeScript tags)
removeScript [] = []

insert :: [Tag String] -> [Tag String] -> [Tag String]
insert ((TagOpen "head" attrs):tags) extra = (TagOpen "head" attrs):extra ++ tags
insert (tag:tags) extra = tag:(insert tags extra)
insert [] extra = []

main = do
    mathjax <- readFile "mathjax.html"
    let scripts = parseTags mathjax
    html <- getContents
    let tags = insert (removeScript (parseTags html)) scripts
    putStr (renderTags tags)
