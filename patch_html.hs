#!/usr/bin/env runghc

import System.IO
import Text.HTML.TagSoup

removeScript :: [Tag String] -> [Tag String]
removeScript tags = case tags of
    (TagOpen "script" _):_tags -> removeScript _tags
    (TagClose "script"):_tags  -> removeScript _tags
    (other:_tags)              -> other:(removeScript _tags)
    []                         -> []

insert :: [Tag String] -> [Tag String] -> [Tag String]
insert elts tags = case tags of
     (TagOpen "head" attrs):_tags -> (TagOpen "head" attrs):elts ++ _tags
     tag:_tags                    -> tag:(insert elts _tags)
     _                            -> []

main = do
    mathjax <- readFile "mathjax.html"
    let scripts = parseTags mathjax
    html <- getContents
    let tags = (insert scripts . removeScript . parseTags) html
    putStr (renderTags tags)
