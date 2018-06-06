function [patient_list] = get_patients(dcmaet, dcmaec, peer, port)
patients_cmd = ['findscu -aet ' dcmaet ' -aec ' dcmaec  ' --patient -k 0008,0052=PATIENT -k 0010,0010 -k 0010,0020 -v ' ...
                peer ' ' port];
            
[sys_status, patients_txt] = system(patients_cmd);      
            
patients_split = regexp(patients_txt, '\(0008,0052\)', 'split');
patients = patients_split(3:end);

patient_list = [];

for i = 1:length(patients)
    patient_txt =  regexp(patients{i}, 'W:', 'split');
    
    [s_ind, e_ind] = regexp(patient_txt{3}, '\[.+\]');
    patient_name = patient_txt{3}(s_ind+1:e_ind-1);
    
     [s_ind, e_ind] = regexp(patient_txt{4}, '\[.+\]');
    patient_id = patient_txt{4}(s_ind+1:e_ind-1);
    
    
    patient_list{i} = struct('PatientName', patient_name, 'PatientId', patient_id);
end
end

