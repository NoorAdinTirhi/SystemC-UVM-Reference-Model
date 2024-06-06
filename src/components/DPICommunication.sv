
//module used to communicate with the systemC reference model through the cpp warpper
module dpiConmunicator;
    typedef logic[79:0] logic_arr_t;

    // import DPI-C function to get reference model;
    import "DPI-C" function byte getReset();
    import "DPI-C" function byte getCommand();
    import "DPI-C" function int getWordData_in(int wi);
    import "DPI-C" function byte getCompressed_in();
    import "DPI-C" function byte getCompressed_out();
    import "DPI-C" function int getWordDecompressed_out(int wi);
    import "DPI-C" function byte getResponse();

    function logic_arr_t getData_in();
        logic_arr_t data;
        for (int i = 0; i < 80; i++) begin
            data[i] = getWordData_in(i/32)[i%32];
        end
        return data;
    endfunction

    function logic_arr_t getDecompressed_out();
        logic_arr_t data;
        for (int i = 0; i < 80; i++) begin
            data[i] = getWordDecompressed_out(i/32)[i%32];
        end
        return data;
    endfunction
endmodule