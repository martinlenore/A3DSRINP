  setBatchMode(true);
  run("Image Sequence...", "convert_to_rgb sort use");
  end_dir=getDirectory("Choose a Directory");
  stack1 = getImageID;
  stack2 = 0;
  angles=newArray(0,90,180,270);
  devs=newArray(-5,0,5);
  g_n=newArray(0,25,50);
  for (fn=0;fn<g_n.length;fn++){
    dname=end_dir+"gsn_"+g_n[fn];
    if (File.isDirectory(dname)==0) {
      File.makeDirectory(dname)
    }
    dname_plain=dname+"\\plain";
    if (File.isDirectory(dname_plain)==0) {
      File.makeDirectory(dname_plain)
    }
    dname_sandp=dname+"\\sandp";
    if (File.isDirectory(dname_sandp)==0) {
      File.makeDirectory(dname_sandp)
    }
  }
  selectImage(stack1);
  n = angles.length;
  ay=0;
  dy=0;
  for (i=0; i<n; i++) {
    showProgress(i, n);
    ax=angles[i];
    for (k=0;k<n;k++){
      az=angles[k];
      for (x=0;x<devs.length;x++){
        dx=devs[x];
        for (z=0;z<devs.length;z++){
          dz=devs[z];
          selectImage(stack1);
          run("Volume Viewer", "display_mode=5 scale=2.5 axes=0 interpolation=4 angle_x="+(360+ax+dx)%360 +" angle_y="+((360+ay+dy)%360)+" angle_z="+(360+(az+dz)%360)+" bg_r=255 bg_g=255 bg_b=255" );
          run("Copy");
          w=getWidth; h=getHeight;
          close();
          thisname="Plots_"+((360+ax+dx)%360)+"_"+((360+az+dz)%360)+".png";
          newImage(thisname, "RGB", w, h, 1);
          run("Paste");
          run("8-bit");
          fnameplain=end_dir+"gsn_0\\plain\\"+thisname;
          for (fn=0;fn<g_n.length;fn++){
            run("8-bit");
            dname_plain=end_dir+"gsn_"+g_n[fn]+"\\plain";
            if (g_n[fn]>0){
              run("Add Specified Noise...", "standard="+g_n[fn]);
            }
            saveAs("PNG", ""+dname_plain+"\\"+thisname);
            dname_sandp=end_dir+"gsn_"+g_n[fn]+"\\sandp";
            run("Salt and Pepper");
            saveAs("PNG", ""+dname_sandp+"\\"+thisname);
            close();
            open(fnameplain);
          }
          close();
        }
      }
    }
  }
  run("Select None");
  setBatchMode(false);
