`timescale 1ns / 1ps

module sync_fifo #(
    parameter Depth = 8,
    parameter Width = 16
)(
    input  wire clk,
    input  wire reset,
    input  wire w_enb,
    input  wire r_enb,
    input  wire [Width-1:0] din,

    output reg  [Width-1:0] dout,
    output wire empty,
    output wire full
);

    function integer clog2;
        input integer value;
        integer temp;
        begin
            temp = value - 1;
            clog2 = 0;

            while (temp > 0) begin
                temp = temp >> 1;
                clog2 = clog2 + 1;
            end
        end
    endfunction

    localparam PTR_WIDTH =
        (Depth > 1) ? clog2(Depth) : 1;

    localparam COUNT_WIDTH =
        (Depth > 1) ? clog2(Depth + 1) : 1;

    reg [PTR_WIDTH-1:0] wptr;
    reg [PTR_WIDTH-1:0] rptr;
    reg [COUNT_WIDTH-1:0] count;

    reg [Width-1:0] fifo [0:Depth-1];

    assign full  = (count == Depth);
    assign empty = (count == 0);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wptr  <= {PTR_WIDTH{1'b0}};
            rptr  <= {PTR_WIDTH{1'b0}};
            count <= {COUNT_WIDTH{1'b0}};
            dout  <= {Width{1'b0}};
        end else begin

            // Write operation
            if (w_enb && !full) begin
                fifo[wptr] <= din;

                if (wptr == Depth - 1) begin
                    wptr <= {PTR_WIDTH{1'b0}};
                end else begin
                    wptr <= wptr + 1'b1;
                end
            end

            // Read operation
            if (r_enb && !empty) begin
                dout <= fifo[rptr];

                if (rptr == Depth - 1) begin
                    rptr <= {PTR_WIDTH{1'b0}};
                end else begin
                    rptr <= rptr + 1'b1;
                end
            end

            // Occupancy counter
            case ({w_enb && !full, r_enb && !empty})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase

        end
    end

endmodule