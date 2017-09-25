defmodule Utils do
    @base 73
    @base_chars "1234567890-=qwertyuiop[]\asdfghjkl;`'zxcvbnm,./'QWERTYUIOPASDFGHJKLZXCVBNM"
    
    def get_current_ip do
        #get ip of current node
        {:ok, [ tuples | _]} = :inet.getif
        elem(tuples,0) |> :inet_parse.ntoa
    end

    def get_longname(app_name, node_type, ip) do
        String.to_atom("#{app_name}-#{node_type}@#{ip}")
    end

    def change_base(num), do: change_base(num, "")

    #remainders prepended make the base-73 representation
    defp change_base(num, str) do
        case num do
            0 -> str
            _ ->change_base(div(num, @base), String.at(@base_chars, rem(num, @base)) <> str) 
        end
    end 

end