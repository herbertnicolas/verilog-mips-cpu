set filter [list CPUTestBench.CPU_.clock CPUTestBench.CPU_.reset CPUTestBench.CPU_.CtrlUnit_.state\[6:0\] led.red msp430.port_out5\[7:0\] msp430.intr_num\[7:0\] msp430.intr_gie ]
gtkwave::addSignalsFromList $filter