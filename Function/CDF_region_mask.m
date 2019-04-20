% mask_region = CDF_region_mask

function mask_region = CDF_region_mask

a1 = [
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
    16   NaN   NaN   NaN    16   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16
    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    12    12    12    12    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13
    12    12    12    12    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13
    12    12    12    12   NaN   NaN    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13   NaN
    12    12    12   NaN   NaN   NaN   NaN    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13    13
     7     7     7   NaN   NaN   NaN   NaN    11    11    11    11    11    11    11    11    11    11    11    11    11    11    11     8     8
     7     7     7   NaN   NaN   NaN   NaN   NaN    11    11    11    11    11    11    11    11    11    11    11    11    11    11     8     8
     7     7     7   NaN   NaN   NaN   NaN    11    11    11    11    11    11    11    11    11    11    11    11    11    11    11     8     8
     7     7     7   NaN   NaN   NaN   NaN    11    11    11    11    11    11    11    11    11    11    11    11    11    11    11     8     8
     7     7   NaN   NaN   NaN   NaN   NaN   NaN    11    11    11    11    11    11    11    11    11    11    11    11    11    11     8     8
     7   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN    11    11    11    11    11    11    11    11    11    11    11    11    11     8     8
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN    11    11    11    11    11    11    11    11    11    11    11    11    11    11     8     8
   NaN   NaN   NaN   NaN   NaN   NaN   NaN    11    11   NaN    11    11    11    11    11   NaN    11    11    11   NaN   NaN    11     8     8
   NaN   NaN   NaN   NaN   NaN   NaN   NaN    11   NaN   NaN   NaN    11    11    11    11   NaN   NaN    11    11   NaN   NaN    11     2     2
   NaN   NaN   NaN   NaN   NaN   NaN     6    11   NaN    11    11    11   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN     6     6     6     6     6     6   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
     6     6     6     6     6     6     6     6   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     2
     6     6     6     6     6     6     6     6   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN     6   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
     4     4     4     4   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
     4     4     4     4   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
    17    17    17    17    17   NaN    17   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
    17    17    17    17    17   NaN    17    17    17    17    17    17   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17   NaN   NaN   NaN   NaN   NaN   NaN   NaN    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17];

a2 = [        
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN    16    16    16    16    16    16    16    16    16    16    16    16   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16
    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16
    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    13    13    13    13    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14
    13    13    13   NaN   NaN   NaN    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14
   NaN   NaN   NaN   NaN   NaN   NaN    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14
   NaN   NaN   NaN   NaN   NaN   NaN    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14    14
     8   NaN   NaN     8     8     8     8     8     9     9     9     9     9     9     9     9     9     9     9     9    10    10    10    10
     8     8     8     8     8     8     8     8     9     9     9     9     9     9     9     9     9     9     9     9    10    10    10    10
     8     8     8     8     8     8     8     8     9     9     9     9     9     9     9     9     9     9     9     9    10    10    10    10
     8     8     8     8     8     8     8     8     9     9     9     9     9     9     9     9     9     9     9     9    10    10    10    10
     8     8     8     8     8     8     8     8     9     9     9     9     9     9     9     9     9     9     9     9    10    10    10    10
     8     8     8     8     8     8     8     8     9     9     9     9     9     9     9     9     9     9     9     9    10    10    10    10
     8     8     8     8     8     8     8     8     9     9     9     9     9     9     9     9     9     9     9     9    10    10    10    10
     8     8     8     8     8     8     8     8     9     9     9     9     9     9     9     9     9     9     9     9    10    10    10    10
     2     2     2     2     2     2     2     2     2     2     2     2     3     3     3     3     3     3     3     3     3     3     3     3
     2     2     2     2     2     2     2     2     2     2     2     2     3     3     3     3     3     3     3     3     3     3     3     3
     2     2     2     2     2     2     2     2     2     2     2     2     3     3     3     3     3     3     3     3     3     3     3     3
     2     2     2     2     2     2     2     2     2     2     2     2     3     3     3     3     3     3     3     3     3     3     3     3
   NaN     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5
   NaN   NaN   NaN     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5
   NaN   NaN   NaN     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5   NaN
   NaN   NaN   NaN     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5     5   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN    17    17   NaN    17    17    17    17    17   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN    17    17    17    17   NaN   NaN   NaN   NaN    17   NaN   NaN   NaN
    17    17    17    17   NaN   NaN    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17];

a3 = [
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN    16    16    16    16    16    16    16    16    16   NaN   NaN   NaN   NaN
    16    16    16    16    16    16    16    16    16    16   NaN    16    16    16    16    16    16    16    16    16    16    16    16    16
    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16
    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16    16
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15   NaN    15    15    15    15    15    15    15    15    15    15    15    15    15    15
    15    15    15    15    15    15    15    15    15    15   NaN    15    15    15    15    15    15    15    15    15    15    15    15    15
    14    14    14    14    14    14    14    14    14    14   NaN    14    12    12    12    12    12    12    12    12    12    12    12    12
    14    14    14    14    14    14    14    14    14    14   NaN   NaN   NaN    12    12    12    12    12    12    12    12    12    12    12
    14    14    14    14    14    14    14    14    14    14   NaN   NaN   NaN   NaN    12    12    12    12    12    12    12    12    12    12
    14    14    14    14    14    14    14    14    14    14   NaN   NaN   NaN   NaN    12    12    12    12    12    12    12    12    12    12
    10    10    10    10    10    10    10    10    10    10   NaN   NaN   NaN   NaN   NaN   NaN     7     7     7     7     7     7     7     7
    10    10    10    10    10    10    10    10    10   NaN   NaN   NaN   NaN   NaN   NaN   NaN     7     7     7     7     7     7     7     7
    10    10    10    10    10    10    10    10    10   NaN   NaN   NaN   NaN   NaN   NaN   NaN     7     7     7     7     7     7     7     7
    10    10    10    10    10    10    10    10   NaN   NaN   NaN   NaN   NaN   NaN     7     7     7     7     7     7     7     7     7     7
    10    10    10    10    10    10    10    10    10   NaN   NaN   NaN   NaN     7     7     7     7     7     7     7     7     7     7     7
    10    10    10    10    10    10    10    10    10   NaN   NaN     7     7     7     7     7     7     7     7     7     7     7     7   NaN
    10    10    10    10    10    10     7     7     7     7     7     7     7     7     7     7     7     7     7     7     7   NaN   NaN   NaN
    10    10    10    10    10    10     7     7     7     7     7     7     7     7     7     7     7     7     7     7     7   NaN   NaN   NaN
     3     3     3   NaN     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1   NaN   NaN   NaN
     3     3     3   NaN     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1   NaN   NaN
     3     3   NaN   NaN   NaN   NaN   NaN     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1   NaN
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1     1
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     4     4     4     4     4     4     4     4     4     4     4     4     4     4     4
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     4     4     4     4     4     4     4     4     4     4     4     4     4     4
   NaN   NaN   NaN   NaN   NaN   NaN   NaN     4     4   NaN   NaN   NaN     4     4     4     4     4     4     4     4     4     4     4     4
   NaN   NaN   NaN   NaN   NaN     4     4     4     4   NaN     4     4     4     4     4     4     4     4     4     4     4     4     4     4
   NaN   NaN   NaN   NaN   NaN    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17
    17    17    17    17    17    17    17    17    17   NaN    17    17    17    17   NaN   NaN    17    17    17    17    17    17    17    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17   NaN   NaN   NaN   NaN   NaN    17    17    17    17    17
    17    17    17    17    17    17    17   NaN    17    17    17    17    17   NaN   NaN   NaN   NaN   NaN   NaN   NaN    17    17    17    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17
    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17    17];

mask_region = [a1 a2 a3];

end