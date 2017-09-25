defmodule MasterNode do

    #master (./project1 num_zeroes)
    def start(app_name, num_zeroes) do
        setup_node(app_name) #makes current node distributed and register
        master_pid = self()
        String.to_integer(num_zeroes) |> Master.start({:from_master_node, 1}, master_pid) 
    end

    defp setup_node(app_name) do
        master = self() # current BEAM process is master
        {:ok, _} = Utils.get_longname(app_name, "master", Utils.get_current_ip()) |> Node.start #converts current node to distributed node
        Application.get_env(app_name, :cookie) |> Node.set_cookie #gets common cookie and sets the master's with it
        :global.register_name(:master, master) #registers it for all connected nodes
    end
        
end