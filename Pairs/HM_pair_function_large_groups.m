% When do_rmsml == 1, ony returns the large groups
%   large groups are defined as: for pairs that are picked out by distance without removing
%   any dupicates, small nations, each group should contribute to more than 200,000 for Bucket SST
%   pairs to the summed dataset.
%
% When do_rmsml == 0, returns standard groups for LME analysis
%   standard is defined as: for pairs that are picked out by distance without removing
%   any dupicates, small nations, each of the included group should contribute to more than 5,000
%   pairs throughout 1850-2014.
function list_large_group = HM_pair_function_large_groups(do_NpD,varname,method,do_rmsml)

    if do_rmsml == 1,
    % Large groups

        if do_NpD == 0,
            % Nation Level

            if strcmp(varname,'SST') && strcmp(method,'Bucket'),
                % Large groups - Nation Level - Bucket SST
                list_large_group = [    67    65
                                        68    69
                                        70    82
                                        71    66
                                        74    80
                                        78    76
                                        82    85
                                        85    83
                                       155   155
                                       156   156];
            end

        elseif do_NpD == 1,
            % Deck Level

            if strcmp(varname,'SST') && strcmp(method,'Bucket'),
                % Large groups - Deck Level - Bucket SST
                list_large_group = [    68    69   192
                                        68    69   215
                                        68    69   720
                                        68    69   926
                                        68    69   927
                                        70    82   927
                                        71    66   184
                                        71    66   201
                                        71    66   202
                                        71    66   203
                                        71    66   230
                                        71    66   706
                                        71    66   926
                                        71    66   927
                                        74    80   118
                                        74    80   762
                                        74    80   927
                                        78    76   193
                                        78    76   926
                                        78    76   927
                                        82    85   555
                                        82    85   732
                                        82    85   735
                                        82    85   888
                                        82    85   926
                                        82    85   927
                                        85    83   706
                                        85    83   927
                                       155   155   155
                                       156   156   156];
            end
        end

    elseif do_rmsml == 0,
    % Standard groups

        if do_NpD == 0,
            % Nation Level

            if strcmp(varname,'SST') && strcmp(method,'Bucket'),
                % Standard groups - Nation Level - Bucket SST
                list_large_group = [    65    82
                                        65    85
                                        66    69
                                        66    82
                                        66    88
                                        67    65
                                        67    78
                                        68    69
                                        68    75
                                        68    76
                                        68    78
                                        69    69
                                        69    83
                                        70    82
                                        71    66
                                        72    75
                                        72    79
                                        72    82
                                        73    69
                                        73    76
                                        73    78
                                        73    83
                                        73    89
                                        74    80
                                        76    82
                                        77    75
                                        77    89
                                        78    76
                                        78    79
                                        78    90
                                        80    65
                                        80    76
                                        80    77
                                        80    84
                                        82    85
                                        83    69
                                        83    71
                                        83    80
                                        84    72
                                        85    65
                                        85    83
                                        90    65
                                       155   155
                                       156   156
                                       197   197
                                       203   203
                                       255   255
                                       792   792
                                       888   888
                                       926   926
                                       927   927
                                       992   992];
            end

        elseif do_NpD == 1,
            % Deck Level

            if strcmp(varname,'SST') && strcmp(method,'Bucket'),
                  % Standard groups - Deck Level - Bucket SST
                  list_large_group = [      65    82   927
                                            65    85   900
                                            66    69   792
                                            66    69   888
                                            66    69   926
                                            66    69   927
                                            66    82   926
                                            66    88   706
                                            67    65   792
                                            67    65   888
                                            67    65   926
                                            67    65   927
                                            67    65   992
                                            67    78   706
                                            67    78   781
                                            67    78   792
                                            68    69   151
                                            68    69   192
                                            68    69   215
                                            68    69   555
                                            68    69   720
                                            68    69   721
                                            68    69   792
                                            68    69   888
                                            68    69   926
                                            68    69   927
                                            68    69   992
                                            68    75   792
                                            68    75   888
                                            68    75   926
                                            68    75   927
                                            68    76   706
                                            68    78   706
                                            69    69   555
                                            69    69   792
                                            69    69   888
                                            69    83   927
                                            70    82   706
                                            70    82   792
                                            70    82   888
                                            70    82   926
                                            70    82   927
                                            71    66   152
                                            71    66   184
                                            71    66   201
                                            71    66   202
                                            71    66   203
                                            71    66   204
                                            71    66   205
                                            71    66   221
                                            71    66   230
                                            71    66   245
                                            71    66   249
                                            71    66   555
                                            71    66   705
                                            71    66   706
                                            71    66   707
                                            71    66   792
                                            71    66   849
                                            71    66   888
                                            71    66   926
                                            71    66   927
                                            71    66   992
                                            72    75   926
                                            72    75   927
                                            72    79   705
                                            72    79   706
                                            72    79   707
                                            72    82   926
                                            73    69   926
                                            73    69   927
                                            73    76   926
                                            73    76   927
                                            73    78   926
                                            73    78   927
                                            73    83   926
                                            73    83   927
                                            73    89   706
                                            74    80   118
                                            74    80   119
                                            74    80   555
                                            74    80   705
                                            74    80   706
                                            74    80   762
                                            74    80   792
                                            74    80   888
                                            74    80   898
                                            74    80   926
                                            74    80   927
                                            76    82   792
                                            76    82   888
                                            77    75   927
                                            77    89   792
                                            77    89   927
                                            78    76   150
                                            78    76   193
                                            78    76   555
                                            78    76   705
                                            78    76   706
                                            78    76   792
                                            78    76   888
                                            78    76   926
                                            78    76   927
                                            78    76   992
                                            78    79   700
                                            78    79   702
                                            78    79   706
                                            78    79   792
                                            78    79   888
                                            78    79   926
                                            78    79   927
                                            78    79   992
                                            78    90   926
                                            78    90   927
                                            80    65   792
                                            80    65   992
                                            80    76   926
                                            80    76   927
                                            80    77   707
                                            80    84   926
                                            80    84   927
                                            82    85   185
                                            82    85   555
                                            82    85   732
                                            82    85   735
                                            82    85   792
                                            82    85   849
                                            82    85   888
                                            82    85   926
                                            82    85   927
                                            83    69   926
                                            83    69   927
                                            83    71   792
                                            83    71   888
                                            83    71   926
                                            83    71   927
                                            83    80   706
                                            85    65   555
                                            85    65   792
                                            85    65   888
                                            85    83   116
                                            85    83   281
                                            85    83   555
                                            85    83   701
                                            85    83   704
                                            85    83   705
                                            85    83   706
                                            85    83   707
                                            85    83   710
                                            85    83   792
                                            85    83   926
                                            85    83   927
                                            90    65   888
                                            90    65   927
                                           155   155   155
                                           156   156   156
                                           197   197   197
                                           203   203   203
                                           255   255   255
                                           792   792   792
                                           888   888   888
                                           926   926   926
                                           927   927   927
                                           992   992   992];
            end
        end
    end
end
