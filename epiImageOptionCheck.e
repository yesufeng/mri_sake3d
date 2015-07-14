/*
 *  GE Medical Systems
 *  Copyright (C) 1997 The General Electric Company
 *  
 *  epiImageOptionCheck.e
 *  
 *  Inline file that contains imaging options checks
 *  
 *  Language : ANSI C
 *  Author   : Bryan Mock
 *  Date     : 5/8/01
 *
 */
/* do not edit anything above this line */

@host epiImageCheck

/* Function Delcaration */
STATUS checkEpiImageOptions(void);

STATUS checkEpiImageOptions( void )
{
    int cardcv;                   /* Cardiac Gating Flag */
    float temp_float;             

    if(exist(opsilent) == PSD_ON && (exist(opfmri) == PSD_ON || exist(opmph) == PSD_ON || exist(opdynaplan) == PSD_ON))
    {
        epic_error( use_ermes, "%s is incompatible with %s ",
                    EM_PSD_INCOMPATIBLE, 2, STRING_ARG, "Acoustic Reduction",
                    STRING_ARG, "fMRI and multiphase EPI" );
        return FAILURE;
    }

    /* Sequence Type Check - SE and GRE Only */
    if ( (exist(oppseq) != 1) && (exist(oppseq) != 2) ) { /* lockout IR,SSFP,SPGR,TOF,PC,TOFSP,PCSP */
	epic_error(use_ermes,
                   "The EPI option is not supported in this scan",
                   EM_PSD_EPI_INCOMPATIBLE, 0);
	return FAILURE;
    }
    
    /* No 3D yet */
    if (exist(opimode) == PSD_3D) {
	epic_error(use_ermes,
		   "EPI is not compatible with the 3D Image Mode.  Please select 2D",
                   EM_PSD_EPI_VOLUME_INCOMPATIBLE, 0);
	return FAILURE;
    }
    
    /* No Spectro-EPI Yet */
    if (exist(opimode) == PSD_SPECTRO) {
	epic_error(use_ermes,
		   "Spectroscopy prescription failed.",
                   EM_PSD_SPECTRO_FAILURE, 0);
	return FAILURE;
    }
    
    /* No CINE EPI */
    if ((exist(opimode) == PSD_CINE) && existcv(opimode)) {
        epic_error(use_ermes,"Cine is not available with this PSD",EM_PSD_CINE_INCOMPATIBLE,0);
        return FAILURE;
    }
    
    /* POMP is not supported with EPI */
    if ((exist(oppomp) == PSD_ON) && existcv(oppomp)) {
        epic_error(use_ermes,"The POMP option is not supported in this scan.", EM_PSD_POMP_INCOMPATIBLE, 0);
        return FAILURE;
    }
    
    /* No PhaseWrap is not Supported */
    if (exist(opnopwrap) == PSD_ON) {
	epic_error(use_ermes, "No Phase Wrap and EPI are incompatible features.",
                   EM_PSD_EPI_NOP_INCOMPATIBLE, 0);
	return FAILURE;
    }
    
    /* Tailored RF is only for FSE-based scans */  
    if (exist(optlrdrf) == PSD_ON) {
	epic_error(use_ermes,
                   "The Tailored RF option is not supported in this scan.",
                   EM_PSD_TLRDRF_INCOMPATIBLE, 0);
	return FAILURE;
    }
    
    /* Resp. Comp Check */
    if (exist(opexor) == PSD_ON) {
	epic_error(use_ermes,
                   "Respiratory Compensation and EPI and incompatible features.",
                   EM_PSD_EPI_RESP_COMP_INCOMPATIBLE, 0);
	return FAILURE;
    }
    
    /* Driven Equilibrium Prep not Supported */
    if (exist(opdeprep) == PSD_ON) {
	epic_error(use_ermes,
                   "The DE Prep Option is not available with this pulse sequence.",
                   EM_PSD_OPDEPREP_INCOMPATIBLE, 0);
	return FAILURE;
    }
    
    /* Resp Triggered Scans are not supported */
    if (exist(oprtcgate) == PSD_ON) {
	epic_error(use_ermes,
                   "Respiratory Triggering and EPI and incompatible features.",
                   EM_PSD_EPI_RESP_TRIG_INCOMPATIBLE, 0);
	return FAILURE;
    }
    
    /* No Mag. Transfer */
    if (exist(opmt)==PSD_ON && existcv(opmt)==PSD_ON) {
        epic_error(use_ermes,"MT not Supported",EM_PSD_MT_INCOMPATIBLE,0);
        return FAILURE;
    }    
    
    /* No Clasic Feature */
    if (exist(opblim) == PSD_ON) {
        epic_error(use_ermes,
                   "Classic is not an option.",
                   EM_PSD_CLASSIC_INCOMPATIBLE, 0);
        return FAILURE;
    }

    /* YMSmr07221, YMSmr07315 */
    if (existcv(opptsize) && (exist(opptsize) > 2)) {
        epic_error(use_ermes,"EDR is not supported in this PSD.",EM_PSD_EDR_INCOMPATIBLE,0);
        return FAILURE;
    }       
 
    /* Can't use a graphic ROI */
    if ((exist(opgrxroi) == PSD_ON) && existcv(opgrxroi)) {
        epic_error(use_ermes,
                   "The Graphic ROI Option is not available with this sequence.",
                   EM_PSD_OPGRXROI_INCOMPATIBLE, 0);
        return FAILURE;
    }
    
    /* EPI and SSFSE are not compatible */
    if (exist(opepi)==PSD_ON && exist(opssfse)==PSD_ON){
	epic_error(use_ermes,
                   "EPI is incompatible with the Single-Shot button. Please use # of Shots = 1 for SS-EPI.",
                   EM_PSD_EPI_SSFSE_INCOMPATIBLE, 0);
	return FAILURE;
    }
    
    /* MRIge53672 - Make Concat SAT and multiphase EPI incompatible */
    if ( (PSD_ON == mph_flag) && (PSD_ON == exist(opccsat)) ) {
        epic_error( use_ermes, "%s is incompatible with %s ",
                    EM_PSD_INCOMPATIBLE, 2, STRING_ARG, "Concat SAT",
                    STRING_ARG, "multiphase EPI" );
        return FAILURE;
    }
    
    /* No rect. FOV */
    if (exist(oprect) == PSD_ON) {
	strcpy(estr, "Rectangular FOV is not allowed with this scan.");
	epic_error(use_ermes, estr, EM_PSD_RECT_NOT_SUPPORTED, EE_ARGS(0));
	return FAILURE; 
    }
    
    /* Caridac Gating Checks */
    cardcv = (exist(opcgate) && existcv(ophrate) && existcv(ophrep) 
              && existcv(opphases) && existcv(opcardseq) && existcv(optdel1)
              && existcv(oparr));
    
    /* MRIge65081 */
    if (exist(opcgate)) {
        if ((exist(opslquant) > avmaxslquant) && existcv(opslquant)) {
            epic_error(use_ermes,"Maximum slice quantity is %-d ",EM_PSD_SLQUANT_OUT_OF_RANGE,1,INT_ARG,avmaxslquant);
            return ADVISORY_FAILURE;
        }
    } 
    
    if (!exist(opcgate)) {
        if ((opautotr == 0) && (exist(optr) < avmintr) && existcv(optr)) {
            epic_error(use_ermes," Minimum TR is %-d ms ",EM_PSD_TR_OUT_OF_RANGE,1,INT_ARG,(avmintr/1ms));
            return ADVISORY_FAILURE;
        }
        
        if ((opautotr == 0) && (exist(optr) > avmaxtr) && existcv(optr))
        {
            epic_error(use_ermes," Maximum TR is %-d ms ",EM_PSD_TR_OUT_OF_RANGE2,1,INT_ARG,(avmaxtr/1ms));
            return ADVISORY_FAILURE;
        }
    }
    else
    {
        if ((piait < avmintseq) && (existcv(optdel1)))
        {
            epic_error(use_ermes," Improper Avail. Image Time.  Decrease Trigger Window and/or Trigger Delay. ",EM_PSD_AIT_OUT_OF_RANGE,0);
            return FAILURE;
        }
        
        if ((existcv(optdel1))&& ((exist(optdel1) < avmintdel1)
                                  || (exist(optdel1) > 1.6s)))
        {
            epic_error(use_ermes," Min. delay after trigger is %-d ms ",EM_PSD_TD_OUT_OF_RANGE,1,INT_ARG,(avmintdel1/1ms));
            return FAILURE;
        }
    } 
    
    if (cardcv)
    {
        if (exist(opphases) > avmaxphases)
        {
            epic_error(use_ermes," The number of phases must be reduced to %-d ", 
                       EM_PSD_MAXPHASE_EXCEEDED,1,INT_ARG,avmaxphases);
            return FAILURE;
        }
        if ((psd_tseq < avmintseq) && (existcv(opfov)) && (existcv(opcardseq)))
        {
            epic_error(use_ermes," The minimum inter sequence delay time must be increased to %-d ms due to the FOV/slice thickness selected ",EM_PSD_TSEQ_FOV_OUT_OF_RANGE,1,INT_ARG,(avmintseq/1ms));
            return FAILURE;
        }
        
        if ((psd_tseq < avmintseq) && (existcv(opcardseq)))
        {
            epic_error(use_ermes," The minimum inter sequence delay time must be increased to %-d ms. ",EM_PSD_TSEQ_OUT_OF_RANGE,1,INT_ARG,(avmintseq/1ms));
            return FAILURE;
        }
        if (seq_type == TYPMPMP)
        {
            temp_float = (float)opphases/(float)opslquant;
            if ((temp_float != 1.0) && (temp_float != 2.0) && 
                (temp_float != 3.0) && (exist(opslquant) > 1))
            {
                epic_error(use_ermes," The number of phases/locations must equal 1, 2, or 3.\n ",EM_PSD_SLCPHA_INCOMPATIBLE,0);
                return FAILURE;
            }
            
            if (exist(opphases)*exist(opslquant)*exist(opfphases) > DATA_ACQ_MAX)
            {
                epic_error(use_ermes," The number of locations*phases has exceeded %-d.\n ",EM_PSD_SLCPHA_OUT_OF_RANGE,1,INT_ARG,DATA_ACQ_MAX);
                return FAILURE;
            }
        }
    }

    /* YMSmr09726 */
    if( exist(opasset) && (val15_lock == PSD_ON) ){
        if(!strcmp( coilInfo[0].coilName, "GE_HDx 8NVARRAY_A")){
            epic_error( use_ermes, "%s is incompatible with %s.",
                            EM_PSD_INCOMPATIBLE, 2,
                            STRING_ARG, "EPI ASSET",
                            STRING_ARG, "8NVARRAY_A");
            return FAILURE;
        } else if(!strcmp( coilInfo[0].coilName, "GE_HDx 8NVANGIO_A")){ 
            epic_error( use_ermes, "%s is incompatible with %s.",
                            EM_PSD_INCOMPATIBLE, 2,
                            STRING_ARG, "EPI ASSET",
                            STRING_ARG, "8NVANGIO_A");
            return FAILURE;
        }
    }

   return SUCCESS;

} /* end checkEpiImageOptions( void ) */

