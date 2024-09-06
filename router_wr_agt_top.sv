class router_wr_agt_top extends uvm_env;
	
	`uvm_component_utils(router_wr_agt_top)

	router_wr_agent agnth[];

	router_env_config m_cfg;

	extern function new (string name="router_wr_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass

function router_wr_agt_top::new(string name="router_wr_agt_top",uvm_component parent);
        super.new(name,parent);
endfunction

function void router_wr_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
                `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

	agnth = new[m_cfg.no_of_write_agent];

 	foreach(agnth[i])
        	begin
				agnth[i]=router_wr_agent::type_id::create($sformatf("agnth[%0d]",i) ,this);
                uvm_config_db #(router_wr_agt_config)::set(this,$sformatf("agnth[%0d]*",i),  "router_wr_agt_config", m_cfg.wr_agt_cfg[i]);
            end
endfunction


