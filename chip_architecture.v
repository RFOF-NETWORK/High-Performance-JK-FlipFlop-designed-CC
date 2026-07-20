// Echte Hardware-Beschreibung für die Halbleiter-Fabrik (Foundry)
module chip_architecture (
    input wire clk,           // Physischer Takt-Pin (Clock)
    input wire rst_n,         // Globaler Reset-Pin (Aktiv bei Low)
    input wire [1:0] op_code, // Befehlseingang für die ALU (Rechenwerk)
    input wire j,             // J-Eingang für das J.K.-Flipflop
    input wire k,             // K-Eingang für das J.K.-Flipflop
    output reg [7:0] alu_out, // 8-Bit Ausgang des Rechenwerks
    output reg jk_q           // Physischer Ausgang des J.K.-Flipflops
);

    // 1. ATOMARE BIT-SPEICHERUNG (J.K.-Flipflop)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            jk_q <= 1'b0;
        end else begin
            case ({j, k})
                2'b00 : jk_q <= jk_q;  // Zustand stabil halten
                2'b01 : jk_q <= 1'b0;  // Reset auf Bit 0
                2'b10 : jk_q <= 1'b1;  // Set auf Bit 1
                2'b11 : jk_q <= ~jk_q; // Toggle (Invertieren)
            endcase
        end
    end

    // 2. MONOLITHISCHE ALU (Rechenwerk für mathematische Semantik)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alu_out <= 8'h00;
        end else begin
            case (op_code)
                2'b00: alu_out <= alu_out + 1'b1; // Inkrementieren
                2'b01: alu_out <= alu_out - 1'b1; // Dekrementieren
                2'b10: alu_out <= alu_out ^ 8'hAA; // XOR Bitmaske (Krypto-Vorphase)
                2'b11: alu_out <= {alu_out[6:0], jk_q}; // Bit-Shift mit Flipflop-Inhalt
                default: alu_out <= alu_out;
            endcase
        end
    end

endmodule
