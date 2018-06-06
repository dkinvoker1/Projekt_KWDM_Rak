function send_mask(dcmaet, dcmaec, peer, port, patient_id, study_uid)
send_cmd = ['storescu +sd -aet ' dcmaet ' -aec ' dcmaec  ' '  peer ' ' port ' Results'];

[sys_status, patients_txt] = system(send_cmd);

clear_results();
end

