# jane-street-solution
Can you reverse engineer an ASIC?

The simplest, most straight-forward solution to Jane Street's ASIC puzzle

Tools: Klayout, Python, Verilog, Yosys, Sby, z3, Surfer 

Step 1:
After opening the GDS file in Klayout, I poked around the design and was able to confirm it was unflattened and in sky130.

Step 2:
Next, I imported the sky130 LVS file to extract the target netlist. I went through the file by hand and commented out each line that either referenced a schematic or did a comparison. 

Step 3:
The netlist had both standard cell instantiations (X lines) and MOSFET gate definitions (M lines). In order to put it into Yosys, the M lines had to be removed through a process I learned was called black boxing.

Step 4:
Now it was time to parse the file into Verilog, which I did so using a python script.

Step 5:
Finally, it was time to use Yosys. I imported the skywater 130 A lib file. As the lib file had many, many functions that were unnecessary for this run, I removed parts like those pertaining to clock functions etc.

Step 6:
Eventually, Yosys ran successfully and I now had a RTL file with wires and posedge blocks.

Step 7:
The blog explained that there was an output, an input, and a success pin, and I thought that the solution to the puzzle must be when success is high. So I researched how to find this out, and one of the ways to do so is using SymbiYosys with SMT solvers.

Step 8:
I ran a wrapper and a sby file against the verilog, and started with Bitwuzla with a depth of 128. Once I ran the file, I opened the trace in Surfer and discovered that it had found an output where success was high, and that was was 28 (in hex) or "(" in ASCII.

Step 9:
I re-ran the file, changing the mode from bmc to prove and increasing the depth to 150, however I was unable to find any other output values where success remained high. Under the original LinkedIn post, someone had mentioned using z3 instead of Bitwuzla. I thought it might be faster and decided to try it out. I made a new sby file, using z3 instead, with cover mode. I was surprised to find it was actually slower than Bitwzula, but when I opened the trace in Surfer I was stunned to see there were now two hex values in the output section while success was high for an additional clock cycle. These hex values were 28 and 2a.

Step 11:
Interesting. I wasn't sure what I was looking for anymore, but as it was only 2 values I had a small Verilog code that would ensure more output values on a set number of additional clock cycles were printed while success stayed high. I started with 3, which gave me 28 and 2a again. Then I increased it to 10, which gave me a string with a final output value of 20, and that didn't really make sense because I assumed it would end with a parentheses as well. I decided to up the clock cycles to 15 and re-ran it, which gave me 28, 2a, 20, 54, 57, 4f, 20, 53, 54, 41, 52, 53, 20, 2a, 29.

Step 12:
I now had a hex string, and the last step was to convert it into ASCII and hope for a legible phrase. I searched up a converter, dropped in the string, and received an output of (* TWO STARS *). Which is actually really cute. And I had finally solved the Jane Street puzzle!!! Congratulations to everyone who did as well, and thanks so much to the team who made this puzzle.

I hope this write-up is inspiring to other people and students with similar passions, or maybe those who want to learn something they've never worked with before. If there is one thing I learned from this puzzle, it is the importance of trying different strategies. I used AI liberally to help with the python scripts, but the process and steps were entirely human-generated. Feel free to reach me at a.vedn45@proton.me if you have any questions or would like further clarification on any steps.
