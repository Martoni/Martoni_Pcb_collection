module hub75_driver (
    input wire clk,           // Horloge du système
    input wire rst,           // Reset
    output reg [2:0] addr,    // Signaux d'adresse A, B, C
    output reg oe,            // Output Enable (actif bas)
    output reg latch,         // Latch signal
    output reg clk_out,       // Horloge pour les données RGB
    output reg r0, g0, b0,    // Couleurs pour la moitié supérieure
    output reg r1, g1, b1,     // Couleurs pour la moitié inférieure
    output GLM_LED1,
    output GLM_LED2,
    output GLM_LED3,
    output GLM_LED4
);

    assign GLM_LED1=1'b1;
    assign GLM_LED2=1'b0;
    assign GLM_LED3=1'b1;
    assign GLM_LED4=1'b0;


    reg [4:0] row_counter = 0; // Compteur de lignes (5 bits pour 32 lignes)
    reg [4:0] col_counter = 0; // Compteur de colonnes (5 bits pour 32 colonnes)
    reg [15:0] pixel_data;     // Données RGB
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            row_counter <= 0;
            col_counter <= 0;
            addr <= 3'b000;
            oe <= 1;
            latch <= 0;
            clk_out <= 0;
        end else begin
            // Envoi des données ligne par ligne
            if (col_counter < 31) begin
                col_counter <= col_counter + 1;
                clk_out <= ~clk_out; // Générer l'horloge pour la matrice
            end else begin
                col_counter <= 0;
                oe <= 1;         // Désactiver la sortie
                latch <= 1;      // Latch pour charger les nouvelles données
                
                if (row_counter < 31) begin
                    row_counter <= row_counter + 1;
                end else begin
                    row_counter <= 0;
                end
                
                addr <= row_counter[2:0]; // Mise à jour des signaux d'adresse
                oe <= 0;          // Réactiver la sortie après latch
                latch <= 0;
            end
        end
    end

    always @(*) begin
        // Simulation de récupération des données pixel (remplacer par mémoire réelle)
        pixel_data = (row_counter[0]) ? 16'hF800 : 16'h07E0; // Alternance Rouge/Vert
        
        // Attribution des bits de couleur (RGB565 simulé)
        r0 = pixel_data[15];
        g0 = pixel_data[10];
        b0 = pixel_data[5];
        r1 = pixel_data[14];
        g1 = pixel_data[9];
        b1 = pixel_data[4];
    end
endmodule
