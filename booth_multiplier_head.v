module half_adder (
    input  wire [1:0]  cin ,
    output wire        Cout,
    output wire        S    
);
    assign S    = (cin[0]&~cin[1])|(~cin[0]&cin[1]);
    assign Cout = cin[0]&cin[1];
endmodule
//////////////////////////////////////////////////////////////////////////////////
module full_adder (
    input  wire  [2:0] cin ,
    output wire        Cout,
    output wire        S    
);
    assign S = (cin[0]&~cin[1]&~cin[2])|(~cin[0]&cin[1]&~cin[2])|(~cin[0]&~cin[1]&cin[2])|(cin[0]&cin[1]&cin[2]);
    assign Cout = cin[0]&cin[1]|cin[0]&cin[2]|cin[1]&cin[2];
endmodule
//////////////////////////////////////////////////////////////////////////////////
module adder4
(
input    wire          cin ,//���Ե�λ�Ľ�λ����
input    wire [3:0]    p   ,//p=a|b ��λ��������
input    wire [3:0]    g   ,//g=a&b ��λ��������
output   wire          G   ,//��һ���Ľ�λ��������
output   wire          P   ,//��һ���Ľ�λ��������
output   wire [2:0]    cout //ÿ��bit��Ӧ�Ľ�λ���
);

assign P=&p;
assign G=g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0]);
assign cout[0]=g[0]|(p[0]&cin);
assign cout[1]=g[1]|(p[1]&g[0])|(p[1]&p[0]&cin);
assign cout[2]=g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin);
endmodule
//////////////////////////////////////////////////////////////////////////////////
module adder32(
    input  wire [31:0]  a   ,//�������ݣ������Ʋ���
    input  wire [31:0]  b   ,//�������ݣ������Ʋ���
    input  wire         cin ,//���Ե�λ�Ľ�λ����
    output wire [31:0]  out ,//�����a + b�������Ʋ��루���������λ�Ľ�λ��
    output wire         cout //�����a + b���Ľ�λ
);

// level1
wire [31:0] p1 = a|b;
wire [31:0] g1 = a&b;
wire [31:0] c;//ÿһλ�Ľ�λ���
wire [7:0] p2, g2;
wire [1:0] p3, g3;
assign c[0] = cin;

genvar j;
generate
    for (j = 0; j<8; j=j+1) begin
        adder4 u_adder4_l1 (.p(p1[(4*j+3)-:4]),.g(g1[(4*j+3)-:4]),.cin(c[j*4]),.P(p2[j]),.G(g2[j]),.cout(c[(4*j+3)-:3]));
    end
endgenerate

// level2
generate
    for (j = 0; j<2; j=j+1) begin
        adder4 u_adder4_l2 (.p(p2[(4*j+3)-:4]),.g(g2[(4*j+3)-:4]),.cin(c[j*16]),.P(p3[j]),.G(g3[j]),.cout({c[j*16+12],c[j*16+8],c[j*16+4]}));
    end
endgenerate

// level3
assign c[16]=g3[0]|(p3[0]&c[0]);

// �õ���λ�����ӷ���
assign cout = (a[31]&b[31]) | (a[31]&c[31]) | (b[31]&c[31]);
assign out = (~a&~b&c)|(~a&b&~c)|(a&~b&~c)|(a&b&c);

endmodule
//////////////////////////////////////////////////////////////////////////////////
module booth_decoder (
    input  wire [31:0] xin ,//����x
    input  wire [2: 0] yin ,//�ӳ���yѡȡ�ģ�3bit�����ź�
    output wire        cout,//�õ��Ĳ��ֻ�����Ǹ����Ļ�����Ҫ"ȡ����һ"����������ָʾ�Ƿ�"��һ"
    output wire [32:0] xout //booth�����õ���1�����ֻ�����������
);
    // wire x_none = (~yin[2]&~yin[1]&~yin[0])|(yin[2]&yin[1]&yin[0]);
    wire x_add1 = (~yin[2]&~yin[1]&yin[0])|(~yin[2]&yin[1]&~yin[0]);
    wire x_add2 = (~yin[2]&yin[1]&yin[0]);
    wire x_sub2 = (yin[2]&~yin[1]&~yin[0]);
    wire x_sub1 = (yin[2]&~yin[1]&yin[0])|(yin[2]&yin[1]&~yin[0]);

    assign xout = {33{x_add1}} & {xin[31],xin}//�ӷ�Ϊ����������λΪ0
                | {33{x_add2}} & {xin[31:0],1'b0}
                | {33{x_sub1}} & {~xin[31],~xin} 
                | {33{x_sub2}} & ({~xin[31:0],1'b1}) 
                ;
    assign cout = x_sub1|x_sub2;
endmodule
//////////////////////////////////////////////////////////////////////////////////
module booth_decoder_16 (
    input  wire [31:0] xin       ,//����x
    input  wire [31:0] yin       ,//����y������ȡ��3bit��������õ�booth�����ѡ���ź�
    output wire [15:0] cout      ,//�õ��Ĳ��ֻ�����Ǹ����Ļ�����Ҫ"ȡ����һ"����������ָʾ�Ƿ�"��һ"
    // output wire [31:0] xout[7:0]  //booth�����õ���8�����ֻ�����������
    output wire [63:0] xout0     ,
    output wire [63:0] xout1     ,
    output wire [63:0] xout2     ,
    output wire [63:0] xout3     ,
    output wire [63:0] xout4     ,
    output wire [63:0] xout5     ,
    output wire [63:0] xout6     ,
    output wire [63:0] xout7     ,
    output wire [63:0] xout8     ,
    output wire [63:0] xout9     ,
    output wire [63:0] xout10    ,
    output wire [63:0] xout11    ,
    output wire [63:0] xout12    ,
    output wire [63:0] xout13    ,
    output wire [63:0] xout14    ,
    output wire [63:0] xout15    
    
);
wire [63:0] xout[15:0];
assign xout0 = xout[0];
assign xout1 = xout[1];
assign xout2 = xout[2];
assign xout3 = xout[3];
assign xout4 = xout[4];
assign xout5 = xout[5];
assign xout6 = xout[6];
assign xout7 = xout[7];
assign xout8 = xout[8];
assign xout9 = xout[9];
assign xout10 = xout[10];
assign xout11 = xout[11];
assign xout12 = xout[12];
assign xout13 = xout[13];
assign xout14 = xout[14];
assign xout15 = xout[15];

wire [32:0] yin_t = {yin,1'b0};
wire [32:0] xout_t[15:0];
genvar j;
generate
    for(j=0; j<16; j=j+1)
    begin:booth_decoder_loop
        booth_decoder u_booth_decoder(
        	.xin  (xin  ),
            .yin  (yin_t[(j+1)*2-:3]),
            .xout (xout_t[j]),
            .cout (cout[j] )
        );
        assign xout[j]={{(31-j*2){xout_t[j][32]}},xout_t[j],{(j*2){cout[j]}}};
        // ��λĬ����0�������Ļ�������ȡ��
    end
endgenerate
endmodule
//////////////////////////////////////////////////////////////////////////////////
module wallace_1_16(
    input   [15: 0]    N   ,// N��1bit������ѹ��(ӵ����ͬ��Ȩ��)
    input   [15: 0]    cin ,// �����Ҳ�Ľ�λ(index����ڸ߲�)
    output             C   ,// ���һ�������C
    output             S   ,// ���һ�������S
    output  [15: 0]     cout // ���ݵ����Ľ�λ
);
    // layer 1
    wire [11: 0]    layer_2_in;
    full_adder u_adder_l1_1(.cin(N[15-:3]),.Cout(cout[0]),.S(layer_2_in[11]));
    full_adder u_adder_l1_2(.cin(N[12-:3]),.Cout(cout[1]),.S(layer_2_in[10]));
    full_adder u_adder_l1_3(.cin(N[9-:3]),.Cout(cout[2]),.S(layer_2_in[9]));
    full_adder u_adder_l1_4(.cin(N[6-:3]),.Cout(cout[3]),.S(layer_2_in[8]));
    half_adder u_adder_l1_5(.cin(N[3-:2]),.Cout(cout[4]),.S(layer_2_in[7]));
    half_adder u_adder_l1_6(.cin(N[1-:2]),.Cout(cout[5]),.S(layer_2_in[6]));
    assign layer_2_in[5:0] = cin[5:0];
    
    // layer 2
    wire [7: 0]    layer_3_in;
    full_adder u_adder_l2_1(.cin(layer_2_in[11-:3]),.Cout(cout[6]),.S(layer_3_in[7]));
    full_adder u_adder_l2_2(.cin(layer_2_in[8-:3]),.Cout(cout[7]),.S(layer_3_in[6]));
    full_adder u_adder_l2_3(.cin(layer_2_in[5-:3]),.Cout(cout[8]),.S(layer_3_in[5]));
    full_adder u_adder_l2_4(.cin(layer_2_in[2-:3]),.Cout(cout[9]),.S(layer_3_in[4]));
    assign layer_3_in[3:0] = cin[9:6];

    // layer 3
    wire [5: 0]    layer_4_in;
    full_adder u_adder_l3_1(.cin(layer_3_in[7-:3]),.Cout(cout[10]),.S(layer_4_in[5]));
    full_adder u_adder_l3_2(.cin(layer_3_in[4-:3]),.Cout(cout[11]),.S(layer_4_in[4]));
    half_adder u_adder_l3_3(.cin(layer_3_in[1-:2]),.Cout(cout[12]),.S(layer_4_in[3]));
    assign layer_4_in[2:0] = cin[12:10];

    // layer 4
    wire [3:0]    layer_5_in;
    full_adder u_adder_l4_1(.cin(layer_4_in[5-:3]),.Cout(cout[13]),.S(layer_5_in[3]));
    full_adder u_adder_l4_2(.cin(layer_4_in[2-:3]),.Cout(cout[14]),.S(layer_5_in[2]));
    assign layer_5_in[1:0] = cin[14:13];
    
    // layer 5
    wire [2:0]    layer_6_in;
    full_adder u_adder_l5_1(.cin(layer_5_in[3-:3]),.Cout(cout[15]),.S(layer_6_in[2]));
    assign layer_6_in[1:0] = {layer_5_in[0],cin[15]};

    // layer 6
    full_adder u_adder_l6_1(.cin(layer_6_in[2-:3]),.Cout(C      ),.S(S            ));

endmodule
//////////////////////////////////////////////////////////////////////////////////
module wallace_64_16(
    // input wire [31:0]  xin[7:0] ,//booth�����õ���8�����ֻ�
    input wire [63:0]  xin0     ,
    input wire [63:0]  xin1     ,
    input wire [63:0]  xin2     ,
    input wire [63:0]  xin3     ,
    input wire [63:0]  xin4     ,
    input wire [63:0]  xin5     ,
    input wire [63:0]  xin6     ,
    input wire [63:0]  xin7     ,
    input wire [63:0]  xin8     ,
    input wire [63:0]  xin9     ,
    input wire [63:0]  xin10    ,
    input wire [63:0]  xin11    ,
    input wire [63:0]  xin12    ,
    input wire [63:0]  xin13    ,
    input wire [63:0]  xin14    ,
    input wire [63:0]  xin15    ,
    input wire [15:0]   cin      ,//32λ����wallace�����Ҳ��cin
    output wire [63:0] C        ,//32λ����wallace��������������λC
    output wire [63:0] S        ,//32λ����wallace���������������S
    output wire [15:0]  cout      //32λ����wallace��������cout���������ˣ�û��
);

wire [15:0] c_t[64:0];
assign c_t[0] = cin[15:0];
genvar j;
generate
    for(j=0; j<64; j=j+1)
    begin:wallace_1_16_loop
        wallace_1_16 u_wallace_1_16(
        	.N    ({xin15[j],xin14[j],xin13[j],xin12[j],xin11[j],xin10[j],xin9[j],xin8[j],xin7[j],xin6[j],xin5[j],xin4[j],xin3[j],xin2[j],xin1[j],xin0[j]}),
            .cin  (c_t[j]   ),
            .C    (C[j]     ),
            .S    (S[j]     ),
            .cout (c_t[j+1] )
        );
    end
endgenerate

assign cout = c_t[32];

endmodule
