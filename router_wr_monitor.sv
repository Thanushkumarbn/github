class router_wr_monitor extends uvm_monitor;

	`uvm_component_utils(router_wr_monitor)

    virtual router_if.WMON_MP vif;
    router_wr_agt_config m_cfg;

	uvm_analysis_port#(write_xtn) monitor_port;

	extern function new(string name ="router_wr_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
endclass

function router_wr_monitor::new(string name ="router_wr_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port = new("monitor_port",this);
endfunction

function void router_wr_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
      
    if(!uvm_config_db #(router_wr_agt_config)::get(this,"","router_wr_agt_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

function void router_wr_monitor::connect_phase(uvm_phase phase);
	vif = m_cfg.vif;
endfunction

task router_wr_monitor::run_phase(uvm_phase phase);
	forever
       	collect_data();
endtask

task router_wr_monitor::collect_data();
    
    	write_xtn mon_data;
    	begin
      		mon_data = write_xtn::type_id::create("mon_data");
      		
		@(vif.wmon_cb);
		while(!vif.wmon_cb.pkt_valid)
			@(vif.wmon_cb);
		while(vif.wmon_cb.busy)
            @(vif.wmon_cb);      
			
      	mon_data.header = vif.wmon_cb.data_in;
      	mon_data.payload_data = new[mon_data.header[7:2]];
      	@(vif.wmon_cb)	
      	foreach(mon_data.payload_data[i])
        begin
			while(vif.wmon_cb.busy)
				@(vif.wmon_cb);
          			
			mon_data.payload_data[i]=vif.wmon_cb.data_in;
          	@(vif.wmon_cb);
        end

		while(vif.wmon_cb.busy)
			@(vif.wmon_cb);
      
      	mon_data.parity = vif.wmon_cb.data_in;
      	repeat(2) @(vif.wmon_cb);
      	mon_data.err=vif.wmon_cb.error;
      
      	`uvm_info("ROUTER_WR_MONITOR",$sformatf("printing from monitor \n %s",mon_data.sprint()),UVM_LOW)
      	monitor_port.write(mon_data);
    	end
  
endtask
   

