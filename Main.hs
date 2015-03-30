{-# LANGUAGE OverloadedStrings, RecordWildCards #-} 
module Main where

import Text.XML.HXT.Core

main = do
  runX (readDocument [ withValidate no, withParseHTML yes, withInputEncoding utf8 ] ""
        >>> processTopDown process1
        >>> writeDocument [] "-" 
        )

process1 :: ArrowXml a => a XmlTree XmlTree
process1 = 
      addText
      `when`
      (isElem >>> hasName "p")

addText :: ArrowXml a => a XmlTree XmlTree
addText = replaceChildren (getChildren <+> txt " test")
      
        

{-
process = deep (isElem >>> hasName "p")
          >>> withNav (followingSiblingAxis >>> filterAxis (isElem >>> hasName "p"))
 -}         
