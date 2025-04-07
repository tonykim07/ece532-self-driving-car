`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 09:29:23 AM
// Design Name: 
// Module Name: inverse_table
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module inverse_table(
  input wire clk,
  input wire rst_n,

  input wire [7:0]  denominator,
  output reg [32:0] inverse // UQ1.32 format
);

  (* ram_type = "distributed" *) reg [31:0] inverse_table [0:255];

  always @(posedge clk) begin
    if (!rst_n) begin
      inverse <= 0;
    end else begin
      inverse <= (denominator == 1) ? 1<<32 : inverse_table[denominator];
    end
  end

  initial begin
    inverse_table[0] = 'h00000000;
    inverse_table[1] = 'h00000000;
    inverse_table[2] = 'h80000000;
    inverse_table[3] = 'h55555555;
    inverse_table[4] = 'h40000000;
    inverse_table[5] = 'h33333333;
    inverse_table[6] = 'h2AAAAAAA;
    inverse_table[7] = 'h24924924;
    inverse_table[8] = 'h20000000;
    inverse_table[9] = 'h1C71C71C;
    inverse_table[10] = 'h19999999;
    inverse_table[11] = 'h1745D174;
    inverse_table[12] = 'h15555555;
    inverse_table[13] = 'h13B13B13;
    inverse_table[14] = 'h12492492;
    inverse_table[15] = 'h11111111;
    inverse_table[16] = 'h10000000;
    inverse_table[17] = 'h0F0F0F0F;
    inverse_table[18] = 'h0E38E38E;
    inverse_table[19] = 'h0D79435E;
    inverse_table[20] = 'h0CCCCCCC;
    inverse_table[21] = 'h0C30C30C;
    inverse_table[22] = 'h0BA2E8BA;
    inverse_table[23] = 'h0B21642C;
    inverse_table[24] = 'h0AAAAAAA;
    inverse_table[25] = 'h0A3D70A3;
    inverse_table[26] = 'h09D89D89;
    inverse_table[27] = 'h097B425E;
    inverse_table[28] = 'h09249249;
    inverse_table[29] = 'h08D3DCB0;
    inverse_table[30] = 'h08888888;
    inverse_table[31] = 'h08421084;
    inverse_table[32] = 'h08000000;
    inverse_table[33] = 'h07C1F07C;
    inverse_table[34] = 'h07878787;
    inverse_table[35] = 'h07507507;
    inverse_table[36] = 'h071C71C7;
    inverse_table[37] = 'h06EB3E45;
    inverse_table[38] = 'h06BCA1AF;
    inverse_table[39] = 'h06906906;
    inverse_table[40] = 'h06666666;
    inverse_table[41] = 'h063E7063;
    inverse_table[42] = 'h06186186;
    inverse_table[43] = 'h05F417D0;
    inverse_table[44] = 'h05D1745D;
    inverse_table[45] = 'h05B05B05;
    inverse_table[46] = 'h0590B216;
    inverse_table[47] = 'h0572620A;
    inverse_table[48] = 'h05555555;
    inverse_table[49] = 'h05397829;
    inverse_table[50] = 'h051EB851;
    inverse_table[51] = 'h05050505;
    inverse_table[52] = 'h04EC4EC4;
    inverse_table[53] = 'h04D4873E;
    inverse_table[54] = 'h04BDA12F;
    inverse_table[55] = 'h04A7904A;
    inverse_table[56] = 'h04924924;
    inverse_table[57] = 'h047DC11F;
    inverse_table[58] = 'h0469EE58;
    inverse_table[59] = 'h0456C797;
    inverse_table[60] = 'h04444444;
    inverse_table[61] = 'h04325C53;
    inverse_table[62] = 'h04210842;
    inverse_table[63] = 'h04104104;
    inverse_table[64] = 'h04000000;
    inverse_table[65] = 'h03F03F03;
    inverse_table[66] = 'h03E0F83E;
    inverse_table[67] = 'h03D22635;
    inverse_table[68] = 'h03C3C3C3;
    inverse_table[69] = 'h03B5CC0E;
    inverse_table[70] = 'h03A83A83;
    inverse_table[71] = 'h039B0AD1;
    inverse_table[72] = 'h038E38E3;
    inverse_table[73] = 'h0381C0E0;
    inverse_table[74] = 'h03759F22;
    inverse_table[75] = 'h0369D036;
    inverse_table[76] = 'h035E50D7;
    inverse_table[77] = 'h03531DEC;
    inverse_table[78] = 'h03483483;
    inverse_table[79] = 'h033D91D2;
    inverse_table[80] = 'h03333333;
    inverse_table[81] = 'h0329161F;
    inverse_table[82] = 'h031F3831;
    inverse_table[83] = 'h03159721;
    inverse_table[84] = 'h030C30C3;
    inverse_table[85] = 'h03030303;
    inverse_table[86] = 'h02FA0BE8;
    inverse_table[87] = 'h02F14990;
    inverse_table[88] = 'h02E8BA2E;
    inverse_table[89] = 'h02E05C0B;
    inverse_table[90] = 'h02D82D82;
    inverse_table[91] = 'h02D02D02;
    inverse_table[92] = 'h02C8590B;
    inverse_table[93] = 'h02C0B02C;
    inverse_table[94] = 'h02B93105;
    inverse_table[95] = 'h02B1DA46;
    inverse_table[96] = 'h02AAAAAA;
    inverse_table[97] = 'h02A3A0FD;
    inverse_table[98] = 'h029CBC14;
    inverse_table[99] = 'h0295FAD4;
    inverse_table[100] = 'h028F5C28;
    inverse_table[101] = 'h0288DF0C;
    inverse_table[102] = 'h02828282;
    inverse_table[103] = 'h027C4597;
    inverse_table[104] = 'h02762762;
    inverse_table[105] = 'h02702702;
    inverse_table[106] = 'h026A439F;
    inverse_table[107] = 'h02647C69;
    inverse_table[108] = 'h025ED097;
    inverse_table[109] = 'h02593F69;
    inverse_table[110] = 'h0253C825;
    inverse_table[111] = 'h024E6A17;
    inverse_table[112] = 'h02492492;
    inverse_table[113] = 'h0243F6F0;
    inverse_table[114] = 'h023EE08F;
    inverse_table[115] = 'h0239E0D5;
    inverse_table[116] = 'h0234F72C;
    inverse_table[117] = 'h02302302;
    inverse_table[118] = 'h022B63CB;
    inverse_table[119] = 'h0226B902;
    inverse_table[120] = 'h02222222;
    inverse_table[121] = 'h021D9EAD;
    inverse_table[122] = 'h02192E29;
    inverse_table[123] = 'h0214D021;
    inverse_table[124] = 'h02108421;
    inverse_table[125] = 'h020C49BA;
    inverse_table[126] = 'h02082082;
    inverse_table[127] = 'h02040810;
    inverse_table[128] = 'h02000000;
    inverse_table[129] = 'h01FC07F0;
    inverse_table[130] = 'h01F81F81;
    inverse_table[131] = 'h01F44659;
    inverse_table[132] = 'h01F07C1F;
    inverse_table[133] = 'h01ECC07B;
    inverse_table[134] = 'h01E9131A;
    inverse_table[135] = 'h01E573AC;
    inverse_table[136] = 'h01E1E1E1;
    inverse_table[137] = 'h01DE5D6E;
    inverse_table[138] = 'h01DAE607;
    inverse_table[139] = 'h01D77B65;
    inverse_table[140] = 'h01D41D41;
    inverse_table[141] = 'h01D0CB58;
    inverse_table[142] = 'h01CD8568;
    inverse_table[143] = 'h01CA4B30;
    inverse_table[144] = 'h01C71C71;
    inverse_table[145] = 'h01C3F8F0;
    inverse_table[146] = 'h01C0E070;
    inverse_table[147] = 'h01BDD2B8;
    inverse_table[148] = 'h01BACF91;
    inverse_table[149] = 'h01B7D6C3;
    inverse_table[150] = 'h01B4E81B;
    inverse_table[151] = 'h01B20364;
    inverse_table[152] = 'h01AF286B;
    inverse_table[153] = 'h01AC5701;
    inverse_table[154] = 'h01A98EF6;
    inverse_table[155] = 'h01A6D01A;
    inverse_table[156] = 'h01A41A41;
    inverse_table[157] = 'h01A16D3F;
    inverse_table[158] = 'h019EC8E9;
    inverse_table[159] = 'h019C2D14;
    inverse_table[160] = 'h01999999;
    inverse_table[161] = 'h01970E4F;
    inverse_table[162] = 'h01948B0F;
    inverse_table[163] = 'h01920FB4;
    inverse_table[164] = 'h018F9C18;
    inverse_table[165] = 'h018D3018;
    inverse_table[166] = 'h018ACB90;
    inverse_table[167] = 'h01886E5F;
    inverse_table[168] = 'h01861861;
    inverse_table[169] = 'h0183C977;
    inverse_table[170] = 'h01818181;
    inverse_table[171] = 'h017F405F;
    inverse_table[172] = 'h017D05F4;
    inverse_table[173] = 'h017AD220;
    inverse_table[174] = 'h0178A4C8;
    inverse_table[175] = 'h01767DCE;
    inverse_table[176] = 'h01745D17;
    inverse_table[177] = 'h01724287;
    inverse_table[178] = 'h01702E05;
    inverse_table[179] = 'h016E1F76;
    inverse_table[180] = 'h016C16C1;
    inverse_table[181] = 'h016A13CD;
    inverse_table[182] = 'h01681681;
    inverse_table[183] = 'h01661EC6;
    inverse_table[184] = 'h01642C85;
    inverse_table[185] = 'h01623FA7;
    inverse_table[186] = 'h01605816;
    inverse_table[187] = 'h015E75BB;
    inverse_table[188] = 'h015C9882;
    inverse_table[189] = 'h015AC056;
    inverse_table[190] = 'h0158ED23;
    inverse_table[191] = 'h01571ED3;
    inverse_table[192] = 'h01555555;
    inverse_table[193] = 'h01539094;
    inverse_table[194] = 'h0151D07E;
    inverse_table[195] = 'h01501501;
    inverse_table[196] = 'h014E5E0A;
    inverse_table[197] = 'h014CAB88;
    inverse_table[198] = 'h014AFD6A;
    inverse_table[199] = 'h0149539E;
    inverse_table[200] = 'h0147AE14;
    inverse_table[201] = 'h01460CBC;
    inverse_table[202] = 'h01446F86;
    inverse_table[203] = 'h0142D662;
    inverse_table[204] = 'h01414141;
    inverse_table[205] = 'h013FB013;
    inverse_table[206] = 'h013E22CB;
    inverse_table[207] = 'h013C995A;
    inverse_table[208] = 'h013B13B1;
    inverse_table[209] = 'h013991C2;
    inverse_table[210] = 'h01381381;
    inverse_table[211] = 'h013698DF;
    inverse_table[212] = 'h013521CF;
    inverse_table[213] = 'h0133AE45;
    inverse_table[214] = 'h01323E34;
    inverse_table[215] = 'h0130D190;
    inverse_table[216] = 'h012F684B;
    inverse_table[217] = 'h012E025C;
    inverse_table[218] = 'h012C9FB4;
    inverse_table[219] = 'h012B404A;
    inverse_table[220] = 'h0129E412;
    inverse_table[221] = 'h01288B01;
    inverse_table[222] = 'h0127350B;
    inverse_table[223] = 'h0125E227;
    inverse_table[224] = 'h01249249;
    inverse_table[225] = 'h01234567;
    inverse_table[226] = 'h0121FB78;
    inverse_table[227] = 'h0120B470;
    inverse_table[228] = 'h011F7047;
    inverse_table[229] = 'h011E2EF3;
    inverse_table[230] = 'h011CF06A;
    inverse_table[231] = 'h011BB4A4;
    inverse_table[232] = 'h011A7B96;
    inverse_table[233] = 'h01194538;
    inverse_table[234] = 'h01181181;
    inverse_table[235] = 'h0116E068;
    inverse_table[236] = 'h0115B1E5;
    inverse_table[237] = 'h011485F0;
    inverse_table[238] = 'h01135C81;
    inverse_table[239] = 'h0112358E;
    inverse_table[240] = 'h01111111;
    inverse_table[241] = 'h010FEF01;
    inverse_table[242] = 'h010ECF56;
    inverse_table[243] = 'h010DB20A;
    inverse_table[244] = 'h010C9714;
    inverse_table[245] = 'h010B7E6E;
    inverse_table[246] = 'h010A6810;
    inverse_table[247] = 'h010953F3;
    inverse_table[248] = 'h01084210;
    inverse_table[249] = 'h01073260;
    inverse_table[250] = 'h010624DD;
    inverse_table[251] = 'h0105197F;
    inverse_table[252] = 'h01041041;
    inverse_table[253] = 'h0103091B;
    inverse_table[254] = 'h01020408;
    inverse_table[255] = 'h01010101;
  end


endmodule
