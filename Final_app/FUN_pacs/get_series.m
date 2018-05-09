function [series_list] = get_series(dcmaet, dcmaec, peer, port, patient_id, study_uid)
series_cmd = ['findscu -aet ' dcmaet ' -aec ' dcmaec  ' --study  -k 0008,0052=SERIES -k 0010,0020="'...
                patient_id '" -k 0020,000D="' study_uid '" -k 0020,000E -v '  peer ' ' port];
           
[sys_status, patients_txt] = system(series_cmd);      
            
series_txt = regexp(patients_txt, '\(0008,0052\)', 'split');
series = series_txt(3:end);

series_list = [];

for i = 1:length(series)
    study_txt =  regexp(series{i}, 'W:', 'split');
    
    [s_ind, e_ind] = regexp(study_txt{5}, '\[.+\]');
    series_id = study_txt{5}(s_ind+1:e_ind-1);
   
    series_list{i} = struct('SeriesUID', series_id);
end
end