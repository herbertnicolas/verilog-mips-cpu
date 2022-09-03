set filter [list CPUTestBench.CPU_.clock CPUTestBench.CPU_.reset CPUTestBench.CPU_.CtrlUnit_.state\[6:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.CtrlUnit_.state\[6:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
set filter [list CPUTestBench.CPU_.PC_.data\[31:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.PC_.data\[31:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/Alias_Highlighted_Trace pc\[31:0\]
set filter [ list CPUTestBench.CPU_.MDR_.data\[31:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.MDR_.data\[31:0\]"
gtkwave::/Edit/Data_Format/Hex
gtkwave::/Edit/Alias_Highlighted_Trace mdr\[31:0\]
set filter [ list CPUTestBench.CPU_.opcode\[5:0\] CPUTestBench.CPU_.rs\[4:0\] CPUTestBench.CPU_.rt\[4:0\] CPUTestBench.CPU_.rd\[4:0\] CPUTestBench.CPU_.funct\[5:0\] CPUTestBench.CPU_.shamt\[4:0\] CPUTestBench.CPU_.address_immediate\[15:0\] CPUTestBench.CPU_.offset\[25:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.opcode\[5:0\]"
gtkwave::/Edit/Data_Format/Hex
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.funct\[5:0\]"
gtkwave::/Edit/Data_Format/Hex
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.rs\[4:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.rt\[4:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.rd\[4:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.shamt\[4:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.address_immediate\[15:0\]"
gtkwave::/Edit/Data_Format/Signed_Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.offset\[25:0\]"
gtkwave::/Edit/Data_Format/Signed_Decimal
gtkwave::/Edit/UnHighlight_All
set filter [list CPUTestBench.CPU_.EPC_.data\[31:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.EPC_.data\[31:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/Alias_Highlighted_Trace epc\[31:0\]
set filter [list CPUTestBench.CPU_.Registers_.ra\[31:0\] CPUTestBench.CPU_.Registers_.sp\[31:0\]]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.Registers_.ra\[31:0\] CPUTestBench.CPU_.Registers_.sp\[31:0\]"
gtkwave::/Edit/Data_Format/Signed_Decimal
gtkwave::/Time/Zoom/Zoom_Best_Fit