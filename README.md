# Miner

Group Members(1): Anirudh Pathak

Short description of design:

Hashing algorithm - I have create a base-73 system that converts a number to a base-73 string, 
which is then given as an input to SHA-256 generator

Work distribution algorithm - I spawn 1K processes in each node and give them blocks of numbers. Each worker converts the number into a 
Base-73 string, generates SHA256 hash and if it satisfies the given number of zeroes, send it to master 
to print it

Questions:

Q. Size of the work unit that you determined results in best performance for your implementation and an explanation on how you determined it. Size of the work unit refers to the number of sub-problems that a worker gets in a single request from the boss.

Ans: Size of the work-unit: 1K numbers per local worker, 100M numbers per remote worker

Local worker: I spawn 1K processes in each node and each process gets 1K block of numbers at a time
When they exhaust their block, they ask master for the next available 1K block

Remote worker: I give block size of 100M numbers to a remote worker. This is because each
remote worker has its own 1K processes mining, each of which mine 1K block of numbers at a time.
Hence, the total numbers covered by ALL processes in 1 iteration is 1M (1K x 1K). Hence, the remote node
is busy for 100 such FULL iterations (hence, 100M) before it asks for more work from the master. 
Since, remote calls are more expensive than local calls, it is a good idea to keep the remote node busy for a while.

How I came up with block of '1K' size: I wanted to give each local worker enough work to make sure it is busy
for sometime. If I gave it less work, CPU utilization will go down as a lot more time will be spent in sending-receiving
messages rather than doing actual work. I did not want to give each worker more than 1K because I wanted each worker to 
explore different spaces of the universe for the required string rather than get stuck with one huge block to process

 
Q. The result of running your program for ./project1 4

Ans: 
paanir4oA       0000803C006E4EACBAE75EACB2817F1B78108B6F1FEAC22540C29037D764B3B7
paaniroDL       0000E282B6CBAA9D93CB711D5A3C02267671430EF30BF155D0D8800D9BAA56DC
paanir;m9       0000941C6EF0A9FA79939230BB87248A6955B576F8673155CDBE148C4A40E56A
paanir`u9       0000DED7775A36A4A11F39C5A41B26961AB3D94279496466FE3E6A379B884B33
paanirmhO       00008A011CB3FD06657F8D698783A4FA80A5BC3D12C93DBDCABE96EDCB929CDB
paanir28jC      0000C8AB6B3DFF6CE0D92F29EEBB07921537CD627478801248513F1F80B75DB4
paanir2-l4      0000682E97DEF930D894837E9109D45AEE606689E503258DABE97500C5D12D86
paanir2w/d      00009BF0F4E616A34C38DFA7A8A549FC780FD60B58F46E89B642DB8400502B38
paanir2n4R      0000790AFBCFE7F54342E69FBFF21F32D0D1D6E7817CB32C20CA4C870B8E9D84
paanir2C0I      000083FBFE1701B8802578D5E3A34F4955345BC86CC832B4132CC7A2B80DA526
paanir3048      000097FDD880E3B061A48AD227B1768DF408FD53FE5D7148E0A0627501EB91F2
paanir3esz      0000D7DECD16290E81CFF8711522FF2772B65C83E88254373C695B09DE796F9A
paanir3'5j      0000779EA15AF381A77748036A35D791F1F9B3B05AA5B5E3A55B282886AF0777
paanir3mrc      0000E905097C7E7FD6582BFB70DB744EFBEB28D9D833FEEF6C8E52156874ABF7
paanir3'5j      0000779EA15AF381A77748036A35D791F1F9B3B05AA5B5E3A55B282886AF0777
. . . . . . . . . . . . . . . . . . 

Q. The running time for the above as reported by time for the above, i.e. run time ./project1 5 and report the time. The ratio of CPU time
to REAL TIME tells you how many cores were eectively used in the computation. If your are close to 1 you have almost no parallelism (points
will be subtracted).

Ans: 
real    0m41.486s
user    2m16.348s
sys     0m2.954s
CPU time / Real time = 3.3 (on a 4 core machine)

Q. The coin with the most 0s you managed to find.
Ans: 7
paanir7r.sd 00000002E992C412D2DE67B3772ADFD666253ED7A384A8C921D265C40A8A2A3B

Q. The largest number of working machines you were able to run your code with.
Ans: 7 machines, 48 cores ((8 x 5) + (4 x 2))

