`timescale 1ns / 1ps

// New self-checking testbench for Kranthi Uppada's MIT-licensed sync_fifo.
// Inputs change on falling edges. Outputs are checked after rising-edge NBA updates.
module sync_fifo_tb;
  parameter Depth = 8;
  parameter Width = 16;
  reg clk = 0;
  reg reset = 0;
  reg w_enb = 0;
  reg r_enb = 0;
  reg [Width-1:0] din = 0;
  wire [Width-1:0] dout;
  wire full, empty;

  sync_fifo #(.Depth(Depth), .Width(Width)) DUT (
    .clk(clk), .reset(reset), .w_enb(w_enb), .r_enb(r_enb),
    .din(din), .dout(dout), .full(full), .empty(empty)
  );
  always #5 clk = ~clk;

  reg [Width-1:0] reference [0:Depth-1];
  reg [Width-1:0] expected_dout = 0;
  integer head = 0, tail = 0, used = 0;
  integer errors = 0, cycles = 0, reads = 0, writes = 0;
  integer blocked_reads = 0, blocked_writes = 0, simultaneous = 0;
  integer i;
  integer seed = 12345;
  reg [31:0] random_control;
  reg [Width-1:0] random_data;
  reg take_read, take_write;

  // Reference model uses pre-edge occupancy, matching the original FIFO contract:
  // a write at full is rejected even if a read happens on that same edge;
  // a read at empty is rejected even if a write happens on that same edge.
  task step;
    input do_reset;
    input request_write;
    input request_read;
    input [Width-1:0] value;
    begin
      @(negedge clk);
      reset = do_reset;
      w_enb = request_write;
      r_enb = request_read;
      din = value;
      @(posedge clk);
      cycles = cycles + 1;
      if (do_reset) begin
        head = 0;
        tail = 0;
        used = 0;
        expected_dout = 0;
      end else begin
        take_read = request_read && (used > 0);
        take_write = request_write && (used < Depth);
        if (request_read && !take_read) blocked_reads = blocked_reads + 1;
        if (request_write && !take_write) blocked_writes = blocked_writes + 1;
        // Read first so the reference remains correct if head == tail.
        if (take_read) begin
          expected_dout = reference[head];
          head = (head + 1) % Depth;
          reads = reads + 1;
        end
        if (take_write) begin
          reference[tail] = value;
          tail = (tail + 1) % Depth;
          writes = writes + 1;
        end
        if (take_write && !take_read) used = used + 1;
        if (take_read && !take_write) used = used - 1;
        if (take_read && take_write) simultaneous = simultaneous + 1;
      end
      #1;
      if (dout !== expected_dout) begin
        errors = errors + 1;
        $display("ERROR data: cycle=%0d expected=%h actual=%h", cycles, expected_dout, dout);
      end
      if (full !== (used == Depth)) begin
        errors = errors + 1;
        $display("ERROR full: cycle=%0d occupancy=%0d actual=%b", cycles, used, full);
      end
      if (empty !== (used == 0)) begin
        errors = errors + 1;
        $display("ERROR empty: cycle=%0d occupancy=%0d actual=%b", cycles, used, empty);
      end
    end
  endtask

  initial begin
    $display("START self-checking FIFO test Depth=%0d Width=%0d", Depth, Width);
    step(1, 0, 0, 0);
    step(0, 0, 0, 0);
    $display("TEST empty protection");
    repeat (3) step(0, 0, 1, 0);
    $display("TEST fill, full protection, simultaneous request at full");
    for (i=0; i<Depth; i=i+1) step(0, 1, 0, i+16'h100);
    repeat (3) step(0, 1, 0, 16'hDEAD);
    step(0, 1, 1, 16'hBEEF);
    $display("TEST drain and simultaneous request at empty");
    repeat (Depth-1) step(0, 0, 1, 0);
    step(0, 1, 1, 16'h1234);
    step(0, 0, 1, 0);
    $display("TEST pointer wrap and simultaneous transfers");
    for (i=0; i<Depth/2+1; i=i+1) step(0, 1, 0, i);
    for (i=0; i<4*Depth; i=i+1) step(0, 1, 1, i+16'h200);
    $display("TEST reset while data is buffered and requests are asserted");
    step(1, 1, 1, 16'hFFFF);
    step(0, 0, 1, 0);
    $display("TEST 1000 reproducible pseudo-random cycles");
    for (i=0; i<1000; i=i+1) begin
      random_control = $random(seed);
      random_data = $random(seed);
      step(0, random_control[0], random_control[1], random_data);
    end
    // Drain all outstanding expected data.
    while (used > 0) step(0, 0, 1, 0);
    step(0, 0, 0, 0);
    if ((reads == 0) || (writes == 0) || (blocked_reads == 0) ||
        (blocked_writes == 0) || (simultaneous == 0)) begin
      errors = errors + 1;
      $display("ERROR: a required transaction category was not exercised");
    end
    $display("SUMMARY cycles=%0d writes=%0d reads=%0d blocked_writes=%0d blocked_reads=%0d simultaneous=%0d errors=%0d",
      cycles, writes, reads, blocked_writes, blocked_reads, simultaneous, errors);
    if (errors == 0) $display("PASS: all data and flag checks passed");
    else $fatal(1, "FAIL: %0d checks failed", errors);
    $finish;
  end
  initial begin
    #1000000;
    $fatal(1, "FAIL: simulation timeout");
  end
endmodule
