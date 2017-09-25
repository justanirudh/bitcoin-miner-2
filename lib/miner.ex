defmodule Miner do
  def main(args) do     
      app_name = :project1
      arg = List.first(args) 
      #if a number, it is a master; if an ip, it is a slave 
      case :re.run(arg, "^[0-9]*$") do
        {:match, _} -> MasterNode.start(app_name, arg)
        :nomatch -> SlaveNode.start(app_name, arg) 
      end   
  end
end
