datapath=uigetdir([],'Select Data Directory'); 
d=dir(fullfile(datapath,'*.mat'));

for i=1:numel(d)
  txt_file = fullfile(datapath,d(i).name);
  img=load(txt_file);
  img=img.imgdist;
  detectEdge(img)
  [~,~,c]=ginput(1);
  while c~='n'
        [~,~,c]=ginput(1);
  end
end