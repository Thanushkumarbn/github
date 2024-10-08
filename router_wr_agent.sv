class router_wr_agent extends uvm_agent;

   	`uvm_component_utils(router_wr_agent)

   	router_wr_agt_config m_cfg;

   	router_wr_monitor monh;
    router_wr_sequencer seqrh;
    router_wr_driver drvh;

	extern function new(string name = "router_wr_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
endclass 

function router_wr_agent::new(string name = "router_wr_agent",uvm_component parent = null);
	super.new(name,parent);
endfunction

function void router_wr_agent::build_phase(uvm_phase phase);
	
	super.build_phase(phase);
    if(!uvm_config_db #(router_wr_agt_config)::get(this,"","router_wr_agt_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    monh=router_wr_monitor::type_id::create("monh",this);
    if(m_cfg.is_active==UVM_ACTIVE)
	begin
		drvh=router_wr_driver::type_id::create("drvh",this);
		seqrh=router_wr_sequencer::type_id::create("seqrh",this);
	end
endfunction

function void router_wr_agent::connect_phase(uvm_phase phase);
 	if(m_cfg.is_active==UVM_ACTIVE)
	begin
		drvh.seq_item_port.connect(seqrh.seq_item_export);
	end
endfunction


