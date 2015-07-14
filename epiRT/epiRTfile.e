/*
 *  GE Medical Systems
 *  Copyright (C) 1997 The General Electric Company
 *  
 *  epiRTfile.e
 *  
 *  Contains epiRT inline code
 *  
 *  Language : ANSI C
 *  Author   : Bryan Mock
 *  Date     : 5/10/01
 */


/* do not edit anything above this line */

/* ***********************************************************************************************
 rev     date        comments
 ----  -----------   --------------------------------------------------

 20.0  06/10/2008 SWL MRIhc35951: The removal of SPSP RF pulse 3024850 caused minimum slice 
                                  thickness increased. The pull down menu for slice thickness 
                                  was adjusted. 

 20.1  12/09/2008  GW MRIhc40248: Added maximum #images check for fMRI

*************************************************************************************************/                                  

@global RTincludes
/* New Code Section ***********************************************/
/* This section of code contains include files for RT scanning    */
#include <RT.h>
#include <RT_rspupdate.h>

#ifdef PSD_HW
#include "op_global.h"
/* Needed to define structures */
#define USE_RSP_CM_DEFINITIONS
#include "tps_rsp_recon.h"
#include "Tps_Rsp.h"
#endif /* PSD_HW */

#define MAXIMAGES_RESEARCH 200000
#define MAXIMAGES_CLINICAL 50000

@cv epiRT_CV
/* New Code Section ***********************************************/
/* This section of code contains all the epiRT specific CV's      */

int RTIP_test = 0 with {0,1,0,VIS,"RTIP mode flag",};
float percent_dither = 0.85 with {0,1.0,0.85,VIS, "Dither % of Flip for RTIP Testing",};
int pw_TTLpack = 3us;    /* Duration of the SSP packet for fMRI device */
int TTLtime_tot = 1003us; /* add 3us to count TTLpack */
int pos_start_TTLON = 0;
int pw_eegpack = 3us;       /* and EEG blanking control */
int eegtime_tot = 1003us;  /* add 3us to count eegpack */
int pos_start_eegON = 0;
int RT_DEBUG = 0 with {0,1,1,VIS, "RT_DEBUG statement",};
int timerstamp_res = 0 with {0, 1, 0, INVIS, "fMRI timestamp resolution: 0: 100us, 1: 1us",};
/* BJM added for epiRT support */
int ase_offset = 0 with {-100,100,0,VIS, "ASE: 180 offset (ms)",};

/* Real-time bore temperature monitoring CVs */
int btemp_debug = 0 with {0,1,0,VIS,"Print out bore temperature to TGT",};
int btemp_monitor = 1 with {0,1,1,VIS,"Monitor bore temperature in RT mode",};
int minSeqCoilAdjust = 1 with {0,1,1,VIS,"fMRI Coil Heating Adjustment Flag",};
int enable_TTL = 1 with {0,1,1,VIS,"fMRI: enable TTL pulse",};
int enable_eegblank = 0 with {0,1,1,VIS,"fMRI: enable eeg blank pulse",};


@host epiRTfuncs
/* New Code Section ***********************************************/
/* This section of code contains function prototypes              */

STATUS lim_protocol(void);
STATUS checkAPConfig( int );

@host epiRT_UserCV

/* New Code Section ***********************************************/
/* This section of code sets up the userCV page for an epiRT scan */

/* BJM: set up fMRI parameters based on fMRI feature flag */
if(exist(opfmri)==PSD_ON){   
 
    /* BJM: PSD Trigger Type, (External of Internal) */
    cvmod(oppsd_trig, 0.0, 1., 0.0, "PSD Trigger: 0 = internal, 1 = external (J7)",0," "); 
    
    /* oppsd_trig range check for fmri */
    if(( existcv(oppsd_trig) && ((exist(oppsd_trig) > 1) || (exist(oppsd_trig) < 0)))) {
        strcpy(estr, " Invalid psd_trig entry - select again... ");
        epic_error(0,estr,EM_PSD_INVALID_RX, 0);
        return FAILURE;
    }


    /* BJM: asymmetric spin-echo acq. setup (only for SE-EPI) */
    opuser3 = 0.0;                 /* Asymmetric Spin-Echo Tau Offset (ms) */
    cvmod(opuser3, 0.0, 50.0, 0.0, "Asymmetric SE: 180->90 position shift (ms)",0," ");
    
    /* opuser3 range check */
    if( existcv(opuser3) && ((exist(opuser3) > 50) || (exist(opuser3) < 0.0))) {
        strcpy(estr, "%s is out of range.");
        epic_error(use_ermes,estr,EM_PSD_CV_OUT_OF_RANGE, EE_ARGS(1), STRING_ARG, "Asymmetric SE" );
        return FAILURE; 
    } 

    /* Invert offset to move 180 back towards 90 */     
    if(oppseq == PSD_SE) {
        ase_offset = (int)exist(opuser3); 
        ase_offset*= -1;
    } else {
        ase_offset = 0;   /* dont move 180 */
    }


    /* Dummy Acq. control to remove the non-steady state signal */
    /* from the beg. of an fMRI experiment */
    cvmod(opdda, 0., 50., 4., "# of RTC Dummy Acqs",0," "); 
    
    /* opdda range check for fmri*/
    if(( existcv(opdda) && ((exist(opdda) > 50) || (exist(opdda) < 0)))) {
        strcpy(estr, " Invalid Dummy Acq. entry - select again... ");
        epic_error(0,estr,EM_PSD_INVALID_RX, 0);
        return FAILURE;
    }

    /* State variable used to communicate the initial task state to */
    /* to the RSP section so the PSD can fill the ws user cv with   */
    /* a 0 (off) or a 1 (on) to describe the task state */
    
    cvmod(opinit_state, 0., 1., 0., "Initial State (0 = Base, 1 = Stim)",0," ");
    
    /* opinist_state range check for fmri */
    if(( existcv(opinit_state) && ((exist(opinit_state) > 1) || (exist(opinit_state) < 0)))) {
        strcpy(estr, " Invalid Initial State entry - select again... ");
        epic_error(0,estr,EM_PSD_INVALID_RX, 0);
        return FAILURE;
    }

    /* Number of images in the "baseline" (OFF) state */

    cvmod(oprep_rest, 1., 128., 10., "Baseline Duration (# of images)",0," ");
    
    /* opuser7 range check */
    if(( existcv(oprep_rest) && ((exist(oprep_rest) > 128) || (exist(oprep_rest) < 1)))) {
        strcpy(estr, " Invalid Rest Repetition entry - select again... ");
        epic_error(0,estr,EM_PSD_INVALID_RX, 0);
        return FAILURE;
    }

    /* Number of images in the "activation" (ON) state */

    cvmod(oprep_active, 1., 128., 10., "Stimulation Duration (# of images)",0," ");

    /* active range check */
    if(( existcv(oprep_active) && ((exist(oprep_active) > 128) || (exist(oprep_active) < 1)))) {
        strcpy(estr, " Invalid Active Repetition entry - select again... ");
        epic_error(0,estr,EM_PSD_INVALID_RX, 0);
        return FAILURE;
    }

    /* Total number of images (per slice) in scan */

    cvmod(opfphases, 1.,30000., 1., "Scan Duration (Imgs per Loc)",0," "); 

    /* phases range check */
    if((existcv(opfphases) && ((exist(opfphases) >30000) || (exist(opfphases) < 1)))) {
        strcpy(estr, " Invalid number of images (per slice)  entry - select again... ");
        epic_error(0,estr,EM_PSD_INVALID_RX, 0);
        return FAILURE;
    }

#ifdef NOT_USED_PRESENTLY 

    opuser10 = 0.0;
    cvmod(opuser10, 0., 1., 0., "RTIP Test Mode (0 = off)",0," ");
    RTIP_test = (INT)exist(opuser10);
    
    /* opuser10 range check */
    if( existcv(opuser10) && ((exist(opuser10) >1) || (exist(opuser10) < 0))) {
        strcpy(estr, " Invalid opuser10 entry - select again... ");
        epic_error(0,estr,EM_PSD_INVALID_RX, 0);
        return FAILURE;
    }


#endif     

    /* Setup delay after each slice package (after a pass) */    
    cvmod(opsldelay, 0, 10s,1us, "Delay after each slice package (us)",0," ");
    
    if(( existcv(opsldelay) && ( (exist(opsldelay) < 0) || (exist(opsldelay) > 10s) ) )) {
        sprintf(estr, "Please select a delay 0 - 10s");
        epic_error(0,estr,EM_PSD_INVALID_RX, 0);
        return FAILURE;
    }

    /* Add ASE button is SE EPI */
    if(exist(oppseq) == PSD_SE) {
        piuset |= use3;
    } else {
        piuset &= ~use3;
    }
    
/* Monitor bore temperature for hardware only. */
#ifdef PSD_HW 
    btemp_monitor = 1;
#else
    btemp_monitor = 0;
#endif /* PSD_HW */

} /* end if(opfmri = ON) */

@host epiRTErrorCheck
/* New Code Section ***********************************************/
/* This section of code contains error messages specific to epiRT */

#ifndef SIM
  if ((checkOptionKey( SOK_BRNWAVRT ) != 0) && exist(opfmri) == PSD_ON && existcv(opfmri) ) { 
      epic_error(use_ermes,"This prescription is not allowed", EM_PSD_INVALID_RX, EE_ARGS(0));
      return FAILURE;
  }
#endif

  if( exist(opfmri) != PSD_ON && existcv(opfmri))
  {
      epic_error(use_ermes,"The %s option must be selected with %s",
                 EM_PSD_IMGOPT_PSD,2,STRING_ARG,"fMRI",STRING_ARG,"GradEcho EPI");
      return FAILURE;
  }

  /* BJM: MRIge90420 */
  if( (exist(opfmri) == PSD_ON) && (exist(opptsize) == 4))
  {
      epic_error(use_ermes,"EDR is not supported in this PSD.",
                 EM_PSD_EDR_INCOMPATIBLE,0);
      return FAILURE;
  }

  /* BJM: add error check to ASE */
  if((exist(oppseq) == PSD_SE) && exist(opte) && (abs(ase_offset) > 0.0) )
  {
    INT halfte = (INT)(exist(opte)/2.0);
    INT abs_ase = (INT)abs(1000*ase_offset);  /* convert to us */
    INT echoOffset, maxposoffset, maxnegoffset;
 
    if (fract_ky == PSD_FRACT_KY) {
	echoOffset  = num_overscan/intleaves;
    } else {
	if (ky_dir == PSD_TOP_DOWN || ky_dir == PSD_BOTTOM_UP)
	  echoOffset  = (opyres/intleaves)/2;
	else
	  echoOffset  = 0;
    }

    /* limit position of 180 offset to lie between gz1 and gx1 - round to nearest ms */
    maxposoffset = (int)(1000.*floor((halfte - echoOffset*esp - ky_offset*esp/intleaves - 
                (pw_gxwad + pw_gx1a + pw_gx1 + pw_gx1d))/1000.0));

    maxnegoffset = (int)(1000.*floor((halfte - (rfExIso + pw_gzrf1d + 
                         pw_gzrf2l1_tot + pw_gz1_tot + pw_gzrf2/2.0))/1000.0));
    
    /* Offset towards the 90 (always) - check to see we have't pulled it back too far*/
    if ( abs_ase  > maxnegoffset) { 
        epic_error(0, "ASE offset out of range - reduce the ASE offset or increase TE", 0, 0 );
        return FAILURE;
    }

if( RT_DEBUG) {
       printf("ASE maxoffset = %d\n", maxposoffset);
       printf("    echoOffset = %d\n", echoOffset);
       printf("    half TE = %d\n", halfte);
       printf("    maxnegoffset = %d\n", maxnegoffset);
       printf("    abs_se = %d\n", abs_ase);
       printf("    ase_offset = %d\n", ase_offset);
       fflush(stdout);
}

  } /* end ASE check */ 


@host limProtocolFunc
/* New Code Section ************************************************/
/* This section of code contains the lim_protocol() function which */
/* is used to limit the prescription interface when prescrbing     */
/* epi_gre_64,etc. type protocols via a type in */

STATUS 
lim_protocol( void )
{
    INT skip_protocol_checks = FALSE;
    INT noFpsLimitFlag = FALSE;
    FILE *fp = NULL;

    int rtperftest = FALSE;

    /* If file exists enable performance test mode */
    fp = fopen("/usr/g/bin/.epiRTPerfTest", "r");
    if( NULL != fp )
    {
        rtperftest = TRUE;
        fclose(fp);
    }

    /* With DVMR receive chain hardware, there is no frames per second
     * restriction. Remove restrictions if performance testing. */
    if( (PSDDVMR == psd_board_type)
        || rtperftest )
    {
        noFpsLimitFlag = TRUE;
    } 
    else
    {
        noFpsLimitFlag = FALSE;
    }

    /* Disable bore temperature monitor when performance testing on
     * non-XRM gradient coils. */
    if( (PSD_XRMB_COIL != cfgcoiltype)
        && (PSD_XRMW_COIL != cfgcoiltype)
        && rtperftest )
    {
        btemp_monitor = 0;
    }

    /* Thoralf Niendorf GEMSE 22.11.2000: number of shots init*/

    pishotnub = 1 + 2 + 4 + 8; /* display "other" + 3 shot buttons (bitmask)*/
    pishotval2 = 1;
    pishotval3 = 2;
    pishotval4 = 4;

    /* Thoralf Niendorf GEMSE 22.11.2000: TR init*/
    pitrnub = 6;
    pitrval2 = 1000ms;
    pitrval3 = 1500ms;
    pitrval4 = 2000ms;
    pitrval5 = 2500ms;
    pitrval6 = 3000ms;
    avmaxtr = 10000ms;
    cvdef(optr, 5000ms);
    optr = 5000ms;

    /*Thoralf Niendorf GEMSE 22.11.2000: Floating FOV init*/
    pifovnub = 6;
    pifovval2 = 200;
    pifovval3 = 220;
    pifovval4 = 240;
    pifovval5 = 260;
    pifovval6 = 280;

    /*Thoralf Niendorf GEMSE 22.11.2000: Slice Thickness's init*/
    pistnub = 5;
    pistval2 = 3;
    pistval3 = 5;
    pistval4 = 7;
    pistval5 = 10;

    if (PSD_SR200 == cfsrmode) 
    {
        if (ss_rf1 == PSD_ON)
        {  
            pistnub = 6; 
            pistval2 = 4; 
            pistval3 = 5; 
            pistval4 = 6; 
            pistval5 = 7; 
            pistval6 = 10; 
        }
        else
        {
            pistnub = 6; 
            pistval2 = 2; 
            pistval3 = 3; 
            pistval4 = 4; 
            pistval5 = 7; 
            pistval6 = 10; 
        }
    }

    /* Remove interleave slice spacing */
    piisil = PSD_OFF;

    avmaxslthick = 20;
    cvdef(opslthick,5);

    /* nex */
    pinexnub = 2;
    pinexval2 = 1;
    avminnex = 1;
    avmaxnex = 1;

    /* fmri */
    avminrep_rest = 1;
    avmaxrep_rest = 128;
    avminrep_active = 1;
    avmaxrep_active = 128;
    avmin_dda = 0;
    avmax_dda = 50;

    /* Thoralf Niendorf GEMSE 22.11.2000: phase fov init */
    piphasfovnub2 = 1 + 2 + 4;
    piphasfovval2 = 1.0;
    piphasfovval3 = 0.75;
    cvdef(opphasefov,1.0);
    avminphasefov = 0.75;
    avmaxphasefov = 1.0;
    opphasefov = 1.0;

    /* Thoralf Niendorf GEMSE 22.11.2000: xres init */
    pixresnub = 63; /*bitmask*/
    pixresval2 = 64;
    pixresval3 = 96;
    pixresval4 = 128;
    pixresval5 = 192;
    pixresval6 = 256;
    cvdef(opxres,64);
    avminxres = 64;
    avmaxxres = 256;

    /* Thoralf Niendorf GEMSE 22.11.2000: yres init */
    piyresnub = 63;  /*bitmask*/
    piyresval2 = 64;
    piyresval3 = 96;
    piyresval4 = 128;
    piyresval5 = 192;
    piyresval6 = 256;
    cvdef(opyres,64);
    avminyres = 64;
    avmaxyres = 256;
 
    /* Turn off concat sat.  Leave sat page enabled so chem sat  */
    /* can be selected */
    piccsatnub = 0;

    /* BJM: skip limits if epiRT is the psdname */
    if ((!strcmp("epiRT",psd_name)) || (!strcmp("EPIRT",psd_name))) {
        skip_protocol_checks = TRUE;
    }

    /* Check for psdname string */
    if((exist(oppseq) == PSD_GE) && (skip_protocol_checks == FALSE) ) {

        /* Thoralf Niendorf GEMSE 22.11.2000: TE  init*/
        pite1nub = 63;
        pite1val2 =  PSD_MINIMUMTE;
        pite1val3 =  PSD_MINFULLTE;
        pite1val4 = 40ms;
        pite1val5 = 45ms;
        pite1val6 = 50ms;
        avmaxte = 120ms;

        /* Thoralf Niendorf GEMSE 18.11. 2000: flip angle init*/
        pifanub = 6;
        pifaval2 = 10;
        pifaval3 = 30;
        pifaval4 = 50;
        pifaval5 = 70;
        pifaval6 = 90;
        cvdef(opflip, 90);
        avminflip=10;
        avmaxflip=90;
        opflip=35;

        if ((!strcmp("epi_gre_64",psd_name)) || (!strcmp("EPI_GRE_64",psd_name))) {

            /* xres */
            pixresnub = 2;
            pixresval2 = 64;
            cvmin(opxres,64);
            cvmax(opxres,64);
            cvdef(opxres,64);
            avmaxxres = 64;    
            avminxres = 64;    

            /* yres */
            piyresnub = 2;
            piyresval2 = 64;
            cvmin(opyres,64);
            cvmax(opyres,64);
            avmaxyres = 64;
            avminyres = 64;  

        } else if ((!strcmp("epi_gre_128",psd_name)) || (!strcmp("EPI_GRE_128",psd_name))) {

            /* xres */
            pixresnub = 2;
            pixresval2 = 128;
            cvmin(opxres,128);
            cvmax(opxres,128);
            cvdef(opxres,128);
            avmaxxres = 128;    
            avminxres = 128;    

            /* yres */
            piyresnub = 2;
            piyresval2 = 128;
            cvmin(opyres,128);
            cvmax(opyres,128);
            avmaxyres = 128;
            avminyres = 128;  

        }         

#ifndef SIM
        /* disallow SE with GRE protocol */
        if ( existcv(optr) && 
             ( (!strcmp("epi_se_64",psd_name)) || (!strcmp("EPI_SE_64",psd_name)) || 
               (!strcmp("epi_se_128",psd_name)) || (!strcmp("EPI_SE_128",psd_name)) ) ) {
            strcpy(estr, " Gradient Echo EPI selected. Protocol mismatch. ");
            epic_error(0,estr,EM_PSD_INVALID_RX, 0);
            return FAILURE;
        }
#endif /* !SIM */
    } 

    if((exist(oppseq) == PSD_SE) && (skip_protocol_checks == FALSE)) {

        /* TE  Thoralf Niendorf GEMSE 22.11.2000*/
        pite1nub = 63;
        pite1val2 = 60ms;
        pite1val3 = 70ms;
        pite1val4 = 80ms;
        pite1val5 = 90ms;
        pite1val6 = 100ms;
        avmaxte = 120ms;
        cvdef(opte, 90ms);

        /* Thoralf Niendorf GEMSE 18.11. 2000: flip angle*/
        pifanub = 2;
        pifaval2 = 90;
        cvdef(opflip, 90);

        if ((!strcmp("epi_se_64",psd_name)) || (!strcmp("EPI_SE_64",psd_name))) {

            /* xres */
            pixresnub = 2;
            pixresval2 = 64;
            cvmin(opxres,64);
            cvmax(opxres,64);
            avminxres = 64;
            avmaxxres = 64;

            /* yres */
            piyresnub = 2;
            piyresval2 = 64;
            cvmin(opyres,64);
            cvmax(opyres,64);
            avminyres = 64;
            avmaxyres = 64;

        } else if ((!strcmp("epi_se_128",psd_name)) || (!strcmp("EPI_SE_128",psd_name))) {

            /* xres */
            pixresnub = 2;
            pixresval2 = 128;
            cvmin(opxres,128);
            cvmax(opxres,128);
            avminxres = 128;
            avmaxxres = 128;

            /* yres */
            piyresnub = 2;
            piyresval2 = 128;
            cvmin(opyres,128);
            cvmax(opyres,128);
            avminyres = 128;
            avmaxyres = 128;

        }

#ifndef SIM
        /* disallow GRE with SE protocol */
        if ( existcv(optr) && 
             ( (!strcmp("epi_gre_64",psd_name)) || (!strcmp("EPI_GRE_64",psd_name)) || 
               (!strcmp("epi_gre_128",psd_name)) || (!strcmp("EPI_GRE_128",psd_name)) ) ) {
            strcpy(estr, " Spin Echo EPI selected. Protocol mismatch. ");
            epic_error(0,estr,EM_PSD_INVALID_RX, 0);
            return FAILURE;
        }
#endif /* !SIM */
    } 

    /* BJM: more protocol limits */

    /* Thoralf Niendorf GEMSE 27.11.2000: Read Out Size check*/
    if( existcv(opxres) && exist(opxres)%32 != 0 )  
    {
        epic_error(use_ermes, 
                   "The nearest valid frequency encoding value is %d.",
                   EM_PSD_XRES_ROUNDING, EE_ARGS(1), INT_ARG,
                   32*(int)((float)opxres/32.0 + 0.50));

        return FAILURE;
    }

    /* Thoralf Niendorf GEMSE 27.11.2000: Phase Encoding Size check*/
    if( existcv(opyres) && exist(opyres)%32 != 0 )
    {
        epic_error(use_ermes, 
                   "The nearest valid phase encoding value is %d.",
                   EM_PSD_YRES_ROUNDING, EE_ARGS(1), INT_ARG,
                   32*(int)((float)opyres/32.0 + 0.50));
        return FAILURE;
    }

    /* BJM: Added RTIP & Recon fps limits for MGD/EXCITE.  Limits are     */
    /* based on either the RTC/RTIP limit or the recon limt from Fred     */
    /* Frigo's recon scorecard. For multi coil EPI > 4 channels w/ vrgf,  */ 
    /* recon is limiting piece.  Otherwise, RTC/RTIP will limit the rate  */
    /* if the desired rate is note faster than simple physics timing will */
    /* permit */

    if (noFpsLimitFlag == FALSE) {   

        INT numcoils =  ((cfrecvend - cfrecvst)+1);
        FLOAT fps_limit = 256.0;  /* limit on fps */
        INT maxDimension;

        maxDimension = IMax(2,exist(opxres), exist(opyres));

        /* MRIhc23089 */

        if  ( maxDimension <= 64 ) {
            
            /* 25 fps limit (1 channel), 20 fps (8 channels) */
            fps_limit = (numcoils > 4) ? 20.0 : 25.0;

            if(((float)avmaxslquant/(float)((float)exist(optr)/1.0e6) > fps_limit)) {
                avmaxslquant = floor(fps_limit*(float)exist(optr)/1.0e6);
                avmintr = (INT)(ceil(1.0e6 * (float)((float)exist(opslquant)/(float)fps_limit))); 
                avmintr = (INT)(ceil((float)avmintr / 1000.0) * 1000.0);
            }

            
if (RT_DEBUG) {
            printf("64x64 FPS check\n");
            printf("fps limit = %f\n", fps_limit);
            printf("avmaxslquant = %d\n", avmaxslquant);
            fflush(stdout);
}

        } else if ( maxDimension <= 128 )  {

            /* 18 fps limit x(1 channel), 13 fps (8 channels) */
            fps_limit = (numcoils > 4) ? 13.0 : 18.0;
           
            if(((float)avmaxslquant/(float)((float)exist(optr)/1.0e6) > fps_limit)) {
                avmaxslquant = floor(fps_limit*(float)exist(optr)/1.0e6);
                avmintr = (INT)(ceil(1.0e6 * (float)((float)exist(opslquant)/(float)fps_limit))); 
                avmintr = (INT)(ceil((float)avmintr / 1000.0) * 1000.0);
            } 
     
if (RT_DEBUG) {
            printf("128x128 FPScheck\n");
            printf("fps limit = %f\n", fps_limit);
            printf("avmaxslquant = %d\n", avmaxslquant);
            fflush(stdout);
}

        } else {
                        
            /* 10 fps limit (1 channel), 5 fps (8 channels) */
            fps_limit = (numcoils > 4) ? 5.0 : 10.0;
           
            if(((float)avmaxslquant/(float)((float)exist(optr)/1.0e6) > fps_limit)) {
                avmaxslquant = floor(fps_limit*(float)exist(optr)/1.0e6);
                avmintr = (INT)(ceil(1.0e6 * (float)((float)exist(opslquant)/(float)fps_limit))); 
                avmintr = (INT)(ceil((float)avmintr / 1000.0) * 1000.0);
            } 

if (RT_DEBUG) {
            printf("greater than 128x128 check\n");
            printf("fps limit = %f\n", fps_limit);
            printf("avmaxslquant = %d\n", avmaxslquant);
            fflush(stdout);
}
        }
        
    } /* end noFpsLimitFlag Check */

    /* Thoralf Niendorf GEMSE 23.11.2000: Prevent scanning
     * more than max slices allowed */
    if ((avmaxslquant > 0) && (exist(opslquant) > avmaxslquant)) {
        strcpy(estr, "Too many slices per TR, please reduce slice number or increase TR");
        epic_error(use_ermes, estr, EM_PSD_FMRI_MULTIACQS, EE_ARGS(0));
        return ADVISORY_FAILURE;
    }


    /* More than one nex - not supported */
    if (existcv(opnex) && ((exist(opnex) < avminnex ) || (exist(opnex) > avmaxnex ))) 
    {
        epic_error(use_ermes, "Improper NEX selected", 
                   EM_PSD_NEX_OUT_OF_RANGE, EE_ARGS(0));
        return FAILURE;
    }  

    /* Thoralf Niendorf GEMSE 18.11.2000: Flip Angle Check  for gradient and spin echo*/
    if((exist(oppseq) == PSD_GE)) {
        if (existcv(opflip) && ( (exist(opflip) < 10) || (exist(opflip) > 90) ) )
        {
            strcpy(estr, "Please select a flip angle between %d and %d.");
            epic_error(use_ermes, estr, EM_PSD_RFFLIP_INVALID, EE_ARGS(2),
                       INT_ARG, 10, INT_ARG, 90);
            return FAILURE;
        } 
    } else if((exist(oppseq) == PSD_SE)) {
        if (existcv(opflip) && ( (exist(opflip) < 10) || (exist(opflip) > 120 ) ) )
        {
            strcpy(estr, "Please select a flip angle between %d and %d.");
            epic_error(use_ermes, estr, EM_PSD_RFFLIP_INVALID, EE_ARGS(2),
                       INT_ARG, 10, INT_ARG, 120);
            return FAILURE;
        }
    } 


    /* Thoralf Niendorf GEMSE 17.03.2001: Number of shots check*/
    if( existcv(opnshots) && ( ( (opnshots) != 1 ) && ((opnshots) != 2 ) && ((opnshots) != 4 ) ) )
    {
        strcpy(estr, "Please select a number of shots from the Pull-Down Menu.");
        epic_error(use_ermes,estr,EM_PSD_FMRI_NSHOTS_INVALID, EE_ARGS(0));
        return FAILURE;
    }

    if ( existcv(optr) && exist(optr)<avmintr )
    {
        epic_error(use_ermes,
                   "The selected TR must be increased to %3.1f ms for the current prescription.",EM_PSD_FLOAT_MINTR_OUT_OF_RANGE, EE_ARGS(1), FLOAT_ARG, (FLOAT) ((INT)(avmintr*1.0e-3)) );
        return ADVISORY_FAILURE;
    }

    if ( existcv(optr) && exist(optr)>avmaxtr ) 
    {
        epic_error(use_ermes, 
                   "The selected TR must be decreased to %3.1f ms for the current prescription.",EM_PSD_FLOAT_MAXTR_OUT_OF_RANGE, EE_ARGS(1), FLOAT_ARG, (FLOAT)((INT)(avmaxtr*1.0e-3)) );
        return FAILURE;
    }

    /*Thoralf Niendorf GEMSE 27.11.2000: Phase FOV check*/
    if( existcv(opphasefov) && (exist(opphasefov) != avminphasefov) && (exist(opphasefov) != avmaxphasefov) )  
    {
        strcpy(estr, "Please select a phase FOV from the pulldown menu.");
        epic_error(use_ermes,estr,EM_PSD_FMRI_PFOV_INVALID, EE_ARGS(0));
        return FAILURE;
    }

    /* BJM: multiphase check */
    if( existcv(opmph) && (exist(opmph) == PSD_ON) )
    {
        strcpy(estr, "Multi Phase is not compatible with this scan.");
        epic_error(use_ermes,estr,EM_PSD_MULTI_PHASE_NOT_COMPATIBLE, EE_ARGS(0));
        return FAILURE;
    }

    /* Prevent users from selecting interleave w/ fMRI */
    if( exist(opileave) == PSD_ON) {
        epic_error( use_ermes, "%s is incompatible with %s.", EM_PSD_INCOMPATIBLE, EE_ARGS(2), STRING_ARG, "fMRI", STRING_ARG, "Interleaved Slice Spacing" );
        return FAILURE;
    }

    return SUCCESS;

} /* end lim_protocol */

/* Function reads medcam.cfg and check for required 8 processor */
STATUS checkAPConfig( int testFlag ) 
{

  FILE *apConfigFile;     /* File pointer to open */
  INT number_of_aps;      /* number of aps in medcam.cfg*/

  INT Reflex400Aps = 8;   /* number of APs in min config */

  /* Open medcam.cfg file */
  apConfigFile = fopen( "/usr/g/bin/medcam.cfg", "r");
 
  /* For test mode always return success */
  if(testFlag == TRUE) return SUCCESS;

  if ( apConfigFile == NULL ) {

      return FAILURE;

  } else {

      fscanf( apConfigFile, "Number Recon Processors: %d", &number_of_aps);
      fclose( apConfigFile );

  }

  /* check against min aps required for real-time EPI */
  if (number_of_aps < Reflex400Aps) {

      return FAILURE;

  } else {  

      return SUCCESS;

  }

} /* end check AP config */


@host scanTime
/* New Code Section ***********************************************/
/* This section of code updates the scan time on the clock based  */
/* the number of images prescribed on the userCV page */

  /* BJM: added opfphases for scan time */
  {
     if (exist(opcgate) == PSD_ON)
        scan_time = (float)(passr_shots*(ccs_relaxtime + 
                        pass_shots*((float)(act_tr+pass_time)*(opdda + 
                        nex*core_shots*reps*(opfphases)))));
     else
        scan_time = (float)(passr_shots*(ccs_relaxtime + 
                        pass_shots*((float)(act_tr+((TRIG_LINE==gating)?TR_SLOP:0)+pass_time)*(opdda +
			nex*core_shots*reps*(opfphases)))));
  }

    if(baseline > 0)
        scan_time = scan_time + bline_time*acqs;

@host RT_slice_time
if (opfmri>0) {
    int *slicetime_tab;
    int seqtime, error_total, num;
#ifdef PSD_HW
    FILE *fp;
#endif /* PSD_HW */

    slicetime_tab=(int *)malloc(opslquant*sizeof(int));
    switch(tr_corr_mode)
    {
        case 0:
            seqtime = RUP_GRD(act_tr/opslquant);
            for (i=0; i<exist(opslquant); i++)
            {
                slicetime_tab[i] = data_acq_order[i].sltime*seqtime/100; 
            }
        break;
        case 1:
            seqtime = RDN_GRD(act_tr/opslquant);
            error_total = act_tr-seqtime*opslquant;
            num = error_total/GRAD_UPDATE_TIME;
            for (i=0; i<exist(opslquant); i++)
            {
                if(data_acq_order[i].sltime<num)
                {
                    slicetime_tab[i] = data_acq_order[i].sltime*(seqtime+GRAD_UPDATE_TIME)/100; 
                }
                else
                {
                    slicetime_tab[i] = (data_acq_order[i].sltime*seqtime+error_total)/100;
                }
            }
        break;
        case 2:
            seqtime = RDN_GRD(act_tr/opslquant);
            for (i=0; i<exist(opslquant); i++)
            {
                slicetime_tab[i] = data_acq_order[i].sltime*seqtime/100; 
            }
        break;
    }

#ifdef PSD_HW
    fp=fopen("/usr/g/bin/fMRI_slicestamping.txt", "w+");
    for (i=0; i<exist(opslquant); i++) {
        fprintf(fp, "%d, \n",slicetime_tab[i]);
    }
    fclose(fp);
#endif
}    

@host RT_checkMaxNumImages
/* This section of code checks if the number of images exceeds the maximum limition */ 
    if(exist(opfmri) == PSD_ON)
    {
        if(opresearch == PSD_OFF && opslquant*opfphases > MAXIMAGES_CLINICAL)
        {
            epic_error(use_ermes, "Maximum number of images exceeded (%d images/scan). Please reduce number of images per scan.", EM_PSD_MAX_IMAGES_PER_SCAN, EE_ARGS(1), INT_ARG, MAXIMAGES_CLINICAL);
            return FAILURE; 
        }
        else if(opresearch == PSD_ON && opslquant*opfphases > MAXIMAGES_RESEARCH)
        {
            epic_error(use_ermes, "Maximum number of images exceeded (%d images/scan). Please reduce number of images per scan.", EM_PSD_MAX_IMAGES_PER_SCAN, EE_ARGS(1), INT_ARG, MAXIMAGES_RESEARCH);
            return FAILURE;
        }
    }

@host setRhVarsfMRI
/* New Code Section ***********************************************/
/* This section of code set the rh variables that are need by recon  */
/* for activating the host-based fMRI processing */

if(exist(opfmri) == PSD_ON) {

    /* BJM: logical OR rhtype1 for host-based fmri */
    /*      4096 = bit 8 -> auto scan/pass detection scheme enabled */
    rhtype1 |= 4096;

    /* BJM: SET rhexecctrl for host-based fMRI */
    rhexecctrl = (RHXC_RTD_XFER_IM_REMOTE + RHXC_RTD_SCAN + RHXC_RTD_XFER_ALL_IM_PER_PASS + (RHXC_AUTO_LOCK*autolock));

} /* end if (opfmri) check */

/* MRIhc05886 and MRIhc14486 */
@host taratioAdjust_fMRI
/* Added to set minimum taratio to 0.85 */
        if( cfgcoiltype == PSD_TRM_COIL && epispec_flag == 0 && exist(opfmri) == PSD_ON && minSeqCoilAdjust == PSD_ON ) {
            if( !checkOptionKey( SOK_IPCM ) ) {
                if( taratio < 0.85 ) {
                    taratio = 0.85;
                }
            } else {
                if( taratio < 0.9 ) {
                    taratio = 0.9;
                }
            }
            if( taratio < 0.9 && exist(opasset) == ASSET_SCAN && opxres < 128 ) {
                taratio = 0.9;
            }
        }

@host epiRT_nontetime_update
/* New Code Section ***********************************************/
/* This section of code updated the non_te_time to include the    */
/* pulse timing for the extra SSP packets in the real time seq.   */
/* MRIge64831: Added eeg and device timing to non_tetime */

non_tetime = non_tetime + eegtime_tot;


/* Added to adjust the coil heating calculation to account */
/* for changes in resistance */

@host coilAdjust_fMRI

  {
      if( (PSD_XRMB_COIL != cfgcoiltype)
          && (PSD_XRMW_COIL != cfgcoiltype) )
      {
          /* Coil Heating Update - account for resistance changes */
          float drf = 1.0;

          if( exist(opfmri) == PSD_ON && minSeqCoilAdjust == PSD_ON ) {

              /* Taken from Garrons simulation for RMS current */
              /* Needed to remove 1.25 (highfreq derating factor) */
              /* from original derating factor since Garrons sim */
              /* did not apply this factor */

              drf = (-0.0009*(esp)+ 2.29)/1.25;
              if(drf < 1.0) drf = 1.0;

          }

          /* Dont derate if research mode and .fmri_research file exists in /usr/g/bin/. */
          if ( exist(opresearch) == PSD_ON ) {
              FILE *fp = NULL;

              /* Check for existance of file */
              /* set flag based on result....*/
              if ((fp=fopen("/usr/g/bin/.fmri_research", "r")) !=NULL) {

                  /* dont derate the coil heating */
                  drf = 1.0;
                  fclose(fp);

              }

          } /* end research check */

          /* Calculate minimum sequence time based on coil, gradient driver,
             GRAM, pulse width modulation, RF amplifier, and playout */
          fmri_coil_limit = (INT)minseqcoil_t*drf;

          printDebug( DBLEVEL1, (dbLevel_t)seg_debug, funcName, "fmri adjusted coil limit = %d\n", fmri_coil_limit);
          printDebug( DBLEVEL1, (dbLevel_t)seg_debug, funcName, "fmri fps = %f\n", (float)optr/tmin_total);
      }
  }
  
  
@host epiRT_check_eegblank_and_TTL
{
    FILE *fp = NULL; 
    if ((fp = fopen("/usr/g/bin/.enableEEGblank","r"))!=NULL) 
    { 
        enable_eegblank = PSD_ON; 
        fclose(fp); 
    } 
    else 
    { 
        enable_eegblank = PSD_OFF; 
    } 
    
    if ((fp = fopen("/usr/g/bin/.disableTTL","r"))!=NULL) 
    {
       enable_TTL = PSD_OFF; 
       fclose(fp); 
    } 
    else 
    { 
        enable_TTL = PSD_ON; 
    }
}


/******** ABOVE THIS LINE IS HOST CODE **********/
/********* BELOW is TGT CODE ********************/

@rspvar epiRT_rspvar
/* New Code Section ***********************************************/
/* This section of code inserts all the rsp variables and used in */
/* in the real-time sequence */

/*** epiRT Variables ****/
/* variables for realtime generation of stimulus paradigm */
int rt_counter;           /* how many loops have we completed? */
int length_count;         /* used to keep track of stim state or base duration */
int stim_state;           /* =1 (header stamp) if RTIP should "bin" image in stim distribution */
int stim_change;          /* variable used to change stim_state value */
int rtip_state;           /* =1 if RTIP should cue operator to "On" condition */
int modval;               /* how many images before switching (header)states? */
int trigger_flag;         /* flag that is toggled for TTL output control */
int ws_usrvar0 = 0;       /* tags headers with stim/base */
int ws_usrvar1 = 0;       /* ws varaible to store the timestamping */
int ws_usrvar1sec = 0;   /* temporary storage for ws_usrvar1. Used for AGP dump of slice timing*/
int ws_usrvar1subsec = 0;   /* temporary storage for ws_usrvar1. Used for AGP dump of slice timing*/
int idelay = 0;           /* image delay to RTIP */
int adw_rt = 1;           /* key for ADW */
int cont_recon_queue; /* MRIge91079 */

/* BJM: provide TTL pulse for device control
 * SSP packet for controlling the fMRI devices that 
 * can accept a TTL from the J12 connection (Dab Out 8) on
 * the CERD which is also the QTUNE ENABLE line
 */
/* BJM: 02/07/2000 - modified.  Moved triggering to dab4 */
short TTLpack[3] =
      {   0,
          SSPOC + DREG,  /* DABOUT8 - is J12 */
          SSPD           /* DABOUT4 - is Dab4 on Front Panel IO */
      };                 /* will add data words in rsp section via setwamp() */

/* BJM: These pulses will be played out prior to each RF */
/* and at the end of all gradient activity on J11.  The */
/* purpose is to provide "blanking" window for an external */
/* EEG recording device -they are controlled in real time so two */
/* packetsare defined, the first turns it on, the second turns it off */
short eegpack[3] =
      {   0,
          SSPOC + DREG,      /* BJM: from pulsegen.h...*/
          SSPD + DABOUT7     /* DABOUT7 is J11 on DAB */
      };

short eegpackend[3] =
      {   0,
          SSPOC + DREG,   /* BJM: from pulsegen.h...*/
          SSPD            /* turn it off - remove DABOUT7 */
      };

@pg epiRT_pgVars 
/* These are from RT.e and are currently not used explicitly for fMRI */
float cont_slthick;
int cont_r1, cont_satmode;
float cont_xoffset_old, cont_yoffset_old, cont_zoffset_old;
float cont_alpha_old, cont_beta_old, cont_gamma_old;
float xyz_new[DATA_ACQ_MAX][3];
int tot_slices;


@pg epiRT_init_SSP_packets
/* New Code Section ***********************************************/
/* This section of code initializes the SSP packet device select  */
/* fields.  It must occur after the sspinit() call since EDC is   */
/* defined in that function. */

/* BJM have to set this here since EDC is defined by sspinit */
    TTLpack[0] = SSPDS + EDC;
    eegpack[0] = SSPDS + EDC;
    eegpackend[0] = SSPDS + EDC;


@pg epiRT_SSP_Packets

/* New Code Section ***********************************************/
/* This section of code set up some SSP packets that can be used to */
/* control the dab outs on the MGD chassis.  Specifically, the      */
/* TTL_ON packet turns the pulse on J12 high before the RF1         */
/* pulse and then TTL_OFF set it low for triggering external        */
/* equpiment */

    pos_start_TTLON = pendallssp(&ssp_td0,0);
    pos_start_eegON = pendallssp(&ssp_td0,0);
    if (enable_TTL == PSD_ON) 
    {
  /* BJM: add SSP packet for TTL fMRI device control */
  /*      play out packet just before rf1frq (or after
   *      ssp_td0) */         
       SSPPACKET(TTL_ON,pos_start_TTLON,pw_TTLpack,TTLpack,); 
       SSPPACKET(TTL_OFF,1ms - pw_TTLpack + pendallssp(&TTL_ON,0),pw_TTLpack,TTLpack,);

       TTLtime_tot = pendallssp(&TTL_OFF,0) - pendallssp(&TTL_ON,0) + pw_TTLpack; 
    }
    else
    { 
        TTLtime_tot = 0; 
    }

  /* BJM: add SSP packet for EEG blanking */
  /*      play out pulse (blank) just after device control packet */
  /*      play out pulse (unblank) just before sspshift */
  /*      Note: unblank occurs after all gradient activity ceases */
   if (enable_eegblank == PSD_ON)
   {
       if (enable_TTL == PSD_ON) pos_start_eegON = pendallssp(&TTL_OFF,0);
       SSPPACKET(eegblankbeg,pos_start_eegON,pw_eegpack,eegpack,);
       SSPPACKET(eegblankbegoff,1ms-pw_eegpack+pendallssp(&eegblankbeg,0),pw_eegpack,eegpackend,);
       SSPPACKET(eegblankend,temps+7us,pw_eegpack,eegpack,);
       SSPPACKET(eegblankendoff,1ms-pw_eegpack+pendallssp(&eegblankend,0),pw_eegpack,eegpackend,);
   
       eegtime_tot = pendallssp(&eegblankendoff,0) - temps+7us;
   }
   else
   {
       eegtime_tot = 0;
   }

/* add total SSP time for next set of packets */ 
   temps = temps + eegtime_tot;

/* Call to RT_pginit -  this function simply initialize some real-time  */
/* variables such as cont_synch which tells recon we are in a real-time */
/* or continuous looping scan mode */
/* THIS MUST BE IN PULSEGEN or recon wont get the message to switch modes */

   RT_pginit();


@pg RTpgInit

/* New Code Section ********************************************** */
/* This section of code initializes a few rsp variables in pulsgen */
/* so that recon know we are in a real-time loop mode */

STATUS
RT_pginit( void )
{
#ifdef IPG
    INT i, j;

    /* Initialize the rsp variable control block */
#ifdef PSD_HW
    cs_rsps_init_processing();
#endif /* PSD_HW */

    /* Initialize flag to recon. */
    cont_synch = 1;

    /* Initialization of continuous imaging rsps */
    cont_sp_changed = PSD_OFF;
    cont_zoffset = cont_yoffset = cont_xoffset = 0.0;  /* No offsets */
    cont_xoffset_old = cont_yoffset_old = cont_zoffset_old = 0.0;
    cont_alpha_old = cont_beta_old = cont_gamma_old = 0.0;
    cont_wsid = cont_psdid = 0;                   /* Init in core too*/
    cont_time = 0;                                   /* 0 time stamp */
    tot_slices = opslquant* opfphases;
         
     /* Initialize original x, y, z locations (xyz_base) */
    fpntoxyz( rsprot, DATA_ACQ_MAX, xyz_base, rsp_info, &loggrd,
              &phygrd, cont_debug);
    
    for (i = 0; i < DATA_ACQ_MAX; i++)
	{
	    /* Save original rotation matrices */
	    for (j = 0; j < 9; j++)
		rsprot_base[i][j] = rsprot[i][j];
            
	    /* Initialize new x, y, z locations (xyz_new) */
	    xyz_new[i][0] = xyz_base[i][0] + cont_xoffset;
	    xyz_new[i][1] = xyz_base[i][1] + cont_yoffset;
	    xyz_new[i][2] = xyz_base[i][2] + cont_zoffset;
	}
    
    cont_stop = cont_stop_usr = 0;   /* Init in core too*/

#endif /* IPG */

    return SUCCESS;

}   /* end RT_pginit() */

@rsp epiRT_RTvar_init
/* New Code Section ***********************************************/
/* This section of code initializes the RSP varibales before the     */
/* PSD begins to loop.  It is inlined into the epi.e PSD just before */
/* the "pass_rep" loop in the PSD. */

 rt_counter = 0;         /* # of real-time loops completed */
 length_count = 1;       /* Counts 1/2 cycle for stamping headers */
 trigger_flag = PSD_ON;  /* flag to toggle TTL pulse */

/* BJM: Is this an fMRI scan and are we in the SCAN state? */
if(opfmri == PSD_ON && rspent == L_SCAN ) {

    cont_flag = PSD_ON;        
    BoreOverTempFlag = PSD_OFF;   /* Bore temp initialization */
    rspprp = opfphases;       /* use pass_rep loop */
    
    /* 0 id tags for MROR-WS and psd */
    cont_wsid = cont_psdid = 0;

} else {
   cont_flag = PSD_OFF;
}


 /* BJM: set up initial conditions - are we starting in the activation cond? */
 if(opinit_state == 0) {

     modval = oprep_rest;
     ws_usrvar0 = 0;
     stim_state = 0;
     stim_change = 1;        /* state change variables   */
     ws_usrvar1 = 0;
 
 } else {

     modval = oprep_active;
     ws_usrvar0 = 1;
     stim_state = 1;
     stim_change = -1;    /* state change variables   */
     ws_usrvar1 = 1;
  }

/* set trigger to aux if desired */
if(oppsd_trig == PSD_ON  && rspent == L_SCAN && cont_flag == PSD_ON )
 { 
   settrigger((SHORT)TRIG_AUX,0);
 }

@rsp epiRT_core_RTvar_update
/* New Code Section ***********************************************/
/* This section of code is used update the ws_user variables which */
/* are used to communicate to RTIP the state of the fMRI experiment */
/* it also updates the rt_counter and checks the boretemp monitor   */
/* Determine stimulus state */
if(opfmri > 0 && rt_counter > 0)  {
    if (opfMRIPDTYPE == SIMPLE_BLOCK ) {
        if ((!((length_count)%modval)) && ((length_count) != 0)) {

            stim_state += stim_change;
            stim_change *= -1;

            /* update ws header variable */
            ws_usrvar0 = stim_state;

            /* toggle modulus value for differing state lengths */
            if(stim_state == PSD_ON)
                modval = oprep_active;
            else 
                modval = oprep_rest;

            /* reset trigger output */
            trigger_flag = PSD_ON;  /* flag to toggle TTL pulse */

            /* reset counter */
            length_count = 1;

        } else {

            length_count++;
        }

        /* BJM: reset trigger array */
        if((oppsd_trig == PSD_ON) && (rspent == L_SCAN)) {
            settrigger((short)TRIG_INTERN,0);
        }
    }


} /* end rt_counter > 0 */

/* check for bore temp limits */
BoreOverTempFlag=(int)BoreOverTemp(cont_flag && btemp_monitor,btemp_debug);

if ( RT_DEBUG){

    printf("rt counts (phase) = %d\n",rt_counter);
    printf("***************************\n");
    printf("\nstim_state = %d\n",stim_state);
    printf("ws_usrvar0 = %d\n",ws_usrvar0);
    printf("ws_usrvar1 = %d\n", ws_usrvar1);
    printf("psdid = %d\n\n", cont_psdid);
    printf("\n*************************\n");

    fflush(stdout);
}

@rsp RT_startclock
if (opfmri>0) {
    if (pass_rep == 0 && slice == 0) {
        boffset(off_seqRTclock);
        startseq((short)0, (SHORT)MAY_PAUSE);
        boffset(off_seqcore);
        if (timerstamp_res == 0)
            rspstarttimer();
        else
            rsptimerstart();
    }
}

@rsp RT_readclock
if (opfmri>0) {
    if (slice == 0) {
/* Here, we return ws_usrvar1 as 100us resolution to maintain the
 * compatibility with host software, however choose to display in AGP
 * term in various resolution for better debugging experience. */
        if (timerstamp_res == 0)
        {
            ws_usrvar1 = (INT)rspreadtimer();
            if (RT_DEBUG) {
                printf("rt counts (phase) = %d\n",rt_counter);     
                printf("slice time (100us) = %d\n", ws_usrvar1); 
                fflush(stdout);        
            }
        }
        else if (timerstamp_res == 1)
        {
            rsptimersample();
            ws_usrvar1sec = (INT)rsptimergetsec();
            ws_usrvar1subsec = (INT)(rsptimergetnano()/1000); 
            /* Note that rsptimer function calls themselves introduce 
             * a few micro second jitter in the timing measurement, SWL */
            ws_usrvar1 = (INT)(ws_usrvar1sec*10000)+(INT)(ws_usrvar1subsec/100);
             if (RT_DEBUG) {
                printf("rt counts (phase) = %d\n",rt_counter);     
                if (ws_usrvar1subsec>=0)
                    printf("slice time (1us) = %dsec + %dus\n", ws_usrvar1sec,ws_usrvar1subsec); 
                else
                    printf("slice time (1us) = %dsec + %dus\n", ws_usrvar1sec-1,1000000+ws_usrvar1subsec); 
                fflush(stdout);        
            }
        }
    }
}

@rsp RTIP_test
/* New Code Section ***********************************************/
/* This section of code is used to modulate the flip angle */
/* by an amount equal to percent_dither.  This is a CV that can be */
/* modified if desired and is currently set to 15% to make a large */
/* signal change that is easily detectable.... */
     
     /* RTFMRI */
     /* BJM - this code is for testing the rtip application */
     /* for fMRI using phantoms.  The rf1 amplitude (flip angle) is */
     /* decreased slightly in the baseline state to give more */
     /* signal in the stim state */

     if(RTIP_test == PSD_ON) {
         if ( (rspent == L_SCAN) && (stim_state == PSD_OFF)) {   

             /* modulate flip angle */ 
             setiamp((int)(rfpol[ileave]*percent_dither),&rf1,0);

         } else {
             
             /* set it back to the nominal flip angle */ 
             setiamp(rfpol[ileave],&rf1,0);
         }

     }  /* end RTIP_test */

@rsp setTTLpulse
/* New Code Section **********************************************   */
/* This section of code turns the TTL_ON pulse on/off.  This         */
/* TTL pulse starts before the RF pulse and ends after the RF pulse. */  
/* Since there is an TTL_OFF packet that has null data, we simply    */
/* have to send DABOUT8 as the data in TTL_ON.  The register becomes */
/* hi and then the TTL_OFF packet will set the register low ending   */
/* the TTL pulse output    */

/* BJM: turn on TTL pulse -> add DABOUT4 & 8 to data field */ 
  if (enable_TTL == PSD_ON)
{
  if(rspent == L_SCAN && cont_flag == PSD_ON)  {
         if(trigger_flag == PSD_ON) {
             setwamp(SSPD+DABOUT8+DABOUT4, &TTL_ON, 2); 
             trigger_flag = PSD_OFF;
         } else {
             setwamp(SSPD, &TTL_ON, 2); 
         }
  }
}
@rsp RT_save

/* New Code Section ***********************************************/
/* This section of code is called for every pass to update the shared */
/* buffer........  */
          
/****************** Save the variables ********************/
if (cont_flag == PSD_ON)
{


#ifdef PSD_HW
    cs_save_recon_rsp_values();

#endif /* PSD_HW */

    /*MRIhc02691 add support to get mag, phase, real, imaginary at the
     * same time*/
    if(rhrcctrl & 0x0001) {
        cont_psdid++;       /* magnitude images */
    } 

    if (rhrcctrl & 0x0002) { 
        cont_psdid++;       /* phase images */
    }

    if (rhrcctrl & 0x0004) { 
        cont_psdid++;       /* real images */
    }

    if (rhrcctrl & 0x0008) { 
        cont_psdid++;       /* imaginary images */
    }

    rt_counter += 1;

if (RT_DEBUG) {
    printf("Updating psdid to = %d\n", cont_psdid);
    fflush(stdout);
}

}

/********** End of epiRTfile.e inline ***********************/
