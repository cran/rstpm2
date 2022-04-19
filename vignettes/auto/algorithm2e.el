(TeX-add-style-hook
 "algorithm2e"
 (lambda ()
   (TeX-run-style-hooks
    "ifthen"
    "ifoddpage"
    "xspace"
    "endfloat"
    "relsize"
    "xcolor"
    "tocbibind")
   (TeX-add-symbols
    '("SetKwIf" 6)
    '("Titleofalgo" 1)
    '("restylealgo" 1)
    '("showlnlabel" 1)
    '("Setnlsty" 3)
    '("nlSty" 1)
    '("setalcaphskip" 1)
    '("setalcapskip" 1)
    '("Setnlskip" 1)
    '("setnlskip" 1)
    '("decmargin" 1)
    '("incmargin" 1)
    '("SetAlgoRefName" 1)
    '("SetAlgoRefRelativeSize" 1)
    '("SetAlgorithmName" 3)
    '("TitleOfAlgo" 1)
    '("SetAlgoCaptionSeparator" 1)
    '("SetAlgoCaptionLayout" 1)
    '("SetKwRepeat" 3)
    '("SetKwFor" 4)
    '("SetKwIF" 8)
    '("SetKwSwitch" 9)
    '("SetStartEndCondition" 3)
    '("SetKwBlock" 3)
    '("SetKwArray" 2)
    '("SetKwFunction" 2)
    '("SetKw" 2)
    '("SetKwProgFn" 4)
    '("SetKwProg" 4)
    '("SetKwComment" 3)
    '("SetKwHangingKw" 2)
    '("SetKwData" 2)
    '("SetKwInput" 2)
    '("ResetInOut" 1)
    '("SetKwInOut" 2)
    '("SetAlgoBlockMarkers" 2)
    '("SetVlineSkip" 1)
    '("SetBlockMarkersSty" 1)
    '("BlockMarkersSty" 1)
    '("SetTitleSty" 2)
    '("TitleSty" 1)
    '("SetCommentSty" 1)
    '("CommentSty" 1)
    '("SetDataSty" 1)
    '("DataSty" 1)
    '("SetProgSty" 1)
    '("ProgSty" 1)
    '("SetFuncSty" 1)
    '("FuncSty" 1)
    '("SetFuncArgSty" 1)
    '("FuncArgSty" 1)
    '("SetArgSty" 1)
    '("ArgSty" 1)
    '("SetKwSty" 1)
    '("KwSty" 1)
    '("SetProcArgSty" 1)
    '("ProcArgSty" 1)
    '("SetProcNameSty" 1)
    '("ProcNameSty" 1)
    '("SetProcSty" 1)
    '("ProcSty" 1)
    '("SetAlCapNameSty" 1)
    '("AlCapNameSty" 1)
    '("SetAlCapSty" 1)
    '("AlCapSty" 1)
    '("SetAlTitleSty" 1)
    '("AlTitleSty" 1)
    '("SetProcArgFnt" 1)
    '("SetProcNameFnt" 1)
    '("SetProcFnt" 1)
    '("SetAlCapNameFnt" 1)
    '("SetAlCapFnt" 1)
    '("SetAlTitleFnt" 1)
    '("SetAlFnt" 1)
    '("ShowLnLabel" 1)
    '("SetEndCharOfAlgoLine" 1)
    '("lnlset" 2)
    '("lnl" 1)
    '("nlset" 1)
    '("nllabel" 1)
    '("SetNlSty" 3)
    '("NlSty" 1)
    '("SetAlgoNlRelativeSize" 1)
    '("Indentp" 1)
    '("SetAlCapHSkip" 1)
    '("SetAlCapSkip" 1)
    '("SetNlSkip" 1)
    '("DecMargin" 1)
    '("IncMargin" 1)
    '("SetInd" 2)
    '("SetCustomAlgoRuledWidth" 1)
    '("SetAlgoInsideSkip" 1)
    '("SetAlgoSkip" 1)
    '("relsize" 1)
    '("SetAlgoHangIndent" 1)
    '("RestyleAlgo" 1)
    '("SetAlgoFuncName" 2)
    '("SetAlgoProcName" 2)
    "renewcommand"
    "algocf"
    "listalgorithmcfname"
    "algorithmcfname"
    "algorithmautorefname"
    "algorithmcflinename"
    "procedureautorefname"
    "functionautorefname"
    "defaultsmacros"
    "setLeftLinesNumbers"
    "setRightLinesNumbers"
    "skiptotal"
    "skiplinenumber"
    "skiprule"
    "skiphlne"
    "skiptext"
    "skiplength"
    "algomargin"
    "skipalgocfslide"
    "algowidth"
    "inoutsize"
    "inoutindent"
    "interspacetitleruled"
    "interspacealgoruled"
    "interspacetitleboxruled"
    "arg"
    "BlankLine"
    "vespace"
    "AlCapSkip"
    "AlCapHSkip"
    "algoskipindent"
    "Indp"
    "Indpp"
    "Indm"
    "Indmm"
    "nl"
    "enl"
    "DontPrintSemicolon"
    "PrintSemicolon"
    "LinesNumbered"
    "LinesNotNumbered"
    "LinesNumberedHidden"
    "ShowLn"
    "AlFnt"
    "AlTitleFnt"
    "AlCapFnt"
    "AlCapNameFnt"
    "ProcFnt"
    "ProcNameFnt"
    "ProcArgFnt"
    "AlgoDisplayBlockMarkers"
    "AlgoDontDisplayBlockMarkers"
    "AlgoDisplayGroupMarkers"
    "AlgoDontDisplayGroupMarkers"
    "Hlne"
    "SetAlgoLongEnd"
    "SetAlgoShortEnd"
    "SetAlgoNoEnd"
    "SetAlgoNoLine"
    "SetAlgoVlined"
    "SetAlgoLined"
    "SetNothing"
    "InOutSizeDefined"
    "SetSideCommentLeft"
    "SetSideCommentRight"
    "SetNoFillComment"
    "SetFillComment"
    "NoCaptionOfAlgo"
    "RestoreCaptionOfAlgo"
    "fnum"
    "listofalgocfs"
    "l"
    "noalgocaption"
    "algoplace"
    "algoendfloat"
    "SetNoLine"
    "SetNoline"
    "SetVline"
    "SetLine"
    "dontprintsemicolon"
    "printsemicolon"
    "linesnumbered"
    "linesnotnumbered"
    "linesnumberedhidden"
    "showln"
    "nocaptionofalgo"
    "restorecaptionofalgo"
    "theHalgocf"
    "theHAlgoLine"
    "theHalgocfproc"
    "theHalgocffunc"
    "AlgoLineautorefname"
    "algocfautorefname"
    "algocfprocautorefname"
    "algocffuncautorefname"
    "thealgocf"
    "everypar"
    "test")
   (LaTeX-add-labels
    "#1")
   (LaTeX-add-environments
    '("function" LaTeX-env-args ["argument"] 0)
    '("procedure" LaTeX-env-args ["argument"] 0)
    "algocf"
    "algomathdisplay"
    "procedure"
    "function")
   (LaTeX-add-counters
    "AlgoLine"
    "postalgo"
    "algocfline"
    "algocfproc"
    "algocf")
   (LaTeX-add-lengths
    "algocf"
    "algoheightruledefault"
    "algoheightrule"
    "algotitleheightruledefault"
    "algotitleheightrule")
   (LaTeX-add-saveboxes
    "algocf"))
 :latex)

