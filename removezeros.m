function mat=removezeros(mat)
%%Description: remove all zeros rows which show at the beginning of a matrix
% a row is removed if product of current row ==0 and product of previous row ==0
    
%%
mylogic= mat==0 & backshift(1,mat)==0;
mat=mat(sum(mylogic,2)==0,:);
mat=mat(2:end,:);
