@host AllSupportedIopts
#include <psdiopt.h>
int sequence_iopts[] = {
    PSD_IOPT_CARD_GATE,
    PSD_IOPT_FLOW_COMP,
    PSD_IOPT_SEQUENTIAL,
    PSD_IOPT_MPH,
    PSD_IOPT_SQR_PIX,
    PSD_IOPT_FMRI,
    PSD_IOPT_IR_PREP,
    PSD_IOPT_ASSET,  /* MRIge92386: Added for enabling Asset with EPI for Excite-III */
    PSD_IOPT_DYNPL,
    PSD_IOPT_MILDNOTE
};

long feature_flag = 0;

@host ImagingOptionFunctions
void
psd_init_iopts( void )
{
    int numopts = sizeof(sequence_iopts) / sizeof(int);

    psd_init_iopt_activity();

    activate_iopt_list( numopts, sequence_iopts );
    enable_iopt_list( numopts, sequence_iopts );

    set_incompatible( PSD_IOPT_FMRI, PSD_IOPT_MPH );                    
    set_incompatible( PSD_IOPT_FMRI, PSD_IOPT_IR_PREP );                
    set_incompatible( PSD_IOPT_FMRI, PSD_IOPT_CARD_GATE );              
    set_incompatible( PSD_IOPT_FMRI, PSD_IOPT_SEQUENTIAL );             
    set_incompatible( PSD_IOPT_FMRI, PSD_IOPT_DYNPL );             

    /* Disable ART with fMRI and multi-phase EPI */ 
    if(mild_note_support)
    {
        set_incompatible( PSD_IOPT_MPH, PSD_IOPT_MILDNOTE );
        set_incompatible( PSD_IOPT_DYNPL, PSD_IOPT_MILDNOTE );
        set_incompatible( PSD_IOPT_FMRI, PSD_IOPT_MILDNOTE );
    }

    /* MRIge92386: Added for Excite-3: Enabling Asset with EPI but not
     * with fMRI */   
    /* MRIhc06306: for DVMRI, asset is supported for fMRI*/
    /*set_incompatible( PSD_IOPT_FMRI, PSD_IOPT_ASSET); */                  

    /* MRIhc01608: FLOWCOMP and fMRI not compatible in SEPI */
    if (PSD_SE == exist(oppseq)) {
        set_incompatible( PSD_IOPT_FMRI, PSD_IOPT_FLOW_COMP);
    }

    set_incompatible( PSD_IOPT_CARD_GATE, PSD_IOPT_DYNPL );
    set_incompatible( PSD_IOPT_MPH, PSD_IOPT_DYNPL );

    return;
}

STATUS
cvsetfeatures( void )
{
    return SUCCESS;
}

STATUS
cvfeatureiopts( void )
{
    psd_init_iopts();

    /* MRIhc08639  09/01/2005 YI */
    if(exist(opcgate) == PSD_ON){
        deactivate_ioption( PSD_IOPT_DYNPL );
    }

    if(value_system_flag == VALUE_SYSTEM_HDE){
        deactivate_ioption( PSD_IOPT_FMRI );
    }

    if(checkOptionKey( SOK_MPHVAR )){
        deactivate_ioption( PSD_IOPT_DYNPL );
    }

    if(!mild_note_support){
        deactivate_ioption( PSD_IOPT_MILDNOTE );
    }

    if( (val15_lock == PSD_ON) && 
        (!strcmp( coilInfo[0].coilName, "GE_HDx 8NVARRAY_A") || 
         !strcmp( coilInfo[0].coilName, "GE_HDx 8NVANGIO_A"))) 
    {
        disable_ioption( PSD_IOPT_ASSET );
    }
    
    if (exist(optouch)) {
        deactivate_ioption(PSD_IOPT_MPH);
        deactivate_ioption(PSD_IOPT_DYNPL);
        deactivate_ioption(PSD_IOPT_FMRI);
        deactivate_ioption(PSD_IOPT_MILDNOTE);
        deactivate_ioption(PSD_IOPT_IR_PREP);
        deactivate_ioption(PSD_IOPT_SQR_PIX);
        deactivate_ioption(PSD_IOPT_SEQUENTIAL);
        deactivate_ioption(PSD_IOPT_CARD_GATE);
    }
 
    return SUCCESS;
}

STATUS
cvevaliopts( void )
{

    /* Option Key Check */
    int fmri_option_key_status;

    /*MRIhc07637 no longer check for medcam.cfg with VRE*/

    /* Option Key Check */
    fmri_option_key_status = !checkOptionKey( SOK_BRNWAVRT );

    if ((FALSE == fmri_option_key_status) && (value_system_flag != VALUE_SYSTEM_HDE)) {
        set_disallowed_option(PSD_IOPT_FMRI);
    }

   return SUCCESS;
}

















