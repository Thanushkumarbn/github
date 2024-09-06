class write_xtn extends uvm_sequence_item;

	`uvm_object_utils(write_xtn)

	rand bit[7:0] header;
	rand bit[7:0] payload_data[];

	bit[7:0]parity;
	bit err;

	constraint c1{header[1:0]!=3;}
	constraint c2{payload_data.size == header[7:2];}
	constraint c3{payload_data.size!=0;}

	extern function new(string name = "write_xtn");
	extern function void post_randomize();
	extern function void do_print(uvm_printer printer);

endclass

function write_xtn::new(string name = "write_xtn");
	super.new(name);
endfunction : new

function void write_xtn::post_randomize();//after randomization, to calculate the parity
	parity = 0 ^ header;
	foreach(payload_data[i])
		parity = parity ^ payload_data[i];
endfunction

function void  write_xtn::do_print (uvm_printer printer);
	super.do_print(printer);

	printer.print_field( "header",this.header,8,UVM_HEX);
	foreach(payload_data[i])
		printer.print_field($sformatf("payload_data[%0d]",i),this.payload_data[i],8,UVM_HEX);
    
	printer.print_field( "parity",this.parity,8,UVM_HEX);
endfunction


