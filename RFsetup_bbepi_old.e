/* Contains some functions required for reading in external waveforms*/
  
/* Most RF setup code is plagiarized from Greed and fidcsi. However, this */
/* psd reads the dat file for RF pulse parameters */
/* this functionality was plagiarized from flprofile.e*/

@host read_spsp_datfile

/*this function reads dat files written by ss_save.m*/
STATUS read_spsp_datfile(char fname[100],
						 int *specspat,
						 int *res,
						 int *pw,
						 float *nom_flip,
						 float *abswidth,
						 float *effwidth,
						 float *area,
						 float *dtycyc,
						 float *maxpw,
						 float *max_b1,
						 float *max_int_b1_sqr,
						 float *max_rms_b1,
						 float *nom_bw,
						 int *isodelay,
						 float *a_gzs,
						 float *nom_thk)
{
  char junk[80];
  FILE *fid;
  fid = fopen(fname,"r");
  if (fid==NULL)
	{
	  fprintf (stderr, "Error opening rf pulse file:  %s!!\n",fname);
	  fflush (stderr);
	  return(FAILURE);
	}
  else
	{
	  fprintf (stderr, "reading dat file:  %s\n",fname);
	}
  
  fscanf(fid,"%d %s",specspat		,junk);
  fscanf(fid,"%d %s",res		,junk);    
  fscanf(fid,"%d %s",pw		,junk);
  fscanf(fid,"%f %s",nom_flip	,junk);
  fscanf(fid,"%f %s",abswidth	,junk);
  fscanf(fid,"%f %s",effwidth	,junk);
  fscanf(fid,"%f %s",area		,junk);
  fscanf(fid,"%f %s",dtycyc		,junk);
  fscanf(fid,"%f %s",maxpw		,junk);
  fscanf(fid,"%f %s",max_b1		,junk);
  fscanf(fid,"%f %s",max_int_b1_sqr	,junk);
  fscanf(fid,"%f %s",max_rms_b1	,junk);
  if (specspat == 0) {
	fscanf(fid,"%f %s",nom_bw	,junk);
    fscanf(fid,"%d %s",isodelay	,junk);
  } else {
	fscanf(fid,"%f %s",a_gzs	,junk);
	fscanf(fid,"%f %s",nom_thk	,junk);
  }
  fclose(fid);
  return SUCCESS;
}

@host read_rf_datfile
/*this function reads dat files written by rf_write.m*/
STATUS read_rf_datfile(char fname[100],
					   float *abswidth,
					   float *effwidth,
					   float *area,
					   float *dtycyc,
					   float *maxpw,
					   float *max_b1,
					   float *max_int_b1_sqr,
					   float *max_rms_b1,
					   float *nom_flip,
					   int *pw,
					   float *nom_bw,
					   int *isodelay,
					   int *res,
					   int *extgradfile)
{
  char junk[80];
  FILE *fid;
  
  fid = fopen(fname,"r");
  if (fid==NULL)
	{
	  fprintf (stderr, "Error opening rf pulse file:  %s!!\n",fname);
	  fflush (stderr);
	  return(FAILURE);
	}
  else
	{
	  fprintf (stderr, "reading dat file:  %s\n",fname);
	}
  
  fscanf(fid,"%f %s",abswidth	,junk);
  fscanf(fid,"%f %s",effwidth	,junk);
  fscanf(fid,"%f %s",area		,junk);
  fscanf(fid,"%f %s",dtycyc		,junk);
  fscanf(fid,"%f %s",maxpw		,junk);
  fscanf(fid,"%f %s",max_b1		,junk);
  fscanf(fid,"%f %s",max_int_b1_sqr	,junk);
  fscanf(fid,"%f %s",max_rms_b1	,junk);
  fscanf(fid,"%f %s",nom_flip	,junk);
  fscanf(fid,"%d %s",pw		,junk);
  fscanf(fid,"%f %s",nom_bw	,junk);
  fscanf(fid,"%d %s",isodelay	,junk);
  fscanf(fid,"%d %s",res		,junk);    
  fscanf(fid,"%d %s",extgradfile		,junk);    
  fclose(fid);

  
  return SUCCESS;
}

@pg read_write_flip_tables
STATUS read_flip_table( void )
{
    FILE * fp;

    strcpy(fileloc_vfa,"vfa_sched_");        
    sprintf(vfa_loc_tmp,"%d", vfa_flag);
    strcat(fileloc_vfa, vfa_loc_tmp);        
    strcat(fileloc_vfa,".log");   
    fprintf(stderr,"Attempting to load VFA schedule %s\n",fileloc_vfa);
    
    if((fp=fopen(fileloc_vfa,"r"))==NULL)
    	{
	  fprintf (stderr, "Error opening vfa file!!\n");
	  fflush (stderr);
	  return(FAILURE);
	}        
	
    vfa_ctr = 0;
    while(vfa_ctr < opfphases)
    {
    	fscanf(fp, "%f ", &vfa_flips[vfa_ctr]);
	vfa_ctr++;
    }
    
    /*close the file*/
    fclose(fp);    
    
    	    /*spit it out for diagnostics!*/
	    for (vfa_ctr = 0; vfa_ctr < opfphases; vfa_ctr++) 
	    {
	        if(vfa_ctr == 0) fprintf(stderr,"VFA schedule is: ");
    		if(vfa_ctr < (opfphases-1)) fprintf(stderr,"%f ",vfa_flips[vfa_ctr]);
    		if(vfa_ctr == (opfphases-1)) fprintf(stderr,"%f \n",vfa_flips[vfa_ctr]);		
	    }
    
    return SUCCESS;
}

STATUS write_flip_table( void )
{    
    FILE * fp;
    int jj;

    strcpy(fileloc_vfa,"vfa_sched_");        
    sprintf(vfa_loc_tmp,"%d", vfa_flag);
    strcat(fileloc_vfa, vfa_loc_tmp);        
    strcat(fileloc_vfa,".log");    

    fp=fopen(fileloc_vfa,"w");
    
    /*calculate the VFA schedule in reverse order*/
    for (vfa_ctr = (num_frames - 1); vfa_ctr >= 0; vfa_ctr--)
    {
    	if(vfa_flag == 1) {
	/*Account solely for RF decay*/
    	if(vfa_ctr == (num_frames - 1))
	{
		vfa_flips[vfa_ctr] = PI / 2;
	} else {
		vfa_flips[vfa_ctr] = atan(sin(vfa_flips[vfa_ctr + 1])); 
	}
	/*Account for RF and T1 decay, to be written*/
	} else {
		/*this is just filler*/
		vfa_flips[vfa_ctr] = vfa_ctr * PI / 180;
    	}
    }

    /*Now write in in the correct order*/
    for (vfa_ctr = 0; vfa_ctr < num_frames; vfa_ctr++) 
    {
    
    	/*convert from radians to degrees*/
    	vfa_flips[vfa_ctr] = vfa_flips[vfa_ctr] * 180 / PI;
	
	/*write each flip angle num_mets times*/
	for(jj = 0; jj < num_mets; jj++)
	{
	        fprintf(fp, "%f ",vfa_flips[vfa_ctr]);			
	}
	
	/*spit it out for diagnostics!*/	
        if(vfa_ctr == 0) fprintf(stderr,"VFA schedule is: ");
	if(vfa_ctr < (opfphases-1)) fprintf(stderr,"%f ",vfa_flips[vfa_ctr]);
	if(vfa_ctr == (opfphases-1)) fprintf(stderr,"%f \n",vfa_flips[vfa_ctr]);		
    }
    fclose(fp);
    return SUCCESS;    
}
