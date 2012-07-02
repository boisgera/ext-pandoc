#!/usr/bin/env runghc

import System.IO
import Text.HTML.TagSoup

isTag :: String -> Tag String -> Bool
isTag name tag = (isTagOpenName name tag) || (isTagCloseName name tag)

removeTag :: String -> [Tag String] -> [Tag String]
removeTag name = filter (\tag -> not (isTag name tag))

insertTags :: [Tag String] -> [Tag String] -> [Tag String]
insertTags elts tags = case tags of
     (TagOpen "head" attrs):_tags -> (TagOpen "head" attrs):elts ++ _tags
     tag:_tags                    -> tag:(insertTags elts _tags)
     _                            -> []

main = do
    mathjax <- readFile "mathjax.html"
    let scripts = parseTags mathjax
    html <- getContents
    let tags = (insertTags scripts . removeTag "script" . parseTags) html
    putStr (renderTags tags)
