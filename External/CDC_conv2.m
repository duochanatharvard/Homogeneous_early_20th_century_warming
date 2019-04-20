% output = CDC_conv2(input_x,input_y)
%
% CDC_conv2 does 2D convolution and can handle NaN values
% 
% Note that this function is only for CDF_smooth2 to use
% and did not normalize the outputs
% 
% Last update: 2018-08-09
 
function output = CDC_conv2(input_x,input_y)
 
    input_x(isnan(input_x)) = 0;
    input_y(isnan(input_y)) = 0;
 
    output = conv2(input_x,input_y); 
end

