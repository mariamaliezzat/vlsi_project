clear
clc
length = 32;
length_FFE = length;
int_bits = 12;
frac_bits = 0;
total_bits = int_bits + frac_bits;
%random data is in range between -2048 and 2048
data_in = (2*rand(1,length)-1)*2048;
H = [0.5 -0.25 0.15625 -0.0625];
data_out = conv(data_in,H);

%data_out=zeros(1,length);
% for j = 0 : length_FFE - 4
%     data_out(j+1:j+4) = fliplr(data_in(j +1: j+4))*H';
% end


q = quantizer('DataMode', 'fixed', 'Format', [int_bits+frac_bits frac_bits]);
data_in_f = num2bin(q, data_in);
data_out_f = num2bin(q, data_out);

fileID1 = fopen('data_in_ref.txt','w+');
fileID2 = fopen('data_out_ref.txt','w+');
for i = 1 : length
    if i == length
      fprintf(fileID1, '%s', data_in_f(i, :));
      fprintf(fileID2, '%s', data_out_f(i, :));
    else
      fprintf(fileID1, '%s\n', data_in_f(i, :));
      fprintf(fileID2, '%s\n', data_out_f(i, :));
    end
end
fclose(fileID1);
fclose(fileID2);