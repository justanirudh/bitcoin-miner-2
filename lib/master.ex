defmodule Master do
    @num_slaves 1000
    @local_block_size 1000 #1k is the size given to local slaves; 1-1000, 1001-2000
    @global_block_size 100000000 #100m is the size given to remote nodes (1m consumed by 1k processes)

    def start(num_zeroes, source, master_pid) do
        start_num = case source do
            {:from_master_node, start_num} -> start_num
            {:from_slave_node, _, start_num, _} -> start_num
        end
        #spawning of to a new process to not block this one
        {:ok, _} = Task.start(Master, :assign_work, [master_pid, num_zeroes, start_num, @num_slaves]) 
        next_block_start = start_num + (@num_slaves * @local_block_size) # needs to be sent to remote node
        case source do
            {:from_master_node, _} -> loop_master(next_block_start, num_zeroes) #if master. print it
            {:from_slave_node, master_node_pid, _, limit} -> loop_slave(master_node_pid, next_block_start, limit, master_pid) #if slave, send to master node
        end
    end

    def assign_work(caller, num_zeroes, start_num, slaves_rem) do
        case slaves_rem do
            0 -> :ok #dummy
            _ -> 
                end_num = start_num + @local_block_size - 1
                spawn(Slave, :mine, [num_zeroes, caller, start_num, end_num])
                assign_work(caller, num_zeroes, end_num + 1, slaves_rem - 1 )
        end
    end

    #if master, print
    defp loop_master(start_num, num_zeroes) do
        receive do
            {:res, rand_string, hash} -> #print hash
                IO.puts rand_string <> "\t" <> hash
                loop_master(start_num, num_zeroes)
            {:local_end, slave_pid} -> #local node finished work
                end_num = start_num + @local_block_size - 1
                send slave_pid, {:next_block, start_num, end_num}
                loop_master(end_num + 1, num_zeroes)
            {:slave_node, slave_node_pid} -> #new global slave node wants work
                end_num = start_num + @global_block_size - 1
                send slave_node_pid, {:first_block, num_zeroes, start_num, end_num}
                loop_master(end_num + 1, num_zeroes)
            {:global_end, slave_pid} -> #global node finished work
                end_num = start_num + @global_block_size - 1
                send slave_pid, {:next_block, start_num, end_num}
                loop_master(end_num + 1, num_zeroes)
        end     
    end

    #if slave, send to master
    defp loop_slave(master_node_pid, start_num, limit, master_pid) do
        if(start_num > limit) do #global slave wants more work
            send master_node_pid, {:global_end, master_pid}
            receive do
                {:next_block, new_start_num, new_limit} -> loop_slave(master_node_pid, new_start_num, new_limit, master_pid)
            end
        else
            receive do            
                {:res, rand_string, hash} -> #global slave found a hash
                    send master_node_pid, {:res, rand_string, hash}
                    loop_slave(master_node_pid, start_num, limit, master_pid)
                {:local_end, slave_pid} -> #local node finished work
                    end_num = start_num + @local_block_size - 1               
                    send slave_pid, {:next_block, start_num, end_num}
                    loop_slave(master_node_pid, end_num + 1, limit, master_pid)
            end  
        end
        
    end

end