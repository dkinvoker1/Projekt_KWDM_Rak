function [studies_list] = get_studies(dcmaet, dcmaec, peer, port, patient_id)
study_cmd = ['findscu -aet ' dcmaet ' -aec ' dcmaec  ' --study -k 0008,0052=STUDY -k 0010,0020="'...
                patient_id '" -k 0020,000D -v '  peer ' ' port];
            
[sys_status, patients_txt] = system(study_cmd);      
            
studies_txt = regexp(patients_txt, '\(0008,0052\)', 'split');
studies = studies_txt(3:end);

studies_list = [];

for i = 1:length(studies)
    study_txt =  regexp(studies{i}, 'W:', 'split');
    
    [s_ind, e_ind] = regexp(study_txt{4}, '\[.+\]');
    study_id = study_txt{4}(s_ind+1:e_ind-1);
    
%      [s_ind, e_ind] = regexp(patient_txt{4}, '\[.+\]');
%     patient_id = patient_txt{4}(s_ind+1:e_ind-1);
    
    
    studies_list{i} = struct('StudyUID', study_id);
end
end