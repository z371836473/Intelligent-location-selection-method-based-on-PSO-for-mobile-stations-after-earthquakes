classdef Locating < PROBLEM
    methods
        %% Default settings of the problem
        function Setting(obj)
            [grid_step, ~, ~, row, col, ~, ~, ~, mobile_station_num] = obj.ParameterSet();
            obj.lower = zeros(1, obj.D);
            obj.upper = [ones(1, mobile_station_num) .* row .* grid_step, ones(1, mobile_station_num) .* col .* grid_step];
            obj.encoding = ones(1, obj.D);
        end
        %% Calculate objective values
        function pop_obj = CalObj(obj, pop_dec)
%             [~, main_index, magnitude, row, col, map, fixed_station_num, fixed_station_index, mobile_station_num] = obj.ParameterSet();
            [grid_step, main_index, p, row, col, map, fixed_station_num, fixed_station_index, mobile_station_num] = obj.ParameterSet();
            % 计算间隙角
            if (fixed_station_num == 0)
                fixed_station_index_x = [];
                fixed_station_index_y = [];
            else
                fixed_station_index_x = repmat(fixed_station_index(:, 1)', obj.N, 1);
                fixed_station_index_y = repmat(fixed_station_index(:, 2)', obj.N, 1);
            end
            pop_dec_x = pop_dec(:, 1 : mobile_station_num);
            pop_dec_y = pop_dec(:, mobile_station_num + 1 : end);
            all_station_index_x = [pop_dec_x, fixed_station_index_x];
            all_station_index_y = [pop_dec_y, fixed_station_index_y];
            trans_all_station_index_x = all_station_index_x - main_index(1); % 以震中投影点为中心构建坐标系
            trans_all_station_index_y = all_station_index_y - main_index(2);
            [theta, rho] = cart2pol(trans_all_station_index_x, trans_all_station_index_y); % 转换为极坐标
            theta(theta < 0) = theta(theta < 0) + 2 * pi;
            theta = sort(theta, 2);
            moved_theta = [theta(:, 2 : end), theta(:, 1)];
            diff_theta = moved_theta - theta;
            diff_theta(:, end) = diff_theta(:, end) + 2 * pi;
            gap_angle = max(diff_theta, [], 2) / pi * 180;
            
            % compute f2: the mobiles should be uniformly stated between
            % p(1) to p(2)
            rho = sort(rho, 2);
            p_scattered = linspace(p(1),p(2),mobile_station_num + fixed_station_num);
%             dis = mean(abs(rho - p_scattered),2);
            dis = mean(abs(rho - p_scattered)./p_scattered,2);
            
            pop_obj = [gap_angle, dis];

            % 计算最佳距离
%             a = col * 0.1 / 4 * (1 + magnitude / 10); % 长轴
%             b = row * 0.1 / 4 * (1 + magnitude / 10); % 短轴
%             idea_x = sqrt((a ^ 2 * b ^ 2 .* pop_dec_x .^ 2) ./ (b ^ 2 .* pop_dec_x .^ 2 + pop_dec_y .^ 2 + 1e-6));
%             idea_y = abs(idea_x .* pop_dec_y ./ (pop_dec_x + 1e-6));
%             dis = sum(sqrt((abs(pop_dec_x) - idea_x) .^ 2 + (abs(pop_dec_y) - idea_y) .^ 2), 2);
%             if sum(isnan(dis))
%                 disp(12);
%             end
            % 计算约束
            
        end
        
        %% constraints
        function pop_con = CalCon(obj, pop_dec)
%             [~, main_index, magnitude, row, col, map, fixed_station_num, fixed_station_index, mobile_station_num] = obj.ParameterSet();
            [grid_step, main_index, p, row, col, map, fixed_station_num, fixed_station_index, mobile_station_num] = obj.ParameterSet();
            constraint_point = zeros(obj.N, 1);
            pop_dec_x = pop_dec(:, 1 : mobile_station_num);
            pop_dec_y = pop_dec(:, mobile_station_num + 1 : end);
            for i = 1 : obj.N
                for j = 1 : mobile_station_num
                    row_index = ceil(pop_dec_x(i, j) / grid_step);
                    row_index(row_index == 0) = 1;
                    col_index = ceil(pop_dec_y(i, j) / grid_step);
                    col_index(col_index == 0) = 1;
                    raw_point = map(row_index, col_index);
                    p1 = raw_point / 1000; % 断裂带
                    raw_point = mod(raw_point, 1000);
                    p2 = raw_point / 100; % 不可行区域
                    raw_point = mod(raw_point, 100);
                    p3 = raw_point / 100; % 噪声区域;
                    raw_point = mod(raw_point, 10);
                    p4 = raw_point; % 基岩
                    constraint_point(i) = constraint_point(i) + p1 * 10000 + p2 * 10000 + p3 * 10000 + mod(p4 + 1, 2);
                end
            end
            pop_con =  constraint_point;
%             pop_con = zeros(obj.N, 1);
        end
    end
end