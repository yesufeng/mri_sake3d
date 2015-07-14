/*
 *  bbepi.tgtex.h
 *
 *  Do not edit this file. It is automatically generated by EPIC.
 *
 *  Date : Oct  9 2013
 *  Time : 17:18:52
 */

#ifndef h_bbepi_tgtex_h
#define h_bbepi_tgtex_h

/* *******************
   ipgexport
   ******************* */
RSP_INFO rsp_info[DATA_ACQ_MAX] = { {0,0,0,0} };
/* changed following 2 parameters from short to int. YH */
long rsprot[TRIG_ROT_MAX][9]= {{0}};    /* rotation matrix for this slice */
long rsptrigger[TRIG_ROT_MAX]= {0};   /* trigger type */

long ipg_alloc_instr[PSD_MAX_PROCESSORS] = {
PSD_GRADX_INSTR_SIZE,
PSD_GRADY_INSTR_SIZE,
PSD_GRADZ_INSTR_SIZE,
PSD_RHO1_INSTR_SIZE,
PSD_RHO2_INSTR_SIZE,
PSD_THETA_INSTR_SIZE,
PSD_OMEGA_INSTR_SIZE,
PSD_SSP_INSTR_SIZE,
PSD_AUX_INSTR_SIZE};


RSP_INFO asrsp_info[3] = { {0,0,0,0} };   /* transmit, receive locations for autoshim */
/* changed from short to in.  YH */
long sat_rot_matrices[14][9]= {{0}}; /* rotation matrices for sp sat */

/* following parameters are new for 55 */ /* added  YH 10/14/94 */
/* physical gradient characteristics */
/* MRIhc08159: Initializations added */
PHYS_GRAD phygrd = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
/* logical gradient characteristics */
LOG_GRAD  loggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
/* logical gradient chars. for graphic sat */
LOG_GRAD satloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
/* logical gradient characteristics */
LOG_GRAD asloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
SCAN_INFO asscan_info[3] = { {0,0,0,{0}} };
/* MRIge43968 (BJM): redefined from long PSrot[10] to the following.. */
/* redefined to long PSrot from int as per CARDIAC34.01 version */
long PSrot[PRESCAN_ROT_MAX][9]= {{0}};             /* prescan rotation matrix */

/* ************************************
   Prescan modification parameter (GE)
   ************************************  */
long PSrot_mod[PRESCAN_ROT_MAX][9]= {{0}};             /* prescan rotation matrix */
 
PHASE_OFF phase_off[DATA_ACQ_MAX] = { {0,0} };
int yres_phase= {0};  /* offset in phase direction in mm */
int yoffs1= {0};  /* intermediate phase offset variable */

/*** RT ***/
/* For use in SpSat.e */
/* storage of original concat sat offsets */
int off_rfcsz_base[DATA_ACQ_MAX]= {0};
/* storage of original matrix location */
SCAN_INFO scan_info_base[1] = { {0,0,0,{0}} };

/* For use in Prescan.e and psds */
/* storage of original x, y, and z offsets */
float xyz_base[DATA_ACQ_MAX][3]= {{0}};
/* storage of original rotation matrices */
long rsprot_base[TRIG_ROT_MAX][9]= {{0}};
/*** End RT ***/

/* Begin RTIA */
int rtia_first_scan_flag = 1 ; 
/* End RTIA */

RSP_PSC_INFO rsp_psc_info[MAX_PSC_VQUANT] = { {0,0,0,{0},0,0,0} };

/*************************************************************************
 * These structures are copy for target side. We will copy from host
 * @reqexport section to @ipgexport section.
 * The COIL_INFO and TX_COIL_INFO is defined                 
 * in /vobs/lx/include/CoilParameters.h
 *************************************************************************/

COIL_INFO coilInfo_tgt[MAX_COIL_SETS] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };

COIL_INFO volRecCoilInfo_tgt[MAX_COIL_SETS] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };

TX_COIL_INFO txCoilInfo_tgt[MAX_TX_COIL_SETS] = { { 0,0,0,0,0,0,0,0,0,{0},0,0,{0},{0},{0},0 } };

ChannelTransTableEntryType cttEntry_tgt[MAX_NUM_CHAN_TRANSLATION_MAPS] =  { { {0},{0},0,0,0,{0} } };

int cframpdir_tgt = 1;
int chksum_rampdir_tgt = 1447292810UL;

/*********************************************************************
 *                  PRESCAN.E IPGEXPORT SECTION                      *
 *                                                                   *
 * Standard C variables of _any_ type common for both the Host and   *
 * Tgt PSD processes. Declare here all the complex type, e.g.,       *
 * structures, arrays, files, etc.                                   *
 *                                                                   *
 * NOTE FOR Lx:                                                      *
 * Since the architectures between the Host and the Tgt sides are    *
 * different, the memory alignment for certain types varies. Hence,  *
 * the following types are "forbidden": short, char, and double.     *
 *********************************************************************/
int PSfreq_offset[ENTRY_POINT_MAX]= {0};
int cfl_tdaq= {0};
int cfh_tdaq= {0};
int rcvn_tdaq= {0};
long rsp_PSrot[MAX_PSC_VQUANT] [9]= {{0}};

/* For presscfh MRIhc08321 */
PSC_INFO presscfh_info[MAX_PSC_VQUANT]={ {0,0,0,{0},0,0,0} };

/* YMSmr09211  04/26/2006 YI */
LOG_GRAD  cflloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
LOG_GRAD  ps1loggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
LOG_GRAD  cfhloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
LOG_GRAD  rcvnloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };


WF_PROCESSOR read_axis = XGRAD;
WF_PROCESSOR killer_axis = YGRAD;


char ext_spsp_fatsat_rf_filename[256]= {0};
char ext_spsp_fatsat_gz_filename[256]= {0};


long rsprot_unscaled[DATA_ACQ_MAX][9]= {{0}}; /* a copy of the rotation matrices
					  unscaled by cf<x,y,z.full, targets,
				          or full scale values */
int off_rfcsz[DATA_ACQ_MAX]= {0};           /* This is for concat Sat */
int field_strength= {0};

/* Define physical and gradient characterisitics for epi read train.       */
/* Physical limits are actual hardware limits, not limited by dB/dt        */
/* constraints.  dB/dt constraints are applied within epigradopt function. */

/* MRIhc08159 */
 /* physical gradient characteristics */
PHYS_GRAD epiphygrd = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };   
 /* logical gradient characteristics */
LOG_GRAD  epiloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };   

RF_PULSE_INFO rfpulseInfo[RF_FREE] = { {0,0} };

/* variables used as buffers to read in static data from external file; 
   these buffers are used by functions for on-the-fly calculations, etc.    RK */
float delay_buffer[10]= {0};
float dither_buffer[12]= {0};
float ccinx[50]= {0};
float cciny[50]= {0};
float ccinz[50]= {0};
float fesp_in[50]= {0};
int esp_in[50]= {0};
float g0= {0};
int num_elements= {0};
int file_exist= {0};

/* SXZ::MRIge72411: edge ghost optimization */
float taratio_arr[NODESIZE]= {0};
float totarea_arr[NODESIZE]= {0};

float vfa_flips[1024]= {0}; /*jwg bb for vfa flip schedule*/
float sake_blips[1024]= {0}; /*jwg bb for SAKE blip schedule*/
char ssthetafile[128]= {0}; /*jwg bb for reading in external THETA waveform*/

char ssrffile[40]= {0};
char ssgzfile[40]= {0};
char hgzssfn[40]= {0};

/******************************ssInit************************************/
/************************************************************************/
long _lasttgtex = 0;

#endif /* h_bbepi_tgtex_h */
