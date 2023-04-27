function site_selection(parameter_str, file_dir)
    parameter_str = string(parameter_str);
    splited_str = strsplit(parameter_str, ";");
    splited_temp_str = strsplit(splited_str(1), ",");
    grid_step = double(splited_temp_str(1)); % grid_step refers to the size of grid
    p = [double(splited_temp_str(2))/2, double(splited_temp_str(3))]; % p refers to the lower and upper distance for mobile sites
%     origin_index = [double(splited_temp_str(1)), double(splited_temp_str(2))]; % æ ¼å­åŽŸç‚¹åæ ‡
    splited_temp_str = strsplit(splited_str(2), ",");
    main_index = [double(splited_temp_str(2)), double(splited_temp_str(1))]; % (switch the row and colum) the relative coordinate of the main earthquake
%     main_index = abs(main_index - origin_index);
%     main_index = main_index(1,end:-1:1);
%     magnitude = double(splited_temp_str(3)); % ä¸»éœ‡éœ‡çº§
    row = double(splited_str(3)); % è¢«åˆ†å‰²çš„å¯è¡ŒåŒºåŸŸçš„è¡Œæ•?
    col = double(splited_str(4)); % è¢«åˆ†å‰²çš„å¯è¡ŒåŒºåŸŸçš„åˆ—æ•?
    map = zeros(row, col); % å¯è¡ŒåŒºåŸŸçŸ©é˜µ
    for i = 1 : row * col
        splited_temp_str = strsplit(splited_str(4 + i), ",");
        temp_row = double(splited_temp_str(1));
        temp_col = double(splited_temp_str(2));
        temp_val = double(splited_temp_str(3));
        map(temp_row, temp_col) = temp_val;
    end
    fixed_station_num = double(splited_str(5 + row * col)); % å›ºå®šå°ç«™ä¸ªæ•°
    fixed_station_index = zeros(fixed_station_num, 2); % å›ºå®šå°ç«™åæ ‡
    for i = 1 : fixed_station_num
        splited_temp_str = strsplit(splited_str(5 + row * col + i), ",");
        temp_x = double(splited_temp_str(1));
        temp_y = double(splited_temp_str(2));
        fixed_station_index(i, 2) = temp_x; % (switch the row and colum)
        fixed_station_index(i, 1) = temp_y;
    end
    mobile_station_num = double(splited_str(6 + row * col + fixed_station_num)); % æµåŠ¨å°ç«™ä¸ªæ•°
%     [dec, obj] = platemo('algorithm', @SMPSO, 'problem', {@Locating, origin_index, main_index, magnitude, row, col, map, fixed_station_num, fixed_station_index, mobile_station_num}, 'N', 200, 'M', 2, 'D', 2 * mobile_station_num, 'maxFE', 400000);
    [dec, obj, con] = platemo('algorithm', @SMPSO, 'problem', {@Locating, grid_step, main_index, p, row, col, map, fixed_station_num, fixed_station_index, mobile_station_num}, 'N', 200, 'M', 2, 'D', 2 * mobile_station_num, 'maxFE', 1000000);
    
    %% unique dec and obj
    [~, index] = unique(obj, "rows"); % åŽ»é‡å¹¶æŽ’åº?
    obj = obj(index, :);
    dec = dec(index, :);

    %% deal obj_2
    % ¼ÆËã¼äÏ¶½Ç
%     if (fixed_station_num == 0)
%         fixed_station_index_x = [];
%         fixed_station_index_y = [];
%     else
%         fixed_station_index_x = repmat(fixed_station_index(:, 1)', 200, 1);
%         fixed_station_index_y = repmat(fixed_station_index(:, 2)', 200, 1);
%     end
%     pop_dec_x = dec(:, 1 : mobile_station_num);
%     pop_dec_y = dec(:, mobile_station_num + 1 : end);
%     all_station_index_x = [pop_dec_x, fixed_station_index_x];
%     all_station_index_y = [pop_dec_y, fixed_station_index_y];
%     trans_all_station_index_x = all_station_index_x - main_index(1); % ÒÔÕðÖÐÍ¶Ó°µãÎªÖÐÐÄ¹¹½¨×ø±êÏµ
%     trans_all_station_index_y = all_station_index_y - main_index(2);
%     [~, rho] = cart2pol(trans_all_station_index_x, trans_all_station_index_y); % ×ª»»Îª¼«×ø±ê
%     rho = sort(rho, 2);
%     p_scattered = linspace(p(1),p(2),mobile_station_num + fixed_station_num);
%     dis = mean(abs(rho - p_scattered)./p_scattered,2);
%     obj(:,2) = dis;
    
    %% change the structure of dec for outputting
    temp_dec = zeros(size(dec));
    temp_dec(:, 1 : 2 : end) = dec(:, 1 : mobile_station_num);
    temp_dec(:, 2 : 2 : end) = dec(:, mobile_station_num + 1 : end);
    dec = temp_dec;
    dec_backup = dec;
    obj_backup = obj;
    if size(dec_backup, 1) > 3
%         dec = dec_backup([1, ceil(size(dec_backup, 1) / 20), ceil(size(dec_backup, 1) * 1 / 5)], :);
%         obj = obj_backup([1, ceil(size(obj_backup, 1) / 20), ceil(size(obj_backup, 1) * 1 / 5)], :);
        dec = dec_backup([1, 100, 200], :);
        obj = obj_backup([1, 100, 200], :);
    end
    result_num = size(dec, 1);
    %% create output
    %     result_str = num2str(result_num) + ";";
    
    for i = 1 : result_num
        result_str(i,:) = ";";
%         for j = 1 : mobile_station_num-1
%             result_str(i,:) = result_str(i,:) + num2str(dec(i, 2 * j - 1)) + "," + num2str(dec(i, 2 * j)) + ";";
%         end
%         for j = mobile_station_num
%             result_str(i,:) = result_str(i,:) + num2str(dec(i, 2 * j - 1)) + "," + num2str(dec(i, 2 * j)) + ",";
%         end
        for j = 1 : mobile_station_num-1
            result_str(i,:) = result_str(i,:) + num2str(dec(i, 2 * j)) + "," + num2str(dec(i, 2 * j - 1)) + ";";
        end
        for j = mobile_station_num
            result_str(i,:) = result_str(i,:) + num2str(dec(i, 2 * j)) + "," + num2str(dec(i, 2 * j - 1)) + ",";
        end
        result_str(i,:) = result_str(i,:) + num2str(obj(i, 1)) + "," + num2str(obj(i, 2)*100) + ";";
        temp = char(result_str(i,:));
        result_str(i,:) = string(temp(1,2:end));
    end
    writematrix(result_str,file_dir)
    %%
%     figure
%     for k = 1:3
%         subplot(1, 3, k);
%         plot(main_index(1), main_index(2), 'o');
%         hold on
%         for i = 1 : mobile_station_num
%             plot(dec(k, i * 2 - 1), dec(k, i * 2), '*');
%             hold on;
%         end
%         for i = 1 : fixed_station_num
%             plot(fixed_station_index(i, 1), fixed_station_index(i, 2), '+');
%             hold on;
%         end
%     end
%     
%     figure
%     scatter(obj_backup(:,1), obj_backup(:,2))

end