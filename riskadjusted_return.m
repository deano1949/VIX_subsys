function mat = riskadjusted_return(mat,vol_target)
%RISKADJUSTED_RETURN calculates volatility-adjusted returns
%Input:   mat: matrix of raw returns
%         vol_target: target volatility
%Output:  mat: volatility_adjusted returns

vol=ones(size(mat,1),1)*std(mat);
tar_vol=ones(size(mat))*vol_target;

mat=mat./vol.*tar_vol;

end

