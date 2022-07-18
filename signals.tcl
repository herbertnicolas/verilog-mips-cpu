set filter [list CPUTestBench.CPU_.clock CPUTestBench.CPU_.reset CPUTestBench.CPU_.CtrlUnit_.state\[6:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.CtrlUnit_.state\[6:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::addCommentTracesFromList "PC"
set filter [list CPUTestBench.CPU_.PC_.data\[31:0\] CPUTestBench.CPU_.PC_.load ]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.PC_.data\[31:0\]"
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.PC_.data\[31:0\]"
gtkwave::/Edit/Alias_Highlighted_Trace pc
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.PC_.load"
gtkwave::/Edit/Alias_Highlighted_Trace pc_write
gtkwave::addCommentTracesFromList "Memory"
set filter [ list CPUTestBench.CPU_.Memory_.mem_read CPUTestBench.CPU_.Memory_.mem_write CPUTestBench.CPU_.Memory_.data_out\[31:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.Memory_.data_out\[31:0\]"
gtkwave::/Edit/Data_Format/Hex
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.Memory_.data_out\[31:0\]"
gtkwave::/Edit/Alias_Highlighted_Trace mem_data
gtkwave::addCommentTracesFromList "IR"
set filter [ list CPUTestBench.CPU_.IR_.ir_write CPUTestBench.CPU_.opcode\[5:0\] CPUTestBench.CPU_.rs\[4:0\] CPUTestBench.CPU_.rt\[4:0\] CPUTestBench.CPU_.rd\[4:0\] CPUTestBench.CPU_.funct\[5:0\] CPUTestBench.CPU_.shamt\[4:0\] CPUTestBench.CPU_.address_immediate\[15:0\] CPUTestBench.CPU_.offset\[25:0\] ]
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
gtkwave::addCommentTracesFromList "Registers"
set filter [ list CPUTestBench.CPU_.Registers_.reg_write CPUTestBench.CPU_.A_.load CPUTestBench.CPU_.A_.read_data\[31:0\] CPUTestBench.CPU_.B_.load CPUTestBench.CPU_.B_.read_data\[31:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.A_.read_data\[31:0\]"
gtkwave::/Edit/Data_Format/Signed_Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.B_.read_data\[31:0\]"
gtkwave::/Edit/Data_Format/Signed_Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.A_.load"
gtkwave::/Edit/Alias_Highlighted_Trace write_a
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.B_.load"
gtkwave::/Edit/Alias_Highlighted_Trace write_b
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.A_.read_data\[31:0\]"
gtkwave::/Edit/Alias_Highlighted_Trace a
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.B_.read_data\[31:0\]"
gtkwave::/Edit/Alias_Highlighted_Trace b
gtkwave::addCommentTracesFromList "ALU"
set filter [ list CPUTestBench.CPU_.ALU_.alu_ctrl\[2:0\] CPUTestBench.CPU_.ALU_.alu_out\[31:0\] CPUTestBench.CPU_.ALU_.overflow ]
gtkwave::addSignalsFromList $filter
gtkwave::/Edit/UnHighlight_All
gtkwave::highlightSignalsFromList "CPUTestBench.CPU_.ALU_.alu_out\[31:0\]"
gtkwave::/Edit/Data_Format/Signed_Decimal
gtkwave::/Edit/UnHighlight_All
gtkwave::addCommentTracesFromList "Else"
gtkwave::/Time/Zoom/Zoom_Best_Fit