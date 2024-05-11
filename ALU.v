`include "Parameters.v"   

//ALU��������������������AluType�Ĳ�ͬ�����в�ͬ�ļ��߼����������AluOutΪ����ļ�����
module ALU(
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,
    input wire [3:0] AluType,
    output reg [31:0] AluOut
    );
	always@(*)
		case (AluType)
			`ADD: AluOut = Operand1 + Operand2;
			`SUB: AluOut = Operand1 - Operand2;
			`AND: AluOut = Operand1 & Operand2;
			`OR : AluOut = Operand1 | Operand2;
			`XOR: AluOut = Operand1 ^ Operand2;
			`SLT: begin
					if(Operand1[31] == Operand2[31]) 
					AluOut = (Operand1 < Operand2) ? 32'b1 : 32'b0;
					else 
					AluOut = (Operand1[31] < Operand2[31]) ? 32'b0 : 32'b1;//��������ֱ�ӱȽϷ���
                  end
			`SLTU: AluOut = (Operand1 < Operand2) ? 32'b1 : 32'b0;
			`SLL: AluOut = Operand1 << Operand2[4:0];
			`SRL: AluOut = Operand1 >> Operand2[4:0];
			`SRA: AluOut = $signed(Operand1) >>> Operand2[4:0];
			//ʹ��>>>Ϊ�������ƣ���λ�����ţ��޷�����Ҳ�����߼�����
			`LUI: AluOut = Operand2;
			default: AluOut = 32'h0;
		endcase
endmodule


