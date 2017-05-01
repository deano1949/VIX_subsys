function dm = diversify_multiplier(correl,w)
%DIVERSIFY_MULTIPLIER: calculate diversified muliplier (works for between strategies as well as subsystems.
% correl: correlation
% w: optimal weights
% dm: diversified multiplier
dm=1/sqrt(w*correl*w');

if dm > 2.5
    dm=2.5;
end

end

