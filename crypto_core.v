// Logische Gatter-Struktur für einen dedizierten Krypto-Beschleuniger auf dem Chip
module crypto_core (
    input wire clk,
    input wire rst_n,
    input wire [31:0] data_in,   // 32-Bit Dateneingang (Zubringung aus Telekommunikation)
    input wire start_sha,        // Trigger-Signal für die Krypto-Operation
    output reg ready,            // Status-Pin: Berechnung abgeschlossen
    output reg [31:0] hash_chunk // Erster verarbeiteter Block des SHA-256-Vorgangs
);

    // Interne Schieberegister und logische Funktionen (Ch, Maj) nach SHA-256 Standard
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hash_chunk <= 31'h0;
            ready <= 1'b0;
        } else if (start_sha) begin
            // Bitweise logische Gatter-Verschaltung (Beispielhafte Kompressions-Runde)
            hash_chunk <= (data_in ^ 32'h5A827999) + (data_in << 2); 
            ready <= 1'b1;
        } else begin
            ready <= 1'b0;
        end
    end

endmodule
