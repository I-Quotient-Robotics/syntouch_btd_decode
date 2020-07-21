file = fopen('data.btd');

% key to data structure: 
% timestamp batch_index frame_list channel_id 
% biotac_1_value biotac_1_parity biotac_2_value biotac_2_parity biotac_3_value biotac_3_parity
cells = textscan(file, '%f %f %f %f %f %f %f %f %f %f', 'headerlines', 13);
data = cell2mat(cells);

% get raw data
e_raw_data = data(data(:,4)>15,:);
pac_raw_data = data(data(:,4)==0,:);
pdc_raw_data = data(data(:,4)==1,:);
tac_raw_data = data(data(:,4)==2,:);
tdc_raw_data = data(data(:,4)==3,:);

% impedance data (mV)
e_data = e_raw_data;
e_data(:,9) = (4095.0 ./ e_data(:,9) - 1.0) * 10000.0;

% microvibration data (Pa)
pac_data = pac_raw_data;
pac_data(:,9) = (pac_data(:,9)-pac_data(1,9)) * 0.37;

% fluid pressure (kPa)
pdc_data = pdc_raw_data;
pdc_data(:,9) = (pdc_data(:,9)-pdc_data(1,9)) * 0.0365;

% thermal flux (°C/s)
tac_data = tac_raw_data;
tac_data(:,9) = -41.07 ./ log((155183-46555*tac_data(:,9) / 4095.0) ./ (tac_data(:,9) / 4095.0));

% temperature (°C)
tdc_data = tdc_raw_data;
tdc_data(:,9) = 4025.0 ./ log((155183-46555*tdc_data(:,9) / 4095.0) ./ (tdc_data(:,9) / 4095.0)) - 273.15;

frame_list = unique(data(:,3));
raw_data_sets = zeros(length(frame_list), 47);
for row = 1 : length(frame_list)
  frame_id = frame_list(row);
  raw_data_sets(row,1) = data(find(data(:,3)==frame_id,1),1);
  raw_data_sets(row,2) = data(find(data(:,3)==frame_id,1),2);
  raw_data_sets(row,3) = frame_id;
  raw_data_sets(row,4) = pdc_raw_data(pdc_raw_data(:,3)==frame_id,9);
  raw_data_sets(row,5) = tac_raw_data(tac_raw_data(:,3)==frame_id,9);
  raw_data_sets(row,6) = tdc_raw_data(tdc_raw_data(:,3)==frame_id,9);
  temp_sets = e_raw_data(e_raw_data(:,3)==frame_id,:)';
  raw_data_sets(row,7:25) = temp_sets(9,:);
  temp_sets = pac_raw_data(pac_raw_data(:,3)==frame_id,:)';
  raw_data_sets(row,26:47) = temp_sets(9,:);
end

data_sets = zeros(length(frame_list), 47);
for row = 1 : length(frame_list)
  frame_id = frame_list(row);
  data_sets(row,1) = data(find(data(:,3)==frame_id,1),1);
  data_sets(row,2) = data(find(data(:,3)==frame_id,1),2);
  data_sets(row,3) = frame_id;
  data_sets(row,4) = pdc_data(pdc_data(:,3)==frame_id,9);
  data_sets(row,5) = tac_data(tac_data(:,3)==frame_id,9);
  data_sets(row,6) = tdc_data(tdc_data(:,3)==frame_id,9);
  temp_sets = e_data(e_data(:,3)==frame_id,:)';
  data_sets(row,7:25) = temp_sets(9,:);
  temp_sets = pac_data(pac_data(:,3)==frame_id,:)';
  data_sets(row,26:47) = temp_sets(9,:);
end

% generate raw data table
raw_data_table = array2table(raw_data_sets);
raw_data_table.Properties.VariableNames(1:3) = {'timestamp', 'batch_index', 'frame_index'};
raw_data_table.Properties.VariableNames(4:6) = {'pdc', 'tac', 'tdc'};
raw_data_table.Properties.VariableNames(7:13) = {'e_1', 'e_2', 'e_3', 'e_4', 'e_5', 'e_6', 'e_7'};
raw_data_table.Properties.VariableNames(14:20) = {'e_8', 'e_9', 'e_10', 'e_11', 'e_12', 'e_13', 'e_14'};
raw_data_table.Properties.VariableNames(21:25) = {'e_15', 'e_16', 'e_17', 'e_18', 'e_19'};
raw_data_table.Properties.VariableNames(26:32) = {'pac_1', 'pac_2', 'pac_3', 'pac_4', 'pac_5', 'pac_6', 'pac_7'};
raw_data_table.Properties.VariableNames(33:39) = {'pac_8', 'pac_9', 'pac_10', 'pac_11', 'pac_12', 'pac_13', 'pac_14'};
raw_data_table.Properties.VariableNames(40:47) = {'pac_15', 'pac_16', 'pac_17', 'pac_18', 'pac_19', 'pac_20', 'pac_21', 'pac_22'};

% generate data table
data_table = array2table(data_sets);
data_table.Properties.VariableNames(1:3) = {'timestamp', 'batch_index', 'frame_index'};
data_table.Properties.VariableNames(4:6) = {'pdc', 'tac', 'tdc'};
data_table.Properties.VariableNames(7:13) = {'e_1', 'e_2', 'e_3', 'e_4', 'e_5', 'e_6', 'e_7'};
data_table.Properties.VariableNames(14:20) = {'e_8', 'e_9', 'e_10', 'e_11', 'e_12', 'e_13', 'e_14'};
data_table.Properties.VariableNames(21:25) = {'e_15', 'e_16', 'e_17', 'e_18', 'e_19'};
data_table.Properties.VariableNames(26:32) = {'pac_1', 'pac_2', 'pac_3', 'pac_4', 'pac_5', 'pac_6', 'pac_7'};
data_table.Properties.VariableNames(33:39) = {'pac_8', 'pac_9', 'pac_10', 'pac_11', 'pac_12', 'pac_13', 'pac_14'};
data_table.Properties.VariableNames(40:47) = {'pac_15', 'pac_16', 'pac_17', 'pac_18', 'pac_19', 'pac_20', 'pac_21', 'pac_22'};

subplot(4,1,1)
plot(pac_data(:,1), pac_data(:,9));
xlabel('Time(Second)')
ylabel('PAC(Pa)')

subplot(4,1,2)
plot(pdc_data(:,1), pdc_data(:,9));
xlabel('Time(Second)')
ylabel('PDC(kPa)')

subplot(4,1,3)
plot(tac_data(:,1), tac_data(:,9));
xlabel('Time(Second)')
ylabel('TAC(°C/s)')

subplot(4,1,4)
plot(tdc_data(:,1), tdc_data(:,9));
xlabel('Time(Second)')
ylabel('TDC(°C)')

% raw_data_table: 以帧为单位的完整数据表，时间戳采用每帧收到的第一个数据的时间戳，所有数值都为传感器返回的原始值
% pac_raw_data: 微振动数据，单位Pa
% pdc_raw_data: 液体压力数据，单位kPa
% tac_raw_data: 热通量数据，单位°C/s
% tdc_raw_data: 温度数据，单位°C

% data_table: 以帧为单位的完整数据表，时间戳采用每帧收到的第一个数据的时间戳，所有数值都转换为物理单位
% pac_data: 微振动原始数据，无单位
% pdc_data: 液体压力原始数据，无单位
% tac_data: 热通量原始数据，无单位
% tdc_data: 温度数据，无单位
