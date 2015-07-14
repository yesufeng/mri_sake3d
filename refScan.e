/*
 *  GE Medical Systems
 *  Copyright (C) 1997 The General Electric Company
 *  
 *  refScan.e
 *  
 *  
 *  
 *  Language : ANSI C
 *  Author   : Gabriel Fernandez
 *  Date     : 
 */
/* do not edit anything above this line */


/*
 *  GE Medical Systems
 *  Copyright (C) 1997 The General Electric Company
 *  
 *  refScan.e - this inline file contains all the code to set up a spin-echo
 *              reference scan in EPI.  It is NOT a stand-alone inline file 
 *              since it utilizes much of the EPI timing information for the
 *              readout train.  This elminates the need to duplicate (or copy)
 *              pulse timings to get the reference scan entry point to "match"
 *              the scan entry point.
 *  
 *  
 *  
 *  Language : ANSI C
 *  Author   : Bryan Mock
 *  Date     : 3/5/2002
 */
/***************************
G3 12/09/03 SXZ MRIge89403: modifications for internal reference scan.
                Keyword: iref_etl, tot_etl.

14.0 04/25/05 ZL MRIhc06309: odd iref_etl needs to be supported for EPI/fMRI

14.5 10/09/2006 TS   MRIhc15304 - coil info related changes for 14.5

20.1 02/05/2009 GW   MRIhc41862: Modified calculation of Rf2Location to avoid double
                                 psd_rf_wait shift of rf2 pulse

     12/31/2009 VSN/VAK MRIhc46886 : SV to DV Apps Sync Up

 ***************************/  
/* do not edit anything above this line */

@cv refScanCV
int refScanTe;        /* This is the equivalent spin-echo TE */
int minTeFrac_ref;
int minTeFull_ref;
int tempTe_ref;
int se_ref = 0; /* 1: use spin echo ref scan */
int reMap = 1;  /* 0: dont fit correction values vs. Ky */

/* Setup all the rh variable related to pahse correction */
@host epiRefScanRhVars
    /* Number of points to exclude, center of post RFT frame */
    /* The number of points dicarded is controlled by:   */
    /* rhpcdiscmid = 'X' points at the center of the frame */
    /* rhpcdiscbeg = 'X' points at beginning of frame */
    /* rhpcdiscend = 'X' points at end of frame */
    rhpcdiscmid = 0;

    /* Number of interleaves to acquire for phase correction (ref) */ 
    /* rhpcileave = 0 (collect all of them) */
    /* rhpcileave = X (collect one an interpolate results */
    rhpcileave = 0;   /* collect them all */

    /* Pick the "best" Ky line to fit the data along Ky */
    /* Since this is a spin echo reference, we will use the */
    /* point of the Hahn Echo in the readout train - the views */
    /* are number from the top (0) to the bottom (opyres) so the max */
    /* value is determined if the scan if a fract_ky scan */
    if (fract_ky == PSD_FRACT_KY) {

        cvmax(rhpcbestky, rhnframes+rhhnover+1);

    } else {

        cvmax(rhpcbestky, rhnframes+1);

    }

    /* Set up linear & constant remap across Ky */
    if(reMap == PSD_ON) {

        rhpclinfix = 1; /* fit phase correction values vs. Ky */
        rhpcconfix = 1; 

    } else {

        rhpclinfix = 2;  /* take avg. across Ky (force slope = 0) */
        rhpcconfix = 2;
 
        rhpclinslope = 0.0;
        rhpcconslope = 0.0;
    }
    
    /* Pick the rhpcbestky "point" based on the trajectory */
    if(se_ref == PSD_ON) { 

        /* Spin echo Ref -> best line coincident w/ Hahn echo */  
        if (fract_ky == PSD_FULL_KY && ky_dir == PSD_TOP_DOWN) {
            
            rhpcbestky = (float)(rhnframes+1)/2.0 + ky_offset;
            
        } else if (fract_ky == PSD_FULL_KY && ky_dir == PSD_BOTTOM_UP) {
            
            rhpcbestky = (float)(rhnframes+1)/2.0 - ky_offset;
            
        } else if (fract_ky == PSD_FRACT_KY || ky_dir == PSD_BOTTOM_UP) {
            
            rhpcbestky = (float)(2*rhnframes+1)/2.0 - ky_offset;
            
        } else if (fract_ky == PSD_FULL_KY || ky_dir == PSD_CENTER_OUT) {

            rhpcbestky = (float)(rhnframes+1)/2.0;
        }

    } else {

        /* Gradient echo - best line is 1st in time */
        if (fract_ky == PSD_FULL_KY && ky_dir == PSD_TOP_DOWN) {
            
            rhpcbestky = ( 1.0  + (float)(rhnframes + 1)/2.0 )/2.0;          
            
        } else if (fract_ky == PSD_FULL_KY && ky_dir == PSD_BOTTOM_UP) {
            
            rhpcbestky = ( (float)rhnframes  + (float)(rhnframes + 1)/2.0 )/2.0;

        } else if (fract_ky == PSD_FRACT_KY || ky_dir == PSD_BOTTOM_UP) {

            rhpcbestky = rhnframes;

        } else if (fract_ky == PSD_FULL_KY || ky_dir == PSD_CENTER_OUT) {

            rhpcbestky = (float)(rhnframes+1)/2.0;

        }

    } /* end se_ref if/else */

    /* This centers the data in the recon buffer for minTE scans */ 
    if (fract_ky == PSD_FRACT_KY) rhhdbestky = opyres/2;

    /* Coil Selection */
    cvmax(rhpccoil, (INT)((cfrecvend - cfrecvst)+1));
    cvmin(rhpccoil, (INT)-1);
    {
        INT numcoils = ((cfrecvend - cfrecvst)+1);
 
        /* BJM: use coil #4 for phase correcion with 8 channel */
        /* head coil */
        /* 11.0 update - use all coils, rhpccoil = 0 */

        if(numcoils > 1)
            rhpccoil = 0; /* (INT)(numcoils)/2.0; */
        else
            rhpccoil = 1;

        /* MRIge91081 - disable ref scan per coil for Asset */
        /* asset = 2 for scans, 1 for calibration */
        if(exist(opasset) == 2) { 
            rhpccoil = (INT)-1; 
        }
    }

    /* Turn on linear & constant correction */
    rhpclin = 1;
    rhpccon = 1;

    /* for single-shot ref scan, minimum fit orders are 1 */
    if ( rhpcileave > 0 )
    {
        cvmod(rhpcconorder, 1, 4, 2,
              "Constant fit order: 0=vu spcfc;1=Kybest;2=line;3,4=poly",0," ");
        cvmod(rhpclinorder, 1, 4, 2,
              "Constant fit order: 0=vu spcfc;1=Kybest;2=line;3,4=poly",0," ");
    }
    else
    {
        cvmod(rhpcconorder, 0, 4, 2,
              "Linear fit order: 0=vu spcfc;1=Kybest;2=line;3,4=poly",0," ");
        cvmod(rhpclinorder, 0, 4, 2,
              "Linear fit order: 0=vu spcfc;1=Kybest;2=line;3,4=poly",0," ");
    }

    cvmax(rhpcshotfirst, intleaves-1);
    rhpcshotfirst = 0;
    cvmin(rhpcshotlast, rhpcshotfirst);
    cvmax(rhpcshotlast, intleaves - 1);
    rhpcshotlast = intleaves - 1;

    /* set con and lin orders: 0=vu spcfc, 1=kybest, 2=line, 3,4=poly */
    rhpcconorder = 2;
    rhpclinorder = 2;

    /* set con and lin #pts */
    cvmax(rhpcconnpts, 4);
    cvmax(rhpclinnpts, 4);
    rhpcconnpts = 4;
    if (etl > 3)
    {
        while (rhpcconnpts > etl/2)
        {
            rhpcconnpts = rhpcconnpts - 1;
        }
        cvmax(rhpcconnpts, etl/2);
    } 
    else
    {
        rhpcconorder = 1;
    }

    if (etl>3)
    {
        rhpclinnpts = IMin(2, 4, etl/2);
        cvmax(rhpclinnpts, etl/2);
    }
    else
    {
        rhpclinnpts = 3; /* value does not matter */
        rhpclinorder = 1;
    }

    /* BJM: turn off phase correction via button */
    if ( (etl == 1) )
    {
        rhpccon = 0;
        rhpclin = 0;
        rhpcconorder = 1;
        rhpclinorder = 1;
    }
    
    if ((TX_COIL_BODY == getTxCoilType()) && (RX_COIL_LOCAL == getRxCoilType()))
    {
        rhpclinnorm = 1;
        rhpcconnorm = 1;
    }
    else
    {
        rhpclinnorm = 0;
        rhpcconnorm = 0;
    }

    rhpclinfitwt = 0;
    cvmax(rhpclinfitwt, 0);
    rhpclinavg = 0;

    cvmax(rhpcthrespts, 32);
  
    rhpcconfitwt = 0;

@host epiRefScanTeCalc

INT avmintecalc_ref( void )
{
    int pulsecnt;
    int tdaqhxatemp;
  
    /* All this to find pw_gy1_tot: */
    gy1_offset = ky_offset*fabs(area_gyb)/intleaves;
    area_gy1 = area_gy1 + gy1_offset;
    area_gy1 = fabs(area_gy1);
    endview_iamp = max_pg_wamp;
    endview_scale = (float)max_pg_iamp / (float)endview_iamp;
    /* Find the amplitudes and pulse widths of the trapezoidal
       phase encoding pulse. */
    
    if (amppwtpe(&a_gy1a,&a_gy1b,&pw_gy1,&pw_gy1a,&pw_gy1d,
                 loggrd.ty_xyz/endview_scale,loggrd.yrt,
                 area_gy1) == FAILURE)
    {
        epic_error(use_ermes,supfailfmt,EM_PSD_SUPPORT_FAILURE,
                   1,STRING_ARG,"amppwtpe");
        return FAILURE;
    } 
    
    pw_gy1_tot = pw_gy1a + pw_gy1 + pw_gy1d;
    
    if (ygmn_type == CALC_GMN1) {
        
        /* set time origin at end of bipolar flow comp lobe/beginning of 
           gy1f phase encoding pulse */
        invertphase = 0;
        zeromomentsum = 0.0;
        firstmomentsum = 0.0;
        pulsepos = 0;
        
        /* compute moments for blips */
        pulsepos = pw_gy1_tot + pw_gxwad + esp - pw_gxwad/2 - pw_gyb/2 - pw_gybd;
        if(no_gy1_ol_gxw && iref_etl > 0) pulsepos += esp;
        for (pulsecnt=0;pulsecnt<blips2cent;pulsecnt++) {
            rampmoments(0.0, a_gyb, pw_gyba, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gyb, a_gyb, pw_gyb, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gyb, 0.0, pw_gybd, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            pulsepos = pulsepos + (esp - pw_gyba - pw_gyb/2);
        }
        gyb_tot_0thmoment = zeromomentsum;
        gyb_tot_1stmoment = firstmomentsum;
        
        /* Here we compute the gradient moment nulling pulse parameters
           for a worst case condition: when the gy1f pulse has zero
           amplitude.  Since the gy1f never really steps to zero amplitude,
           this is hardly an optimal solution.  A future option is to
           compute the minimum amplitude of gy1f across all intleaves
           in this calculation. */
        
        amppwygmn(gyb_tot_0thmoment, gyb_tot_1stmoment, pw_gy1a, pw_gy1,
                  pw_gy1d, 0.0, 0.0, loggrd.ty_xyz, (float)loggrd.yrt,
                  0, &pw_gymn2a, &pw_gymn2, &pw_gymn2d, &a_gymn2);
        
        a_gymn2 = -a_gymn2;
        a_gymn1 = -a_gymn2;
        pw_gymn1a = pw_gymn2a;
        pw_gymn1 = pw_gymn2;
        pw_gymn1d = pw_gymn2d;
        
        pw_gymn1_tot = pw_gymn1a + pw_gymn1 + pw_gymn1d;
        pw_gymn2_tot = pw_gymn2a + pw_gymn2 + pw_gymn2d;
        
    } else {    /* if (ygmn_type != CALC_GMN1) */
        pw_gymn1_tot = 0;
        pw_gymn2_tot = 0;
    }

    if( iref_etl != 0 && pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot > esp ){
       pw_iref_gxwait = RUP_GRD(pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot - esp);
    }else{
       pw_iref_gxwait = 0;
    }
    if(no_gy1_ol_gxw && iref_etl > 0)
        pw_iref_gxwait = RUP_GRD(pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot);

    tdaqhxatemp = tdaqhxa + pw_iref_gxwait;

    /* SSP Timing for Spin-Echo */
    avminssp = pw_rf2/2 + rfupd + 8us + pw_wssp + tdaqhxatemp;
    avminssp = avminssp + HSDAB_length;

    if (xtr_offset == 0) {
        avminssp = avminssp + (XTRSETLNG + XTR_length[PSD_XCVR2]);
    } else {
        avminssp = avminssp + xtr_offset;
    }
    
    /* Since spin-echo - need 2*tau */
    avminssp *= 2;    

    avminxa = 2*(rfExIso);
    avminxb = 2*(tdaqhxatemp + pw_wgx + pw_rf2/2 +
                 IMax(3,
                      pw_gx1_tot,
                      (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0),
                      pw_gzrf2r1_tot));

    avminx  = (avminxa>avminxb) ? avminxa : avminxb;
    

    avminya = 2*(rfExIso);
    avminyb = 2*(pw_rf2/2 + pw_wgy + tdaqhxatemp + pw_gxwad +
                 IMax(3,
                      pw_gx1_tot,
                      (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0),
                      pw_gzrf2r1_tot));
    
    avminy  = (avminya>avminyb) ? avminya : avminyb;
    
    avminza = 2*(rfExIso + pw_gzrf1d + pw_gz1_tot +
                 pw_gzrf2l1_tot + (pw_rf2/2));
    avminzb = 2*(8us + (pw_rf2/2) + tdaqhxatemp + pw_wgz +
                 IMax(3,
                      pw_gx1_tot,
                      (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0),
                      pw_gzrf2r1_tot));
    avminz  = (avminza>avminzb) ? avminza : avminzb;
    
    tempTe_ref = ((avminy>avminz) ? avminy : avminz);
    tempTe_ref = ((avminx>tempTe_ref) ? avminx : tempTe_ref);
    tempTe_ref = ((avminssp>tempTe_ref) ? avminssp : tempTe_ref);

    return tempTe_ref;
}

@pg epiRefScanPulses

/* 90 Degree Pulse + Gradient */
WF_PULSE gzrf1refa = INITPULSE;
WF_PULSE gzrf1ref  = INITPULSE;
WF_PULSE gzrf1refd = INITPULSE;
WF_PULSE rf1ref = INITPULSE;
WF_PULSE thetarf1ref  = INITPULSE;

/* 180 Degree Pulse Pulse Slice-Select */
WF_PULSE gzrf2refa = INITPULSE;
WF_PULSE gzrf2ref  = INITPULSE;
WF_PULSE gzrf2refd = INITPULSE;
WF_PULSE rf2ref = INITPULSE;
WF_PULSE rf2se1b4_ref = INITPULSE;

/* Crushers Left (l1) and Right (r1) */
WF_PULSE gzrf2refl1a = INITPULSE;
WF_PULSE gzrf2refl1 = INITPULSE;
WF_PULSE gzrf2refl1d = INITPULSE;

WF_PULSE gzrf2refr1a = INITPULSE;
WF_PULSE gzrf2refr1 = INITPULSE;
WF_PULSE gzrf2refr1d = INITPULSE;

/* Ky Prephaser Pulse */
WF_PULSE refgy1a = INITPULSE;
WF_PULSE refgy1 = INITPULSE;
WF_PULSE refgy1d = INITPULSE;

/* Kx Prephaser Pulse */
WF_PULSE refgx1a = INITPULSE;
WF_PULSE refgx1 = INITPULSE;
WF_PULSE refgx1d = INITPULSE;

/* Killer Pulse on X */
WF_PULSE refgxka = INITPULSE;
WF_PULSE refgxk = INITPULSE;
WF_PULSE refgxkd = INITPULSE;

/* Killer Pulse on Y */
WF_PULSE refgyka = INITPULSE;
WF_PULSE refgyk = INITPULSE;
WF_PULSE refgykd = INITPULSE;

/* Killer Pulse on Z */
WF_PULSE refgzka = INITPULSE;
WF_PULSE refgzk = INITPULSE;
WF_PULSE refgzkd = INITPULSE;

WF_PULSE wgxref = INITPULSE;

WF_PULSE wgyref = INITPULSE;

WF_PULSE wgzref = INITPULSE;

WF_PULSE wsspref = INITPULSE;

WF_PULSE sspdelayref = INITPULSE;

WF_PULSE omegadelayref = INITPULSE;

WF_PULSE womegaref = INITPULSE;

WF_PULSE e1entnsref = INITPULSE;
short e1entnsref_pack[4] = {0,SSPOC+DREG,SSPD+DCBL,SSPDS};

WF_PULSE e1distnsref = INITPULSE;
short e1distnsref_pack[4] = {0,SSPOC+DREG,SSPD,SSPDS};

WF_PULSE sspshiftref = INITPULSE;
WF_PULSE ssp_pass_delayref = INITPULSE;


WF_PULSE rho_killerref = INITPULSE;

WF_PULSE rs_omega_attackref = INITPULSE;
WF_PULSE rs_omega_decayref = INITPULSE;
WF_PULSE omega_flatref = INITPULSE;

WF_PULSE_ADDR rf2ssp_end;

WF_PULSE **echotrainxtr_ref;
WF_PULSE **echotrainrba_ref;

@pg epiRefScanPG

if(se_ref == PSD_ON) {

    /* BJM: reuse all the pulse parameters of the imaging sequence */
    /* spsp 90 RF slice select pulse *******************************************/
    temp_res = res_rf1;
    if (rfpulseInfo[RF1_SLOT].change == PSD_ON)  /* set to new resolution */
        res_rf1 = rfpulseInfo[RF1_SLOT].newres;
    
    /* set rfunblank_bits[2] so that addrfbits in sliceselz does not
       unblank the receiver - see EpicConf.c for defaults. Will unblank
       the receiver later - MRIge28778 */
    
    rfunblank_bits[0][2] = SSPD;
    rfunblank_bits[1][2] = SSPD;

    {
      /* Now create the pulses */
      pulsename(&gzrf1refa,"gzrf1refa");
      pulsename(&gzrf1ref,"gzrf1ref");
      pulsename(&gzrf1refd,"gzrf1refd");
      pulsename(&rf1ref,"rf1ref");
      pulsename(&thetarf1ref, "thetarf1ref");

      /*  Now create the slice select trapezoid */
      pg_beta = loggrd.zbeta;

      if ( gztype == PLAY_GFILE) {

#if defined(IPG_TGT) || defined(MGD_TGT)
          /* Use external gradient file for now */
          createextwave( &gzrf1ref, ZGRAD, res_gzrf1,
                         grad_zrf1);

          createinstr( &gzrf1ref, (long)pos_start+pw_gzrf1a,
                       pw_gzrf1, ia_gzrf1 );

#elif defined(HOST_TGT)
          /* Create train of trapezoids on the Host side */
          int i;
          int polarity = 1;
       
          pulsepos = pos_start+pw_gzrf1a; 
       
          for(i = 1; i <= num_rf1lobe; i++) {
              polarity *= -1;

              trapezoid( ZGRAD,"gzrf1ref", &gzrf1ref, 
                         &gzrf1refa, &gzrf1refd,
                         pw_constant, pw_ss_rampz, pw_ss_rampz, 
                         (polarity*(ia_gzrf1)),
                         (polarity*(ia_gzrf1)),
                         (polarity*(ia_gzrf1)), 0, 0, 
                         pulsepos, TRAP_ALL, &loggrd );

              pulsepos += pw_constant + 2 * pw_ss_rampz;
          }
#endif

      } else {

          /* Create simple trapezoid for chem sat + rf */
          createramp( &gzrf1refa,ZGRAD,pw_gzrf1a,
                      (short)0, max_pg_wamp,
                      (short)(maxGradRes *
                              (pw_gzrf1a/ GRAD_UPDATE_TIME)),
                      pg_beta );

          createinstr( &gzrf1refa,
                       (long)(pos_start+pw_gzrf1a - pw_gzrf1a),
                       pw_gzrf1a, ia_gzrf1 );

          createconst( &gzrf1ref, ZGRAD, pw_rf1, max_pg_wamp );
          createinstr( &gzrf1ref, (long)pos_start+pw_gzrf1a,
                       pw_gzrf1, ia_gzrf1 );

          createramp( &gzrf1refd, ZGRAD, pw_gzrf1d,
                      max_pg_wamp, (short)0,
                      (short)(maxGradRes *
                              (pw_gzrf1d/ GRAD_UPDATE_TIME)),
                      pg_beta );
          createinstr( &gzrf1refd,
                       (long)(pos_start+pw_gzrf1a + pw_gzrf1),
                       pw_gzrf1d, ia_gzrf1 );

      }

      /* Now create the rf pulse */
      if ( rftype == PLAY_RFFILE) {
          createextwave( &rf1ref,TYPRHO1, res_rf1,
                         rf_rf1);
      } else {
          createsinc( &rf1ref,TYPRHO1, res_rf1,
                      max_pg_wamp,cyc_rf1, alpha_rf1 );
      }

      createinstr( &rf1ref,(long)pos_start+pw_gzrf1a + psd_rf_wait +
                   ss_rf_wait,  pw_rf1,ia_rf1);

      addrfbits( &rf1ref, off_rf1, (long)pos_start+pw_gzrf1a +
                 psd_rf_wait + ss_rf_wait, pw_rf1 );

      /* Now create the theta pulse */
      if ( thetatype == PLAY_THETA) {
          createextwave( &thetarf1ref, TYPOMEGA,
                         res_thetarf1, theta_rf1);

          createinstr( &thetarf1ref, (long)pos_start+pw_gzrf1a + psd_rf_wait +
                       ss_rf_wait, pw_thetarf1,
                       ia_thetarf1);

          addrfbits( &thetarf1ref, off_thetarf1,
                     (long)pos_start+pw_gzrf1a + psd_rf_wait + ss_rf_wait,
                     pw_thetarf1 );
      }
#if defined(IPG_TGT) || defined(MGD_TGT)
      if ( gztype == PLAY_GFILE) {
          linkpulses( 3,
                      &rf1ref, &gzrf1ref, &thetarf1ref);
      } else {
          linkpulses( 4,
                      &rf1ref, &gzrf1ref,
                      &gzrf1refa, &gzrf1refd);
      }
#endif
  }
    
    /* reset the bit */
    rfunblank_bits[0][2] = SSPD + RUBL;
    rfunblank_bits[1][2] = SSPD + RUBL;
    
    if (rfpulseInfo[RF1_SLOT].change == PSD_ON)  /* change back for ext. file */
        res_rf1 = temp_res;
    
    /* 180 RF refocusing pulse ********************************************/
    Rf2Location[0] = RUP_GRD((int)(pend(&rf1ref,"rf1ref",0) - rfExIso  + refScanTe/2
                                       - pw_rf2/2) - psd_rf_wait);  /* Find start loc of 180s */
        
        /* MRIge58235: moved uextwave to here so the file read from disk is always read with orig. res_rf2 */
    strcpy(ext_filename, "rfse1b4.rho");
        
    /* Create some RHO waveform space, read in the 
       se1b4 spin echo 180 to local memory, and then move
       the local memory to the reserved RHO memory.
     */
    temp_wave_space = (short *)AllocNode(res_rf2*sizeof(short));
    uextwave(temp_wave_space, res_rf2, ext_filename);
        
    {
        /* MRIge58235: save orig. res_rf2ref for scaling */
        short orig_res;
            
        orig_res = res_rf2;
        if (rfpulseInfo[RF2_SLOT].change==PSD_ON)
            res_rf2 = rfpulseInfo[RF2_SLOT].newres;     /* Set to new resolution */
            
        /* set rfunblank_bits[2] so that addrfbits in sliceselz does not
           unblank the receiver - see EpicConf.c for defaults. Will unblank
           the receiver later - MRIge28778 */
        rfunblank_bits[0][2] = SSPD;
        rfunblank_bits[1][2] = SSPD;

        /*  180 slice sel pulse  */
        {
            /* First create the pulses */
            pulsename(&gzrf2refa,"gzrf2refa");
            pulsename(&gzrf2ref,"gzrf2ref");
            pulsename(&gzrf2refd,"gzrf2refd");
            pulsename(&rf2ref,"rf2ref");

            /*  Now create the slice select trapezoid */
            pg_beta = loggrd.zbeta;
            createramp(&gzrf2refa,ZGRAD,pw_gzrf2a,(short)0,
                       MAX_PG_WAMP,(short)(maxGradRes*(pw_gzrf2a/
                                                       GRAD_UPDATE_TIME)),pg_beta);
            createinstr( &gzrf2refa,(long)(Rf2Location[0]-pw_gzrf2a),
                         pw_gzrf2a,ia_gzrf2);
            createconst(&gzrf2ref,ZGRAD,pw_gzrf2,MAX_PG_WAMP);
            createinstr( &gzrf2ref,(long)(Rf2Location[0]),
                         pw_gzrf2,ia_gzrf2);
            createramp(&gzrf2refd,ZGRAD,pw_gzrf2d,MAX_PG_WAMP,
                       (short)0,(short)(maxGradRes*(pw_gzrf2d/GRAD_UPDATE_TIME)),
                       pg_beta);
            createinstr( &gzrf2refd,(long)(Rf2Location[0]+pw_gzrf2),
                         pw_gzrf2d,ia_gzrf2);

            /* Now create the rf pulse */
            createsinc(&rf2ref,TYPRHO1,res_rf2,
                       MAX_PG_WAMP,cyc_rf2, alpha_rf2);
            createinstr( &rf2ref,(long)(Rf2Location[0]) + psd_rf_wait,
                         pw_rf2,ia_rf2);
            linkpulses(4,&rf2ref,&gzrf2ref,&gzrf2refa,
                       &gzrf2refd);
            addrfbits(&rf2ref,off_rf2,(long)(Rf2Location[0]) + psd_rf_wait, 
                      pw_rf2);
        }

        /* reset the bit */
        rfunblank_bits[0][2] = SSPD + RUBL;
        rfunblank_bits[1][2] = SSPD + RUBL;

        /* Stretch rf pw if needed */
        if (rfpulseInfo[RF2_SLOT].change==PSD_ON) {
            wave_space = (short *)AllocNode(rfpulseInfo[RF2_SLOT].newres*
                                            sizeof(short));
            stretchpulse((int)orig_res, (int)rfpulseInfo[RF2_SLOT].newres,
                         temp_wave_space,wave_space);
            FreeNode(temp_wave_space);
        } else {
            wave_space = temp_wave_space;
        }

        /* Assign temporary board memory and move immediately into permanent
           memory */
        res_rf2se1b4 = res_rf2;
        pulsename(&rf2se1b4_ref,"rf2se1b4_ref");
        createreserve(&rf2se1b4_ref,RHO, res_rf2se1b4);
        movewaveimm(wave_space, &rf2se1b4_ref, (int)0, res_rf2, TOHARDWARE);
        FreeNode(wave_space);

        /* MRIge58235: reset res_rf2 after scaling */
        res_rf2 = orig_res;
    }

    setphase((float)(PI/-2.0), &rf2ref, 0);  /* Apply 90 phase shift to  180 */

    attenflagon(&rf1ref, 0);                 /* Assert ESSP flag on rf1 pulse */

    attenflagon(&rf2ref, 0);                 /* Assert ESSP flag on 1st rf2 */

    /* Z crushers (echo 1) ***********************************************/
    trapezoid(ZGRADB, "gzrf2refl1", &gzrf2refl1, &gzrf2refl1a,
              &gzrf2refl1d, pw_gzrf2l1, pw_gzrf2l1a, pw_gzrf2l1d,
              ia_gzrf2l1, 0, 0, 0, 0, pbeg(&gzrf2ref,"gzrf2ref",0)-(pw_gzrf2l1+pw_gzrf2l1d)-pw_gzrf2l1a, TRAP_ALL,
              &loggrd);

    trapezoid(ZGRADB, "gzrf2refr1", &gzrf2refr1, &gzrf2refr1a,
              &gzrf2refr1d, pw_gzrf2r1, pw_gzrf2r1a, pw_gzrf2r1d,
              ia_gzrf2r1, 0, 0, 0, 0, pend(&gzrf2ref,"gzrf2refd",0)-pw_gzrf2r1a, TRAP_ALL,
              &loggrd);

    /* unblank receiver rcvr_ub_off us prior to first xtr/dab/rba packet */
    /* BJM: move DAB packet after RF for less upfront deadtime */
    getssppulse(&rf2ssp_end, &rf2ref, "ubr", 0);
    rcvrunblankpos = pendallssp(rf2ssp_end, 0);
    RCVRUNBLANK(rec_unblankref, rcvrunblankpos,);

    /***********************************************************************/
    /* X EPI readout train                                                 */
    /***********************************************************************/

    /* These arrays are used to hold the addresses of the data acq pulses.. */
    echotrainxtr_ref = (WF_PULSE **)AllocNode(tot_etl*sizeof(WF_PULSE *));
    echotrainrba_ref = (WF_PULSE **)AllocNode(tot_etl*sizeof(WF_PULSE *));

    /* BJM: pkt_delay is included to account for any delay between */
    /* sending the RBA and the first sample acquired (hardware delay) */
    if (vrgfsamp == PSD_ON) {
        dacq_offset = pkt_delay + pw_gxwad - 
            (int)(fbhw*((float)pw_gyb/2.0 + 
                        (float)pw_gybd) + 0.5);
    } else {
        dacq_offset = pkt_delay;
    }

    /* MRIge58023 & 58033 need to RUP_GRD entire expression */
    if (intleaves == opyres) {
        tempx = RUP_GRD((int)(pend(&rf1ref,"rf1ref",0) - rfExIso + refScanTe - pw_gxw/2 - pw_gxwl - ky_offset*esp/intleaves));
    } else {
        tempx = RUP_GRD((int)(pend(&rf1ref,"rf1ref",0) - rfExIso + refScanTe - echoOffset * esp - ky_offset*esp/intleaves + 1ms));
    }

    tempy = tempx + gydelay;
    tempz = tempx;
    tempx += gxdelay;

    /* Set up for EP_TRAIN */
    stddab = (hsdab==PSD_ON ? 0:1);
    pg_tsp =0;

    EP_TRAIN_NAME(ref,
                  tempx + pw_gxwad,
                  tot_etl,
                  0,
                  tot_etl,
                  fast_rec,
                  scanslot,
                  stddab,
                  psd_grd_wait - dacq_offset,
                  pg_tsp,
                  dab_offset,
                  xtr_offset,
                  iref_etl,
                  epiloggrd);

    if (tot_etl % 2 == 1) {
        getbeta(&betax, XGRAD, &epiloggrd);
        pulsePos = pend(&refgxw, "refgxw", tot_etl-1);
        createramp(&refgxwde, XGRAD, pw_gxwad, -max_pg_wamp, 0,
                   (short)(maxGradRes*(pw_gxwad)/GRAD_UPDATE_TIME), betax);
        createinstr(&refgxwde, pulsePos, pw_gxwad, -ia_gxw);
        pulsePos += pw_gxwad;
    }

    /***********************************************************************/
    /* X dephaser                                                          */
    /***********************************************************************/
    temp1 = RUP_GRD((int)(pbeg(&refgxw,"refgxw",0) - (pw_gxwad + pw_gx1a +
                                                      pw_gx1 + pw_gx1d)));
    pg_beta = loggrd.xbeta;
    
    /* Gx1ref Attack Pulse */
    pulsename(&refgx1a,"refgx1a");
    createramp(&refgx1a,XGRAD,pw_gx1a,(short)0,
               max_pg_wamp,(short)(maxGradRes*(pw_gx1a/GRAD_UPDATE_TIME)),
               pg_beta);
    createinstr(&refgx1a, (LONG)temp1, pw_gx1a, ia_gx1);
    
    /* Gx1ref Pulse */
    if (pw_gx1 >= GRAD_UPDATE_TIME) {
        pulsename(&refgx1,"refgx1");
        createconst(&refgx1,XGRAD,pw_gx1,max_pg_wamp);
        createinstr( &refgx1,(LONG)(LONG)temp1+pw_gx1a,
                     pw_gx1,ia_gx1);
    }

    /* Gx1ref Decay Pulse */
    pulsename(&refgx1d, "refgx1d");
    createramp(&refgx1d,XGRAD,pw_gx1d,max_pg_wamp,
               (short)0,(short)(maxGradRes*(pw_gx1d/GRAD_UPDATE_TIME)),
               pg_beta);
    createinstr( &refgx1d,(LONG)((LONG)temp1+pw_gx1a+pw_gx1),
                 pw_gx1d,ia_gx1);

    pulsename(&refgxwa, "refgxwa");  /* attack ramp for epi train */
    createramp(&refgxwa, XGRAD, pw_gxwad, (short)0, max_pg_wamp,
               (short)(maxGradRes*(pw_gxwad/GRAD_UPDATE_TIME)), pg_beta);
    if ( etl%2 == 0 && ky_dir != PSD_TOP_DOWN  )
        createinstr(&refgxwa, (LONG)tempx, pw_gxwad, -ia_gxw);
    else
        createinstr(&refgxwa, (LONG)tempx, pw_gxwad, ia_gxw);

    /* Set readout polarity to gradpol[ileave] value */
    ileave = 0;
    setreadpolarity_ref();

    /* Hyperscan DAB packet */
    temp2 = pendall(&rf1ref, 0) + rfupd + 4us;  /* 4us for unblank receiver */
    HSDAB(hyperdabref, temp2);

    /* If we don't reset frequency and phase on each view, then it is best
       to use a single packet at the beginning of the frame - one that doesn't
       shift with interleave.  This is because we want the constant part of Ahn
       correction to see continuous phase evolution across the views. */

    temp2 = pendall(&rf2ref, 0) + rfupd + 4us;  /* 4us for unblank receiver */

    /* Y prephaser ************************************************************/
    temp1 = pbeg(&refgxw, "refgxw", iref_etl) - pw_gxwad - pw_gy1_tot;
    temp1 = RDN_GRD(temp1);

    /* Setup the Ky Prephaser for Ref Scan */
    trapezoid(YGRAD,"refgy1",
              &refgy1,&refgy1a,&refgy1d,
              pw_gy1,pw_gy1a,pw_gy1d,
              ia_gy1,ia_gy1wa,ia_gy1wb,
              0,0,temp1,TRAP_ALL_SLOPED, &loggrd);

    /* TRAPEZOID2(YGRAD, refgy1, temp1, TRAP_ALL_SLOPED,,,endview_scale, loggrd); */

    /* X killer pulse *********************************************************/
    if (eosxkiller == PSD_ON) {
        tempx = RUP_GRD(pend(&refgxwde,"refgxwde",0) + gkdelay + pw_gxka);

        trapezoid(XGRAD, "refgxk", &refgxk, &refgxka,
                  &refgxkd, pw_gxk, pw_gxka, pw_gxkd,
                  ia_gxk, 0, 0, 0, 0, tempx-pw_gxka, TRAP_ALL,
                  &loggrd);

        /* TRAPEZOID(XGRAD, refgxk, tempx, 0, TYPNDEF, loggrd); */
    }

    /* Y killer pulse *****************************************************/
    if (eosykiller == PSD_ON) {
        tempy = RUP_GRD(pend(&refgxwde,"refgxwde",0) + gkdelay + pw_gyka);

        trapezoid(YGRAD, "refgyk", &refgyk, &refgyka,
                  &refgykd, pw_gyk, pw_gyka, pw_gykd,
                  ia_gyk, 0, 0, 0, 0, tempy-pw_gyka, TRAP_ALL,
                  &loggrd);

        /* TRAPEZOID(YGRAD, refgyk, tempy, 0, TYPNDEF, loggrd); */
    }

    /* Z killer pulse *****************************************************/
    if (eoszkiller == PSD_ON) {
        tempz = RUP_GRD(pend(&refgxwde,"refgxwde",0) + gkdelay + pw_gzka);

        trapezoid(ZGRAD, "refgzk", &refgzk, &refgzka,
                  &refgzkd, pw_gzk, pw_gzka, pw_gzkd,
                  ia_gzk, 0, 0, 0, 0, tempz-pw_gzka, TRAP_ALL,
                  &loggrd);

        /* TRAPEZOID(ZGRAD, refgzk, tempz, 0, TYPNDEF, loggrd); */
    }

    /* RHO killer? pulse ***********************************************/
    /* This pulse is specific to MGD.  It forces the RHO sequencer to  */
    /* EOS after all other RF sequencers (omega & theta) as a temp fix */
    /* for a sequencer buffer glitch.                                  */

    if (eosrhokiller == PSD_ON) {

        int pw_rho_killer = 2;
        int ia_rho_killer = 0;

        tempz = RUP_GRD(pend(&refgxwde,"refgxwde",0) + gkdelay + pw_gzka);
        pulsename(&rho_killerref,"rho_killerref");
        createconst(&rho_killerref,RHO,pw_rho_killer,MAX_PG_WAMP);
        createinstr( &rho_killerref,(long)(tempz),
                     pw_rho_killer,ia_rho_killer);
    }

#ifdef IPG
    /*
     * Execute this code only on the Tgt side
     */
    /* Major "Wait" Pulses ************************************************/

    tempy = pbeg(&refgy1a, "refgy1a", 0) - pw_wgy;
    tempx = pbeg(&refgx1a, "refgx1a", 0) - pw_wgx;
    /* TFON sliding data acq. window wait intervals */

    /* WAIT Pulse on X */
    pulsename(&wgxref,"wgxref");
    createconst(&wgxref,XGRAD,pw_wgx,(short)0); 
    createinstr( &wgxref,(long)(tempx),pw_wgx,0);

    /* WAIT Pulse on Y */
    pulsename(&wgyref,"wgyref");
    createconst(&wgyref,YGRAD,pw_wgy,(short)0); 
    createinstr( &wgyref,(long)(tempy),pw_wgy,0);

    tempz = pendall(&gzrf2refr1, 0);    

    /* WAIT Pulse on Z */
    pulsename(&wgzref,"wgzref");
    createconst(&wgzref,ZGRAD,pw_wgz,(short)0); 
    createinstr( &wgzref,(long)(tempz),pw_wgz,0);

    temps = pendall(&rf2ref, 0) + rfupd + 4us;

    /* WAIT on SSP */ 
    pulsename(&wsspref,"wsspref");
    createconst(&wsspref,SSP,pw_wssp,(short)0); 
    createinstr( &wsspref,(long)(temps),pw_wssp,0);
   
    /* 1us is the min time for ssp, per L. Ploetz. YPD */ 
    pw_sspdelay = defaultdelay + 1us;
    
    /* WAIT for SSP Delay */ 
    pulsename(&sspdelayref,"sspdelayref");
    createconst(&sspdelayref,SSP,pw_sspdelay,(short)0); 
    createinstr( &sspdelayref,(long)(temps+pw_wssp),pw_sspdelay,0);
    
    pw_omegadelay = RUP_RF(defaultdelay+2us); /* 2us is the min time for omega,
                                                 per L. Ploetz. YPD */
    /* WAIT for Omega Delay */ 
    pulsename(&omegadelayref,"omegadelayref");
    createconst(&omegadelayref,OMEGA,pw_omegadelay,(short)0); 
    createinstr( &omegadelayref,(long)(RUP_GRD(temps)),pw_omegadelay,0);
    
    pulsename(&womegaref,"womegaref");
    createconst(&womegaref,OMEGA,pw_womega,(short)0); 
    createinstr( &womegaref,(long)(RUP_GRD(temps)+pw_omegadelay),pw_womega,0);

    /* pulse names for Omega Freq Mod pulses */ 
    pulsename(&rs_omega_attackref, "rs_omega_attackref");
    pulsename(&rs_omega_decayref, "rs_omega_decayref");
    pulsename(&omega_flatref, "omega_flatref");

    for (echoloop = 0; echoloop < tot_etl; echoloop++ ) {
        getssppulse(&(echotrainrba_ref[echoloop]), &(refechotrain[echoloop]), "rba", 0);

        {   /* local scope */

            int time_offset = 0;
            pulsepos = pendallssp(echotrainrba_ref[echoloop], 0); 
            time_offset = pw_gxwad - dacq_offset;  
 
            /* TURN TNS ON at the first etl and OFF at the last etl so that */
            /* the xtr and TNS do not overlap. */
            if ( echoloop == 0)  {
                e1entnsref_pack[0] = SSPDS+EDC;
                pulsename(&e1entnsref,"e1entnsref");
                createbits(&e1entnsref,TYPSSP,4,e1entnsref_pack);
                createinstr( &e1entnsref,(LONG)(pulsepos),4,0);
            }

            if ( echoloop == tot_etl-1) {
                e1distnsref_pack[0] = SSPDS+EDC;
                pulsename(&e1distnsref,"e1distnsref");
                createbits(&e1distnsref,TYPSSP,4,e1distnsref_pack);
                createinstr( &e1distnsref,(LONG)(pulsepos+(int)(tsp*(float)rhfrsize)),4,0);
            }

            if (vrgfsamp) {
	        /*jwg bb change first variable from OMEGA to wg_omegaro1 so we can broadband this sucker*/	    
                trapezoid( wg_omegaro1,"omegaref", &omega_flatref, 
                           &rs_omega_attackref, &rs_omega_decayref,
                           pw_gxwl+pw_gxw+pw_gxwr,  pw_gxwad, pw_gxwad, 
                           ia_omega,ia_omega,ia_omega, 0, 0, 
                           RUP_RF(pulsepos-time_offset), TRAP_ALL, &loggrd);    
            } else {
                
                /* BJM: to offset frequency, play constant on omega */
		/* jwg bb and we'll do the same thing down here, in case we're not ramp sampling*/		
                createconst(&omega_flatref, wg_omegaro1, pw_gxwl+pw_gxw+pw_gxwr, 
                            max_pg_wamp);
                createinstr(&omega_flatref, RUP_RF(pulsepos),
                            pw_gxwl+pw_gxw+pw_gxwr, ia_omega);            
            }

        }
    }
    
    /* 4us for the e1distns pack */
    temps = pendallssp(&refechotrain[tot_etl-1], 0) + (int)(tsp*(float)rhfrsize)+ 4; 
    
    /* "Spring" for sspdelay - keeps TR constant for sliding read window */
    pulsename(&sspshiftref,"sspshiftref");
    createconst(&sspshiftref,SSP,pw_sspshift,(short)0); 
    createinstr( &sspshiftref,(long)(temps+7  ),pw_sspshift,0);

    temps = pendallssp(&sspshiftref, 0);
    pulsename(&ssp_pass_delayref,"ssp_pass_delayref");
    createconst(&ssp_pass_delayref,SSP,pw_ssp_pass_delay,(short)0); 
    createinstr( &ssp_pass_delayref,(long)(temps),pw_ssp_pass_delay,0);
    
    temps = pendallssp(&ssp_pass_delayref, 0);
    
    PASSPACK(pass_pulseref, temps);
    
#endif /* IPG */
    
/* BJM: What if the number of spin-echo slices cannot fit into the GRE TR?? */
/* compensate here...*/

    {
        int tminSeRef = tmin;
        int actTrSe = act_tr;

        /* Determine of tmin calculated is ok */
        if(tmin < RUP_GRD(non_tetime + refScanTe)) {
           tminSeRef = RUP_GRD(non_tetime + refScanTe);

        } else {

           tminSeRef = tmin;
        }

        /* MRIge78651 - removed divide by zero condition */
        /* Will the slices requested fit work for a SE Ref? */
        if( act_tr < slquant1 * tminSeRef) {

          actTrSe = RUP_GRD(slquant1*tminSeRef) + 1ms;

        } else {

          actTrSe = act_tr;

        }

        /* Actual deadtimes for cardiac scans will be rewritten later */
        if(opcgate==PSD_ON)
            psd_seqtime = RUP_GRD(tminSeRef);
        else
            psd_seqtime = RUP_GRD(actTrSe/slquant1 - time_ssi);
    }

    SEQLENGTH(seqrefcore, psd_seqtime, seqrefcore);

    /* Fill echotrain xtr and rba arrays with SSP pulse structures */
    for (echoloop = 0; echoloop < tot_etl; echoloop++ ) {
        getssppulse(&(echotrainxtr_ref[echoloop]), &(refechotrain[echoloop]), "xtr", 0);
        getssppulse(&(echotrainrba_ref[echoloop]), &(refechotrain[echoloop]), "rba", 0);
    }
    
} /* End if(se_ref == PSD_ON) */

/********* End of RefScan Pulsgen Section **************/

@pg refScanDeclPG
STATUS setreadpolarity_ref( void );

/* Declaration of new function for ref scan */
@rsp refScanDecl
STATUS refSpinEcho( void );
STATUS refAsScan( void );
STATUS psdinit_ref( void );
STATUS refloop( void );
STATUS refcore( void );
STATUS dabrbaloadref( void );
STATUS turnOffBlips( INT numblips );

@rsp refScanRsp 
STATUS ref( void )
{
    /* SXZ: turn on/off spin echo reference scan */
    if( oppseq == 1 || se_ref != 1 )
        refAsScan(); 
    else
        refSpinEcho();

    return SUCCESS;
}

/***************************  refSpinEcho  ******************************/
/* This function sets up a "spin-echo" reference scan regardless of the */
/* actual epi scan used to image. */
STATUS refSpinEcho( void )
{

  printdbg("Greetings from REF", debugstate);
  rspent = L_REF;
  rspdda = dda;

  if (cs_sat ==1)    /* Turn on ChemSat Y crusher */
      cstun=1;

  /* call to psdinit function for ref scan */
  psdinit();

  /* baselines */
  rspbas = rhbline;   /* used on blineacq only */

  rspasl = -1;
  rspgy1 = 1;
  rspnex = nex; /*jwg bb changed from 1 to allow averaging*/

  rspesl = -1;
  rspgyc = 0;

  /* pass to use */
  rspacqb = pre_pass;
  rspacq = pre_pass + 1;

  /* slice to use - closest to isocenter */
  rspslqb = pre_slice;
  rspslq = pre_slice + 1;

  /* phase to use */
  rspprp = 1;
  rsprep = 1;
 
  /* Turn off the phase encode axis - this function 0s the blips and prephaser */
  /* of the reference sequence */
  turnOffBlips(etl);

  /* ref_mode: set up the looping based on ref_mode */
  /* ref_mode = 0 -> loop over all slices prescribed */
  if(ref_mode == 0) { 
      
      /* passes */
      rspacqb = 0;  
      rspacq = acqs;
      
      /* slices */
      rspslqb = 0;
      rspslq = slquant1;
      
  } 
  
  /* ref_mode = 1 ->  acquire all the slices up to the slice closest to isocenter then stop */
  if(ref_mode == 1) { 
      
      /* passes */
      rspacqb = pre_pass;
      rspacq = pre_pass + 1;
      
      /* slices */
      rspslqb = 0;
      rspslq = pre_slice+1;
      
  }
  
  /* ref_mode = 2 -> acquire the slice closet to isocenter only */
  if(ref_mode == 2) {  
      
      /* passes */
      rspacqb = pre_pass;
      rspacq = pre_pass + 1;
      
      /* slices */
      rspslqb = pre_slice;
      rspslq = pre_slice+1;
  }
  
  /* rhpctemporal: which temporal phase to use for ref scan. 0 = first rep of sequence */
  if(rhpctemporal == 0) {
      
      /* Which phase loop to use */   
      if ( (mph_flag==1) && (acqmode==0) )
          rspprp = pass_reps;
      if ( (mph_flag==1) && (acqmode==1) )
          rsprep =  reps;
      
  } else if (rhpctemporal != 0 ) {
      
      /* rep to use */
      rsprep = rhpctemporal;
      
  } 

  /* rhpcileave: determine which interleaves */
  /* to use for multi-shot.  0 = all interleaves */
  if (rhpcileave == 0) {
      rspilv = intleaves;
  } else {
      rspilv = 1;
  }

  refloop();
  rspexit();

  return SUCCESS;
}

/***************************  RefAsScan  *******************************/
/* This function uses the same pulses used in the "scan" portion of the */
/* of the epi sequence.  Thus, if the scan is a gradient echo, the ref  */
/* scan will be gradient echo...This is a simple way to go back to the  */
/* previous implementation....*/
STATUS refAsScan( void )
{
  printdbg("Greetings from REF", debugstate);
  rspent = L_REF;
  rspdda = dda;
  if (cs_sat ==1)  /* Turn on ChemSat Y crusher */
      cstun=1;
  psdinit();

  /* baselines */
  rspbas = rhbline;   /* used on blineacq only */

  rspasl = -1;
  rspgy1 = 1;
  rspnex = nex; /*jwg bb changed from 1 to allow averaging*/

  rspesl = -1;
  rspgyc = 0;

  /* pass to use */
  rspacqb = pre_pass;
  rspacq = pre_pass + 1;

  /* slice to use - closest to isocenter */
  rspslqb = pre_slice;
  rspslq = pre_slice + 1;

  /* phase to use */
  rspprp = 1;
  rsprep = 1;

  ygradctrl(rspgyc, gyb_amp, etl);

  /* ref_mode: set up the looping based on ref_mode */
  /* ref_mode = 0 -> loop over all slices prescribed */
  if(ref_mode == 0) { 
      
      /* passes */
      rspacqb = 0;  
      rspacq = acqs;
      
      /* slices */
      rspslqb = 0;
      rspslq = slquant1;
      
  } 
  
  /* ref_mode = 1 ->  acquire all the slices up to the slice closest to isocenter then stop */
  if(ref_mode == 1) { 
      
      /* passes */
      rspacqb = pre_pass;
      rspacq = pre_pass + 1;
      
      /* slices */
      rspslqb = 0;
      rspslq = pre_slice+1;
      
  }
  
  /* ref_mode = 2 -> acquire the slice closet to isocenter only */
  if(ref_mode == 2) {  
      
      /* passes */
      rspacqb = pre_pass;
      rspacq = pre_pass + 1;
      
      /* slices */
      rspslqb = pre_slice;
      rspslq = pre_slice+1;
  }
  
  /* rhpctemporal: which temporal phase to use for ref scan. 0 = first rep of sequence */
  if(rhpctemporal == 0) {
      
      /* Which phase loop to use */   
      if ( (mph_flag==1) && (acqmode==0) )
          rspprp = pass_reps;
      if ( (mph_flag==1) && (acqmode==1) )
          rsprep =  reps;
      
  } else if (rhpctemporal != 0 ) {
      
      /* rep to use */
      rsprep = rhpctemporal;
      
  } 

  /* rhpcileave: determine which interleaves */
  /* to use for multi-shot.  0 = all interleaves */
  if (rhpcileave == 0) {
      rspilv = intleaves;
  } else {
      rspilv = 1;
  }

  scanloop();
  rspexit();

  return SUCCESS;
}

STATUS
#ifdef __STDC__ 
psdinit_ref( void )
#else /* !__STDC__ */
psdinit_ref() 
#endif /* __STDC__ */
{
    int icnt;
    float *refdata = NULL;  /* MRIge55996 - Changed array from static to dynamic */
    int refdata_size;
    int refdata_offset;

    strcpy(psdexitarg.text_arg, "psdinit_ref");  /* reset global error variable */

    timedelta = 0;

    /*
     * MRIge55996 - Allocate and initialize refdata array.
     */
    /* Set refdata array size and offset */
    if( rhpcspacial == 0 )  {

        refdata_size = 1024 * opslquant;
        refdata_offset = 1024;

    } else {

        refdata_size = 1024;
        refdata_offset = 0;
    }

    /* Allocate the needed memory for refdata */
    refdata = (float *)AllocNode( refdata_size * sizeof(float) );
    if( NULL == refdata )
    {
        psdexit( EM_PSD_ALLOC, 0, "", "PSD init entry point", 0 );
    }
    else
    {
        /* MRIge54033 - Zero entire array */
        for( icnt = 0; icnt < refdata_size; icnt++ )
        {
            refdata[icnt] = 0.0;
        }
    }

    if (RefDatCorrection == PSD_OFF)
    {
        int slc;

        /* No need to calculate refdattime */
        for( slc = 0; slc < opslquant; slc++ ) {
            refdattime[slc] = 0.0;
        }

    }

    /*
     * MRIge55996 - Free refdata array.
     */
    if ( NULL != refdata ) {
        FreeNode( refdata );
    }

    setrfconfig((short)rfconf);

    /* Clear the SSI routine. */
    if (opsat == PSD_ON)
        ssivector(ssisat, FALSE);
    else 
        ssivector(dummyssi, FALSE);

    /* turn off dithering */
    setditherrsp(dither_control,dither_value);

    /* Set ssi time.  This is time from eos to start of sequence interrupt
       in internal triggering.  The minimum time is 50us plus 2us*(number of
       waveform and instruction words modified in the update queue).
       Needs to be done per entry point. */
    setssitime((LONG)time_ssi/GRAD_UPDATE_TIME);

    scopeon(&seqrefcore);    /* reset all scope triggers */  
    syncon(&seqrefcore);     /* reset all synchronizations, not needed in pass */

    /* Inform the Tgt of the location of the trigger arrays. */
    settriggerarray((short)(opslquant*opphases), rsptrigger);

    /* Inform the Tgt of the rotation matrix array to be used */
    setrotatearray((short)(opslquant*opphases), rsprot[0]);

    pass = 0;
    pass_index = 0;
    rspacqb = 0;
    rspacq = acqs;
    rspprp = pass_reps;

    /* DAB initialization */
    dabop = 0;    /* Store data */
    dabecho = 0;  /* first dab packet is for echo 0 */

    /* use the autoincrement echo feature for subsequent echos */
    dabecho_multi = -1;

    rspgyc = gyctrl;
    rspslqb = 0;
    rspslq = slquant1;
    rspilvb = 0;
    rspilv = intleaves;
    rspbasb = 1;

    /* Update the exciter freq/phase tables */
    ref_switch = 1;

    xtr = 0.0;
    frt = frtime;

    /* BJM: MRIge54033
       refdattime now passed as array (one entry for each slice) */
    epiRecvFrqPhs( opslquant, intleaves, etl, xtr-timedelta,
                   refdattime, frt, opfov, opyres, opphasefov,
                   b0ditherval, rf_phase_spgr, dro, dpo, rsp_info, view1st,
                   viewskip, gradpol, ref_switch = (rspent==L_REF ? 1:0),
                   ky_dir, dc_chop, pepolar, recv_freq, recv_phase_angle,
                   recv_phase, gldelayfval, a_gxw, debugRecvFrqPhs,
                   ref_with_xoffset, 1.0, iref_etl );

    /* Call MaxwellCorrection Function (see epiMaxwellCorrection.e) */
    if( epiMaxwellCorrection() == FAILURE) return FAILURE; 

    ref_switch = 0; 
    rspe1st = 0;
    rspetot = tot_etl;

    /* Call to set filter in HSDAB packet for EPI */ 
    setEpifilter(scanslot,&hyperdabref); 

    return SUCCESS;  

} /* End psdinit_ref */

/*************************** SCANLOOP *******************************/
STATUS refloop( void )
{
    int pause; /* pause attribute storage loc */

    printdbg("Greetings from RefScan", debugstate);

    setiamp(ia_rf1, &rf1ref, 0);   /* Reset amplitudes */
    setiamp(ia_rf2, &rf2ref, 0);

    /* Turning spatial & chem SAT on */ 
    SpSat_Saton(0);

    if (cs_sat > 0)  
        setiamp(ia_rfcssat, &rfcssat, 0);

    strcpy(psdexitarg.text_arg, "scan");

    for (pass_rep = 0; pass_rep < rspprp; pass_rep++) {
        for (pass = rspacqb; pass < rspacq; pass++) {

            pass_index = pass + pass_rep*rspacq;

            boffset(off_seqrefcore);

            /* MRIge53529: initialize wait time and pass packet for disdacqs, etc.*/
            setwamp(SSPDS, &pass_pulseref, 0);
            setwamp(SSPD, &pass_pulseref, 2);
            setwamp(SSPDS, &pass_pulseref, 4);
            setperiod(1, &ssp_pass_delayref, 0);
            pause = MAY_PAUSE;
            printdbg("Pre core(): Null ssp pass packet", debugstate);

            refcore(); /* acquire the data */

            /* Return to standard trigger array and core offset */
            settriggerarray((SHORT)(opslquant*opphases), rsptrigger);

        } /* end pass loop */
    } /* end pass_rep loop */

    printdbg("Normal End of REF SCAN", debugstate);

    return SUCCESS;

} /* End REFLOOP */

/*****************************  REFCORE  *************************/
STATUS refcore( void )
{
    int pause = MAY_PAUSE;

    if (rspdda > 0) {

        acq_data = (int)DABOFF;
        dabrbaloadref();   

        setperiod((int)tf[0], &wgx, 0);
        setperiod((int)tf[0], &wgy, 0);
        setperiod((int)tf[0], &wgz, 0);
        setperiod((int)tf[0], &wssp, 0);
        setperiod((int)tf[0], &womega, 0);

        for (ileave = rspdda - 1; ileave >= 0; ileave--) {

            /* The % accounts for the case when dda > intleaves */
            if (rf_chop == PSD_ON && rspnex <= 1
%ifdef RT
                && intleaves > 1
%endif
                )
                setiamp(-rfpol[ileave % intleaves], &rf1ref, 0);
            else
                setiamp(rfpol[ileave % intleaves], &rf1ref, 0);

            for (slice = rspslqb; slice < rspslq; slice++) {    

                if (acqmode==0) /* interleaved */
                    sliceindex = (acq_ptr[pass_index] + slice)%opslquant;

                if (acqmode==1) /* sequential */
                    sliceindex = acq_ptr[pass_index];

                if (ss_rf1 == PSD_ON) {
                    if (fat_flag == PSD_ON)
                        rf1_freq[sliceindex] = fat_offset;
                    else
                        rf1_freq[sliceindex] = 0;      
                    setiampall(theta_freq[sliceindex], &thetarf1ref, 0);
                }

                setfrequency(rf1_freq[sliceindex], &rf1ref, 0);
                setfrequency(rf2_freq[sliceindex], &rf2ref, 0);
                startseq((short)sliceindex, (SHORT)MAY_PAUSE);

            } /* for slice= 0 */

        } /* for ileave = 0 */

    } /* if rspdda > 0 */

    /******* end disdaq block ***********************************/

    for (core_rep = 0; core_rep < rsprep; core_rep++) {
        for (ileave = rspilvb; ileave < rspilv; ileave++) {

            /* set sliding ssp/readout/phase/slice */
            setperiod((int)tf[ileave], &wgxref, 0);
            setperiod((int)tf[ileave], &wgyref, 0);
            setperiod((int)tf[ileave], &wgzref, 0);
            setperiod((int)tf[ileave], &wsspref, 0);
            setperiod((int)tf[ileave], &womegaref, 0);

            for (excitation=1-rspdex; excitation <= rspnex; excitation++) {

                if (rf_chop == PSD_ON && excitation % 2 == 0)
                    setiamp(-rfpol[ileave], &rf1ref, 0);  /* even excitation */
                else
                    setiamp(rfpol[ileave], &rf1ref, 0);   /* odd excitation */

                for (slice = rspslqb; slice < rspslq; slice++) {    

                    /* Determine which slice(s) to excite (find spot in 
                       rspinfo table) */
                    /* Remember slices & passes start at 0 */

                    if (acqmode==0) /* interleaved */
                        sliceindex = (acq_ptr[pass_index] + slice)%opslquant;

                    if (acqmode==1) /* sequential */
                        sliceindex = acq_ptr[pass_index];

                    if (( rspasl == -1) && (excitation > 0))
                        acq_data = (int)DABON;
                    else
                        acq_data = (int)DABOFF;

                    /* Set the rf pulse transmit frequencies */
                    if (ss_rf1 == PSD_ON) {
                        if (fat_flag == PSD_ON)
                            rf1_freq[sliceindex] = fat_offset;
                        else
                            rf1_freq[sliceindex] = 0;      
                        setiampall(theta_freq[sliceindex], &thetarf1ref, 0);
                    }

                    setfrequency(rf1_freq[sliceindex], &rf1ref, 0);
                    setfrequency(rf2_freq[sliceindex], &rf2ref, 0);

                    if (excitation == 1)
                    {
                        dabop = 0;
                    }
                    else if (rf_chop == PSD_OFF)
                    {
                        dabop = 1;
                    }
                    else
                    {
                        dabop = 3 - 2*(excitation % 2);
                    }
                    
                    slicerep = slice + core_rep*rspslq;
                    
                    if(setDataAcqDelays == PSD_ON) {
                        /* Update the delay on the SSP and Omega boards */
                        setperiod((int)((float)gldelaycval[sliceindex] + pw_sspdelay),
                                  &sspdelayref, 0);
                        
                        setperiod(RUP_RF((int)((float)gldelaycval[sliceindex] +
                                               pw_omegadelay)), &omegadelayref, 0);
                        
                        setperiod((int)((float)(pw_sspshift - gldelaycval[sliceindex])),
                                  &sspshiftref, 0);
                    }
                    
                    /* mod_rba = FALSE; */
                    dabrbaloadref();
                    
                    /* play out pass delay and send proper pass packet within seqcore.  We do
                       this to avoid having to play out a seperate pass sequence as is usually
                       done */
                    if ( (pass == (rspacq - 1)) && (pass_rep == (rspprp - 1)) &&
                         (slice == rspslq-1) && (excitation == rspnex) && 
                         (ileave == rspilv-1) && (core_rep == rsprep-1) ) {
                        
                        /* Set DAB pass packet to end of scan */
                        setwamp(SSPDS + DABDC, &pass_pulseref, 0);
                        setwamp(SSPD + DABPASS + DABSCAN, &pass_pulseref, 2);
                        setwamp(SSPDS + DABDC, &pass_pulseref, 4);
                        setperiod(1, &ssp_pass_delayref, 0);
                        pause = MAY_PAUSE;
                        printdbg("End of Scan and Pass", debugstate);
                        
                    } else if ( (slice == rspslq-1) && (excitation == rspnex) && 
                                (ileave == rspilv-1) && (core_rep == rsprep-1) ) {

                        /* Set DAB pass packet to end of pass */
                        setwamp(SSPDS + DABDC, &pass_pulseref, 0);
                        setwamp(SSPD + DABPASS, &pass_pulseref, 2);
                        setwamp(SSPDS + DABDC, &pass_pulseref, 4);
                        setperiod(1, &ssp_pass_delayref, 0);
                        pause = AUTO_PAUSE;
                        printdbg("End of Pass", debugstate);
                      
                    } else {

                        /* send null pass packet and use the minimum delay for pass_delay */
                        setwamp(SSPDS, &pass_pulseref, 0);
                        setwamp(SSPD, &pass_pulseref, 2);
                        setwamp(SSPDS, &pass_pulseref, 4);
                        setperiod(1, &ssp_pass_delayref, 0);
                        pause = MAY_PAUSE;
                        printdbg("Null ssp pass packet", debugstate);
                    }

                    startseq((short)sliceindex, (SHORT)pause);

                    syncoff(&seqrefcore); 
                }  /* slice */

            } /* excitation */

        } /* ileave */

    } /* core_rep */

    return SUCCESS;  

} /* End Ref Core */

/***************************** dabrbaloadref *************************/
STATUS dabrbaloadref(void)
{
    TYPDAB_PACKETS dabacqctrl;
    int echo;  /* loop counter */
    int freq_ctrl = 0;
    int phase_ctrl = 0;

    dabacqctrl = (TYPDAB_PACKETS)acq_data;
    loadhsdab(&hyperdabref,   /* load hyperdab */
              (LONG)slicerep,
              (LONG)0,
              (LONG)dabop,
              (LONG)view1st[ileave],
              (LONG)viewskip[ileave],
              (LONG)tot_etl,
              (LONG)1,
              (LONG)1,
              dabacqctrl,
              (LONG)hsdabmask);

    /* Load the receive frequency/phase and dab packets */
    for (echo=0; echo<tot_etl; echo++) {

        /* MRIge56894 - only set this stuff during real data acq */
        if(acq_data != DABOFF) { 
            /* BJM: we set the demod freq (sl_rcvcf) in the freq offset */
            /* register and then use omega to offset the slice along */
            /* the read axis.  For non-ramp sampled cases, the offset */
            /* waveform is a constant pulse.  For ramp sampled waveforms */
            /* the offset freq wavefrom is a trapezoid (freq mod on ramps */
            /* This simplifies the phase accumulation across the echo since */
            /* we no longer have to worry about the time it takes to latch */
            /* a freq. offset which leads to an uncertainty in how long we */
            /* accumulate phase across each echo in the train */

            freq_ctrl = sl_rcvcf;
            phase_ctrl = recv_phase[sliceindex][ileave][echo];

            /* load demod. frequnecy in packet xtr packet */
            setfreqphase(freq_ctrl,
                         phase_ctrl,
                         echotrainxtr_ref[echo]);

            /* frequency offset */ 
            tempamp=(short)((recv_freq[sliceindex][ileave][echo]-sl_rcvcf)/omega_scale);

            if (vrgfsamp) {

                /* offset waveform (omega) is a trapezoid */        
                setiampt(tempamp, &omega_flatref, echo);

            } else {

                /* simple constant offset waveform */
                setiamp(tempamp, &omega_flatref, echo);

            }

        } /* end acq_data condition */

        /* determine which echos will be collected */
        if ((echo >= rspe1st) && (echo < rspe1st + rspetot))
            dabacqctrl = (TYPDAB_PACKETS)acq_data;
        else
            dabacqctrl = DABOFF;

        /* set RBA bit for echos to acquire */
        acqctrl(dabacqctrl, fast_rec, echotrainrba_ref[echo]);

    } /* end echo loop for setting up xtr & rba packets */  

    return SUCCESS;

} /* End dabrbaloadref */

/***************************** turnOffBlips  *************************/
STATUS turnOffBlips( INT numblips )
{
    int bcnt;  

    /* Blips */
    for (bcnt=0;bcnt<numblips-1;bcnt++)
        setiampt((short)0, &refgyb, bcnt); 

    /* Prephaser */
    setiampt((short)0, &refgy1, 0);

    return SUCCESS;

} /* End turnOffBlips */

@pg refScanFuncsPG

/***************************** setreadpolarity *************************/
STATUS setreadpolarity_ref( void )
{
    int polarity;

    if (iref_etl%2 == 1) {
        polarity = -1;
    }
    else {
        polarity = 1;
    }

    tia_gx1 = polarity*gradpol[ileave]*ia_gx1;  /* temporary x dephaser amp */
    tia_gxw = polarity*gradpol[ileave]*ia_gxw;  /* temporary x readout amp  */
    tia_gxk = polarity*gradpol[ileave]*ia_gxk;  /* temporary x killer amp   */
    setiamp(tia_gx1, &refgx1a, 0);        /* x dephaser attack */
    setiamp(tia_gx1, &refgx1, 0);         /* x dephaser middle */
    setiamp(tia_gx1, &refgx1d, 0);        /* x dephaser decay  */
    setiamp(tia_gxw, &refgxw, 0);

    /* Ramps are handled with opposite sign because of the way they
       are defined in the EP_TRAIN_NAME macro.  Please refer to epic.h
       for more details. */

    for (echo=1; echo < tot_etl; echo++) {
        if ((echo % 2) == 1) {  /* Even echo within interleave */ 
            setiamp(-tia_gxw, &refgxwa, echo-1); /* waveforms go neg to pos in ep_train */
            setiamp(-tia_gxw, &refgxwd, echo-1);
            setiamp(-tia_gxw, &refgxw, echo);    /* const   */
        } else {                    /* Odd echo within interleave */
            setiamp(tia_gxw, &refgxwa, echo-1); /* waveforms go neg to pos in ep_train */
            setiamp(tia_gxw, &refgxwd, echo-1);
            setiamp(tia_gxw, &refgxw, echo);     /* flattop   */
        }
    }


    if ((tot_etl % 2) == 1) {

        setiamp(-tia_gxw,&refgxwde, 0);  /* decay,end */

        if (eosxkiller == 1) {
            setiamp(-tia_gxk,&refgxka, 0);   /* killer attack */
            setiamp(-tia_gxk,&refgxk, 0);    /* killer flattop */
            setiamp(-tia_gxk,&refgxkd, 0);   /* killer decay  */
        }

    } else {

        setiamp(tia_gxw,&refgxwde, 0);   /* decay,end */

        if (eosxkiller == 1) {
            setiamp(tia_gxk,&refgxka, 0);    /* killer attack */
            setiamp(tia_gxk,&refgxk, 0);     /* killer flattop */
            setiamp(tia_gxk,&refgxkd, 0);    /* killer decay  */
        }
    }

    return SUCCESS;

} /* end setreadpolarity_ref() */


/**** END of refScan.e File ****/
