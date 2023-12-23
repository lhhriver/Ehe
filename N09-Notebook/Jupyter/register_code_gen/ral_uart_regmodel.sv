class uart_reg_UARTDR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTDR)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OE;
    rand uvm_reg_field BE;
    rand uvm_reg_field PE;
    rand uvm_reg_field FE;
    rand uvm_reg_field DATA;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 4, 12, "RO", 0, 'h0, 1, 1, 1);

        OE = uvm_reg_field::type_id::create("OE");
        OE.configure(this, 1, 11, "RW", 0, 'h0, 1, 1, 1);

        BE = uvm_reg_field::type_id::create("BE");
        BE.configure(this, 1, 10, "RW", 0, 'h0, 1, 1, 1);

        PE = uvm_reg_field::type_id::create("PE");
        PE.configure(this, 1, 9, "RW", 0, 'h0, 1, 1, 1);

        FE = uvm_reg_field::type_id::create("FE");
        FE.configure(this, 1, 8, "RW", 0, 'h0, 1, 1, 1);

        DATA = uvm_reg_field::type_id::create("DATA");
        DATA.configure(this, 8, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTDR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTRSR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTRSR)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OE;
    rand uvm_reg_field BE;
    rand uvm_reg_field PE;
    rand uvm_reg_field FE;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 12, 4, "RO", 0, 'h0, 1, 1, 1);

        OE = uvm_reg_field::type_id::create("OE");
        OE.configure(this, 1, 3, "RW", 0, 'h0, 1, 1, 1);

        BE = uvm_reg_field::type_id::create("BE");
        BE.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

        PE = uvm_reg_field::type_id::create("PE");
        PE.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

        FE = uvm_reg_field::type_id::create("FE");
        FE.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTRSR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTFR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTFR)

    rand uvm_reg_field reserved;
    rand uvm_reg_field RI;
    rand uvm_reg_field TXFE;
    rand uvm_reg_field RXFE;
    rand uvm_reg_field TXFF;
    rand uvm_reg_field RXFF;
    rand uvm_reg_field BUSY;
    rand uvm_reg_field DCD;
    rand uvm_reg_field DSR;
    rand uvm_reg_field CTS;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 7, 9, "RO", 0, 'h0, 1, 1, 1);

        RI = uvm_reg_field::type_id::create("RI");
        RI.configure(this, 1, 8, "RO", 0, 'h1, 1, 1, 1);

        TXFE = uvm_reg_field::type_id::create("TXFE");
        TXFE.configure(this, 1, 7, "RO", 0, 'h1, 1, 1, 1);

        RXFE = uvm_reg_field::type_id::create("RXFE");
        RXFE.configure(this, 1, 6, "RO", 0, 'h0, 1, 1, 1);

        TXFF = uvm_reg_field::type_id::create("TXFF");
        TXFF.configure(this, 1, 5, "RO", 0, 'h0, 1, 1, 1);

        RXFF = uvm_reg_field::type_id::create("RXFF");
        RXFF.configure(this, 1, 4, "RO", 0, 'h1, 1, 1, 1);

        BUSY = uvm_reg_field::type_id::create("BUSY");
        BUSY.configure(this, 1, 3, "RO", 0, 'h0, 1, 1, 1);

        DCD = uvm_reg_field::type_id::create("DCD");
        DCD.configure(this, 1, 2, "RO", 0, 'h1, 1, 1, 1);

        DSR = uvm_reg_field::type_id::create("DSR");
        DSR.configure(this, 1, 1, "RO", 0, 'h1, 1, 1, 1);

        CTS = uvm_reg_field::type_id::create("CTS");
        CTS.configure(this, 1, 0, "RO", 0, 'h1, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTFR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTIBRD extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTIBRD)

    rand uvm_reg_field BAUD_DIVINT;

    virtual function void build();
        BAUD_DIVINT = uvm_reg_field::type_id::create("BAUD_DIVINT");
        BAUD_DIVINT.configure(this, 16, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTIBRD");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTFBRD extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTFBRD)

    rand uvm_reg_field BAUD_DIVERAC;

    virtual function void build();
        BAUD_DIVERAC = uvm_reg_field::type_id::create("BAUD_DIVERAC");
        BAUD_DIVERAC.configure(this, 16, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTFBRD");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTLLCR_H extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTLLCR_H)

    rand uvm_reg_field reserved;
    rand uvm_reg_field SPS;
    rand uvm_reg_field WLEN;
    rand uvm_reg_field FEN;
    rand uvm_reg_field STP2;
    rand uvm_reg_field EPS;
    rand uvm_reg_field PEN;
    rand uvm_reg_field BRK;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 8, 8, "RO", 0, 'h0, 1, 1, 1);

        SPS = uvm_reg_field::type_id::create("SPS");
        SPS.configure(this, 1, 7, "RW", 0, 'h0, 1, 1, 1);

        WLEN = uvm_reg_field::type_id::create("WLEN");
        WLEN.configure(this, 2, 5, "RW", 0, 'h0, 1, 1, 1);

        FEN = uvm_reg_field::type_id::create("FEN");
        FEN.configure(this, 1, 4, "RW", 0, 'h0, 1, 1, 1);

        STP2 = uvm_reg_field::type_id::create("STP2");
        STP2.configure(this, 1, 3, "RW", 0, 'h0, 1, 1, 1);

        EPS = uvm_reg_field::type_id::create("EPS");
        EPS.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

        PEN = uvm_reg_field::type_id::create("PEN");
        PEN.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

        BRK = uvm_reg_field::type_id::create("BRK");
        BRK.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTLLCR_H");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTCR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTCR)

    rand uvm_reg_field CTSEn;
    rand uvm_reg_field RTSEn;
    rand uvm_reg_field Out2;
    rand uvm_reg_field Out1;
    rand uvm_reg_field RTS;
    rand uvm_reg_field DTR;
    rand uvm_reg_field RXE;
    rand uvm_reg_field TXE;
    rand uvm_reg_field LBE;
    rand uvm_reg_field reserved;
    rand uvm_reg_field SIRLP;
    rand uvm_reg_field SIREN;
    rand uvm_reg_field UARTEN;

    virtual function void build();
        CTSEn = uvm_reg_field::type_id::create("CTSEn");
        CTSEn.configure(this, 1, 15, "RW", 0, 'h0, 1, 1, 1);

        RTSEn = uvm_reg_field::type_id::create("RTSEn");
        RTSEn.configure(this, 1, 14, "RW", 0, 'h0, 1, 1, 1);

        Out2 = uvm_reg_field::type_id::create("Out2");
        Out2.configure(this, 1, 13, "RW", 0, 'h0, 1, 1, 1);

        Out1 = uvm_reg_field::type_id::create("Out1");
        Out1.configure(this, 1, 12, "RW", 0, 'h0, 1, 1, 1);

        RTS = uvm_reg_field::type_id::create("RTS");
        RTS.configure(this, 1, 11, "RW", 0, 'h0, 1, 1, 1);

        DTR = uvm_reg_field::type_id::create("DTR");
        DTR.configure(this, 1, 10, "RW", 0, 'h0, 1, 1, 1);

        RXE = uvm_reg_field::type_id::create("RXE");
        RXE.configure(this, 1, 9, "RW", 0, 'h1, 1, 1, 1);

        TXE = uvm_reg_field::type_id::create("TXE");
        TXE.configure(this, 1, 8, "RW", 0, 'h1, 1, 1, 1);

        LBE = uvm_reg_field::type_id::create("LBE");
        LBE.configure(this, 1, 7, "RW", 0, 'h0, 1, 1, 1);

        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 4, 3, "RO", 0, 'h0, 1, 1, 1);

        SIRLP = uvm_reg_field::type_id::create("SIRLP");
        SIRLP.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

        SIREN = uvm_reg_field::type_id::create("SIREN");
        SIREN.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

        UARTEN = uvm_reg_field::type_id::create("UARTEN");
        UARTEN.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTCR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTIFLS extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTIFLS)

    rand uvm_reg_field reserved;
    rand uvm_reg_field RXIFLSEL;
    rand uvm_reg_field TXIFLSEL;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 10, 6, "RO", 0, 'h0, 1, 1, 1);

        RXIFLSEL = uvm_reg_field::type_id::create("RXIFLSEL");
        RXIFLSEL.configure(this, 3, 3, "RW", 0, 'h2, 1, 1, 1);

        TXIFLSEL = uvm_reg_field::type_id::create("TXIFLSEL");
        TXIFLSEL.configure(this, 3, 0, "RW", 0, 'h2, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTIFLS");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTIMSC extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTIMSC)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OEIM;
    rand uvm_reg_field BEIM;
    rand uvm_reg_field PEIM;
    rand uvm_reg_field FEIM;
    rand uvm_reg_field RTIM;
    rand uvm_reg_field TXIM;
    rand uvm_reg_field RXIM;
    rand uvm_reg_field DSRMIM;
    rand uvm_reg_field DCDMIM;
    rand uvm_reg_field CTSRMIM;
    rand uvm_reg_field RIRMIM;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 5, 11, "RO", 0, 'h0, 1, 1, 1);

        OEIM = uvm_reg_field::type_id::create("OEIM");
        OEIM.configure(this, 1, 10, "RW", 0, 'h0, 1, 1, 1);

        BEIM = uvm_reg_field::type_id::create("BEIM");
        BEIM.configure(this, 1, 9, "RW", 0, 'h0, 1, 1, 1);

        PEIM = uvm_reg_field::type_id::create("PEIM");
        PEIM.configure(this, 1, 8, "RW", 0, 'h0, 1, 1, 1);

        FEIM = uvm_reg_field::type_id::create("FEIM");
        FEIM.configure(this, 1, 7, "RW", 0, 'h0, 1, 1, 1);

        RTIM = uvm_reg_field::type_id::create("RTIM");
        RTIM.configure(this, 1, 6, "RW", 0, 'h0, 1, 1, 1);

        TXIM = uvm_reg_field::type_id::create("TXIM");
        TXIM.configure(this, 1, 5, "RW", 0, 'h0, 1, 1, 1);

        RXIM = uvm_reg_field::type_id::create("RXIM");
        RXIM.configure(this, 1, 4, "RW", 0, 'h0, 1, 1, 1);

        DSRMIM = uvm_reg_field::type_id::create("DSRMIM");
        DSRMIM.configure(this, 1, 3, "RW", 0, 'h0, 1, 1, 1);

        DCDMIM = uvm_reg_field::type_id::create("DCDMIM");
        DCDMIM.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

        CTSRMIM = uvm_reg_field::type_id::create("CTSRMIM");
        CTSRMIM.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

        RIRMIM = uvm_reg_field::type_id::create("RIRMIM");
        RIRMIM.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTIMSC");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTRIS extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTRIS)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OERIS;
    rand uvm_reg_field BERIS;
    rand uvm_reg_field PERIS;
    rand uvm_reg_field FERIS;
    rand uvm_reg_field RTRIS;
    rand uvm_reg_field TXRIS;
    rand uvm_reg_field RXRIS;
    rand uvm_reg_field DSRRMIS;
    rand uvm_reg_field DCDRMIS;
    rand uvm_reg_field CTSRMIS;
    rand uvm_reg_field RIRMIS;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 5, 11, "RO", 0, 'h0, 1, 1, 1);

        OERIS = uvm_reg_field::type_id::create("OERIS");
        OERIS.configure(this, 1, 10, "RO", 0, 'h0, 1, 1, 1);

        BERIS = uvm_reg_field::type_id::create("BERIS");
        BERIS.configure(this, 1, 9, "RO", 0, 'h0, 1, 1, 1);

        PERIS = uvm_reg_field::type_id::create("PERIS");
        PERIS.configure(this, 1, 8, "RO", 0, 'h0, 1, 1, 1);

        FERIS = uvm_reg_field::type_id::create("FERIS");
        FERIS.configure(this, 1, 7, "RO", 0, 'h0, 1, 1, 1);

        RTRIS = uvm_reg_field::type_id::create("RTRIS");
        RTRIS.configure(this, 1, 6, "RO", 0, 'h0, 1, 1, 1);

        TXRIS = uvm_reg_field::type_id::create("TXRIS");
        TXRIS.configure(this, 1, 5, "RO", 0, 'h0, 1, 1, 1);

        RXRIS = uvm_reg_field::type_id::create("RXRIS");
        RXRIS.configure(this, 1, 4, "RO", 0, 'h0, 1, 1, 1);

        DSRRMIS = uvm_reg_field::type_id::create("DSRRMIS");
        DSRRMIS.configure(this, 1, 3, "RO", 0, 'h0, 1, 1, 1);

        DCDRMIS = uvm_reg_field::type_id::create("DCDRMIS");
        DCDRMIS.configure(this, 1, 2, "RO", 0, 'h0, 1, 1, 1);

        CTSRMIS = uvm_reg_field::type_id::create("CTSRMIS");
        CTSRMIS.configure(this, 1, 1, "RO", 0, 'h0, 1, 1, 1);

        RIRMIS = uvm_reg_field::type_id::create("RIRMIS");
        RIRMIS.configure(this, 1, 0, "RO", 0, 'h1, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTRIS");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTMIS extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTMIS)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OEMIS;
    rand uvm_reg_field BEMIS;
    rand uvm_reg_field PEMIS;
    rand uvm_reg_field FEMIS;
    rand uvm_reg_field RTMIS;
    rand uvm_reg_field TXMIS;
    rand uvm_reg_field RXMIS;
    rand uvm_reg_field DSRMMIS;
    rand uvm_reg_field DCDMMIS;
    rand uvm_reg_field CTSMMIS;
    rand uvm_reg_field RIMMIS;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 5, 11, "RO", 0, 'h0, 1, 1, 1);

        OEMIS = uvm_reg_field::type_id::create("OEMIS");
        OEMIS.configure(this, 1, 10, "RO", 0, 'h0, 1, 1, 1);

        BEMIS = uvm_reg_field::type_id::create("BEMIS");
        BEMIS.configure(this, 1, 9, "RO", 0, 'h0, 1, 1, 1);

        PEMIS = uvm_reg_field::type_id::create("PEMIS");
        PEMIS.configure(this, 1, 8, "RO", 0, 'h0, 1, 1, 1);

        FEMIS = uvm_reg_field::type_id::create("FEMIS");
        FEMIS.configure(this, 1, 7, "RO", 0, 'h0, 1, 1, 1);

        RTMIS = uvm_reg_field::type_id::create("RTMIS");
        RTMIS.configure(this, 1, 6, "RO", 0, 'h0, 1, 1, 1);

        TXMIS = uvm_reg_field::type_id::create("TXMIS");
        TXMIS.configure(this, 1, 5, "RO", 0, 'h0, 1, 1, 1);

        RXMIS = uvm_reg_field::type_id::create("RXMIS");
        RXMIS.configure(this, 1, 4, "RO", 0, 'h0, 1, 1, 1);

        DSRMMIS = uvm_reg_field::type_id::create("DSRMMIS");
        DSRMMIS.configure(this, 1, 3, "RO", 0, 'h0, 1, 1, 1);

        DCDMMIS = uvm_reg_field::type_id::create("DCDMMIS");
        DCDMMIS.configure(this, 1, 2, "RO", 0, 'h0, 1, 1, 1);

        CTSMMIS = uvm_reg_field::type_id::create("CTSMMIS");
        CTSMMIS.configure(this, 1, 1, "RO", 0, 'h0, 1, 1, 1);

        RIMMIS = uvm_reg_field::type_id::create("RIMMIS");
        RIMMIS.configure(this, 1, 0, "RO", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTMIS");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTICR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTICR)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OEIC;
    rand uvm_reg_field BEIC;
    rand uvm_reg_field PEIC;
    rand uvm_reg_field FEIC;
    rand uvm_reg_field RTIC;
    rand uvm_reg_field TXIC;
    rand uvm_reg_field RXIC;
    rand uvm_reg_field DSRMIC;
    rand uvm_reg_field DCDMIC;
    rand uvm_reg_field CTSMIC;
    rand uvm_reg_field RIMIC;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 5, 11, "RO", 0, 'h0, 1, 1, 1);

        OEIC = uvm_reg_field::type_id::create("OEIC");
        OEIC.configure(this, 1, 10, "WO", 0, 'h0, 1, 1, 1);

        BEIC = uvm_reg_field::type_id::create("BEIC");
        BEIC.configure(this, 1, 9, "WO", 0, 'h0, 1, 1, 1);

        PEIC = uvm_reg_field::type_id::create("PEIC");
        PEIC.configure(this, 1, 8, "WO", 0, 'h0, 1, 1, 1);

        FEIC = uvm_reg_field::type_id::create("FEIC");
        FEIC.configure(this, 1, 7, "WO", 0, 'h0, 1, 1, 1);

        RTIC = uvm_reg_field::type_id::create("RTIC");
        RTIC.configure(this, 1, 6, "WO", 0, 'h0, 1, 1, 1);

        TXIC = uvm_reg_field::type_id::create("TXIC");
        TXIC.configure(this, 1, 5, "WO", 0, 'h0, 1, 1, 1);

        RXIC = uvm_reg_field::type_id::create("RXIC");
        RXIC.configure(this, 1, 4, "WO", 0, 'h0, 1, 1, 1);

        DSRMIC = uvm_reg_field::type_id::create("DSRMIC");
        DSRMIC.configure(this, 1, 3, "WO", 0, 'h0, 1, 1, 1);

        DCDMIC = uvm_reg_field::type_id::create("DCDMIC");
        DCDMIC.configure(this, 1, 2, "WO", 0, 'h0, 1, 1, 1);

        CTSMIC = uvm_reg_field::type_id::create("CTSMIC");
        CTSMIC.configure(this, 1, 1, "WO", 0, 'h1, 1, 1, 1);

        RIMIC = uvm_reg_field::type_id::create("RIMIC");
        RIMIC.configure(this, 1, 0, "WO", 0, 'h1, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTICR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class ral_uart_reg extends uvm_reg_block;

    rand uart_reg_UARTDR UARTDR;
    rand uart_reg_UARTRSR UARTRSR;
    rand uart_reg_UARTFR UARTFR;
    rand uart_reg_UARTIBRD UARTIBRD;
    rand uart_reg_UARTFBRD UARTFBRD;
    rand uart_reg_UARTLLCR_H UARTLLCR_H;
    rand uart_reg_UARTCR UARTCR;
    rand uart_reg_UARTIFLS UARTIFLS;
    rand uart_reg_UARTIMSC UARTIMSC;
    rand uart_reg_UARTRIS UARTRIS;
    rand uart_reg_UARTMIS UARTMIS;
    rand uart_reg_UARTICR UARTICR;

    `uvm_object_utils(ral_uart_reg)

    function new(string name = "ral_uart_reg");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        default_map = create_map("default_map", 0, 4, UVM_BIG_ENDIAN, 1);

        UARTDR = uart_reg_UARTDR::type_id::create("UARTDR", null, get_full_name());
        UARTDR.configure(this, null, "");
        UARTDR.build();
        default_map.add_reg(UARTDR, 'h00, "RW");

        UARTRSR = uart_reg_UARTRSR::type_id::create("UARTRSR", null, get_full_name());
        UARTRSR.configure(this, null, "");
        UARTRSR.build();
        default_map.add_reg(UARTRSR, 'h04, "RW");

        UARTFR = uart_reg_UARTFR::type_id::create("UARTFR", null, get_full_name());
        UARTFR.configure(this, null, "");
        UARTFR.build();
        default_map.add_reg(UARTFR, 'h018, "RW");

        UARTIBRD = uart_reg_UARTIBRD::type_id::create("UARTIBRD", null, get_full_name());
        UARTIBRD.configure(this, null, "");
        UARTIBRD.build();
        default_map.add_reg(UARTIBRD, 'h024, "RW");

        UARTFBRD = uart_reg_UARTFBRD::type_id::create("UARTFBRD", null, get_full_name());
        UARTFBRD.configure(this, null, "");
        UARTFBRD.build();
        default_map.add_reg(UARTFBRD, 'h028, "RW");

        UARTLLCR_H = uart_reg_UARTLLCR_H::type_id::create("UARTLLCR_H", null, get_full_name());
        UARTLLCR_H.configure(this, null, "");
        UARTLLCR_H.build();
        default_map.add_reg(UARTLLCR_H, 'h02C, "RW");

        UARTCR = uart_reg_UARTCR::type_id::create("UARTCR", null, get_full_name());
        UARTCR.configure(this, null, "");
        UARTCR.build();
        default_map.add_reg(UARTCR, 'h030, "RW");

        UARTIFLS = uart_reg_UARTIFLS::type_id::create("UARTIFLS", null, get_full_name());
        UARTIFLS.configure(this, null, "");
        UARTIFLS.build();
        default_map.add_reg(UARTIFLS, 'h034, "RW");

        UARTIMSC = uart_reg_UARTIMSC::type_id::create("UARTIMSC", null, get_full_name());
        UARTIMSC.configure(this, null, "");
        UARTIMSC.build();
        default_map.add_reg(UARTIMSC, 'h038, "RW");

        UARTRIS = uart_reg_UARTRIS::type_id::create("UARTRIS", null, get_full_name());
        UARTRIS.configure(this, null, "");
        UARTRIS.build();
        default_map.add_reg(UARTRIS, 'h03C, "RW");

        UARTMIS = uart_reg_UARTMIS::type_id::create("UARTMIS", null, get_full_name());
        UARTMIS.configure(this, null, "");
        UARTMIS.build();
        default_map.add_reg(UARTMIS, 'h040, "RW");

        UARTICR = uart_reg_UARTICR::type_id::create("UARTICR", null, get_full_name());
        UARTICR.configure(this, null, "");
        UARTICR.build();
        default_map.add_reg(UARTICR, 'h044, "RW");

    endfunction
endclass
class uart_reg_UARTDR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTDR)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OE;
    rand uvm_reg_field BE;
    rand uvm_reg_field PE;
    rand uvm_reg_field FE;
    rand uvm_reg_field DATA;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 4, 12, "RO", 0, 'h0, 1, 1, 1);

        OE = uvm_reg_field::type_id::create("OE");
        OE.configure(this, 1, 11, "RW", 0, 'h0, 1, 1, 1);

        BE = uvm_reg_field::type_id::create("BE");
        BE.configure(this, 1, 10, "RW", 0, 'h0, 1, 1, 1);

        PE = uvm_reg_field::type_id::create("PE");
        PE.configure(this, 1, 9, "RW", 0, 'h0, 1, 1, 1);

        FE = uvm_reg_field::type_id::create("FE");
        FE.configure(this, 1, 8, "RW", 0, 'h0, 1, 1, 1);

        DATA = uvm_reg_field::type_id::create("DATA");
        DATA.configure(this, 8, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTDR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTRSR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTRSR)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OE;
    rand uvm_reg_field BE;
    rand uvm_reg_field PE;
    rand uvm_reg_field FE;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 12, 4, "RO", 0, 'h0, 1, 1, 1);

        OE = uvm_reg_field::type_id::create("OE");
        OE.configure(this, 1, 3, "RW", 0, 'h0, 1, 1, 1);

        BE = uvm_reg_field::type_id::create("BE");
        BE.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

        PE = uvm_reg_field::type_id::create("PE");
        PE.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

        FE = uvm_reg_field::type_id::create("FE");
        FE.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTRSR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTFR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTFR)

    rand uvm_reg_field reserved;
    rand uvm_reg_field RI;
    rand uvm_reg_field TXFE;
    rand uvm_reg_field RXFE;
    rand uvm_reg_field TXFF;
    rand uvm_reg_field RXFF;
    rand uvm_reg_field BUSY;
    rand uvm_reg_field DCD;
    rand uvm_reg_field DSR;
    rand uvm_reg_field CTS;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 7, 9, "RO", 0, 'h0, 1, 1, 1);

        RI = uvm_reg_field::type_id::create("RI");
        RI.configure(this, 1, 8, "RO", 0, 'h1, 1, 1, 1);

        TXFE = uvm_reg_field::type_id::create("TXFE");
        TXFE.configure(this, 1, 7, "RO", 0, 'h1, 1, 1, 1);

        RXFE = uvm_reg_field::type_id::create("RXFE");
        RXFE.configure(this, 1, 6, "RO", 0, 'h0, 1, 1, 1);

        TXFF = uvm_reg_field::type_id::create("TXFF");
        TXFF.configure(this, 1, 5, "RO", 0, 'h0, 1, 1, 1);

        RXFF = uvm_reg_field::type_id::create("RXFF");
        RXFF.configure(this, 1, 4, "RO", 0, 'h1, 1, 1, 1);

        BUSY = uvm_reg_field::type_id::create("BUSY");
        BUSY.configure(this, 1, 3, "RO", 0, 'h0, 1, 1, 1);

        DCD = uvm_reg_field::type_id::create("DCD");
        DCD.configure(this, 1, 2, "RO", 0, 'h1, 1, 1, 1);

        DSR = uvm_reg_field::type_id::create("DSR");
        DSR.configure(this, 1, 1, "RO", 0, 'h1, 1, 1, 1);

        CTS = uvm_reg_field::type_id::create("CTS");
        CTS.configure(this, 1, 0, "RO", 0, 'h1, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTFR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTIBRD extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTIBRD)

    rand uvm_reg_field BAUD_DIVINT;

    virtual function void build();
        BAUD_DIVINT = uvm_reg_field::type_id::create("BAUD_DIVINT");
        BAUD_DIVINT.configure(this, 16, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTIBRD");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTFBRD extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTFBRD)

    rand uvm_reg_field BAUD_DIVERAC;

    virtual function void build();
        BAUD_DIVERAC = uvm_reg_field::type_id::create("BAUD_DIVERAC");
        BAUD_DIVERAC.configure(this, 16, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTFBRD");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTLLCR_H extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTLLCR_H)

    rand uvm_reg_field reserved;
    rand uvm_reg_field SPS;
    rand uvm_reg_field WLEN;
    rand uvm_reg_field FEN;
    rand uvm_reg_field STP2;
    rand uvm_reg_field EPS;
    rand uvm_reg_field PEN;
    rand uvm_reg_field BRK;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 8, 8, "RO", 0, 'h0, 1, 1, 1);

        SPS = uvm_reg_field::type_id::create("SPS");
        SPS.configure(this, 1, 7, "RW", 0, 'h0, 1, 1, 1);

        WLEN = uvm_reg_field::type_id::create("WLEN");
        WLEN.configure(this, 2, 5, "RW", 0, 'h0, 1, 1, 1);

        FEN = uvm_reg_field::type_id::create("FEN");
        FEN.configure(this, 1, 4, "RW", 0, 'h0, 1, 1, 1);

        STP2 = uvm_reg_field::type_id::create("STP2");
        STP2.configure(this, 1, 3, "RW", 0, 'h0, 1, 1, 1);

        EPS = uvm_reg_field::type_id::create("EPS");
        EPS.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

        PEN = uvm_reg_field::type_id::create("PEN");
        PEN.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

        BRK = uvm_reg_field::type_id::create("BRK");
        BRK.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTLLCR_H");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTCR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTCR)

    rand uvm_reg_field CTSEn;
    rand uvm_reg_field RTSEn;
    rand uvm_reg_field Out2;
    rand uvm_reg_field Out1;
    rand uvm_reg_field RTS;
    rand uvm_reg_field DTR;
    rand uvm_reg_field RXE;
    rand uvm_reg_field TXE;
    rand uvm_reg_field LBE;
    rand uvm_reg_field reserved;
    rand uvm_reg_field SIRLP;
    rand uvm_reg_field SIREN;
    rand uvm_reg_field UARTEN;

    virtual function void build();
        CTSEn = uvm_reg_field::type_id::create("CTSEn");
        CTSEn.configure(this, 1, 15, "RW", 0, 'h0, 1, 1, 1);

        RTSEn = uvm_reg_field::type_id::create("RTSEn");
        RTSEn.configure(this, 1, 14, "RW", 0, 'h0, 1, 1, 1);

        Out2 = uvm_reg_field::type_id::create("Out2");
        Out2.configure(this, 1, 13, "RW", 0, 'h0, 1, 1, 1);

        Out1 = uvm_reg_field::type_id::create("Out1");
        Out1.configure(this, 1, 12, "RW", 0, 'h0, 1, 1, 1);

        RTS = uvm_reg_field::type_id::create("RTS");
        RTS.configure(this, 1, 11, "RW", 0, 'h0, 1, 1, 1);

        DTR = uvm_reg_field::type_id::create("DTR");
        DTR.configure(this, 1, 10, "RW", 0, 'h0, 1, 1, 1);

        RXE = uvm_reg_field::type_id::create("RXE");
        RXE.configure(this, 1, 9, "RW", 0, 'h1, 1, 1, 1);

        TXE = uvm_reg_field::type_id::create("TXE");
        TXE.configure(this, 1, 8, "RW", 0, 'h1, 1, 1, 1);

        LBE = uvm_reg_field::type_id::create("LBE");
        LBE.configure(this, 1, 7, "RW", 0, 'h0, 1, 1, 1);

        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 4, 3, "RO", 0, 'h0, 1, 1, 1);

        SIRLP = uvm_reg_field::type_id::create("SIRLP");
        SIRLP.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

        SIREN = uvm_reg_field::type_id::create("SIREN");
        SIREN.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

        UARTEN = uvm_reg_field::type_id::create("UARTEN");
        UARTEN.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTCR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTIFLS extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTIFLS)

    rand uvm_reg_field reserved;
    rand uvm_reg_field RXIFLSEL;
    rand uvm_reg_field TXIFLSEL;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 10, 6, "RO", 0, 'h0, 1, 1, 1);

        RXIFLSEL = uvm_reg_field::type_id::create("RXIFLSEL");
        RXIFLSEL.configure(this, 3, 3, "RW", 0, 'h2, 1, 1, 1);

        TXIFLSEL = uvm_reg_field::type_id::create("TXIFLSEL");
        TXIFLSEL.configure(this, 3, 0, "RW", 0, 'h2, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTIFLS");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTIMSC extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTIMSC)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OEIM;
    rand uvm_reg_field BEIM;
    rand uvm_reg_field PEIM;
    rand uvm_reg_field FEIM;
    rand uvm_reg_field RTIM;
    rand uvm_reg_field TXIM;
    rand uvm_reg_field RXIM;
    rand uvm_reg_field DSRMIM;
    rand uvm_reg_field DCDMIM;
    rand uvm_reg_field CTSRMIM;
    rand uvm_reg_field RIRMIM;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 5, 11, "RO", 0, 'h0, 1, 1, 1);

        OEIM = uvm_reg_field::type_id::create("OEIM");
        OEIM.configure(this, 1, 10, "RW", 0, 'h0, 1, 1, 1);

        BEIM = uvm_reg_field::type_id::create("BEIM");
        BEIM.configure(this, 1, 9, "RW", 0, 'h0, 1, 1, 1);

        PEIM = uvm_reg_field::type_id::create("PEIM");
        PEIM.configure(this, 1, 8, "RW", 0, 'h0, 1, 1, 1);

        FEIM = uvm_reg_field::type_id::create("FEIM");
        FEIM.configure(this, 1, 7, "RW", 0, 'h0, 1, 1, 1);

        RTIM = uvm_reg_field::type_id::create("RTIM");
        RTIM.configure(this, 1, 6, "RW", 0, 'h0, 1, 1, 1);

        TXIM = uvm_reg_field::type_id::create("TXIM");
        TXIM.configure(this, 1, 5, "RW", 0, 'h0, 1, 1, 1);

        RXIM = uvm_reg_field::type_id::create("RXIM");
        RXIM.configure(this, 1, 4, "RW", 0, 'h0, 1, 1, 1);

        DSRMIM = uvm_reg_field::type_id::create("DSRMIM");
        DSRMIM.configure(this, 1, 3, "RW", 0, 'h0, 1, 1, 1);

        DCDMIM = uvm_reg_field::type_id::create("DCDMIM");
        DCDMIM.configure(this, 1, 2, "RW", 0, 'h0, 1, 1, 1);

        CTSRMIM = uvm_reg_field::type_id::create("CTSRMIM");
        CTSRMIM.configure(this, 1, 1, "RW", 0, 'h0, 1, 1, 1);

        RIRMIM = uvm_reg_field::type_id::create("RIRMIM");
        RIRMIM.configure(this, 1, 0, "RW", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTIMSC");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTRIS extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTRIS)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OERIS;
    rand uvm_reg_field BERIS;
    rand uvm_reg_field PERIS;
    rand uvm_reg_field FERIS;
    rand uvm_reg_field RTRIS;
    rand uvm_reg_field TXRIS;
    rand uvm_reg_field RXRIS;
    rand uvm_reg_field DSRRMIS;
    rand uvm_reg_field DCDRMIS;
    rand uvm_reg_field CTSRMIS;
    rand uvm_reg_field RIRMIS;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 5, 11, "RO", 0, 'h0, 1, 1, 1);

        OERIS = uvm_reg_field::type_id::create("OERIS");
        OERIS.configure(this, 1, 10, "RO", 0, 'h0, 1, 1, 1);

        BERIS = uvm_reg_field::type_id::create("BERIS");
        BERIS.configure(this, 1, 9, "RO", 0, 'h0, 1, 1, 1);

        PERIS = uvm_reg_field::type_id::create("PERIS");
        PERIS.configure(this, 1, 8, "RO", 0, 'h0, 1, 1, 1);

        FERIS = uvm_reg_field::type_id::create("FERIS");
        FERIS.configure(this, 1, 7, "RO", 0, 'h0, 1, 1, 1);

        RTRIS = uvm_reg_field::type_id::create("RTRIS");
        RTRIS.configure(this, 1, 6, "RO", 0, 'h0, 1, 1, 1);

        TXRIS = uvm_reg_field::type_id::create("TXRIS");
        TXRIS.configure(this, 1, 5, "RO", 0, 'h0, 1, 1, 1);

        RXRIS = uvm_reg_field::type_id::create("RXRIS");
        RXRIS.configure(this, 1, 4, "RO", 0, 'h0, 1, 1, 1);

        DSRRMIS = uvm_reg_field::type_id::create("DSRRMIS");
        DSRRMIS.configure(this, 1, 3, "RO", 0, 'h0, 1, 1, 1);

        DCDRMIS = uvm_reg_field::type_id::create("DCDRMIS");
        DCDRMIS.configure(this, 1, 2, "RO", 0, 'h0, 1, 1, 1);

        CTSRMIS = uvm_reg_field::type_id::create("CTSRMIS");
        CTSRMIS.configure(this, 1, 1, "RO", 0, 'h0, 1, 1, 1);

        RIRMIS = uvm_reg_field::type_id::create("RIRMIS");
        RIRMIS.configure(this, 1, 0, "RO", 0, 'h1, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTRIS");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTMIS extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTMIS)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OEMIS;
    rand uvm_reg_field BEMIS;
    rand uvm_reg_field PEMIS;
    rand uvm_reg_field FEMIS;
    rand uvm_reg_field RTMIS;
    rand uvm_reg_field TXMIS;
    rand uvm_reg_field RXMIS;
    rand uvm_reg_field DSRMMIS;
    rand uvm_reg_field DCDMMIS;
    rand uvm_reg_field CTSMMIS;
    rand uvm_reg_field RIMMIS;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 5, 11, "RO", 0, 'h0, 1, 1, 1);

        OEMIS = uvm_reg_field::type_id::create("OEMIS");
        OEMIS.configure(this, 1, 10, "RO", 0, 'h0, 1, 1, 1);

        BEMIS = uvm_reg_field::type_id::create("BEMIS");
        BEMIS.configure(this, 1, 9, "RO", 0, 'h0, 1, 1, 1);

        PEMIS = uvm_reg_field::type_id::create("PEMIS");
        PEMIS.configure(this, 1, 8, "RO", 0, 'h0, 1, 1, 1);

        FEMIS = uvm_reg_field::type_id::create("FEMIS");
        FEMIS.configure(this, 1, 7, "RO", 0, 'h0, 1, 1, 1);

        RTMIS = uvm_reg_field::type_id::create("RTMIS");
        RTMIS.configure(this, 1, 6, "RO", 0, 'h0, 1, 1, 1);

        TXMIS = uvm_reg_field::type_id::create("TXMIS");
        TXMIS.configure(this, 1, 5, "RO", 0, 'h0, 1, 1, 1);

        RXMIS = uvm_reg_field::type_id::create("RXMIS");
        RXMIS.configure(this, 1, 4, "RO", 0, 'h0, 1, 1, 1);

        DSRMMIS = uvm_reg_field::type_id::create("DSRMMIS");
        DSRMMIS.configure(this, 1, 3, "RO", 0, 'h0, 1, 1, 1);

        DCDMMIS = uvm_reg_field::type_id::create("DCDMMIS");
        DCDMMIS.configure(this, 1, 2, "RO", 0, 'h0, 1, 1, 1);

        CTSMMIS = uvm_reg_field::type_id::create("CTSMMIS");
        CTSMMIS.configure(this, 1, 1, "RO", 0, 'h0, 1, 1, 1);

        RIMMIS = uvm_reg_field::type_id::create("RIMMIS");
        RIMMIS.configure(this, 1, 0, "RO", 0, 'h0, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTMIS");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class uart_reg_UARTICR extends uvm_reg;
    `uvm_object_utils(uart_reg_UARTICR)

    rand uvm_reg_field reserved;
    rand uvm_reg_field OEIC;
    rand uvm_reg_field BEIC;
    rand uvm_reg_field PEIC;
    rand uvm_reg_field FEIC;
    rand uvm_reg_field RTIC;
    rand uvm_reg_field TXIC;
    rand uvm_reg_field RXIC;
    rand uvm_reg_field DSRMIC;
    rand uvm_reg_field DCDMIC;
    rand uvm_reg_field CTSMIC;
    rand uvm_reg_field RIMIC;

    virtual function void build();
        reserved = uvm_reg_field::type_id::create("reserved");
        reserved.configure(this, 5, 11, "RO", 0, 'h0, 1, 1, 1);

        OEIC = uvm_reg_field::type_id::create("OEIC");
        OEIC.configure(this, 1, 10, "WO", 0, 'h0, 1, 1, 1);

        BEIC = uvm_reg_field::type_id::create("BEIC");
        BEIC.configure(this, 1, 9, "WO", 0, 'h0, 1, 1, 1);

        PEIC = uvm_reg_field::type_id::create("PEIC");
        PEIC.configure(this, 1, 8, "WO", 0, 'h0, 1, 1, 1);

        FEIC = uvm_reg_field::type_id::create("FEIC");
        FEIC.configure(this, 1, 7, "WO", 0, 'h0, 1, 1, 1);

        RTIC = uvm_reg_field::type_id::create("RTIC");
        RTIC.configure(this, 1, 6, "WO", 0, 'h0, 1, 1, 1);

        TXIC = uvm_reg_field::type_id::create("TXIC");
        TXIC.configure(this, 1, 5, "WO", 0, 'h0, 1, 1, 1);

        RXIC = uvm_reg_field::type_id::create("RXIC");
        RXIC.configure(this, 1, 4, "WO", 0, 'h0, 1, 1, 1);

        DSRMIC = uvm_reg_field::type_id::create("DSRMIC");
        DSRMIC.configure(this, 1, 3, "WO", 0, 'h0, 1, 1, 1);

        DCDMIC = uvm_reg_field::type_id::create("DCDMIC");
        DCDMIC.configure(this, 1, 2, "WO", 0, 'h0, 1, 1, 1);

        CTSMIC = uvm_reg_field::type_id::create("CTSMIC");
        CTSMIC.configure(this, 1, 1, "WO", 0, 'h1, 1, 1, 1);

        RIMIC = uvm_reg_field::type_id::create("RIMIC");
        RIMIC.configure(this, 1, 0, "WO", 0, 'h1, 1, 1, 1);

    endfunction

    function new(string name = "uart_reg_UARTICR");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction
endclass

class ral_uart_reg extends uvm_reg_block;

    rand uart_reg_UARTDR UARTDR;
    rand uart_reg_UARTRSR UARTRSR;
    rand uart_reg_UARTFR UARTFR;
    rand uart_reg_UARTIBRD UARTIBRD;
    rand uart_reg_UARTFBRD UARTFBRD;
    rand uart_reg_UARTLLCR_H UARTLLCR_H;
    rand uart_reg_UARTCR UARTCR;
    rand uart_reg_UARTIFLS UARTIFLS;
    rand uart_reg_UARTIMSC UARTIMSC;
    rand uart_reg_UARTRIS UARTRIS;
    rand uart_reg_UARTMIS UARTMIS;
    rand uart_reg_UARTICR UARTICR;

    `uvm_object_utils(ral_uart_reg)

    function new(string name = "ral_uart_reg");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        default_map = create_map("default_map", 0, 4, UVM_BIG_ENDIAN, 1);

        UARTDR = uart_reg_UARTDR::type_id::create("UARTDR", null, get_full_name());
        UARTDR.configure(this, null, "");
        UARTDR.build();
        default_map.add_reg(UARTDR, 'h00, "RW");

        UARTRSR = uart_reg_UARTRSR::type_id::create("UARTRSR", null, get_full_name());
        UARTRSR.configure(this, null, "");
        UARTRSR.build();
        default_map.add_reg(UARTRSR, 'h04, "RW");

        UARTFR = uart_reg_UARTFR::type_id::create("UARTFR", null, get_full_name());
        UARTFR.configure(this, null, "");
        UARTFR.build();
        default_map.add_reg(UARTFR, 'h018, "RW");

        UARTIBRD = uart_reg_UARTIBRD::type_id::create("UARTIBRD", null, get_full_name());
        UARTIBRD.configure(this, null, "");
        UARTIBRD.build();
        default_map.add_reg(UARTIBRD, 'h024, "RW");

        UARTFBRD = uart_reg_UARTFBRD::type_id::create("UARTFBRD", null, get_full_name());
        UARTFBRD.configure(this, null, "");
        UARTFBRD.build();
        default_map.add_reg(UARTFBRD, 'h028, "RW");

        UARTLLCR_H = uart_reg_UARTLLCR_H::type_id::create("UARTLLCR_H", null, get_full_name());
        UARTLLCR_H.configure(this, null, "");
        UARTLLCR_H.build();
        default_map.add_reg(UARTLLCR_H, 'h02C, "RW");

        UARTCR = uart_reg_UARTCR::type_id::create("UARTCR", null, get_full_name());
        UARTCR.configure(this, null, "");
        UARTCR.build();
        default_map.add_reg(UARTCR, 'h030, "RW");

        UARTIFLS = uart_reg_UARTIFLS::type_id::create("UARTIFLS", null, get_full_name());
        UARTIFLS.configure(this, null, "");
        UARTIFLS.build();
        default_map.add_reg(UARTIFLS, 'h034, "RW");

        UARTIMSC = uart_reg_UARTIMSC::type_id::create("UARTIMSC", null, get_full_name());
        UARTIMSC.configure(this, null, "");
        UARTIMSC.build();
        default_map.add_reg(UARTIMSC, 'h038, "RW");

        UARTRIS = uart_reg_UARTRIS::type_id::create("UARTRIS", null, get_full_name());
        UARTRIS.configure(this, null, "");
        UARTRIS.build();
        default_map.add_reg(UARTRIS, 'h03C, "RW");

        UARTMIS = uart_reg_UARTMIS::type_id::create("UARTMIS", null, get_full_name());
        UARTMIS.configure(this, null, "");
        UARTMIS.build();
        default_map.add_reg(UARTMIS, 'h040, "RW");

        UARTICR = uart_reg_UARTICR::type_id::create("UARTICR", null, get_full_name());
        UARTICR.configure(this, null, "");
        UARTICR.build();
        default_map.add_reg(UARTICR, 'h044, "RW");

    endfunction
endclass
