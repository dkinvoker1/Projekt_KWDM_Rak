function [info, images, spatial] = get_images(dcmaet, dcmaec, peer, port, patient_id, study_uid, series_uid)
images_cmd = ['movescu -aet ' dcmaet ' -aec ' dcmaec  ' -k 0008,0052=SERIES -k 0010,0020="'...
                patient_id '" -k 0020,000D="' study_uid '" -k 0020,000E="' series_uid '" -v '...
                ' --port 10114 ' peer ' ' port];
            
cd  FUN_pacs/images
system(images_cmd);
cd ..
cd ..

[images, spatial, dim] = dicomreadVolume('FUN_pacs/images');

listing = dir('FUN_pacs/images');
info = dicominfo(['FUN_pacs/images/' listing(3).name]);

end