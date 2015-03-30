{-# LANGUAGE OverloadedStrings, RecordWildCards #-} 
module Main where

import Text.XML.HXT.Core

main = do
  runX (readDocument [ withValidate no, withParseHTML yes, withInputEncoding utf8 ] ""
        >>> processChildren (process1 `when` isElem) 
        >>> writeDocument [] "-" 
        )

process1 :: ArrowXml a => a XmlTree XmlTree
process1 = 
        addNav >>>
        processTopDown (

              (returnA
                <+> (followingSiblingAxis >>> filterAxis (hasName "p") )
              )

              `when` withoutNav (hasName "p")
            
        )
        >>> remNav


deleteExtraParas :: ArrowXml a => a XmlTree XmlTree
deleteExtraParas = addNav
    >>> (getChildren >>> withoutNav (isElem >>> hasName "p"))
    >>> remNav

addText :: ArrowXml a => a XmlTree XmlTree
addText = replaceChildren (getChildren <+> txt " test")
      
        

{-
process = deep (isElem >>> hasName "p")
          >>> withNav (followingSiblingAxis >>> filterAxis (isElem >>> hasName "p"))
 -}         
