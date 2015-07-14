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
    int ii;
    int jj;
    char filedesc[1024];

    strcpy(fileloc_vfa,"vfa_sched_");        
    sprintf(vfa_loc_tmp,"%d", vfa_flag);
    strcat(fileloc_vfa, vfa_loc_tmp);        
    strcat(fileloc_vfa,".log");   
    fprintf(stderr,"Attempting to load %s\n",fileloc_vfa);
    
    if((fp=fopen(fileloc_vfa,"r"))==NULL)
    	{
	  fprintf (stderr, "Error opening vfa file!!\n");
	  fflush (stderr);
	  return(FAILURE);
	}        
	
    /*try and load in the descriptor/first line?*/	
    fgets(filedesc,1024,fp);
	
    vfa_ctr = 0;
    while(vfa_ctr < opfphases)
    {
    	fscanf(fp, "%f ", &vfa_flips[vfa_ctr]);
	vfa_ctr++;
    }
    
    /*close the file*/
    fclose(fp);    
    
vfa_ctr = 0;
/*fprintf(stderr,"VFA schedule is: \n");*/
fprintf(stderr,"%s\n",filedesc);
for (ii = 0; ii < num_frames; ii++)
{
	for (jj = 0; jj < num_mets; jj ++)
	{
		if(jj == 0) fprintf(stderr,"Timeframe %d: %-4.4f  ",ii+1,vfa_flips[vfa_ctr]);
		else if(jj == (num_mets-1)) fprintf(stderr,"%-4.4f  \n",vfa_flips[vfa_ctr]);
		else fprintf(stderr,"%-4.4f  ",vfa_flips[vfa_ctr]);
		vfa_ctr++;
	}
	fprintf(stderr,"\n");
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
    fprintf(stderr,"Attempting to write %s\n",fileloc_vfa);    

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

    /*Write file descriptor in the first line of the VFA schedule*/
    fprintf(fp,"RF compensated VFA for %i species and %i timeframes\n", num_mets, num_frames);

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
        /*if(vfa_ctr == 0) fprintf(stderr,"VFA schedule is: ");
	if(vfa_ctr < (opfphases-1)) fprintf(stderr,"%f ",vfa_flips[vfa_ctr]);
	if(vfa_ctr == (opfphases-1)) fprintf(stderr,"%f \n",vfa_flips[vfa_ctr]);		*/
    }
    
    fclose(fp);

    /*spit it out for diagnostics*/
    read_flip_table();    
    return SUCCESS;    
}

/*jwg read in SAKE blip info*/
@pg read_sake
STATUS read_sake( void )
{
    FILE * fp;
    int ii;
    char filedesc[1024];
    char sake_loc_tmp[10];

    strcpy(fileloc_sake,"sake_blips_");        
    sprintf(sake_loc_tmp,"%d", sake_flag);
    strcat(fileloc_sake, sake_loc_tmp);        
    strcat(fileloc_sake,".log");   
    fprintf(stderr,"Attempting to load %s\n",fileloc_sake);
    
    if((fp=fopen(fileloc_sake,"r"))==NULL)
    	{
	  fprintf (stderr, "Error opening SAKE blip schedule!!\n");
	  fflush (stderr);
	  return(FAILURE);
	}        
	
    /*try and load in the descriptor/first line?*/	
    fgets(filedesc,1024,fp);
	
    sake_ctr = 0;
    while(sake_ctr < (opetl-1))
    {
    	fscanf(fp, "%f ", &sake_blips[sake_ctr]);
	if(sake_blips[sake_ctr] > sake_max_blip)
	{
		sake_max_blip = sake_blips[sake_ctr]; 
	}
	sake_ctr++;
    }
    
    /*close the file*/
    fclose(fp);    
    
sake_ctr = 0;
fprintf(stderr,"%s\n",filedesc);
for (ii = 0; ii < (opetl-1); ii++)
{
	fprintf(stderr,"%d ",(int)sake_blips[sake_ctr]);
	sake_ctr++;
}
fprintf(stderr,"\n");
    
    return SUCCESS;
}
