module rgb_2_hsv(
  input [23:0] rgb,
//  input [2:0] saturation_contrib,
//  input [2:0] value_contrib,
  output [8:0] hue
//  output [8:0] saturation,
//  output [8:0] value
);

  reg [7:0] r, g, b;
  reg [7:0] max, min;
  reg signed [8:0] delta;
  reg signed [8:0] h;

  always @(*) begin
    r = rgb[23:16];
    b = rgb[15:8];
    g = rgb[7:0];
    max = r > g ? r : g;
    max = max > b ? max : b;
    min = r < g ? r : g;
    min = min < b ? min : b;
    delta = max - min;
    if (delta == 0) begin
      h = 0;
    end else if (max == r) begin
      h = (g - b) / delta;
    end else if (max == g) begin
      h = 2 + (b - r) / delta;
    end else begin
      h = 4 + (r - g) / delta;
    end
    h = h * 42.5;
  end

  assign hue = h;
//  assign value = max >> value_contrib;
//  assign saturation = (max == 0) ? 0 : (delta / max) >> saturation_contrib;
  
endmodule