defmodule Slave do
    @username "paanir"

    #change start of range from 1 to a bigger number say 100. end to be say 200-300
    #can cut off the last 'm digits'. might decrease probability of collision
    def mine(exp_num_zeroes, caller, curr_num, end_num) do
        if(curr_num > end_num) do
            slave_pid = self()
            send caller, {:local_end, slave_pid}
            receive do
                {:next_block, start_num, end_num} -> mine(exp_num_zeroes, caller, start_num, end_num)
            end
        else
            #number to base-73 string conversion
            key = @username <> Utils.change_base(curr_num)
            #hash generation
            hash = :crypto.hash(:sha256, key) |> Base.encode16
            #zero counting
            num_leading_zeroes = count(hash, 0)
            #checking expected number of zeroes        
            if(num_leading_zeroes == exp_num_zeroes) do
                send caller, {:res, key, hash}
            end
            mine(exp_num_zeroes, caller, curr_num + 1, end_num)
        end        
    end

    defp count(str , val) do
        case {str, val} do
            {"0" <> rest, val} -> count(rest, val + 1)
            _ -> val
        end
    end

end