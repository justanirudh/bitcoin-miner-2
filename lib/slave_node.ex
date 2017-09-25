defmodule SlaveNode do
    
    #slave (./project ip)
    def start(app_name, master_node_ip) do
        setup_node(app_name)
        connect_to_master(app_name, master_node_ip)
        master_node_pid = :global.whereis_name(:master)
        slave_node_pid = self() # current BEAM process is slave             
        {num_zeroes, start_num, end_num} = request_work(master_node_pid, slave_node_pid)
        Master.start(num_zeroes, {:from_slave_node, master_node_pid, start_num, end_num}, slave_node_pid) #this request coming from a :slave
    end 

    defp setup_node(app_name) do
        current_ip = Utils.get_current_ip()     
        {:ok, _} = Utils.get_longname(app_name, "slave", current_ip) |> Node.start #converts current node to distributed node
        Application.get_env(app_name, :cookie) |> Node.set_cookie #gets common cookie and sets the master's with it
    end

    defp connect_to_master(app_name, master_node_ip) do
        _ = Utils.get_longname(app_name, "master", master_node_ip) |> Node.connect #connect to master
        :global.sync #sync global registry to let slave know of master being named :master
    end

    defp request_work(master_node_pid, slave_node_pid) do
        send master_node_pid, {:slave_node, slave_node_pid} #send request to master asking for work
        receive do #get the number of zeroes to be mined from master
            {:first_block, num_zeroes, start_num, end_num} -> {num_zeroes, start_num, end_num}
        end
    end

end