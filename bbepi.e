/* GEMSBG C source File
 * Copyright (C) 1992 The General Electric Company
 *
 *	File Name:  @filename@   
 *	Developer:  P. Licato, F. Epstein, YP Du
 *
 * $Source: epi.e $
 * $Revision: 1.179 $  $Date: 04 Jun 1996 14:55:36 $
 */

/*@Synopsis 
  Spin or gradient recalled echo planar imaging sequence.
*/     

/*@Description
     
*/

/**************** MGD Version of EPI ********************************
  2/06/01   BJM: MGD Related changes:
            Changed setfilter calls to support new interface.
            Stripped most fast receiver code.  
            Moved Old 5x/LX comments to Comments file
            Added SetHWMem() call in pulsegenk
            Added dummylinks call on MGD side
  5/10/01   BJM: Moved common code to inlines (calibration checks,
            maxwell correction, PSD compatibility checks)
            Removed more fast receiver code.
            Got rid of #ifdef MGD conditional code
            Fixed cvxfull,cvyfull, cvzfull for blipcor()
            Minimized pass_delay time
            Send echo1_filt.fslot to EP_TRAIN and entry point table
            Added omega_scale to account for 24bit Omega sequencer
            Enable freq offset during ref scan
            Removed burstmode support (no 8645's in MGD)
            Subtract off sl_rcvr for VRGF due to non-zero offset DDS freq

 11.0    02/25/03     NU      MRIge71092: check UserCVs 

 11.0    04/09/03     RS      MRIge82528: opfmri is initialized to have a max value of 1.

 11.0    24/04/03     RS      MRIge83258: opvbw was turned ON for epi.e and epi2.e

 11.0    05/22/03     BJM     MRIge83828: move RT_save below startseq.

 11.0    06/28/03     RJF     MRIge85417: opautote defed to MIN_TE.

 11.0    08/01/03     RJF     MRIge86773: limiting rhnpasses to 512. 

G3 12/09/03 SXZ MRIge89403: initial promote for the epi internal reference 
                scan. Keyword: internref. 

G3 01/29/04 SXZ MRIge90940: the previous promote for the internal ref 
                 scan feature limits the max yres. This is due to that 
                 length of the y prephaser cannot exceed esp. To remove
                 this limitation, the EP_TRAIN macro is modified to use
                 two ramp pulses instead of one, and an waiting pulse is
                 inserted between if y prephaser is longer that esp.
                 Related modified files are: epi.e, epi2.e, epic.h, 
                 refScan.h, refScan.e.

 12.0    03/12/04     SVR     MRIge91727: Changes for supporting > 1024 im/ser

 12.0    04/07/04     RDP     MRIge91983: Inclusion of rotatescan to allow arbitrary 
                              scan plane rotation through CVs.


 12.0    04/09/04     AMR/BJM MRIge92386: Changes for enabling ASSET with EPI
                              for ASSET enhancements for Excite-III

 12.0    05/19/04     AMR     MRIge93847: PSD override functionality for ASSET.
                              Only a phase acceleration factor of 2 which is 
			      also the default will be allowed. Type-in is not 
			      allowed as per the requirement.

 12.0    06/21/04     ZL      MRIhc00996: fix area_gy1 calculation for  EPI+ASSET
                              in full echo acquisition.

 12.0    06/23/04     SVR     MRIhc00610: Set max # phases in sequential
                              multiphase to 256.

 12.0    08/13/04     ZL      MRIhc01021: log error message into GEsyslog before 
                              scan abort during fMRI when boretemp sensor tripped

12.0  09/09/04 SXZ     MRIge90632: all of the UI-related error messages 
                       should be from error database and thus can be
                       translated. 
 
12.0  09/09/04 ZL/SXZ  MRIhc03324

12.0  02/04/05 ZL/TRS  MRIhc05886

14.0  03/09/05 ZL      MRIhc06466: rhpcspacial_dynamic needs to be enabled for fMRI
                                   when rhpcspacial is set to 0, the rhpcspacial_dynamic
                                   should still be set to the center slice to reduce
                                   recon time.
                                   According to Dr. Scott Hink's in house testing, the 
                                   dynamic update of the reference scans is fairly slice
                                   independent.

14.0  03/09/05 ZL      MRIhc06308: rhpcspacial needs to be set to 0, i.e, acquire refscan
                                   for each individual slice, for better IQ in oblique case.

14.0  03/09/05 ZL      MRIhc06307: dynamic refscan needs to be activated for 
                                   EPI+ASSET+MPH (when opfphase>10). It was locked in 12.0 
                                   due to data acquisition error, which is resolved in 14.0.
14.0  04/25/05 ZL      MRIhc06309: odd iref_etl needs to be supported for EPI/fMRI

Value1.5T 04/08/05 KK  YMSmr06515: # of slice locations expansion 
                       Max # of slice is 512 for EPI.
Value1.5T 04/19/05 YI  Added auto voice support changes.
Value1.5T 05/19/05 YI  Added Mild Note(Silent Mode) support changes.

14.0  05/28/05 AMR     MRIhc07356: Merge of fix for YMSmr06713 (Value 1.5T)

Value1.5T 05/31/05 KK  Value1.5T with DCERD2 does not support BACC.
                       Value1.5T Ghost Check (ghost_check)

14.0  06/01/05 LS   MRIge91793 - delay, b0_dither cal files are moved to /usr/g/caldir from
                                 change from /usr/g/bin.

14.0  06/27/05 MSK  MRIhc08159 - Initialized RF_PULSE_INFO, PHYS_GRAD and LOG_GRAD

14.0  07/16/05 ZL   MRIhc05898 - EPI sequence download failure for patient weight above 130kg
                                 with BODY or SURFACE coil on long bore system. This is caused by 
                                 spsp pulse, we can not stretch spsp pulse. 
                                 The fix is to reduce flip angle when 
                                 patient weight is above 130kg. This is a short term fix, a better
                                 one would be designing a better spsp pulse.

14.0  07/16/05 ZL   MRIhc08588 - EPI+MPH with opsldelay > 15s, get refscan hang and/or scp
                                 time out error. This is due to that we are using pass packet to handle
                                 the delay, and the longest sequencer time is around 15s. The fix is to 
                                 break the delay into multiple delays is they are longer than 15s.

14.0  07/27/05 ZL   MRIhc08493 - need to add support for brainwave RT change.

14.0  08/04/05 ZL   MRIhc09115 - Gating+MPH+rhpcspacial = 0 causing refscan hang, this is due
                                 to wrong setting of rhreps, fixed.

14.0  05/31/06 AMR/    MRIhc15685: External trigger support for FUS
               Y Zur   Add auxiliary trigger prior to scan entry point, and the reset the trigger to internal.
                       This starts the scan with external trigger, and then continue to the end of scan as usual.
                       Changes will be in effect only when the "epi_trig" PSD that is part of the FUS protocol
                       will be used. Code changes can be referenced by searching for "ext_trig".

14.2  04/12/06 ARI  MRIhc14923 - Remove GRAM model.

14.2  06/27/06 SHM  MRIhc16090 - Assigning esp to minseqcoil_esp.

14.2  07/10/06 ARI  MRIhc16496 - Change minseq() function interface.

14.2  09/08/06 ARI  MRIhc18055 - Remove pgen_debug flag.
14.0  07/07/06 AMR     MRIhc16435: Rename occurences of "fus_ext_trig" to "ext_trig" so that it is 
                       consistent with implementation in other PSDs like 2dfast and fgre that support
                       external triggering for FUS.                                    

14.0  06/19/07 VAK     MRIhc24685: The maximum xres allowed with ramp sampling
                       is 256 and without ramp sampling the maximum xres is 512
14.0  06/01/07 SWL     MRIhc24523 TR_SLOP should not be included in total
                       scan time calculation if line gating is not on.

14.0  07/02/07 SWL     MRIhc24435 for epispec, max flip angle should be limited to 50 for 3T TRM & CRM and 80 for the other
                       systems to stay under hardware limit. The external grad mode in the RF pulse structure should be
                       set appropriately for pulse stretching. Change was made to the call of setuprfpulse() to set the
                       external grad mode to 1 for epispec rf1 pulse.

14.0  07/13/07 SWL     MRIhc25264: For 1.5T BRM system, the EPI readout gradient
                       needs to be derated via rampopt due to the coil heating.

14.0  09/10/07 SWL     MRIhc26732 : For 1.5T BRM system, the product data sheet 
                       failure is fixed by excluding non fMRI GRE EPI
                       from the derating done for MRIhc25264.

14.2  10/10/06 TRS  MRIhc19114 - Increase overscans for fMRI + ASSET + minTE.
14.2  10/10/06 TRS  MRIhc19129 - Increase number of overscans for fMRI + 
                                  ASSET with minTE.
14.5 10/05/2006 TS   MRIhc15304 - coil info related changes for 14.5

20.0  03/22/2007 SWL MRIhc21901,MRIhc23348, MRIhc23349 - new BAM model 
                     supports multi phase, dynaplan phase, and requires 
                     less input arguments in maxslquanttps().

20.0  06/27/2007 LS  MRIhc24436, MRIhc20970: Supports for displaying grayed out fields: RBW.

20.0  08/24/2007 KK  MRIhc26000: Corrected the position of gz1

20.0  10/10/2007 SWL MRIhc27256, MRIhc27357: 
                                 The scan time should exclude TR_SLOP when line triggering
                                 is not used.

20.0  10/17/2007 ARI MRIhc27631 Change obloptimize to obloptimize_epi function

20.0  11/30/2007 KK  MRIhc27295: avmintr is rounded up after multiplication of opslquant to reduce rounding error.

20.0  11/30/2007 KK  MRIhc19114: Fixed rounding for asset_factor

20.0  10/24/2007 HT MRIhc27495:  The calculation of fmri_coil_limit was set to be working only for pre XRM systems.
                                 
20.0  10/24/2007 HT MRIhc24730:  Bandpass asymmetry correction will not be applied on DVMR receive chain hardware 
                                 and hence change was made to have the correction run only for non-DVMR systems.

20.0  01/08/2008 SWL MRIhc28488: Removed frame per second limit for DVMR hardware.

20.0  01/24/2008 SWL MRIhc32513: Prevented stretching of RF pulse for epispec in setuprfpulse().
                                 And limited the maximum flip angle to 60 degrees for epispec PSD.

15.0  04/16/2008 SWL MRIhc35936: turned on rampopt for all configuration to reduce edge ghosting.

20.0  04/17/2008 GW  MRIhc35883: Fixed the prep-scan failure for DynaPlan

20.0  04/28/2008 GW  MRIhc35928: reset time_ssi to make sure minTR (5ms) not related to prescription order for epiepec 

20.0  05/16/2008 GW  MRIhc36882: reset rhnphases = 1 when enable_1024 = PSD_OFF

20.0  05/28/2008 GW  MRIhc36289: fixed avminte calculation error for top_down view order

20.0  06/04/2008 SWL MRIhc37103: For patient weight higher than 158kg, spsp pulse is disabled, 
                                 and fat sat is forced to prevent download failure. For research mode,
                                 this can be overrided via a CV override_fatsat_high_weight.


20.0  06/10/2008 SWL MRIhc35951: The removal of SPSP RF pulse 3024850 caused minimum slice 
                                 thickness increased. The pull down menu for slice thickness 
                                 was adjusted. 

20.0  07/15/2008 SWL MRIhc38838: B0 dither calibration is removed for DVMR hardware. The EPI
                                 PSD no longer checks or reads from b0 dither cal files.

20.1  10/15/2008 SWL MRIhc40277: code clean up for fmri_coil_limit

20.1  10/29/2008 SWL MRIhc40141: The maximum inversion time is fixed to 4000.

20.1  10/29/2008 SWL MRIhc40636: Overrided minimum delay when cardiac gating is on. 

20.1  10/31/2008  GW MRIhc38807: Set rspnex=2 in mps2 to fix ScanTR noise issue

20.1  12/09/2008  GW MRIhc40248: added maximum #images check for fMRI

20.1  01/14/2009  GW MRIhc41476: Changed maximum value of intleaves to match avmaxyres 
                                 Corrected width of OMEGA pulse for non ramp sampling acq

20.1  02/05/2009  GW MRIhc41862: Modified calculation of Rf2Location to avoid double 
                                 psd_rf_wait shift of rf2 pulse

20.1  02/17/2009 SWL MRIhc41251: Added new rsp timer functions to support 1us resolution.

20.1  02/17/2009 SWL MRIhc42061: Removed redundancy of TTLtime_tot and eegtime_tot from 
                                 non_tetime calculation. Also added control variables to 
                                 enable turning off the TTL pulse and eeg blanking pulses.

20.1  02/24/2009  GW MRIhc42202: Removed gap between slice selection gradient and 
                                 z-direction flow comp gradient when ss_rf1 = 1

20.1  03/11/2009 SWL MRIhc42525: Reset trigger to internal after first TR of dummy scan.

20.1  04/03/2009 DQY GEHmr01487: To support new XFD ID and SR100

20.1  07/06/2009 SWL MRIhc44019: turn off EEG trigger by default.

21.0  04/24/2009  GW MRIhc43183  Applied different ways to calculate end of slice selection 
                                 gradient for target and host to avoid pulsegen failure 
                                 in host side. (MRIhc42387 on 20.1)

21.0  04/24/2009  GW MRIhc43184: code change for DVW gradient spec test of SR150 and GMAX34

21.0  05/08/2009  GW MRIhc43487: Used type-in PSD name(epigradspec) and opuser1 to control
                                 gradient spec test

21.0  07/28/2009  GW MRIhc44186: Corrected the value of ia_gy1 for corner point generation 
                                 in pgen_on_host

SV20.1 07/30/2009 KK GEHmr01833: Lower XFD power limit for EPI 

21.0  08/14/2009  GW MRIhc44763: Changed the logic to have inittarget() called only when the 
                                 gradient test mode is switched for the type-in PSD epigradspec. 

20.1_IB1 08/25/2009 GW MRIhc44418: Implemented two ways to avoid unwanted ESP range for multi-phase 
                                   EPI and fMRI EPI: 
                                   1) Based on the current product, increase ESP until out of 
                                      unwanted ESP range. (by default)
                                   2) Based on convolution dbdt model, minimize ESP first and then 
                                      increase ESP until out of unwanted ESP range. (by type-in PSD
                                      epiespopt (multi-phase EPI) or epiRTespopt (fMRI EPI))
                                   Also added two type-in PSDs to minimize ESP without considering 
                                   unwanted ESP range: epiminesp for epi and epiRTminesp for epiRT.

22.0  11/01/2009 RBA MRIhc42465: Put in support for new Parallel Imaging UI

SV20.1 11/20/2009 DQY GEHmr03409: Use Rect dBdt model for epispec in SV 

22.0   12/31/2009 VSN/VAK  MRIhc46886: SV to DV Apps Sync Up

22.0  01/25/2010 GW  MRIhc47080: Use convolution dbdt model by default for epigradopt on XRM system. 
                                 rampopt is set to off if using convolution dbdt model. 

22.0  02/03/2010 GW  MRIhc47528: set rhref to 4 for self-navigated dynamic phase correction

22.0  04/05/2010 LS  MRIhc48581: disable 3d gradwarp for sequential MPh mode by setting pi3dgradwarpnub=0. 

22.0  04/07/2010 ZZ  MRIhc48883: increased time_ssi based on Firmware recommendation

22.0  04/21/2010 GW  MRIhc48481: changed one of the parameters when calling maxpass() to make 
                                 sure acqs=1 for fMRI

22.0  04/30/2010 GW  MRIhc49786: esprange_check is off by default

22.0  05/13/2010 SWL MRIhc49910: turn off convolution model for 450w configuration

22.0  05/14/2010 GW  MRIhc50364: Forced tmin_total when acqs>1 equal to that when acqs=1 
                                 for MPH EPI

22.0  05/14/2010 GW  MRIhc49787: Corrected the TR roundup error

22.0  05/24/2010 XZ  MRIhc50670  Make EPI compatable with ESE compiler, move include of ctype.h from 
                                 @global to @host

22.0  06/07/2010 GW  MRIhc50463: Added two type-in PSDs (epira3 and epiRTra3) to set rhref=3
                                 and activate ESP lock-out when needed as default

22.0  07/14/2010 GW  MRIhc50987: set Acoustic Reduction incompatible with fMRI and multi-phase EPI

22.0  12/08/2010 DX/GW/SWL MRIhc47130: added SPSP fatsat for fMRI and multi-phase EPI

22.1  02/04/2011 GW  MRIhc53096: Made ASSET factor editable and maximum allowed value depending on coil setting.

23.0  02/10/2011 GW/JX MRIhc54709: Added fMRI/multi-phase EPI realtime B0 drift compensation feature
                                   which can be enabled using CV rtb0_flag;

22.0  02/28/2011 GW MRIhc55403: added user CV7 and CV8 for type-in PSDs epira3 and epiRTra3 to 
                                have options to revert echo-spacing and dynamic phase correction 
                                methods back to DVIB.

23.0  03/15/2011 GW MRIhc51274: added a reseach CV fract_ky_topdown to control partial or full kspace 
                                acquisition for mininum TE and type-in TE with top-down view order. For 
                                MinFull TE, always acquiring full-kspace.

23.0  03/25/2011 ZZ MRIhc55128/MRIhc55130: 
                                Fixed the AutoVoice and TR & Driver Cycle dependency issue for MR-Touch.

23.0  03/29/2011 GW MRIhc56034: added initialization of saved_tmin_total and changed initialization of piuset.

23.0  03/30/2011 GW MRIhc55375  Increased time_ssi to 2ms when etl+etl_iref > 192

23.0  04/05/2011 GW MRIhc56035: smart # of overscan lines: num_overscan is determined based on the 
                                difference between minTE and given TE when the given TE is between minTE 
                                and min Full TE. 

23.0  04/28/2011 UNO MRIhc56520: Image distortion in EPI with ART on 750w. 
                                 SR is set to 50 instead of 20 for EPI family with ART.

23.0  05/04/2010 GW  MRIhc56388: added rhfrsize limit of 512 for dynamic phase correction. This limit is from recon.

23.0  06/01/2011 GW MRIhc51912: If spsp pulse used for rf1, for GE-EPI limit its max Rx-able flip angle and 
                                for SE-EPI scale flip angle down to its max allowed value (if < 90 degree).

23.0  06/13/2011 KK MRIhc57184: Corrected logic for rf chopping.

23.0  06/14/2011 GW  MRIhc56139: Matched the RF choping pattern between disdaq and noraml scan for single-shot fMRI.

23.0  06/20/2011 GW HCSDM00081978: Forced cfaccel_ph_maxstride as 2 if it is < 2 and cleaned up the Parallel
                                   Imaging UI -related code.

23.0  06/21/2011 GW HCSDM00078902: added esp range check for 750W.  

23.0  06/22/2011 KK HCSDM00082374: Added CV6 to adjust taratio with XRMW.

23.0  06/23/2011 YI MRIhc57297: Avoid the case rhhnover > rhnframes in multi-shot fractional ky mode.

23.0  07/14/2011 GW HCSDM00086245: Moved full k #frames calculation to cveval() and changed ceil() 
                                   to ceilf().

23.0  08/10/2011 KK HCSDM00092062: Turned on fixedflag of opte with auto TE.

23.0  09/14/2011 GW HCSDM00094712: Added else statement for user CV setting.

7T23.0  04/11/2012 GW HCSDM00131537 Moved epiCalFileCVInit() call into epiCalFileCVCheck(), which is 
                                    called in cvcheck(). 

*****************************************************************************************/
@inline epic.h
@inline refScan.h
/*jwg bb*/
@inline epi_macros.h

@global 
/*********************************************************************
 *                       EPI.E GLOBAL SECTION                        *
 *                                                                   *
 * Common code shared between the Host and Tgt PSD processes.  This  *
 * section contains all the #define's, global variables and function *
 * declarations (prototypes).                                        *
 *********************************************************************/
/*
 * System header files
 */
/* MRIge42854 BJM */
#include <math.h>
#include <string.h>
#include <stdio.h>

/*
 * EPIC header files
 */
#include <em_psd_ermes.in>
#include <stddef_ep.h>
#include <epicconf.h>
#include <pulsegen.h>
#include <support_func.h>
#include <epic_error.h>
#include <epicfuns.h>

#ifdef PSD_HW   /* Auto Voice */
#include "broadcast_autovoice_timing.h"
#endif

#include "ChemSat.h"

#include "psd_proto.h"
#include "bbepi.h"
#include "grad_rf_bbepi.globals.h"
#include "epic_checkcvs.h"
#include "touch.h"

/* BJM - for RT support */
%ifdef RT
@inline epiRTfile.e RTincludes
%endif 

#define MAXFRAMESIZE_DPC 512 /* max frame size limited by recon when dynamic phace correction is needed */

#ifndef PSD_CFH_CHEMSAT
#define PSD_CFH_CHEMSAT
#endif

%define PSD_SPSPFATSAT

#define MAX_ENTRY_POINTS 15

/* Some Non-SpSP RF1 definitions */
#define PSD_SE_RF1_PW   5ms      /* Pulse width */
#define PSD_SE_RF1_fPW  5.0ms
#define PSD_SE_RF1_LEFT  3100us
#define PSD_SE_RF1_RIGHT 1900us
#define PSD_SE_RF1_R     250     /* Resolution of FL90mc pulse */
#define PSD_GR_RF1_PW   3200us   /* Pulse width */
#define PSD_GR_RF1_fPW  3200.0us
#define PSD_GR_RF1_LEFT  1600us
#define PSD_GR_RF1_RIGHT 1600us
#define PSD_GR_RF1_R     400     /* Resolution of GR30l pulse */

/* needed for Inversion.e inline */
#define PSD_FSE_RF2_fPW   4.0ms
#define PSD_FSE_RF2_R     400

#ifndef RUP_HRD
#define RUP_HRD(A)  (((A)%hrdwr_period) ? (int)((A) + hrdwr_period) & ~(hrdwr_period - 1) : (A))
#endif

/* L_CFL through L_AUTOSHIM occupy 0 - 9 */
#define L_REF  10

#undef TR_MAX
#define TR_MAX 15000000

/* MRIge55604 */
#undef FOV_MIN
#define FOV_MIN 40
#define FOV_MAX_EPI 990
#undef RBW_MIN
#define RBW_MIN 15.625
#undef RBW_MAX
#define RBW_MAX 250.0

#undef MAX_RFPULSE_NUM

/* minimum number of additional ky lines to acquire beyond opyres/2: */
#define MIN_HNOVER_DEF 8
#define MIN_HNOVER_GRE 20

/* dephaser pulse position definitions */
#define PSD_PRE_180 0
#define PSD_POST_180 1

/* Flow Comp */
#define NO_GMN 0
#define CALC_GMN1 1
#define CALC_GMN2 2

/* YMSmr06515: # of slice locations expansion  
#undef DATA_ACQ_MAX
#define DATA_ACQ_MAX 512
*/

#define MAXSLQUANT_EPI 512

#ifdef LOG_CVS
#define DEFV 3
#endif

/* ASPIR for DWI */
#define ASPIR_DWI_MIN_15T_TI  30000
#define ASPIR_DWI_MAX_15T_TI  250000
#define ASPIR_DWI_15T_TI      60000
#define ASPIR_DWI_MIN_3T_TI   50000
#define ASPIR_DWI_MAX_3T_TI   290000
#define ASPIR_DWI_3T_TI       110000

@inline ChemSat.e ChemSatGlobal
@inline SpSat.e SpSatGlobal
@inline Inversion.e InversionGlobal
@inline Prescan.e PSglobal
@inline BroadBand.e BBglobal
@inline ss.e ssGlobal
@inline Asset.e AssetGlobal

/* SXZ::MRIge72411: for edge ghost optimization */
#define NODESIZE 3
#define VRGF_AFTER_PCOR_ALT 32768
#define FAST_VRGF_ALT 2048

/* GEHmr01833, GEHmr02647: XFD Power Limit */
#define XFD_POWER_LIMIT     8.5 /* kW */
#define XFD_POWER_LIMIT_SE  6.4 /* kW */
#define XFD_POWER_LIMIT_GRE 6.3 /* kW */

#define DEFAULT_IREF_ETL 4

/* MRIhc56520: SR for EPI with ART on 750w */
#define XRMW_3T_EPI_ART_SR 5.0

#define TARATIO_XRMW 0.85

/************************************************************************/
@ipgexport
@inline Prescan.e PSipgexport
@inline ChemSat.e ChemSatIpgExport

long rsprot_unscaled[DATA_ACQ_MAX][9]; /* a copy of the rotation matrices
					  unscaled by cf<x,y,z.full, targets,
				          or full scale values */
int off_rfcsz[DATA_ACQ_MAX];           /* This is for concat Sat */
int field_strength;

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
float delay_buffer[10];
float dither_buffer[12];
float ccinx[50];
float cciny[50];
float ccinz[50];
float fesp_in[50];
int esp_in[50];
float g0;
int num_elements;
int file_exist;

/* SXZ::MRIge72411: edge ghost optimization */
float taratio_arr[NODESIZE];
float totarea_arr[NODESIZE];

float vfa_flips[1024]; /*jwg bb for vfa flip schedule*/
float sake_blips[1024]; /*jwg bb for SAKE blip schedule*/
char ssthetafile[128]; /*jwg bb for reading in external THETA waveform*/

@inline ss.e ssIPGexport
/************************************************************************/
@cv
@inline ChemSat.e ChemSatCV
@inline SpSat.e SpSatCV
@inline loadrheader.e rheadercv
@inline BroadBand.e BBcvs
@inline vmx.e SysCVs
@inline Prescan.e PScvs
@inline Inversion.e InversionCV
@inline ss.e ssCV                               /* CVs for spatial spectral pulse */  
@inline epiRtd.e epiRtdCV                       /* CVs for Real-Time Display in Core */
@inline epiMaxwellCorrection.e epiMaxwellCV     /* CVs for Maxwell Compensation      */
@inline epiCalFile.e epiCalCV                   /* CVs for calibration file check    */
@inline refScan.e refScanCV                     /* BJM: SE Ref Scan */
/* MRIge92386 */
@inline Asset.e AssetCVs

%ifdef RT
@inline epiRTfile.e epiRT_CV                    /* CVs for epiRT */
%endif

@inline RTB0.e RTB0cv
int rtb0_comp_flag = 0 with {0,1,0,VIS, "Flag to realtime b0 drift compensation",};
int rtb0_acq_delay = 0 with {0,,0,VIS, "Delay time of realtime b0 drift acquisition",};
int rtb0_midsliceindex = -1 with {-1,,-1, VIS, "Index of middle slice (-1: all slices)",};
float rtb0_outlier_threshold = 10.0 with {0.0,,10.0,VIS, "CF offset outlier threshold in one TR (Hz)",};
float rtb0_outlier_duration = 30.0 with {0.0,,30.0,VIS, "CF offste outlier duration (s)",};
int rtb0_outlier_nTRs;
int rtb0_minintervalb4acq = 0;

/* MRIhc44418 */
int epiespopt_flag = 0 with {0,1,0,INVIS, "Flag for type-in PSD epiespopt",};
int epiRTespopt_flag = 0 with {0,1,0,INVIS, "Flag for type-in PSD epiRTespopt",};
int epiminesp_flag = 0 with {0,1,0,INVIS, "Flag for type-in PSD epiminesp",};
int epiRTminesp_flag = 0 with {0,1,0,INVIS, "Flag for type-in PSD epiRTminesp",};

/* MRIhc50643 */
int epira3_flag = 0 with {0,1,0,INVIS, "Flag for type-in PSD epira3",};
int epiRTra3_flag = 0 with {0,1,0,INVIS, "Flag for type-in PSD epiRTra3",};

/* These two CVs function only for type-in PSDs epira3 and epiRTra3 */
int ra3_minesp_flag = 0 with {0,1,0,INVIS, "Flag for legacy or minimized ESP",};
int ra3_sndpc_flag = 0 with {0,1,0,INVIS, "Flag for legacy or new phase correction",};

int dbdt_model = 0 with {0,1,0,VIS,"dBdt model: 0-rectangular, 1-convolution",};
float dbdtper_new; /* new dbdtper parameter for epigradopt */
int esprange_check = 0 with {0,1,0,VIS,"Flag to avoid unwanted ESP range: 0-off, 1-on",};
int espopt = 1 with {0,1,1,VIS, "Turn on ESP minimization when dbdt_model = 1",};
int espincway = 0 with {0,1,0,VIS, "Way to increase ESP: 0-regenerate waveform, 1-zero padding",};
int no_gy1_ol_gxw = 0 with {0,1,1,INVIS, "0-gy1 overlapping with gxw, 1-not",};

int epigradopt_debug = 0;
int epigradopt_output = 0;

int saved_tmin_total = 0;
int tr_corr_mode = 1 with {0, 2, 0, VIS, "TR error correction mode: 0-off, 1-distribute among slices, 2-burst at the last slice", };

/* ZL::MRIhc08588 */
int num_passdelay = 1 with {1,,1,VIS,"number of pass delay sequence",};

/* ZL::MRIhc06466, MRIhc06308 */
int temp_rhpcspacial = 0 with {0, DATA_ACQ_MAX, 0, VIS, "temporal variable to set rhpcspacial",};

/* SXZ::MRIge72411: top area vs. total area ratio */
float taratio = 0.0 with {0.0,0.90005,0.0,VIS, "Minimal top area ratio in readout gradient",};
int rampopt = 1 with {0,1,1,VIS,"1: enable ramp sampling optimization",};
int taratio_override = PSD_OFF with {0,1,0,INVIS,"1: override taratio",};

/* SXZ::MRIge72411: following cvs show useful info */
float totarea = 0; /* G*usec/cm */
float actratio = 0;

int fmri_coil_limit = 1.0;

/* internref: internal reference scan */
int iref_etl = 0 with {0,,0,VIS, "Internal reference echoes for dynamic phase correction",};
int iref_frames = 0;

int MinFram2FramTime = 30us;

float phase_dither = 0.0 with {,,0.0,VIS, "B0 phase dither value (degrees)",};
int spgr_flag = 0 with {0,1,0,VIS,"SPGR flag",};

int newyres=0;		/* New yres if opnshots/opte/opyres is incompatible. */

int avmintefull = 0 with {0,,0,VIS, "Minimum te with full ky coverage",};   
int cvrefindex1;
int avmintetemp;

int cfh_crusher = 0 with {0,,1,INVIS, "if 1 autogenerate cfh crushers",};   

int fast_rec = 0 with {0,1,0,VIS, "receiver selected: 0=standard recvr, 1=fast recvr",};

/* Given n baselines, use bl_acq_tr1 for first n-1 baselines, bl_acq_tr2
   for nth baseline.  This is to minimize baseline acq. time while
   avoiding sequence preparation failures for the scan that follows. */

int bl_acq_tr1 = 100ms with {1ms,6s, 10ms, MODIFIABLE, "Fast Baseline acquisition sequence length",};
int bl_acq_tr2 = 300ms with {1ms,6s, 100ms, MODIFIABLE, "Baseline acquisition sequence length",};

float fecho_factor; /*SNR*/
float tsp = 8.0 with { 1.0, 1000.0, 8, VIS, "Sampling period (1us).",};
int intleaves = 1 with { 1,512, 1,VIS,"Interleaves to get yres.",};

int ky_dir = 2 with {0,2,2,VIS,"Ky samp dir:0=top/down,1=cent/out,2=bottom/up",};

int dc_chop   =  1 with {0,1,1,VIS,"Receiver phase chop flag: 1=on,0=off",};
/*	  0 = same start polarity (+) for all intleaves.
 	  1 = odd intleaves start +, even start -
 	  2 = 1st half of intleaves start +, second half interleaves start -
 	  3 = 1st & 3rd quarters start +, 2nd & 4th quarters start -.  */
int kx_dir = 0 with {0,3,0,VIS,"Kx samp dir:0=same,1=alt w/intleave,2=halfset,3=quarterset.",};

int etot = 0 with {0,,0,VIS,"Total echoes required to feed MPS.",};
int emid = 0 with {0,,0,VIS,"1st echo right of TE midpoint.",};
int e1st = 0 with {0,,0,VIS,"1st echo to turn on.",};

/*    Allow ram function in SCAN.  Use only w/RAWDATA=1 (ie.no DAB sort). */
int seq_data  = 0 with {0,1,0,VIS,"0=std sorting,1=time seq order.",};

float msamp = 0.0 with {,,0.0,VIS,"Default echo shift, samp per, +=R,-=L.",};
float dsamp = 0.0 with {,,0.0,VIS,"Delta echo shift,   samp per, +=R,-=L.",};
float delpw;
 
/* Number of repeated scans at each slice */
/* LX TPS has 8M bytes and allows at least 512 passes. ypd */
int reps        = 1 with {1,999,1,VIS,"# scan repetitions.",};
int pass_reps   = 1 with {1,999,1,VIS,"# pass repetitions.",};
int max_dsht    = 8 with {1,256,8,VIS,"# diff grad amps in increment cycle.",};

int rf_chop = 1 with {0,1,1,VIS,"1=chop RF for intleaves>1,0=don't.",};

 /*spsp*/
int rftype = 1 with {0,1,1,VIS,"1=extern rfpulse, 0=sinc rfpulse",};
int thetatype = 0 with {0,1,0,VIS,"1=play extern theta pulse, 0=no theta",};
int gztype = 1 with {0,1,1,VIS,"1=extern grad, 0=create by macro",};

int hsdab   = 1 with {0,1,1,VIS,"0=std dab packets,1=EPI dab packets.",};

/* LX TPS has 8M bytes and allows at least 512 passes. ypd */
int slice_num = 1 with {1,DATA_ACQ_MAX,1,VIS,"slice number within rep.",}; /* YMSmr06515 */
int rep_num = 1 with {1,999,1,VIS,"rep number within total reps.",};

int endview_iamp;  /* end instruction phase amp */
int endview_scale; /* ratio of last instruction amp to maximum value */

int gx1pos   = 1 with {0,1,1,VIS,"gx1 placement: 0=pre-180, 1=post-180.",};
int gy1pos   = 1 with {0,1,1,VIS,"gy1 placement: 0=pre-180, 1=post-180.",};

int eosxkiller  = 0 with {0,1,1,VIS,"eos x killer pulses: 0=off, 1=on.",};
int eosykiller  = 1 with {0,1,1,VIS,"eos y killer pulses: 0=off, 1=on.",};
int eoszkiller  = 1 with {0,1,1,VIS,"eos z killer pulses: 0=off, 1=on.",};
int eoskillers  = 1 with {0,1,1,VIS,"eos killer pulses: 0=off, 1=on.",};
int eosrhokiller  = 1 with {0,1,1,VIS,"eos rho killer pulses: 0=off, 1=on.",};

int gyctrl = 1 with {-1,1,1,VIS, "GY Blip control: 1=on, 0=off",};
int gxctrl = 1 with {0,1,1,VIS,"GX Read control: 1=on, 0=off.",};
int gzctrl = 1 with {0,1,1,VIS,"GZ control: 1=on, 0=off.",};

int ygmn_type;   /* specifies degree of FC on Y */
int zgmn_type;   /* specifies degree of FC on Z */

/* VGRF CVs */
int vrgfsamp  = 0 with {0,1,0,VIS, "0=std sampling,1=VRGF sampling.",};
int autovrgf = 1 with {0,1,1,VIS, "1=vrgf program called automatically in predownload, 0=manual mode.",};
float vrgf_targ = 2.0 with {0.2,16.0,2.0,VIS,"vrgf oversampling ratio target value.",};

float fbhw = 1.0 with {0.0,1.0,1.0,VIS,"Fraction of blip half width excluded from sampling.",};
int vrgf_reorder = 1 with {0,1,1,VIS, "1=vrgf->PC (new), 0=PC->vrgf (old)",};

/* MRIge66374 - this get applied in epigradopt (needs to be 0) */
int   osamp     = 0 with {0,1024,0,VIS,"Fractional echo oversamples.",};

int   esp       = 0 with {0,,0,VIS,"echo spacing",};
int   etl       = 1 with {1,,1,VIS,"echo train length",};
int   eesp      = 0 with {0,,0,VIS,"effective echo spacing",};
int   nblips, blips2cent;   /* total number of blips and number of blips
							  to the center of ky offset */
int ep_alt = 0 with {0,2,0,VIS,"Alt read sign:0=no,1=odd/evn,2=halves,3=pairs",};

int tia_gx1, tia_gxw, tia_gxk;     /*temp internal amps that flip in polarity*/
float ta_gxwn;                     /* temp value for negative a_gxw value */
float rbw;                         /* rbw in Hz */

/* MinTE Calculation CV's */
int   avminxa, avminxb, avminx, avminya, avminyb, avminy;
int   avminza, avminzb, avminz, avminssp;
float avminfovx, avminfovy;

int hrdwr_period = 4us with {4us,128us,32us,VIS, "Hardware specific base period.",};
int samp_period = 8us with {0,,0,VIS, "sample period generated by epigradopt.",};
int pwmin_gap = 2*4us; /*=2*GRAD_UPDATE_TIME*/

float frqx = 200.0 with {0.0,1000.0,200.0,VIS,"Kx sampling freq peak (KHz).",};
float frqy = 2.0   with {0.0,1000.0,2.0,VIS,"Ky sampling freq peak (KHz).",};

int dacq_offset = 0us with {0,,0us,VIS,"dacq packet offset relative to gxw (us)",};
int   pepolar = 0 with {0,1,0,VIS,"1= flip phase encoding polarity, 0=don't.",};

int   tdaqhxa, tdaqhxb;
float delt;

/* sliding data acquisition window control: */
int   tfon = 1 with {0,1,1,VIS,"Time shift interleaves:0=off,1=on.",};

/* Homodyne (minTE) scan, ky_offset - moves echo to flow-comp echo group*/
int fract_ky = PSD_FULL_KY with {PSD_FULL_KY,PSD_FRACT_KY,PSD_FULL_KY,VIS,"Fractional ky space acquisition flag:0=off,1=on",};
float ky_offset = 0.0 with {-256,256,0,VIS,"# Ky lines to offset echo peak, -=early, +=later",};
float gy1_offset = 0.0 with {,,0.0,VIS,"gy1 dephaser area difference for ky shift",};
int rhhnover_max=0;	/* Maximum allowed rhhnovers due to physical space on the boards */
int rhhnover_min = 8;   /* minimum number of overscans */
int num_overscan = 8;   /* BJM: this was added for multi-shot EPI */
int fract_ky_topdown = 1 with {0,1,1,VIS,"Fractional ky space acquisition flag for top-down view order:0=off,1=on",};

int smart_numoverscan = 0 with {0,1,0,VIS,"flag for smart number of over-scan lines",};

/* MRIhc57297  06/15/2011 YI */
int ky_offset_save;
int rhhnover_save;
int rhnframes_tmp;

/* needed for Inversion.e */
int satdelay = 0ms with {0,,0,INVIS, "Delay between last SAT and 90",};

int   td0       = 4 with {0,,1,INVIS, "Init deadtime",};
int   t_exa     = 0 with {0,,0,INVIS,"time from start of 90 to mid 90"};
int   te_time   = 0 with {0,,0,INVIS," te * opnecho ",};
int   pos_start = 0 with {0,, ,INVIS, "Start time for sequence. ",};
int   post_echo_time = 0 with {0,,,INVIS, "time from te to end of seq",};
int   psd_tseq = 0 with {0,,,INVIS, " intersequence delay time for cardiac",};
int   time_ssi  = 1000us with {0,,8000us,INVIS,"time from eos to ssi in intern trig",};

float dacq_adjust = 0.0 with {,,,VIS, "dacq starting time fine tuning adjustment",};

int watchdogcount = 15 with{1,15,15,INVIS,"Pulsegen execution time (x5sec) before timeout",};

int dabdelay = 0 with {,,,INVIS, "Extra time for dab packet (negative is more)",};

int long_hrdwr_period = 1 with {0,1,1,VIS,"1: hrdwr_period=96us for sr20; 0: hrdwr_period=64us for sr20. ",};

int tlead     = 25us with {0,,25us,INVIS, "Init deadtime",};
int tleadssp  = 25us with {0,,25us,INVIS, "SSP Init deadtime",};
int act_tr    = 0 with {0,,,INVIS, "actual tr",};
/*jwg change rfconf initialization for broadband*/
/*int rfconf = ENBL_RHO1 | ENBL_RHO2 | ENBL_THETA;*/
int rfconf = ENBL_RHO1 + ENBL_THETA + ENBL_OMEGA + ENBL_OMEGA_FREQ_XTR1;
int ctlend = 0 with {0,,0,INVIS,"card deadtime when next slice in intern gated",};
int ctlend_last = 0 with {0,,0,INVIS,"deadtime for last slice in a cardiac scan",};
int ctlend_fill = 0 with {0,,0,INVIS, "deadtime for last slice in a filled R-R",};
int ctlend_unfill = 0 with {0,,0,INVIS, "deadtime for last slice in a unfilled R-R",};
int dda = 0 with {0,,4,INVIS," number of disdaqs in scan (not pairs)",};
int debug = PSD_OFF with {0,1,0,VIS,"1 if debug is on ",};
int debugipg = PSD_OFF with {0,1,0,VIS,"1 if debugipg is on ",};
int debugepc = PSD_OFF with {0,1,0,VIS,"Phase debug flag (1 = ON)",};
int debugRecvFrqPhs= PSD_OFF with {0,1,0,VIS,"1 to turn on exciter phase debug",};
int debugdither = PSD_OFF with {0,1,0,VIS,"1 to turn on b0dither debug",};
int debugdelay = PSD_OFF with {0,1,0,VIS,"1 to turn on delay debug",};
int debugileave = PSD_OFF with {0,1,0,VIS,"1 to turn on ileaveinit debug",}; 
int dex = 0 with {,,0,INVIS, "num of discarded excitations",};
int gating = 0 with {0,,0,INVIS,"gating - TRIG_INTERN, TRIG_LINE, etc.",};
int ipg_trigtest = 1 with {0,1,1,INVIS, "if 0 use internal trig always",};
int gxktime = 0 with {0,,,INVIS, "x Killer Time.",};
int gyktime = 0 with {0,,,INVIS, "y Killer Time.",};
int gzktime = 0 with {0,,,INVIS, "z Killer Time.",};
int gktime = 0 with {0,,,INVIS, "Max Killer Time.",};
int gkdelay = 100us with {0,,,INVIS,"Time to delay killers from end of readout train.",};

int   scanslot = 0 with {0,7,4,VIS, "Scan filter slot number",};/*LX - 4 in epi2*/

/* temp crusher amplitudes */
float gx1_area;                  /* readout dephaser pulse area */
float area_gz1, area_gzrf2l1; 
float area_std;                   /* crusher calcs */

/* gradient echo refocus */
int avail_pwgz1;		/* avail time for gz1 pulse */

int   prescan1_tr = 2s with {0,,,INVIS,"1st pass prescan time",};
int   ps2_dda     =  0 with {0,,,INVIS,"Number of disdaq in 2nd pass prescan.",};
int   avail_pwgx1;               /* avail time for gx1 pulse */
int   avail_image_time;          /* act_tr for norm scans*/
int   avail_zflow_time;          /* time available for gz1, gzmn pulses */

int test_getecg = 1; 
int premid_rf90 = 0 with {,,0, INVIS,"Time from beg. of seq. to mid 90", };

int sar_amp;  /* debug variable for power monitor */
int sar_cycle;
int sar_width;
/*    min sequence times based on coil heating */
int   max_seqtime;               /* nax time/slice for max av panel routines */
int   max_slicesar;              /* min slices based on sar */
float myrloc = 0 with {0,,,INVIS, "Value for scan_info[0].oprloc",};
int   other_slice_limit;         /* temp av panel value */

float target_area;      /* temp area */
float start_amp;       /* temp amp */
float end_amp;         /* temp amp */

int pre_pass  = 0 with {0,,0,INVIS, "prescan slice pass number",};
int nreps     = 0 with {0,,0,INVIS, "number of sequences played out",};
int max_num_pass = 512 with {0,999,512,VIS, "maximum number of passes",};

/* Scaling CVs */
float xmtaddScan;

/* needed for Inversion.e */
float rfscale = 1.0 with {,,1.0,INVIS,"Rf pulse width scaling factor",};

/* Offset from end of excitation pulse to magnetic isocenter */
int rfExIso;

/* Inner volume flag */
int innerVol = 0 with {0, 1, 0, VIS, "Inner volume flag",};
float ivslthick = 5 with {1, FOV_MAX_EPI, 480, VIS, "Inner Volume Slice thickness in mm.",};

/* These CVs are used to override the triggering scheme in testing. */
int psd_mantrig = 0 with {0,1,0, INVIS, "manual trigger override",};
int trig_mps2 = TRIG_LINE with {0,,TRIG_INTERN, VIS, " mps2 trigger",};
int trig_aps2 = TRIG_LINE with {0,,TRIG_INTERN, VIS, " aps2 trigger",};
int trig_scan = TRIG_LINE with {0,,TRIG_INTERN, VIS, " scan trigger",};
int trig_prescan = TRIG_LINE with {0,,TRIG_INTERN, INVIS,"prescan trigger",};
int read_truncate = 1 with {0,,1,INVIS, "Truncate extra readout on fract echo",};

int trigger_time = 0 with {0,,0,INVIS, "Time for cardiac trigger window",};
int use_myscan = 0 with {0,,0,INVIS,"On(=1) to use my scan setup",};

/* needed for Inversion.e */
int t_postreadout = 0;

int initnewgeo = PSD_ON;     /* for initialization of obloptimize_epi in cvinit() */
int obl_debug = PSD_OFF with { 0, 1, 0, INVIS, "On(=1) to print messages for obloptimize_epi",};
int obl_method = 1 with {0,1,1,INVIS,"1=optimal, 0=to force targets to worst case",};
int debug_order = 0 with {0,,0,INVIS,"On(=1) to print data acq order table",};
int debug_tdel = 0 with {0,1,0,VIS,"On(=1) to print ihtdeltab table",};
int debug_scan = 0 with {0,,0,INVIS,"On(=1) to print scan & rsp info tables",};
int postsat;
int order_routine = 0 with {,,0,INVIS, " slice ordering routine",};
int scan_offset;		 /* adds 'x' mm to all scan locations */

int dither_control = 0;		 /* 1 means turn dither on  */
int dither_value = 0 with {0,15,6,VIS, "Value for dither",};

int slquant_per_trig = 0 with {0,,0,INVIS, "slices in first pass or slices in first R-R for XRR scans",};
int xtr_offset = -56 with {,,-30,VIS, "Value for xtr_offset",};

int non_tetime;                  /* time outside te time */
int slice_size;                  /* bytes per slice */
int max_bamslice;                /* max slices that can fit into bam */
int bw_rf1, bw_rf2;             /* bandwidth of rf pulses */

/* x dephaser attributes */
float a_gx1;
int ia_gx1;
int pw_gx1a;
int pw_gx1d;
int pw_gx1;
int single_ramp_gx1d;      /* "bridge" decay ramp of gx1 into echo train */

/* y dephaser attributes */
float area_gy1;

/* Blip attributes */
float area_gyb;

/* Omega Pulse Attributes */
float a_omega;
int ia_omega;

/* dummy pulse width */
int pw_dummy;

float bline_time = 0;  /* time to play baseline acquistions */
float scan_time;   /* time to play out scan (without burst recovery) */

int pw_gx1_tot;
int pw_gy1_tot;
int pw_gymn1_tot, pw_gymn2_tot;
float gyb_tot_0thmoment;
float gyb_tot_1stmoment;

int pw_gz1_tot;
int pw_gzrf2l1_tot;
int pw_gzrf2r1_tot;

int ia_hyperdab=0;
int ia_hyperdabbl=0;

int dab_offset = 0;
int rcvr_ub_off = -100;  /* receiver unblank offset from beg of echo0000 packet */

int temprhfrsize;

/* variables used in gradient moment nulling */
float zeromoment;
float firstmoment;
float zeromomentsum;
float firstmomentsum;
int pulsepos;
int invertphase;

float xtarg = 1.0 with {0.0,10.0,1.0,VIS, "EPI read train logical x target",};
float ytarg = 1.0 with {0.0,10.0,1.0,VIS, "EPI read train logical y target",};

/* slice reset - ability to perform multi-slice scans all at a single
   location.  Needed for testing. */
int slice_reset = 0 with {0,1,0,VIS,"Perform multi-slice at single location, 0=off,1=on",};
float slice_loc = 0.0 with {,,0.0,VIS,"Slice offset (mm), when slice_reset=1.",};

int ditheron = 1 with {0,1,1,VIS,"1=use b0 values from /usr/g/caldir/b0_dither.cal, 0=don't",};
float dx = 0.0 with {,,0.0,VIS,"phys X dither in deg (dx shift to + readout, -dx shift to -",};
float dy = 0.0 with {,,0.0,VIS,"phys Y dither in deg (dy shift to + readout, -dy shift to -",};
float dz = 0.0 with {,,0.0,VIS,"phys Z dither in deg (dz shift to + readout, -dz shift to -",};

int b0calmode = 0 with {0,1,0,VIS,"1=enable 3-axis b0 test mode, 0=disabled",};
int delayon = 1 with {0,1,1,VIS,"1=use delay values from /usr/g/caldir/delay.dat, 0=don't",};

int pkt_delay = 0us with {0,1ms,0,VIS,"Hrdwr Delay between RBA & 1st Sample Acquired (us).",};
int   gxdelay = 0us with {-1ms,1ms,-40us,VIS,"X grad delay (us).",};
int   gydelay = 0us with {-1ms,1ms,-40us,VIS,"Y grad delay (us).",};
float gldelayx = 0us with {-10.0ms,10.0ms, 0.0,VIS, "Acq. Window delay wrt X Grad (us).",};
float gldelayy = 0us with {-10.0ms,10.0ms, 0.0,VIS, "Acq. Window delay wrt Y Grad (us).",};
float gldelayz = 0us with {-10.0ms,10.0ms, 0.0,VIS, "Acq. Window delay wrt Z Grad (us).",};
float pckeeppct = 100.0 with {0.0, 100.0, 100.0, VIS,"Percentange of post-RFT array to use in phase correction",};

/* multi-phase */
int mph_flag = 0 with {0,,0,INVIS,"on(=1) flag for FAST Multi-Phase option",};
int acqmode = 0 with {0,,,INVIS, "acq. mode, 0=interleave, 1=sequential",};
int max_phases with {0,512,,INVIS,"Maximum number of phases",};
int opslquant_old = 1 with {1,SLTAB_MAX,1,VISONLY, "Slice quantity",};
int piphases with {0,512,,INVIS,"Number of phases",};

/* echo spacing and gap */
int reqesp = 0 with {0,,0,VIS,"Requested echo spacing: 0=auto, nonzero=explicit",};
int autogap = 0 with {0,2,0,VIS,"1:auto set read gap = blip duration, 0:don't, 2:compute dB/dt sep.",};
int minesp;

/* reduced image size */
int fft_xsize = 0 with {0,1024,0,VIS, "Row FT size",};
int fft_ysize = 0 with {0,1024,0,VIS, "Column FT size",};
int image_size = 0 with {0,1024,0,VIS, "Image size",};
             
/* off-center FOV control */
float xtr_rba_control = 1 with {0,1,1,VIS,"XTR-RBA Timing: 1=measured, 0=calculated.",};
float xtr_rba_time = XTRSETLNG + XTR_TAIL with {,,XTRSETLNG + XTR_TAIL,VIS, "phase accumulation interval for off-center FOV (usec)",};
float frtime = 0.0 with {,,,VIS,"read window phase accumulation interval for off-center FOV (usec)",};
int readpolar = 1 with {-1,1,1,VIS,"readout gradient base polarity: 1=positive, -1=negative.",};
int blippolar = 1 with {-1,1,1,VIS,"blipo gradient base polarity: 1=positive, -1=negative.",};

/* ref scan control */
int ref_mode = 1 with {0,2,0,VIS, "Ref Mode: 0=loop over all slices, 1=loop to ioscenter slc, 2=isocenter slc only",};
int refnframes = 256 with {1,YRES_MAX,256,INVIS,"# of recon frames for ref scan.",};

/* ref correction */
/* This variable is pass to epiRecvFrqPhs() and enables/disables the freq offset in the */
/* receiver (to offset the FOV) for ref scanning */
int ref_with_xoffset = 1 with {0,1,1,VIS, "Ref Correction: 0=off, 1 = include freq offset x.",};
int RefDatCorrection = 0 with {0,1,0,VIS, "Ref Pre Correction: 0=off, 1 = calc phase split",};
float phaseScale = 2.0 with {-4.0,4.0,2.0,VIS, "Phase Split Scale",};
int setDataAcqDelays = 1 with {0,1,1,VIS, "Turn ON SSP delays (0 = no setperiod() in core )",};
int xtr_calibration = 0 with {0,2,0,VIS, "Calibrate XTR-RBA phase accumulation",};
int refSliceNum = -1 with {-1,256,-1,VIS, "Spatial Ref Scan Slc (0=all,-1=isocenter slc)",};

/* Value1.5T May 2005 KK */
int ghost_check = 0 with {0,2,0,VIS,"0:off 1:phase cor. off mode(check for epi calibration) 2:phase cor. on mode",};
int gck_offset_fov = 1 with {0,1,0,VIS,"1/4 FOV offset in ghost_check 0:off 1:on",};

int core_shots;
int disdaq_shots;
int pass_shots;
int passr_shots;
int pass_time;    /* total time for pass packets */

int pw_gxwl1 = 0;
int pw_gxwl2 = 0;
int pw_gxwr1 = 0;
int pw_gxwr2 = 0;
int pw_gxw_total = 0 with {0ms,,0ms,VIS, "pw_gxwl + pw_gxw + pw_gxwr",};

int pass_delay = 1us with {1us,,1us,VIS, "ssp delay prior to sending pass packet(us)",};

int nshots_locks  = 1 with {0,1,1,VIS, "1=lockout opnshots<min_nshots, 0=allow all opnshots values.",};
int min_nshots = 1 with {1,8,1,VIS, "Minium number of shots allowed.",};

/* phase-encoding blip oblique correction (for oblique scan planes) cvs */
float da_gyboc = 0.0 with {0.0,2.2,0.0,VIS, "Tweaking value for a_gyboc.",};
float oc_fact = 2.0 with {-10.0,10.0,1.0,VIS, "Multiplication factor for a_gyboc.",};
int oblcorr_on = 1 with {0,1,1,VIS, "Control switch for use of oblique plane  blip correction [0=off,1=on].",};

/* default oblcorr_perslice off because tgt sequence update times become
   prohibitively long when updating blip instruction amplitudes on a per-slice
   basis */
int oblcorr_perslice = 1 with {0,1,0,VIS, "Perform oblique correction on per slice basis [0=off,1=on].",};
int debug_oblcorr = 0 with {0,1,0,VIS, "Debug switch for phase-encoding blip correction [0=off,1=on].",};
float bc_delx = 0.0 with {-1000.0,1000.0,0.0,VIS, "Interpolated x delay for blip correction.",};
float bc_dely = 0.0 with {-1000.0,1000.0,0.0,VIS, "Interpolated y delay for blip correction.",};
float bc_delz = 0.0 with {-1000.0,1000.0,0.0,VIS, "Interpolated z delay for blip correction.",};
float percentBlipMod = 0.0;

int   cvxfull = MAX_PG_IAMP;
int   cvyfull = MAX_PG_IAMP;
int   cvzfull = MAX_PG_IAMP;

/* cvs for modified rbw annotation for vrgf */
float bw_flattop;
float area_usedramp;
float pw_usedramp;
float area_usedtotal;

/* Spec PSD Flag */
int epispec_flag = 0 with {0,1,0,VIS, "Enable short RF & no Chem Sat.",};

/* Omega Scale (8 bit shift = 256)*/
float omega_scale= 256.0 with {1.0,4096,256,VIS, "Instruction amplitude scaling",};
int start_pulse = 0;

/* MRIge91983 - RDP - scan plane rotation CVs */
float my_alpha = 0.0 with {-360.0, 360.0, 0.0, VIS, "Rotation around X-axis", };
float my_beta = 0 with {-360.0, 360.0, 0.0, VIS, "Rotation around Y-axis", };
float my_gamma = 0.0 with {-360.0, 360.0, 0.0, VIS, "Rotation around Z-axis", };

/* EXT TRIGGER */
int ext_trig = 0 with {0,1,0,INVIS,"Externally Triggered Scan (1=ON, 0=OFF)",};

float rup_factor = 2.0; /* MRIhc19114: round factor for asset */

/* high patient weight */
int override_fatsat_high_weight = 0 with {0,1,0,INVIS,"Override forcicng fat sat use for high patient weight (1=ON, 0=OFF)",};
int bigpat_warning_flag = PSD_ON;

/* for DVw gradient test */
int epigradspec_flag = 0 with {0,1,0,VIS, "Enable DVw gradient test.",};
int dvw_grad_test = 0 with {0,2,0,INVIS,"Select DVw gradient test (0=DEFAULT, 1=SR150, 2=GMAX34)",};

int fullk_nframes = 1;

/*jwg bb external rf cvs*/
/*for external RF pulses. All values will be overwritten*/
int   specspat_temp        = 1;
int   res_temp             = 320;
int   nom_pw_temp          = 1280;
float nom_flip_temp        = 90;
float abswidth_temp        = 0.32058;  
float effwidth_temp        = 0.21609;  
float area_temp            = 0.24701;  
float dtycyc_temp          = 0.39062;  
float maxpw_temp           = 1.0;  
float max_b1_temp          = 0.11607;  
float max_int_b1_sqr_temp  = 0.00596;  
float max_rms_b1_temp      = 0.05396;
float nom_bw_temp; 
int   isodelay_temp; 
float a_gzs_temp;
float nom_thk_temp;
int   extgradfile_temp;
float nom_thk_rf1;
float target;

int thetaflag = 0; /*jwg bb this is for phase modulation of RF pulse*/

/*for troubleshooting shift in PE direction*/
float phase_mod = 10.5 with {-1000,1000,10.5,VIS,"Factor for phase modulation to account for off-resonance",};

/*for shifting the metabolites into the passband*/
float sw_freq = 0 with {0,2000,0,VIS,"Spectral bandwidth for SPSP RF, needed for shifting passbands",};
float sw;

/*for user control of BW for ramp sampled EPI*/
int user_bw = 0;

/*for disabling internal reference etl, opuser24*/
int enable_iref_etl = 0;
/*enable vfa schemes, opuser25*/
int vfa_flag = 0;
/*enable SAKE schemes, opuser26*/
int sake_flag = 0;
int sake_max_blip = 1;
int rtime, ftime;

/*cvs for multi-frequency acquisition*/
float df1, df2, df3, df4, df5;
float df1_ppm = 0 with {-10000, 10000, 0, VIS, "Frequency offset for pyruvate (ppm)" };
float df2_ppm = 12 with {-10000, 10000, 1000, VIS, "Frequency offset for lactate (ppm)" };
float df3_ppm = -8 with {-10000, 10000, 1000, VIS, "Frequency offset for urea (ppm)" };
float df4_ppm = 8 with {-10000, 10000, 8, VIS, "Frequency offset for compound 4 (ppm)" };
float df5_ppm = 6 with {-10000, 10000, 8, VIS, "Frequency offset for compound 5 (ppm)" };
float met_ppm;
int num_frames = 1;
int num_mets = 1;

/*CV for readout modulation*/
int wg_omegaro1 = TYPOMEGA;
/*jwg end*/

/* Define MRE CVs */
@inline touch.e TouchCV

/****************************************************************************/

@host
/*********************************************************************
 *                        EPI.E HOST SECTION                         *
 *                                                                   *
 * Write here the code unique to the Host PSD process. The following *
 * functions must be declared here: cvinit(), cveval(), cvcheck(),   *
 * and predownload().                                                *
 *********************************************************************/

/* Local function declarations */
STATUS setEpiEsp(void);
STATUS mph_protocol(void);

/* MRIhc44418 */
STATUS optGradAndEsp_conv(void);
STATUS optGradAndEsp_rect(void);
STATUS epigradopt_rect(float, int);
float calcdbdtper_conv(void);
float intercept(float, float, int, int);
STATUS searchEspLonger_rect(int, int);
int getEspOutOfUnwantedRange(int, int, int);
int isGradAndEspReoptNeeded(void);
int getReadoutPhyAxis(void);
int isEspOutOfUnwantedRange(int,int);
void readEspRange(void);
void procNoEspRangeFile(FILE *);
int isCommentOrBlankLine(char *);
void printEpigradoptLog(void);
void printEpigradoptResult(void);
void printCornerPoint(int, int *, float *, float *);
void printDbdtper(float, int nump, int *, float *, float *, float *);
void printEspRange(void);

%ifdef RT
@inline epiRTfile.e epiRTfuncs
%endif

/* System includes */
#include <stdio.h>
#include <stdlib.h>

/* Local includes */
#include "sokPortable.h"   /* includes for option key functionality */
#include "epic_iopt_util.h"

#include "sar_pm.h"
#include "grad_rf_bbepi.h"
#ifndef SIM
/* Needed for epic_warning() */
#include "epic_rt.h"
#include "psdIF_inc.h"
#include "psdIF_proto.h"
#endif /* !SIM */

#ifdef EMULATE_HW
#define checkOptionKey(x) 0
#endif

#include <printDebug.h>

/* fec : Field strength dependency library */
#include <sysDep.h>
#include <sysDepSupport.h>
#include <psd.h>
#include <ctype.h>
#define BOGUS_ERMES_NUMBER 0

#define SINC_PULSE 0

char  estr[80];

/*jwg bb for reading external waveform and vfa schemes*/
char rf1froot[80]; 
char rf1_datfile[80]; 

int vfa_ctr = 0;
char fileloc_vfa[128];
char vfa_loc_tmp[10];

/*jg bb sake*/
char fileloc_sake[128];
int sake_ctr = 0;

/*jwg end*/

float save_opnex;
int save_fixed;
int save_exist;
int save_newgeo;

FILTER_INFO scan_filt;          /* Used in Inversion.e */
FILTER_INFO echo1_filt;         /* Used by epi.e */

#define Present 1
#define Absent 0

/* Array to hold max B1 for each entry point. */
float maxB1[MAX_ENTRY_POINTS], maxB1Seq;
int   entry, pulse;           /* loop counters */

int hrf1a, hrf1b;               /* location of rf1 center */
int hrf2a, hrf2b;               /* location of rf2 center */
int   crusher_type;             /* Vrg or non vrg type define */
float crusher_scale[NECHO_MAX];  /* reserve space for crusher scale factors*/

int av_temp_int;                 /* temp placement for advisory panel return values */
float av_temp_float;             /* temp placement for advisory panel return values */

OPT_GRAD_INPUT gradin;     /* gradient input paramters */
OPT_GRAD_PARAMS gradout;   /* gradient output paramters for optimal grads */

static char supfailfmt[] = "Support routine %s failed";

int save_dvw_grad_test = -1;
/* MRIhc44418 */
#define DBDTMODELRECT 0
#define DBDTMODELCONV 1
#define DBDT_STEPSIZE 2
#define DBDT_MAXNUMSTEPS 25
#define DBDT_ETL 2 /* 2 is sufficient for calculating dbdtper using convolution model */
#define XAXIS 0x0001
#define YAXIS 0x0002
#define ZAXIS 0x0004
#define MAXNUMESPRANGE 5
#define MAXCHAR 150

int dbdtper_count = 0;
int total_gradopt_count = 0;
int each_gradopt_count = 0;

int no_esprangefile = 0;
int numesprange_x = 0;
int esprange_x[MAXNUMESPRANGE][2];
int numesprange_y = 0;
int esprange_y[MAXNUMESPRANGE][2];
int numesprange_z = 0;
int esprange_z[MAXNUMESPRANGE][2];

int epigradopt_debug_old = -1;
int reopt_flag = PSD_ON;
int dbdt_model_old = -1;
float cfdbdtper_old = -1;
int esprange_check_old = -1;
int espopt_old = -1;
int espincway_old = -1;
int opmph_old = -1;
int rampopt_old = -1;
long rsprot_old[9] = {0,0,0,0,0,0,0,0,0};
OPT_GRAD_INPUT gradin_old = {-1, -1};     

/* MGD inlines */
@inline epiImageOptionCheck.e epiImageCheck
@inline epiCalFile.e epiCalFileHost

/* MGD: needed for filter changes */
@inline Prescan.e PShostVars

/* For enabling more than 1024 im/ser -Venkat */
int enable_1024 = 0; 
int max_slice_limit = DATA_ACQ_MAX;

@inline epi_iopts.e AllSupportedIopts
@inline epi_iopts.e ImagingOptionFunctions

/* load up psd header */
abstract("Spin or gradient recalled echo planar imaging sequence (rev lx 54)");
psdname("EPI");

/* ****************************************
   MYSCAN
   myscan sets up the scan_info table for a hypothetical scan.
   It is controlled by the cv opslquant, and opslthick, and opfov. 
   ************************************** */
STATUS
#ifdef __STDC__ 
myscan( void )
#else /* !__STDC__ */
    myscan()
#endif /* __STDC__ */
{
    int i,j;
    int num_slice;
    float z_delta;		/* change in z_loc between slices */
    float r_delta;		/* change in r_loc between slices */
    double alpha, beta, gamma; /* rotation angles about x, y, z respectively */
    
    num_slice = exist(opslquant);
    
    r_delta = exist(opfov)/num_slice;
    z_delta = exist(opslthick)+exist(opslspace);
    
    scan_info[0].optloc = 0.5*z_delta*(num_slice-1);
    if (myrloc!=0.0)
        scan_info[0].oprloc = myrloc;
    else 
        scan_info[0].oprloc = 0;
    
    for (i=1;i<9;i++)
        scan_info[0].oprot[i]=0.0;
    
    switch (exist(opplane)) {
    case PSD_AXIAL:
        scan_info[0].oprot[0] = 1.0;
        scan_info[0].oprot[4] = 1.0;
        scan_info[0].oprot[8] = 1.0;
        break;
    case PSD_SAG:
        scan_info[0].oprot[2] = 1.0;
        scan_info[0].oprot[4] = 1.0;
        scan_info[0].oprot[6] = 1.0;
        break;
    case PSD_COR:
        scan_info[0].oprot[2] = 1.0;
        scan_info[0].oprot[6] = 1.0;
        scan_info[0].oprot[7] = 1.0;
        break;
    case PSD_OBL:
        alpha = PI/4.0;  /* rotation about x (applied first) */
        beta = 0;   /* rotation about y (applied 2nd) */
        gamma = 0;  /* rotation about z (applied 3rd) */
        scan_info[0].oprot[0] = cos(gamma)*cos(beta);
        scan_info[0].oprot[1] = cos(gamma)*sin(beta)*sin(alpha) -
                                       sin(gamma)*cos(alpha);
        scan_info[0].oprot[2] = cos(gamma)*sin(beta)*cos(alpha) +
                                       sin(gamma)*sin(alpha);
        scan_info[0].oprot[3] = sin(gamma)*cos(beta);
        scan_info[0].oprot[4] = sin(gamma)*sin(beta)*sin(alpha) +
                                       cos(gamma)*cos(alpha);
        scan_info[0].oprot[5] = sin(gamma)*sin(beta)*cos(alpha) -
                                       cos(gamma)*sin(alpha);
        scan_info[0].oprot[6] = -sin(beta);
        scan_info[0].oprot[7] = cos(beta)*sin(alpha);
        scan_info[0].oprot[8] = cos(beta)*cos(alpha);
        break;
    }
    
    for(i=1;i<num_slice;i++) {
        scan_info[i].optloc = scan_info[i-1].optloc - z_delta;
        scan_info[i].oprloc = i*r_delta;
        for(j=0;j<9;j++)
            scan_info[i].oprot[j] = scan_info[0].oprot[j];
    }
    return SUCCESS;
}


/* ****************************************
   RotateScan

   MRIge91983 - RDP - this is based on MyScan from SpectroCommon.e
   ************************************** */
STATUS
#ifdef __STDC__ 
rotatescan( void )
#else  /* !__STDC__ */
    rotatescan()
#endif /* __STDC__ */
{

    int i, j;
    int num_slice;
    float t_delta;
    double alpha, beta, gamma;
    float z_delta;		/* change in z_loc between slices */
    float r_delta;		/* change in r_loc between slices */

    alpha = my_alpha * PI / 180.0;  /*around X*/
    beta = my_beta * PI / 180.0;    /*around Y*/
    gamma = my_gamma * PI / 180.0;  /*around Z*/

    num_slice = exist(opslquant) * exist(opvquant);

    r_delta = exist(opfov)/num_slice;
    z_delta = exist(opslthick)+exist(opslspace);

    t_delta = exist(opvthick);

    short oblpln = PSD_AXIAL;

    if (exist(opplane) == PSD_OBL) {

       setexist(oprlcsiis, PSD_ON);
       setexist(opapcsiis, PSD_ON);
       setexist(opsicsiis, PSD_ON);

       scan_info[0].optloc = 0.5*z_delta*(num_slice-1);

       scan_info[0].oprot[0] = cos(gamma) * cos(beta);
       scan_info[0].oprot[1] = cos(gamma) * sin(beta) * sin(alpha)
                                 - sin(gamma) * cos(alpha);
       scan_info[0].oprot[2] = cos(gamma) * sin(beta) * cos(alpha)
                                 + sin(gamma) * sin(alpha);
       scan_info[0].oprot[3] = sin(gamma) * cos(beta);
       scan_info[0].oprot[4] = sin(gamma) * sin(beta) * sin(alpha)
                                 + cos(gamma) * cos(alpha);
       scan_info[0].oprot[5] = sin(gamma) * sin(beta) * cos(alpha)
                                 - cos(gamma) * sin(alpha);
       scan_info[0].oprot[6] = -sin(beta);
       scan_info[0].oprot[7] = cos(beta) * sin(alpha);
       scan_info[0].oprot[8] = cos(beta) * cos(alpha);

       if( (abs(scan_info[0].oprot[0])
            >= abs(scan_info[0].oprot[1]))
           &&  (abs(scan_info[0].oprot[0])
                >= abs(scan_info[0].oprot[2]))) {
                oblpln = PSD_AXIAL;
       }
       else if( (abs(scan_info[0].oprot[1])
                 > abs(scan_info[0].oprot[0]))
                &&  (abs(scan_info[0].oprot[1])
                     >= abs(scan_info[0].oprot[2]))) {
           oblpln = PSD_SAG;
       }
       else if( (abs(scan_info[0].oprot[2])
                 > abs(scan_info[0].oprot[0]))
                &&  (abs(scan_info[0].oprot[2])
                     > abs(scan_info[0].oprot[1]))) {
           oblpln = PSD_COR;
       }
       opobplane = oblpln;
       switch (exist(opobplane)) {
       case PSD_AXIAL:
           if(!opspf) {   
               opapcsiis = 2;
               oprlcsiis = 1;
           } else {
               opapcsiis = 1;
               oprlcsiis = 2;
           }  

           opsicsiis = 3;
           break;
       case PSD_SAG:
           if(!opspf) {
               opapcsiis = 2;
               opsicsiis = 1;
           } else {
               opapcsiis = 1;
               opsicsiis = 2;
           } 
            
           oprlcsiis = 3;
           break;
       case PSD_COR:
           if(!opspf) {
               oprlcsiis = 2;
               opsicsiis = 1;
           } else {
               opapcsiis = 1;
               opsicsiis = 2;
           } 
  
           opapcsiis = 3;
           break;
       }
           
    
       for(i=1;i<num_slice;i++) {
            scan_info[i].optloc = scan_info[i-1].optloc - z_delta;
            for(j=0;j<9;j++) {
                scan_info[i].oprot[j] = scan_info[0].oprot[j];
            }
       }
    }
    return SUCCESS;
} /* end rotatescan() */

/* 
 * Override coil acceleration capabilties
 */
void epi_asset_override(void)
{
    if(existcv(opasset) && (1 == exist(opassetscan)))
    {
        if( touch_flag )
        {
            /* the acceleration factor of 8ch TORSO/Cardic coil is limited to 2x */
            /* override it to 3x for MR-Touch application*/
            cfaccel_ph_maxstride = FMax(2, 3.0, cfaccel_ph_maxstride);
        }
        else
        {
            /* To replicate legacy behavior, allow ASSET R=2 even if the coil
             * doesn't support it. */
            cfaccel_ph_maxstride = FMax(2, 2.0, cfaccel_ph_maxstride);
        }
    }

    return;
}

/*
 * Setup parallel imaging UI to only show integer step sizes
 */ 
void epi_asset_set_dropdown(void)
{
    if(existcv(opasset) && (1 == exist(opassetscan)))
    {
        if(avmaxaccel_ph_stride > 2.0)
        {
            piaccel_phnub = 4;
            piaccel_phval2 = 1.0;
            piaccel_phval3 = 2.0;
            piaccel_phval4 = avmaxaccel_ph_stride;
        }
        else
        {
            piaccel_phnub = 3;
            piaccel_phval2 = 1.0;
            piaccel_phval3 = 2.0;
        }

        piaccel_ph_step = 1.0;
    }

    return;
}

/****************************************************************************/
/*  CVINIT                                                                  */
/****************************************************************************/
STATUS
cvinit( void )
{
    if ((PSDDVMR == psd_board_type) && (value_system_flag == PSD_OFF))
    {
        /* B0 dither calibration is removed for DVMR hardware */
        ditheron = 0;
    }
    else
    {
        ditheron = 1;    
    }

    OpenDelayFile(delay_buffer);
    if (ditheron)
    {
        OpenDitherFile(txCoilInfo[getTxIndex(coilInfo[0])].txCoilType,
                       dither_buffer);
        OpenDitherInterpoFile(txCoilInfo[getTxIndex(coilInfo[0])].txCoilType,
                              ccinx, cciny, ccinz, esp_in, fesp_in, &g0,
                              &num_elements, &file_exist);
    }

    /* RAK: MRIge55889 - removed GRAD_UPDATE_TIME being used during the */
    /*                   initialization of CVs.                         */
    
    pwmin_gap     = 2*GRAD_UPDATE_TIME;
    td0           = GRAD_UPDATE_TIME;
    hrdwr_period = GRAD_UPDATE_TIME;
     
    /* SXZ::MRIge72411: init the optimization arr */
    taratio_arr[0] = 0.7; 
    taratio_arr[1] = 0.65; 
    taratio_arr[2] = 0.5;
    totarea_arr[0] = 1127.4; /* fov=20; xres=96 */
    totarea_arr[1] = 1503.2; /* fov=20; xres=128 */
    totarea_arr[2] = 2254.8; /* fov=20; xres=192 */

    /* Setup to use ermes database for HW compile */
#ifdef ERMES_DEBUG
    use_ermes = 0;
#else
    use_ermes =1;
#endif
    
@inline vmx.e SysParmInit

    epi_asset_override();

    /* MRIge92386 */
@inline Asset.e AssetCVInit

    epi_asset_set_dropdown();

    /* MRIhc19114 */
    if ( (fract_ky == PSD_FRACT_KY) && (intleaves == 1) ) {
        rup_factor = 4.0;
    } else {
        rup_factor = 2.0;
    }

    if ( existcv(opasset) && (exist(opasset) == ASSET_SCAN_PHASE) ) {
        int temp_nframes;
        if (num_overscan > 0) {
            temp_nframes = (short)(ceilf((float)exist(opyres)*asset_factor/rup_factor)*rup_factor*fn*nop - ky_offset);
            asset_factor = FMin(2, 1.0, floorf((temp_nframes + ky_offset)*1.0e5/((float)exist(opyres)*fn*nop))/1.0e5);
        } else {
            temp_nframes = (short)(ceilf((float)exist(opyres)*asset_factor/rup_factor)*rup_factor*fn*nop);
            asset_factor = FMin(2, 1.0, floorf(temp_nframes*1.0e5/((float)exist(opyres)*fn*nop))/1.0e5);
        }
    } else {
        asset_factor = 1.0;
    }

    opautorbw = PSD_OFF;
         
    /* Initialize B0 field for maxwell compensation */
    B0_field=cffield;
 
    /* Set specs for EPI */
    if ( !strncasecmp("epispec",psd_name,7) ) {
        epispec_flag = PSD_ON;
    } else {
        epispec_flag = PSD_OFF;
    }

    /* Set DVw gradient test */
    if ( !strncasecmp("epigradspec",psd_name,11) ) {
        epigradspec_flag = PSD_ON;
    } else {
        epigradspec_flag = PSD_OFF;
    }

    /* MRIhc44418, convolution dbdt model for readout gradient waveform */
    if ( !strncasecmp("epiespopt",psd_name,9) ) {
        epiespopt_flag = PSD_ON;
    } else {
        epiespopt_flag = PSD_OFF;
    }
    if ( !strncasecmp("epiRTespopt",psd_name,11) ) {
        epiRTespopt_flag = PSD_ON;
    } else {
        epiRTespopt_flag = PSD_OFF;
    }
    if ( !strncasecmp("epiminesp",psd_name,9) ) {
        epiminesp_flag = PSD_ON;
    } else {
        epiminesp_flag = PSD_OFF;
    }
    if ( !strncasecmp("epiRTminesp",psd_name,11) ) {
        epiRTminesp_flag = PSD_ON;
    } else {
        epiRTminesp_flag = PSD_OFF;
    }

    /* MRIhc50643 */
    if ( !strncasecmp("epira3",psd_name,6) ) {
        epira3_flag = PSD_ON;
    } else {
        epira3_flag = PSD_OFF;
    }
    if ( !strncasecmp("epiRTra3",psd_name,8) ) {
        epiRTra3_flag = PSD_ON;
    } else {
        epiRTra3_flag = PSD_OFF;
    }

    if((epispec_flag == PSD_ON) || (epiespopt_flag == PSD_ON) || (epiRTespopt_flag == PSD_ON) ||
       (epiminesp_flag == PSD_ON) || (epiRTminesp_flag == PSD_ON) ||
       (cfgcoiltype == PSD_XRMB_COIL))
    {
        dbdt_model = DBDTMODELCONV;
    }
    else
    {
        dbdt_model = DBDTMODELRECT;
    }

    if (((value_system_flag == VALUE_SYSTEM_SVEM) ||
         (value_system_flag == VALUE_SYSTEM_SVDM)) &&
        (epispec_flag == PSD_ON))
        dbdt_model = DBDTMODELRECT; 

    cvmax(opepi, PSD_ON);  /* enable epi flag selection */
    cvdef(opepi, PSD_ON);
    
    /*MRIge85417*/
    cvdef(opautote, PSD_MINTE);

    cvmax(opirprep, PSD_ON); /* enable ir prep flag selection */
    /* MRIge65081 */
    if(opcgate==PSD_ON)
        setexist(opcgate,PSD_ON); 
    else
        setexist(opcgate,PSD_OFF); 
    
    if( Absent == !checkOptionKey( SOK_EPLI ) )
    {
        epic_error( use_ermes, "%s is not available without the option key.",
                    EM_PSD_FEATURE_OPTION_KEY, EE_ARGS(1), STRING_ARG, "EPI" );
        return FAILURE;
    }
    
%ifdef RT
#ifndef SIM
    if ((checkOptionKey( SOK_BRNWAVRT ) != 0) && exist(opfmri) == PSD_ON && existcv(opfmri) )
    {
        epic_error( use_ermes, "%s is not available without the option key.",
                    EM_PSD_FEATURE_OPTION_KEY, EE_ARGS(1), STRING_ARG, "fMRI" );
        return FAILURE;
    }
#endif
%endif

@inline touch.e TouchInit

    /* MRIge82528 */
    cvmax(opfmri,1);

    opslice_order = 1;
    
    /*
     * To allow 512 passes. As many as 999 passes (or phases in mph)
     * can be allowed by replacing this line with: cvmax(rhreps, max_num_pass);
     * ypd
     */
    /*jwg bb may need to increase this if we want lots of timeframes, but should be ok currently*/      
    cvmax(rhreps, 512);    

    enable_1024 = (mph_flag==PSD_ON ? PSD_ON : PSD_OFF);

    if( enable_1024 )
        max_slice_limit = RHF_MAX_IMAGES_MULTIPHASE;
    else
        max_slice_limit = DATA_ACQ_MAX * SLICE_FACTOR;
        
    cvmod(rhnslices, 0, max_slice_limit, 1, "opslquant*optphases*opfphases.", 0, " ");

    cvmod(rhpcspacial, 0, DATA_ACQ_MAX, 1,
          "temporal index of ref scan slice (0=all slices).",0," ");
    cvmod(rhref, 0, 4, 2, "Ref Alg. 0=old, 1=new, 2=N-N sub, 3=pc_per_img, 4=self_nav_dpc",0," ");
    cvmod(opirmode, 0, 1, 0, "Sequential (1) or interleaved (0) mode.",0," ");
    opirmode = 0;
    
    scan_offset = 0;
    postsat = PSD_OFF;
    
    /* initialize configurable variables */
    /* MRIhc18005 */
    EpicConf();
    inittargets(&loggrd, &phygrd);
    inittargets(&epiloggrd, &epiphygrd);
    
%ifdef RT 
@inline epiRTfile.e epiRT_check_eegblank_and_TTL 
%endif

    /* update gradient config  */
    if(cfgcoiltype == PSD_XRMW_COIL && epigradspec_flag == PSD_ON)
    {
        if( existcv(opuser1) && ((exist(opuser1) > 2) || (exist(opuser1) < 0) || (exist(opuser1)!=(int)exist(opuser1)))) 
        {
            strcpy(estr, "%s is out of range");
            epic_error(use_ermes,estr,EM_PSD_CV_OUT_OF_RANGE, EE_ARGS(1), STRING_ARG, "Gradient Test (CV1)");
            return FAILURE;
        }
        dvw_grad_test = exist(opuser1);
        switch(dvw_grad_test)
        {
            case 1: 
                config_update_mode = CONFIG_UPDATE_TYPE_DVW_AMP20SR150; 
            break;
            case 2: 
                config_update_mode = CONFIG_UPDATE_TYPE_DVW_AMP34SR120; 
            break;
            default: 
                config_update_mode = CONFIG_UPDATE_TYPE_DVW_DEFAULT; 
            break;
        }
        inittargets(&loggrd, &phygrd);
        inittargets(&epiloggrd, &epiphygrd);
    }

    /* Silent Mode  05/19/2005 YI */
    /* Save configurable variables after conversion by setupConfig() */
    if(set_grad_spec(CONFIG_SAVE,glimit,srate,PSD_ON,debug_grad_spec) == FAILURE)
    {
      epic_error(use_ermes,"Support routine set_grad_spec failed",
        EM_PSD_SUPPORT_FAILURE,1, STRING_ARG,"set_grad_spec");
        return FAILURE;
    }
    /* Get gradient spec for silent mode */
    getSilentSpec(exist(opsilent), &grad_spec_ctrl, &glimit, &srate);
 
    /* MRIhc56520: for EPI with ART on 750w. */
    if (exist(opsilent) && (cffield == B0_30000) && (cfgcoiltype == PSD_XRMW_COIL))
    {
        srate = XRMW_3T_EPI_ART_SR;
    }

    /* Update configurable variables */
    if(set_grad_spec(grad_spec_ctrl,glimit,srate,PSD_ON,debug_grad_spec) == FAILURE)
    {
      epic_error(use_ermes,"Support routine set_grad_spec failed",
        EM_PSD_SUPPORT_FAILURE,1, STRING_ARG,"set_grad_spec");
        return FAILURE;
    }
    /* Skip setupConfig() if grad_spec_ctrl is turned on */
    if(grad_spec_change_flag) {
        if(grad_spec_ctrl)config_update_mode = CONFIG_UPDATE_TYPE_SKIP;
        else              config_update_mode = CONFIG_UPDATE_TYPE_ACGD_PLUS;
        inittargets(&loggrd, &phygrd);
        inittargets(&epiloggrd, &epiphygrd);
    }
    /* End Silent Mode */

    epiphygrd.xrt = cfrmp2xfs;
    epiphygrd.yrt = cfrmp2yfs;
    epiphygrd.zrt = cfrmp2zfs;
    epiphygrd.xft = cffall2x0;
    epiphygrd.yft = cffall2y0;
    epiphygrd.zft = cffall2z0;
    epiloggrd.xrt = epiloggrd.yrt = epiloggrd.zrt =
        IMax(3,cfrmp2xfs,cfrmp2yfs,cfrmp2zfs);
    epiloggrd.xft = epiloggrd.yft = epiloggrd.zft =
        IMax(3,cffall2x0,cffall2y0,cffall2z0);
    
    /* MRIhc18005 */

    /* always set initnewgeo=1 since cvinit (including inittargets) is */
    /* called on transition to scan ops page in 5.5 */
    initnewgeo = PSD_ON;
    
    /* BJM: save this for next oblopt call with epi loggrd */
    save_newgeo = initnewgeo;
    if (obloptimize_epi(&loggrd, &phygrd, scan_info, exist(opslquant),
                        exist(opplane), exist(opcoax), obl_method,
                        obl_debug, &initnewgeo, cfsrmode)==FAILURE) { 
        /* maybe rot matrices not set */
        epic_error(use_ermes, "%s failed in %s", EM_PSD_FUNCTION_FAILURE,
                   EE_ARGS(2), STRING_ARG, "obloptimize_epi",
                   STRING_ARG, "cvinit()");

        return FAILURE;
    }
    
    /* BJM: MRIge47073 derate non readout waveforms */
    dbdtderate(&loggrd, 0);
    
    initnewgeo = save_newgeo;
    if (obloptimize_epi(&epiloggrd, &epiphygrd, scan_info, exist(opslquant),
                        exist(opplane), exist(opcoax), obl_method,
                        obl_debug, &initnewgeo, cfsrmode)==FAILURE) { 
        /* maybe rot matrices not set */
        epic_error(use_ermes, "%s failed in %s", EM_PSD_FUNCTION_FAILURE,
                   EE_ARGS(2), STRING_ARG, "obloptimize_epi",
                   STRING_ARG, "cvinit()");

        return FAILURE;
    }

    /* GEHmr01833, GEHmr02647 */
    if( (cfgradamp == 8919) &&
        ((value_system_flag == VALUE_SYSTEM_SVEM) ||
         (value_system_flag == VALUE_SYSTEM_SVDM)) )
    {
        if( exist(oppseq) == PSD_SE )
        {
            cfxfd_power_limit = XFD_POWER_LIMIT_SE;
        }
        else
        {
            cfxfd_power_limit = XFD_POWER_LIMIT_GRE;
        }
    }
    else
    {
        cfxfd_power_limit = XFD_POWER_LIMIT;
    }
  
    /* spsp FL90mc or GR30l for excitation, and se1b4 for 
       refocussing */
    cyc_rf1 = 1;
    cyc_rf2 = 1;
    
    if (SpSatInit(vrgsat) == FAILURE) return FAILURE;

    opautoti = PSD_OFF;

    /* ZZ, activate ASPIR through SPECIAL fat sat option */
    if( PSD_ON == exist(optouch) ) {
        pichemsatopt = 2;
    }
    else {
        pichemsatopt = 0;
    }
     
@inline ChemSat.e ChemSatInit
@inline BroadBand.e BBcvinit /*jwg bb*/
@inline Prescan.e PScvinit
      
#include "cvinit.in"
  
    pw_sspshift = 400;   /* pulsewidth of spring for sspwait, Added by MGH. MRIge24538 */
    a_rfcssat = .50;
    
    gscale_rf2 = 0.9;

    /* ****************************************************
       Advisory Panel 
       
       If piadvise is 1, the advisory panel is supported.
       pimax and pimin are bitmaps that describe which
       advisory panel routines are supported by the psd.
       Scan Rx will activate cardiac gating advisory panel
       values if gating is chosen from the gating screen onward.
       Scan Rx will display the minte2 and maxte2 values 
       if 2 echos are chosen.
       
       Constants for the bitmaps are defined in epic.h
       *********************************************** */
    piadvise = 1; /* Advisory Panel Supported */
    
    /* bit mask for minimum adv. panel values.
     * Scan Rx will remove TE2 entry automatically if 
     * 1 or 4 echos selected. */
    piadvmin = (1<<PSD_ADVECHO) +
        (1<<PSD_ADVTE) + (1<<PSD_ADVTR) +	(1<<PSD_ADVFOV);
    piadvmax = (1<<PSD_ADVECHO) +
        (1<<PSD_ADVTE) + (1<<PSD_ADVTR) +	(1<<PSD_ADVFOV);
    
    /* bit mask for cardiac adv. panel values */
    piadvcard = (1<<PSD_ADVISEQDELAY)
        + (1<<PSD_ADVMAXPHASES) + (1<<PSD_ADVEFFTR) + (1<<PSD_ADVMAXSCANLOCS)
        + (1<<PSD_ADVAVAILIMGTIME);
    
    /* bit mask for scan time adv. panel values */
    piadvtime = (1<<PSD_ADVMINTSCAN) + (1<<PSD_ADVMAXLOCSPERACQ) +
        (1<<PSD_ADVMINACQS) + (1<<PSD_ADVMAXYRES);
    
    /* Default to axial */
    cvdef(opplane, PSD_AXIAL);
    opplane = PSD_AXIAL;
    
    /* Single echo only */
    piechnub  = 0;
    opnecho = 1;
    
    /* Enable only the prescan autoshim button and default on, 
     * always keep phase correction on and grey it out */
    pipscoptnub = 1;
    pipscdef = 3;
    _opphcor.fixedflag = PSD_OFF;
    opphcor = PSD_ON;
    cvdef(opphcor, PSD_ON);
    _opphcor.fixedflag = PSD_ON;
    _opphcor.existflag = PSD_ON;
    
    /**** Number of SHOTS ******/
    if (touch_flag) {
        /* only single-shot allowed for MR-Touch */
        pishotnub=2;
        pishotval2=1;
    }
    else{
        /* MRIge50404 - maximum opnshots must be less than 16 with vrgf */
        if (vrgfsamp == PSD_ON) {
            pishotnub = 63;    /* display "other" + 5 shot buttons (bitmask)*/
            pishotval2 = 1;
            pishotval3 = 2;
            pishotval4 = 4;
            pishotval5 = 8;
            pishotval6 = 14;
        } else {
            pishotnub = 63;    /* display "other" + 5 shot buttons (bitmask)*/
            pishotval2 = 1;
            pishotval3 = 2;
            pishotval4 = 4;
            pishotval5 = 8;
            pishotval6 = 16;
        }
    }

    /***** TE UI Button Control *********/ 
    pite1nub = 63;   /* te button bitmask:
                        1       2          4       8 16 32
                        other, automin, autominfull, x, x, x */
    pite1val2 = PSD_MINIMUMTE;    /* 2nd button is autominte */
    pite1val3 = PSD_MINFULLTE;    /* 3rd button is autominte full */
    pitetype = PSD_LABEL_TE_EFF;  /* label te buttons as
                                     "Effective Echo Time" */
    
    if (exist(oppseq) == PSD_SE) {
        pite1val4 = 20ms;
        pite1val5 = 60ms;
        pite1val6 = 100ms;
        pifanub = 0;
        cvoverride(opflip, 90, PSD_FIX_OFF, PSD_EXIST_ON);
        acq_type = TYPSPIN;
    } else {
        pite1val4 = 20ms;
        pite1val5 = 30ms;
        pite1val6 = 40ms;
        /* flip angle buttons */
        pifanub = 6;
        pifaval2 = 10;
        pifaval3 = 20;
        pifaval4 = 30;
        pifaval5 = 60;
        pifaval6 = 90;
        acq_type = TYPGRAD;
    }

    /*MRIhc05898 limit flip angle to 70 degree for longbore 3T with BODY
     * or surface coil with spsp pulse*/
    if ((PSD_CRM_COIL == cfgcoiltype) && 
        (TX_COIL_BODY == txCoilInfo[getTxIndex(coilInfo[0])].txCoilType) && 
        exist(opweight) > 130 && PSD_OFF == exist(opfat)  && 
        cffield == B0_30000) 
    {
        if (PSD_SE == exist(oppseq)) {
            pifanub = 0;
            cvoverride(opflip, 70, PSD_FIX_ON, PSD_EXIST_ON);
        }else {
            cvmax(opflip, 70);
            avmaxflip = 70;    
            cvdef(opflip, 70);
        }

        /* SWL : this is added to prevent multiple advisory pop up */
        if (exist(opflip) > avmaxflip)   
        {
            opflip = avmaxflip;
        }
    }

    /*
     * MRIhc24435: For epispec PSD, limit flip angle to 50 for 3T
     * TRM and CRM and 100 for all the other system configurations.
     */

    if (PSD_ON == epispec_flag)
    {
        if ((B0_30000 == cffield) && ((PSD_CRM_COIL == cfgcoiltype) || (PSD_TRM_COIL == cfgcoiltype)))
        {
            avmaxflip = 50;
            cvmax(opflip, 50);
            cvdef(opflip, 50);
            if (exist(opflip) > avmaxflip) 
            {
                opflip = avmaxflip;
            }
        }
        else
        {
            avmaxflip = 80;
            cvmax(opflip, 80);
            cvdef(opflip, 80);
            if (exist(opflip) > avmaxflip)
            {
                opflip = avmaxflip;
            }
        }
    }

    if( (PSD_ON == epispec_flag)
        && (B0_30000 == cffield)
        && (PSD_XRMB_COIL == cfgcoiltype) )
    {
        avmaxflip = 60;
        cvmax(opflip, 60);
        cvdef(opflip, 60);
        if (exist(opflip)>avmaxflip)
        {
            opflip = avmaxflip;
        }
    }

    /* Reasonable TE defaults */
    cvdef(opte, 110ms);
    cvmin(opte, 100);   
    opte = 110ms;
    
    /* Scan TR Values */
    /* use a large default value for tr */
    cvdef(optr, 10s);
    optr = 10s;

    avmaxti = TI_MAX;
    avminti = TI_MIN;
    cvmax(opti, TI_MAX);
    cvmin(opti, TI_MIN);
    
    /* RBW Options */
    cvmax(oprbw,RBW_MAX);
    oprbw = RBW_MAX;
    cvdef(oprbw,62.5);
    oprbw = 62.5;
    pidefrbw = 62.5;
    pircb2nub = 0;  /* turn off 2nd echo rbw buttons */
    
    /*JWG change averaging max values here*/
    cvmax(opnex,1024);
    cvmax(ihnex,1024); /*opnex sets nex, nex sets ihnex...*/
    
    /* MGD: +/- 250 Digital */
    pircbnub = 5;
    pircbval2 = 250.0;
    pircbval3 = 166.6;
    pircbval4 = 125.0;
    pircbval5 = 62.5;
    
    /* XRES & YRES Values */
    /*jwg bb change default values to 16-256 from 32-512*/
    piyresnub = 63;
    piyresval2 = 16;
    piyresval3 = 32;
    piyresval4 = 64;
    piyresval5 = 128;
    piyresval6 = 256;
    cvmin(opyres, 16); /*jwg change from 32 to 16*/
    cvmax(opyres, 512);
    cvdef(opyres, 64);
    opyres = 64;
    
    pixresnub = 63; /* bitmask */
    pixresval2 = 16;
    pixresval3 = 32;
    pixresval4 = 64;
    pixresval5 = 128;
    pixresval6 = 256;
    cvmin(opxres, 16); /*jwg change from 32 to 16*/
    cvmax(opxres, 512);
    cvdef(opxres, 64);
    cvmax(opslthick,500); /*jwg make large for c13 testing*/
    opxres = 64;

    /* FOV buttons */	
    pifovnub = 6;
    pifovval2 = 220;
    pifovval3 = 240;
    pifovval4 = 260;
    pifovval5 = 280;
    pifovval6 = 300;

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


    /* MRIge55604 */
    cvmin(opfov, FOV_MIN);
    cvmax(opfov, FOV_MAX_EPI);
    cvdef(opfov, cfsystemmaxfov);
    oprect = 0;
    opfov = cfsystemmaxfov;

    opslquant = 1;
    cvmax(opetl, MAXINT);
    
    switch (cfsrmode) {
    case PSD_SR17:
        cvdef(opnshots, 8);
        opnshots = 8;
        break;
    case PSD_SR20:
    case PSD_SR25:
        cvdef(opnshots, 8);
        opnshots = 8;
        break;
    case PSD_SR50:
        cvdef(opnshots, 8);
        opnshots = 8;
        break;
    case PSD_SR77:
        cvdef(opnshots, 4);
        opnshots = 4;
        break;
    case PSD_SR100: 
    case PSD_SR120:
    case PSD_SR150:
    case PSD_SR200:
        cvdef(opnshots, 1);
        opnshots = 1;
        cvmax(iheesp, MAXINT);  /* MRIge41058 - latha@mr */
        break;
    default:
        cvdef(opnshots, 8);
        opnshots = 8;
        break;
    }
    
    cvdef(opslthick, 10.0);
    opslthick = 10.0;
    
    cvmax(rhfrsize, 8192);
    cvmax(rhdaxres, 8192);
    
    /* Multi-Phase CVs */
    cvmax(opmph,1);
    cvdef(opmph,0); /* default to MPH off */
    cvdef(opacqo,0);  /* default to interleaved */
    opacqo = 0;
    cvdef(opfphases, PHASES_MIN);
    cvmin(opsldelay, -MAXINT); /* YMSmr07177 */
    cvmax(opsldelay,  MAXINT); /* YMSmr07177 */
    cvdef(opsldelay, 1us);
    opsldelay = 1us;
    reps = 1;
 
    if ( mph_flag == PSD_ON ) {
        /* screen for MPH option */
        pimphscrn = 1;
        pifphasenub = 6;
        pifphaseval2 = 1;
        pifphaseval3 = 2;
        pifphaseval4 = 5;
        pifphaseval5 = 10;
        pifphaseval6 = 15;
        
        pisldelnub = 6;
        pisldelval3 = 500ms;
        pisldelval4 = 1000ms;
        pisldelval5 = 2000ms;
        pisldelval6 = 5000ms;
	
	/*jwg bb set opfphases to leverage the built-in phase loop*/
	/*NOTE: will return to hard-coding this at a later date*/
	/*
	if (existcv(opuser21) && existcv(opuser22))
	{
		pifphasenub = 0; 
   		opfphases = opuser21 * opuser22;
		_opfphases.fixedflag = 1;
		_opfphases.existflag = 1;		 
	}   	
        */
        /* Changed piacqnub from 2 to 3 for Linux-MGD. WGEbg17457 -Venkat*/
        piacqnub = 3; /* acquisition order buttons */ 
       
        prevent_scan_under_emul = 0;

    } else if (exist(opfmri)==PSD_ON) {

        prevent_scan_under_emul = 1;

        pifmriscrn = 1;
        pifphasenub = 6;

        /* BJM: reasonable pulldowns for fMRI */
        pifphaseval2 = 50;
        pifphaseval3 = 75;
        pifphaseval4 = 100;
        pifphaseval5 = 125;
        pifphaseval6 = 150;

        pisldelnub = 6;
        pisldelval3 = 500ms;
        pisldelval4 = 1000ms;
        pisldelval5 = 2000ms;
        pisldelval6 = 5000ms; 

        pirepactivenub = 1;
        pireprestnub = 1;
        piddanub = 1;
        piinitstatnub = 1;
        piviewordernub = 1;
        pisliceordnub = 1;
        pipsdtrignub = 1;

    } else {	
        
        pimphscrn = 0; /* do not display the Multi-Phase Parameter screen */
        pifmriscrn = 0;

        prevent_scan_under_emul = 0; 
    } 

    /* init epigradopt output structure to point to appropriate CVs */
    fprintf(stderr,"LINE 2355, pw_gyb and a_gyb are %d and %f \n",pw_gyb,a_gyb);
    gradout.agxw = &a_gxw;
    gradout.pwgxw = &pw_gxw;
    gradout.pwgxwa = &pw_gxwad;
    gradout.agyb = &a_gyb;
    gradout.pwgyb = &pw_gyb;
    gradout.pwgyba = &pw_gyba;
    gradout.frsize = &temprhfrsize;
    gradout.pwsamp = &samp_period;
    gradout.pwxgap = &pw_gxgap;
  
    /* Turn off EP_TRAIN macro elements we don't want */
    pw_gxcla = 0;
    pw_gxcl = 0;
    pw_gxcld = 0;
    a_gxcl = 0;
    pw_gxwl = 0;
    pw_gxwr = 0;
    pw_gxgap = 0;
    pw_gxcra = 0;
    pw_gxcr = 0;
    pw_gxcrd = 0;
    a_gxcr = .0;
    
    /* Opuser CV PAGE control */
    piuset |= use0;     
    pititle = 1;       /* Since this is MGD - we can always have ramp samp */
    
    cvdesc(pititle, "EPI Advanced Feature Controls:");
    
    /* Only 30 characters per CV are displayed on user CV screen, thats it!
       "123456789012345678901234567890" */
    cvmod(opuser0, 0.0, 1.0, 1.0, "Ramp Sampling (1=on, 0=off)",0," ");
    opuser0 = 1;

    if(epigradspec_flag == PSD_ON && cfgcoiltype == PSD_XRMW_COIL)
    {
        piuset = piuset | use1;     
        cvmod(opuser1, 0.0, 2.0, 0.0, "Gradient Test (0=DEFAULT, 1=GMAX20SR150, 2=GMAX34SR120)",0," ");
        opuser1 = 0;
    }
    else
    {
        piuset = piuset & (~use1);
        cvmod( opuser1, -MAXFLOAT, MAXFLOAT, 0.0, "User CV variable 1", 0, "" );
        cvoverride(opuser1, _opuser1.defval, PSD_FIX_OFF, PSD_EXIST_OFF);
    }
    
    /* MRIge59852: opuser0 range check */
    /* MRIge71092 */
    if( existcv(opuser0) && ((exist(opuser0) > 1) || (exist(opuser0) < 0) || (exist(opuser0)!=(int)exist(opuser0)))) {
        strcpy(estr, "%s must be set to either 0 or 1.");
        epic_error(use_ermes,estr,EM_PSD_CV_0_OR_1, EE_ARGS(1), STRING_ARG, "Ramp Sampling");
        return FAILURE;
    }

    /* Added for spsp fatsat pulse */
    if (B0_30000 == cffield)
    {
        if(PSD_ON == exist(opfat) && (PSD_ON == exist(opmph) || PSD_ON == exist(opfmri) || PSD_ON == exist(opdynaplan)))
        {
    	    piuset = piuset | use4;
            cvmod(opuser4, 0.0, 1.0, 0.0, "Spectral-Spatial FatSat (1=on, 0=off)",0," ");
            opuser4 = 0;

            if( existcv(opuser4) && ((exist(opuser4) > 1) || (exist(opuser4) < 0) || (exist(opuser4)!=(int)exist(opuser4)))) 
            {
                strcpy(estr, "%s must be set to either 0 or 1.");
                epic_error(use_ermes,estr,EM_PSD_CV_0_OR_1, EE_ARGS(1), STRING_ARG, "Spectral-Spatial FatSat");
                return FAILURE;
            }
            use_spsp_fatsat = (int)exist(opuser4);
        }
        else
        {
    	    piuset = piuset & (~use4);
            cvmod( opuser4, -MAXFLOAT, MAXFLOAT, 0.0, "User CV variable 4", 0, "" );
            cvoverride(opuser4, _opuser4.defval, PSD_FIX_OFF, PSD_EXIST_OFF);
            use_spsp_fatsat = 0;
        }
    }
    else
    {
        piuset = piuset & (~use4);
        cvmod( opuser4, -MAXFLOAT, MAXFLOAT, 0.0, "User CV variable 4", 0, "" );
        cvoverride(opuser4, _opuser4.defval, PSD_FIX_OFF, PSD_EXIST_OFF);
        use_spsp_fatsat = 0;
    }

    /* HCSDM00082374 */
    {
        static int old_taratio_override;

        old_taratio_override = taratio_override;

        if ((PSD_XRMW_COIL == cfgcoiltype) && (PSD_OFF == touch_flag) && (PSD_ON == vrgfsamp) && (PSD_ON == rampopt))
        {
            piuset = piuset | use6;
            cvmod(opuser6, 0.0, 1.0, 0.0, "Max # Slices Optimization (1=on, 0=off)",0," ");
            opuser6 = 0;

            if (existcv(opuser6) && ((exist(opuser6) > 1) || (exist(opuser6) < 0) || (exist(opuser6)!=(int)exist(opuser6))))
            {
                strcpy(estr, "%s must be set to either 0 or 1.");
                epic_error(use_ermes,estr,EM_PSD_CV_0_OR_1, EE_ARGS(1), STRING_ARG, "Max # Slices Optimization");
                return FAILURE;
            }

            taratio_override = exist(opuser6);
        }
        else
        {
            piuset = piuset & (~use6);
            cvmod( opuser6, -MAXFLOAT, MAXFLOAT, 0.0, "User CV variable 6", 0, "" );
            cvoverride(opuser6, _opuser6.defval, PSD_FIX_OFF, PSD_EXIST_OFF);
            taratio_override = PSD_OFF;
        }

        if (taratio_override != old_taratio_override)
        {
            set_cvs_changed_flag( TRUE );
        }
    }

    /* MRIhc55403 */
    if(PSD_ON == epira3_flag || PSD_ON == epiRTra3_flag)
    {
        if(cfgcoiltype == PSD_XRMB_COIL)
        {
            piuset = piuset | use7;
            cvmod(opuser7, 0.0, 1.0, 1.0, "Echo Spacing (Legacy=0, Minimized=1)",0," ");
            opuser7 = 1;

            if( existcv(opuser7) && ((exist(opuser7) > 1) || (exist(opuser7) < 0) || (exist(opuser7)!=(int)exist(opuser7))))
            {
                strcpy(estr, "%s must be set to either 0 or 1.");
                epic_error(use_ermes,estr,EM_PSD_CV_0_OR_1, EE_ARGS(1), STRING_ARG, "Legacy or minimized echo-spacing");
                return FAILURE;
            }
            ra3_minesp_flag = (int)exist(opuser7);
            if(PSD_ON == ra3_minesp_flag)
            {
                dbdt_model = DBDTMODELCONV;
            }
            else
            {
                dbdt_model = DBDTMODELRECT;
            }
        }
        else 
        {
            piuset = piuset & (~use7);
            cvmod( opuser7, -MAXFLOAT, MAXFLOAT, 0.0, "User CV variable 7", 0, "" );
            cvoverride(opuser7, _opuser7.defval, PSD_FIX_OFF, PSD_EXIST_OFF);
            ra3_minesp_flag = 0;
        }

        piuset = piuset | use8;
        cvmod(opuser8, 0.0, 1.0, 0.0, "Phase Correction (Legacy=0, New=1)",0," ");
        opuser8 = 0;

        if( existcv(opuser8) && ((exist(opuser8) > 1) || (exist(opuser8) < 0) || (exist(opuser8)!=(int)exist(opuser8))))
        {
            strcpy(estr, "%s must be set to either 0 or 1.");
            epic_error(use_ermes,estr,EM_PSD_CV_0_OR_1, EE_ARGS(1), STRING_ARG, "Legacy or new phase correction");
            return FAILURE;
        }
        ra3_sndpc_flag = (int)exist(opuser8);
    }
    else
    {
        piuset = piuset & (~use7);
        cvmod( opuser7, -MAXFLOAT, MAXFLOAT, 0.0, "User CV variable 7", 0, "" );
        cvoverride(opuser7, _opuser7.defval, PSD_FIX_OFF, PSD_EXIST_OFF);
        piuset = piuset & (~use8);
        cvmod( opuser8, -MAXFLOAT, MAXFLOAT, 0.0, "User CV variable 8", 0, "" );
        cvoverride(opuser8, _opuser8.defval, PSD_FIX_OFF, PSD_EXIST_OFF);
    }

    /*jwg bb opusercvs*/
    /*opuser20 will control external RF waveforms*/
    /* 1: 1H spsp, from macro; 
       2: sinc; 
       3: or_pass;
       4: complex spsp
       98: magnitude test spsp pulse
       99: complex test spsp pulse */
    cvmod(opuser20, 0, 99, 0, "External RF Waveform",0,"Invalid external waveform");    
    piuset |= use20;
    
    /*opuser21 controls # species to acquire*/
    cvmod(opuser21, 1, 5, 1, "Number of HP species to acquire",0,"Invalid # of metabolites");    
    _opuser21.defval = 1;
    piuset |= use21;
    num_mets = (int)opuser21;
    
    /*opuser22 controls the number of dynamic timeframes to acquire*/
    cvmod(opuser22, 1, 100, 1, "Number of timeframes to acquire",0,"Invalid # of timeframes");    
    piuset |= use22; 
    num_frames = (int)opuser22;
    
    /*opuser23 lets the user control the BW during a ramp sampled EPI*/
    cvmod(opuser23, 0, 1, 0, "User control of BW during ramp sampled EPI (1 = yes)",0,"User controlled BW opuser23");    
    piuset |= use23;     
    
    /*opuser24 Disable internal reference scan, DONT want this for C13 studies. Retained for 1H functionality*/
    cvmod(opuser24, 0, 1, 0, "Enable internal reference scan (1 = ENABLED)",0,"Enable iref_etl opuser24");    
    piuset |= use24;       
    enable_iref_etl = (int)opuser24;
    
    /*jwg bb this cv should enable overlapped slices, see epic.h*/
    pioverlap = 1;
        
    /*opuser25 Enable VFA schemes*/
    cvmod(opuser25, 0, 99, 0, "Enable VFA Scheme (0 = Same flip for all freqs)",0,"vfa scheme opuser25");    
    piuset |= use25;       
    vfa_flag = (int)opuser25;    
    
    /*opuser25 Enable VFA SAKE undersampling*/
    cvmod(opuser26, 0, 99, 0, "Enable SAKE undersampling (0 = off, 1-99 on)",0,"sake scheme opuser26");    
    piuset |= use26;       
    sake_flag = (int)opuser26;      
    /*jwg bb sake force MINTE if and only if we're running SAKE*/
    if(sake_flag > 0) 
    {
    	cvoverride(opautote,PSD_MINTE, PSD_FIX_ON, PSD_EXIST_ON);
    } else {
    	cvunlock(opautote);
    }
    
    /*jwg bb force opfphases to equal num_freqs X num_frames to leverage the built-in phase loop*/
    if (existcv(opuser21) && existcv(opuser22))
    {
    	cvoverride(opfphases,(opuser21 * opuser22), PSD_FIX_ON, PSD_EXIST_ON);
    }   	
    
    /*jwg end*/
    
%ifdef RT

@inline epiRTfile.e epiRT_UserCV       

%else

    if(exist(opfmri) == PSD_ON) {

        /* Prevent users from selecting fMRI w/ EPI */
        /* Can only select fMRI with epiRT pulse sequence */
        epic_error( use_ermes, "%s is incompatible with %s.", EM_PSD_INCOMPATIBLE, EE_ARGS(2), STRING_ARG, "fMRI", STRING_ARG, "EPI (must use epiRT)" );
        return FAILURE;
    }

    /* MERGE EXT TRIGGER */

    if( !strncasecmp( "epi_trig", psd_name, 8 ) ) {
        cvdef(ext_trig, PSD_ON); 
        ext_trig = PSD_ON;
    
        /* ext_trig range check */
        if(( existcv(ext_trig) && ((exist(ext_trig) > 1) || (exist(ext_trig) < 0)))) {
            strcpy(estr, " Invalid psd_trig entry - select again... ");
            epic_error(0,estr,EM_PSD_INVALID_RX, 0);
            return FAILURE;
        }
    } 
    /* END - MERGE EXT TRIGGER */


%endif

    if(exist(opfmri) == PSD_ON && exist(opirprep) == PSD_ON) {
        epic_error( use_ermes, "%s is incompatible with %s.", EM_PSD_INCOMPATIBLE, EE_ARGS(2), STRING_ARG, "FMRI", STRING_ARG, "IR Prepared" );
        return FAILURE;
    }

    if(exist(opfmri) == PSD_ON && exist(opcgate) == PSD_ON) {
        epic_error( use_ermes, "%s is incompatible with %s.", EM_PSD_INCOMPATIBLE, EE_ARGS(2), STRING_ARG, "FMRI", STRING_ARG, "Cardiac Gating/Triggering" );
        return FAILURE;
    }
    
    /* Check for Cal files */
    if(epiCalFileCVInit() != SUCCESS) return FAILURE;

    /* Set cvxfull, cvyfull, cvzfull for blipcorr() */
    cvxfull = cfxfull;
    cvyfull = cfyfull;
    cvzfull = cfzfull;
    
#if defined(RT) && defined(LIM_PROTOCOLS)
    if (lim_protocol() == FAILURE) {
        /* don't send ermes so that underlying ermes will be displayed */
        return FAILURE;
    }
#else
    if( (mph_flag == PSD_ON) && ((opfphases * opslquant) > 2048) ) 
    { 
        if(mph_protocol() == FAILURE) {
            /* don't send ermes so that underlying ermes will be displayed */
            return FAILURE;
        }
    }
#endif

    if( (PSD_OFF == pircbnub) && (PSD_OFF == exist(opautorbw)) )
    {
        opautorbw = PSD_ON;
    }

    /* MRIhc44418 */
    reopt_flag = PSD_ON;
    total_gradopt_count = 0;

    if((cfgcoiltype == PSD_XRMB_COIL || cfgcoiltype == PSD_XRMW_COIL) && (epispec_flag == PSD_OFF))
    {
        ss_fa_scaling_flag = PSD_ON;
    }
    else
    {
        ss_fa_scaling_flag = PSD_OFF;
    }

    return SUCCESS;
    
}  /* end CVINIT */

@inline SpSat.e SpSatInit
@inline SpSat.e SpSatCheck
@inline ss.e ssInit
/* 4/21/96 RJL: Init all new Advisory Cvs */
@inline InitAdvisories.e InitAdvPnlCVs

/**************************************************************************/
/* CVEVAL                                                                 */
/**************************************************************************/

/*jwg bb functions for reading external waveforms*/
@inline RFsetup_bbepi.e read_spsp_datfile
@inline RFsetup_bbepi.e read_rf_datfile
@inline RFsetup_bbepi.e read_write_flip_tables
@inline RFsetup_bbepi.e read_sake

STATUS
cveval( void )
{
    double ave_sar;
    double peak_sar; /* temp sar value locations */
    double cave_sar;
    double b1rms;

    float c1_scale;
    int crusher_type;

    int pack_ix;
    
    ctlend_last = 0; /* initialization */
    ctlend_fill = 0;
    ctlend_unfill = 0;
    
    if(specnuc > 1) cfbbmod = PSD_ON; /*jwg bb*/    
    if(specnuc > 1) autolock = 1; /*jwg bb*/   
    
    fprintf(stderr,"At top of cveval, pw_gyb and a_gyb are %d and %f \n",pw_gyb,a_gyb);    
    
    /*jwg bb do frequency calculations for metabolites based on B0 field*/
    df1 = df1_ppm * GAM / 1000000 * cffield; /* freq (hz) = chem shift (ppm) * hz/(G * ppm) * B0 (G) */
    df2 = df2_ppm * GAM / 1000000 * cffield; 
    df3 = df3_ppm * GAM / 1000000 * cffield;    
    df4 = df4_ppm * GAM / 1000000 * cffield;    
    df5 = df5_ppm * GAM / 1000000 * cffield;            
   
    /*jwg bb setup vfa scheme if required*/
    /*see RFsetup_bbepi.e for more details*/
    if(vfa_flag > 2) read_flip_table();
    if(vfa_flag == 1 || vfa_flag == 2) write_flip_table();
    if(vfa_flag == 0) fprintf(stderr,"No VFA schedule!\n");
    /*jwg read sake here*/
    if(sake_flag > 0) read_sake();

    user_bw = exist(opuser23);

    epi_asset_override();

@inline Asset.e AssetEval

    epi_asset_set_dropdown();

    /* update gradient config for DVw  */
    if(cfgcoiltype == PSD_XRMW_COIL && epigradspec_flag == PSD_ON)
    {
        dvw_grad_test = exist(opuser1);
        if(dvw_grad_test != save_dvw_grad_test)
        {
            save_dvw_grad_test = dvw_grad_test;
            switch(dvw_grad_test)
            {
                case 1: 
                    config_update_mode = CONFIG_UPDATE_TYPE_DVW_AMP20SR150; 
                break;
                case 2: 
                    config_update_mode = CONFIG_UPDATE_TYPE_DVW_AMP34SR120; 
                break;
                default: 
                    config_update_mode = CONFIG_UPDATE_TYPE_DVW_DEFAULT; 
                break;
            }
            inittargets(&loggrd, &phygrd);
            inittargets(&epiloggrd, &epiphygrd);
            epiphygrd.xrt = cfrmp2xfs;
            epiphygrd.yrt = cfrmp2yfs;
            epiphygrd.zrt = cfrmp2zfs;
            epiphygrd.xft = cffall2x0;
            epiphygrd.yft = cffall2y0;
            epiphygrd.zft = cffall2z0;
            epiloggrd.xrt = epiloggrd.yrt = epiloggrd.zrt =
                IMax(3,cfrmp2xfs,cfrmp2yfs,cfrmp2zfs);
            epiloggrd.xft = epiloggrd.yft = epiloggrd.zft =
                IMax(3,cffall2x0,cffall2y0,cffall2z0);
            opnewgeo = PSD_ON;
        }

    }

    /* Silent Mode  05/19/2005 YI */
    /* Get gradient spec for silent mode */
    getSilentSpec(exist(opsilent), &grad_spec_ctrl, &glimit, &srate);

    /* MRIhc56520: for EPI with ART on 750w. */
    if (exist(opsilent) && (cffield == B0_30000) && (cfgcoiltype == PSD_XRMW_COIL))
    {
        srate = XRMW_3T_EPI_ART_SR;
    }

    /* Update configurable variables */
    if(set_grad_spec(grad_spec_ctrl,glimit,srate,PSD_ON,debug_grad_spec) == FAILURE)
    {
      epic_error(use_ermes,"Support routine set_grad_spec failed",
        EM_PSD_SUPPORT_FAILURE,1, STRING_ARG,"set_grad_spec");
        return FAILURE;
    }
    /* Skip setupConfig() if grad_spec_ctrl is turned on */
    if(grad_spec_change_flag) { 
        if(grad_spec_ctrl)config_update_mode = CONFIG_UPDATE_TYPE_SKIP;
        else              config_update_mode = CONFIG_UPDATE_TYPE_ACGD_PLUS;
        inittargets(&loggrd, &phygrd);
        inittargets(&epiloggrd, &epiphygrd);
        epiphygrd.xrt = cfrmp2xfs;
        epiphygrd.yrt = cfrmp2yfs;
        epiphygrd.zrt = cfrmp2zfs;
        epiphygrd.xft = cffall2x0;
        epiphygrd.yft = cffall2y0;
        epiphygrd.zft = cffall2z0;
        epiloggrd.xrt = epiloggrd.yrt = epiloggrd.zrt =
            IMax(3,cfrmp2xfs,cfrmp2yfs,cfrmp2zfs);
        epiloggrd.xft = epiloggrd.yft = epiloggrd.zft =
            IMax(3,cffall2x0,cffall2y0,cffall2z0);
    }
    /* End Silent Mode */

    /* internref */  /* MRIhc06307 and MRIhc19932 */
    /* jwg bb added enable_iref_etl == 0 for C13 dynamic studies*/
    if( exist(opnshots) == 1 && acqs == 1 && enable_iref_etl == 1 &&(exist(opfmri) == PSD_ON || (mph_flag && (opfphases > 10) && (opacqo == PSD_OFF) && (PSD_OFF == touch_flag)) )){
 
        iref_etl = DEFAULT_IREF_ETL;

    } else {

        iref_etl = 0;

    }

    rtb0_flag = PSD_OFF;
    rtb0_comp_flag = rtb0_flag;
    if(psd_board_type == PSDCERD || psd_board_type == PSDDVMR)
    {
        pack_ix = PSD_XCVR2;
    }
    else
    {
        pack_ix = 0;
    }
    rtb0_minintervalb4acq = IMax(3, DABSETUP,
                                    XTRSETLNG + XTR_length[pack_ix] + DAB_length[pack_ix],
                                    XTRSETLNG + XTR_length[pack_ix] - rcvr_ub_off);

    /* internref: following error checks are only for testing. 
     * should not be in error database */

    if( iref_etl < 0 ){
        epic_error(0,"Please set iref_etl not less than 0",0, 0);
        return FAILURE;
    }

    if((!rtb0_flag) && rtb0_comp_flag) {
        epic_error(0,"rtb0_comp_flag should not be ON when rtb0_flag is OFF",0, 0);
        return FAILURE;
    }

    if(iref_etl == 0 && rtb0_flag) {
        epic_error(0,"rtb0_flag should not be ON when iref_etl is 0",0, 0);
        return FAILURE;
    }

    if( ky_dir == PSD_CENTER_OUT && iref_etl != 0 ){
        epic_error(0,"Internal reference is incompatible with CENTER_OUT",0, 0);
        return FAILURE;
    }
    if( seq_data != 0 && iref_etl != 0 ){
        epic_error(0,"seq_data must be 0 when iref_etl > 0",0, 0);
        return FAILURE;
    }

    if( gy1pos != 1 && iref_etl != 0 ){
        epic_error(0,"gy1pos must be 1 when iref_etl > 0",0, 0);
        return FAILURE;
    }

    if( opacqo != 0 && iref_etl != 0 ){
        epic_error(0,"Sequential multi-phase is not compatible with iref_etl > 0",0, 0);
        return FAILURE;
    }

@inline touch.e TouchEval

    /* SXZ::MRIge76397: disable user cv page if no option inside */
    if( piuset == 0 ) pititle = 0;
    
    /* SXZ::MRIge80335 */
    if( exist(opuser0) == 1 )
    { 
        vrgfsamp = 1;
        /* MRIhc24685: The maximum xres allowed with ramp sampling ON  is 256 */
        cvmax(opxres, 256);

        if( (epispec_flag == PSD_ON) || (epiespopt_flag == PSD_ON) || (epiRTespopt_flag == PSD_ON) ||
            (epiminesp_flag == PSD_ON) || (epiRTminesp_flag == PSD_ON) || (dbdt_model == DBDTMODELCONV) ||
            ((cffield == B0_15000) && (PSD_XRMB_COIL == cfgcoiltype)))
        {
            rampopt = 0; 
        }
        else
        {
            rampopt = 1;
        } 
    }
    else
    {
        vrgfsamp = 0;
        /* MRIhc24685: The maximum xres allowed with ramp sampling OFF is 512 */ 
        cvmax(opxres, 512);
        rampopt = 0;
    }

%ifdef RT 
@inline epiRTfile.e epiRT_check_eegblank_and_TTL 
%endif 

    /* 4/21/96 RJL: Init all new Advisory Cvs from InitAdvisories.e */
    InitAdvPnlCVs();

    /* Initialize advisory panel values */
    avmaxtr = TR_MAX;
    avmaxslquant = 1;
    avminnecho = 1; 
    avmaxnecho = 1;
    
    avminphasefov = 0.5;
    avmaxphasefov = 1.0;
    if (touch_flag)
    {
        avminsldelay = TR_PASS;
    }
    else
    {
        avminsldelay = 0us;  /* minimum delay between passes */
    }
    avmaxsldelay = 20s;

    avminxres = 16; /*jwg bb changed from 32 to 16 for c13*/
    avmaxxres = 512;
    
    /* Make sure Y res is within a valid range */
    if( opyres < avminyres ) {
        epic_error( use_ermes, "The phase encoding steps must be increased to %d for the current prescription.", EM_PSD_YRES_OUT_OF_RANGE2, EE_ARGS(1), INT_ARG, avminyres );
        return ADVISORY_FAILURE;
    }
    if( opyres > avmaxyres ) {
        epic_error( use_ermes, "The phase encoding steps must be decreased to %d for the current prescription.", EM_PSD_YRES_OUT_OF_RANGE, EE_ARGS(1), INT_ARG, avmaxyres );
        return ADVISORY_FAILURE;
    }

    /* Setsysparms sets the psd_grd_wait and psd_rf_wait
       parameters for the particular system. */
    if (setsysparms() == FAILURE) {
        epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "setsysparms");
        return FAILURE;
    }
    
    ir_on = exist(opirprep);
    epi_ir_on = ir_on;
    
    /* ***************************
       Multi-Phase parameters
       *************************** */
    mph_flag = ((exist(optouch) || exist(opmph))==PSD_ON ? PSD_ON : PSD_OFF);
    
    if ( (mph_flag==PSD_ON) && (exist(opacqo)==0) && 
         (exist(opcgate)==PSD_ON) ) {   /* multi-rep cardiac gated */
        pass_reps = exist(opfphases);
        reps = 1;
    } else { 
        if ( (mph_flag==PSD_ON) && (exist(opacqo)==0) ) {  /* interleaved multi-phase */
            pass_reps = exist(opfphases);
            reps = 1;
        } else { 
            if ( (mph_flag==PSD_ON) && (exist(opacqo)==1) ) { /* sequential multi-phase */
                reps = exist(opfphases);
                pass_reps = 1;
            } else {  /* default */
                reps = 1;
                pass_reps = 1;
            }
        }
    } /* end if(mph_flag.... */

    acqmode =  exist(opacqo); /* acq mode, 0=interleaved, 1=def=sequential */
    rhuser4 = acqmode; /* for recon fix MRIge36453 */

    /* MRIhc07356 */
    /* YMSmr06713  04/26/2005 YI */
    if (existcv(opsldelay) && (exist(opsldelay) == avminsldelay) && (avminsldelay <= 1us)) {

        /* set pass_delay to min. = 1 us which is effectively    */
        /* a delay = 0us between passes since the delay between */
        /* each null pass is also 1 us.                         */
        pass_delay = 1us;
        num_passdelay = 1;
        
    } else {

        /* Else...set the delay to the prescribed value */
        pass_delay = exist(opsldelay);
        if (pass_delay > 15s) {
            num_passdelay = pass_delay/15s+((pass_delay%15s==0)?0:1);
        }
        else {
            num_passdelay = 1;
        }
        pass_delay = pass_delay/num_passdelay+1;

    }

    piphases = exist(opphases);
    max_phases = piphases;
        
    if (cffield == B0_5000) 
    { /* at 0.5T, turn on fatsat, turn off spsp */
        cvoverride(opsat, PSD_ON, PSD_FIX_ON, PSD_EXIST_ON);
        cvoverride(opfat, PSD_ON, PSD_FIX_ON, PSD_EXIST_ON);
        ss_rf1 = PSD_OFF;
    }
    
    /* MRIge48532 - turn on eosykiller if ss_rf1 = PSD_ON */
    if (exist(opfat) == PSD_ON) 
    {
        ss_rf1 = PSD_OFF;
        eosykiller = PSD_OFF;
    } 
    else 
    {
        ss_rf1 = PSD_ON;
        eosykiller = PSD_ON;
    }

    /* BJM: epi Specs */
    if(epispec_flag == PSD_ON) 
    {
        ss_rf1 = PSD_OFF;        /* turn off spatial spectral flag */
    }

    opautotr = 0;
    fast_rec = 0;
    cvmin(intleaves, 1);
    cvmax(intleaves, avmaxyres);
    
    /* gxdelay and gydelay must lie on 4us bundaries */
    if (gxdelay % GRAD_UPDATE_TIME != 0) {
        cvoverride(gxdelay,RUP_GRD(gxdelay),_gxdelay.fixedflag, _gxdelay.existflag);
    }
    
    if (gydelay % GRAD_UPDATE_TIME != 0) {
        cvoverride(gydelay,RUP_GRD(gydelay),_gydelay.fixedflag, _gydelay.existflag);
    }
    
    intleaves = exist(opnshots);
    
    piphasfovnub = 0;
    /* Variable FOV buttons on or off depending on square pixels */
    if ( (exist(opsquare) == PSD_ON) || (exist(opnopwrap) == PSD_ON) ) {
        piphasfovnub2 = 0;
    } else {
        piphasfovnub2 = 7;
        piphasfovval2 = 1.0;
        piphasfovval3 = 0.5;
    }
    
    /* Set default frequency encoding direction for head R/L  QT*/
    if (( TX_COIL_LOCAL == txCoilInfo[getTxIndex(coilInfo[0])].txCoilType 
          && ( exist(opplane) == PSD_AXIAL || exist(opplane)== PSD_COR) ) ||
        ( TX_COIL_LOCAL == txCoilInfo[getTxIndex(coilInfo[0])].txCoilType 
          && exist(opplane) == PSD_OBL && existcv(opplane) 
          && ( exist(opobplane) == PSD_AXIAL || exist(opobplane) == PSD_COR ))) 
        piswapfc = 1;
    else 
        piswapfc = 0;
    
    /****  Asymmetric Fov  ****/
    /* handling for phase (y) resolution and recon scale factor.*/
    if ( (exist(opphasefov) != 1.0) && existcv(opphasefov) 
         && ( (exist(opsquare) != PSD_ON) && existcv(opsquare) ) ) {
        rhphasescale = exist(opphasefov);
        eg_phaseres = exist(opyres);
    } else { 
        if (exist(opsquare) == PSD_ON) {
            rhphasescale = (float)exist(opyres)/(float)exist(opxres);
            
            /* MRIge50536 - BJM: only set this if yres exists */
            /* MRIge61054 - BSA Menu chase correction,  error trapping moved to cvcheck */
            if( existcv(opyres) && existcv(opxres) && (rhphasescale<=1.0) && (0.5<=rhphasescale) ) {
                setexist(opphasefov,PSD_ON);
                _opphasefov.fixedflag = 0;
                opphasefov = rhphasescale;
                _opphasefov.fixedflag = 1;
                eg_phaseres = exist(opxres);
            }
        } else {
            rhphasescale = 1.0;
            _opphasefov.fixedflag = 0;
            opphasefov = 1.0;
            _opphasefov.fixedflag = 1;
            eg_phaseres = exist(opyres);
        }
    }
    
    /* set up rhfreqscale */
    rhfreqscale = 1.0;
    dfg = 1;
    dfscale = 1.0;
    freq_scale = rhfreqscale;
       
    /**********************************************************************
     Initialize RF System Safety Information.  This must be re-initialized
     in eval section since CV changes may lead to scaling of rfpulse.
    *********************************************************************/
    for (pulse=0; pulse<RF_FREE; pulse++) {
        rfpulseInfo[pulse].change=PSD_OFF;
        rfpulseInfo[pulse].newres=0;
    }
    /* Reinitialize Prescan CV's for cveval. Done so rf system safety check
       can be performed with each OPIO change. */

@inline vmx.e SysParmEval
	fprintf(stderr,"before obloptim, pw_gyb and a_gyb are %d and %f \n\n\n\n",pw_gyb,a_gyb);    
    if (exist(opslquant) == 3 && b0calmode == 1) {
        setb0rotmats();
         
        save_newgeo = opnewgeo;
         
        if (obloptimize_epi(&loggrd, &phygrd, scan_info, exist(opslquant),
                            PSD_OBL, 0, 1, obl_debug, &opnewgeo, cfsrmode)==FAILURE) {
            psd_dump_scan_info();
            epic_error(use_ermes,"%s failed in %s", EM_PSD_FUNCTION_FAILURE,
                       EE_ARGS(2), STRING_ARG, "obloptimize_epi",
                       STRING_ARG, "cveval()");
            return FAILURE;
        }
         
        /* BJM: MRIge47073 derate non readout waveforms */
        dbdtderate(&loggrd, 0);  
         
        /* call for epiloggrd */
        opnewgeo = save_newgeo;
        if (obloptimize_epi(&epiloggrd, &epiphygrd, scan_info, exist(opslquant),
                            PSD_OBL, 0, 1, obl_debug, &opnewgeo, cfsrmode)==FAILURE) {
            psd_dump_scan_info();
            epic_error(use_ermes, "%s failed in %s", EM_PSD_FUNCTION_FAILURE,
                       EE_ARGS(2), STRING_ARG, "obloptimize_epi",
                       STRING_ARG, "cveval()");
            return FAILURE;
        }    
         
    } else {
        save_newgeo = opnewgeo;
        if (obloptimize_epi(&loggrd, &phygrd, scan_info, exist(opslquant),
                            exist(opplane), exist(opcoax), obl_method,
                            obl_debug, &opnewgeo, cfsrmode)==FAILURE) {
            psd_dump_scan_info();
            epic_error(use_ermes,"%s failed in %s", EM_PSD_FUNCTION_FAILURE,
                       EE_ARGS(2), STRING_ARG, "obloptimize_epi",
                       STRING_ARG, "cveval()");
            return FAILURE; 
        }
         
        /* BJM: MRIge47073 derate non readout waveforms */
        dbdtderate(&loggrd, 0);  
         
        opnewgeo = save_newgeo;
        if (obloptimize_epi(&epiloggrd, &epiphygrd, scan_info, exist(opslquant),
                            exist(opplane), exist(opcoax), obl_method,
                            obl_debug, &opnewgeo, cfsrmode)==FAILURE) {
            psd_dump_scan_info();
            epic_error(use_ermes, "%s failed in %s", EM_PSD_FUNCTION_FAILURE,
                       EE_ARGS(2), STRING_ARG, "obloptimize_epi",
                       STRING_ARG, "cveval()");
            return FAILURE; 
        }

    } /* end if (exist(opslquant) == 3 && b0calmode == 1) */
    	fprintf(stderr,"after obloptim, pw_gyb and a_gyb are %d and %f \n\n\n\n",pw_gyb,a_gyb);    
    /* reinitialize sat and prescan vars in case loggrd changed */
    
    if (SpSatInit(vrgsat) == FAILURE) return FAILURE;
 
@inline ChemSat.e ChemSatInit
@inline BroadBand.e BBcvinit /*jwg bb*/
@inline Prescan.e PScvinit
@inline Inversion.e InversionInit
	
    /*jwg bb opuser20 for external waveforms*/
    if ((opuser20 == 0)) /*play default fat/water spsp*/
    {	
    if ( (exist(oppseq) == PSD_SE) || (exist(opflip)>30) ) {
        pw_rf1 = PSD_SE_RF1_PW;
        res_rf1 = PSD_SE_RF1_R;
        gscale_rf1 = .90;
        flip_rf1 = 90.0;
        hrf1a = PSD_SE_RF1_LEFT;
        hrf1b = PSD_SE_RF1_RIGHT;
        a_rf1 = 0.5;
        rftype = PLAY_RFFILE;
	thetaflag = 0;		
        sprintf(ssrffile, "/usr/g/bin/rffl901mc.rho");
        sprintf(ssgzfile, "/usr/g/bin/rfempty1.gz");
	a_phaserf1 = 0;
	sw_freq = 0;			
    } else {
        pw_rf1 = PSD_GR_RF1_PW;
        res_rf1 = PSD_GR_RF1_R;
        gscale_rf1 = .90;
        flip_rf1 = 30.0;
        hrf1a = PSD_GR_RF1_LEFT;
        hrf1b = PSD_GR_RF1_RIGHT;
        a_rf1 = 0.5;
        rftype = PLAY_RFFILE;
	thetaflag = 0;		
        sprintf(ssrffile, "/usr/g/bin/rfgr30l.rho");
        sprintf(ssgzfile, "/usr/g/bin/rfempty1.gz");
	a_phaserf1 = 0;
	sw_freq = 0;			
    }
    } else {
    /*jwg bb this is where external rf info goes*/
    /*the system default calls thetatype for the OMEGA pulse, I added thetaflag for the THETA board for complex RF*/
    /*dont ask*/
    switch ((int)opuser20)
    {
    case 1: /*sinc excitation*/
        pw_rf1 = 3200;
        res_rf1 = 320;
        gscale_rf1 = 1;
        flip_rf1 = opflip;
        hrf1a = pw_rf1 / 2;
        hrf1b = pw_rf1 / 2;
        a_rf1 = (float)flip_rf1 / 180;
        sprintf(ssrffile, "/usr/g/bin/hard.rho");
        sprintf(ssgzfile, "/usr/g/bin/rfempty1.gz");
	ss_rf1 = 0; /*no spsp*/
	rftype = 0;
	gztype = 0;
	thetatype = 0;
	thetaflag = 0;	
	a_phaserf1 = 0;
	sw_freq = 0;				
    break;
    case 2: /*or_pass spsp*/
        /*RF pulses stored in /usr/g/mrsc/jwgordon/ */
	strcpy(rf1froot,"jwgordon/or_pass");    
	strcpy(rf1_datfile,rf1froot);  strcat(rf1_datfile,".dat");
	read_spsp_datfile(rf1_datfile,&specspat_temp,&res_temp,&nom_pw_temp,&nom_flip_temp,
				   &abswidth_temp,&effwidth_temp,&area_temp,&dtycyc_temp,
				   &maxpw_temp,&max_b1_temp,&max_int_b1_sqr_temp,
				   &max_rms_b1_temp,&nom_bw_temp,&isodelay_temp,
				   &a_gzs_temp,&nom_thk_temp);
				   
	nom_thk_rf1 = nom_thk_temp;
	pw_rf1 = nom_pw_temp;
	nom_bw_temp = GAM * a_gzs_temp * nom_thk_rf1/10; /*calc this to make rest of psd happy, we set amp manually below*/
	res_rf1 = res_temp; 
	bw_rf1 = nom_bw_temp;
	/*double check the below values!!!*/
	gscale_rf1 = 1;
	flip_rf1 = opflip;
	hrf1a = pw_rf1 / 2;
	hrf1b = pw_rf1 / 2;
	a_rf1 = opflip / 180;
	ss_rf1 = 1;
	rftype = 1;
	gztype = 1;
	thetatype = 0; /*no external theta file*/
	thetaflag = 0;	
        sprintf(ssrffile, "jwgordon/or_pass.rho");
        sprintf(ssgzfile, "jwgordon/or_pass.grd");
	a_phaserf1 = 0;
	sw_freq = 0;		
    break;
    case 3: /*complex spsp, non-symmetric frequency response*/
        /*RF pulses stored in  */
	strcpy(rf1froot,"jwgordon/comp_sb");    
	strcpy(rf1_datfile,rf1froot);  strcat(rf1_datfile,".dat");
	read_spsp_datfile(rf1_datfile,&specspat_temp,&res_temp,&nom_pw_temp,&nom_flip_temp,
				   &abswidth_temp,&effwidth_temp,&area_temp,&dtycyc_temp,
				   &maxpw_temp,&max_b1_temp,&max_int_b1_sqr_temp,
				   &max_rms_b1_temp,&nom_bw_temp,&isodelay_temp,
				   &a_gzs_temp,&nom_thk_temp);
				   
	nom_thk_rf1 = nom_thk_temp;
	pw_rf1 = nom_pw_temp;
	nom_bw_temp = GAM * a_gzs_temp * nom_thk_rf1/10; /*calc this to make rest of psd happy, we set amp manually below*/
	res_rf1 = res_temp; 
	bw_rf1 = nom_bw_temp;
	/*double check the below values!!!*/
	gscale_rf1 = 1;
	flip_rf1 = opflip;
	hrf1a = pw_rf1 / 2;
	hrf1b = pw_rf1 / 2;
	a_rf1 = opflip / 180;
	ss_rf1 = 1;
	rftype = 1;
	gztype = 1;
	thetatype = 0; /*no external theta file*/
	thetaflag = 1;	
        sprintf(ssrffile, "jwgordon/comp_sb.rho");
        sprintf(ssgzfile, "jwgordon/comp_sb.grd");
	sprintf(ssthetafile,"jwgordon/comp_sb.pha");	
	pw_phaserf1 = pw_rf1; /*these two are here to make the EXTWAVE macro happy, now don't need to download twice*/
	res_phaserf1 = res_rf1;
	a_phaserf1 = 1;
	sw_freq = 598;	
    break; 
    case 98: /*magnitude spsp*/
        /*RF pulses stored in  */
	strcpy(rf1froot,"jwgordon/spsp98");    
	strcpy(rf1_datfile,rf1froot);  strcat(rf1_datfile,".dat");
	read_spsp_datfile(rf1_datfile,&specspat_temp,&res_temp,&nom_pw_temp,&nom_flip_temp,
				   &abswidth_temp,&effwidth_temp,&area_temp,&dtycyc_temp,
				   &maxpw_temp,&max_b1_temp,&max_int_b1_sqr_temp,
				   &max_rms_b1_temp,&nom_bw_temp,&isodelay_temp,
				   &a_gzs_temp,&nom_thk_temp);
				   
	nom_thk_rf1 = nom_thk_temp;
	pw_rf1 = nom_pw_temp;
	nom_bw_temp = GAM * a_gzs_temp * nom_thk_rf1/10; /*calc this to make rest of psd happy, we set amp manually below*/
	res_rf1 = res_temp; 
	bw_rf1 = nom_bw_temp;
	/*double check the below values!!!*/
	gscale_rf1 = 1;
	flip_rf1 = opflip;
	hrf1a = pw_rf1 / 2;
	hrf1b = pw_rf1 / 2;
	a_rf1 = opflip / 180;
	ss_rf1 = 1;
	rftype = 1;
	gztype = 1;
	thetatype = 0; /*no external theta file*/
	thetaflag = 0;	
        sprintf(ssrffile, "jwgordon/spsp98.rho");
        sprintf(ssgzfile, "jwgordon/spsp98.grd");
	a_phaserf1 = 0;
	sw_freq = 0;		
    break;       
    case 99: /*test SPSP, complex RF*/
    	/*If want to do frequency shifting of passbands, need to input sw_freq manually for this pulse*/
        /*RF pulses stored in  */
	strcpy(rf1froot,"jwgordon/spsp99");    
	strcpy(rf1_datfile,rf1froot);  strcat(rf1_datfile,".dat");
	read_spsp_datfile(rf1_datfile,&specspat_temp,&res_temp,&nom_pw_temp,&nom_flip_temp,
				   &abswidth_temp,&effwidth_temp,&area_temp,&dtycyc_temp,
				   &maxpw_temp,&max_b1_temp,&max_int_b1_sqr_temp,
				   &max_rms_b1_temp,&nom_bw_temp,&isodelay_temp,
				   &a_gzs_temp,&nom_thk_temp);
				   
	nom_thk_rf1 = nom_thk_temp;
	pw_rf1 = nom_pw_temp;
	nom_bw_temp = GAM * a_gzs_temp * nom_thk_rf1/10; /*calc this to make rest of psd happy, we set amp manually below*/
	res_rf1 = res_temp; 
	bw_rf1 = nom_bw_temp;
	/*double check the below values!!!*/
	gscale_rf1 = 1;
	flip_rf1 = opflip;
	hrf1a = pw_rf1 / 2;
	hrf1b = pw_rf1 / 2;
	a_rf1 = opflip / 180;
	ss_rf1 = 1;
	rftype = 1;
	gztype = 1;
	thetatype = 0; /*no external theta file*/
	thetaflag = 1;
        sprintf(ssrffile, "jwgordon/spsp99.rho");
        sprintf(ssgzfile, "jwgordon/spsp99.grd");
	sprintf(ssthetafile,"jwgordon/spsp99.pha");
	pw_phaserf1 = pw_rf1; /*these two are here to make the EXTWAVE macro happy, now don't need to download twice*/
	res_phaserf1 = res_rf1;
	a_phaserf1 = 1;
    break;    
    } /*end switch*/
    } /*end opuser if/else*/
    /*jwg end*/    
    
    /*jwg bb for center frequency shifting. If desired, can manually set sw_freq to the stopband BW*/
    sw = sw_freq / TARDIS_FREQ_RES;	
    
    /*gztype = PLAY_TRAP;*/
    /*thetatype = NO_THETA;*/
    pw_rf2 = 3.2ms; 
    res_rf2 = RES_SE1B4_RF2;
    gscale_rf2 = .90;
    flip_rf2 = 180.0;
    hrf2a = pw_rf2/2;
    hrf2b = pw_rf2/2;
    a_rf2 = 1.0;
    alpha_rf2 = 0.46;
    
    /*jwg for testing passband shifting and complex RF, will clean up later*/
    /*if(opuser20 == 99) { sw = sw_freq / TARDIS_FREQ_RES; a_phaserf1 = 1; } else { sw = 0; a_phaserf1 = 0;}*/

    fprintf(stderr,"before SETUP \n");
    /*jwg bb only change setup based on PSD, not flip angle*/
    if (exist(oppseq) == PSD_SE /*|| (exist(opflip)>30)*/ ) {
        setuprfpulse(RF1_SLOT, &pw_rf1, &a_rf1, SAR_ABS_FL901MC, SAR_PFL901MC,
                     SAR_AFL901MC, SAR_DTYCYC_FL901MC, SAR_MAXPW_FL901MC, 1,
                     MAX_B1_FL901MC_90, MAX_INT_B1_SQ_FL901MC_90,
                     MAX_RMS_B1_FL901MC_90, 90.0, &flip_rf1, 4000.0,
                     NOM_BW_FL901MC_RF1, PSD_APS2_ON + PSD_MPS2_ON + PSD_SCAN_ON,
                     0, hrf1b, 1.0, &res_rf1, 0, &wg_rf1, rfpulse);
        
        setuprfpulse(RF2_SLOT, &pw_rf2, &a_rf2, SAR_ABS_SE1B4, SAR_PSE1B4,
                     SAR_ASE1B4, SAR_DTYCYC_SE1B4, SAR_MAXPW_SE1B4, 1,
                     MAX_B1_SE1B4_180, MAX_INT_B1_SQ_SE1B4_180,
                     MAX_RMS_B1_SE1B4_180, 180.0, &flip_rf2, 3200.0,
                     NOM_BW_SE1B4, PSD_APS2_ON + PSD_MPS2_ON + PSD_SCAN_ON, 0,
                     hrf2b, 1.0, &res_rf2, 0, &wg_rf2, rfpulse);
    } else { /*jwg: GRE mode, where we'll initially be for c13 imaging*/
    if(opuser20 < 2) /*run default code if want 1H spsp (=0)or sinc (=1)*/
    {
        fprintf(stderr,"default setuprfpulse \n");
        setuprfpulse(RF1_SLOT, &pw_rf1, &a_rf1, SAR_ABS_GR30L, SAR_PGR30L,
                     SAR_AGR30L, SAR_DTYCYC_GR30L, SAR_MAXPW_GR30L, 1,
                     MAX_B1_GR30L, MAX_INT_B1_SQ_GR30L, MAX_RMS_B1_GR30L,
                     30.0, &flip_rf1, 3200.0, NOM_BW_GR30L,
                     PSD_APS2_ON + PSD_MPS2_ON + PSD_SCAN_ON, 0,
                     hrf1b, 1.0, &res_rf1, 0, &wg_rf1, rfpulse);
    } else { /*run setuprfpulse given the parameters from the dat file*/
	setuprfpulse (RF1_SLOT, &pw_rf1, &a_rf1, abswidth_temp, effwidth_temp,
		 area_temp,dtycyc_temp, maxpw_temp, 1, max_b1_temp,
		 max_int_b1_sqr_temp, max_rms_b1_temp,
		 nom_flip_temp, &flip_rf1, nom_pw_temp, nom_bw_temp,
		 PSD_MPS2_ON+PSD_APS2_ON+PSD_SCAN_ON, (char ) 0, 0, 0.0,
		 (int *) &res_rf1, 1,(int*)&wg_rf1 ,rfpulse);
		 
	/*calculate amp from .dat file, won't use ampslice functions below*/	
	nom_thk_rf1 = nom_thk_rf1 * 4257.6 / (GAM);
	pw_gzrf1 = pw_rf1;
	a_gzrf1 = a_gzs_temp*(nom_thk_rf1/thk_rf1)*(rfpulse[RF1_SLOT].nom_pw / pw_rf1);
	gettarget(&target, ZGRAD, &loggrd);
	ia_gzrf1 = (a_gzrf1/target) * MAX_PG_IAMP;
	//nom_bw_temp = GAM * a_gzs_temp * nom_thk_rf1/10; /*calc this to make rest of psd happy, we set amp manually below*/
	nom_bw_temp = 4257.6 * a_gzs_temp * nom_thk_temp/10;
	res_rf1 = res_temp; 
	bw_rf1 = nom_bw_temp;
	rfpulse[RF1_SLOT].nom_bw = bw_rf1; /*jwg bb need to set this to bw_rf1, as it will be used in sseval1 for calculations!*/
        fprintf(stderr,"bw is %d\n", bw_rf1);
	fprintf(stderr,"a_gzs_temp = %f, nom_thk_rf1 = %f, thk_rf1 = %f, nom PW = %f, pw_rf1 = %d\n",a_gzs_temp,nom_thk_rf1,thk_rf1,rfpulse[RF1_SLOT].nom_pw,pw_rf1);		 
	fprintf(stderr,"right after calc, amp and iamp are %f and %d \n",a_gzrf1,ia_gzrf1);
    }		     
        /*see prototype in include/support_func.host.h*/
        setuprfpulse(RF2_SLOT, &pw_rf2, &a_rf2, SAR_ABS_SE1B4, SAR_PSE1B4,
                     SAR_ASE1B4, SAR_DTYCYC_SE1B4, SAR_MAXPW_SE1B4, 1,
                     MAX_B1_SE1B4_180, MAX_INT_B1_SQ_SE1B4_180,
                     MAX_RMS_B1_SE1B4_180, 180.0, &flip_rf2, 3200.0,
                     NOM_BW_SE1B4, PSD_APS2_ON + PSD_MPS2_ON + PSD_SCAN_ON, 0,
                     hrf2b, 1.0, &res_rf2, 0, &wg_rf2, rfpulse);
    }
    fprintf(stderr,"after SETUP \n");    
    
    /* BJM epispec stuff */
    if(epispec_flag == PSD_ON) {
        pw_rf1 = NOM_PW_RTIA;                  /* width of RF1 */
        res_rf1 = RES_RTIA;                    /* resolution of RF1 */
        hrf1a = NOM_PW_RTIA-ISO_RTIA;
        hrf1b = ISO_RTIA;
        setuprfpulse(RF1_SLOT, &pw_rf1, &a_rf1, SAR_ABS_RTIA, SAR_PRTIA,
                     SAR_ARTIA, SAR_DTYCYC_RTIA, SAR_MAXPW_RTIA, 1,
                     MAX_B1_RTIA_08_30, 0.000858061, 0.0327502,
                     NOM_FA_RTIA, &flip_rf1, NOM_PW_RTIA, NOM_BW_RTIA,
                     PSD_APS2_ON + PSD_MPS2_ON + PSD_SCAN_ON, 0,
                     ISO_RTIA, 1.0, &res_rf1, 1, &wg_rf1, rfpulse);
        sprintf(ssrffile, "/usr/g/bin/rf_bw4_800us.rho");
      
        sprintf(ssgzfile, "/usr/g/bin/rfempty1.gz");
    }

    /* BJM: change pulse if possible */
    if( (cfsrmode >= PSD_SR100) ) {
 
        /* turn on 1.5T delay insensitive RF pulse */
        if (cffield ==  B0_15000) {
            ss_override = 1;
        } else {
            ss_override = 0;   /* 3T is already delay insensitive */
        }

    } else {

        ss_override = 0;

    }

    /*jwg bb this is where things are being changed behind our back!*/
    /*it looks like the psd is setting up the pulse above, but then it's */
    /*overwriting it based on the ss_rf1 flag. */
    /*Let's change that! Only call for 1H SPSP or sinc*/    
    if (opuser20 < 2 ) 
    {
	    if (ssInit() == FAILURE) return FAILURE;
    }
    
    
    
    /* Check to see if rf pw's need scaling for large patients */
    for (entry=0; entry<MAX_ENTRY_POINTS; entry ++)
        scalerfpulses(opweight,cfgcoiltype,RF_FREE,rfpulse,entry,rfpulseInfo);
    
    /* If pulse width of 90 scaled, then scale off90 accordingly */
    if (rfpulseInfo[RF1_SLOT].change==PSD_ON)
        off90 *= (int) rint(pw_rf1 / rfpulse[RF1_SLOT].nom_pw);
    
    /*	iso_delay = pw_rf1/2 + off90; */
    
    /* Inner volume selective pulse */
    pw_gyrf2iv = pw_rf2;
    off90 = 0;
    
    pw_gzrf1 = pw_rf1;
    pw_gzrf2 = pw_rf2;
    flip_rf1 = exist(opflip);

    fprintf(stderr,"before sseval1, amp and iamp are %f and %d \n",a_gzrf1,ia_gzrf1);
    fprintf(stderr,"bw is %d\n", bw_rf1);
    /*jwg this is resetting a_gzrf1 and ia_gzrf1 for user-defined c13 pulses.*/
    /*jwg need to run it to make the psd happy, so just reset the CVs after it*/
    if (ssEval1() == FAILURE) return FAILURE;  /* Redefine area_gz1, bw_rf1, 
                                                  hrf1a, hrf1b and other parameters for spectral-spatial pulse. */
    if(opuser20 > 1 )
    {
    	a_gzrf1 = a_gzs_temp*(nom_thk_rf1/thk_rf1)*(rfpulse[RF1_SLOT].nom_pw / pw_rf1);
	gettarget(&target, ZGRAD, &loggrd);
	ia_gzrf1 = (a_gzrf1/target) * MAX_PG_IAMP;
	fprintf(stderr,"after sseval1 amp and iamp are %f and %d \n",a_gzrf1,ia_gzrf1);
    fprintf(stderr,"bw is %d\n", bw_rf1);
    }
    
    if (ss_fa_scaling_flag && (cfgcoiltype == PSD_XRMB_COIL || cfgcoiltype == PSD_XRMW_COIL) &&
        (ss_rf1 == PSD_ON) && (exist(oppseq) == PSD_GE) && max_ss_fa < avmaxflip)
    {
        avmaxflip = max_ss_fa;
    }

    /* Make sure the true bandwidths are up to date. */
    bw_rf1 = rfpulse[RF1_SLOT].nom_bw*rfpulse[RF1_SLOT].nom_pw/pw_rf1;
    bw_rf2 = rfpulse[RF2_SLOT].nom_bw*rfpulse[RF2_SLOT].nom_pw/pw_rf2;
    fprintf(stderr,"bw is %d\n", bw_rf1);
    
    /* time from the start of the excitation pulse to the magnetic isocenter */
    t_exa = hrf1a - off90;
    
    rfExIso = hrf1b + off90;
    
    /* auto min te and tr */
    if ( exist(opautote) == PSD_MINTE || exist(opautote) == PSD_MINTEFULL ) 
        setexist(opte,PSD_OFF);
    
    if (exist(opfcomp) == PSD_ON && existcv(opfcomp)) {
        zgmn_type = CALC_GMN1;
        ygmn_type = CALC_GMN1;
    } else {
        zgmn_type = NO_GMN;
        ygmn_type = NO_GMN;
    }
    
    pw_gzrf2a = RUP_GRD(loggrd.zrt);
    pw_gzrf2d = RUP_GRD(loggrd.zrt);
    pw_gzrf2r1a = RUP_GRD(loggrd.zrt); 
    pw_gzrf2r1d = RUP_GRD(loggrd.zrt);
    
    /* Seqtype(MPMP, XRR, NCAT,CAT  needed for several routines */
    if (seqtype(&seq_type) == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "seqtype");
        return FAILURE;
    }
    
    /* Set the fract_ CVs */
    fract_ky = PSD_FULL_KY;
    ky_dir = PSD_TOP_DOWN;
    
    if (ky_dir == PSD_CENTER_OUT && fract_ky == PSD_FULL_KY)
        ep_alt = 2;   /*1st half +, second half - */
    else
        ep_alt = 0;
    
    nexcalc();
    
    /* X readout train */
    
    /* Some hardware restrictions apply:  When operating with the standard
       receiver, the data acquisition window spacings must be a multiple of
       the 187.5 kHz demodulation frequency offset.  This corresponds to a
       5.33 us period. The nearest integral multiple is then 16 us. */
    
    if (vrgfsamp == 0) {
        /* epigradopt() will set this properly for vrg */
        rhfrsize = exist(opxres);
    }
    
    if (vrgfsamp == 1 && user_bw == 0) {
        /* Turn off bandwidth buttons & rbw advisory */
        pircbnub = 0;
        piadvmax = (piadvmax & ~(1<<PSD_ADVRCVBW)); 
        piadvmin = (piadvmin & ~(1<<PSD_ADVRCVBW)); 
        
        /* MRIge50913 - BJM: force user to select rbw if vrgf turned off */
        _oprbw.existflag = 0;
    } else {
        piadvmax = (piadvmax | (1<<PSD_ADVRCVBW));
        piadvmin = (piadvmin | (1<<PSD_ADVRCVBW));
    }
    
    /* Fill in the epigradopt input structure */
    if (autogap == 1) {
        xtarg = epiloggrd.tx;
        ytarg = epiloggrd.ty;
    } else {
        xtarg = epiloggrd.tx_xy;
        ytarg = epiloggrd.ty_xy;
    }
    
    /* Local block for calcualting tsp */
    {
        /* HALF_KHZ_USEC is from filter.h - need to change from cfcerdbw1 when */
        /* config name changes */
        float tsp_min = (HALF_KHZ_USEC /RBW_MAX);
        float act_rbw;
        float decimation;
        float max_rbw;
 
        if (vrgfsamp == PSD_ON  && user_bw == 0) {
            
            rbw = 0.0;  /* calculate this for the vrgf case */
            
            /* Do this so rhfrsize remains low enough for current recon limitations */
            if (exist(opxres) <= 128) {
                vrgf_targ = 2.0;
            } else {
                vrgf_targ = 1.6;
            }
            
            /* 4x oversampling ratio desired */
            tsp = 1.0 / (GAM * xtarg * exist(opfov) / 10.0) / (vrgf_targ / 1.0e6); 
                                  
            /* Cant go lower than hardware sample period */
            if (tsp < tsp_min) {
                tsp = tsp_min;
            }  

            /* Calculate desited RBW in kHz. */
            /* Note: this might not be valid if the */
            /* decimation required is not supported by */
            /* MGD.  Thus, we will check this calculation */
            /* below with calcvalidrbw() */
            /* Hz to kHz */
            rbw = ( 1.0 /(2.0*(tsp / 1.0s)) )/ 1000.0;

            /* Check for a valid RBW */
            /* Calculate the rbw, decimation based on the */
            /* the supported MGD configuration */
            /* This function will return act_rbw with the nearest */
            /* valid value and also overwrite the value of oprbw  */
            if (SUCCESS != calcvalidrbw(rbw, &act_rbw, &max_rbw, &decimation, 
                                        OVERWRITE_OPRBW, vrgfsamp)) {
                return FAILURE;
            }
            
            /* Recalculate tsp now that we have a valid RBW */
            tsp = 1.0s*(1.0/(2.0*(1000.0*act_rbw)));

            /* Reset rbw to updated value */
            rbw = act_rbw;
            
        }  else {
            
            /* first, check for a valid RBW */
            /* calculate the rbw, decimation based on the */
            if (SUCCESS != calcvalidrbw(exist(oprbw), &act_rbw, &max_rbw, 
                                        &decimation, OVERWRITE_OPRBW, vrgfsamp)) {
                return FAILURE;
            }

            /* tsp = echo1_filt.tsp;*/
            rbw = exist(oprbw); 

            /* Need to calculate tsp for epigradopt */
            tsp = 1.0s*(1.0/(2.0*(1000.0*rbw)));
            
        } /* end if(vrgfsamp == PSD_ON) */
    
        /* Round tsp (removes any small RO error) */
        tsp = (float)((floor)((tsp*10.0) + 0.5)/ 10.0);

    } /* end local block */
    
    /* Fill in the gradient structure for epigradopt() call */
    gradin.xfs = xtarg;
    gradin.yfs = ytarg;
    gradin.xrt = epiloggrd.xrt;
    gradin.yrt = epiloggrd.yrt;
    gradin.xbeta = epiloggrd.xbeta;
    gradin.ybeta = epiloggrd.ybeta;
    gradin.xfov = rhfreqscale*exist(opfov)/10.0;   /* convert to cm */
    /* MRIge92386 */
    gradin.yfov = exist(opphasefov)*exist(opfov)*asset_factor/10.0; /* convert to cm */

    if (vrgfsamp == PSD_OFF)
        gradin.xres = rhfrsize;
    else
        gradin.xres = exist(opxres);
    
    /* MRIge92386 */
    gradin.yres = (int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor);

    if (ky_dir == PSD_CENTER_OUT && fract_ky == PSD_FULL_KY)
        gradin.ileaves = intleaves/2;
    else
        gradin.ileaves = intleaves;
    gradin.xdis = cfdbdtdx;
    gradin.ydis = cfdbdtdy;
    gradin.tsp = tsp;
    gradin.osamps = osamp;
    gradin.fbhw = fbhw;
    gradin.vvp = hrdwr_period;    
    pw_gxgap = 0;  

    /* SXZ::MRIge72411: find taratio value for the current prescription */
    /* max k value */
    totarea = 1.0e6 * gradin.xres / (gradin.xfov * (FLOAT)GAM);
    if( vrgfsamp == PSD_ON && rampopt == 1 ){
        int indx;
        for(indx = 0; indx < NODESIZE; indx++){
            if(totarea <= totarea_arr[indx]){
                if( indx == 0 ){
                    taratio = taratio_arr[indx];
                }else{ 
                    taratio = taratio_arr[indx-1] 
                        + (totarea-totarea_arr[indx-1])
                        /(totarea_arr[indx]-totarea_arr[indx-1])
                        *(taratio_arr[indx]-taratio_arr[indx-1]);
                }
                break;
            }else if(indx==NODESIZE-1){
                taratio = taratio_arr[indx];
            }
        }

/* MRIhc05886 and MRIhc14486 */
%ifdef RT
@inline epiRTfile.e taratioAdjust_fMRI
%endif

        if( (cfgcoiltype == PSD_TRM_COIL) && (epispec_flag == 0) && (mph_flag == PSD_ON) && ((opfphases * opslquant) > 2048) ) {
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

        if ((PSD_ON == taratio_override) && (PSD_XRMW_COIL == cfgcoiltype))
        {
            taratio = TARATIO_XRMW;
        }

    }else{
        taratio = 0;
    }

    gradin.taratio = taratio;

    /* MRIhc44418 activate ESP range check*/

    each_gradopt_count = 0;

    if(iref_etl > 0 && cffield >= B0_30000 && PSD_XRMB_COIL == cfgcoiltype && 
       ((epira3_flag == PSD_ON || epiRTra3_flag == PSD_ON) && (ra3_sndpc_flag == PSD_OFF)))
    {
        esprange_check = 1;
    }
    else if(cffield >= B0_30000 && PSD_XRMW_COIL == cfgcoiltype)
    {
        esprange_check = 1;
    }
    else
    {
        esprange_check = 0;
    }

    if(esprange_check == 1) readEspRange();

    if(dbdt_model == DBDTMODELCONV && (cfdbdtts == 0.0 && cfdbdtper > 0.0))
    {
        if(optGradAndEsp_conv() == FAILURE) 
        {
            reopt_flag = PSD_ON;
            return FAILURE;
        }
        if(iref_etl > 0 && dbdtper_new > cfdbdtper) no_gy1_ol_gxw = 1;
        else no_gy1_ol_gxw = 0;
    }
    else if(esprange_check && (cfdbdtts == 0.0 && cfdbdtper > 0.0))
    {
        if(optGradAndEsp_rect() == FAILURE) 
        {
            reopt_flag = PSD_ON;
            return FAILURE;
        }
        no_gy1_ol_gxw = 0;
    }
    else
    {
        pw_gxgap = 0;
        dbdtper_new = cfdbdtper;
        if(epigradopt_rect(dbdtper_new, 0) == FAILURE) 
        {
            reopt_flag = PSD_ON;
            return FAILURE;
        }
        if(epigradopt_debug) printEpigradoptLog();
        no_gy1_ol_gxw = 0;
    }
    
    /* echo shifting for fractional echo and tuning */
    msamp = 0.0;
    dsamp = 0.0;       /* Delta echo shift (tuning) */
    
    /* PW_GXW delta for GW1 calc */ 
    delpw = (msamp+dsamp)*tsp;
    
    /* Position of dephaser pulses: pre- or post- 180 */
    /* For GRE - the positions are post-180 to get the proper sign */  
    if (exist(oppseq) != PSD_SE) {              
        /* set the gx1 and gy1 position flags */
        cvoverride(gx1pos, PSD_POST_180,_gx1pos.fixedflag,_gx1pos.existflag);
        cvoverride(gy1pos, PSD_POST_180,_gy1pos.fixedflag,_gy1pos.existflag);
    }
    
    /* X dephaser pulse */
    gx1_area = a_gxw * ((float)pw_gxwad/2.0 + (float)pw_gxwl +
                        (float)pw_gxw/2.0 + delpw);
    
    /* The GRAM circuit may require shaped attack and decay ramps to
       facilitate a smooth transition between the ramp transition and
       adjacent pulse seqments.  A mechanism is provided in 5.5 to shape
       the waveform such that it begins as a parabola, transitions smoothly
       into a linear segment covering the center portion of the transition,
       and transitions smoothly into a parabolic segment (a mirror of the
       first parabolic component) to terminate the transition.  This
       composite waveform and its first deriviative are continuous from
       start to end.   A parameter called "beta," ranging form 0 to 1,
       specifies the portion of the ramp that is linear.  If beta is 1,
       the ramp is completely linear; if zero, the ramp is completely
       parabolic.  As a greater portion of the waveform becomes parabolic,
       the slope of the linear segment increases.  The absolute area under
       the "ramp" transition remains constant for any value of beta over
       its range [0..1].
       PSD_ss1528822_RF1_LEFT
       Please refer to the 5.5 General PSD Enhancements SRS.
       
       The wave shaping is performed at the low level ramp generation
       routine (w_ramp funciton in wg_linear.c, PGEN_WAVE project).
       
       In the readout echo planar pulse train, the first attack and last
       decay ramp will have different shapes than the other ramps.
       For VRG sampling, this results in an assymmetry in the first and
       last view of the train.  To circumvent this, the dephaser pulse
       can be moved up against the readout train, and the dephaser's
       decay and be combined with the first readout attack ramp.
       
       The following code make this determination.  */
    
    /* If epiloggrd.xrt == loggrd.xrt then dB/dt is not an issue and
       a single ramp is legal. */
    if (( gx1_area >= a_gxw*(float)pw_gxwad) && gx1pos == PSD_POST_180 &&
        epiloggrd.xrt == loggrd.xrt)
        single_ramp_gx1d = 1;
    else
        single_ramp_gx1d = 0;
    
    if (single_ramp_gx1d == PSD_ON) {
        pw_gx1a = pw_gxwad;
        pw_gx1d = pw_gxwad;
        /* pw_gx1 must >= MIN_PLATEAU_TIME */
        pw_gx1 = IMax(2, RUP_GRD((int)(gx1_area/a_gxw - (float)pw_gx1a)), MIN_PLATEAU_TIME); 
        a_gx1 = -gx1_area/(float)(pw_gx1a + pw_gx1);
    } else {
        if (gx1pos == PSD_POST_180)
            gx1_area *= -1;
        start_amp = 0.0;
        end_amp = 0.0;
        if (amppwgradmethod(&gradx[GX1_SLOT], gx1_area, loggrd.tx_xyz, start_amp,
                            end_amp, loggrd.xrt, MIN_PLATEAU_TIME) == FAILURE) {
            epic_error(use_ermes,"%s failed", EM_PSD_SUPPORT_FAILURE,
                       EE_ARGS(1), STRING_ARG, "amppwgradmethod:gx1");
            return FAILURE;
        }
    }
    
    pw_gx1_tot = pw_gx1a + pw_gx1 + pw_gx1d;
    
    /* At this point, we know the timing for the basic parameters for
       the echo planar gradient train: amplitudes and pulse widths of
       readout and phase encoding trapezoids, excluding the y axis
       dephaser.
       
       To compute the advisory panel minimum TE, first calculate the
       other timing elements, such as slice select axis timing, killer
       pulses, etc.  Then proceed with advisory calculations,
       finishing up with calculation of the phase encoding dephaser,
       ky_offset, rhhnover, etc. */
    
    
    /***** Slice select timing ****************************************/
    /*jwg bb the external spsp rf files already have nominal thickness calculated,
    so we don't need to go through this process for them!*/
    if (opuser20 < 2)
    {
    fprintf(stderr,"running ampslice and optramp \n");
    if (ampslice(&a_gzrf1, bw_rf1, exist(opslthick), gscale_rf1, TYPDEF)
        == FAILURE) {
        epic_error(use_ermes, "%s failed for gzrf1", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "ampslice");
        return FAILURE;
    }
    
    /* optimize attack and decay ramps */
    if (optramp(&pw_gzrf1d, a_gzrf1, loggrd.tz_xyz, loggrd.zrt, TYPDEF) == FAILURE) {
        epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "optramp:pw_gzrf1d");
        return FAILURE;
    }
    pw_gzrf1a = pw_gzrf1d;
    }

    if (ampslice(&a_gzrf2, bw_rf2, exist(opslthick), gscale_rf2,TYPDEF)== FAILURE) {
        epic_error(use_ermes,"%s failed for gzrf2", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "ampslice");
        return FAILURE;
    }
    
    ivslthick = exist(opfov);
    if (ampslice(&a_gyrf2iv, bw_rf2, ivslthick, gscale_rf2, TYPDEF) == FAILURE) {
        epic_error(use_ermes, "%s failed for gyrf2iv", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "ampslice");
        return FAILURE;
    }
    
    gradz[GZRF1_SLOT].num = 1;
    gradz[GZK_SLOT].num = 1;
    
    if (exist(oppseq) == PSD_SE) {

        if (innerVol == PSD_ON) {  /* refocus pulse on logical Y */
            gradz[GZRF2_SLOT].num = 0;
            grady[GYRF2IV_SLOT].num = 1;

            if (optramp(&pw_gyrf2iva, loggrd.ty_xyz, loggrd.ty, loggrd.yrt, TYPDEF)
                == FAILURE) {
                epic_error(use_ermes,"%s failed", EM_PSD_SUPPORT_FAILURE,
                           EE_ARGS(1), STRING_ARG, "optramp:pw_gyrf2iva");
                return FAILURE;
	    }
            pw_gyrf2ivd = pw_gyrf2iva;

	} else {  /* refocus pulse on logical Z */
            gradz[GZRF2_SLOT].num = 1;
            grady[GYRF2IV_SLOT].num = 0;
	}

        gradz[GZRF2L1_SLOT].num = 1;
        gradz[GZRF2R1_SLOT].num = 1;
        gradz[GZRF2_SLOT].num = 1;
        rfpulse[RF2_SLOT].num = 1;
        rfpulse[RF2_SLOT].activity = PSD_APS2_ON + PSD_MPS2_ON + PSD_SCAN_ON;

    } else {
        gradz[GZRF2_SLOT].num = 0;
        grady[GYRF2IV_SLOT].num = 0;
        gradz[GZRF2L1_SLOT].num = 0;
        gradz[GZRF2R1_SLOT].num = 0;
        gradz[GZRF2_SLOT].num = 0;
        rfpulse[RF2_SLOT].num = 0;
        rfpulse[RF2_SLOT].activity = PSD_PULSE_OFF;
    }
    
    rfpulse[RF1_SLOT].num = 1;
    
    if (optramp(&pw_gzrf2l1a, loggrd.tz_xyz, loggrd.tz, loggrd.zrt, TYPDEF) == FAILURE) {
        epic_error(use_ermes,"%s failure", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "optramp:pw_gzrf2l1a");
        return FAILURE;
    }
  
    if (optramp(&pw_gzrf2l1d, fabs(a_gzrf2l1-a_gzrf2), loggrd.tz_xyz,
                loggrd.zrt, TYPDEF) == FAILURE)
        return FAILURE;
    
    crusher_type = PSD_TYPCMEMP;
    if (crusherutil(crusher_scale, crusher_type) == FAILURE) {
        epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "crusherutil");
        return FAILURE;
    }
	
    /* The CVs c1_scale, c2_scale, ... are maintained for bay testing. */
    c1_scale = crusher_scale[0];
    area_std = pw_gzrf2*a_gzrf2/2;
    
    /*  The following part is not needed for GRE-EPI. MRIge33618.  ypd */
    if (exist(oppseq) == PSD_SE || se_ref == 1) {
        if ((amppwcrush(&gradz[GZRF2R1_SLOT], &gradz[GZRF2L1_SLOT],
                        (int)1, c1_scale, loggrd.tz_xyz, a_gzrf2, area_std,
                        MIN_PLATEAU_TIME, loggrd.zrt) == FAILURE)) {
            epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                       EE_ARGS(1), STRING_ARG, "amppwcrush");
            return FAILURE;
        }
    } 
    
    /* Include gz1 and gzmn in gradient duty cycle calc. MRIge33619 YP Du */
    gradz[GZ1_SLOT].num = 1;
    
    if ( existcv(opfcomp) && exist(opfcomp) == PSD_ON)
        gradz[GZMN_SLOT].num = 1;
	
    /* *******************************************************
       Left Crusher for 1st 180 (handles 90 pulse rephasing)
       Calc area needed for z rephaser for amppwlcrsh routine.
    *******************************************************/
	
    /* spsp area needed for rephaser */
    
    avail_pwgz1 = TR_MAX;
    area_gz1 = ((float)rfExIso + (float)pw_gzrf1d/2.0)*a_gzrf1; 
    
    if (ssEval1() == FAILURE) return FAILURE;  /* redefine area_gz1 for
                                                  spectral-spatial pulse */

    if(opuser20 > 1 )
    {
    	a_gzrf1 = a_gzs_temp*(nom_thk_rf1/thk_rf1)*(rfpulse[RF1_SLOT].nom_pw / pw_rf1);
	gettarget(&target, ZGRAD, &loggrd);
	ia_gzrf1 = (a_gzrf1/target) * MAX_PG_IAMP;
	fprintf(stderr,"after sseval1 AGAIN amp and iamp are %f and %d \n",a_gzrf1,ia_gzrf1);
    }
    
    if(ss_rf1 == PSD_OFF) 
        area_gz1 = ((float)rfExIso + (float)pw_gzrf1d/2.0)*a_gzrf1;

    if (zgmn_type == CALC_GMN1) {
        /* Set time origin for moment calculation at end of gzrf1d decay ramp.
           Therefore the gzrf1 pulse is time reversed. */
        pulsepos = 0;
        zeromomentsum = 0.0;
        firstmomentsum = 0.0;
        invertphase = 0;
        
        if (ss_rf1 == PSD_ON) {
            zeromomentsum = gz1_zero_moment;
            firstmomentsum = gz1_first_moment;
	} else {
            rampmoments(0.0, a_gzrf1, pw_gzrf1d, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gzrf1, a_gzrf1, rfExIso, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
	}

        if (exist(oppseq) == PSD_SE) {
            /* Make left and right crushers mirror images of each other */
            a_gzrf2l1 = a_gzrf2r1;
            pw_gzrf2l1d = pw_gzrf2r1a;
            pw_gzrf2l1 = pw_gzrf2r1;
            pw_gzrf2l1a = pw_gzrf2r1d;
            pulsepos = -(rfExIso + pw_gzrf1d) + exist(opte) -
                (pw_gzrf2l1a + pw_gzrf2l1 + pw_gzrf2l1d + pw_gzrf2/2);
            rampmoments(0.0, a_gzrf2l1, pw_gzrf2l1a, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gzrf2l1, a_gzrf2l1, pw_gzrf2l1, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gzrf2l1, a_gzrf2, pw_gzrf2l1d, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gzrf2, a_gzrf2, pw_gzrf2/2, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            invertphase = 1;
            rampmoments(a_gzrf2, a_gzrf2, pw_gzrf2/2, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gzrf2, a_gzrf2r1, pw_gzrf2r1a, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gzrf2r1, a_gzrf2r1, pw_gzrf2r1, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            rampmoments(a_gzrf2r1, 0.0, pw_gzrf2r1d, invertphase, &pulsepos,
                        &zeromoment, &firstmoment, &zeromomentsum,
                        &firstmomentsum);
            avail_zflow_time = exist(opte) - (rfExIso + pw_gzrf1d + pw_gzrf2l1a +
                                              pw_gzrf2l1 + pw_gzrf2l1d +
                                              pw_gzrf2/2);
            firstmomentsum *= -1.0;
	} else {  /* gradient recalled echo */
            avail_zflow_time = exist(opte) - (rfExIso + pw_gzrf1d);
	}
        
        /* Calculate the z moment nulling pulses: gz1, gzmn */
        if (amppwgmn(zeromomentsum, firstmomentsum, 0.0, 0.0, avail_zflow_time,
                     loggrd.zbeta, loggrd.tz_xyz, loggrd.zrt, MIN_PLATEAU_TIME,
                     &a_gz1, &pw_gz1a, &pw_gz1, &pw_gz1d, &a_gzmn, &pw_gzmna,
                     &pw_gzmn, &pw_gzmnd) == FAILURE) {
            /* don't trap the failure here; this will drive minimum te */
        }
        a_gz1 *= -1.0;  /* Invert gz1 pulse */

    } else {        /* zgmn_type != CALC_GMN1 */

        pw_gzmna = 0;
        pw_gzmn = 0;
        pw_gzmnd = 0;
        
        if (exist(oppseq) != PSD_SE) {
	    if(opuser20 < 2 )  /*for 1H spsp or sinc*/
	    	{
	            if (amppwgz1(&a_gz1, &pw_gz1, &pw_gz1a, &pw_gz1d, area_gz1,
        	                 avail_pwgz1, MIN_PLATEAU_TIME, loggrd.zrt,
                	         loggrd.tz_xyz) == FAILURE) {
	                epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
        	                   EE_ARGS(1), STRING_ARG, "amppwgz1");
                	return FAILURE;
			}
	
		    } else { /*jwg c13 spsp pulses are self-refocusing (i.e. built-in)*/
		     	area_gz1 = 0; 
			a_gz1 = 0;
			/*have to give these some time to make the system happy!*/
			pw_gz1a = 12; 
			pw_gz1 = 12;
			pw_gz1d = 12;
		
	    }
            
	} else {
            a_gz1 = 0.0;
            pw_gz1a = 0;
            pw_gz1 = 0;
            pw_gz1d = 0;
            if (amppwlcrsh(&gradz[GZRF2L1_SLOT], &gradz[GZRF2R1_SLOT],
                           area_gz1, a_gzrf2, loggrd.tz_xyz, MIN_PLATEAU_TIME,
                           loggrd.zrt, &pw_gzrf2a) == FAILURE) {
                epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                           EE_ARGS(1), STRING_ARG, "amppwlcrush");
                return FAILURE;
	    }
	}
    }  /* 	if (zgmn_type == CALC_GMN1) */

    pw_gz1_tot = pw_gz1a + pw_gz1 + pw_gz1d + pw_gzmna + pw_gzmn + pw_gzmnd;
    
    if (ssEval2() != SUCCESS) return FAILURE;
    
    pw_gzrf2a = pw_gzrf2l1d;
    pw_gzrf2d = pw_gzrf2r1a;
    pw_gzrf2l1_tot = pw_gzrf2l1a + pw_gzrf2l1 + pw_gzrf2l1d;
    pw_gzrf2r1_tot = pw_gzrf2r1a + pw_gzrf2r1 + pw_gzrf2r1d;
    
    /***** End of sequences (eos) killer pulses *******************************/
    
    if (eoskillers == PSD_ON) {

        target_area = a_gxw*(float)(pw_gxwad + pw_gxw/2);

        if (eosxkiller == PSD_ON) {   /* X killer pulse */
            if (amppwgradmethod(&gradx[GXK_SLOT], target_area, loggrd.tx_xyz,
                                start_amp, end_amp,
                                loggrd.xrt, MIN_PLATEAU_TIME)==FAILURE) {
                epic_error(use_ermes, supfailfmt, EM_PSD_SUPPORT_FAILURE,
                           EE_ARGS(1), STRING_ARG, "amppwgradmethod:gxk");
                return FAILURE;
            }
        }

        if (eosykiller == PSD_ON) {   /* Y killer pulse */
            if (amppwgradmethod(&grady[GYK_SLOT], target_area, loggrd.ty_xyz,
                                start_amp, end_amp,
                                loggrd.yrt, MIN_PLATEAU_TIME)==FAILURE) {
                epic_error(use_ermes, supfailfmt, EM_PSD_SUPPORT_FAILURE,
                           EE_ARGS(1), STRING_ARG, "amppwgradmethod:gyk");
                return FAILURE;
            }
        }
        if (eoszkiller == PSD_ON) {   /* Z killer pulse */
            if (amppwgradmethod(&gradz[GZK_SLOT], target_area, loggrd.tz_xyz,
                                start_amp, end_amp,
                                loggrd.zrt, MIN_PLATEAU_TIME)==FAILURE) {
                epic_error(use_ermes, supfailfmt, EM_PSD_SUPPORT_FAILURE,
                           EE_ARGS(1), STRING_ARG, "amppwgradmethod:gzk");
                return FAILURE;
            }
        }

        gxktime = pw_gxk + pw_gxka + pw_gxkd;
        gyktime = pw_gyk + pw_gyka + pw_gykd;
        gzktime = pw_gzk + pw_gzka + pw_gzkd;

    } else {

        gxktime = 0;
        gyktime = 0;
        gzktime = 0;

    }
	  
    gktime  = IMax(3,gxktime, gyktime, gzktime);

    /**** End of killer pulse calcs */
   
    
    /***** Cardiac and advisory panel control *********************************/
    
    if (ChemSatEval(&cs_sattime) == FAILURE) {
        epic_error(use_ermes, "%s failed", EM_PSD_ROUTINE_FAILURE,
                   EE_ARGS(1), STRING_ARG, "ChemSat Eval");
        return FAILURE;
    }
    
    if (SpSatEval(&sp_sattime) == FAILURE) {
        epic_error(use_ermes, "%s failed", EM_PSD_ROUTINE_FAILURE,
                   EE_ARGS(1), STRING_ARG, "Spatial Sat Eval");
        return FAILURE;
    }

    /* The sat time is not calculated correctly in SpSat.e */
    /* Adding 200 us will compensate for the incorrect sat time */
    /* for the time being... */
    if( sp_sattime > 0) {
        sp_sattime =  sp_sattime + 200us;
    }

    /*
     * Set the gradient calc mode here for selecting the right gradsafety
     * calc technique.
     * NOTE: The gradHeatMethod CV is used in minseq() to decide whether to call
     *       minseqseg() (gradHeatMethod = TRUE -> Linear Segment Method) or
     *       minseqgrad() (gradHeatMethod = FALSE -> Traditional Method).
     */
    gradHeatMethod = PSD_ON;
    
    /* YMSmr07133 */
    if( value_system_flag == VALUE_SYSTEM_HDE ){ 
        gradDriverMethod = PSD_ON;
    }
    
    if( exist(opnshots) == 1 && (mph_flag && (opfphases > 10) && (opacqo == PSD_OFF)) &&
        _iref_etl.fixedflag == PSD_OFF && iref_etl == 0){
        if(get_cvs_changed_flag() == TRUE)
        {
            iref_etl = DEFAULT_IREF_ETL;
            if(dbdt_model == DBDTMODELCONV && (cfdbdtts == 0.0 && cfdbdtper > 0.0) && dbdtper_new > cfdbdtper)
                no_gy1_ol_gxw = 1;
            saved_tmin_total = 0;

            if (cveval1() == FAILURE) {        
                /* don't send ermes so that underlying ermes will be displayed */
                return FAILURE;
            }

            iref_etl = 0;
            no_gy1_ol_gxw = 0;
            saved_tmin_total = tmin_total;
        }
    }
    else
    {
        saved_tmin_total = 0;
    }
    if (cveval1() == FAILURE) {        
        /* don't send ermes so that underlying ermes will be displayed */
        return FAILURE;
    }

    /* MRIge75651*/
    if( peakAveSars( &ave_sar, &cave_sar, &peak_sar, &b1rms, (int)RF_FREE,
                     rfpulse, L_SCAN, (int)(act_tr/slquant1) )  == FAILURE )
    {
        epic_error(use_ermes, "%s failed", EM_PSD_ROUTINE_FAILURE,
                   EE_ARGS(1), STRING_ARG, "peakAveSars");
        return FAILURE;
    }

    piasar = (float)ave_sar; /* Report to plasma */
    picasar = (float)cave_sar; /* Coil SAR to plasma */
    pipsar = (float)peak_sar; /* Report to plasma */
    pib1rms = (float)b1rms; /* Report predicted b1rms value on the UI */

    /* Set fecho_factor based on value for fract_ky */
    if (fract_ky == PSD_FRACT_KY) {
        /* jwg this has been changed in ESE24*/
	/*fecho_factor =((float)rhdayres/2 + num_overscan)/rhdayres;*/
	fecho_factor = (float)(rhnframes + rhhnover)/fullk_nframes;
    } else {
        fecho_factor = 1.0;
    }
    
    /* SNR monitor */
    _pifractecho.fixedflag = 0;
    pifractecho = fecho_factor;
    setexist(pifractecho,_opte.existflag);
    _pifractecho.fixedflag = _opte.fixedflag;
    
    /* MRIge56926 - Calculation of avminslthick - TAA */
    ampslice(&av_temp_float, bw_rf1, loggrd.tz, gscale_rf1,TYPDEF);
    av_temp_float = ceil(av_temp_float*10.0)/10.0;
    avminslthick = av_temp_float;
    
    ampslice(&av_temp_float, bw_rf2, loggrd.tz, gscale_rf2,TYPDEF);
    av_temp_float = ceil(av_temp_float*10.0)/10.0;
    
    /*jwg bb only concerned w/ this calc if using standard spsp pulses (ie opuser20 = 0) */
    if (opuser20 < 2) 
    {
	avminslthick = FMax(3,avminslthick,av_temp_float, ss_rf1*ss_min_slthk);
    }
    
    /* MRIge56898 - To perform calculation of avminnshots outside of error
       conditions  - TAA */
    if (existcv(opnex) != PSD_OFF) {
        avmaxnshots = exist(opyres);
    }
        
    /*MRIge61054 - BSA*/
    if (nshots_locks == PSD_ON) {

        if ( (cfsrmode==PSD_SR20) || (cfsrmode==PSD_SR25) ) {

            min_nshots = 8;
            pishotnub = 49;

        } else { if ( cfsrmode <= PSD_SR77 ) { 

            if (exist(opxres) <= 256){
                min_nshots = 1;
                pishotnub = 63;
                    
            } else {
                    
                min_nshots = 4;
                pishotnub = 57;
                    
            } 

        } else if ( (cfsrmode==PSD_SR100) || (cfsrmode==PSD_SR120) || (cfsrmode==PSD_SR150) || (cfsrmode==PSD_SR200) )  {

            if (exist(opxres)==512) {
                min_nshots = 2;
                pishotnub = 61;
            } else {
                min_nshots = 1;
            }

        } else {
            min_nshots = 1;
        }   
        }

    } /* nshots_locks */
    
    avminnshots = min_nshots;
    
    if (existcv(opnshots)== PSD_OFF && exist(opnshots) < avminnshots) 
        cvdef(opnshots, avminnshots); 

#if defined(RT) && defined(LIM_PROTOCOLS)
    if (lim_protocol() == FAILURE) {
        /* don't send ermes so that underlying ermes will be displayed */
        return FAILURE;
    }
#else
    if( (mph_flag == PSD_ON) && ((opfphases * opslquant) > 2048) )
    {
        if(mph_protocol() == FAILURE) {
            /* don't send ermes so that underlying ermes will be displayed */
            return FAILURE;
        }
    } 
#endif

    if( (PSD_OFF == pircbnub) && (PSD_OFF == exist(opautorbw)) )
    {
        opautorbw = PSD_ON;
    }

    /* MRIhc48581 -- 3dgradwarp UI */
    /* disable 3D gradwarp for sequential MPh mode */ 
    if( (PSD_OFF == opdynaplan) && (PSD_ON == mph_flag) && (opacqo == 1) )
    {
        pi3dgradwarpnub = 0;
    }
    else
    {
        pi3dgradwarpnub = _pi3dgradwarpnub.defval;;
    }

    /* ZZ, activate ASPIR through SPECIAL fat sat option */
    if( PSD_ON == exist(optouch) ) {
        pichemsatopt = 2;
    }
    else {
        pichemsatopt = 0;
    }

    if( PSD_ON == exist(opspecir)) {
        /* Activate advisory panel checks for TI */
        piadvmin = (piadvmin | (1<<PSD_ADVTI));
        piadvmax = (piadvmax | (1<<PSD_ADVTI));

        /* Set TI annotation */
        pititype = PSD_LABEL_TE_PREP;
        /* Only show Auto TI */
        pitinub = 2;
	piautoti = PSD_ON;

        if(cffield == B0_15000)
        {
            avmaxti = ASPIR_DWI_MAX_15T_TI;
            cvmax(opti,ASPIR_DWI_MAX_15T_TI);
            avminti = IMax(2, ASPIR_DWI_MIN_15T_TI, aspir_minti);
            cvmin(opti,avminti);
            cvdef(opti, ASPIR_DWI_15T_TI);
            pitidefval = ASPIR_DWI_15T_TI;
	    pitival2 = ASPIR_DWI_15T_TI;
            if(existcv(opautoti) && exist(opautoti))
            {
                cvoverride(opti, ASPIR_DWI_15T_TI, PSD_FIX_OFF, PSD_EXIST_ON);
            }
        }
        else if (cffield == B0_30000)
        {
            avmaxti = ASPIR_DWI_MAX_3T_TI;
            cvmax(opti,ASPIR_DWI_MAX_3T_TI);
            avminti = IMax(2, ASPIR_DWI_MIN_3T_TI, aspir_minti);
            cvmin(opti,avminti);
            cvdef(opti, ASPIR_DWI_3T_TI);
            pitidefval = ASPIR_DWI_3T_TI;
	    pitival2 = ASPIR_DWI_3T_TI;
            if(existcv(opautoti) && exist(opautoti))
            {
                cvoverride(opti, ASPIR_DWI_3T_TI, PSD_FIX_OFF, PSD_EXIST_ON);
            }
        }
    }
    else {
        /* turn off TI field */
        pitinub=0;
	piautoti = PSD_OFF;
        cvoverride(opautoti, PSD_OFF, PSD_FIX_OFF, PSD_EXIST_OFF);
    }
fprintf(stderr,"At bottom of cveval, pw_gyb and a_gyb are %d and %f \n\n\n\n",pw_gyb,a_gyb);    
    return SUCCESS;

} /* End of cveval */


/* optimize gradient and esp based on rectangular dbdt model */
STATUS optGradAndEsp_rect(void)
{
    int readout_phyaxis;

    if(isGradAndEspReoptNeeded() == PSD_OFF) return SUCCESS;

    pw_gxgap = 0;
    dbdtper_new = cfdbdtper;
    if(epigradopt_rect(dbdtper_new, 0) == FAILURE) return FAILURE;
    if(epigradopt_debug) printEpigradoptLog();

    if(!esprange_check) return SUCCESS;
   
    readout_phyaxis = getReadoutPhyAxis();    
    if(isEspOutOfUnwantedRange(esp, readout_phyaxis) == PSD_OFF)
    {
        if(searchEspLonger_rect(esp, readout_phyaxis) == FAILURE) return FAILURE;
        if(epigradopt_debug) printEpigradoptLog();
    } 
    return SUCCESS;
}


/* optimize gradient and esp based on convolution dbdt model */
STATUS optGradAndEsp_conv(void)
{
    int dbdtper_inc;

    int esp_value[DBDT_MAXNUMSTEPS];
    int dbdtper_value[DBDT_MAXNUMSTEPS];
    int prev_esp;
    int esp_notchanged;

    int hit_esp_index;
    int i;
    int readout_phyaxis;

    int esp_first;



    if(isGradAndEspReoptNeeded() == PSD_OFF) return SUCCESS;
    
    pw_gxgap = 0;
    readout_phyaxis = getReadoutPhyAxis();
    if((!espopt) && (!esprange_check))
    {
        dbdtper_new = cfdbdtper;
        if(epigradopt_rect(dbdtper_new, 0) == FAILURE) return FAILURE;
        pidbdtper = calcdbdtper_conv();
        if(epigradopt_debug) printEpigradoptLog();
        return SUCCESS;
    }

    /* Search for shortest esp with pidbdtper smaller than cfdbdtper */
    dbdtper_count = 0;
    dbdtper_inc = DBDT_STEPSIZE;
    dbdtper_new = cfdbdtper;
    esp_notchanged = 0;
    prev_esp = -1;
    esp_first = -1;
    do
    {
        if(epigradopt_rect(dbdtper_new, 0) == FAILURE) return FAILURE;
        if(esp_first == -1) esp_first = esp;
        pidbdtper = calcdbdtper_conv();
        if(epigradopt_debug) printEpigradoptLog();

        if(pidbdtper > cfdbdtper) break; /* break when pidbdtper reaches cfdbdtper */
        esp_value[dbdtper_count] = esp;
        dbdtper_value[dbdtper_count] = dbdtper_new;
        dbdtper_count++;
        if(dbdtper_count >= DBDT_MAXNUMSTEPS) break; /* break if too many steps */

        if(esp == prev_esp) 
        {
            esp_notchanged++;
            if(esp_notchanged >= 3) break; /* break if esp not changed in 3 continous steps */
        }
        else
        {
            prev_esp = esp;
            esp_notchanged = 0;
        }
        
        if(!espopt) 
        {
            if(isEspOutOfUnwantedRange(esp, readout_phyaxis) == PSD_ON) 
            {
                return SUCCESS;
            }
        }

        dbdtper_new += dbdtper_inc;

    } while(1);
    
    if(!espopt) /* increase esp until out of unwanted range */
    {
        if(searchEspLonger_rect(esp_first, readout_phyaxis) == FAILURE) return FAILURE;
        pidbdtper = calcdbdtper_conv(); 
        if(epigradopt_debug) printEpigradoptLog();
        return SUCCESS;
    }

    if(!esprange_check) /* no need to check esp range */
    {
        if(pidbdtper > cfdbdtper) /* one step back */
        {
            dbdtper_new -= dbdtper_inc;
            if(epigradopt_rect(dbdtper_new, 0) == FAILURE) return FAILURE;
            pidbdtper = calcdbdtper_conv();
            if(epigradopt_debug) printEpigradoptLog();
        }
        return SUCCESS;
    }

    /* search for shortest esp out of unwanted range */
    hit_esp_index = -1;
    for(i=dbdtper_count-1; i>=0; i--)
    {
        if(isEspOutOfUnwantedRange(esp_value[i], readout_phyaxis) == PSD_ON)
        {
            hit_esp_index = i;
            break;
        }
    }
    if(hit_esp_index < 0) /* search esp in terms of out of unwanted range */
    {
        if(searchEspLonger_rect(esp_first, readout_phyaxis) == FAILURE) return FAILURE;
        pidbdtper = calcdbdtper_conv();
        if(epigradopt_debug) printEpigradoptLog();
    }
    else
    {
        dbdtper_new = dbdtper_value[hit_esp_index];
        if(epigradopt_rect(dbdtper_new, 0) == FAILURE) return FAILURE;
        pidbdtper = calcdbdtper_conv();
        if(epigradopt_debug) printEpigradoptLog();
    }
    
    return SUCCESS;
}

/* get esp out of unwanted range */
/* if get esp longer than esp_start, longer_shorter = 1;
   else longer_shorter = -1 */
int getEspOutOfUnwantedRange(int esp_start, int longer_shorter, int readout_phyaxis) 
{
    if(longer_shorter < 0) longer_shorter = -1;
    else longer_shorter = 1;

    while(isEspOutOfUnwantedRange(esp_start, readout_phyaxis) == PSD_OFF)
    {
        esp_start += GRAD_UPDATE_TIME*longer_shorter;   
    }

    return esp_start;
}

/* search esp out of unwanted range by increasing esp */
STATUS searchEspLonger_rect(int esp_start, int readout_phyaxis)
{

    if(espincway == 0)
    {
        int dbdtper_inc;
        dbdtper_new = cfdbdtper;
        dbdtper_inc = DBDT_STEPSIZE;
        do /* search for optimal esp in terms of shortest out of the unwanted range */
        {
            dbdtper_new -= dbdtper_inc;
            if(dbdtper_new <= 0)
            {
                epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                           EE_ARGS(1), STRING_ARG, "optGradAndEsp");
                return FAILURE;
            }
            epigradopt_rect(dbdtper_new, 0);
            if(epigradopt_debug) printEpigradoptLog();
        } while(isEspOutOfUnwantedRange(esp, readout_phyaxis) == PSD_OFF);
    }
    else
    {
        int esp_new;
        dbdtper_new = cfdbdtper;

        epigradopt_rect(dbdtper_new, 0);
        if(epigradopt_debug) printEpigradoptLog();
        esp_new =  getEspOutOfUnwantedRange(esp, 1, readout_phyaxis); 
        pw_gxgap = pw_gxgap + (esp_new - esp);
        if ((pw_gxgap - (pw_gxgap/pwmin_gap)*pwmin_gap) != 0.0)
            pw_gxgap = (int)ceil((double)pw_gxgap / (double)pwmin_gap) * pwmin_gap;
        if( FAILURE == setEpiEsp() ) 
        {
            epic_error(use_ermes, "setEpiEsp_failed", EM_PSD_SUPPORT_FAILURE,1,
                   STRING_ARG, "setEpiEsp()");
            return FAILURE;
        } 
    }

    return SUCCESS;
}


/* Get physical axis of readout gradient */
int getReadoutPhyAxis(void)
{
    int readout_phyaxis, i; 
    readout_phyaxis = 0;
    for(i=0; i<exist(opslquant); i++)
    {
        if(rsprot[i][0] != 0) readout_phyaxis |= XAXIS;
        if(rsprot[i][3] != 0) readout_phyaxis |= YAXIS;
        if(rsprot[i][6] != 0) readout_phyaxis |= ZAXIS;
    }
    return readout_phyaxis;
}

/* check if esp is out of unwanted range or not */                        
int isEspOutOfUnwantedRange(int esp_v, int readout_phyaxis)
{
    int i;

    if(readout_phyaxis & XAXIS)
    {
        for(i=0; i<numesprange_x; i++)
        {
            if(esp_v >= esprange_x[i][0] && esp_v <= esprange_x[i][1]) return PSD_OFF;
        }
    }
    if(readout_phyaxis & YAXIS)
    {
        for(i=0; i<numesprange_y; i++)
        {
            if(esp_v >= esprange_y[i][0] && esp_v <= esprange_y[i][1]) return PSD_OFF;
        }
    }
    if(readout_phyaxis & ZAXIS)
    {
        for(i=0; i<numesprange_z; i++)
        {
            if(esp_v >= esprange_z[i][0] && esp_v <= esprange_z[i][1]) return PSD_OFF;
        }
    }

    return PSD_ON;
}

/* generate epi readout gradient waveform and set esp */
STATUS epigradopt_rect(float cfdbdtper_new, int reqesp_new)
{
    epigradopt( &gradin, &gradout, &pidbdtts, &pidbdtper, cfdbdtts, cfdbdtper_new,
           cfdbdtdx, cfdbdtdy, reqesp_new, autogap, (int)vrgfsamp,
           (int)vrgfsamp, (int)debug );
    
    rhfrsize = temprhfrsize;
    /* SXZ::MRIge72411: calc actual ratio */
    if(vrgfsamp == PSD_ON && rampopt == 1){
        int tempvar;
        /* ramp area */
        tempvar = ((float)a_gxw*pw_gxwad-a_gxw*(pw_gyba+pw_gyb/2)*(pw_gyba+pw_gyb/2)/pw_gxwad);
        /* top area */
        tempvar = totarea - tempvar;
        actratio = tempvar/totarea;
    } else {
        actratio = 1;
    }
    
    /* MGD: call calcfilter() */
    /* MRIge66608: need rhfrsize input pts and no exist(oprbw) for VRGF */
    if( FAILURE == (calcfilter(&echo1_filt, oprbw, rhfrsize, OVERWRITE_OPRBW)) ) {
        epic_error(use_ermes, "calfilter_failed", EM_PSD_SUPPORT_FAILURE,1, 
                   STRING_ARG, "calcfilter");
        return FAILURE;
    } 
    
    getminesp(echo1_filt, xtr_offset, intleaves, hrdwr_period, vrgfsamp, &minesp);
    
    /* There is a bug in epigradopt for non-vrg.  Bump up pw_gxwad */
    pw_gxwad = RUP_GRD(pw_gxwad);
    
    /* Also, epigradopt does not make pw_gxgap a mult. of 2*GRAD_UPDATE_TIME,
       so do it here (MRIge23911) */
    if ((pw_gxgap - (pw_gxgap/pwmin_gap)*pwmin_gap) != 0.0)
        pw_gxgap = (int)ceil((double)pw_gxgap / (double)pwmin_gap) * pwmin_gap;
    
    /* need to set the decay of the blip to = the attack found in epgradopt() */
    pw_gybd = pw_gyba;
    
    /* Call to calculate the echo-sapcing (esp) */
    if( FAILURE == setEpiEsp() ) {
        epic_error(use_ermes, "setEpiEsp_failed", EM_PSD_SUPPORT_FAILURE,1, 
                   STRING_ARG, "setEpiEsp()");
        return FAILURE;
    } 
    return SUCCESS;
}
    
/* check if EPI readout gradient waveforms need to be regenerated  */
int isGradAndEspReoptNeeded(void)    
{
    if((reopt_flag == PSD_ON) ||
       memcmp(&gradin, &gradin_old, sizeof(OPT_GRAD_INPUT)) || memcmp(rsprot[0], rsprot_old, 9*sizeof(long)) ||
       (cfdbdtper != cfdbdtper_old) || (dbdt_model != dbdt_model_old) ||
       (esprange_check != esprange_check_old) || (mph_flag != opmph_old) ||
       (rampopt != rampopt_old) || (espopt != espopt_old) || (espincway != espincway_old))
    {
        reopt_flag = PSD_OFF;
        memcpy(&gradin_old, &gradin, sizeof(OPT_GRAD_INPUT));
        memcpy(rsprot_old, rsprot[0], 9*sizeof(long));
        cfdbdtper_old = cfdbdtper;
        dbdt_model_old = dbdt_model;
        esprange_check_old = esprange_check;
        opmph_old = mph_flag;
        rampopt_old = rampopt;
        espopt_old = espopt;
        espincway_old = espincway;
        epigradopt_debug_old = epigradopt_debug;
        return PSD_ON;
    }
    if(epigradopt_debug && epigradopt_debug != epigradopt_debug_old)
    {
        epigradopt_debug_old = epigradopt_debug;
        return PSD_ON;
    }
    epigradopt_debug_old = epigradopt_debug;

    return PSD_OFF;
}

/* calculate dbdtper of EPI readout gradient waveforms using convolution dbdt model */
float calcdbdtper_conv(void)
{
/*
    The epi readout gradient waveforms could be considered three parts:
       1. The first ramp. There is no epi blip here. 3 corner points for this part. 
       2. Parity switching period. There is epi bilp within this period. This period is repeated, and 10 
          corner points needed for each repetation.
       3. The last ramp: There is no epi blip here. 3 corner points for this part.
*/

    int i, j;
    float max_dbdtper;

    int tcon1[3], tcon2[10], tcon3[3];
    float aconx1[3], aconx2[10], aconx3[3];
    float acony1[3], acony2[10], acony3[3];

    /* generate corner points */
    tcon1[0]=0; tcon1[1]=pw_gxwad; tcon1[2]=pw_gxwl;
    aconx1[0]=0; aconx1[1]=a_gxw; aconx1[2]=a_gxw;
    acony1[0]=0; acony1[1]=0; acony1[2]=0;

    tcon3[0]=pw_gxw; tcon3[1]=pw_gxwr; tcon3[2]=pw_gxwad;
    aconx3[0]=a_gxw; aconx3[1]=a_gxw; aconx3[2]=0;
    acony3[0]=0; acony3[1]=0; acony3[2]=0;
     
    tcon2[0]=pw_gxw; aconx2[0]=a_gxw;  acony2[0]=0;
    if(pw_gyba+pw_gyb/2 > pw_gxwad+pw_gxgap/2) 
    {
        tcon2[1]=pw_gxwr+(pw_gxwad+pw_gxgap/2)-(pw_gyba+pw_gyb/2); aconx2[1]=a_gxw;  acony2[1]=0; 
        if(pw_gyb/2 > pw_gxwad+pw_gxgap/2)
        {
            tcon2[2]=pw_gyba; aconx2[2]=a_gxw;  acony2[2]=a_gyb; 
            tcon2[3]=(pw_gyb/2)-(pw_gxwad+pw_gxgap/2); aconx2[3]=a_gxw; acony2[3]=a_gyb;
            tcon2[4]=pw_gxwad; aconx2[4]=0; acony2[4]=a_gyb;
        }
        else
        {
            tcon2[2]=(pw_gyba+pw_gyb/2)-(pw_gxwad+pw_gxgap/2); aconx2[2]=a_gxw;  acony2[2]=0; 
            if(pw_gyb/2 > pw_gxgap/2)
            {
                tcon2[3]=(pw_gxwad+pw_gxgap/2)-(pw_gyb/2); 
                aconx2[3]=intercept(a_gxw, 0, pw_gxwad,tcon2[3]); 
                acony2[3]=a_gyb;
                tcon2[4]=pw_gxwr+pw_gxwad; aconx2[4]=0; acony2[4]=a_gyb;
            }
            else
            {
                tcon2[3]=pw_gxwad; 
                aconx2[3]=0; 
                acony2[3]=intercept(0, a_gyb, pw_gyba,tcon2[2]+tcon2[3]);
                tcon2[4]=(pw_gxgap/2)-(pw_gyb/2); aconx2[4]=0; acony2[4]=a_gyb;
            }
              
        }
    }
    else
    {
        tcon2[1]=pw_gxwr; aconx2[1]=a_gxw;  acony2[1]=0; 
        if(pw_gyba+pw_gyb/2 > pw_gxgap/2)
        {
            tcon2[2]=(pw_gxwad+pw_gxgap/2)-(pw_gyba+pw_gyb/2); 
            aconx2[2]=intercept(a_gxw, 0, pw_gxwad, tcon2[2]);  
            acony2[2]=0; 
            if(pw_gyb/2 > pw_gxgap/2)
            {
                tcon2[3]=pw_gyba; 
                aconx2[3]=intercept(a_gxw, 0, pw_gxwad,pw_gxwad+pw_gxgap/2-pw_gyb/2); 
                acony2[3]=a_gyb;
                tcon2[4]=pw_gyb/2-pw_gxgap/2; aconx2[4]=0; acony2[4]=a_gyb;
            }
            else
            {
                tcon2[3]=(pw_gyba+pw_gyb/2)-(pw_gxgap/2); 
                aconx2[3]=0; 
                acony2[3]=intercept(0, a_gyb, pw_gyba, tcon2[3]);
                tcon2[4]=pw_gxgap/2-pw_gyb/2; aconx2[4]=0; acony2[4]=a_gyb;
            }
        }
        else
        {
            tcon2[2]=pw_gxwad; aconx2[2]=0;  acony2[2]=0; 
            tcon2[3]=(pw_gxgap/2)-(pw_gyba+pw_gyb/2); aconx2[3]=0; acony2[3]=0;
            tcon2[4]=pw_gyba; aconx2[4]=0; acony2[4]=a_gyb;
        }
           
    }

    tcon2[5]=2*((pw_gxwr+pw_gxwad+pw_gxgap/2)-tcon2[1]-tcon2[2]-tcon2[3]-tcon2[4]);
    for(i=6;i<10;i++)
    {
        tcon2[i]=tcon2[10-i];
    }
    for(i=5;i<10;i++)
    {
        aconx2[i]=-aconx2[9-i];
        acony2[i]=acony2[9-i];
    }


    /* calculate dbdtper with convolution dbdt model*/
    {
        int etl_1, num_cornerpoints;
        int * tcon;
        float * aconx, * acony;
        float * dbdtper_x_data, * dbdtper_y_data, * dbdtper_data;

        float us2s = 1.0e-6;
        float gcm2Tm = 1.0e-2;
        float cm2m = 1.0e-2;

        int sign = 1;
        float dbdtdxyz;

        etl_1 = DBDT_ETL;
        num_cornerpoints = 3+10*(etl_1-1)+3;

	tcon = (int *)malloc(num_cornerpoints*sizeof(int));
        aconx = (float *)malloc(num_cornerpoints*sizeof(float));
        acony = (float *)malloc(num_cornerpoints*sizeof(float));
        dbdtper_x_data = (float *)malloc(num_cornerpoints*sizeof(float));
        dbdtper_y_data = (float *)malloc(num_cornerpoints*sizeof(float));
        dbdtper_data = (float *)malloc(num_cornerpoints*sizeof(float));

        tcon[0]=0;
        aconx[0]=0;
        acony[0]=0;
        for(i=1; i<num_cornerpoints; i++)
        {
            if(i<3)
            {
                tcon[i] = tcon[i-1]+tcon1[i];
                aconx[i] = aconx1[i];
                acony[i] = acony1[i];
            }
            else if(i>=num_cornerpoints-3) 
            {
                tcon[i] = tcon[i-1]+tcon3[i-(num_cornerpoints-3)];
                aconx[i] = aconx3[i-(num_cornerpoints-3)]*sign;
                acony[i] = acony3[i-(num_cornerpoints-3)];
            }
            else 
            {
                tcon[i] = tcon[i-1]+tcon2[(i-3)%10];
                aconx[i] = aconx2[(i-3)%10]*sign;
                acony[i] = acony2[(i-3)%10];
                if(((i-3)%10)==9) sign *= -1;
            }
        }

        if(epigradopt_debug) printCornerPoint(num_cornerpoints, tcon, aconx, acony);

        dbdtdxyz = FMax(3, cfdbdtdx, cfdbdtdy, cfdbdtdz);
        for(i=0;i<num_cornerpoints; i++)
        {
            aconx[i] *= dbdtdxyz*cm2m*gcm2Tm;
            acony[i] *= dbdtdxyz*cm2m*gcm2Tm;
        }
        
        max_dbdtper=0.0;
        dbdtper_x_data[0] = dbdtper_y_data[0] = dbdtper_data[0] = 0.0;
        for(i=1; i<num_cornerpoints; i++)
        {
            float the_dbdtper_x=0.0;
            float the_dbdtper_y=0.0;
            float the_dbdtper;
        
            for(j=0;j<i;j++)
            {
                float dbdt_x, dbdt_y;
                if(tcon[j+1]==tcon[j]) continue;

                dbdt_x=(aconx[j+1]-aconx[j])/(tcon[j+1]-tcon[j])/us2s;
                dbdt_y=(acony[j+1]-acony[j])/(tcon[j+1]-tcon[j])/us2s;
                the_dbdtper_x=the_dbdtper_x+dbdt_x*cfrfact/cfrinf*
                              (1.0/(cfrfact+tcon[i]-tcon[j+1]) - 1.0/(cfrfact+tcon[i]-tcon[j]));
                the_dbdtper_y=the_dbdtper_y+dbdt_y*cfrfact/cfrinf*
                              (1.0/(cfrfact+tcon[i]-tcon[j+1]) - 1.0/(cfrfact+tcon[i]-tcon[j]));
            }
            the_dbdtper = sqrt(the_dbdtper_x*the_dbdtper_x+the_dbdtper_y*the_dbdtper_y);
            if(the_dbdtper>max_dbdtper) max_dbdtper=the_dbdtper;

            dbdtper_x_data[i] = the_dbdtper_x;
            dbdtper_y_data[i] = the_dbdtper_y;
            dbdtper_data[i] = the_dbdtper;
        }

        if(epigradopt_debug) printDbdtper(max_dbdtper*100.0, num_cornerpoints, tcon, dbdtper_x_data, dbdtper_y_data, dbdtper_data);

        free(tcon);
        free(aconx);
        free(acony);
        free(dbdtper_x_data);
        free(dbdtper_y_data);
        free(dbdtper_data);
    }

    /* return the minimum dbdtper value of rect and conv models */
    return (pidbdtper > 0.0 ? FMin(2, pidbdtper, max_dbdtper*100.0) : max_dbdtper*100.0);
}

float intercept(float y1, float y2, int xl, int x)
{
    return (y2-y1)/xl*x+y1;
}

/* read unwanted ESP range from a host file epiesp.dat
   File format:
   1  <--- number of ranges of X axisi, could be 0-5
   420 460   <--- first range of X axis
   1  <--- number of ranges of Y axis, could be 0-5
   420 460   <--- first range of Y axis
   1  <--- number of ranges of Z axis, could be 0-5
   360 400   <--- first range of Z axis

   comments could be inserted with # as the first character of the line
*/
void readEspRange(void)
{
    FILE * fp;
    char tempstring[MAXCHAR];
    int i;

    if(epigradopt_debug && no_esprangefile == 1) printEspRange();
    if(no_esprangefile == 1) return;
#ifndef SIM
    if(PSD_XRMW_COIL == cfgcoiltype)
    {
        if((fp=fopen("/usr/g/bin/epiespW.dat", "rt")) == NULL) {procNoEspRangeFile(fp); return;}
    }
    else
    {
        if((fp=fopen("/usr/g/bin/epiesp.dat", "rt")) == NULL) {procNoEspRangeFile(fp); return;}
    }
#else
    if(PSD_XRMW_COIL == cfgcoiltype)
    {
        if((fp=fopen("epiespW.dat", "rt")) == NULL) {procNoEspRangeFile(fp); return;}
    }
    else
    {
        if((fp=fopen("epiesp.dat", "rt")) == NULL) {procNoEspRangeFile(fp); return;}
    }
#endif
    /* reading esp range on X axis */
    do
    {
        if(fgets( tempstring, MAXCHAR, fp ) == NULL) {procNoEspRangeFile(fp); return;}
    } while(isCommentOrBlankLine(tempstring));
    if(sscanf(tempstring, "%d", &numesprange_x) != 1) {procNoEspRangeFile(fp); return;}
    if(numesprange_x < 0 || numesprange_x > MAXNUMESPRANGE) {procNoEspRangeFile(fp); return;}
    for(i=0; i<numesprange_x; i++)
    {
        do
        {
            if(fgets( tempstring, MAXCHAR, fp ) == NULL) {procNoEspRangeFile(fp); return;}
        } while(isCommentOrBlankLine(tempstring));
        if(sscanf(tempstring, "%d %d", &esprange_x[i][0], &esprange_x[i][1]) != 2) {procNoEspRangeFile(fp); return;}
        if(esprange_x[i][0] <= 0 || esprange_x[i][1] <= 0) {procNoEspRangeFile(fp); return;}
        if(esprange_x[i][1] < esprange_x[i][0]) {procNoEspRangeFile(fp); return;}
    }

    /* reading esp range on Y axis */
    do
    {
        if(fgets( tempstring, MAXCHAR, fp ) == NULL) {procNoEspRangeFile(fp); return;}
    } while(isCommentOrBlankLine(tempstring));
    if(sscanf(tempstring, "%d", &numesprange_y) != 1) {procNoEspRangeFile(fp); return;}
    if(numesprange_y < 0 || numesprange_y > MAXNUMESPRANGE) {procNoEspRangeFile(fp); return;}
    for(i=0; i<numesprange_y; i++)
    {
        do
        {
            if(fgets( tempstring, MAXCHAR, fp ) == NULL) {procNoEspRangeFile(fp); return;}
        } while(isCommentOrBlankLine(tempstring));
        if(sscanf(tempstring, "%d %d", &esprange_y[i][0], &esprange_y[i][1]) != 2) {procNoEspRangeFile(fp); return;}
        if(esprange_y[i][0] <= 0 || esprange_y[i][1] <= 0) {procNoEspRangeFile(fp); return;}
        if(esprange_y[i][1] < esprange_y[i][0]) {procNoEspRangeFile(fp); return;}
    }

    /* reading esp range on Z axis */
    do
    {
        if(fgets( tempstring, MAXCHAR, fp ) == NULL) {procNoEspRangeFile(fp); return;}
    } while(isCommentOrBlankLine(tempstring));
    if(sscanf(tempstring, "%d", &numesprange_z) != 1) {procNoEspRangeFile(fp); return;}
    if(numesprange_z < 0 || numesprange_z > MAXNUMESPRANGE) {procNoEspRangeFile(fp); return;}
    for(i=0; i<numesprange_z; i++)
    {
        do
        {
            if(fgets( tempstring, MAXCHAR, fp ) == NULL) {procNoEspRangeFile(fp); return;}
        } while(isCommentOrBlankLine(tempstring));
        if(sscanf(tempstring, "%d %d", &esprange_z[i][0], &esprange_z[i][1]) != 2) {procNoEspRangeFile(fp); return;}
        if(esprange_z[i][0] <= 0 || esprange_z[i][1] <= 0) {procNoEspRangeFile(fp); return;}
        if(esprange_z[i][1] < esprange_z[i][0]) {procNoEspRangeFile(fp); return;}
    }
    no_esprangefile = 1;
    fclose(fp);
}

int isCommentOrBlankLine(char * str)
{
    int i;
    
    i = -1;
    while(isspace(str[++i]));
    if((i == strlen(str)) || (str[i] == '#')) return 1;
    return 0;
} 

void procNoEspRangeFile(FILE * fp)
{
    if(fp != NULL) fclose(fp);
#ifndef SIM
    epic_warning( "epiesp.dat was corrupted or not found. Using default values.");
#endif
    numesprange_x = 0;
    numesprange_y = 0;
    numesprange_z = 0;
    no_esprangefile = 1;
}

void printEpigradoptLog(void)
{
    FILE * fp;

    total_gradopt_count++;
    each_gradopt_count++;

    if((fp=fopen("epigradopt.log","a"))==NULL) return;
    fprintf(fp, "dbdtper and esp:\n");
    fprintf(fp, "%d %d %d %f %f %f %d\n",dbdt_model, total_gradopt_count, each_gradopt_count,
        cfdbdtper, dbdtper_new, pidbdtper, esp);
    fclose(fp);
}

void printEspRange(void)
{
    FILE * fp;
    int i;

    if((fp=fopen("epigradopt.log","a"))==NULL) return;
    fprintf(fp, "X esp range:\n");
    for(i=0; i<numesprange_x; i++)
    {
        fprintf(fp, "%d %d %d\n", i+1, esprange_x[i][0], esprange_x[i][1]);
    }
    fprintf(fp, "Y esp range:\n");
    for(i=0; i<numesprange_y; i++)
    {
        fprintf(fp, "%d %d %d\n", i+1, esprange_y[i][0], esprange_y[i][1]);
    }
    fprintf(fp, "Z esp range:\n");
    for(i=0; i<numesprange_z; i++)
    {
        fprintf(fp, "%d %d %d\n", i+1, esprange_z[i][0], esprange_z[i][1]);
    }
    fclose(fp);
}

void printCornerPoint(int nump, int * tcon, float * aconx, float * acony)
{
    FILE * fp;
    int i;

    if((fp=fopen("epigradopt.log","a"))==NULL) return;
    fprintf(fp, "readout and phase waveform:\n");
    fprintf(fp, "%d %d %d\n",dbdt_model, total_gradopt_count+1, each_gradopt_count+1);
    fprintf(fp, "dbdtinf %f dbdtfactor %d efflength %f\n", cfrinf, cfrfact, FMax(3, cfdbdtdx, cfdbdtdy, cfdbdtdz));
    fprintf(fp, "all %d\n", nump);
    for(i=0; i<nump; i++)
    {
        fprintf(fp, "%d %f %f 0.0\n", tcon[i], aconx[i], acony[i]);
    }
    fclose(fp);
}

void printDbdtper(float the_dbdtper, int nump, int * tcon, float * dbdtper_x, float * dbdtper_y, float * dbdtper_t)
{
    FILE * fp;
    int i;

    if((fp=fopen("epigradopt.log","a"))==NULL) return;
    fprintf(fp, "convolution model dbdtper waveform:\n");
    fprintf(fp, "%d %d %d %f\n",dbdt_model, total_gradopt_count+1, each_gradopt_count+1, the_dbdtper);
    for(i=0; i<nump; i++)
    {
        fprintf(fp, "%d %f %f %f\n", tcon[i], dbdtper_x[i], dbdtper_y[i], dbdtper_t[i]);
    }
    fclose(fp);
}

void printEpigradoptResult(void)
{
    FILE * fp;
    float ta;

    if((fp=fopen("epigradopt_result.log","a"))==NULL) return;
    if(vrgfsamp == PSD_OFF) ta = 1.0;
    else ta = ((float)pw_gxw)/(pw_gxw+(float)pw_gxwad-(pw_gyba+pw_gyb/2.0)*(pw_gyba+pw_gyb/2.0)/pw_gxwad);
    fprintf(fp, "%d %d %d %d %f %d %d %f %f %f %d %f %d %d %d %d\n", dbdt_model, rampopt, 
        esprange_check, espopt, opfov, opxres, opyres, cfdbdtper, dbdtper_new, 
        pidbdtper, esp, ta, min_seqgrad, tmin, tmin_total, avmaxslquant);
    fclose(fp);
}

STATUS 
#ifdef __STDC__
setEpiEsp( void )
#else
    setEpiEsp()
#endif
{
    /* Minimum time between the endof one frame and beginning */
    /* of next is 50us in MGD DRF. */

    /* modify pw_gxwl,r1 to satisfy esp constraints */
    pw_gxwl1 = 0;
    pw_gxwr1 = 0;
    pw_gxwl2 = 0;
    pw_gxwr2 = 0;
    pw_gxwl = pw_gxwl1;
    pw_gxwr = pw_gxwr1;
    
    esp  = pw_gxw + 2*pw_gxwad + pw_gxwl + pw_gxwr + pw_gxgap;
    
    if (esp < minesp) {  /* is esp long enough? - if not, adjust pw_gxwl1,r2 */
        pw_gxwl1 = (minesp - esp)/2;
        pw_gxwr1 = pw_gxwl1;
        pw_gxwl = pw_gxwl1;
        pw_gxwr = pw_gxwr1;
        esp  = pw_gxw + 2*pw_gxwad + pw_gxwl + pw_gxwr + pw_gxgap;
    }
    
    if (vrgfsamp != PSD_ON)  {

        if ( (2*pw_gxwad + pw_gxwl1 + pw_gxwr1) < (pw_gyba + pw_gyb + pw_gybd) ) {
            pw_gxwl1 = pw_gxwl1 + RUP_GRD(pw_gyb/2 + pw_gyba - pw_gxwad);
            pw_gxwr1 = pw_gxwr1 + RUP_GRD(pw_gyb/2 + pw_gyba - pw_gxwad);
            pw_gxwl = pw_gxwl1;
            pw_gxwr = pw_gxwr1;
            esp  = pw_gxw + 2*pw_gxwad + pw_gxwl + pw_gxwr + pw_gxgap;
	}

        /* local scope { } */
        {  
            /* make sure esp/intleaves is a multiple of (hardware period)*intleaves by adjusting pw_gxwl1,r1 */
            int tmp, esp_new;
            
            esp_new = esp;
            tmp = intleaves * hrdwr_period;
            if( (esp % tmp) != 0) esp_new = (esp/tmp + 1) * tmp;
            esp_new = IMax(2, esp_new, minesp);
            
            if( esp_new > esp ) {
                pw_gxwl1 = pw_gxwl1 + (esp_new - esp)/2;
                pw_gxwr1 = pw_gxwl1;
                pw_gxwl = pw_gxwl1;
                pw_gxwr = pw_gxwr1;
                esp  = pw_gxw + 2*pw_gxwad + pw_gxwl + pw_gxwr + pw_gxgap;
            }   

        } /* end local {} scope */


    } /* end if vrgfsamp != PSD_ON */

    /* Last check: Make sure the echo-spacing */
    /* does not violate the minimum time from the end */
    /* of one data frame to the beginning of the next */
    if( (esp - rhfrsize*tsp) <  MinFram2FramTime) {      
        pw_gxgap  = RUP_GRD((int)(MinFram2FramTime-(esp - rhfrsize*tsp)));

        /* Make sure added pw_gxgap/2 is on 4 us boundary */
        if ((pw_gxgap - (pw_gxgap/pwmin_gap)*pwmin_gap) != 0.0)
            pw_gxgap = (int)ceil((double)pw_gxgap / (double)pwmin_gap) * pwmin_gap;    
    } 
    
    /* Do the following in case pw_gxwl2 was modified by modify cvs */
    pw_gxwr2 = pw_gxwl2;
    pw_gxwl = pw_gxwl1 + pw_gxwl2;
    pw_gxwr = pw_gxwr1 + pw_gxwr2;
    esp  = pw_gxw + 2*pw_gxwad + pw_gxwl + pw_gxwr + pw_gxgap;
    
    /* total readout flat-top */
    pw_gxw_total = pw_gxwl + pw_gxw + pw_gxwr;  
    
    return SUCCESS;
}

STATUS
mph_protocol( void )
{
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

    if (noFpsLimitFlag == FALSE) {

        INT numcoils =  ((cfrecvend - cfrecvst)+1);
        FLOAT fps_limit = 256.0;  /* limit on fps */
        INT maxDimension;

        maxDimension = IMax(2,exist(opxres), exist(opyres));

        if  ( maxDimension <= 64 ) {
            fps_limit = (numcoils > 4) ? 20.0 : 25.0;
            if(((float)avmaxslquant/(float)((float)exist(optr)/1.0e6) > fps_limit)) {
                avmaxslquant = floor(fps_limit*(float)exist(optr)/1.0e6);
                avmintr = (INT)(ceil(1.0e6 * (float)((float)exist(opslquant)/(float)fps_limit)));
                avmintr = (INT)(ceil((float)avmintr / 1000.0) * 1000.0);
            }
        } else if ( maxDimension <= 128 )  {
            fps_limit = (numcoils > 4) ? 13.0 : 18.0;
            if(((float)avmaxslquant/(float)((float)exist(optr)/1.0e6) > fps_limit)) {
                avmaxslquant = floor(fps_limit*(float)exist(optr)/1.0e6);
                avmintr = (INT)(ceil(1.0e6 * (float)((float)exist(opslquant)/(float)fps_limit)));
                avmintr = (INT)(ceil((float)avmintr / 1000.0) * 1000.0);
            }
        } else {
            fps_limit = (numcoils > 4) ? 5.0 : 10.0;
            if(((float)avmaxslquant/(float)((float)exist(optr)/1.0e6) > fps_limit)) {
                avmaxslquant = floor(fps_limit*(float)exist(optr)/1.0e6);
                avmintr = (INT)(ceil(1.0e6 * (float)((float)exist(opslquant)/(float)fps_limit)));
                avmintr = (INT)(ceil((float)avmintr / 1000.0) * 1000.0);
            }
        }
    } /* end noFpsLimitFlag Check */

    if( exist(opileave) == PSD_ON) {
        epic_error( use_ermes, "%s is incompatible with %s.", EM_PSD_INCOMPATIBLE, EE_ARGS(2), STRING_ARG, "fMRI", STRING_ARG, "Interleaved Slice Spacing" );
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
    if ((avmaxslquant > 0) && (exist(opslquant) > avmaxslquant)) {
        strcpy(estr, "Too many slices per TR, please reduce slice number or increase TR");
        epic_error(use_ermes, estr, EM_PSD_FMRI_MULTIACQS, EE_ARGS(0));
        return ADVISORY_FAILURE;
    }

    return SUCCESS;
}


STATUS
#ifdef __STDC__ 
cveval1( void )
#else /* !__STDC__ */
    cveval1() 
#endif /* __STDC__ */
{
    int icount, pulsecnt;
    const CHAR funcName[] = "cveval1";
    int temp_slquant = 1; /* MRIhc27295 */
    int temp_maxslquant;

    tlead = 24us;
    tleadssp = tlead;
    tlead = RUP_GRD(tlead);
    tleadssp = RUP_GRD(tleadssp);

    psd_card_hdwr_delay = 10ms;  
    if ((exist(opcgate) == PSD_ON) && existcv(opcgate)) 
    {
        avmintdel1 = psd_card_hdwr_delay + tlead + t_exa + GRAD_UPDATE_TIME;
        avmintdel1 = avmintdel1 + ir_time_total;
        if (ir_on == PSD_ON)
        {
            pitdel1 = avmintdel1;
        }
        else
        {
            pitdel1 = avmintdel1 + sp_sattime + cs_sattime;
            pitdel1 = pitdel1 + satdelay;
        }
        advroundup(&avmintdel1); /* round up to ms */
        advroundup(&pitdel1); /* round up to ms */
        
        /* Override Trigger Delay value if user prescribes Minimum or Recommended */
        if( existcv(opautotdel1) ) 
        { 
            if( PSD_TDEL1_MINIMUM == exist(opautotdel1) ) 
            { 
                cvdef(optdel1, avmintdel1); 
                cvoverride(optdel1, _optdel1.defval, PSD_FIX_ON, PSD_EXIST_ON); 
            } 
            else if( PSD_TDEL1_RECOMMENDED == exist(opautotdel1) ) 
            { 
                cvdef(optdel1, pitdel1); 
                cvoverride(optdel1, _optdel1.defval, PSD_FIX_ON, PSD_EXIST_ON); 
            } 
        }

        if (optdel1 < pitdel1)
            td0 = RUP_GRD((int)(exist(optdel1) - (psd_card_hdwr_delay 
                                                  + tlead + t_exa)));
        else
            td0 = RUP_GRD((int)(exist(optdel1) - (psd_card_hdwr_delay + tlead 
                                                  + t_exa + sp_sattime + cs_sattime + ir_time + satdelay)));
      
        gating = TRIG_ECG;
        piadvmin = (piadvmin & ~(1<<PSD_ADVTR));
        piadvmax = (piadvmax & ~(1<<PSD_ADVTR));
        pitrnub = 0;
    } 
    else 
    {
        _opphases.fixedflag = 0;
        opphases = 1;
        avmintdel1 = 0;
        td0 = GRAD_UPDATE_TIME;
        piadvmin = (piadvmin | (1<<PSD_ADVTR));
        piadvmax = (piadvmax | (1<<PSD_ADVTR));
        pitrnub = 6;
        gating = TRIG_INTERN;
    }
			   
    /* Find the avail time for freq dephaser */

    /* Need fix here for trapezoidal phase encoding */
    if (exist(oppseq) == PSD_SE)
    {
        avail_pwgx1 = (int)(exist(opte) / 2 - rfExIso - pw_rf2 / 2 -
                            RUP_GRD(rfupd));
    }
    else
    {
        avail_pwgx1 = (int)(exist(opte) - rfExIso - (pw_gxwad + pw_gxw / 2) -
                            RUP_GRD(rfupd));
    }

    /*
     * MRIge55604 - Calculate minimun and maximum FOV
     */
    avminfovx = 1.0 / (GAM * xtarg * tsp * 1.0e-6);
    avminfovy = 0.0;
    avminfov = (avminfovx > avminfovy) ? avminfovx : avminfovy; 
    avminfov = ceil(avminfov) * 10.0;
    if (vrgfsamp == PSD_ON  && user_bw == 0)
    {
        /* Always use the minimum FOV for Ramp Sampling */
        avminfov = _opfov.minval;
    }
    else
    {
        /* Make sure min FOV is within the valid range */
        avminfov = (avminfov < _opfov.minval) ? _opfov.minval : avminfov;
    }
    /* This is the best Scan can do on the advisory panel.  The PSD supports
       a larger fov than 99cm, but the advisory panel won't reflect it. */
    avmaxfov = _opfov.maxval;
  
    /*
     * MRIge55604 - Calculate minimun and maximum RBW
     */
    if( exist(opnshots) > 1) {
        avminrbw = 31.25;
    } else {
        avminrbw = 62.5;
    }
    avmaxrbw = RBW_MAX;
    avminrbw = 15.625; /*jwg enable very low RBW for testing*/
  
    {
        float tsptmp;   /* min possible sampling period in micro seconds. */
      
        /* Calculate maximum RBW when ramp samp is not ON */
        /* MRIge51408 - Set max RBW based on max FOV */
        tsptmp = 10.0 / (GAM * xtarg * avmaxfov * 1.0e-6);
        /* round up to nearest 50 nanoseconds */
        tsptmp = (int)(5+100*tsptmp)/100.0;
        tsptmp -= ((int)(100*tsptmp)%5)/100.0;
        avmaxrbw = (1.0 / (2.0 * (tsptmp / 1000.0)));
        avmaxrbw = (avmaxrbw > RBW_MAX) ? RBW_MAX : avmaxrbw;
    }

    /* avmaxrbw2 is not used in EPI, but this value
       will be displayed in the insensitive field of
       bandwidth2 */
    avmaxrbw2 = avmaxrbw;

    /* Calculate or adjust some timing variables based on MRE information */
@inline touch.e TouchEvalTimings

    fullk_nframes = (int)(ceilf(opyres*asset_factor/rup_factor)*rup_factor);

    /* Begin Minimum TE *****************************************************/
    area_gyb = (float)(pw_gyba + pw_gyb)*a_gyb;  /* G usec / cm */
    /*jwg bb run amppwgrad so that we can generate 'worst-case scenario' blip scheme*/
    if(sake_flag > 0)
    {
        gettarget(&target, YGRAD, &loggrd);
	getramptime(&rtime, &ftime, YGRAD, &loggrd);
	rtime /= 4;
    	amppwgrad(area_gyb, target, 0.0, 0.0, rtime * (int)sake_max_blip, MIN_PLATEAU_TIME, &a_gyb, &pw_gyba, &pw_gyb, &pw_gybd);
	fprintf(stderr,"Target is %f, rtime is %d, Rise time is %d \n",target,rtime,loggrd.yrt);    
    } else {
    	sake_max_blip = 1;
    }
        
  
    /* Compute minimum te with full ky coverage first *************************/

    /* MRIge92386 */
    etl = (int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)/intleaves;
    num_overscan = 0;
  
    /* Set the fract_ CVs */
    fract_ky = PSD_FULL_KY;
    if(exist(opview_order) == PSD_OFF) {
        ky_dir = PSD_TOP_DOWN;
    } else {
        ky_dir = PSD_BOTTOM_UP;
    }
   
    /* BJM: setup ky_offset, dont allow mods below if single etl */
    /* MRIge92386 */
    if ((int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor) == exist(opnshots)) {
        cvoverride(ky_offset, 0, PSD_FIX_ON, PSD_EXIST_ON);
        cvoverride(delt, 0, PSD_FIX_ON, PSD_EXIST_ON);
    } else {
        cvoverride(ky_offset, 0, PSD_FIX_OFF, PSD_EXIST_ON);
        cvoverride(delt, 0, PSD_FIX_OFF, PSD_EXIST_ON);
    }

    if (intleaves == 1) 
    {
        delt = 0;
        ky_offset = 0.0;
        pw_wgx = GRAD_UPDATE_TIME;
    } 
    else 
        if ( ky_dir==PSD_BOTTOM_UP ) 
        {
            delt = RUP_HRD((int)((float)esp/(float)(intleaves)));
            if (etl % 2 == 0) 
            {
                /* BJM: MRIge60610 */
                if ((etl/2) % 2 == 0)
                    ky_offset = (float)(ceil(-(double)intleaves/2.0));
                else
                    ky_offset = (float)(ceil((double)intleaves/2.0));
            } 
            else 
            {
                ky_offset = (float)(ceil((double)-intleaves));
            }
            pw_wgx = (intleaves-1)*delt/2 + GRAD_UPDATE_TIME;
        } 
        else 	
        {    /* full ky CENTER-OUT */
            delt = RUP_HRD((int)((float)esp/(float)(intleaves*2)));
            ky_offset = 0.0;
            pw_wgx = GRAD_UPDATE_TIME;
        }

    blips2cent = etl/2 + ky_offset/intleaves;

    pw_wgx = RUP_GRD(pw_wgx);
    pw_wgy = pw_wgx;
    pw_wgz = pw_wgx;
    pw_wssp = pw_wgx;
    pw_womega = pw_wgx;
	
    tdaqhxa = ((float)etl/2.0 + ky_offset/(float)intleaves + iref_etl)*(float)esp + delt/2;
    /* MRIge92386 */
    area_gy1 = area_gyb * (ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor/2.0 - 0.5)/(float)intleaves;

    avmintecalc();

    avmintefull = (int)(100.0*ceil((double)avmintetemp/100.0));	/* round up to 0.1 ms, YP Du */
 
    /* BJM - SE Ref Scan */
    /* Determine min TE for Full Ky Spin Echo Ref Case */
    minTeFull_ref = avmintecalc_ref();

    /* Compute minimum te with fractional ky coverage or full ky with center/out
       coverage next ******************/

    /* Set the fract_ CVs */
    fract_ky = PSD_FRACT_KY;

    if(exist(opview_order) == PSD_OFF) {
        ky_dir = PSD_TOP_DOWN;
    } else {
        ky_dir = PSD_BOTTOM_UP;
    }

    /* New rhhnover calculation - use minimum number of overscans (based
       on opnshots and fract_ky).  Leave old algorithm in, but use it to
       calc. rhhnover_max, which is not currently used, but may be in the
       future to maximize s/n. */
    if ( exist(oppseq) == PSD_GE )
    	/*jwg bb change from MIN_HNOVER_GRE to opyres/4, i.e. 0.75PE*/
	if (sake_flag == 0)
	{
        	rhhnover_min = (int)ceilf(opyres / 4);
	} else {
		rhhnover_min = 0; /*jwg trick system into acquiring only half k-space lines*/
		rhhnover = 0;
	}
    else
        rhhnover_min = MIN_HNOVER_DEF;

    /* MRIge92386 */
    if( intleaves < (int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor) ) {
        for (icount=0; icount<=rhhnover_min; icount++) {
            if (icount*intleaves>=rhhnover_min) {
                num_overscan = (icount*intleaves);
                break;
            }
        }
      
    } else {
        num_overscan = rhhnover_min;
    } 

    /* MRIge92386; Change it to ASSET_SCAN */
    /* asset = 2 for scans, 1 for calibration */
    if((exist(opasset) == ASSET_SCAN) &&
       ((exist(oppseq) == PSD_SE) || (intleaves == 1))) { /* YMSmr08010 */

        /* Use 8  overscans for Asset */
        num_overscan = 8;

%ifdef RT
        if((exist(oppseq) == PSD_GE)) 
        {
            num_overscan = 16;
        }
%endif

        if(num_overscan >= (int)(ceilf(asset_factor*exist(opyres)/rup_factor)*rup_factor/2.0)) {
            num_overscan = (int)(ceilf(asset_factor*exist(opyres)/rup_factor)*rup_factor/2.0);
        }

    }

    /* MRIge92386 */
    etl = ((int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)/2 + num_overscan)/intleaves;

    /* Determine ky offsets */
    if (intleaves == 1) 
    {
        delt = 0;
        ky_offset = 0.0;

        if(ky_dir == PSD_BOTTOM_UP) {
            tdaqhxa = (float)num_overscan*(float)esp;
        } else {
            tdaqhxa = (float)((fullk_nframes/2)*(float)esp);
        }
        tdaqhxa += (float)iref_etl*esp;

        pw_wgx = GRAD_UPDATE_TIME;
    } 
    else 
    {
        delt = RUP_HRD((int)((float)esp/(float)(intleaves)));

        if ((num_overscan/intleaves) % 2 == 0)
            ky_offset = (float)(ceil((double)-intleaves/2.0));
        else
            ky_offset = (float)(ceil((double)intleaves/2.0));

        if (fullk_nframes == exist(opnshots))
            ky_offset = 0.0;

        /* BJM: MRIge60610 */ 
        if(num_overscan > 0) {
            /* BJM: the true number of overscans */
            rhhnover = num_overscan + ky_offset;

            /* MRIhc57297 06/15/2011 YI */
            ky_offset_save = ky_offset;
            rhhnover_save = rhhnover;
            rhnframes_tmp = (short)(ceilf((float)exist(opyres)*asset_factor/rup_factor)*rup_factor*fn*nop);
          
            /* MRIge61204 & MRIge61702 */
            /* Here's da deal: we are trying to put the echo peak */
            /* at the center of the group of flow comped echoes.   */
            /* It's desirable to place the peak early instead of late */
            /* to minimize TE.  However, if we can't, then place the */
            /* echo peak "late" instead for min TE */
            if(fabs(ky_offset) > 0) {
                if (exist(oppseq) == PSD_GE && rhhnover < MIN_HNOVER_GRE) {
                    ky_offset = (float)(ceil(3.0*(double)intleaves/2.0));
                    rhhnover = MIN_HNOVER_GRE + ky_offset;
                } else if (rhhnover < MIN_HNOVER_DEF) {
                    ky_offset = (float)(ceil(3.0*(double)intleaves/2.0));
                    rhhnover = MIN_HNOVER_DEF + ky_offset;
                }

                /* MRIhc57297 06/15/2011 YI */
                if(rhhnover > rhnframes_tmp - ky_offset) {
                    ky_offset = ky_offset_save;
                    rhhnover = rhhnover_save;
                }

            } /* end fabs(ky_offset) > 0 */          
        }

        tdaqhxa = ((float)num_overscan + ky_offset)*(float)esp/(float)intleaves +
            delt*(intleaves-1)/2 + (float)iref_etl*esp;

	/* MRIge92386 */
        etl = ((int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)/intleaves)/2 + IMax(2, num_overscan/intleaves, 1);


        pw_wgx = GRAD_UPDATE_TIME;

    }

    pw_wgx = RUP_GRD(pw_wgx);
    pw_wgy = pw_wgx;
    pw_wgz = pw_wgx;
    pw_wssp = pw_wgx;
    pw_womega = pw_wgx;

    area_gy1 = area_gyb * ((float)num_overscan - 0.5) / (float)intleaves;

    avmintecalc();
    fprintf(stderr,"avminx is %d, avminy is %d, avminz is %d \n",avminx, avminy, avminz);    
  
    /* BJM - SE Ref Scan */
    /* Determine min TE for Fract Ky Spin Echo Case */
    minTeFrac_ref = avmintecalc_ref();

    if ((exist(opautote) == PSD_MINTEFULL) || (exist(opnshots) == fullk_nframes) ||
        (num_overscan == fullk_nframes/2 ) || (ky_dir == PSD_TOP_DOWN))
        avminte = avmintefull;
    else
        avminte = (int)(100.0*ceil((double)avmintetemp/100.0));   /* round up to 0.1ms */
   
    if (exist(opautote) == PSD_MINTE || exist(opautote) == PSD_MINTEFULL) 
    {
        /* Round up min te to nears 0.1 ms */    
        cvoverride(opte,ceil((float)avminte/100.0)*100, PSD_FIX_ON, PSD_EXIST_ON);   
    }
    else if ((existcv(opte) == PSD_ON) && smart_numoverscan)
    {
        if ((exist(opte) > avminte) && (exist(opte) < avmintefull))
        {
            int extra_os_time;
            if (oppseq == PSD_GE)
            {
                extra_os_time = exist(opte) - avminte;
            }
            else
            {
                extra_os_time = (exist(opte) - avminte)/2;
            }
            num_overscan += (extra_os_time/esp/2)*2;
            etl = (num_overscan + (int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)/2)/intleaves;
        }
    }
  
    /* End Minimum TE *******************************************************/

    /* Now recompute everything based on operator selected parameters *******/

    if (exist(opte) >= avmintefull) 
    {
        fract_ky = PSD_FULL_KY;
      
        /* BJM - SE Ref Scan */
        refScanTe = (int)(100.0*ceil((double)minTeFull_ref/100.0)); 
    } 
    else 
    {
        fract_ky = PSD_FRACT_KY;

        /* BJM - SE Ref Scan */
        refScanTe = (int)(100.0*ceil((double)minTeFrac_ref/100.0)); 

    }
  
    if((ky_dir == PSD_TOP_DOWN) && (exist(opautote) != PSD_MINTEFULL) && 
       (fract_ky_topdown == PSD_FRACT_KY) && (fullk_nframes/2.0 > num_overscan))
    {
        fract_ky = PSD_FRACT_KY;
    }

    nexcalc();
  
    if (intleaves == 1) 
    {
        delt = 0;
    } 
    else 
        if ( ky_dir==PSD_BOTTOM_UP ) 
        {
            delt = RUP_HRD((int)((float)esp/(float)(intleaves)));
        } 
        else 	
        {
            delt = RUP_HRD((int)((float)esp/(float)(intleaves*2)));
        }
  
    /* Wait pulses */
    if (intleaves == 1)
        pw_wgx = GRAD_UPDATE_TIME;
    else 
        if ( ky_dir==PSD_BOTTOM_UP ) 
            pw_wgx = (intleaves-1)*delt/2 + GRAD_UPDATE_TIME;
        else    /* full ky CENTER-OUT */
            pw_wgx = GRAD_UPDATE_TIME;

    pw_wgx = RUP_GRD(pw_wgx);
    pw_wgy = pw_wgx;
    pw_wgz = pw_wgx;
    pw_wssp = pw_wgx;
    pw_womega = pw_wgx;

    if (intleaves > 1) 
    {
        if ( ky_dir == PSD_BOTTOM_UP && fract_ky == PSD_FRACT_KY ) 
	{
            if (etl % 2 == 0)
                ky_offset = (float)(ceil((double)-intleaves/2.0));
            else
                ky_offset = (float)(ceil((double)intleaves/2.0));
	} 
        else 
            if ( (ky_dir == PSD_BOTTOM_UP && fract_ky == PSD_FULL_KY) ||
                 ky_dir == PSD_TOP_DOWN ) 
            {
		/* MRIge92386 */
                etl = (int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)/intleaves;
                if (etl % 2 == 0) 
                {
                    if ((etl/2) % 2 == 0)
                        ky_offset = (float)(ceil((double)-intleaves/2.0));
                    else
                        ky_offset = (float)(ceil((double)intleaves/2.0));
                } 
                else 
                {
                    ky_offset = (float)(ceil((double)-intleaves/2.0));
                }
            } 
            else 
                if (ky_dir == PSD_CENTER_OUT && fract_ky == PSD_FULL_KY)
                    ky_offset = 0.0;
    } 
    else 
    {             /* single interleave */
        ky_offset = 0.0;
    }

    /* MRIge75283 */
    if (fullk_nframes == exist(opnshots)) {
        ky_offset = 0.0;
    }
  
    if (fract_ky == PSD_FULL_KY) 
    {
        rhhnover = 0;
        num_overscan = 0;
	/* MRIge92386 */
        etl = (int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)/intleaves;
    } 
    else
    {
        if (intleaves > 1) 
        {
            if ((num_overscan/intleaves) % 2 == 0)
                ky_offset = (float)(ceil((double)-intleaves/2.0));
            else
                ky_offset = (float)(ceil((double)intleaves/2.0));
        } 
        else 
        {
            ky_offset = 0.0;
        }
	
	/* MRIge92386 */
        etl = (num_overscan + (int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)/2)/intleaves;

	/* MRIge92386 */
        if (num_overscan >= fullk_nframes/2) 
	{
            rhhnover = 0;
            num_overscan = 0;
            fract_ky = PSD_FULL_KY;
            ky_dir = PSD_BOTTOM_UP;
	    /* MRIge92386 */
            etl = (int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)/intleaves;
            /* MRIge41484 BJM: modify ky_offset and set fn = 1.0 to prevent */
            /*                 download failure of Min TE, multi-shot, */
            /*                 spin-echo epi */
            ky_offset *= -1;
            fn = 1.0;         /* reset fractional nex value */

	}

    } /* partial ky */

    /* since opetl gets stored in the header */
    opetl = etl;

    /* BJM: MRIge60610 */ 
    if(num_overscan > 0) {
        /* BJM: the true number of overscans */
        rhhnover = num_overscan + ky_offset;

        /* MRIhc57297 06/15/2011 YI */
        ky_offset_save = ky_offset;
        rhhnover_save = rhhnover;
        rhnframes_tmp = (short)(ceilf((float)exist(opyres)*asset_factor/rup_factor)*rup_factor*fn*nop);

        /* MRIge61204 & MRIge61702 */
        if(fabs(ky_offset) > 0) {
            if (exist(oppseq) == PSD_GE && rhhnover < MIN_HNOVER_GRE) {
                ky_offset = (float)(ceil(3.0*(double)intleaves/2.0));
                rhhnover = MIN_HNOVER_GRE + ky_offset;
            } else if (rhhnover < MIN_HNOVER_DEF) {
                ky_offset = (float)(ceil(3.0*(double)intleaves/2.0));
                rhhnover = MIN_HNOVER_DEF + ky_offset;
            }

            /* MRIhc57297 06/15/2011 YI */
            if(rhhnover > rhnframes_tmp - ky_offset) {
                ky_offset = ky_offset_save;
                rhhnover = rhhnover_save;
            }

        } /* end fabs(ky_offset) > 0 */
    }

    nblips = etl - 1;
	
    /* Y phase encode prephaser */
  
    if (etl == 1) {
        area_gy1 = area_gyb/2.0;
        blips2cent = 0;
    } else {
        if (ky_dir == PSD_BOTTOM_UP && fract_ky == PSD_FRACT_KY) {

            area_gy1 = area_gyb * ((float)num_overscan - 0.5) / (float)intleaves;
            blips2cent = (num_overscan + ky_offset) / intleaves;

        } else if (ky_dir == PSD_TOP_DOWN && fract_ky == PSD_FRACT_KY) {

	    /* MRIge92386 */
            area_gy1 = area_gyb * (ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor/2.0 - 0.5) /
                (float)intleaves;
            blips2cent = etl/2 + ky_offset/intleaves;

        }  else if (ky_dir == PSD_CENTER_OUT && fract_ky == PSD_FULL_KY) {

            area_gy1 = area_gyb * ((float)intleaves/2.0 - 0.5);
            blips2cent = 0;

        } else if ( (ky_dir == PSD_BOTTOM_UP && fract_ky == PSD_FULL_KY) ||
                    (ky_dir == PSD_TOP_DOWN && fract_ky == PSD_FULL_KY) ) {
        /*MRIhc00996*/
            area_gy1 = area_gyb * (ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor/2.0 - 0.5) /
                (float)intleaves;
            blips2cent = etl/2 + ky_offset/intleaves;

        }
    }
  
    gy1_offset = ky_offset*fabs(area_gyb)/intleaves;
  
    /* Shift ky=0 point to center of x flow comp'd echoes */
    if (etl > 1)
        area_gy1 += gy1_offset;
  
    /* Scale the waveform amps for the phase encodes 
     * so each phase instruction jump is an integer step */
  
    if (ky_dir == PSD_BOTTOM_UP && fract_ky == PSD_FRACT_KY) {
        if (intleaves <= 1)
            endview_iamp = max_pg_wamp;
        else {
            if (num_overscan >= 2)
                endview_iamp = (int)((int)( 2*max_pg_wamp/
                                            (num_overscan-1 + 2*ky_offset) )/2)*
                    2*(num_overscan-1+2*ky_offset)/2;
            else
                endview_iamp = max_pg_wamp;
        }
    } else if (ky_dir == PSD_CENTER_OUT && fract_ky == PSD_FULL_KY) {
        if (intleaves <= 2)
            endview_iamp = max_pg_wamp;
        else
	    /* MRIge92386 */
            endview_iamp = (int)((int)(2*max_pg_wamp/
                                       ((int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)-1 + 2*ky_offset))/2)*
                2*((int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)-1 + 2*ky_offset)/2;
    } else if ((ky_dir == PSD_TOP_DOWN || ky_dir == PSD_BOTTOM_UP) &&
               fract_ky == PSD_FULL_KY) {
        if (intleaves <= 1)
            endview_iamp = max_pg_wamp;
        else
	    /* MRIge92386 */
            endview_iamp = (int)((int)(2*max_pg_wamp/
                                       ((int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)-1 + 2*ky_offset))/2)*
                2*((int)(ceilf(exist(opyres)*asset_factor/rup_factor)*rup_factor)-1 + 2*ky_offset)/2;
    }
  
    endview_scale = (float)max_pg_iamp / (float)endview_iamp;
  
    /* Find the amplitudes and pulse widths of the trapezoidal
       phase encoding pulse. */
  if(opuser26 == 0)
  {
    if (amppwtpe(&a_gy1a,&a_gy1b,&pw_gy1,&pw_gy1a,&pw_gy1d,
                 loggrd.ty_xyz/endview_scale,loggrd.yrt,
                 area_gy1) == FAILURE)
    {
        epic_error(use_ermes, supfailfmt, EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "amppwtpe");
        return FAILURE;
    } 
    } else {
    /*jwg with sake want to ensure we got out to edge of k-space, even though we trick it w/ rhhnover_min = 0*/
	    if (amppwtpe(&a_gy1a,&a_gy1b,&pw_gy1,&pw_gy1a,&pw_gy1d,
                 loggrd.ty_xyz/endview_scale,loggrd.yrt,
                 (area_gyb * ((float)(opyres/2) - 0.5) / (float)intleaves)) == FAILURE)
    {
        epic_error(use_ermes, supfailfmt, EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "amppwtpe");
        return FAILURE;
    } 
    }
  
    pw_gy1_tot = pw_gy1a + pw_gy1 + pw_gy1d;
  
    a_gy1a = ((exist(oppseq) == PSD_SE && gy1pos == PSD_PRE_180) ?
              a_gy1a : -a_gy1a);
    a_gy1b = ((exist(oppseq) == PSD_SE && gy1pos == PSD_PRE_180) ?
              a_gy1b : -a_gy1b);
  
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
            pulsepos += (esp - pw_gyba - pw_gyb/2);
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

    /* internref: pw_iref_gxwait is defined in EP_TRAIN() */
    if( iref_etl != 0 && pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot > esp ){
        pw_iref_gxwait = RUP_GRD(pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot - esp);
    }else{
        pw_iref_gxwait = 0;
    }
    if(no_gy1_ol_gxw && iref_etl > 0)
        pw_iref_gxwait = RUP_GRD(pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot);

    /* Actual inter echo time */
    if (etl == 1)
        esp = 0;  /* can't define an echo spacing with an etl of 1! */
  
    if (esp % GRAD_UPDATE_TIME != 0) {
        sprintf(estr,
                " esp not an integral multiple of grad hardware period. ");
        epic_error(use_ermes, estr, EM_PSD_SUPPORT_FAILURE, 1, STRING_ARG,
                   " esp not an integral multiple of grad hardware period. ");
        return FAILURE;
    }
 
    if (etl == 1) {
        tdaqhxa = (pw_gxw + 2*pw_gxwad + pw_gxwl + pw_gxwr)/2;
        tdaqhxb = tdaqhxa;
        pw_gxgap = 0;
    } else {
        if ((ky_dir==PSD_TOP_DOWN || ky_dir==PSD_BOTTOM_UP) &&
            fract_ky == PSD_FULL_KY) {
            tdaqhxa = ((float)etl/2.0 + ky_offset/(float)intleaves + iref_etl)*(float)esp;
            tdaqhxb = ((float)etl/2.0 - ky_offset/(float)intleaves)*(float)esp;
        } else if (ky_dir == PSD_BOTTOM_UP && fract_ky == PSD_FRACT_KY) {
            /* Do overscans first */
            tdaqhxa = ((float)num_overscan - ky_offset)*(float)esp/(float)intleaves + (float)iref_etl*esp;
            tdaqhxb = ((float)etl-(((float)num_overscan+ky_offset)/(float)intleaves))
                *(float)esp;
        }  else if (ky_dir == PSD_TOP_DOWN && fract_ky == PSD_FRACT_KY) {
            /* Do overscans LAST */
            tdaqhxb = ((float)num_overscan - ky_offset)*(float)esp/(float)intleaves;
            tdaqhxa = ((float)etl-(((float)num_overscan+ky_offset)/(float)intleaves))
                *(float)esp + (float)iref_etl*esp;
        } else if (ky_dir == PSD_CENTER_OUT && fract_ky == PSD_FULL_KY) {
            /* Put the middle of the first echo at the nominal TE */
            tdaqhxa = pw_gxwad + pw_gxwl + (pw_gxw/2);
            tdaqhxb = etl*esp + pw_gxgap + pw_gxwad + pw_gxwl + (pw_gxw/2);
        }
    }

    tdaqhxa += pw_iref_gxwait;

    if (etl % 2 == 0)       /* odd number of views, so negate killer ampl. */
        a_gxk = -a_gxk;
 
    if (etl+iref_etl >= 256) {
        if  (PSDDVMR == psd_board_type){
            time_ssi = 4000;
        }
        else{
            time_ssi = 2000;
        }
    }
    else {
        if (PSDDVMR == psd_board_type){
            if (PSD_OFF == epispec_flag) {
                if(etl+iref_etl <= 192) {
                    time_ssi = 1200;
                }
                else {
                    time_ssi = 2000;
                }
            }
            else {
                time_ssi = 1000;
            }
        }
        else{
            time_ssi = 1000;
        }
    }
       
    te_time = exist(opte);
    gkdelay = RUP_GRD(gkdelay);

    pos_start = RUP_GRD((int)tlead + GRAD_UPDATE_TIME);

%ifdef RT
    /* BJM - since added 2 ms of time for trigger pulses update pos_start */
    TTLtime_tot = 1003;
    eegtime_tot = 1003;
    if (enable_TTL == PSD_OFF) TTLtime_tot = 0;
    if (enable_eegblank == PSD_OFF) eegtime_tot = 0;

    pos_start = RUP_GRD((int)tlead + eegtime_tot+ 
                        TTLtime_tot + abs(pw_gzrf1a + rfupa) + GRAD_UPDATE_TIME);
%endif

    if ((pos_start + pw_gzrf1a) < -rfupa) {
        pos_start = RUP_GRD((int)(-rfupa - pw_gzrf1a + GRAD_UPDATE_TIME));
    }

    /* MRIge57894 - added pw_sspshift to non_tetime *//* YMSmr08284 */
    non_tetime = pos_start + cs_sattime + sp_sattime + pw_gzrf1a + t_exa + tdaqhxb +
        gktime + gkdelay + time_ssi + GRAD_UPDATE_TIME + delt*(intleaves-1) +
        psd_rf_wait + pw_sspshift;
@inline Inversion.e InversionEval /* calculate ir time */
 
    non_tetime = non_tetime + ir_time + satdelay;
  
%ifdef RT
@inline epiRTfile.e  epiRT_nontetime_update
%endif    

    tmin = te_time + non_tetime;
  
    /* Imgtimutil calculates actual tr for 
       normal scans, available portion of R-R
       interval for imaging for cardiac scans.
       First parameter is only used if the scan
       is cardiac gated. */
  
    premid_rf90 = optdel1 - psd_card_hdwr_delay  - td0;
    if (imgtimutil(premid_rf90, seq_type, gating, 
                   &avail_image_time)==FAILURE)
        epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "imgtimutil");
    else 
        act_tr =  avail_image_time;
  
    /* Image time util returns the time available for slices.
       If cardiac, imgtimutil subtracts off the cardiac trigger delay.
    */
  
    if (existcv(opcgate) && (opcgate == PSD_ON)) {
        /* act_tr is used in powermon routines */
        act_tr = RUP_GRD((int)((float)(exist(ophrep))
                               * (60.0/exist(ophrate))* 1e6));
    }
  
@inline touch.e TouchTRCalc

    act_tr = RUP_HRD(act_tr);
    avail_image_time = RUP_HRD(avail_image_time);
  
    rhptsize = exist(opptsize);
  
    /* BJM: MRIge60610 */
    /* MRIge92386 */
    if(num_overscan > 0) {
        rhnframes = (short)(ceilf((float)exist(opyres)*asset_factor/rup_factor)*rup_factor*fn*nop - ky_offset);
    } else {
        rhnframes = (short)(ceilf((float)exist(opyres)*asset_factor/rup_factor)*rup_factor*fn*nop);
    }

    /* internref: iref_frames */
    iref_frames = iref_etl * intleaves;

    if (rawdata) {
        slice_size = (1+baseline+rhnframes+rhhnover+iref_frames)*
            2*rhptsize*rhfrsize*nex*exist(opnecho);
    } else {
        slice_size = (1+rhnframes+rhhnover+iref_frames)*2*rhptsize*rhfrsize
            *exist(opnecho);
    }
  
    rhdayres = rhnframes + rhhnover + iref_frames + 1;
    if (exist(opxres) > 256 && exist(opxres) <= 512)
        rhimsize = 512;
    else
        rhimsize = 256;

    /* internref: rhcv calculations */
    if( ky_dir == PSD_BOTTOM_UP ){
        rhextra_frames_top = 0;
        rhextra_frames_bot = iref_frames;
        rhpc_ref_start = rhdayres - intleaves - 1;
        rhpc_ref_stop = rhdayres - iref_frames + intleaves;
    }else if( ky_dir == PSD_TOP_DOWN ){
        rhextra_frames_top = iref_frames;
        rhextra_frames_bot = 0;
        rhpc_ref_start = intleaves + 1;
        rhpc_ref_stop = iref_frames - intleaves;
    }

    /* prepare for maxslquanttps calculation */
    opslquant_old = opslquant;
    if ( mph_flag == PSD_ON ) {
        if (acqmode == 0)
            opslquant = opslquant_old;
        else if (acqmode == 1)
            opslquant = exist(opfphases);
    }
  
    if (maxslquanttps(&max_bamslice, (int)rhimsize, slice_size, 1, NULL) == FAILURE) {
        epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "maxslquanttps");
        return FAILURE; /* MRIhc24685: Added return Failure to avoid warnings being printed on the scan window. */
    }

    /* return opslquant to its original value */
    opslquant = opslquant_old;
  
    ta_gxwn = (-1.0)*a_gxw;
    gradx[GXWP_SLOT].num = etl/2+(iref_etl/2+iref_etl%2);
    gradx[GXWN_SLOT].num = (etl+1)/2+iref_etl/2;
    gradx[GXWN_SLOT].amp = &ta_gxwn;
    grady[GY1_SLOT].num = 1;
    grady[GY_BLIP_SLOT].num = etl - 1;
  
    if (eoskillers == PSD_ON) {
        gradx[GXK_SLOT].num = ((eosxkiller==1) ? 1 : 0);
        grady[GYK_SLOT].num = ((eosykiller==1) ? 1 : 0);
        gradz[GZK_SLOT].num = ((eoszkiller==1) ? 1 : 0);
    } else {
        gradx[GXK_SLOT].num = 0;
        grady[GYK_SLOT].num = 0;
        gradz[GZK_SLOT].num = 0;
    }
  
    grady[GY1_SLOT].ptype = G_TRAP;
    grady[GY1_SLOT].attack = &pw_gy1a;
    grady[GY1_SLOT].decay = &pw_gy1d;
    grady[GY1_SLOT].pw = &pw_gy1;

@inline BroadBand.e BBcveval
/* need 1H for AutoShim - but this is taken care of in BBPrescanS so set to specnuc here SJK */    
specparamset(&GAM, &pibbandfilt, &pixmtband, PSD_PROTON);  
@inline Prescan.e PScveval
specparamset(&GAM, &pibbandfilt, &pixmtband, specnuc);


/*jwg BBboardsRho calls for RF pulses go here*/
/*need to add calls for when se_ref = 1 and for a SE scan*/
/*If place these in pulsegen, RHO2 not set correctly*/
/*and prescan freezes up when specnuc != 1*/
BBboardsRho(acquire_type,&wg_rf1);
BBboardsFreq(acquire_type,&wg_omegarf1); /*used in EFFSLICESELZ_SPSP_JWG*/
BBboardsFreq(acquire_type,&wg_omegaro1); /*used in trapezoid call below*/
if(thetaflag == 1) 
{
	BBboardsPhase(acquire_type, &wg_phaserf1);
}	
BBboardsRho( acquire_type, &wg_rf1mps1);
BBboardsRho( acquire_type, &wg_rf2mps1);
BBboardsRho( acquire_type, &wg_rf1cfl);
BBboardsRho(acquire_type, &wg_rf0cfh);
BBboardsPhase(acquire_type, &wg_omegarf0cfh);
BBboardsRho(acquire_type, &wg_rf1cfh);
BBboardsRho(acquire_type, &wg_rf2cfh);
if( presscfh_ctrl != PRESSCFH_NONE ){ /* for presscfh_ctrl */
  BBboardsRho(acquire_type, &wg_rf3cfh);
 } 
BBboardsRho(acquire_type, &wg_rf1ftg);
BBboardsRho(acquire_type, &wg_rf2ftg);
BBboardsRho(acquire_type, &wg_rf3ftg);
BBboardsRho(acquire_type, &wg_rf1as);
/*jwg end*/  

    /* Set some MRE MEG properties */
@inline touch.e TouchEvalGrad

    /* Gradient driver and coil heating calculations */
    if (exist(opplane) != PSD_OBL) {
        gradx[GX1_SLOT].powscale = 1.0;
        gradx[GXWP_SLOT].powscale = 1.0;
        gradx[GXWN_SLOT].powscale = 1.0;
        gradx[GXK_SLOT].powscale = 1.0;
        grady[GY1_SLOT].powscale = 1.0;
        grady[GY_BLIP_SLOT].powscale = 1.0;
        grady[GYK_SLOT].powscale = 1.0;
        grady[GYKCS_SLOT].powscale = 1.0;
        grady[GYRF2IV_SLOT].powscale = 1.0;
        grady[GYK0_SLOT].powscale = 1.0;
        gradz[GZRF1_SLOT].powscale = 1.0;
        gradz[GZRF2L1_SLOT].powscale = 1.0;
        gradz[GZRF2R1_SLOT].powscale = 1.0;
        gradz[GZRF2_SLOT].powscale = 1.0;
        gradz[GZRF0_SLOT].powscale = 1.0;
        gradz[GZK_SLOT].powscale = 1.0;
        gradz[GZ1_SLOT].powscale = 1.0;
        gradz[GZMN_SLOT].powscale = 1.0;
    } else {
        gradx[GX1_SLOT].powscale = loggrd.xfs/loggrd.tx_xyz;
        gradx[GXWP_SLOT].powscale = loggrd.xfs/loggrd.tx_xy;
        gradx[GXWN_SLOT].powscale = loggrd.xfs/loggrd.tx_xy;
        gradx[GXK_SLOT].powscale = loggrd.xfs/loggrd.tx_xyz;
        grady[GY1_SLOT].powscale = loggrd.yfs/loggrd.ty_xyz;
        grady[GY_BLIP_SLOT].powscale = loggrd.yfs/loggrd.ty_xy;
        grady[GYK_SLOT].powscale     = loggrd.yfs/loggrd.ty_xyz;
        grady[GYK0_SLOT].powscale    = loggrd.yfs/loggrd.ty_xyz;
        grady[GYKCS_SLOT].powscale   = loggrd.yfs/loggrd.ty_xyz;
        grady[GYRF2IV_SLOT].powscale = loggrd.yfs/loggrd.ty_xyz;
        gradz[GZRF1_SLOT].powscale = loggrd.yfs/loggrd.tz;
        gradz[GZRF2L1_SLOT].powscale = loggrd.yfs/loggrd.tz_xyz;
        gradz[GZRF2R1_SLOT].powscale = loggrd.yfs/loggrd.tz_xyz;
        gradz[GZRF2_SLOT].powscale   = loggrd.yfs/loggrd.tz_xyz;
        gradz[GZRF0_SLOT].powscale   = loggrd.zfs/loggrd.tz_xyz;
        gradz[GZK_SLOT].powscale     = loggrd.zfs/loggrd.tz_xyz;
        gradz[GZ1_SLOT].powscale     = loggrd.zfs/loggrd.tz_xyz;
        gradz[GZMN_SLOT].powscale    = loggrd.zfs/loggrd.tz_xyz;
    }
  
 
    /* RF Pulse Scaling (to peak B1)  ************************/
    /* First, find the peak B1 for the whole sequence. */
   if (findMaxB1Seq(&maxB1Seq, maxB1, MAX_ENTRY_POINTS, rfpulse, RF_FREE) == FAILURE)
   {
   	epic_error(use_ermes,supfailfmt,EM_PSD_SUPPORT_FAILURE,EE_ARGS(1),STRING_ARG,"findMaxB1Seq");
	return FAILURE;
   }
  
    /* Throw in an extra scale factor to account for xmtadd. */
    if (setScale(L_SCAN, RF_FREE, rfpulse, maxB1[L_SCAN],
                 maxB1[L_SCAN]/maxB1Seq) == FAILURE) {
        epic_error( use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                    EE_ARGS(1), STRING_ARG, "setScale" );
        return FAILURE;
    }
  
    minseqcoil_esp = esp;     /* MRIhc16090 */ 
    /* Perform gradient safety checks for main sequence (idx_seqcore) */

    seqEntryIndex = idx_seqcore;
    if ( FAILURE == minseq( &min_seqgrad,
                            gradx, GX_FREE,
                            grady, GY_FREE,
                            gradz, GZ_FREE,
                            &loggrd, seqEntryIndex, tsamp,
                            avail_image_time,
                            use_ermes, seg_debug ) ) 
    {
        epic_error( use_ermes, "%s failed.", EM_PSD_ROUTINE_FAILURE,
                    EE_ARGS(1), STRING_ARG, "minseq" );
        return FAILURE;
    }
  
    /* RF amp, SAR, and system limitations on seq time */
    if (minseqrfamp_b1scale(&min_seqrfamp,(int)RF_FREE,rfpulse, 
                            L_SCAN) == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "minseqrfamp_b1scale");
        return FAILURE;
    }
  
    /* Note: this routine still uses the old coefficients */
    if (maxslicesar_b1scale(&max_slicesar, (int)RF_FREE,rfpulse, 
                            L_SCAN) == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "maxslicesar_b1scale");
        return FAILURE;
    }
    
    /* Calculate minimum sequence time based on coil, gradient driver,
       GRAM, pulse width modulation, RF amplifier, and playout */

  if( (PSD_XRMB_COIL != cfgcoiltype) && (PSD_XRMW_COIL != cfgcoiltype) ) 
  {    
    if( (mph_flag == PSD_ON) && ((opfphases * opslquant) > 2048) ) 
    {
        float drf = 1.0;

        drf = (-0.0009*(esp)+ 2.29)/1.25;
        if (drf < 1.0) {
            drf = 1.0;
        }

        if ( exist(opresearch) == PSD_ON ) {
            FILE *fp = NULL;

            if ((fp=fopen("/usr/g/bin/.fmri_research", "r")) !=NULL) {
                drf = 1.0;
                fclose(fp);
            }         
        } 
        fmri_coil_limit = (INT)minseqcoil_t*drf;
    } else {
        fmri_coil_limit = 0;
    }
  }
  else /* MRIhc27495: fmri_coil_limit is required only for pre XRM systems*/     
  {
	 fmri_coil_limit = 0;
  }

%ifdef RT
@inline epiRTfile.e coilAdjust_fMRI
%endif
    
    tmin_total = IMax( 5, fmri_coil_limit, min_seqgrad, min_seqrfamp, tmin , saved_tmin_total);

    printDebug( DBLEVEL1, (dbLevel_t)seg_debug, funcName, "min_seqgrad = %d\n", min_seqgrad );
    printDebug( DBLEVEL1, (dbLevel_t)seg_debug, funcName, "min_seqrfamp = %d\n", min_seqrfamp );
    printDebug( DBLEVEL1, (dbLevel_t)seg_debug, funcName, "tmin = %d\n", tmin );
    printDebug( DBLEVEL1, (dbLevel_t)seg_debug, funcName, "fmri coil limit = %d\n", fmri_coil_limit);
    printDebug( DBLEVEL1, (dbLevel_t)seg_debug, funcName, "tmin_total = %d\n", tmin_total );
    printDebug( DBLEVEL1, (dbLevel_t)seg_debug, funcName, "fps = %f\n", (float)optr/tmin_total);


    /* Used for cardiac intersequence time.  Round up to integer number of ms
     * but report to scan in us. */
    avmintseq = tmin_total;
    advroundup(&avmintseq);
    if ((exist(opcgate) == PSD_ON) && existcv(opcgate)) {
        advroundup(&tmin_total); /* this is the min seq time cardiac
                                    can run at.
                                    Needed for adv. panel validity until all 
                                    cardiac buttons exist. */
        if (existcv(opcardseq)) {
            switch (exist(opcardseq)) {
            case PSD_CARD_INTER_MIN:
                psd_tseq = avmintseq;
                tmin_total = avmintseq;
                break;
            case PSD_CARD_INTER_OTHER:
                psd_tseq = optseq;
                if (optseq > tmin_total)
                    tmin_total = optseq;
                break;
            case PSD_CARD_INTER_EVEN:
                /* Roundup tmin_total for the routines ahead. */
                advroundup(&tmin_total);
                break;
            }
        }	else {
            psd_tseq = avmintseq;
        }
    }
    other_slice_limit = IMin(2, max_slicesar, max_bamslice);
  
    if (maxphases(&av_temp_int, tmin_total, seq_type,
                  other_slice_limit) == FAILURE) {
        epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "maxphases");
        return FAILURE;
    }
  
    if (maxslquant(&av_temp_int, avail_image_time, other_slice_limit,
                   seq_type, tmin_total) == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "maxslquant");
        return FAILURE;
    }


    if (exist(opirmode) == PSD_SEQMODE_ON)
        avmaxslquant = 1;
    else {
        if (opautotr == PSD_ON)
            avmaxslquant = SLTAB_MAX;
    }

    /* YMSmr06515: # of slice locations expansion */
    if(avmaxslquant > MAX_SLICES_PER_PASS){
        avmaxslquant = MAX_SLICES_PER_PASS;
    }
  
    
%ifdef RT
    temp_maxslquant = exist(opslquant); 
%else
    temp_maxslquant = avmaxslquant; 
%endif    
    if (maxpass(&acqs,seq_type,(int)exist(opslquant), temp_maxslquant)
        == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "maxpass");
        return FAILURE;
    }
  
    if (slicein1(&slquant_per_trig, acqs, seq_type) == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "slicein1");
        slquant_per_trig =1; /* just try to get out of eval to catch
                                the problem in cvcheck */
    }
  
    if ( (mph_flag==PSD_ON) && (acqmode == 1) ) /* sequential multiphase */
        slquant_per_trig = 1;
  
    if (slquant_per_trig == 0) {
        epic_error(use_ermes,"slquant_per_trig is 0",EM_PSD_SLQUANT_ZERO,0);
        return FAILURE;
    }
  
    /*jwg bb doesn't this semm... backwards? This is why we're not getting slice incrementing, b/c it's set to 1*/
    if (seq_type == TYPXRR)
        slquant1 = opslquant;
    else
        slquant1 = slquant_per_trig;

    /* YMSmr06515: # of slice locations expansion */ 
    if ( (acqs > MAX_PASSES) && (existcv(opslquant)) )
    {
        epic_error(use_ermes,
                   "Maximum of %d acqs exceeded.  Increase locations/acq or decrease number of slices.",
                   EM_PSD_MAX_ACQS, 1, INT_ARG, MAX_PASSES);
        return FAILURE;
    }

    if ( (slquant1 > MAX_SLICES_PER_PASS) && (existcv(opslquant)) )
    {
        epic_error(use_ermes,
                   "The no. of locations/acquisition cannot exceed the max no. of per acq = %d.",
                   EM_PSD_LOC_PER_ACQS_EXCEEDED_MAX_SL_PER_ACQ, 1, INT_ARG, MAX_SLICES_PER_PASS);
        return FAILURE;
    }
  
    /* ****************************
       Calculate extra sat time
       ************************** */
    SatCatRelaxtime(acqs,(act_tr/slquant1),seq_type);
  
  
    /* Calculate inter-sequence delay time for 
       even spacing. */
    if ((exist(opcardseq) == PSD_CARD_INTER_EVEN) && existcv(opcardseq)) {
        psd_tseq = piait/slquant_per_trig;
        advrounddown(&psd_tseq);
    }
    pitseq = avmintseq; /* Value scan displays in min inter-sequence
                           display button */

    /* Set optseq to inter-seq delay value for adv. panel routines. */
    _optseq.fixedflag = 0;
    optseq = psd_tseq;
    /* Have existence of optseq follow opcardseq. */
    _optseq.existflag = _opcardseq.existflag;
  
    if (seqtime(&max_seqtime, avail_image_time, slquant_per_trig, seq_type)
        == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "seqtime");
        return FAILURE;
    }
  
    avround = 1;
    if (maxte1(&av_temp_int,max_seqtime, TYPNVEMP, non_tetime, 0)
        == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "maxte1");
        return FAILURE;
    }

%ifdef RT
    temp_slquant = exist(opslquant); /* MRIhc27295 */
%endif    
  
    if (mintr(&av_temp_int, seq_type, tmin_total*temp_slquant, slquant_per_trig,
              gating) == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "mintr");
        return FAILURE;
    }

    if( tmin_total > avmintr )
    {
        avmintr = tmin_total;
        advroundup(&avmintr);
    }

    if ( (mph_flag==PSD_ON) && (acqmode == 1) ) { /* sequential multiphase */
        acqs = exist(opslquant);
        avmaxacqs = acqs;
        avmaxslquant = 1;
    }
  
    if (touch_flag)
    {
        /* Use a minimum of 2 sec disdaq to allow the motion to get
         * to a steady state */
        dda = (int)ceil(((double)2.0s/(double)optr));
        dda = IMax(2,dda,1);
    } else {
        /* need a more elaborate algorithm here for disdaq determination */
        if (intleaves > 1) {
            /* MRIge51638 crude dda calculation   -KVA (agilandk@mr) */
            dda = (int)ceil(((double)1.5s/(double)optr));
        } else {
            dda = 0;
        }
    }

     /*jwg bb this is the scancore structure here*/
    /* Looping structure in rsp:
	   
    pass_reps
    ---------
    |
    | pass
    | --------
    | |  baseline           }
    | |  ---------          }
    | |  | reps             }
    | |  | ------           } baseline time (first pass only)
    | |  | | slices         }
    | |  | --------         }
    | |  |--------
    | |
    | |  disdaqs:           }
    | |  ileaves            }
    | |  ----------         } disdaq_shots
    | |  | slices           }
    | |  | ----------       }
    | |
    | |  cmdir_rep          }
    | |  -----------        }
    | |  | core_reps        }
    | |  | -----------      }
    | |  | |                }
    | |  | | ileaves        }
    | |  | | ----------     }
    | |  | | |              }
    | |  | | | nex          }
    | |  | | | ----------   } core_shots
    | |  | | | |            }
    | |  | | | | slices     }
    | |  | | | | ---------  }
    | |  | | | ----------   }
    | |  | | ---------      }
    | |  | ----------       }
    | |  -----------        }
    | |
    | | pass packet
    | --------
    |
    |--------
    burst mode (not supported in MGD)
     
    */
  
    passr_shots = pass_reps;
    pass_shots = acqs;
    disdaq_shots = dda;
    core_shots = intleaves; /* *core_reps */
  
    /* Add more time for the last TR of the baseline scan to fix MRIge29749. */  
    /* BJM: added additional 1 second for case below for MRIge44199. */
    if(vrgfsamp == PSD_ON && opyres >= 256) bl_acq_tr2 = 2s;	

    if (baseline > 0)
        bline_time = (baseline-1)*bl_acq_tr1 + bl_acq_tr2;
    else
        bline_time = 0;
  

    pass_time = pass_delay*num_passdelay;
  
    /* BJM MRIge50951 - fixed scan time bug w/opccsat */
    /* MRIge59645 - added bline_time to time */ 
    /*MRIhc08588 - no pass_delay after last acquisition */
    if (exist(opcgate) == PSD_ON) {
        scan_time = (float)(passr_shots*(ccs_relaxtime + pass_shots*
                                         ((float)act_tr*(float)(disdaq_shots + nex*core_shots*reps)
                                          + (float)pass_time)))-(float)pass_time;
    } else {
        int touch_ndir_tmp;
        if( touch_flag )
        {
            touch_ndir_tmp = touch_ndir;
        }
        else
        {
            touch_ndir_tmp = 1;
        }
      		/*jwg bb update scan time correctly, but use old calcs if uninitialized*/
		if (num_mets == 0 || num_frames == 0) {
	        scan_time = (float)(passr_shots*(ccs_relaxtime + pass_shots*
        	                                 ((float)(act_tr+((TRIG_LINE==gating)?TR_SLOP:0))*
                	                          (float)(disdaq_shots + nex*core_shots*reps*touch_ndir_tmp)
                        	                  + (float)pass_time)))-(float)pass_time;
		} else {
		/* passr_shots should be # of timeframes, pass_shots is equals to acqs, or # of slices * num_mets*/
		/* but remember that only play out opsldelay (pass_time) once all num_mets are run! */
	        scan_time = (float)(num_frames*(ccs_relaxtime + pass_shots*num_mets*
        	                                 ((float)(act_tr+((TRIG_LINE==gating)?TR_SLOP:0))*
                	                          (float)(disdaq_shots + nex*core_shots*reps*touch_ndir_tmp)
                        	                  + (float)pass_time/num_mets)))-(float)pass_time;	
	
	}
    }

%ifdef RT
    /* Calculate scan time for epiRT */
@inline epiRTfile.e scanTime
%endif

    if(baseline > 0)
        scan_time = scan_time + bline_time*acqs;

    avmintscan = scan_time;
    pitscan = avmintscan; /* This value shown in clock */
    pisctim1 = pitscan; 

    nreps = pass_reps*acqs*(dda + (nex + dex)*intleaves*reps);
    nreps *= ((rawdata == PSD_ON && rhref == 1) ? 2 : 1);
  
    /* set effective Ky samp freq in KHz */
    if (esp > 0) {
        if ((fract_ky == PSD_FULL_KY) && (ky_dir==PSD_CENTER_OUT)) {
            /* Ky sampling freq peak (KHz)*/
            frqy = 1000.0*(float)(intleaves/2)/(float)esp;
            eesp = rint((float)esp/(float)(intleaves/2));
        } else {
            /* Ky sampling freq peak (KHz)*/
            frqy = 1000.0*(float)(intleaves)/(float)esp;
            eesp = rint((float)esp/(float)intleaves);
        }
       
    } else {
        frqy = 0;
        eesp = 0;
    }

    /*Kx sampling freq peak (KHz) */
    frqx = 1000.0/tsp;

    if (b0calmode == 1)
        slice_reset = 1;
    else
        slice_reset = 0;
  
#if defined(RT) && defined(LIM_PROTOCOLS)
    if (lim_protocol() == FAILURE) {
        /* don't send ermes so that underlying ermes will be displayed */
        return FAILURE;
    }

#endif
    
    if( touch_flag )
    {
        pipauval2 = 0;
        pipauval3 = 1;
        pipauval4 = 2;
        pipauval5 = 3;
        pipauval6 = 4;

        pipaunub = acqs * pass_reps;
        if( pipaunub > 6 )
        {
            pipaunub = 6;
        }
        if( touch_flag )
        {
            pitslice = pitscan / (acqs * pass_reps);
            pisctim2 = pitscan;
            pisctim3 = pipauval3 * pitscan / (acqs * pass_reps);
            pisctim4 = pipauval4 * pitscan / (acqs * pass_reps);
            pisctim5 = pipauval5 * pitscan / (acqs * pass_reps);
            pisctim6 = pipauval6 * pitscan / (acqs * pass_reps);
        }
    }
    else
    {
        pipaunub = 0;
    }
    
    return SUCCESS;
  
} /* end cveval1 */

@inline ss.e ssEval

%ifdef RT
@inline epiRTfile.e limProtocolFunc
%endif

/* BJM - SE Ref Scan */
@inline refScan.e epiRefScanTeCalc

#ifdef __STDC__ 
STATUS avmintecalc( void )
#else /* !__STDC__ */
    STATUS avmintecalc()
#endif /* __STDC__ */
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
        epic_error(use_ermes, supfailfmt, EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "amppwtpe");
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

    if (exist(oppseq) == PSD_SE)
        avminssp = pw_rf2/2 + rfupd + 8us + pw_wssp + tdaqhxatemp;
    else                         /* gradient echo */
        avminssp = rfExIso + rfupd + 8us + pw_wssp + tdaqhxatemp;
    
    avminssp = avminssp + HSDAB_length;
    if (xtr_offset == 0) {
        avminssp = avminssp + (XTRSETLNG + XTR_length[PSD_XCVR2]);
    } else {
        avminssp = avminssp + xtr_offset;
    }
    if (touch_flag)
    {
        avminssp += (multi_phases - 1.) * touch_delta + cont_drive_ssp_delay;
    }
    
    if (exist(oppseq) == PSD_SE)
        avminssp *= 2;    
 
    /* Use MRE information to update TE-related values */
@inline touch.e TouchTECalc

    if (exist(oppseq) == PSD_SE) {
        if (gx1pos == PSD_POST_180) {
            avminxa = 2*(rfExIso);
            avminxb = 2*(tdaqhxatemp + pw_wgx + pw_rf2/2 +
                         IMax(3, pw_gx1_tot, (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0),pw_gzrf2r1_tot));

            if (touch_flag)
            {
                if (meg_mode == 0) {
                    /* Add time for flow comp gradient and MR-Touch gradients and delay */
                    avminxa = avminxa + 2*(pw_gzrf1d + pw_gz1_tot + pw_gzrf2l1_tot + touch_time);
                } else {
                    avminxa = avminxa + 2*(pw_gzrf1d + pw_gz1_tot + touch_time + rf2_time/2);
                    avminxb = 2*(tdaqhxatemp + pw_wgx + rf2_time/2 + touch_time +
                                 IMax(3, pw_gx1_tot, (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0), 0*pw_gzrf2r1_tot));
                }
            }
        } else {
            avminxa = 2*(rfExIso);
            avminxb = 2*(tdaqhxatemp + pw_wgx + pw_rf2/2);

            if (touch_flag) {
                if (meg_mode == 0) {
                    avminxa = avminxa + 2*(pw_gzrf1d + pw_gz1_tot + pw_gzrf2l1_tot + touch_time + pw_gx1_tot);
                } else {
                    avminxa = avminxa + 2*(pw_gzrf1d + pw_gz1_tot + touch_time + rf2_time/2 + pw_gx1_tot);
                    avminxb = 2*(tdaqhxatemp + pw_wgx + rf2_time/2 + touch_time);
                }
            }
        }

        if(rtb0_flag)
        {
            avminxa += 2*(IMax(2, pw_gz1_tot, rfupd+4us+rtb0_minintervalb4acq) + esp + rtb0_acq_delay);
        }
        
        avminx  = (avminxa>avminxb) ? avminxa : avminxb;
      
        if (gy1pos == PSD_POST_180) {
            avminya = 2*(rfExIso);

            /* internref */
            avminyb = 2*(pw_rf2/2 + pw_wgy + tdaqhxatemp + pw_gxwad +
                         IMax(3,pw_gx1_tot,(pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0),pw_gzrf2r1_tot));
            if (touch_flag) {
                if (meg_mode == 0) {
                    avminya = 2*(rfExIso + pw_gzrf1d + pw_gz1_tot + pw_gzrf2l1_tot + touch_time);
                    avminyb = 2*(pw_rf2/2 + pw_wgy + tdaqhxatemp + pw_gxwad +
                                 IMax(3, pw_gx1_tot, (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0), pw_gzrf2r1_tot));
                } else {
                    avminya = 2*(rfExIso + pw_gzrf1d + pw_gz1_tot + touch_time + rf2_time/2);
                    avminyb = 2*(rf2_time/2 + touch_time + pw_wgy + tdaqhxatemp + pw_gxwad +
                                 IMax(3, pw_gx1_tot, (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0), 0*pw_gzrf2r1_tot));
                }
            }
        } else {
            avminya = 2*(rfExIso);
            avminyb = 2*(pw_rf2/2 + pw_gxwad + IMax(2, pw_gx1_tot, pw_gzrf2r1_tot));
            if (touch_flag) {
                if (meg_mode == 0) {
                    avminya = 2*(rfExIso + pw_gzrf1d + pw_gz1_tot + pw_gzrf2l1_tot + touch_time + pw_gy1_tot + pw_wgy);
                    avminyb = 2*(pw_rf2/2 + pw_gxwad + IMax(2, pw_gx1_tot, pw_gzrf2r1_tot));
                } else {
                    avminya = 2*(rfExIso + pw_gzrf1d + pw_gz1_tot + touch_time + rf2_time/2 + pw_gy1_tot + pw_wgy);
                    avminyb = 2*(rf2_time/2 + touch_time + pw_gxwad + IMax(2, pw_gx1_tot, 0*pw_gzrf2r1_tot));
                }
            }  
        }

        if(rtb0_flag)
        {
            avminya += 2*(IMax(2, pw_gz1_tot, rfupd+4us+rtb0_minintervalb4acq) + esp + rtb0_acq_delay);
        }

        avminy  = (avminya>avminyb) ? avminya : avminyb;

        avminza = 2*(rfExIso + pw_gzrf1d + pw_gz1_tot + pw_gzrf2l1_tot + (pw_rf2/2));
        avminzb = 2*(8us + (pw_rf2/2) + tdaqhxatemp + pw_wgz +
                     IMax(3,pw_gx1_tot,(pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0),pw_gzrf2r1_tot));
        if (touch_flag) {
            if (meg_mode == 0) {
                avminza = 2*(rfExIso + pw_gzrf1d + pw_gz1_tot + pw_gzrf2l1_tot + touch_time + (pw_rf2/2));
                avminzb = 2*(8us + (pw_rf2/2) + tdaqhxatemp + pw_wgz +
                             IMax(3, pw_gx1_tot, (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0), pw_gzrf2r1_tot));
            } else {
                avminza = 2*(rfExIso + pw_gzrf1d + pw_gz1_tot + touch_time + (rf2_time/2));
                avminzb = 2*(8us + (rf2_time/2) + touch_time + tdaqhxatemp + pw_wgz +
                             IMax(3, pw_gx1_tot, (pw_gymn1_tot + pw_gymn2_tot + pw_gy1_tot)*(iref_etl==0), 0*pw_gzrf2r1_tot));
            }
        }

        if(rtb0_flag)
        {
            avminza += 2*(IMax(2, pw_gz1_tot, rfupd+4us+rtb0_minintervalb4acq) + esp + rtb0_acq_delay - pw_gz1_tot);
        }

        avminz  = (avminza>avminzb) ? avminza : avminzb;
        
    } else {  /* Gradient echo */
        if (touch_flag) {
            avminx  = rfExIso + pw_gzrf1d + touch_time + pw_gz1_tot + (pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot)*(iref_etl==0) + (pw_gx1a + pw_gx1 + pw_gx1d) + tdaqhxatemp + pw_wgx;
            avminy = rfExIso + pw_gzrf1d + touch_time + pw_gz1_tot + (pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot)*(iref_etl==0) + (pw_gx1a + pw_gx1 + pw_gx1d) + pw_wgy + tdaqhxatemp;
            avminz = rfExIso + pw_gzrf1d + touch_time + pw_gz1_tot + (pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot)*(iref_etl==0) + (pw_gx1a + pw_gx1 + pw_gx1d) + pw_wgz + tdaqhxatemp;
        } else {
            avminx = rfExIso + pw_gx1a + pw_gx1 + pw_gx1d + tdaqhxatemp + pw_wgx;
            avminy = rfExIso + (pw_gy1_tot + pw_gymn1_tot + pw_gymn2_tot)*(iref_etl==0) + pw_wgy + tdaqhxatemp;
            avminz = rfExIso + pw_gzrf1d + pw_gz1_tot + pw_wgz + tdaqhxatemp;
        }

        if(rtb0_flag)
        {
            avminx += IMax(2, pw_gz1_tot, rfupd+4us+rtb0_minintervalb4acq) + esp + rtb0_acq_delay;
            avminy += IMax(2, pw_gz1_tot, rfupd+4us+rtb0_minintervalb4acq) + esp + rtb0_acq_delay;
            avminz += IMax(2, pw_gz1_tot, rfupd+4us+rtb0_minintervalb4acq) + esp + rtb0_acq_delay - pw_gz1_tot;
        }
    }

    avmintetemp = ((avminy>avminz) ? avminy : avminz);
    avmintetemp = ((avminx>avmintetemp) ? avminx : avmintetemp);
    avmintetemp = ((avminssp>avmintetemp) ? avminssp : avmintetemp);
    
    return SUCCESS;
}

#ifdef __STDC__ 
STATUS nexcalc( void )
#else /* !__STDC__ */
    STATUS nexcalc()
#endif /* __STDC__ */
{ 
    /* This is a similar set of codes as the Nex bookkeeping section, except
       that all the checks have been removed because they have already been
       done once when this routine is called. */

    if (fract_ky == PSD_ON)
        fn = 0.5;
    else
        fn = 1.0;
  
    nop = 1;
  
    nex = IMax(2,(int) 1,(int)(exist(opnex)/nop));
  
    /* nex buttons */
    pinexnub = 63;
    pinexval2 = 1;
    pinexval3 = 2;
    pinexval4 = 3;
    pinexval5 = 4;
    pinexval6 = 8;
    return  SUCCESS;
  
}

#ifdef __STDC__ 
STATUS setb0rotmats( void )
#else /* !__STDC__ */
    STATUS setb0rotmats()
#endif /* __STDC__ */
{
    int slice, n;
    for (slice=0; slice<3; slice++) {
        for (n=0; n<9; n++)
            scan_info[slice].oprot[n] = 0.0;
    }
  
    /* 1st slice (1st in time order) is an axial */
    scan_info[0].oprot[0] = 1.0; /* readout on physical X */
    scan_info[0].oprot[4] = 1.0; /* blips on physical Y */
    scan_info[0].oprot[8] = 1.0; /* slice on physical Z */
  
    /* 2nd slice (3rd in time order) is a saggital */
    scan_info[1].oprot[3] = 1.0; /* readout on physical Y */
    scan_info[1].oprot[7] = 1.0; /* blips on physical Z */
    scan_info[1].oprot[2] = 1.0; /* slice on physical X */
  
    /* 3rd slice (2nd in time order) is a coronal */
    scan_info[2].oprot[6] = 1.0; /* readout on physical Z */
    scan_info[2].oprot[1] = 1.0; /* blips on physical X */
    scan_info[2].oprot[5] = 1.0; /* slice on physical Y */
  
    /* new geometry info! */
    opnewgeo = 1;
  
    return SUCCESS;
}

/* Add function for more robust resolution selection */
@inline touch.e TouchMatrixCheck
@inline Inversion.e InversionCheck

/***********************************************************************/
/* CVCHECK                                                             */
/***********************************************************************/
STATUS
#ifdef __STDC__ 
cvcheck( void )
#else /* !__STDC__ */
    cvcheck() 
#endif /* __STDC__ */
{

    int temp_int;
    
    /* Check for EPI Imaging Option */    
    if (exist(opepi) != PSD_ON) {
        epic_error(use_ermes,
                   "The EPI option is not supported in this scan.", EM_PSD_EPI_INCOMPATIBLE, 0);
        return FAILURE;
    }

    /* YMSmr06515, YMSmr06769 May 2005 KK */
    if (exist(opslquant) > MAXSLQUANT_EPI){
        epic_error( use_ermes, "The number of scan locations selected must be reduced to %d for the current prescription.",
                    EM_PSD_SLQUANT_OUT_OF_RANGE, 1, INT_ARG, MAXSLQUANT_EPI);
        return FAILURE; 
    } 
    
    /* Prescription Level Checks */
    /* Check if the number of opshots are greater than opyres. */
    if ( (existcv(opnex)!=PSD_OFF) && ( (exist(opnshots)) > (exist(opyres)) ) ) {
        epic_error((int)0,
                   "Number of shots must be less than or equal to phase encode lines.",
                   EM_PSD_SUPPORT_FAILURE, 1, STRING_ARG,
                   "Number of shots must be less than or equal to phase encode lines.");
        avminnshots= exist(opyres);
        return ADVISORY_FAILURE;
    }
    
    /* Check if the selected yres is compatible with the chosen opnshots and te */
    if ( (existcv(opnex)!=PSD_OFF) && ((rhnframes + rhhnover) % exist(opnshots) != 0) ) {
        temp_int = exist(opyres)/exist(opnshots);
        if ( (temp_int % 2) == 1) 
            temp_int +=1;
        newyres = temp_int*exist(opnshots);

        {
            int temp_yres, temp_frames, calc_sign, icount, max_count;

            max_count = IMax(2, (newyres - avminyres)/2, (avmaxyres - newyres)/2);

            for (icount=0; (icount<=max_count*2); icount++){

                calc_sign = 1 - 2*(icount%2);
                temp_yres = newyres + 2*calc_sign*(icount/2);

                if ((temp_yres >= avminyres) && (temp_yres <= avmaxyres)){
                    if(num_overscan > 0) {
                         temp_frames = (short)(ceilf((float)temp_yres*asset_factor/rup_factor)*rup_factor*fn*nop - ky_offset);
                    } else {
                         temp_frames = (short)(ceilf((float)temp_yres*asset_factor/rup_factor)*rup_factor*fn*nop);
                    }
                    if (((temp_frames + rhhnover) % 2 == 0) &&
                        ((temp_frames + rhhnover) % exist(opnshots) == 0)){
                        newyres = temp_yres;
                        break;
                    }
                }
            }
        }

        epic_error((int)0,
                   "Combination of opnshots and opyres incompatible try opyres of %d.",
                   EM_PSD_SUPPORT_FAILURE, 1, INT_ARG, newyres,
                   "Combination of opshots and opyres incompatible.");
        /* 4/21/96 RJL - Event handler for this error to get choice into popup. This handler
           forces yres to appear with this desired value in the popup */
        avminyres = newyres;
        avmaxyres = newyres;
        return ADVISORY_FAILURE;
    }
    
    /*MRIge42072*/ /*MRIge61054*/ 
    if ( exist(opsquare)==PSD_OFF &&  exist(opphasefov)<0.5) {
        epic_error( use_ermes,"The phasefov is out of range for the current prescription.",
                    EM_PSD_SUPPORT_FAILURE,1, FLOAT_ARG, avminphasefov);
        avminphasefov = 0.5;
        return ADVISORY_FAILURE;
    }
    
    if ( exist(opsquare)==PSD_OFF && exist(opphasefov)>1.0) {
        epic_error( use_ermes,"The phasefov is out of range for the current prescription.",
                    EM_PSD_SUPPORT_FAILURE,1,FLOAT_ARG,avmaxphasefov);
        avmaxphasefov = 1.0;
        return ADVISORY_FAILURE;
    }
    
    if ( (rhnframes + rhhnover)%2 != 0 ) {
        epic_error(use_ermes, 
                   "Illegal combination of phase encode lines, no. of shots, and fract/full TE.",
                   EM_PSD_EPI_ILLEGAL_NFRAMES, 0);
        return FAILURE;
    }
    
    if ((exist(opte) < (float)avminte) && existcv(opte)) {
	epic_error(use_ermes," Minimum TE is %-d ms ",
                   EM_PSD_TE_OUT_OF_RANGE3, 1, INT_ARG, (int)ceil((double)avminte/1000.0));
	return ADVISORY_FAILURE;
    }
    
    if ((exist(oprbw) > avmaxrbw) && existcv(oprbw)) {
        epic_error( use_ermes,"Decrease oprbw to %f.",
                    EM_PSD_MAX_RBW1, 1, FLOAT_ARG, avmaxrbw );
        return ADVISORY_FAILURE;
    }  
    

    if ((exist(opfov) < avminfov) && existcv(opfov)) {
        epic_error( use_ermes,"Minimum FOV is %-f cm ",
                    EM_PSD_FOV_OUT_OF_RANGE, 1, FLOAT_ARG, avminfov / 10.0 );
        return ADVISORY_FAILURE;
    }  
    
    if (existcv(oprbw) && (exist(oprbw) < avminrbw)) {
        epic_error( use_ermes, "Increase oprbw to %f.",
                    EM_PSD_MIN_RBW1, 1, FLOAT_ARG, avminrbw );
        return ADVISORY_FAILURE;
    }
    
    if ((exist(opfov) > avmaxfov) && existcv(opfov)) {
        epic_error( use_ermes,"Maximum FOV is %-f cm ",
                    EM_PSD_FOV_OUT_OF_RANGE2, 1, FLOAT_ARG, avmaxfov / 10.0 );
        return ADVISORY_FAILURE;
    }
   
    if( existcv(opxres) && exist(opxres) < avminxres ) {
        epic_error( use_ermes, "The frequency encoding steps must be increased to %d for the current prescription.", EM_PSD_XRES_OUT_OF_RANGE2, EE_ARGS(1), INT_ARG, avminxres );
        return ADVISORY_FAILURE;
    }
    if( existcv(opxres) && exist(opxres) > avmaxxres ) {
        epic_error( use_ermes, "The frequency encodings must be decreased to %d for the current prescription.", EM_PSD_XRES_OUT_OF_RANGE, EE_ARGS(1), INT_ARG, avmaxxres );
        return ADVISORY_FAILURE;
    }

    if (existcv(opxres) && (exist(opxres) % 2) != 0) {
        epic_error(use_ermes, "This XRES selection is not valid.", EM_PSD_EPI_XRES_INVALID, 0);
        return FAILURE;
    }

    /* MRIhc56388: rhfrsize limit for dynamic phasce correction */
    if( iref_etl>0 && existcv(opxres) && rhfrsize > MAXFRAMESIZE_DPC) {
        epic_error(use_ermes, "XRES is out of range",
                   EM_PSD_CV_OUT_OF_RANGE, EE_ARGS(1), STRING_ARG, "XRES");
        return FAILURE;
    }
    
    if( exist(opsquare)==PSD_ON  && existcv(opxres) && existcv(opyres) && (exist(opyres) > exist(opxres))) {
        epic_error(use_ermes, "This YRES cannot be achieved with current prescription",
                   EM_PSD_YRES_OUT_OF_RANGE, 1, INT_ARG, avmaxyres);
        avmaxyres = exist(opxres);
        return ADVISORY_FAILURE;
    }
    
    if( exist(opsquare)==PSD_ON  && existcv(opxres) && existcv(opyres) && 
        (exist(opyres) < exist(opxres)*avminphasefov)) {
        epic_error(use_ermes, "This YRES cannot be achieved with current prescription",
                   EM_PSD_YRES_OUT_OF_RANGE, 1, INT_ARG, avminyres);
        avminyres = exist(opxres)/2;
        return ADVISORY_FAILURE;
    }
    
    if (existcv(opyres) && (exist(opyres) % 2) != 0) {
        strcpy(estr, " The acquisition matrix size in phase (y resolution) must be even for EPI ");
        epic_error(use_ermes, estr, EM_PSD_EPI_YRES_MUST_BE_EVEN, EE_ARGS(0));
        return FAILURE; 
    }
    
    if(existcv(opnex) && (exist(opnex) ==0.0 )) {
        epic_error(use_ermes, "Improper NEX selected", EM_PSD_NEX_OUT_OF_RANGE, 0);
        return FAILURE ;
    } /*** RJF , MRIge41464 **/
    
    if ( exist(opnex) - (INT)(exist(opnex)) != 0 ) {
	strcpy(estr, "Fractional NEX is not allowed with this scan.");
	epic_error(use_ermes, estr, EM_PSD_FNEX_INCOMPATIBLE, EE_ARGS(0));
	avminnex = 1.0;
	avmaxnex = 1.0;
	return ADVISORY_FAILURE; 
    }
    
    if ( (exist(opcgate)==PSD_ON) && (mph_flag==PSD_ON) && (exist(opacqo)==1) ) {
        sprintf(estr,"The sequential multiphase and cardiac gating options are not compatible for epi. ");
        epic_error(use_ermes, estr, EM_PSD_EPI_SEQMPH_CGATE_INCOMPATIBLE, 1, STRING_ARG,
                   "The sequential multiphase and cardiac gating options are not compatible for epi. ");
        return FAILURE;
    }

    if  ((exist(opnshots) > touch_maxshots) && (exist(optouch) == PSD_ON))  {
        epic_error( use_ermes, "%s is incompatible with %s.", EM_PSD_INCOMPATIBLE, EE_ARGS(2), STRING_ARG, "MR-Touch", STRING_ARG, "Multi-Shot EPI)" );
        return FAILURE;                              
    }
     
    if (ygmn_type == CALC_GMN1 && gy1pos == PSD_PRE_180) {
	sprintf(estr, " gy1 pulse pos for fcomp. ");
        epic_error(use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, " gy1 pulse pos for fcomp. ");
	return FAILURE;
    }
    
    if (SpSatCheck() == FAILURE) return FAILURE;
    
    /* check for slice thickness */
    if( existcv(opslthick) && (exist(opslthick) < avminslthick) ) 
    {
        epic_error(use_ermes, "Increase the slice thickness to %2f mm", 
                   EM_PSD_SLTHICK_OUT_OF_RANGE, EE_ARGS(1), FLOAT_ARG, avminslthick);
        return ADVISORY_FAILURE;
    }      

    /* MRIge56926 - Removed calculation of avminslthick from inside error conditions */
    if (a_gzrf1 > loggrd.tz) {
        epic_error(use_ermes, "Increase the slice thickness to %2f mm",
                   EM_PSD_SLTHICK_OUT_OF_RANGE, EE_ARGS(1),
                   FLOAT_ARG, avminslthick);
	return ADVISORY_FAILURE;
    }
    
    if (a_gzrf2 > loggrd.tz) {
        epic_error(use_ermes, "Increase the slice thickness to %2f mm",
                   EM_PSD_SLTHICK_OUT_OF_RANGE, EE_ARGS(1),
                   FLOAT_ARG, avminslthick);
	return ADVISORY_FAILURE;
    }
    
    
    /*
     * dB/dt error checks
     */
    /* JAH: MRIge57700 -- only check this when opfov exists, the error should be
       caught more meaningfully when there is a real FOV */
    if ((pidbdtts > cfdbdtts) && (cfdbdtts > 0.0)) {
        epic_error( use_ermes,
                    "Stimulation threshold exceeded (T/s).",
                    EM_PSD_EPI_DBDTTS, 0 );
        printf( "\ndB/dt value of %f T/s exceeds limit of %f T/s\n",
                pidbdtts, cfdbdtts );
        return FAILURE;
    }
    
    if ((pidbdtper > cfdbdtper) && (cfdbdtper > 0.0)) {
        epic_error( use_ermes,
                    "Stimulation threshold exceeded (%%).",
                    EM_PSD_EPI_DBDTPER, 0 );
        printf( "\ndB/dt value of %f percent exceeds limit of %f percent\n",
                pidbdtper, cfdbdtper );
        return FAILURE;  
    }
    
    
    if ( (exist(opxres) > 256) && (vrgfsamp == PSD_ON) ) {
        strcpy(estr, "xres greater than 256 and ramp sampling are not compatible. ");
        epic_error(use_ermes, estr, EM_PSD_EPI_RAMPSAMP_XRES, 0);
        return FAILURE; 
    }
    
    if ( (cffield == B0_5000) && (exist(opfat) !=  PSD_ON) ) {
        strcpy(estr, " Fat suppression must be selected with 0.5T epi. ");
        epic_error(use_ermes, estr, EM_PSD_EPI_HALFT_NOFATSAT, 0);
        return FAILURE; 
    }
    
    /* The number of passes in mph should not excceed max_num_pass. MRIge32615 ypd */
    if( mph_flag == PSD_ON ) {
        if ( existcv(opfphases) && (exist(opfphases) > max_num_pass*SLICE_FACTOR) ) {
            epic_error(use_ermes,"The maximum number of phases is %-d",
                       EM_PSD_NUM_PASS_OUT_OF_RANGE, 1, INT_ARG, max_num_pass);
            return FAILURE;
        }

        if ( existcv(opslquant) && existcv(opfphases) && ((opfphases) > PHASES_MAX) ) {
            epic_error(use_ermes,
                       "Maximum number of phases exceeded, reduce # of slices or phases", EM_PSD_MAXPHASE_EXCEEDED,0);
            return FAILURE;
        }

        if ( existcv(opslquant) && existcv(opfphases) && 
                ((opfphases * opslquant * opphases) > max_slice_limit) ) {
            epic_error(use_ermes, "The number of locations * phases has exceeded %d.", 
                    EM_PSD_SLCPHA_OUT_OF_RANGE ,EE_ARGS(1),INT_ARG,max_slice_limit);

            return FAILURE;
        }

        /* Limit of 256 slices per pass - only a limit for sequential (opacqo = 1) mph */
	if ( existcv(opfphases) && (exist(opfphases) && (exist(opacqo) == 1) > MAXSLQUANT2D) ) {
            epic_error(use_ermes,"The maximum number of phases is %-d",
                       EM_PSD_NUM_PASS_OUT_OF_RANGE, 1, INT_ARG, max_num_pass);
            return FAILURE;
        }

        /* YMSmr06515: # of slice locations expansion -  Limit rhnpasses to MAX_PASSES (=1024) */
        if ( existcv(opfphases) && (exist(opacqo) == 0) && ( (pass_reps * acqs) > MAX_PASSES ) ) { 
            epic_error (use_ermes, "The maximum number of phases is %-d", 
                        EM_PSD_NUM_PASS_OUT_OF_RANGE, 1, INT_ARG, (MAX_PASSES/acqs));
            return FAILURE;
        }

        /*MRIhc00610 -Venkat, Limit phases to 256, for sequential multiphase */ /* YMSmr06515 */
        if ( existcv(opfphases) && (exist(opacqo) == PSD_ON) && (opfphases > MAX_SLICES_PER_PASS) ) { 
            epic_error (use_ermes, "The maximum number of phases is %-d", 
                    EM_PSD_NUM_PASS_OUT_OF_RANGE, 1, INT_ARG, (MAX_SLICES_PER_PASS));


            return FAILURE;
        }
    }
    
    if ( (exist(opnshots) == exist(opyres)) && (exist(opautote) == 2) ) {
        epic_error(use_ermes,
                   "# of Phases should exceed # of shots if Minimum TE is selected",
                   EM_PSD_EPI_NSHOTS_YRES_INCOMPATIBLE2, 0);
        return FAILURE;
    }
    
    /* YMSmr07177 */
    if ((opsldelay < (float)avminsldelay) && existcv(opsldelay)) { 
        epic_error( use_ermes, "%s is out of range.", EM_PSD_CV_OUT_OF_RANGE, EE_ARGS(1), STRING_ARG, "Delay After Acq" );
	return FAILURE;
    }

    /* YMSmr06685, YMSmr07177 */
    if ((opsldelay > (float)avmaxsldelay) && existcv(opsldelay)) {
        epic_error( use_ermes, "%s is out of range.", EM_PSD_CV_OUT_OF_RANGE, EE_ARGS(1), STRING_ARG, "Delay After Acq" );
        return FAILURE;
    } 
    
    if (nshots_locks == PSD_ON) {
        if ( exist(opnshots) < min_nshots ) {
            epic_error(use_ermes,
                       "The minimum number of shots for this protocol is %d.", EM_PSD_EPI_MIN_NSHOTS, 1, INT_ARG, avminnshots);
            return ADVISORY_FAILURE; 
        }
    }
    
 
    {
        int status_flag;

        /* Ensure that the coverage and slice thickness are */
        /* supported by the sp-sp pulse */
        status_flag = ssCheck();
        if (status_flag != SUCCESS) return status_flag;
    
        /* Check epi compatibility with Imaging Options */
        status_flag = checkEpiImageOptions();
        if (status_flag != SUCCESS ) return status_flag;
    
        /* Throw warning if cal files are missing */
        status_flag = epiCalFileCVCheck();
        if(status_flag != SUCCESS) return status_flag;
    }   

    /* MRIge92386 */
@inline Asset.e AssetCheck     /* Asset */
    
%ifdef RT
    /* Include epiRT Error Checks */
@inline epiRTfile.e epiRTErrorCheck
%endif

    if (ss_fa_scaling_flag && (cfgcoiltype == PSD_XRMB_COIL || cfgcoiltype == PSD_XRMW_COIL) && 
        (ss_rf1 == PSD_ON) && (exist(oppseq) == PSD_GE))
    {
        if((existcv(opflip) == PSD_ON) && (exist(opflip) > avmaxflip)) 
        {
            strcpy(estr, "%s is out of range");
            epic_error(use_ermes,estr,EM_PSD_CV_OUT_OF_RANGE, EE_ARGS(1), STRING_ARG, "Flip angle");
            return ADVISORY_FAILURE;
        }
    }

    return SUCCESS;
  
} /* end CVCHECK */

@inline ss.e ssCheck

@inline RTB0.e RTB0init

/*
 *  predownload
 *  
 *  Type: Public Function
 *  
 *  Description:
 *  
 */
STATUS
predownload( void )
{
    int off_index;   /* loop index */
    int i, j;     /* counters */
    int sloff;
    int acq_off;
    
    fprintf(stderr,"At top of predownload, pw_gyb and a_gyb are %d and %f \n",pw_gyb,a_gyb);
    if(epigradopt_output) printEpigradoptResult();

@inline vmx.e PreDownLoad 

    /* To avoid side effects, set pitfeextra before loadrheader */
     pitfeextra = 0; 

    /* Recon variables */
@inline loadrheader.e rheaderinit

    /* MRIge92386 */
@inline Asset.e AssetSetRhVars

%ifdef RT

@inline epiRTfile.e setRhVarsfMRI

%endif

  /*jwg adding more BB stuff*/
    if ((acquire_type == SPECPSD_MASTER_H1)
        || (acquire_type == SPECPSD_MASTER_MNS)){
        rfconf = (ENBL_RHO1 | ENBL_THETA | ENBL_OMEGA
                  | ENBL_OMEGA_FREQ_XTR1 | ENBL_THETA_PHASE_XTR1);
    } else {
        rfconf = (ENBL_RHO2 | ENBL_THETA | ENBL_OMEGA
                  | ENBL_OMEGA_PHASE_XTR2 | ENBL_THETA_FREQ_XTR2);
    }    

    /* > 1024 im/ser -Venkat
     * rhformat(14th bit) : 0=Normal 1=Multiphase scan
     * rhmphasetype       : 0=Int MPh 1=Seq Mph
     * rhnphases          : No of phases in a multiphase scan
     */
    if ( enable_1024 )
    {
        rhformat |= RHF_SINGLE_PHASE_INFO;

        if (opacqo == PSD_OFF) 
        {
            rhmphasetype = 0; /* Interleaved multiphase*/
        }
        else
        {
            rhmphasetype = 1; /* sequential multiphase*/
        }

        rhnphases = exist(opfphases); /* No of phases in a multiphase scan*/
    }
    else
    {
        rhformat &= ~RHF_SINGLE_PHASE_INFO;
        rhnphases = 1; /* MRIhc35883 MRIhc36882*/
    }


    /* Now set it for fract ky annotation */ 
     pitfeextra = fract_ky; 

    /******************************
      Slice Ordering
    ****************************/
    if (rotateflag == PSD_ON) {
        rotatescan();
    }
    else if (exist(use_myscan)==1) {
        myscan();
    }

    if (exist(opslquant) == 3 && b0calmode == 1)
    {
	setb0rotmats();
    }

    if (slice_reset == 1)
    {
	for (off_index=0;off_index<opslquant;off_index++)
        {
            scan_info[off_index].optloc = slice_loc;
        }
    }
  
    if (scan_offset != 0 )
    {
	for (off_index=0;off_index<opslquant;off_index++)
        {
            scan_info[off_index].optloc += (float)scan_offset;
        }
    }
  
    if (debug_scan)
    {
        psd_dump_scan_info();
    }

    order_routine = seq_type;

    if( opslice_order == PSD_OFF) {
        order_routine = TYPNORMORDER;
    }

    if (orderslice(order_routine, opslquant, slquant1, gating) == FAILURE)
    {
        epic_error( use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                    EE_ARGS(1), STRING_ARG, "orderslice" );
	return FAILURE;
    }

    /* Value1.5T May 2005 KK */
    if(ghost_check&&gck_offset_fov)
        rsp_info[0].rspphasoff = opfov/4.0;

    /* BJM - MRIge50915: add TYPCAT for opccsat scans */    
    if ( (order_routine == TYPNCAT || order_routine == TYPCAT || order_routine == TYPNORMORDER) && opfphases > 1 )
    {
	acq_off = reps*slquant1;

	if (acqmode == 0)  /* interleaved */
	{
            /*Venkat > 1024 im/ser */
            /* do nothing ! */
	} /* end if interleaved */
        else if (acqmode == 1)  /* sequential */
	{
            for (i=0; i<acqs; i++)  /* slices loop */
            {
                /*Venkat > 1024 im/ser*/
                for (j=0; j<1; j++)
                {
                    sloff = i;
                    data_acq_order[sloff].slloc = i;
                    data_acq_order[sloff].slpass = i;
                    data_acq_order[sloff].sltime = j;
                }
            }
	} /* end if sequential */
    }
    else if ( pass_reps > 1 ) {
        /* Cardiac gated multi-reps */ 
        /* do nothing ! */
    } /* if pass_reps > 1 */
       

    if (debug_order)
    {
	printf("\nslloc\tslpass\tsltime\t\n");
	for (i = 0; i < opslquant*opphases; i++)
        {
            printf("%d\t%d\t%d\n",data_acq_order[i].slloc,
                   data_acq_order[i].slpass,
                   data_acq_order[i].sltime);
	}
    }
    fflush(stdout);

    trig_scan = gating; 
  
    if (debug_scan)
    {
        psd_dump_rsp_info();
    }

    /* Saved unscaled version of rotation matrices */
    for ( i = 0 ; i < (opslquant * opphases) ; i++ )
    {
        if (obl_debug == PSD_ON)
        {
            printf( "Slice %d\n", i );
        }
        for ( j = 0 ; j < 9 ; j++ )
        {
            rsprot_unscaled[i][j] = rsprot[i][j];
            if (obl_debug == PSD_ON)
            {
                printf( "rsprot_unscaled[%d] = %ld\n", j, rsprot_unscaled[i][j] );
            }
        }
    }

    /* Rotate rotation matrices */
    if (scalerotmats( rsprot, &loggrd, &phygrd, 
                  (int)(opslquant * opphases), obl_debug ) == FAILURE)
    {
        epic_error(use_ermes,"System configuration data integrity violation detected in PSD. \nPlease try again or restart the system.",
                   EM_PSD_PSDCRUCIAL_CONFIG_FAILURE,EE_ARGS(0));
        return FAILURE;
    }

    /***************************************
      Image Header CVs
    ***************************************/

    /* The routine imgtimutil() rounds down optr to full integer line cycles
     * and subtracts TR_SLOP in the calculation of act_tr. Therefore, act_tr is
     * never greater than optr, except in epi. In epi, act_tr is rounded up
     * to hrdwr_period (=64us) at the call of imgtimutil(). Because of this,
     * act_tr + TR_SLOP could be greater than optr. When this happens (ie,
     * ihtr>optr), we get download failure. In order to avoid this download 
     * failure, it is fixed by replacing:
     *     ihtr = act_tr + ((gating==TRIG_LINE) ? TR_SLOP :0);
     * with:
     *     ihtr = act_tr + ((gating==TRIG_LINE) ? TR_SLOP :0);
     *     if(gating==TRIG_LINE) {
     *         ihtr = ihtr - hrdwr_period;
     *     }
     * MRIge34441, ypd
     */
    if ( (opcgate == PSD_OFF) && (mph_flag == PSD_OFF) ) {
        ihtr = act_tr + ((gating==TRIG_LINE) ? TR_SLOP :0);
        if(gating == TRIG_LINE) {
            ihtr = ihtr - hrdwr_period;
        }

	ihtdel1 = MIN_TDEL1;
    } else if ( (mph_flag == PSD_ON) && (opcgate == PSD_OFF)) {
        ihtr = act_tr + ((gating==TRIG_LINE) ? TR_SLOP :0);
        if(gating==TRIG_LINE) ihtr = ihtr - hrdwr_period;
	free(ihtdeltab);

	ihtdeltab = (int *)malloc(opslquant*sizeof(int));
	exportaddr(ihtdeltab, (int)(opslquant*sizeof(int)));
	for (i=0; i<opslquant; i++) {
            /* YMSmr06832 */
            if (acqmode == 0)  /* interleaved */
                ihtdeltab[i] =
                    (data_acq_order[i].slpass) *
                    (disdaq_shots + nex*reps*core_shots) * act_tr +
                    (disdaq_shots + nex*reps*core_shots-1) * act_tr +
                    (data_acq_order[i].sltime + 1)*(act_tr/(float)slquant1) +
                    (data_acq_order[i].slpass) * pass_delay*num_passdelay;
            else if (acqmode == 1)  /* sequential */
                ihtdeltab[i] = 
                    (data_acq_order[i].slpass + 1) * 
                    (disdaq_shots/(float)reps + nex*core_shots) * act_tr +
                    (data_acq_order[i].sltime)*(act_tr/(float)slquant1) +
                    (data_acq_order[i].slpass) * pass_delay*num_passdelay;
        }

    } else {
        ihtdeltab = (int *)malloc(opphases*opslquant*sizeof(int));
        exportaddr(ihtdeltab, (int)(opphases*opslquant*sizeof(int)));
        ihtrtab = (int *)malloc(opphases*opslquant*sizeof(int));
        exportaddr(ihtrtab, (int)(opphases*opslquant*sizeof(int)));

        if (opphases > 1) {
            for (i = 0; i < opphases*opslquant; i++) {
                if (data_acq_order[i].sltime < opslquant) {
                    ihtrtab[i] = (act_tr - ((opphases/opslquant) - 1) *
                                  opslquant * psd_tseq);
                } else {
                    ihtrtab[i] = opslquant * psd_tseq;
                }
            }
            for (i = 0; i < opphases*opslquant; i++) {
                ihtdeltab[i] = optdel1 + psd_tseq*data_acq_order[i].sltime;
            }
        } else {
            /* Cross R-R */
            j= 0;
            for (i = 0; i < opslquant; i++) {
                j = (i%opslquant)/ophrep;
                ihtdeltab[i] = optdel1 + psd_tseq*j;
                ihtrtab[i] = act_tr;
            } /* for (i = ... */
        } /* if (opphases > 1) */
        if(debug_tdel)
        {
            for(i=0;i< opphases*opslquant; i++)
            {
                printf("ihtrtab[%d] = %d\n",i,ihtrtab[i]);
            }
        }

    } /* if (opcgate == PSD_OFF) */

    if(debug_tdel && (opmph == PSD_ON))
    {
        for(i=0;i< opphases*opslquant; i++)
        {
            printf("ihtdeltab[%d] = %d\n",i,ihtdeltab[i]);
        }
    }

%ifdef RT 
@inline  epiRTfile.e RT_slice_time
/*check if #images exceeds maximum possible #images */
@inline epiRTfile.e RT_checkMaxNumImages 
%endif
    
    /* set ihmaxtdelphase
     * This is the tdel value for the last acquired slice for the first phase
     * Used in ifcc to calculate the tdel values for the rest of the phases
     * -- 1024 im/ser -Venkat
     */ 
    if( enable_1024 )
    {
        /* YMSmr06832 */
        ihmaxtdelphase = 0;
        for(i=0;i<opslquant*opphases;i++) 
        { 
            if((ihmaxtdelphase < ihtdeltab[i]) && 
               (data_acq_order[i].slpass == 0 )){ 
                ihmaxtdelphase = ihtdeltab[i];
            }
        }
 
                ihmaxtdelphase = ihmaxtdelphase + opsldelay;
                ihmaxtdelphase = ihmaxtdelphase * acqs;
                printf("ihmaxtdelphase = %10d\n",ihmaxtdelphase);
    }
    else
        ihmaxtdelphase = 0;
    if(debug_tdel)
    {
        printf("ihmaxtdelphase = %10d\n",ihmaxtdelphase);
    }
    fflush(stdout);

 
    ihte1 = opte;

    /* Nex annotation requirements changed at a late date per MRIge24292 */
    ihnex = nex*nop;

    ihflip = flip_rf1;
    ihvbw1 = (FLOAT)(rint(oprbw));
    iheesp = eesp;

    /**********************
      SAT Positioning
    *********************/
    if(SatPlacement(acqs) == FAILURE)
    {
        epic_error(use_ermes,"%s failed",EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1),STRING_ARG,"SatPlacement");
        return FAILURE;
    }

    rhnpasses = acqs*pass_reps;
    eepf = 0;
    
    /* If phase enc grad is flipped, inform recon */
    if (pepolar == PSD_ON)
    {
        oepf = 1;
    }
    else
    {
        oepf = 0;
    }
   
    set_echo_flip(&rhdacqctrl, &chksum_rhdacqctrl, eepf, oepf, eeff, oeff); /* clear bit 1 - flips image in phase dir */
    rhdaxres = rhfrsize;

    /* Turn on new epi phase correction algorithm */
    /* BJM: 2 = Nearest Neighbor processing */
    rhref = 2; /* 0=old algorithm, 1 = new algorithm */
    /* internref: if internal ref scan, set rhref to 3 */
    /* set rhref to 4 for self-navigated dynamic phase correction */
    if( iref_etl > 0 ){
        if((epira3_flag == PSD_ON || epiRTra3_flag == PSD_ON) && (ra3_sndpc_flag == PSD_OFF))
            rhref = 3;
        else
            rhref = 4;
    }

    if(vrgf_reorder == PSD_ON) {
        rhtype1 |= VRGF_AFTER_PCOR_ALT;
    } else {
        rhtype1 &= ~VRGF_AFTER_PCOR_ALT;
    }
    
    rhileaves = intleaves;
    rhkydir = ky_dir;
    rhalt = ep_alt;

    /*MRIhc09115,YMSmr07202*/
    if (mph_flag != PSD_OFF)
    {
        rhreps = exist(opfphases);
    }
    else
    {
        rhreps = reps;
    }

    if (touch_flag)
    {
        rhmethod = 0;
    }
    else
    {
        rhmethod = 1;  /* enable reduced image size */
    }

    {
	int power;
	float temp;

	if (rhmethod == 1)
        {

            if (vrgfsamp == 1)
            {
                
                temp = (float)opxres;
		power = 0;
		
		while (temp > 1)
                {
                    temp /= 2.0;
                    ++power;
		}
		
		fft_xsize = (int)pow(2.0,(double)power);
		
                temp = (float)opyres;
		power = 0;
		
		while (temp > 1)
                {
                    temp /= 2.0;
                    ++power;
		}
		
		fft_ysize = (int)pow(2.0,(double)power);
		
		image_size = IMax(2, fft_xsize, fft_ysize);
		fft_xsize = image_size;
		fft_ysize = image_size;
		
		rhrcxres = fft_xsize;
		rhrcyres = fft_ysize;
		rhimsize = image_size;
		
            }
            else
            {
                
                /* non-VRGF */
                temp = (float)rhdaxres;
		power = 0;
		
		while (temp > 1)
                {
                    temp /= 2.0;
                    ++power;
		}
		
		fft_xsize = (int)pow(2.0,(double)power);
		
                temp = (float)opyres;
		power = 0;
		
		while (temp > 1)
                {
                    temp /= 2.0;
                    ++power;
		}
		
		fft_ysize = (int)pow(2.0,(double)power);
		
		image_size = IMax(2, fft_xsize, fft_ysize);
		fft_xsize = image_size;
		fft_ysize = image_size;
		
		rhrcxres = fft_xsize;
		rhrcyres = fft_ysize;
		rhimsize = image_size;
            }
	  
	}
        else
        {

            if (touch_flag)
            {
                /* MR-Touch post-processing only supports 256 matrix size*/
                fft_xsize = 256;
                fft_ysize = 256;
                image_size = 256;
                rhrcxres = image_size;
                rhrcyres = image_size;
                rhimsize = image_size;
            }
            else
            {
                temp = (float)exist(opxres);
                power = 0;
                while (temp > 1)
                {
                    temp /= 2.0;
                    ++power;
                }

                fft_xsize = (int)pow(2.0,(double)power);

                temp = (float)exist(opyres);
                power = 0;
                while (temp > 1)
                {
                    temp /= 2.0;
                    ++power;
                }
                fft_ysize = (int)pow(2.0,(double)power);

                rhrcxres = opxres;
                rhrcyres = eg_phaseres;
                rhimsize = image_size;
            }
        }
  
        /* Number of points to exclude, beginning and end,
           for phase correction */
        pckeeppct = ((exist(opfov) <= 300.0) ? 100.0 : (300.0/exist(opfov))*100.0 );
	rhpcdiscbeg = (fft_xsize*(100.0 - pckeeppct)/100.0)/2.0;
	rhpcdiscbeg = IMax(2, rhpcdiscbeg, 2);
	rhpcdiscend = rhpcdiscbeg;

        /* BJM: set discard pts = 0 */
        if(rhref >= 2) {
            rhpcdiscbeg = 0;
            rhpcdiscend = 0;
        }
    }

    /* BJM: SE Ref Scan */
    /*      Moved setting of recon phase control vars */
    /* into inline file */
@inline refScan.e epiRefScanRhVars

    /* Value1.5T May 2005 KK */
    if(ghost_check == 1) {
      rhpccon = 0;
      rhpclin = 0;
    }
    else if(ghost_check == 2){ 
      rhpccon = 1;
      rhpclin = 1;
    }

    rhvrgfxres = exist(opxres);
    rhvrgf = vrgfsamp;

    rhdab0s = cfrecvst;
    rhdab0e = cfrecvend;

    if(touch_flag)
    {
        rhnecho = touch_ndir;
        rhrawsize = slquant1 * (1 + (rhbline * rawdata) + rhnframes + rhhnover) * 2
                    * rhptsize * ((exnex * (1 - rawdata)) + (nex * rawdata))
                    * rhnecho * rhfrsize;
    }
    else{
        if (rhref == 1 && baseline > 0 && rawdata == PSD_ON) {
            rhrawsize = 2*slquant1*(1+rhbline+rhnframes+rhhnover)*2
                *rhptsize*nex*rhfrsize;
        }
        else {
            /* internref: consider iref_frames*/ /*MRIhc04836*/
            rhrawsize = slquant1*(1+rhbline*rawdata+rhnframes+rhhnover+iref_frames)*2
                *rhptsize*nex*rhfrsize;
        }
        rhrawsize *= reps*exist(opphases);
        rhnecho = 1;
    }

    /*In case opfphases is not reset to 1 by SCAN when "Mph" is turned off. YP Du. MRIge32705 */
    if(mph_flag==PSD_ON)
    {
        rhnslices = exist(opslquant)*exist(opphases)*exist(opfphases);
    }
    else
    {
        rhnslices = exist(opslquant)*exist(opphases);
    }

    if ((rhdab0e - rhdab0s) == 0) {
        rhtype1 = rhtype1 & ~RHTYP1AUTOPASS;  /* clear automatic scan/pass detection bit */
    }

    /* Tell TARDIS there is a hyperscan dab packet and to use HRECON. */
    rhformat = rhformat | 64;

    /* Turn on row-flipping */
    rhformat = rhformat | 2048;
  
    if (touch_flag)
    {
        rhrcctrl = RHRCMAG + RHRCCOMP;
    }
    else
    {
        /* Turn off image compression */
        rhrcctrl = RHRCMAG + rawmode*RHRCRAW;
    }

    if (dc_chop == 1) {
	rhtype = rhtype & ~RHTYPCHP;  /* clear chopper bit */
	rhblank = blank;
    } else {
	rhtype = rhtype | RHTYPCHP;   /* set chopper bit */
	rhblank = 0;
    }
    if (touch_flag){
        rhtype &= ~RHTYPFRACTNEX;
    }

    /* number of points to blank on display */
    if (image_size < 256)
        rhblank = (4*image_size)/256;

    /* Fermi filter control - different for epi due to vrgf */
    rhfermr = exist(opxres)/2;

    /* Set recon header variables based on MRE information */
@inline touch.e TouchRhheader

    /* Split predownlaod into two modules so gcc assembler can process */
    if (predownload1()==FAILURE) {
        return FAILURE;
    }

    /* Set pulse parameters */
    if ( FAILURE == calcPulseParams() )
    {
        return FAILURE;
    }

    if (ss_fa_scaling_flag && (cfgcoiltype == PSD_XRMB_COIL || cfgcoiltype == PSD_XRMW_COIL))
    {
        override_fatsat_high_weight = PSD_ON;
    }

    if (PSD_OFF == override_fatsat_high_weight)
    { 
        if((opweight > 158) && (ss_rf1 == PSD_ON)) { 
            epic_error( use_ermes, "%s is incompatible with %s.", EM_PSD_IMGOPT_PSD1, EE_ARGS(2), STRING_ARG, "SPSP RF (Chem Sat=None/water)", STRING_ARG, "high pat. weight (>158kg) for EPI" ); 
            return FAILURE; 
        }
    }

#ifndef SIM
    if (bigpat_warning_flag == PSD_ON)
    {
        if ((flip_rf1 < exist(opflip)) && (exist(oppseq) == PSD_SE) && (ss_rf1 == PSD_ON))
        {
            epic_warning( "Image quality may be degraded due to reduced flip angle at high patient weights" );
            bigpat_warning_flag = PSD_OFF;
        }
    }
#endif

@inline touch.e TouchAcqOrder
@inline touch.e TouchPredownloadIhtdel

    if(rtb0_flag)
    {
        rtb0_midsliceindex = pre_slice;
        rtb0_outlier_nTRs = (int)ceil(rtb0_outlier_duration*1000000.0/exist(optr));
        rtb0Init();
    }

    return SUCCESS;
    fprintf(stderr,"At end of predownload, pw_gyb and a_gyb are %d and %f \n",pw_gyb,a_gyb);    
}   /* end predownload() */


/*
 *  predownload1
 *  
 *  Type: Public Function
 *  
 *  Description:
 *  
 */
STATUS
#ifdef __STDC__
predownload1( void )
#else /* !__STDC__ */
    predownload1()
#endif /* __STDC__ */
{
    int i;

    /* Prescan Slice Calc **********************/
    if (prescanslice(&pre_pass, &pre_slice, opslquant) == FAILURE) {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "prescanslice");
	return FAILURE;
    }
  
    /* Find the corresponding spacial slice/pass for the prescan/center slice location */
    {
	int savei = 0;

	for (i = 0; i < opphases*opslquant; i++) {
            if (data_acq_order[i].sltime == pre_slice) {
		savei = i;
		i = opphases*opslquant;
            }
	}

	if ( (mph_flag==PSD_ON) && (acqmode==1) ) {  /* multi-phase sequential */
            for (i = 0; i < reps*opphases*opslquant; i++) {
		if (data_acq_order[i].slpass == pre_pass) {
                    savei = i;
                    i = reps*opphases*opslquant;
		}
            }
	}

	slice_num = savei + 1;
    }

    rhpctemporal = 1;          /* use first temporal position */

    /* mph, seq, play 1 rep */
    if ( (mph_flag==PSD_ON) && (acqmode==1) && (rhpctemporal==1) )
	slice_num = data_acq_order[slice_num-1].slpass + 1;
	
    /* figure out rhpcpspacial given refSliceNum value */
    if(exist(refSliceNum) != -1 && exist(refSliceNum) != 0) {
        
        /* Is refSliceNum in a valid prescription range */
        if(existcv(opslquant) && exist(opslquant) >= exist(refSliceNum)) {
            
            /* Figure out temporal position of desired ref slice (interleaved order) */
            /* the slice prescribed is in terms of the spatial order.  This converts */
            /* the spatial index to the temporal position in the pass.               */
            /* Note: the must subtract 1 since slice index starts @ 0!               */
            
            temp_rhpcspacial = (INT)(data_acq_order[(INT)(exist(refSliceNum)-1)].sltime + 1);
            pre_slice =  temp_rhpcspacial - 1;
            
        } else {
            
            epic_error( 0, "Error!: Ref Scan Slice Index > number of slices",
                        EM_PSD_SUPPORT_FAILURE, 1, STRING_ARG, "predownload" );
            return FAILURE;
        }
        
        if( exist(refSliceNum) != -1 && acqs > 1) {
            epic_error( 0, "Error!: refSliceNum != -1 & acqs > 1 not compatible",
                        EM_PSD_SUPPORT_FAILURE, 1, STRING_ARG, "predownload" );
            return FAILURE;
        }
        
    } else {
        /* MRIhc19933 */ 
        /* One ref for all, using prescan slice */
        temp_rhpcspacial = 0;            /* use all slices */
        if ( (mph_flag==PSD_ON) && (acqmode==1) ) /* multi-phase sequential */
        {
            temp_rhpcspacial = 1;
        }
    }
   
    /*MRIhc06466 MRIhc06308*/
    if (PSD_OBL==exist(opplane)) {
       rhpcspacial = 0;
       rhpcspacial_dynamic = temp_rhpcspacial;
    } else if ( iref_etl > 0 ) { /* Temp fix for 14.0ME to make dynamic pc
                                    work.  Please remove this 'else if' section
                                    when fixed */
       rhpcspacial = 0;
       rhpcspacial_dynamic = temp_rhpcspacial;
    } else {
       rhpcspacial = temp_rhpcspacial;
       rhpcspacial_dynamic = temp_rhpcspacial;
    } 

    /* set rhscnframe and rhpasframe */
    if (acqmode == 0) {   /* interleaved */
    	/*Total number of frames acquired for an entire SCAN*/
	rhscnframe = rhnslices*(opnex*(rhnframes+rhhnover+iref_frames) + baseline);
	
	/*Number of frames per pass*/
	rhpasframe = slquant1*(opnex*(rhnframes+rhhnover+iref_frames) + baseline);
    } else if (acqmode == 1) {  /* sequential */
	rhscnframe = rhnslices*(opnex*(rhnframes+rhhnover+iref_frames) + baseline);
	rhpasframe = reps*(opnex*(rhnframes+rhhnover+iref_frames) + baseline);
    }

    
    if ( rhpcspacial == 0 )
	ref_mode = 0;
    else
	ref_mode = 1; /* loop to the center slice */

    if (rhpcileave == 0)
	refnframes = rhnframes;
    else
	refnframes = rhnframes/intleaves;


    /* set rhrefframes and rhrefframep */
    if (ref_mode == 0) {            /* Excite all slices in ref scan */
  	if (acqmode == 0) {         /* Interleaved */
            if (rhpctemporal == 0)
                rhrefframes = rhnslices*(refnframes+rhhnover+iref_frames+baseline);
            else
                rhrefframes = (rhnslices/reps)*(refnframes+rhhnover+iref_frames+baseline);
            rhrefframep = slquant1*((refnframes+rhhnover+iref_frames) + baseline);

	} else if (acqmode == 1) {   /* Sequential */

            if (rhpctemporal == 0)
                rhrefframes = rhnslices*((refnframes+rhhnover+iref_frames) + baseline);
            else
                rhrefframes = (rhnslices/reps)*((refnframes+rhhnover+iref_frames) + baseline);
            rhrefframep = reps*((refnframes+rhhnover+iref_frames) + baseline);

	}
    } else if (ref_mode == 1) {  /* loop to center slice in ref scan */

  	if (acqmode == 0) {   /* Interleaved */
            rhrefframes = (pre_slice+1)*((refnframes+rhhnover+iref_frames) + baseline);
            rhrefframep = (pre_slice+1)*((refnframes+rhhnover+iref_frames) + baseline);
	} else if (acqmode == 1) {  /* sequential */
            rhrefframes = (pre_pass+1)*((refnframes+rhhnover+iref_frames) + baseline);
            rhrefframep = reps*((refnframes+rhhnover+iref_frames) + baseline);
	}

    } else if (ref_mode == 2) {  /* Excite center slice only in ref scan */

  	if (acqmode == 0) {   /* interleaved */
            rhrefframes = ((refnframes+rhhnover+iref_frames) + baseline);
            rhrefframep = ((refnframes+rhhnover+iref_frames) + baseline);
	} else if (acqmode == 1) {  /* sequential */
            rhrefframes = ((refnframes+rhhnover+iref_frames) + baseline);
            rhrefframep =((refnframes+rhhnover+iref_frames) + baseline);
	}

    } else {
	epic_error(use_ermes,"invalid ref_mode value, use 0, 1, or 2",EM_PSD_REF_MODE_ERROR,0);
	return FAILURE;
    }

    /* *******************************
       Entry Point Table Evaluation
       ******************************* */
  
    if (entrytabinit(entry_point_table, (int)ENTRY_POINT_MAX) == FAILURE)
	return FAILURE;
  
    /* Scan entry point */
    strcpy(entry_point_table[L_SCAN].epname, "scan");
  
    /* Set xmtadd according to maximum B1 and rescale for powermon,
       adding additional (audio) scaling if xmtadd is too big. 
       Add in coilatten, too. */
    xmtaddScan = -200*log10(maxB1[L_SCAN]/maxB1Seq) + 
        txCoilInfo[getTxIndex(coilInfo[0])].coilAtten;
	
    /*JWG BB 13C power prescan done with fidcsi. In that psd, xmtaddScan = 0, so force 0 when specnuc != 1*/
    if (specnuc != 1) xmtaddScan = 0;	
	
    if (xmtaddScan > cfdbmax) {
        extraScale = (float) pow(10.0, (cfdbmax - xmtaddScan)/200.0);
        xmtaddScan = cfdbmax;
    } else {
        extraScale = 1.0;
    }
  
    if (setScale(L_SCAN, RF_FREE, rfpulse, maxB1[L_SCAN], 
                 extraScale) == FAILURE) {
        epic_error(use_ermes, "%s failed for scan.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "setScale");
        return FAILURE;
    }
  
    entry_point_table[L_SCAN].epxmtadd = (short) rint((double)xmtaddScan);
  
    if (cs_sat == PSD_ON)
	rfpulse[RFCSSAT_SLOT].num = 1;
  
    /* MRIge75651*/
    if (powermon(&entry_point_table[L_SCAN], L_SCAN, (int)RF_FREE,
                         rfpulse, (int)(act_tr/slquant1)) == FAILURE)
    {
        epic_error(use_ermes, "%s failed.", EM_PSD_SUPPORT_FAILURE,
                   EE_ARGS(1), STRING_ARG, "powermon");
        return FAILURE;
    }

    /* Store SAR power monitor values in CVs for debugging */
    extractActivePowerMonValues( &entry_point_table[L_SCAN],
                                 txCoilInfo[getTxIndex(coilInfo[0])],
                                 &sar_amp, &sar_width, &sar_cycle );
  
    entry_point_table[L_SCAN].epfilter = (unsigned char)echo1_filt.fslot;
    entry_point_table[L_SCAN].epprexres = rhfrsize;
    entry_point_table[L_SCAN].epstartrec = rhdab0s;
    entry_point_table[L_SCAN].ependrec = rhdab0e;
  
    /* Now copy into APS2, MPS2, REF */
    entry_point_table[L_APS2] = entry_point_table[L_MPS2] =
	entry_point_table[L_REF] = entry_point_table[L_SCAN];
    
    strcpy(entry_point_table[L_MPS2].epname, "mps2");
    strcpy(entry_point_table[L_APS2].epname, "aps2");
    strcpy(entry_point_table[L_REF].epname, "ref");
  
    /* MPS (Prescan) uses two frames to substract in the default window */
    etot = 2;

    if (ky_dir == PSD_CENTER_OUT && fract_ky == PSD_FRACT_KY) {
        emid = num_overscan / intleaves - 1;
        emid += ky_offset / intleaves;
    } else if (ky_dir == PSD_CENTER_OUT && fract_ky == PSD_FULL_KY) {
	emid = 0;
    } else if ((ky_dir==PSD_TOP_DOWN || ky_dir==PSD_BOTTOM_UP) &&
               fract_ky == PSD_FULL_KY) {
        emid = (etl-1) / 2; 
        emid += ky_offset / intleaves + iref_etl;
    } else if ((ky_dir==PSD_TOP_DOWN || ky_dir==PSD_BOTTOM_UP) &&
               fract_ky == PSD_FRACT_KY) {
        emid = num_overscan / intleaves - 1;
        emid += ky_offset / intleaves + iref_etl;
    } else {
        emid = 0;
    }

    /* First echo in train to send to MPS2 */
    if (exist(oppseq) == PSD_SE) {
        /* spin echo epi */
        e1st = emid - etot / 2;
    } else if (exist(oppseq) == PSD_GE) {
        /* gradient echo epi */
        e1st = 0;
    } else {
        /* default */
        e1st = 0;
    }

    /* check for negative values */
    emid = ((emid < 0) ? 0 : emid);
    e1st = ((e1st < 0) ? 0 : e1st);

    entry_point_table[L_MPS2].epprexres = rhfrsize;
    entry_point_table[L_APS2].epprexres = rhfrsize;
    
@inline BroadBand.e BBpredownload    

    if (debug_scan) {
        psd_dump_scan_info();
        psd_dump_rsp_info();
    }

    /* *****************************
       Auto Prescan Init
	 
       Inform Auto Prescan about
       prescan parameters.
       *************************** */
  
    pitr = prescan1_tr; /* first pass prescan TR */
    pichop = 0; /* no chop for APS */
    picalmode = 0;
    pislquant = etot*slquant1; /* Number of slices in 2nd pass prescan */
  
    /* Must be called before first setfilter() call in predownload */
    initfilter();

    if (setfilter( &echo1_filt, SCAN) == FAILURE) {
        epic_error(use_ermes,"setfilter failed",EM_PSD_SUPPORT_FAILURE,1,STRING_ARG, "setfilter");
        return FAILURE;
    }

    /* set CV for EP_TRAIN macro */
    scanslot = echo1_filt.fslot;

    if(rtb0_flag)
    {
        filter_rtb0echo = scanslot;
    }

@inline Prescan.e PSfilter

    /* For fast receiver, determine low pass filter setting based on
       sampling period.  This will be selected via an ssp packet */
    rhfast_rec = 0;

    field_strength = cffield;
    frtime = (float)((rhfrsize-1)*tsp);

    /* Open /usr/g/bin/vrgf.param and write out the VRGF parameters
       If auto mode, request that scan call the vrgf program */
    piforkvrgf = 0;
    if (vrgfsamp == PSD_ON) {
	if (genVRGF(&gradout,
                    (int)exist(opxres),
                    tsp,
                    a_gxw,
                    (float)(pw_gxwl + pw_gxw/2)/1.0e6,
                    (float)(pw_gxwad)/1.0e6,
                    2.0/(epiloggrd.xbeta + 1.0),
                    epiloggrd.xbeta) == FAILURE)
            return FAILURE;
        if (autovrgf == PSD_ON){
            piforkvrgf = 1;
        }

/* MRIhc15230 - vrgf for fMRI now called by scn instead of system call */
#ifdef RT

#ifndef SIM
        if (autovrgf == PSD_ON){
            rhtype1 |= FAST_VRGF_ALT;
        }
#endif

#endif

    }
 
    /* Turn on/off bandpass asymmetry correction */
    if( PSDDVMR != psd_board_type ) 
    { 
        if(((rhdab0e - rhdab0s + 1) > number_of_bc_files) || value_system_flag) { 
            rhbp_corr = 0; /* turn it off if the number of BC files */
                           /* does not match the number of active receivers */
        } 
        else 
        {
            rhbp_corr = 1; /* else turn it on */
        }
    }
    else
    {
        rhbp_corr = 0; /* MRIhc24730: Bandpass asymmetry correction */ 
                       /* will not be applied for DVMR receive chain hardware*/
    }

    /* Local scope block */
    {
	float delta_freq;  /* delta frequency (Hz) */
	float full_bw;     /* full bandwidth  (Hz) */
	float read_offset; /* readout offset (Hz) */

	full_bw = 1.0/(tsp*1.0e-6);
	delta_freq = full_bw/(float)rhfrsize;

	/*	read_offset = a_gxw * GAM * scan_info[0].oprloc / 10.0; */
	read_offset = 0.0;
	rhrecv_freq_s = -((float)rhfrsize*delta_freq/2.0 + read_offset) + 0.5;
	rhrecv_freq_e = (float)((rhfrsize-1)/2)*delta_freq + read_offset;
    }

    if (vrgfsamp == PSD_ON) {
        dacq_adjust = ((float)pw_gxw / 2.0 + (float)(pw_gxwad) -
                       (float)(pw_gyba + pw_gyb + pw_gybd) / 2.0 -
                       tsp * ((float)rhfrsize - 1.0) / 2.0);
    } else {
        dacq_adjust = (float)pw_gxw / 2.0 - tsp * ((float)rhfrsize - 1.0) / 2.0;
    }

    /* protect against negative adjustment */
    dacq_adjust = ((dacq_adjust < 0) ? 0 : dacq_adjust);

#ifndef SIM
    /* Compute interpolated time delays for phase-encode blip correction method */
    if ( FAILURE == blipcorrdel( &bc_delx, &bc_dely, &bc_delz, esp,
                                 txCoilInfo[getTxIndex(coilInfo[0])].txCoilType,
                                 debug_oblcorr) ) {
        epic_error( use_ermes, "%s failed", EM_PSD_SUPPORT_FAILURE,
                    EE_ARGS(1), STRING_ARG, "blipcorrdel" );
        return FAILURE;
    }
#endif /* !SIM */

    return SUCCESS;
} /* end Predownload1 */


/*
 *  calcPulseParams
 *  
 *  Type: Public Function
 *  
 *  Description:
 *    This function sets pulse widths and instruction amplitudes needed
 *    for pulse generation.
 */
STATUS
#ifdef __STDC__ 
calcPulseParams( void )
#else /* !__STDC__ */
    calcPulseParams() 
#endif /* __STDC__ */
{

    /* Include EPIC-generated code */
#include "predownload.in"

/* Inversion Recovery predownload */
@inline Inversion.e InversionPredownload

/*jwg bb placing this here gets rfconf automatically set correctly*/
    if ((acquire_type == SPECPSD_MASTER_H1)
        || (acquire_type == SPECPSD_MASTER_MNS)){
        rfconf = (ENBL_RHO1 | ENBL_THETA | ENBL_OMEGA
                  | ENBL_OMEGA_FREQ_XTR1 | ENBL_THETA_PHASE_XTR1);
    } else {
        rfconf = (ENBL_RHO2 | ENBL_THETA | ENBL_OMEGA
                  | ENBL_OMEGA_PHASE_XTR2 | ENBL_THETA_FREQ_XTR2);
    }   


@inline Prescan.e PSpredownload



    /*****************************
      Timing for SCAN entrypoint
    ****************************/
  
    /*************************************************************************
      pos_start marks the position of the start of the attack ramp of
      the gradient for the excitation pulse.  If Sat or other prep pulses
      are played before excitation, then the pos_start marker is incremented
      accordingly to account for the prep time.
      
      Because the rf unblank must be played at least -rfupa us prior to
      the excitation pulse, pos_start must allow enough space for this
      unblank if the attack of the ramp is not long enough.  Rather than
      arbitrarily making the attack pulse longer, the start position is
      adjusted and the attack ramp is optimized.
      
      Note also that rfupa is a negative number, so it is negated in
      the following calculation to make it a positive number.
    ************************************************************************/
    pos_start = RUP_GRD((int)tlead + GRAD_UPDATE_TIME);

%ifdef RT
    /* BJM - since added 2 ms of time for trigger pulses update pos_start */
    pos_start = RUP_GRD((int)tlead + eegtime_tot+ 
                        TTLtime_tot + abs(pw_gzrf1a + rfupa) + GRAD_UPDATE_TIME);
%endif

    if ((pos_start + pw_gzrf1a) < -rfupa) {
        pos_start = RUP_GRD((int)(-rfupa - pw_gzrf1a + GRAD_UPDATE_TIME));
    }

    /*
      Ordering of pulse is for non cardiac:
      spatial sat, chemsat, 90 (180) readout and killer.

      For cardiac:
      90 (180) readout, spatial sat, chemsat, and killer
    */
    sp_satcard_loc = 0;
    if ( (existcv(opcgate)) && (exist(opcgate)==PSD_ON) ) {
	/* Set some values for the scan clock */
	pidmode = PSD_CLOCK_CARDIAC; /* Display views  and clock */
	/*
          piclckcnt 
          piclckcnt is used is estimating the scan time remaining in
          a cardiac scan.  It is the number of cardiac triggers within
          an effective TR interval used by the PSD to initiate a 
          sequence after the initial  cardiac trigger 
          
          piviews
          piviews is used by the Tgt in cardiac scans to display the
          number of heart beat triggers the PSD will use 
          to complete a scan 
          
          trigger_time
          Amount of time to leave for the cardiac trigger.
        */
        ctlend = IMax( 2,
                       (int)GRAD_UPDATE_TIME,
                       RDN_GRD(psd_tseq - tmin - time_ssi) );
        if (opphases  > 1) {
            piviews = nreps; /* used by the Tgt in cardiac scans to display the
                                number of heart beat triggers the PSD will use 
                                to complete a scan */
            piclckcnt = 0;
            trigger_time =  RDN_GRD((int)( 0.01 * oparr * (60.0/ophrate) *
                                           1e6 * ophrep));
            ctlend_last = RDN_GRD(act_tr - trigger_time - td0 -
                                  (opphases -1) * psd_tseq - tmin - time_ssi);
        } else {
            ctlend_fill = RDN_GRD(piait - (((int)(opslquant/ophrep) +
                                            (opslquant%ophrep ? 1:0) -1) *
                                           psd_tseq) - tmin - time_ssi);
            ctlend_unfill = RDN_GRD(ctlend_fill +
                                    (opslquant%ophrep ? psd_tseq:0));
            /* Cross R-R */
            if (opslquant >= ophrep) {
                piclckcnt = ophrep - 1;
                piviews = nreps * ophrep;
                trigger_time =  .01 * oparr * (60.0/ophrate)*1e6;
                ctlend_last = ctlend_unfill;
	    } else {
                piclckcnt = opslquant - 1;
                piviews = nreps * opslquant;
                trigger_time = (0.01 * oparr * (60.0/ophrate) * 1e6 *
                                (ophrep + 1 - opslquant));
                ctlend_last = RDN_GRD(ctlend_fill + (ophrep - opslquant) *
                                      ((1 -.01*oparr) * (60.0/ophrate) * 1e6));
	    }
        }
	
	ps2_dda = dda;
	if (optdel1 < pitdel1) {
            /* Calculate time from middle of last echo to when 
               spatial sat, chemsat or killer can begin */
            /* BJM: MRIge55066 - added pw_sspshift */
            post_echo_time = tdaqhxb + pw_gxwad - rfupa + 1us + gkdelay + gktime + pw_sspshift;
            postsat = opsat;
            sp_satstart = tlead + GRAD_UPDATE_TIME + pw_gzrf1a + t_exa + psd_rf_wait + te_time + post_echo_time;
            cs_satstart = sp_satstart + sp_sattime - rfupa + CHEM_SSP_FREQ_TIME;
            sp_satcard_loc = 1;
	} else {
            postsat = PSD_OFF;
            sp_satstart = GRAD_UPDATE_TIME + tlead + ir_time;
            cs_satstart = sp_satstart + sp_sattime - rfupa + CHEM_SSP_FREQ_TIME;
            pos_start = pos_start + sp_sattime + cs_sattime + ir_time + satdelay;
            sp_satcard_loc = 0;
	}
    } else if (touch_flag) {
        /* Enable acqs before pause */
        pipautype = PSD_LABEL_PAU_REP;  /* _LOC=0, _REP=1, _ACQ=2 */
        if (exist(opslicecnt)==0) {
            pidmode = PSD_CLOCK_NORM;
        } else {
            pidmode = PSD_CLOCK_PAUSE;  /* _NORM=0, _CARDIAC=1, _PAUSE=2, CARDPAUSE=3 */
        }

        postsat = PSD_OFF;
        sp_satstart = GRAD_UPDATE_TIME + tlead + ir_time;
        cs_satstart = sp_satstart + sp_sattime - rfupa + CHEM_SSP_FREQ_TIME;
        pos_start = RUP_GRD(pos_start + sp_satstart + sp_sattime + cs_sattime + satdelay);

    } else {
	pidmode = PSD_CLOCK_NORM; /* Display scan clock in seconds */
	ps2_dda = dda;
        
	sp_satstart = pos_start + ir_time;
	cs_satstart = sp_satstart + sp_sattime - rfupa + CHEM_SSP_FREQ_TIME;
	pos_start = pos_start + ir_time + sp_sattime + cs_sattime + satdelay;
    }
  
    /* MRIge64197 -- single sequence plays IR-SPsat-EPI. Without 
       sp_satcard_loc, IR pulse gets spatial sat rotation matrix. */
    sp_satcard_loc = sp_satcard_loc || ir_on;

    if (ss_rf1 != PSD_ON) {
        pos_moment_start = pos_start + t_exa + pw_gzrf1a;
    }
    cs_satstart = RUP_GRD(cs_satstart);
    sp_satstart = RUP_GRD(sp_satstart); 
  
    /*
     * Initialize the waits for the cardiac instruction.
     * Pulse widths of wait will be set to td0 for first slice
     * of an R-R in RSP.  All other slices will be set to 
     * the GRAD_UPDATE_TIME.
     */
    pw_x_td0 = GRAD_UPDATE_TIME;
    pw_y_td0 = GRAD_UPDATE_TIME;
    pw_z_td0 = GRAD_UPDATE_TIME;
    pw_rho_td0 = GRAD_UPDATE_TIME;
    pw_ssp_td0 = GRAD_UPDATE_TIME;
    pw_theta_td0 = GRAD_UPDATE_TIME;
    pw_omega_td0 = GRAD_UPDATE_TIME;

    ia_gx1 = (int)(a_gx1 * (float)max_pg_iamp / loggrd.tx);
    ia_gxk = (int)(a_gxk * (float)max_pg_iamp / loggrd.tx);

    ia_gy1 = endview_iamp; /* GEHmr01804 */

    if (eoskillers == PSD_ON) {
	ia_gxk = (int)(a_gxk * (float)max_pg_iamp / loggrd.tx);
        if (ky_dir == PSD_TOP_DOWN) {
            ia_gyk = -1*(int)(a_gyk * (float)max_pg_iamp / loggrd.ty);
        } else {
            ia_gyk = (int)(a_gyk * (float)max_pg_iamp / loggrd.ty);
        }
	ia_gzk = (int)(a_gzk * (float)max_pg_iamp / loggrd.tz);
    }
    ia_rf1 = max_pg_iamp * (*rfpulse[RF1_SLOT].amp);
    ia_rf2 = max_pg_iamp * (*rfpulse[RF2_SLOT].amp);

    SpSatIAmp();

    if (cs_sat == PSD_ON) {
	ia_rfcssat = max_pg_iamp * (*rfpulse[RFCSSAT_SLOT].amp);
    }

    /* BJM: Omega Freq Mod Pulses */
    a_omega = 1;
    ia_omega = (a_omega*max_pg_iamp)/loggrd.tz;
    
    return SUCCESS;

}   /* end calcPulseParams() */


@inline ChemSat.e ChemSatEval
@inline ChemSat.e ChemSatCheck
@inline SpSat.e SpSatEval
@inline SpSat.e SatPlacement
@inline BroadBand.e BBHostFuncs
@inline Prescan.e PShost

/**************************************************************************/
/**************************************************************************/
@rsp

CHAR *entry_name_list[ENTRY_POINT_MAX] = { "scan",
                                           "mps2",
                                           "aps2",
                                           "ref",
					     
@inline Prescan.e PSeplist
};

int   deadtime;               /* amount of deadtime */
short viewtable[1025];        /* view table */
int   xrr_trig_time;          /* trigger time for filled or unfilled
		                 R-R interval which is not last R-R */
                  
float *viewpstart; /* starting exciter phase for 1st view of interleave */
float *viewpdelta; /* incremental delta phase between views of interleave */

short tempamp;

WF_PULSE tmppulse,*tmppulseptr;
WF_INSTR_HDR *tmpinstr;

FILE *fp;
char *infilename="ref.dat";
char *pathname="/usr/g/bin/";
char basefilename[80];

@rspvar
@inline Prescan.e PSrspvar

@inline RTB0.e RTB0rspvar

%ifdef RT 
@inline epiRTfile.e epiRT_rspvar
%endif

float rdx, rdy, rdz;     /* B0 phase dither in degrees, physical axes */
float dlyx, dlyy, dlyz;  /* gldelay acq/grad alignment real time variables */

int ref_switch = 0;   /* If 0 use prescribed FOV offset in exciter phase calc
		         If 1, don't used phase offset (for reference scan) */

int acq_data;  /* data acquisiton on/off flag */

int shot_delay;    /* trigger delay value for progressive gating */
int end_delay;     /* end of sequence wait time for conserved TR with
                      progressive gating */
int gyb_amp;       /* amplitude of gyb pulse */

int modrot = 0;      /* flag to determine whether rotation matrices should
                        be modified */
int rotx = 0;        /* rotate about x-axis this many degrees */
int roty = 0;        /* rotate about y-axis this many degrees */
int rotz = 0;        /* rotate about z-axis this many degrees */
int resrot = 0;      /* Reset to original rotation matrices */

int modloc = 0;      /* flag to determine whether locations should be modified */
int dso = 0;         /* delta slice select offset in mm */
int dro = 0;         /* delta readout offset in mm */
int dpo = 0;         /* delta phase encoding offset in mm */
int resloc = 0;      /* Reset to original location */
float xtr;         /* xtr tuning value */
float frt;         /* frt tuning value */

float timedelta;
int deltaomega,scaleomega;

int   sliceindex, pass,view,core_rep,excitation,slice,ileave,echo,pass_rep, pass_index;
int   ileave = 0;
int   slicerep = 0;
int   mod_rba = TRUE;
int   sl_rcvcf;        /*  center freq receive offset */
int   dabecho;         /* vars for loaddab */
int   dabecho_multi;
int   dabop = 0;
short debugstate;      /* if trace is on */
int   acq_sl;
int   rsp_card_intern; /* deadtime when next slice is internally gated in a
                          cardiac scan */
int   rsp_card_last;  /* dead time for last temporal slice of a cardiac scan */
int   rsp_card_fill;  /* dead time for last slice in a filled R-R interval */
int   rsp_card_unfill;/* dead time for last slice in a unfilled R-R interval */
short rsp_hrate;       /* cardiac heart rate */

/*jwg bb rsp vars*/
int freq_ctr = 0;
float met_freq = 0; 
int num_freqs = 0;
int phase_incr = 0;
float vfa_flip_ia = 0;
float vfa_flip_angle = 0;
/*jwg end*/


int pre_slnum;  /* Prescan slice number */

int echoOffset;
int dabmask, hsdabmask;

@inline SpSat.e SpSatRspVar
@inline ChemSat.e ChemSatRspVar
/* Define MRE RSP variables */
@inline touch.e TouchRspVar

int   rspent, rspgyc;
int BoreOverTempFlag = PSD_OFF;  /* used for fMRI */

short rspdda, rspbas, rspbasb, rspilv, rsprep, rspnex, rspchp, rspgy1,
    rspesl, rspasl, rspech, rspdex, rspslq,rspacq, rspacqb, 
    rspslqb, rspilvb, rspprp;

short rspvus, rspsct;   /* used by Prescan.e */
short rspe1st, rspetot;

/* ocfov fix MRIge26428 */
int refindex1, refindex2;
float refdattime[SLTAB_MAX];

/* blip correction array */
int rspia_gyboc[DATA_ACQ_MAX];

@pg
/*********************************************************************
 *                       EPI.E PULSEGEN SECTION                      *
 *                                                                   *
 * Write here the functional code that loads hardware sequencer      *
 * memory with data that will allow it to play out the sequence.     *
 * These functions call pulse generation macros previously defined   *
 * with @pulsedef, and must return SUCCESS or FAILURE.               *
 *********************************************************************/
@inline BroadBand.e BBPgFuncs
/* MRIge55206 - change memory allocation if in SIM for multi-dim array support */
#ifdef SIM
#include <stdlib.h>
#define AllocMem malloc
#else
#define AllocMem AllocNode
#endif
                                          
%ifdef RT
@inline epiRTfile.e epiRT_pgVars
@inline epiRTfile.e RTpgInit
%endif

/* BJM: SE Ref Scan */
@inline refScan.e refScanDeclPG

int tot_etl; /* internref */
                                           
long rsprot_orig[DATA_ACQ_MAX][9]; /* rotation matrix for SAT */
extern PSD_EXIT_ARG psdexitarg;
short *acq_ptr;               /* first slice in a pass */
int   *ctlend_tab;            /* table of cardiac deadtimes */
short *slc_in_acq;            /* number of slices in each pass */
/* Frequency/Phase offsets */
int   *rf1_freq;
int   *theta_freq;
int   *rf2_freq;
int   ***recv_freq;
int   ***recv_phase;
double ***recv_phase_angle;
int   **rf_phase_spgr;
WF_PULSE **echotrainxtr;
WF_PULSE **echotrainrba;
int *echotrainramp;
int *echotrainramp1;
int *echotrainramp2;
short **echotrainrampamp;
short **echotrainrampamp1;
short **echotrainrampamp2;

WF_PULSE_ADDR rtb0echoxtr;

/* The following arrays are indexed by intleave: */
int *gy1f;      /* amplitude of gy1f pulse */
int *gymn;      /* amplitude of y gradient moment nulling pulses */
int *view1st;   /* 1st view to acquire */
int *viewskip;  /* number of views to skip */
int *tf;        /* time factor shift */
int *rfpol;     /* rf polarity */
int *blippol;   /* blip gradient polarity */
int *gradpol;   /* readout gradient polarity */
float *b0ditherval;/* B0 dither value, per slice basis */
float *delayval;   /* delay values, per slice basis */
int *gldelaycval;  /* per slice gldelayc valuse */
float *gldelayfval; /* per slice gldelayf values */
int defaultdelay = 0; /* default delay */
int mintf;         /* most negative tfon value, for echo train positioning */
int sp_satindex, cs_satindex;  /* index for multiple calls to spsat
                                  and chemsat routines */
int rcvrunblankpos;

/*jwg bb for reading external waveform*/
char rf1froot[80]; 
char rf1_datfile[80]; 
/*jwg end*/

WF_PULSE gx1a = INITPULSE;
WF_PULSE gx1 = INITPULSE;
WF_PULSE gx1d = INITPULSE;

WF_PULSE rho_killer = INITPULSE;

WF_PULSE rs_omega_attack = INITPULSE;
WF_PULSE rs_omega_decay = INITPULSE;
WF_PULSE omega_flat = INITPULSE;

/* Define some more MRE variables */
WF_PULSE touch_gx_meg = INITPULSE;
WF_PULSE touch_gy_meg = INITPULSE;
WF_PULSE touch_gz_meg = INITPULSE;

long scan_deadtime;          /* deadtime in scan entry point */
long *scan_deadtime_correct; /* deadtime for each slice after correction*/ 
long prescan_trigger;        /* save the prescan slice's trigger */
long rsptrigger_temp[1];     /* temp trigger array for pass packets 
                                sequences and other misc */
/* Original scan info */
RSP_INFO orig_rsp_info[DATA_ACQ_MAX];
long origrot[DATA_ACQ_MAX][9];
WF_INSTR_HDR *instrtemp;

@inline Inversion.e InversionPGinit

/* BJM: SE Ref Scan */    
@inline refScan.e epiRefScanPulses
@inline refScan.e refScanFuncsPG

void
#ifdef __STDC__ 
dummyssi( void )
#else /* !__STDC__ */
    dummyssi() 
#endif /* __STDC__ */
{
    return;
}

/* Added for Inversion.e */
STATUS
#ifdef __STDC__
setupphases ( INT *phase,
              INT *freq,
              INT slice,
              FLOAT rel_phase,
              INT time_delay )
#else /* !__STDC__ */
    setupphases( phase, freq, slice, rel_phase, time_delay )
    INT *phase;                /* output phase offsets */
    INT *freq;                 /* precomputed frequency offsets */
    INT slice;                 /* slice number */
    FLOAT rel_phase;           /* in cycles */
    INT time_delay;            /* in micro seconds */
#endif /* __STDC__ */
{
    double ftime_delay;           /* floating point time delay in seconds */
    double temp_freq;             /* frequency offset */
    float tmpphase;
    int   intphase;
    int   sign;
    
    ftime_delay = ((double)time_delay)/((double)(1s));
    
    /* Convert tardis int to frequency */
    temp_freq = ((double)(freq[slice]))*TARDIS_FREQ_RES;
    
    /* Determine phase change in radians */
    tmpphase = (rel_phase - ( temp_freq * ftime_delay ))*2.0*PI;
    
    tmpphase /= (float)PI;    /* unwrap this phase bits */
    if (tmpphase < 0) {
        sign = -1;
        tmpphase *= -1;
    } else {
        sign = 1;
    }

    if ( ((int)floor((double)tmpphase) % 2) == 1) {
        sign *= -1;
        intphase = sign * (long)((1.0-(tmpphase - (float)floor((double)tmpphase)) ) * ((double)FSI));
    } else {
        intphase = sign * (long)((tmpphase - (float)floor((double)tmpphase)) * ((double)FSI));
    }

    phase[slice] = intphase;
    
    return SUCCESS;   
} /* end setupphases */


void
#ifdef __STDC__ 
ssisat( void )
#else /* !__STDC__ */
    ssisat()
#endif /* __STDC__ */
{
#ifdef IPG
    int next_slice;

    next_slice = sp_sat_index;
    sp_update_rot_matrix( &rsprot_orig[next_slice][0], sat_rot_matrices,
                          sat_rot_ex_num, sat_rot_df_num );
#endif /* IPG */
    return;
}


/***************************** setreadpolarity *************************/
STATUS
#ifdef __STDC__ 
setreadpolarity( void )
#else /* !__STDC__ */
    setreadpolarity()
#endif /* __STDC__ */
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

    setiamp(tia_gx1, &gx1a, 0);        /* x dephaser attack */
    setiamp(tia_gx1, &gx1, 0);         /* x dephaser middle */
    setiamp(tia_gx1, &gx1d, 0);        /* x dephaser decay  */
    setiamp(tia_gxw, &gxw, 0);

    /* Ramps are handled with opposite sign because of the way they
       are defined in the EP_TRAIN macro.  Please refer to epic.h
       for more details. */
    
    for (echo=1; echo < tot_etl; echo++) {
        if ((echo % 2) == 1) {  /* Even echo within interleave */ 
            setiamp(-tia_gxw, &gxwa, echo-1); /* waveforms go neg to pos in ep_train */
            setiamp(-tia_gxw, &gxwd, echo-1);
            setiamp(-tia_gxw, &gxw, echo);    /* const   */
        } else {                    /* Odd echo within interleave */
            setiamp(tia_gxw, &gxwa, echo-1); /* waveforms go neg to pos in ep_train */
            setiamp(tia_gxw, &gxwd, echo-1);
            setiamp(tia_gxw, &gxw, echo);     /* flattop   */
        }
    }
  
    
    if ((tot_etl % 2) == 1) {

        setiamp(-tia_gxw,&gxwde, 0);  /* decay,end */

	if (eosxkiller == 1) {
            setiamp(-tia_gxk,&gxka, 0);   /* killer attack */
            setiamp(-tia_gxk,&gxk, 0);    /* killer flattop */
            setiamp(-tia_gxk,&gxkd, 0);   /* killer decay  */
	}

    } else {

        setiamp(tia_gxw,&gxwde, 0);   /* decay,end */

	if (eosxkiller == 1) {
            setiamp(tia_gxk,&gxka, 0);    /* killer attack */
            setiamp(tia_gxk,&gxk, 0);     /* killer flattop */
            setiamp(tia_gxk,&gxkd, 0);    /* killer decay  */
	}
    }
    
    return SUCCESS;
}

STATUS
pulsegen( void )
{
    EXTERN_FILENAME ext_filename; /* filename holder for externals */
    int Rf2Location[NECHO_MAX]; /* time locations of Rf2 */
    short slmod_acqs;           /* slices%acqs */
    int tempx, tempy, tempz;
    int i;
#ifdef IPG
    int temps;
#ifdef SIM
    int j;
#endif /* SIM */
#endif /* IPG */
    int temp1, temp2;
    int echoloop;
    int psd_icnt,psd_jcnt;
    int psd_seqtime;      /* sequence time */
    int pg_tsp = 0;
    int stddab;           /* 1 = use standard dab, 0 = use hsdab */
    short *wave_space;
    short *temp_wave_space; /* temporary waveform space for rf scaling */
    short temp_res;         /* temporary resolution */
    int wave_ptr;           /* hardware wave pointer */
    float temp_gmnamp;  /* temporary amplitudes for y gmn calc */
    float tempa, tempb;
    int lpfval = -1;
    LONG pulsePos;
    float betax;

    tot_etl = etl + iref_etl; /* internref */
    
  /*jwg more additions for BB*/
 if((acquire_type == SPECPSD_SLAVE_H1)|| (acquire_type == SPECPSD_SLAVE_MNS))
   {	
	 requestTransceiver( psd_board_type, SLAVE_EXCITER, ALL_RECEIVERS);
   }
 else
   {
	 requestTransceiver( psd_board_type, MASTER_EXCITER, ALL_RECEIVERS);
   }    
        
    /* Set HPC timer set to 10 seconds (5 sec. per count) */
    setwatchdogrsp(watchdogcount); /* First give pulsegen a little extra time */
    sspinit(psd_board_type);
    
%ifdef RT
@inline epiRTfile.e epiRT_init_SSP_packets
%endif

#ifdef IPG
    /*
     * Execute this code only on the Tgt side
     */

#ifdef SIM

    /* Set rotation matrices for Simulation */
    simulationInit( rsprot[0] );

    /* Saved unscaled version of rotation matrices */
    for ( i = 0 ; i < (opslquant * opphases) ; i++ ) {

        if (obl_debug == PSD_ON){
            printf( "Slice %d\n", i );
        }

        for ( j = 0 ; j < 9 ; j++ ) {

            rsprot_unscaled[i][j] = rsprot[i][j];

            if (obl_debug == PSD_ON) {
                printf( "rsprot_unscaled[%d] = %ld\n", j, rsprot_unscaled[i][j] );
            }
        }
    }
#endif /* SIM */
#endif /* IPG */

    /* Initialize psdexitarg */
    psdexitarg.abcode = 0;
    strcpy(psdexitarg.text_arg, "pulsegen");
    view = slice = excitation  = 0;
 
@inline vmx.e VMXpg  
@inline BroadBand.e BBPgSetup    
    
  /*jwg have to fix this or download will fail*/
  ia_gxwas = 0;
       
    debugstate = debugipg;
  
    /* Allocate memory for various arrays.
     * An extra 2 locations are saved in case the user wants to do
     * some tricks. */
    acq_ptr = (short *)AllocNode((acqs*pass_reps + 2)*sizeof(short));
    ctlend_tab = (int *)AllocNode((opphases*opslquant + 2)*sizeof(int));
    slc_in_acq = (short *)AllocNode((acqs*pass_reps + 2)*sizeof(short));
    rf1_freq = (int *)AllocNode((opslquant + 2)*sizeof(int));
    theta_freq = (int *)AllocNode((opslquant + 2)*sizeof(int));
    rf2_freq = (int *)AllocNode((opslquant + 2)*sizeof(int));
    
    /* MRIge55206 */
    /* BJM - change to malloc() in SIM since AllocNode doesn't handle */
    /*       multi-dimensional arrays very well */
    recv_freq = (int ***)AllocMem(opslquant*sizeof(int **));
    for (psd_icnt = 0; psd_icnt < opslquant; psd_icnt++) {
	recv_freq[psd_icnt] = (int **)AllocMem(intleaves*sizeof(int *));
	for (psd_jcnt = 0; psd_jcnt < intleaves; psd_jcnt++)
            recv_freq[psd_icnt][psd_jcnt] = (int *)AllocMem(tot_etl*sizeof(int));
    }
    
    recv_phase = (int ***)AllocMem(opslquant*sizeof(int **));
    for (psd_icnt = 0; psd_icnt < opslquant; psd_icnt++) {
	recv_phase[psd_icnt] = (int **)AllocMem(intleaves*sizeof(int *));
	for (psd_jcnt = 0; psd_jcnt < intleaves; psd_jcnt++)
            recv_phase[psd_icnt][psd_jcnt] = (int *)AllocMem(tot_etl*sizeof(int));
    }
    
    recv_phase_angle = (double ***)AllocMem(opslquant*sizeof(double **));
    for (psd_icnt = 0; psd_icnt < opslquant; psd_icnt++) {
	recv_phase_angle[psd_icnt] = (double **)AllocMem(intleaves*sizeof(double *));
	for (psd_jcnt = 0; psd_jcnt < intleaves; psd_jcnt++)
            recv_phase_angle[psd_icnt][psd_jcnt] =
		(double *)AllocMem(tot_etl*sizeof(double));
    }
    
    rf_phase_spgr = (int **)AllocMem(opslquant*sizeof(int *));
    for (psd_icnt = 0; psd_icnt < opslquant; psd_icnt++) {
	rf_phase_spgr[psd_icnt] = (int *)AllocMem(intleaves*sizeof(int));
    }
    
    echotrainxtr = (WF_PULSE **)AllocNode(tot_etl*sizeof(WF_PULSE *));
    echotrainrba = (WF_PULSE **)AllocNode(tot_etl*sizeof(WF_PULSE *));
    echotrainramp = (int *)AllocNode(tot_etl*sizeof(int));
    echotrainramp1 = (int *)AllocNode(tot_etl*sizeof(int));
    echotrainramp2 = (int *)AllocNode(tot_etl*sizeof(int));
    echotrainrampamp = (short **)AllocNode(tot_etl*sizeof(short*));
    echotrainrampamp1 = (short **)AllocNode(tot_etl*sizeof(short*));
    echotrainrampamp2 = (short **)AllocNode(tot_etl*sizeof(short*));

    gy1f = (int *)AllocNode((intleaves+1)*sizeof(int));
    gymn = (int *)AllocNode((intleaves+1)*sizeof(int));
    view1st = (int *)AllocNode((intleaves+1)*sizeof(int));
    viewskip = (int *)AllocNode((intleaves+1)*sizeof(int));
    tf = (int *)AllocNode((intleaves+1)*sizeof(int));
    rfpol = (int *)AllocNode((intleaves+1)*sizeof(int));
    gradpol = (int *)AllocNode((intleaves+1)*sizeof(int));
    blippol = (int *)AllocNode((intleaves+1)*sizeof(int));
    b0ditherval = (float *)AllocNode((opslquant+1)*sizeof(float));
    delayval = (float *)AllocNode((opslquant+1)*sizeof(float));
    gldelaycval = (int *)AllocNode((opslquant+1)*sizeof(int));
    gldelayfval = (float *)AllocNode((opslquant+1)*sizeof(float));
    
#ifdef ERMES_DEBUG
    debugileave = 1;
#endif

    switch (ky_dir) {
    case PSD_TOP_DOWN:
	readpolar = 1;
	break;
    case PSD_BOTTOM_UP:
    case PSD_CENTER_OUT:
    default:
	if (etl % 2 == 1)  /* odd */
            readpolar = 1;
	else               /* even */
            readpolar = -1;  
	break;
    }

    /*
     * Set gradpol array for readout gradient amplitudes.
     */
    /* BJM: MRIge60610 - added num_overscan */ 
    /* internref: added iref_etl. Note etl does not count iref_etl */
    /* MRIge92386 */

    if (FAILURE == ileaveinit( fullk_nframes, ky_dir,
                               intleaves, ep_alt, readpolar, blippolar, debugileave, ia_rf1,
                               ia_gyb, pepolar, etl, seq_data, delt, tfon, fract_ky,
                               ky_offset, num_overscan, endview_iamp, esp, tsp, rhfrsize,
                               a_gxw, rhrcxres, slquant1, lpfval, iref_etl, gy1f, view1st,
                               viewskip, tf, rfpol, gradpol, blippol, &mintf ))
    {
        return FAILURE;
    }

    for (ileave = 0; ileave < intleaves; ileave++){
        if (ygmn_type == CALC_GMN1) {
            tempa = a_gy1a * (float)gy1f[ileave] / (float)endview_iamp;
            tempb = a_gy1b * (float)gy1f[ileave] / (float)endview_iamp;
            
            amppwygmn( gyb_tot_0thmoment, gyb_tot_1stmoment, pw_gy1a, pw_gy1,
                       pw_gy1d, tempa, tempb, loggrd.ty_xyz, (float)loggrd.yrt,
                       1, &pw_gymn1a, &pw_gymn1, &pw_gymn1d, &temp_gmnamp );
            
            gymn[ileave] = (int)((float)ia_gymn1 * a_gymn1/ temp_gmnamp);
            
            if (debugileave == 1) {
                printf( "gymn[%d] = %d, temp_gmnamp = %f\n",
                        ileave,gymn[ileave],temp_gmnamp );
            }
        } else {
            gymn[ileave] = 0;
        }
    }
    

#ifdef IPG
    /*
     * Execute this code only on the Tgt side
     */
    rdx = dx;
    rdy = dy;
    rdz = dz;
    
    dlyx = gldelayx;
    dlyy = gldelayy;
    dlyz = gldelayz;
    
    b0Dither_ifile( b0ditherval, ditheron, rdx, rdy, rdz, a_gxw, esp,
                    opslquant, debugdither, rsprot_unscaled, 
                    ccinx, cciny, ccinz, esp_in, fesp_in,
                    &g0, &num_elements, &file_exist );
    
    /* Account for rotation in delays.  Since each slice can have a different */
    /* rot mat, each slice is given its own delay */
    calcdelay( delayval, delayon, dlyx, dlyy, dlyz,
               &defaultdelay, opslquant,opgradmode, debugdelay, rsprot_unscaled ); 

#ifdef UNDEF
    calcdelayfile(delayval, delayon, dlyx, dlyy, dlyz,
                  &defaultdelay, opslquant, debugdelay, rsprot_unscaled, 
                  delay_buffer);    
#endif

    /* Set up slice dependent delays for SSP */
    for (slice = 0; slice < opslquant; slice++) {
        
        /* Adjust by daq window (e.g. ramp sampling) */
        delayval[slice] += dacq_adjust;
        
        /* Cast to nearest micro-second */
        if (delayval[slice] < 0.0)
            gldelaycval[slice] = (int)(delayval[slice] - 0.5);
        else
            gldelaycval[slice] = (int)(delayval[slice] + 0.5);
    }
    
    /* SPGR Stuff - not currently used */
    if (oppseq == PSD_SPGR)
	spgr_flag = 1;
    else
	spgr_flag = 0;
    
    for (slice = 0; slice < opslquant; slice++) {
        for (ileave = 0; ileave < intleaves; ileave++)
            rf_phase_spgr[slice][ileave] = 0;  /* call spgr function in future */
        
    }
#endif

    
    WAIT(XGRAD, x_td0, tlead, pw_x_td0);
    WAIT(YGRAD, y_td0, tlead, pw_y_td0);
    WAIT(ZGRAD, z_td0, tlead, pw_z_td0);
    WAIT(RHO, rho_td0, tlead, pw_rho_td0);
    WAIT(THETA, theta_td0, tlead, pw_theta_td0); /* YMSmr07445 */
    WAIT(OMEGA, omega_td0, tlead, pw_omega_td0);
    WAIT(SSP, ssp_td0, tleadssp, pw_ssp_td0);
    
@inline Inversion.e InversionPG 

    /* Spatial Sat *******************************************************/
    sp_satindex = 0;
    SpSatPG(vrgsat,sp_satstart, &sp_satindex, sp_satcard_loc);
    
    /* Chem Sat **********************************************************/
    cs_satindex = 0;
    if (cs_sat) ChemSatPG(cs_satstart, &cs_satindex);
  
    /* spsp 90 RF slice select pulse *******************************************/
    
    /*jwg bb for debugging*/
    fprintf(stderr,"rf pulse is %s \n", ssrffile);
    fprintf(stderr,"gradient file is %s \n", ssgzfile);
    if (thetaflag == 1) fprintf(stderr,"theta file is %s \n", ssthetafile);
    temp_res = res_rf1;
    if (rfpulseInfo[RF1_SLOT].change == PSD_ON)  /* set to new resolution */
	res_rf1 = rfpulseInfo[RF1_SLOT].newres;
    
    /* set rfunblank_bits[2] so that addrfbits in sliceselz does not
       unblank the receiver - see EpicConf.c for defaults. Will unblank
       the receiver later - MRIge28778 */
    
    rfunblank_bits[0][2] = SSPD;
    rfunblank_bits[1][2] = SSPD;
    
    EFFSLICESELZ_SPSP_JWG( rf1, pos_start + pw_gzrf1a, pw_rf1, opslthick,
                       flip_rf1, cyc_rf1, gztype, res_rf1,
                       ssgzfile, rftype, res_rf1, 
                       ssrffile, thetatype, 0, loggrd, ss_rf_wait ); 
		       
    if(thetaflag == 1) 
        {
		strcpy(fileloc_phaserf1,ssthetafile);
		/*jwg bb replace first argument THETA with wg_phaserf1*/
       		EXTWAVE(wg_phaserf1, phaserf1, pos_start + pw_gzrf1a, pw_phaserf1, a_phaserf1, 
			res_phaserf1, fileloc_phasef1, 0, loggrd);		       
	}
    
    /* reset the bit */
    rfunblank_bits[0][2] = SSPD + RUBL;
    rfunblank_bits[1][2] = SSPD + RUBL;
    
    if (rfpulseInfo[RF1_SLOT].change == PSD_ON)  /* change back for ext. file */
	res_rf1 = temp_res;
   
    /* 180 RF refocusing pulse ********************************************/
    if (oppseq == PSD_SE) {
#ifndef RT
	Rf2Location[0] = RUP_GRD((int)(pend(&rf1,"rf1",0) - rfExIso  + opte/2
                                       - pw_rf2/2) - psd_rf_wait);  /* Find start loc of 180s */
#else
        Rf2Location[0] = RUP_GRD((int)(pend(&rf1,"rf1",0) - rfExIso  + opte/2
                                       - pw_rf2/2) + 1000*ase_offset - psd_rf_wait);  /* Find start loc of 180s */
#endif
        
        /* MRIge58235: moved uextwave to here so the file read from disk is always read with orig. res_rf2 */
	strcpy(ext_filename, "rfse1b4.rho");
        
	/* Create some RHO waveform space, read in the 
	   se1b4 spin echo 180 to local memory, and then move
	   the local memory to the reserved RHO memory.
        */
	temp_wave_space = (short *)AllocNode(res_rf2*sizeof(short));
	uextwave(temp_wave_space, res_rf2, ext_filename);
        
        {
            /* MRIge58235: save orig. res_rf2 for scaling */
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
            SLICESELZ(rf2, Rf2Location[0], pw_rf2,
                      opslthick, flip_rf2, cyc_rf2, TYPNDEF, loggrd);
            
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
            SPACESAVER(RHO, rf2se1b4, res_rf2);
            movewaveimm(wave_space, &rf2se1b4, (int)0, res_rf2, TOHARDWARE);
            FreeNode(wave_space);
            
            /* MRIge58235: reset res_rf2 after scaling */
            res_rf2 = orig_res;
        }
        
	if (innerVol == PSD_ON) {
            TRAPEZOID(YGRAD, gyrf2iv, Rf2Location[0], 0.0, TYPNDEF, loggrd);
            ia_gzrf2 = 0;
	}
	
	setphase((float)(PI/-2.0), &rf2, 0);  /* Apply 90 phase shift to  180 */
        
	attenflagon(&rf1, 0);                 /* Assert ESSP flag on rf1 pulse */
	
	attenflagon(&rf2, 0);                 /* Assert ESSP flag on 1st rf2 */
        
        
	/* Z crushers (echo 1) ***********************************************/
	TRAPEZOID(ZGRADB, gzrf2l1,
                  pbeg(&gzrf2,"gzrf2", 0)-(pw_gzrf2l1+pw_gzrf2l1d), 0, TYPNDEF,
                  loggrd);
	
	TRAPEZOID(ZGRADB, gzrf2r1, pend(&gzrf2,"gzrf2d",0), 0, TYPNDEF, loggrd);
        
    } 
    
    /***********************************************************************/
    /* X EPI readout train                                                 */
    /***********************************************************************/
    
    /* For now assume a simple retiling. */
    if (fract_ky == PSD_FRACT_KY) {

        if ( ky_dir == PSD_BOTTOM_UP ) {
            echoOffset  = num_overscan/intleaves + iref_etl;
        } else {
            /* with fract_ky = ON and TOP down, echoffset is yes/2 */       
	    /* MRIge92386 */
            echoOffset  = fullk_nframes/intleaves/2 + iref_etl;
        }       

    } else {
	if (ky_dir == PSD_TOP_DOWN || ky_dir == PSD_BOTTOM_UP)
	    /* MRIge92386 */
            echoOffset  = fullk_nframes/intleaves/2 + iref_etl;
	else
            echoOffset  = 0;
    }
    
    /* BJM: pkt_delay is included to account for any delay between */
    /* sending the RBA and the first sample acquired (hardware delay) */
    if (vrgfsamp == PSD_ON) {
        dacq_offset = pkt_delay + pw_gxwad - 
            (int)(fbhw*((float)pw_gyb/2.0 + 
                        (float)pw_gybd) + 0.5);

        if(dacq_offset < 0) dacq_offset = 0;

    } else {
        dacq_offset = pkt_delay;
    }
    
    /* MRIge58023 & 58033 need to RUP_GRD entire expression */
    if (intleaves == fullk_nframes) {
	tempx = RUP_GRD((int)(pend(&rf1,"rf1",0) - rfExIso + opte - pw_gxw/2 - pw_gxwl - ky_offset*esp/intleaves));
    } else {
	tempx = RUP_GRD((int)(pend(&rf1,"rf1",0) - rfExIso + opte - echoOffset * esp - ky_offset*esp/intleaves - pw_iref_gxwait));
    }
    
    tempy = tempx + gydelay;
    tempz = tempx;
    tempx += gxdelay;
    
    /* Set up for EP_TRAIN */
    stddab = (hsdab==PSD_ON ? 0:1);
    pg_tsp =0;
    /* internref: use tot_etl instead of etl; added iref_etl */
    /*jwg bb this is where EPI readout starts!*/
    if(sake_flag == 0) sake_max_blip = 1;
    fprintf(stderr,"Before EP_TRAIN, pw_gyb and a_gyb are %d and %f \n",pw_gyb,a_gyb);
    EP_TRAIN((LONG)tempx + pw_gxwad,
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
    fprintf(stderr,"After EP_TRAIN, pw_gyb and a_gyb are %d and %f \n",pw_gyb,a_gyb);	     

    /*jwg bb run amppwgrad so that we can generate 'worst-case scenario' blip scheme*/
    /*if(sake_flag > 0)
    {
    	amppwgrad(area_gyb * (int)sake_max_blip, 5.0, 0.0, 0.0, loggrd.yrt, MIN_PLATEAU_TIME, &a_gyb, &pw_gyba, &pw_gyb, &pw_gybd);
    }
    */

    /* unblank receiver rcvr_ub_off us prior to first xtr/dab/rba packet */
    getssppulse(&(echotrainxtr[0]), &(echotrain[0]), "xtr", 0);
    rcvrunblankpos = echotrainxtr[0]->inst_hdr_tail->start;
    rcvrunblankpos += rcvr_ub_off;
    RCVRUNBLANK(rec_unblank, rcvrunblankpos,);

    if (tot_etl % 2 == 1) {
	getbeta(&betax, XGRAD, &epiloggrd);
	pulsePos = pend(&gxw, "gxw", tot_etl-1);
	createramp(&gxwde, XGRAD, pw_gxwad, -max_pg_wamp, 0,
                   (short)(maxGradRes*(pw_gxwad)/GRAD_UPDATE_TIME), betax);
	createinstr(&gxwde, pulsePos, pw_gxwad, -ia_gxw);
	pulsePos += pw_gxwad;
    }
    
    /***********************************************************************/
    /* X dephaser                                                          */
    /***********************************************************************/
    
    if (gx1pos == PSD_POST_180)
	temp1 = RUP_GRD((int)(pbeg(&gxw,"gxw",0) - (pw_gxwad + pw_gx1a +
						    pw_gx1 + pw_gx1d)));
    else
	temp1 = RUP_GRD((int)(pendall(&gzrf1, gzrf1.ninsts-1) + pw_gx1a +
                              pw_wgx + rfupd));
    
    pg_beta = loggrd.xbeta;
    
    pulsename(&gx1a,"gx1a");
    createramp(&gx1a,XGRAD,pw_gx1a,(short)0,
               max_pg_wamp,(short)(maxGradRes*(pw_gx1a/
                                               GRAD_UPDATE_TIME)),
               pg_beta);
    createinstr(&gx1a, (LONG)temp1, pw_gx1a, ia_gx1);
    
    if (pw_gx1 >= GRAD_UPDATE_TIME) {
	pulsename(&gx1,"gx1");
	createconst(&gx1,XGRAD,pw_gx1,max_pg_wamp);
	createinstr( &gx1,(LONG)(LONG)temp1+pw_gx1a,
                     pw_gx1,ia_gx1);
    }
    
    pulsename(&gx1d, "gx1d");
    if (single_ramp_gx1d == PSD_ON) {   /* Single ramp for gx1 decay into gxw
                                           attack */
        createramp(&gx1d, XGRAD, pw_gxwad, max_pg_wamp, -max_pg_wamp,
                   (short)(maxGradRes*(2*pw_gxwad/GRAD_UPDATE_TIME)), pg_beta);
        createinstr(&gx1d, (LONG)(temp1+pw_gx1a+pw_gx1), 2*pw_gxwad, ia_gx1);
    } else {                     /* decay ramp for gx1 */
        createramp(&gx1d,XGRAD,pw_gx1d,max_pg_wamp,
                   (short)0,(short)(maxGradRes*(pw_gx1d/GRAD_UPDATE_TIME)),
                   pg_beta);
	createinstr( &gx1d,(LONG)((LONG)temp1+pw_gx1a+pw_gx1),
                     pw_gx1d,ia_gx1);
        
	pulsename(&gxwa, "gxwa");  /* attack ramp for epi train */
	createramp(&gxwa, XGRAD, pw_gxwad, (short)0, max_pg_wamp,
                   (short)(maxGradRes*(pw_gxwad/GRAD_UPDATE_TIME)), pg_beta);
        if ( tot_etl%2 == 0 && ky_dir != PSD_TOP_DOWN )
            createinstr(&gxwa, (LONG)tempx, pw_gxwad, -ia_gxw);
        else
            createinstr(&gxwa, (LONG)tempx, pw_gxwad, ia_gxw);
    }
    
    /* Set readout polarity to gradpol[ileave] value */
    ileave = 0;
    setreadpolarity();
    
    if(rtb0_flag)
    {
        temp2 = pendall(&rf1, 0) + IMax(2, pw_gz1_tot, rfupd + 4us + rtb0_minintervalb4acq)+rtb0_acq_delay;
        ACQUIREDATA(rtb0echo, temp2, DEFAULTPOS, DEFAULTPOS, DABNORM);
        attenflagon( &(rtb0echo), 0 );

        getssppulse(&(rtb0echoxtr), &(rtb0echo), "xtr", 0);
        rcvrunblankpos = rtb0echoxtr->inst_hdr_tail->start;
        rcvrunblankpos += rcvr_ub_off;
        RCVRUNBLANK(rec_unblank2, rcvrunblankpos,);

        temp2 += esp;
    }
    else
    {
        /* Hyperscan DAB packet */
        temp2 = pendall(&rf1, 0) + rfupd + 4us;  /* 4us for unblank receiver */
    }

    HSDAB(hyperdab, temp2);
    
    /* If we don't reset frequency and phase on each view, then it is best
       to use a single packet at the beginning of the frame - one that doesn't
       shift with interleave.  This is because we want the constant part of Ahn
       correction to see continuous phase evolution across the views. */
    
    if (oppseq == PSD_SE) {
	temp2 = pendall(&rf2, 0) + rfupd + 4us;  /* 4us for unblank receiver */
    } else {
	temp2 = pendall(&rf1, 0) + rfupd + 4us;  /* 4us for unblank receiver */
    }
   
    /* Y prephaser ************************************************************/
    if (gy1pos == PSD_POST_180) {
	temp1 = pbeg(&gxw, "gxw", iref_etl) - pw_gxwad - pw_gy1_tot; /* internref */
        if(no_gy1_ol_gxw && iref_etl > 0) {
            temp1 -= esp;
        }
	temp1 = RDN_GRD(temp1);
    } else {
	temp1 = RDN_GRD(pend(&rf1,"rf1",0) + rfupd);
    }
    
    TRAPEZOID2(YGRAD, gy1, temp1, TRAP_ALL_SLOPED,,,endview_scale, loggrd);
    
    if (ygmn_type == CALC_GMN1) {
	temp1 = pbeg(&gy1a, "gy1a", 0) - pw_gymn2 - pw_gymn2d;
	TRAPEZOID(YGRAD, gymn2, temp1, 0, TYPNDEF, loggrd); 
	temp1 = pbeg(&gy1a, "gy1a", 0) - pw_gymn2_tot - pw_gymn1 - pw_gymn1d;
	TRAPEZOID(YGRAD, gymn1, temp1, 0, TYPNDEF, loggrd); 
    }
    
    /* Z prephaser ************************************************************/
    if (oppseq != PSD_SE || zgmn_type == CALC_GMN1) {
        if(ss_rf1 == PSD_ON)
        {
#if defined(IPG_TGT) || defined(MGD_TGT)
	   temp1 = RDN_GRD(pend(&gzrf1, "gzrf1", gzrf1.ninsts-1) + pw_gz1a);
#elif defined(HOST_TGT)
           temp1 = RDN_GRD(pend(&gzrf1d, "gzrf1d", gzrf1.ninsts-1) + pw_gz1a);
#endif
        }
        else
        {
	    temp1 = RDN_GRD(pendall(&gzrf1d, gzrf1.ninsts-1) + pw_gz1a);	
        }       

	/*jwg bb change start time of rephaser to decay ramp if needed*/
	if( opuser20 == 0) /*using default fat/water spsp rf*/
	{ 
	temp1 = RDN_GRD(pendall(&gzrf1, gzrf1.ninsts-1) + pw_gz1a); 
	} 
	else 
	{
	if ((int)opuser20 == 1)  /*only move to end of decay ramp if using a sinc, which is case 1*/
	{
	temp1 = RDN_GRD(pendall(&gzrf1d, gzrf1.ninsts-1) + pw_gz1a);			
	} 
	else /*using c13 spsp rf, no decay ramp */
	{ 
	temp1 = RDN_GRD(pendall(&gzrf1, gzrf1.ninsts-1) + pw_gz1a); 
	}
	}	
	
	/*fprintf(stderr,"rephaser starts at %d",temp1);*/
	TRAPEZOID( ZGRAD, gz1, temp1, 0, TYPNDEF, loggrd);
	
	if (zgmn_type == CALC_GMN1) {
            temp1 += (pw_gz1 + pw_gz1d + pw_gzmna);
            TRAPEZOID( ZGRAD, gzmn, temp1, 0, TYPNDEF, loggrd); 
	}
    }
    
    /* Added for Inversion.e */
    SPACESAVER(RHO, rf2se1, PSD_FSE_RF2_R);
    
    /* X killer pulse *********************************************************/
    if (eosxkiller == PSD_ON) {
	tempx = RUP_GRD(pend(&gxwde,"gxwde",0) + gkdelay + pw_gxka);
	TRAPEZOID(XGRAD, gxk, tempx, 0, TYPNDEF, loggrd);
    }
    
    /* Y killer pulse *****************************************************/
    if (eosykiller == PSD_ON) {
	tempy = RUP_GRD(pend(&gxwde,"gxwde",0) + gkdelay + pw_gyka);
	TRAPEZOID(YGRAD, gyk, tempy, 0, TYPNDEF, loggrd);
    }
    
    /* Z killer pulse *****************************************************/
    if (eoszkiller == PSD_ON) {
	tempz = RUP_GRD(pend(&gxwde,"gxwde",0) + gkdelay + pw_gzka);
	TRAPEZOID(ZGRAD, gzk, tempz, 0, TYPNDEF, loggrd);
    }

    /* Add MRE waveforms */
@inline touch.e TouchPg

    /* RHO killer? pulse ***********************************************/
    /* This pulse is specific to MGD.  It forces the RHO sequencer to  */
    /* EOS after all other RF sequencers (omega & theta) as a temp fix */
    /* for a sequencer buffer glitch.                                  */

    if (eosrhokiller == PSD_ON) {

        int pw_rho_killer = 2;
        int ia_rho_killer = 0;

	tempz = RUP_GRD(pend(&gxwde,"gxwde",0) + gkdelay + pw_gzka);
        pulsename(&rho_killer,"rho_killer");
        createconst(&rho_killer,RHO,pw_rho_killer,MAX_PG_WAMP);
        createinstr( &rho_killer,(long)(tempz),
                     pw_rho_killer,ia_rho_killer);
    }
   
#ifdef IPG
    /*
     * Execute this code only on the Tgt side
     */
    /* Major "Wait" Pulses ************************************************/
    if (gy1pos == PSD_POST_180)
        tempy = pbeg(&gy1a, "gy1a", 0) - pw_wgy;
    else
        tempy = pbeg(&gyba, "gyba", 0) - pw_wgy;
    
    if (ygmn_type == CALC_GMN1)
        tempy = pbeg(&gymn1a, "gymn1a", 0) - pw_wgy;
    
    if (gx1pos == PSD_POST_180)
        tempx = pbeg(&gx1a, "gx1a", 0) - pw_wgx;
    else
        tempx = pbeg(&gxwa, "gxwa", 0) - pw_wgx;
    
    /* TFON sliding data acq. window wait intervals */
    WAIT(XGRAD, wgx, tempx, pw_wgx );
    WAIT(YGRAD, wgy, tempy, pw_wgy );
    
    if (oppseq == PSD_SE) {
	tempz = pendall(&gzrf2r1, 0);
    } else {
	if (zgmn_type == CALC_GMN1) {
            tempz = pendall(&gzmnd, 0);
        } else {
            tempz = pendall(&gz1d, 0); /*jwg bb i think there may be a problem here, come back to*/
        }
    }
 
    /* For MR-Touch, match with wgx by using tempx instead of tempz */
    WAIT(ZGRAD, wgz, touch_flag ? tempx : tempz, pw_wgz);

    if (oppseq == PSD_SE) {
        temps = pendall(&rf2, 0) + rfupd + 4us;
    } else {
        temps = pendall(&rf1, 0) + rfupd + 4us + (int)HSDAB_length;
    }

    WAIT(SSP, wssp, temps, pw_wssp);
    
    pw_sspdelay = defaultdelay + 1us;	/* 1us is the min time for ssp,
					   per L. Ploetz. YPD */
    WAIT(SSP, sspdelay, temps + pw_wssp, pw_sspdelay);
    
    pw_omegadelay = RUP_RF(defaultdelay+2us); /* 2us is the min time for omega,
                                                 per L. Ploetz. YPD */
    WAIT(OMEGA, omegadelay, RUP_GRD(temps), pw_omegadelay );
    
    WAIT(OMEGA, womega, RUP_GRD(temps)+pw_omegadelay, pw_womega);
    
    /* pulse names for Omega Freq Mod pulses */ 
    pulsename(&rs_omega_attack, "rs_omega_attack");
    pulsename(&rs_omega_decay, "rs_omega_decay");
    pulsename(&omega_flat, "omega_flat");

    /* internref: use tot_etl instead of etl */
    for (echoloop = 0; echoloop < tot_etl; echoloop++ ) {
        getssppulse(&(echotrainrba[echoloop]), &(echotrain[echoloop]), "rba", 0);

        {   /* local scope */

            int time_offset = 0;
            pulsepos = pendallssp(echotrainrba[echoloop], 0); 
            time_offset = pw_gxwad - dacq_offset;  
 
            /* TURN TNS ON at the first etl and OFF at the last etl so that */
            /* the xtr and TNS do not overlap. */
            if ( echoloop == 0) TNSON(e1entns,pulsepos);
            if ( echoloop == tot_etl-1) TNSOFF(e1distns,pulsepos + (int)(tsp*(float)rhfrsize));

            if (vrgfsamp) {
	        /*jwg bb change first variable from OMEGA to wg_omegaro1 so we can broadband this sucker*/
                trapezoid( wg_omegaro1,"omega", &omega_flat, 
                           &rs_omega_attack, &rs_omega_decay,
                           pw_gxwl+pw_gxw+pw_gxwr,  pw_gxwad, pw_gxwad, 
                           ia_omega,ia_omega,ia_omega, 0, 0, 
                           RUP_RF(pulsepos-time_offset+start_pulse), TRAP_ALL, &loggrd);    
            } else {
                
                /* BJM: to offset frequency, play constant on omega */
		/* jwg bb and we'll do the same thing down here, in case we're not ramp sampling*/
                createconst(&omega_flat, wg_omegaro1, pw_gxw, max_pg_wamp);
                createinstr(&omega_flat, RUP_RF(pulsepos+start_pulse), pw_gxw, ia_omega);
            }

        }
    }
    
    /* 4us for the e1distns pack */
    temps = pendallssp(&echotrain[tot_etl-1], 0) + (int)(tsp*(float)rhfrsize)+ 4; 
    
    ATTENUATOR(atten, temps);

%ifdef RT
@inline epiRTfile.e epiRT_SSP_Packets
%endif

    /* spring for sspdelay */
    WAIT(SSP, sspshift, temps + 7us, pw_sspshift);
    
    temps = pendallssp(&sspshift, 0);
   
    for (i=0; i<num_passdelay; i++) { 
        WAIT(SSP, ssp_pass_delay, temps, 1us);
        temps = pendallssp(&ssp_pass_delay, i);
    }
    
    
    PASSPACK(pass_pulse, temps);

    /*jwg bb testing out different delays here to try and fix the shifts in PE direction*/    
    temps = pendallssp(&pass_pulse, 0);
    WAIT(SSP, jwg_delay,temps, 4us);
    /*jwg bb end*/

    if (touch_flag) {
        /* Add WAIT pulse to SSP to sync trigger pulses with MEG */
        WAIT(SSP, touch_wssp, pendallssp(&pass_pulse,0), pw_touch_wssp);
    }

#endif /* IPG */
    
    /* Actual deadtimes for cardiac scans will be rewritten later */
    if(opcgate==PSD_ON)
	    psd_seqtime = RUP_GRD(tmin);
    else
    {
        if(tr_corr_mode == 0) psd_seqtime = RUP_GRD(act_tr/slquant1 - time_ssi);
        else psd_seqtime = RDN_GRD(act_tr/slquant1 - time_ssi);
    }
    
    SEQLENGTH(seqcore,psd_seqtime,seqcore);
    
    getperiod(&scan_deadtime, &seqcore, 0);

    if(opcgate == PSD_OFF)
    {
        int num;
        /* To make sure repetition time is exactly equal to act_tr */
        scan_deadtime_correct = (long *)AllocNode((slquant1 + 2)*sizeof(long));
        switch(tr_corr_mode)
        {
            case 0:
                for(i=0; i<slquant1; i++)
                {
                     scan_deadtime_correct[i] = scan_deadtime;
                }
            break;

            case 1:
                num = (act_tr - (psd_seqtime+time_ssi)*slquant1)/GRAD_UPDATE_TIME;
                for(i=0; i<slquant1; i++)
                {
                    if(i<num) scan_deadtime_correct[i] = scan_deadtime+GRAD_UPDATE_TIME;
                    else scan_deadtime_correct[i] = scan_deadtime;
                }
            break;

            case 2:
                for(i=0; i<slquant1-1; i++)
                {
                    scan_deadtime_correct[i] = scan_deadtime;
                }
                scan_deadtime_correct[slquant1-1] = scan_deadtime + act_tr - (psd_seqtime+time_ssi)*slquant1; 
            break;
        }
    }

    /* BJM: SE Ref Scan */
@inline refScan.e epiRefScanPG

    /* PS **************************************************************/
@inline Prescan.e PSpulsegen
  
    if (SatRelaxers) /* Create Null sequence for Relaxers */
        SpSatCatRelaxPG(time_ssi);
    
    /* Baseline Acquisition *********************************************/
    RCVRUNBLANK(bline_unblank, (LONG)(3ms) , 0);
    FASTACQUIREDATA(blineacq1,
                    (LONG)(5ms), 
                    (LONG)fast_rec,
                    (LONG)stddab,
                    (LONG)0,
                    (LONG)0,
                    (TYPDAB_PACKETS)DABNORM);
    
    /* set up HyperScan Dab for Baseline */
    HSDAB(hyperdabbl,1ms);
    
    SEQLENGTH(seqblineacq, bl_acq_tr2, seqblineacq);

    SEQLENGTH(seqRTclock, RDN_GRD(time_ssi+4), seqRTclock);

    buildinstr();              /* load the sequencer memory */

    if (SatRelaxers) /* Use X and Z Grad offsets from off seqcore */
        SpSatCatRelaxOffsets(off_seqcore);
    
@inline Inversion.e InversionPG1

    if (PSD_ON == touch_flag)
    {
#ifdef IPG
        if((fp=fopen(".SKIP_MRE_DRIVER","r"))==NULL)
        {
            /* Make frequency slightly larger to ensure that the driver
             * completes prior TR */
            if ( FAILURE == setmrtouchdriver(touch_act_freq/0.99,
                                             touch_burst_count,
                                             touch_driver_amp) )
            {
                return FAILURE;
            }
        }
#endif
    }

    /*  ***********************************************************
        Initialization
        ********************************************************** */
  
    if (oppseq == PSD_SE) {   /* point to proper waveform */
        getwave(&wave_ptr, &rf2se1b4);
	setwave(wave_ptr, &rf2, 0);
    }
    
    rspdex = dex;
    rspech = 0;
    rspchp = CHOP_ALL;
    
    num_freqs = (int)opuser21; /*jwg bb*/
   /* for (i = 0; i < opfphases; i++)
    {
	vfa_flips_angle[i] = vfa_flips[i];
    }
    */
    
#ifdef IPG
    /*
     * Execute this code only on the Tgt side
     */
    /* Find frequency offsets */
    setupslices(rf1_freq, rsp_info, opslquant, a_gzrf1, 
                (float)1, (opfov*freq_scale), TYPTRANSMIT); 
    setupslices(theta_freq, rsp_info, opslquant, a_gzrf1/omega_scale,
                (float)1, (opfov*freq_scale), TYPTRANSMIT);
    
    if (oppseq == PSD_SE || se_ref == PSD_ON)
	setupslices(rf2_freq, rsp_info, opslquant, a_gzrf2,
                    (float)1, (opfov*freq_scale), TYPTRANSMIT);

    if (ipg_trigtest == 0) {
	/* Inform the Tgt of the trigger array to be used */
	/* Following code is just here to support Tgt oversize
	   board which only supports internal gating */
	for (slice=0; slice < opslquant*opphases; slice++)
            rsptrigger[slice] = (short)TRIG_INTERN;
	slice = 0;
    }
    
    settriggerarray((short)(opslquant*opphases),rsptrigger);
    
    /* Inform the Tgt of the rotation matrix array to be used.
       For everything but CFH and CFL the sat pulses are played
       out so load the sat rotation matrix. Otherwise
       the original slice rotation matrix is used. */

    /*jwg bb may need to change this to account for num_freq loop, if needed!*/
    SpSat_set_sat1_matrix(rsprot_orig, rsprot, opslquant*opphases,
                          sat_rot_matrices, sat_rot_ex_num, sat_rot_df_num,
                          sp_satcard_loc, 0);
    
    /* Inform the Tgt of the rotation matrix array to be used */
    setrotatearray( (short)(opslquant * opphases), rsprot[0] );
#endif /* IPG */

    sl_rcvcf = (int)((float)cfreceiveroffsetfreq / TARDIS_FREQ_RES);
    
    /* Set up SlcInAcq and AcqPtr tables for multipass scans and
     * multi-repetition scans, including cardiac gating, interleaved,
     * and sequential multi-rep modes.
     * SlcInAcq array gives number of slices per array.
     * AcqPtr array gives index to the first slice in the 
     * multislice tables for each pass. */
    
    /* cardiac gated multi-slice, multi-phase, multi-rep */
    if (opcgate==PSD_ON) {
        rspcardiacinit((short)ophrep, (short)piclckcnt);
        sliceindex = acqs - 1; /* with cardiac gating, acqs is the no. of slices */
        for (pass = 0; pass < acqs; pass++)  {
            slc_in_acq[pass] = slquant1*opphases;
            if (pass == 0) {
                acq_ptr[pass] = 0;
            } else {
                acq_ptr[pass] = sliceindex;
                sliceindex = sliceindex - 1;
	    }
  	} /* repeat the table for multi-reps */
        for (pass_rep = 1; pass_rep < pass_reps; pass_rep++)  {
            for (pass = 0; pass < acqs; pass++)  {
                slc_in_acq[pass + pass_rep*acqs] = slc_in_acq[pass];
                acq_ptr[pass + pass_rep*acqs] = acq_ptr[pass];
	    }
	}
    } else {
        if ( mph_flag==PSD_OFF ) {  /* single-rep interleaved multi-slice */
            slmod_acqs = (opslquant*reps)%acqs;
            for (pass = 0; pass < acqs; pass++) {
                slc_in_acq[pass] = (opslquant*reps)/acqs;
                if (slmod_acqs > pass)
                    slc_in_acq[pass] = slc_in_acq[pass] + 1;
                acq_ptr[pass] = (int)(opslquant/acqs) *pass;
                if (slmod_acqs <= pass)
                    acq_ptr[pass] = acq_ptr[pass] + slmod_acqs;
                else
                    acq_ptr[pass] = acq_ptr[pass] + pass;
            }
        }
        if ( (mph_flag==PSD_ON) && (acqmode==1)) {  /* mph, sequential */
            for (pass=0; pass<acqs; pass++) {  /* for sequential, acqs=opslquant */
                slc_in_acq[pass] = reps;
                acq_ptr[pass] = pass;
            }
        }
        if ( (mph_flag==PSD_ON) && (acqmode==0) ) {  /* mph, interleaved, single pass */
            for (pass = 0; pass < acqs; pass++) {
                slc_in_acq[pass] = slquant1;
                acq_ptr[pass] = 0;
                slmod_acqs = (opslquant*reps)%acqs;
                for (pass = 0; pass < acqs; pass++) {
                    slc_in_acq[pass] = (opslquant*reps)/acqs;
                    if (slmod_acqs > pass)
                        slc_in_acq[pass] = slc_in_acq[pass] + 1;
                    acq_ptr[pass] = (int)(opslquant/acqs) *pass;
                    if (slmod_acqs <= pass)
                        acq_ptr[pass] = acq_ptr[pass] + slmod_acqs;
                    else
                        acq_ptr[pass] = acq_ptr[pass] + pass;
                }
            }
            for (pass_rep = 1; pass_rep < pass_reps; pass_rep++) { /* repeat the table for multi-reps */
                for (pass = 0; pass < acqs; pass++) {
                    slc_in_acq[pass + pass_rep*acqs] = slc_in_acq[pass];
                    acq_ptr[pass + pass_rep*acqs] = acq_ptr[pass];
                }
            }
        }
    }
    
    /* Save the trigger for the prescan slice. */
    prescan_trigger = rsptrigger[acq_ptr[pre_pass] + pre_slice];

    rsptrigger_temp[0] = TRIG_INTERN;
    
#ifdef IPG
    /*
     * Execute this code only on the Tgt side
     */
    /* Save copy of scan_info table */ 
    for(temp1=0; temp1<opslquant; temp1++) {
        orig_rsp_info[temp1].rsptloc = rsp_info[temp1].rsptloc;
        orig_rsp_info[temp1].rsprloc = rsp_info[temp1].rsprloc;
        orig_rsp_info[temp1].rspphasoff = rsp_info[temp1].rspphasoff;
        for (temp2=0; temp2<9; temp2++) {
            origrot[temp1][temp2] = rsprot[temp1][temp2];
        }
    }
    
    /* Fill echotrain xtr and rba arrays with SSP pulse structures */
    for (echoloop = 0; echoloop < tot_etl; echoloop++ ) {
        getssppulse(&(echotrainxtr[echoloop]), &(echotrain[echoloop]), "xtr", 0);
        getssppulse(&(echotrainrba[echoloop]), &(echotrain[echoloop]), "rba", 0);

        if(vrgfsamp) {
            /* Attack Ramp */
            instrtemp = (WF_INSTR_HDR *)GetPulseInstrNode(&rs_omega_attack,(int)echoloop);
            echotrainramp1[echoloop] = (int)instrtemp->wf_instr_ptr;
            echotrainrampamp1[echoloop] = (short*)(&(instrtemp->amplitude)); 

            /* Flattop */
            instrtemp = (WF_INSTR_HDR *)GetPulseInstrNode(&omega_flat,(int)echoloop);
            echotrainramp[echoloop] = (int)instrtemp->wf_instr_ptr;   
            echotrainrampamp[echoloop] = (short*)(&(instrtemp->amplitude)); 
 
            /* Decay Ramp */
            instrtemp = (WF_INSTR_HDR *)GetPulseInstrNode(&rs_omega_decay,(int)echoloop);
            echotrainramp2[echoloop] = (int)instrtemp->wf_instr_ptr;
            echotrainrampamp2[echoloop] = (short*)(&(instrtemp->amplitude)); 

        } else {
           
            /* Constant Freq Offset, no ramp samp */
            instrtemp = (WF_INSTR_HDR *)GetPulseInstrNode(&omega_flat,(int)echoloop);
            echotrainramp[echoloop] = (int)instrtemp->wf_instr_ptr; 
            echotrainrampamp[echoloop] = (short*)(&(instrtemp->amplitude)); 
            
        } /* end vrgfsamp */

    } /* end echoloop */
    
    hsdabmask = PSD_LOAD_HSDAB_ALL;
    scaleomega = 0;

    /* Initialize MRE RSP variables */
@inline touch.e TouchRspInit

#endif /* IPG */

    return SUCCESS;

} /* end pulsegen */

/* Add MRE RSP functions for manipulating the MEG */
@inline touch.e TouchEncodePg
@inline ChemSat.e ChemSatPG
@inline SpSat.e SpSatPG
@inline Prescan.e PSipg

@rsp
/*********************************************************************
 *                        EPI.E RSP SECTION                          *
 *                                                                   *
 * Write here the functional code for the real time processing (Tgt  *
 * side). You may declare standard C variables, but of limited types *
 * short, int, long, float, double, and 1D arrays of those types.    *
 *********************************************************************/
#include "pgen_tmpl.h" 
#include "epic_loadcvs.h"
#include "pgen_errstruct.h"

@inline BroadBand.e BBRsps

@inline epiMaxwellCorrection.e epiMaxwellCorrection 
@inline epiRtd.e epiRTD

@inline RTB0.e RTB0Core
float rtb0_base_cfoffset = 0.0; /* center frequency offste at the first time point */
float rtb0_comp_cfoffset = 0.0; /* center frequency offset for compensation */
int rtb0_comp_cfoffset_TARDIS = 0;
int rtb0_rtp_1streturn = PSD_OFF;
int rtb0_outlier_count = 0;

/* BJM: SE Ref Scan */
@inline refScan.e refScanDecl

STATUS
#ifdef __STDC__ 
psdinit( void )
#else /* !__STDC__ */
    psdinit() 
#endif /* __STDC__ */
{
 
    strcpy(psdexitarg.text_arg, "psdinit");  /* reset global error variable */

    deltaomega = 0;
    timedelta = 0;
/*jwg bb set up rfconf depending on nucleus selected*/
    setrfconfig((short)rfconf);    
/*jwg end*/    
  
    /* Clear the SSI routine. */
    if (opsat == PSD_ON)
        ssivector(ssisat, (short) FALSE);
    else 
        ssivector(dummyssi, (short) FALSE);
  
    /* turn off dithering */
    setditherrsp(dither_control,dither_value);
  
    /* Set ssi time.  This is time from eos to start of sequence interrupt
       in internal triggering.  The minimum time is 50us plus 2us*(number of
       waveform and instruction words modified in the update queue).
       Needs to be done per entry point. */
    setssitime((LONG)time_ssi/GRAD_UPDATE_TIME);
  
    scopeon(&seqcore);    /* reset all scope triggers */

    scopeoff(&seqblineacq);
  
    syncon(&seqcore);  /* reset all synchronizations, not needed in pass */
  
    /* Set trigger for cf and 1st pass prescan.
       Reset trigger the prescan slice to its scan trigger for 
       scan and second pass prescan entry points. */
    if ((rspent == L_CFL) || (rspent == L_CFH) || 
        (rspent == L_MPS1) || (rspent == L_APS1)) {
        rsptrigger[acq_ptr[pre_pass] + pre_slice] = trig_prescan;
      
        if (ipg_trigtest == 0) 
            /* Remove next line when line gating supported */
            rsptrigger[acq_ptr[pre_pass] + pre_slice] = TRIG_INTERN;
        else 
            rsptrigger[acq_ptr[pre_pass] + pre_slice] = prescan_trigger;

    }

    /* Allow for manual trigger override for testing. */      
    if (((psd_mantrig == PSD_ON) || (opcgate == PSD_ON)) && 
        ((rspent == L_APS2) || (rspent == L_MPS2) || (rspent == L_SCAN) || (rspent == L_REF)) ) {
        for (slice=0; slice < opslquant*opphases; slice++) {
          
            if (rsptrigger[slice] != TRIG_INTERN) {
                switch(rspent){
                case L_MPS2:
                    rsptrigger[slice] = trig_mps2;
                    break;
                case L_APS2:
                    rsptrigger[slice] = trig_aps2;
                    break;
                case L_SCAN:
                case L_REF:
                    rsptrigger[slice] = trig_scan;
                    break;
                default:
                    break;
                }
            }
	}
    }
  
    /* Inform the Tgt of the location of the trigger arrays. */
    settriggerarray((short)(opslquant*opphases), rsptrigger);
  
    /* Inform the Tgt of the rotation matrix array to be used */
    setrotatearray((short)(opslquant*opphases), rsprot[0]);
  
    pass = 0;
    pass_index = 0;
    rspacqb = 0;
    rspacq = acqs;
    rspprp = pass_reps;
    /* Motion encoding gradients not played during prescan or
     * non MR-Touch scans.  Default to 1 and update as needed
     * in scan() */
    rsp_cmndir = 1;
  
    /* DAB initialization */
    dabop = 0;    /* Store data */
    dabecho = 0;  /* first dab packet is for echo 0 */

    /* use the autoincrement echo feature for subsequent echos */
    dabecho_multi = -1;
    BoreOverTempFlag = 0;
 
    CsSatMod(cs_satindex);
    SpSatInitRsp((INT)1, sp_satcard_loc,0);
    
    if (gyctrl == PSD_ON) {
        gyb_amp = blippol[0];
    } else {
        gyb_amp = 0;
    }

    rspgyc = gyctrl;
    rspslqb = 0;
    rspslq = slquant1;
    rspilvb = 0;
    rspilv = intleaves;
    rspbasb = 1;

    /* BJM: for XTR-RBA timing calculation, need to shut off X & Y grad. */
    if (gxctrl == PSD_OFF || xtr_calibration == (PSD_ON + 1)) {

        /* turn off the readout axis */
        setieos((SHORT)EOS_DEAD, &x_td0,0);

    } else {

        /* turn it on */
        setieos((SHORT)EOS_PLAY, &x_td0, 0);

    }

    if (xtr_calibration == (PSD_ON + 1)) {

        /* turn off the phase encode axis */
        setieos((SHORT)EOS_DEAD, &y_td0,0);

    } else {

        /* turn it on */
        setieos((SHORT)EOS_PLAY, &y_td0, 0);

    }

    if (gzctrl == PSD_OFF) {

        /* turn off slice select axis */
        setieos((SHORT)EOS_DEAD, &z_td0,0);

    } else {

        /* turn it on */
        setieos((SHORT)EOS_PLAY, &z_td0, 0);
    }

    /* Update the exciter freq/phase tables */
    if (rspent == L_REF)
        ref_switch = 1;
    else
        ref_switch = 0;
  
    xtr = 0.0;
    frt = frtime;

    /* BJM: refdattime is no longer used to prephase the echoes */
    /* keep it until the epiRecvFrqPhs() interface is modified. */
    {
        int slc;
      
        /* No need to calculate refdattime */
        for( slc = 0; slc < opslquant; slc++ ) {
            refdattime[slc] = 0.0;
        }
    }

    /* BJM: MRIge54033 - refdattime now passed as array (one entry for each slice) */
    /* internref: use tot_etl; added iref_etl */
    /* MRIge92386 */ /*MRIhc00996*/
    epiRecvFrqPhs( opslquant, intleaves, etl, xtr-timedelta, refdattime, frt,
                   opfov, fullk_nframes,
                   opphasefov,  b0ditherval, rf_phase_spgr, dro, dpo,
                   rsp_info, view1st, viewskip, gradpol,
                   ref_switch = (rspent==L_REF ? 1:0), ky_dir, dc_chop,
                   pepolar, recv_freq, recv_phase_angle, recv_phase,
                   gldelayfval, a_gxw, debugRecvFrqPhs, ref_with_xoffset,
                   asset_factor, iref_etl );

    /* Call MaxwellCorrection Function (see epiMaxwellCorrection.e) */
    if( epiMaxwellCorrection() == FAILURE) return FAILURE; 

    ref_switch = 0;

    if ((intleaves > 1) && (ep_alt > 0)) {

        ileave = 0;

        setreadpolarity();  /* make sure readout gradient polarity is set
                               properly */
        /* BJM: SE Ref Scan */
        if(se_ref == PSD_ON) 
            setreadpolarity_ref();

    }
 
    rspe1st = 0;
    rspetot = tot_etl;

    /* phase-encoding blip correction for oblique scan planes */
    blipcorr(rspia_gyboc,da_gyboc,debug_oblcorr,rsprot_unscaled,oc_fact,cvxfull,
             cvyfull,cvzfull,bc_delx,bc_dely,bc_delz,oblcorr_on,opslquant,
             &epiloggrd,pw_gyb,pw_gyba,a_gxw);

    /* Call to set filter in HSDAB packet for EPI */ 
    setEpifilter(scanslot,&hyperdab); 

    /* BJM: SE Ref Scan */
    if(se_ref == PSD_ON)
        setEpifilter(scanslot,&hyperdabref);
 
    return SUCCESS;  

} /* End psdinit */	    

/* *******************************************************************
   CardInit
   RSP Subroutine

   Purpose:
   To create an array of deadtimes for each slice/phase of the first
   pass in a cardiac scan.  For multi-phase scans, this same array can be
   used as the slices are shuffled in each pass to obtain new phases.

   Description: The logic for creating the deadtime array for
   multiphase scans is rather simple.  All of the slices except the last
   slice have the same deadtime.  This deadtime will assure that the
   repetition time between slices equals the inter-sequence delay time.
   The last slice has a deadtime that will run the logic board until the
   beginning of the cardiac trigger window.

   The logic for creating the deadtime for single phase, or cross R-R
   scans, is much more complicated.  In these scans, the operator
   prescribes over how many R-R intervals (1-4) the slices should be
   interleaved over.  The deadtimes for the last slice in each R-R
   interval will be different depending on whether the R-R interval is
   filled, unfilled, or the last R-R interval. For example, lets say 14
   slices are to be interleaved among 4 R-R intervals.  4 slices will be
   placed in the first R-R, 4 in the second, 3 in the third, and 3 in the
   fourth.  This prescription has 2 filled R-R intervals, 1 unfilled R-R
   interval, and a final R-R interval.  The deadtimes for slices which
   are not the last slice in a R-R interval is the same deadtime that
   assures that the inter-sequence delay time is met.

   Parameters:
   (O) int ctlend_tab[]  table of deadtimes
   (I) int ctlend_intern deadtime needed to maintain intersequence delay time.
   Delay when next slice will be internally gated.
   (I) int ctlend_last   Delay time for last slice in ophrep beats.  Deadtime needed
   to get proper trigger delay for next heart beat. 
   (I) int ctlend_fill   Dead time for filled R-R interval.  Not used in multi-phase
   scans. 
   (I) int ctlend_unfill Deadtime of last slice in an unfilled R-R interval.  Not used in
   multi-phase scans.
   *********************************************************************** */

/**************************  CardInit  *********************************/
STATUS CardInit( INT ctlend_tab[], INT ctlend_intern, INT ctlend_last, INT ctlend_fill, INT ctlend_unfill)
{
    int rr = 0;  /* index for current R-R interval - 1 */
    int rr_end;  /* index for last slice in a R-R interval */
    int slice_cnt;       /* counter */
    int slice_quant; /* number of sequences within the pass */

    /* Check for negative deadtimes and deadtimes that don't fall
       on GRAD_UPDATE_TIME boundaries */
    if ((ctlend_intern < 0) || (ctlend_last < 0) || (ctlend_fill < 0) ||
        (ctlend_unfill < 0)) 
        psdexit(EM_PSD_SUPPORT_FAILURE, 0, "","CardInit", 0);

    ctlend_intern = RUP_GRD(ctlend_intern);
    ctlend_fill = RUP_GRD(ctlend_fill);
    ctlend_unfill = RUP_GRD(ctlend_unfill);
    ctlend_last = RUP_GRD(ctlend_last);

    /* rr_end is only used in cross R-R, single phase  scans.
       Initialize rr_end as the number of slices in the first R-R - 1 */
    rr_end = opslquant/ophrep + ((opslquant%ophrep) ? 1:0) - 1;

    if (opphases > 1)
        slice_quant = opphases;
    else
	slice_quant = opslquant;

    for (slice_cnt=0; slice_cnt < slice_quant; slice_cnt++) {
        if (opphases > 1) {
	    /* Multiphase */
	    if (slice_cnt == (slice_quant - 1))
	        /* next slice will be cardiac gated */
	        ctlend_tab[slice_cnt] = ctlend_last;
            else
		/* next slice will be internally gated */
		ctlend_tab[slice_cnt] = ctlend_intern;
        } else {
	    /* Single phase, cross R-R */
	    /* Initialize as if slice is NOT the last in a R-R */
	    ctlend_tab[slice_cnt] = ctlend_intern; 
	  
	    if (slice_cnt == (opslquant - 1)) /* last slice */
	        ctlend_tab[slice_cnt] = ctlend_last;
            else if (opslquant <= ophrep) 
		/* At most 1 slice in each R-R. Each
		   slice is the first and last in an R-R */
		ctlend_tab[slice_cnt] = ctlend_fill;
            else {
		if (slice_cnt == rr_end) {
		    /* This is the last slice in an R-R */
		    rr += 1; /* up the rr counter */
		    /* Decide whether to use filled deadtime or
		       unfilled deadtime. Also recalculate rr_end,
		       the index of last slice of the next R-R interval */
		    if (rr < (opslquant%ophrep)) {
		        /* This is a filled R-R interval and the next
			   will be filled also. */
		        ctlend_tab[slice_cnt] = ctlend_fill;
			rr_end += (int)(opslquant/ophrep) + 1;
                    }
		    if (rr == (opslquant%ophrep)) {
		        /* This R-R is filled but the next is not */
		        ctlend_tab[slice_cnt] = ctlend_fill;
			rr_end += (int)(opslquant/ophrep);
                    }
		    if (rr > (opslquant%ophrep)) {
		        /* This is an unfilled R-R interval */
		        ctlend_tab[slice_cnt] = ctlend_unfill;
			rr_end += (int)(opslquant/ophrep);
                    }
                } 
            } 
        } 
    } 
    return SUCCESS;
}

/*******************************   PS   ***************************/
@inline Prescan.e PScore

/*******************************  MPS2  ***************************/
STATUS mps2( void )
{
    printdbg("Greetings from MPS2", debugstate);
    boffset(off_seqcore);
    rspent = L_MPS2;  
    rspdda = ps2_dda;

    if (cs_sat ==1)	/* Turn on Chemsat Y crusher */
        cstun=1;
    psdinit();
    strcpy(psdexitarg.text_arg, "mps2");
  
    rspent = L_MPS2;
    rspbas = 0;

    rspasl = pre_slice;
    rsprep = 30000;
    rspilv = 1;
    rspgy1 = 0;
    rspnex = 2;

    rspesl = -1;
    rspslq = slquant1;
    rspe1st = e1st;
    rspetot = etot;
    pass = pre_pass;

    if (ir_on == PSD_ON)  /* IR..MHN */
        setiamp(ia_rf0, &rf0, 0);

    rspgyc = 0;
    gyb_amp = 0;
    ygradctrl(rspgyc, gyb_amp, etl);

    scanloop();

    printdbg("Normal End of MPS2", debugstate);
    rspexit();

    return SUCCESS;
  
} /* End MPS2 */

/*******************************  APS2  **************************/
STATUS aps2( void )
{
    printdbg("Greetings from APS2", debugstate);
    boffset(off_seqcore);
  
    rspent = L_APS2;
    rspdda = ps2_dda;
    if (cs_sat ==1)	/* Turn on ChemSat Y crusher */
	cstun = 1;
    psdinit();
    strcpy(psdexitarg.text_arg, "aps2");
  
    rspent = L_APS2;                   
    rspbas = 0;

    rspasl = -1;
    rsprep = 30000;
    rspilv = 1;
    rspgy1 = 0;
    rspnex = 2;

    rspesl = -1;
    rspslq = slquant1;
    rspe1st = e1st;
    rspetot = etot;
  
    rspacqb = pre_pass;
    rspacq  = pre_pass + 1;
  
    if (ir_on == PSD_ON)
        setiamp(ia_rf0, &rf0, 0);

    rspgyc = 0;
    gyb_amp = 0;
    ygradctrl(rspgyc, gyb_amp, etl);
    scanloop();
    printdbg("Normal End of APS2", debugstate);
    rspexit();

    return SUCCESS;
  
} /* End APS2 */

/***************************  SCAN  *******************************/
STATUS scan( void )
{
    printdbg("Greetings from SCAN", debugstate);
    rspent = L_SCAN;

    rspdda = dda;

%ifdef RT

    /* BJM: only perfrom dda for actual scan with fMRI */
    if(opdda > 0) rspdda = (opdda);

%endif

    if (cs_sat == 1)	/* Turn on ChemSat Y crusher */
        cstun =1;

    psdinit();

    rspbas = rhbline;     /* used on blineacq only */

    rspasl = -1;
    rsprep = reps;
    rspgy1 = 1;
    rspnex = nex;

    rspesl = -1;
    rspslq = slquant1;
    rspilv = intleaves;
    rspgyc = 0;

    if (touch_flag)
    {
        /* Use the full number of MEG directions during MR-Touch scan */
        rsp_cmndir = touch_ndir;
    }
    else
    {
        rsp_cmndir = 1;
    }

    if (ir_on == PSD_ON)
        setiamp(ia_rf0, &rf0, 0);

    if (rawdata == PSD_ON && baseline > 0) {  /* collect reference scan for rawdata */
        ygradctrl(rspgyc, gyb_amp, etl);
        scanloop();
    }
  
    /* turn on or off phase encode blips */
    if (gyctrl == PSD_ON)
        rspgyc = 1;
    else
        rspgyc = 0;
  
    ygradctrl(rspgyc, gyb_amp, etl);

    if(rtb0_flag)
    {
        rtb0_base_cfoffset = 0.0;
        rtb0_comp_cfoffset = 0.0;
        rtb0_comp_cfoffset_TARDIS = 0;
        rtb0_rtp_1streturn = PSD_OFF;
        rtb0_cfoffset = 0.0;
        rtb0_outlier_count = 0;

        rtB0ComRspInit();

        routeDataFrameDab(&rtb0echo, ROUTE_TO_RTP, cfcoilswitchmethod);
    }

    scanloop();

    if(rtb0_flag)
    {
        RtpEnd();
    }

    rspexit();

    return SUCCESS;
}

/*************************** SCANLOOP *******************************/
STATUS scanloop( void )
{
    int pause; /* pause attribute storage loc */
    int i;

    printdbg("Greetings from scanloop", debugstate);
  
    if (cs_sat == PSD_ON) 
	cstun = 1;
  
    setiamp(ia_rf1, &rf1, 0);   /* Reset amplitudes */
    if (oppseq == PSD_SE)
	setiamp(ia_rf2, &rf2, 0);
  
    /* turning spatial & chem SAT on */ 
    SpSat_Saton(0);

    if (cs_sat > 0)  
	setiamp(ia_rfcssat, &rfcssat, 0);
  
    strcpy(psdexitarg.text_arg, "scan");
  
    if (opcgate==PSD_ON) {

#ifdef ERMES_DEBUG
	/* Don't check ecg rate in simulator mode. */
#else
	if (test_getecg == PSD_ON) {
            getecgrate(&rsp_hrate);
            if (rsp_hrate == 0)
		psdexit(EM_PSD_NO_HRATE,0,"","psd scan entry point",0);
	}
#endif
	rsp_card_intern = ctlend + scan_deadtime;
	rsp_card_last   = ctlend_last + scan_deadtime;
	rsp_card_fill   = ctlend_fill + scan_deadtime;
	rsp_card_unfill = ctlend_unfill + scan_deadtime;
	CardInit(ctlend_tab, rsp_card_intern, rsp_card_last,
                 rsp_card_fill, rsp_card_unfill);
    } else {
        setperiod(scan_deadtime, &seqcore, 0);
    }

%ifdef RT
@inline epiRTfile.e epiRT_RTvar_init

%else
       /* set trigger to aux if desired */
       if (ext_trig == PSD_ON  && rspent == L_SCAN) {
 
           settrigger((SHORT)TRIG_AUX,0);
       }
%endif

    pass_cnt = 0;  /* Reset pass counter */
    freq_ctr = 1;  /* jwg frequency counter for delays */
    
    /*jwg bb here is the top loop*/
    /*in english, this goes from 0 to pass_reps, which is equal to opfphases*/    
    for (pass_rep = 0; pass_rep < rspprp; pass_rep++) {

        if(rtd_on == PSD_ON) attenlockon(&atten);

%ifdef RT
@inline epiRTfile.e epiRT_core_RTvar_update
%endif

        for (pass = rspacqb; pass < rspacq; pass++) {

            /* fMRI - pass_index does not depend on pass_rep */
            /*        since its not a true multi-phase scan  */
            /*        but this loop is used...               */
            if(opfmri == PSD_ON) {
                pass_index = pass;
            } else {
                pass_index = pass + pass_rep*rspacq;
            }

            if (pass_index < rspacq) { /* MRIge57362 - acquire baselines on first rep of each pass */
                if (baseline > 0) {                     /* acquire the baseline */
                    if (baseline > 1)  /* play first n-1 baselines at fast rate */
                        setperiod(bl_acq_tr1, &seqblineacq, 0);
                    else
                        setperiod(bl_acq_tr2, &seqblineacq, 0);
                    blineacq();
                }
            }
        
            boffset(off_seqcore);
        
            /* MRIge53529: initialize wait time and pass packet for disdacqs, etc.*/
            setwamp(SSPDS, &pass_pulse, 0);
            setwamp(SSPD, &pass_pulse, 2);
            setwamp(SSPDS, &pass_pulse, 4);
            for (i=0; i<num_passdelay; i++) 
                setperiod(100, &ssp_pass_delay, i);
            pause = MAY_PAUSE;
            printdbg("Pre core(): Null ssp pass packet", debugstate);

            if (touch_flag)
            {
                SlideTouchTrig();  /* Set MRE motion triggers */
            }

            /*jwg bb OK THE ACTUAL SCANCORE IS WITHIN THIS WHOLE LOOP FUCK*/
	    /*As coded, will loop through all slices one frequency at a time*/
            core();                                 /* acquire the data */
	    freq_ctr++;	    
	
            /* Return to standard trigger array and core offset */
            settriggerarray((SHORT)(opslquant*opphases), rsptrigger);
	
            /* BJM: 825 -> 83 MERGE */
            /* If this isn't the last pass and we are doing relaxers  */
            if ((SatRelaxers)&&( (pass!=(rspacq-1)) && (pass_rep!=(rspprp-1)) ) )
            {
                SpSatPlayRelaxers();  /* BJM: need the next condition for concat seq MPH */
            }
            else if ((SatRelaxers) && (pass!=(rspacq-1)) && (acqmode == 1) )
            {
                SpSatPlayRelaxers();
            }
        } /* end pass loop */
    
        /* This function is for EPI calibration and is not used during normal imaging */
        epiRTD();
    
        /* This is used for fMRI and long rep EPI scans */
        /* if the bore temp is exceeded, break the looping... */
        if(BoreOverTempFlag == TRUE) {
            /*MRIhc01021 log error into GEsyslog before abort scan*/
            pgen_err_msg_struct.ab_code = 0;
            pgen_err_msg_struct.text_string[ 0 ] = '\0';
            pgen_err_msg_struct.error_or_text_flag = 1;
            strncpy( &pgen_err_msg_struct.proc_name[ 0 ], "BORETEMP\0", 8 ); 
            pgen_err_msg_struct.error_code = EM_PSD_BORETEMP_OVER;
            rsp_error_abort();

        }
    
    } /* end pass_rep loop */

    printdbg("Normal End of SCAN", debugstate);
    fprintf(stderr,"SCAN loop is complete \n");

    return SUCCESS;

} /* End SCANLOOP */

/*****************************  CORE  *************************/
STATUS core( void )
{
    int pause = MAY_PAUSE;
    int passDoneFlag = 0;
    int InterPassDoneFlag = 0;
    int i;
#ifdef PRINTRSP
    printdbg("Starting Core", debugstate);
#endif  
  
    /******* disdaq block ***********************************/

    if (touch_flag)
    {
        NullTouchAmp();  /* Null the MRE MEG initially */
    }

    if( rspdda > 0
%ifdef RT
        && (rt_counter == 0)
%endif
        )
    {
        acq_data = (int)DABOFF;
        /* mod_rba = FALSE; */

        cmdir_rep = 0;

        if(rtb0_flag)
        {
            loaddab(&(rtb0echo), 0, 0, DABSTORE, 1, DABOFF, PSD_LOAD_DAB_ALL);
        }
        dabrbaload();   

        setperiod((int)tf[0], &wgx, 0);
        setperiod((int)tf[0], &wgy, 0);
        setperiod((int)tf[0], &wgz, 0);
        setperiod((int)tf[0], &wssp, 0);
        setperiod((int)tf[0], &womega, 0);

        if (touch_flag)
        {
            /* Adjust SSP WAIT pulse to match other boards while
             * not shifting the trigger pulses */
            setperiod(pw_touch_wssp, &touch_wssp, 0);
        }

        if ( (gyctrl == PSD_ON) && (rspent != L_REF) &&
             (rspent != L_MPS2) && (rspent != L_APS2) ) {

            setiampt(gy1f[0], &gy1, 0);

            if (ygmn_type == CALC_GMN1) {
                setiampt(gymn[0], &gymn1, 0);
                setiampt(-gymn[0], &gymn2, 0);
            }

        }
	
        acq_sl = 0;
        attenlockon(&atten);
		
        for (ileave = rspdda - 1; ileave >= 0; ileave--) {

            /* The % accounts for the case when dda > intleaves */
            if (!touch_flag)
            {
                /* Don't RF chop for MRE because it interferes with the alternating +/- MEG */
                if (rf_chop == PSD_ON && rspnex <= 1
%ifdef RT
                    && intleaves > 1
%endif
                    )
                {
                    setiamp(-rfpol[ileave % intleaves], &rf1, 0);
                }
                else
                {
                    setiamp(rfpol[ileave % intleaves], &rf1, 0);
                }
            }

	    /*jwg bb it looks like the DISDAQ slice loop begins here*/
            for (slice = rspslqb; slice < rspslq; slice++) {    

                if (rspesl == -1) {    

                    if (acqmode==0) /* interleaved */
                        sliceindex = (acq_ptr[pass_index] + slice)%opslquant;

                    if (acqmode==1) /* sequential */
                        sliceindex = acq_ptr[pass_index];

                } else {

                    sliceindex = acq_ptr[pass_index] + rspesl;
                }

                /* Set rho, data acquisition flags */
                if (slice >= slc_in_acq[pass_index]) {

                    /* Dummy slice - turn off RHO board */
                    setieos((SHORT)EOS_DEAD, &rho_td0,0);

                } else {  /* live slice */

                    /* turn on RHO BOARD */
                    setieos((SHORT)EOS_PLAY, &rho_td0, 0);

                }

                /* Set cardiac delays and end times */
                if (opcgate) {
                  
                    /* Build the trigger for multi-slice, multi-phase cardiac */
                    msmpTrig();
                  
                    if ((rspent == L_SCAN)||(rspent == L_MPS2) 
                        ||(rspent == L_APS2)||(rspent == L_REF))

                        setperiod(ctlend_tab[slice],&seqcore ,0);
		  
                    /*  first slice in RR */
                    if (rsptrigger[slice] != TRIG_INTERN) {	
                        if ((rspent == L_SCAN)||(rspent == L_MPS2) ||
                            (rspent == L_APS2)||(rspent == L_REF)) {

                            /* Use cardiac trigger delay */
                            setperiod(td0, &x_td0, 0);
                            setperiod(td0, &y_td0, 0);
                            setperiod(td0, &z_td0, 0);
                            setperiod(td0, &rho_td0, 0);
                            setperiod(td0, &theta_td0, 0);
                            setperiod(td0, &omega_td0, 0);
                            setperiod(td0, &ssp_td0, 0);
                        }

                    } else {

                        /* Bypass cardiac trigger delay */
                        setperiod((int)GRAD_UPDATE_TIME, &x_td0, 0);
                        setperiod((int)GRAD_UPDATE_TIME, &y_td0, 0);
                        setperiod((int)GRAD_UPDATE_TIME, &z_td0, 0);
                        setperiod((int)GRAD_UPDATE_TIME, &rho_td0, 0);
                        setperiod((int)GRAD_UPDATE_TIME, &theta_td0, 0);
                        setperiod((int)GRAD_UPDATE_TIME, &omega_td0, 0);
                        setperiod((int)GRAD_UPDATE_TIME, &ssp_td0, 0);
                    }

                } /* if opcgate */
                else
                {
                    setperiod(scan_deadtime_correct[slice], &seqcore, 0);
                }
                    
                /* SPSP fat sat pulse */ 
                if (SpSpFatSatRsp() == FAILURE) return FAILURE;

                SpSatUpdateRsp(1, pass_index, opccsat);

                if (ssRsp() == FAILURE) return FAILURE;

                setfrequency(rf1_freq[sliceindex], &rf1, 0);

                if (oppseq == PSD_SE) {
                    setfrequency(rf2_freq[sliceindex], &rf2, 0);
                }

                sp_sat_index = sliceindex;
                startseq((short)sliceindex, (SHORT)MAY_PAUSE);

/* ++++++++++++++  in case scan starts with external trigger, set internal trigger for the rest of the scan. ++++++++++++++++ */
                if ((pass == rspacqb) && (pass_rep == 0) && (slice == rspslqb) && (ileave == rspdda - 1) && (rspdda > 0)) {
                  
%ifndef RT
                    if((ext_trig == PSD_ON) && (rspent == L_SCAN))
                                   settrigger((short)TRIG_INTERN,0);
%else
                    if((oppsd_trig == PSD_ON) && (rspent == L_SCAN)) 
                                    settrigger((short)TRIG_INTERN,0);
%endif
                }
 
   /* ++++++++++++++  in case scan starts with external trigger, set internal trigger for the rest of the scan. ++++++++++++++++ */

		
            } /* for slice= 0 */

        } /* for ileave = 0 */

    }	/* if rspdda > 0 */
  
    /******* end disdaq block ***********************************/
  
    if (rspent != L_SCAN)
        attenlockoff(&atten);
    else
        attenlockon(&atten);
  
    /* Loop through the MEG directions */
    for (cmdir_rep = 0; cmdir_rep < rsp_cmndir; cmdir_rep++)
    { 
        if (rspent != L_REF)
        {
            SetTouchAmp(cmdir_rep);
        }

        /*jwg bb this set to 1 for interleave, not relevent to us*/
        for (core_rep = 0; core_rep < rsprep; core_rep++) {
            /* baselines are done seperately in blineacq routine */

            for (ileave = rspilvb; ileave < rspilv; ileave++) {

                if (ileave>0) { 
                    if ((ep_alt > 0) && (gradpol[ileave] != gradpol[ileave-1]))
                        setreadpolarity();
                    if(se_ref==1) setreadpolarity_ref();
                }

                if ((cs_sat == PSD_ON) && (rspent == L_MPS2))
                    CsSatMod(cs_satindex);

                /* set sliding ssp/readout/phase/slice */

                setperiod((int)tf[ileave], &wgx, 0);
                setperiod((int)tf[ileave], &wgy, 0);
                setperiod((int)tf[ileave], &wgz, 0);
                setperiod((int)tf[ileave], &wssp, 0);
                setperiod((int)tf[ileave], &womega, 0);

                if (touch_flag)
                {
                    /* Adjust SSP WAIT pulse to match other boards while
                     * not shifting the trigger pulses */
                    setperiod(pw_touch_wssp - tf[ileave], &touch_wssp, 0);
                }

                /* Set blip and gy1 pulse amplitudes */
                ygradctrl(rspgyc, blippol[ileave], etl);

                if ( (gyctrl == PSD_ON) && (rspent != L_REF) &&
                     (rspent != L_MPS2) && (rspent != L_APS2) ) {

                    setiampt(gy1f[ileave], &gy1, 0);

                    if (ygmn_type == CALC_GMN1) {
                        setiampt(gymn[ileave], &gymn1, 0);
                        setiampt(-gymn[ileave], &gymn2, 0);
                    }
                }

		/*jwg bb here is where the actual excitation loop is*/
                for (excitation=1-rspdex; excitation <= rspnex; excitation++) {

                    if (rf_chop == PSD_ON && excitation % 2 == 0)
                        setiamp(-rfpol[ileave], &rf1, 0);  /* even excitation */
                    else
                        setiamp(rfpol[ileave], &rf1, 0);   /* odd excitation */

		    /*jwg bb and here is where the actual slice loop is*/
                    for (slice = rspslqb; slice < rspslq; slice++) {    

%ifdef RT
@inline epiRTfile.e RTIP_test
@inline epiRTfile.e setTTLpulse
%endif

                        if ((slice == rspasl) || (rspasl == -1))
                            acq_sl = 1;
                        else 
                            acq_sl = 0;

                        /* Determine which slice(s) to excite (find spot in 
                           rspinfo table) */
                        /* Remember slices & passes start at 0 */
                        if (rspesl == -1) {
                            if (acqmode==0) /* interleaved */
                                sliceindex = (acq_ptr[pass_index] + slice)%opslquant;

                            if (acqmode==1) /* sequential */
                                sliceindex = acq_ptr[pass_index];

                        } else {

                            sliceindex = acq_ptr[pass_index] + rspesl;

                        }

                        if ((rspent == L_MPS1) || (rspent == L_MPS2)) {

                            if ((excitation == rspnex) && (acq_sl == 1)) {
                                attenlockoff(&atten);
                            } else {
                                attenlockon(&atten);
                            }

                        }

                        /* Set cardiac delays and end times */
                        if (opcgate) {


                            /* Build the trigger for multi-slice, multi-phase cardiac */
                            msmpTrig();

                            if ((rspent == L_SCAN)||(rspent == L_MPS2) 
                                ||(rspent == L_APS2)||(rspent == L_REF))

                                setperiod(ctlend_tab[slice],&seqcore ,0);


                            /*  first slice in RR */
                            if (rsptrigger[slice] != TRIG_INTERN) {	
                                if ((rspent == L_SCAN)||(rspent == L_MPS2)||(rspent == L_APS2)||
                                    (rspent == L_REF)) {
                                    /* Use cardiac trigger delay */
                                    setperiod(td0, &x_td0, 0);
                                    setperiod(td0, &y_td0, 0);
                                    setperiod(td0, &z_td0, 0);
                                    setperiod(td0, &rho_td0, 0);
                                    setperiod(td0, &theta_td0, 0);
                                    setperiod(td0, &omega_td0, 0);
                                    setperiod(td0, &ssp_td0, 0);
                                }
                            } else {
                                /* Bypass cardiac trigger delay */
                                setperiod((int)GRAD_UPDATE_TIME, &x_td0, 0);
                                setperiod((int)GRAD_UPDATE_TIME, &y_td0, 0);
                                setperiod((int)GRAD_UPDATE_TIME, &z_td0, 0);
                                setperiod((int)GRAD_UPDATE_TIME, &rho_td0, 0);
                                setperiod((int)GRAD_UPDATE_TIME, &theta_td0, 0);
                                setperiod((int)GRAD_UPDATE_TIME, &omega_td0, 0);
                                setperiod((int)GRAD_UPDATE_TIME, &ssp_td0, 0);

                            }

                        } 
                        else
                        {
                            setperiod(scan_deadtime_correct[slice], &seqcore, 0);
                        }

                        /* Set rho, data acquisition flags */
                        if (slice >= slc_in_acq[pass_index]) {
                            /* Dummy slice */
                            acq_data = (int)DABOFF;
                            /* turn off RHO BOARD */
                            setieos((SHORT)EOS_DEAD, &rho_td0,0);

                            if (rspesl == -1)
                                sliceindex = (acq_ptr[0] + slice)%opslquant;

                        } else {  /* live slice */

                            /* turn on RHO BOARD */
                            setieos((SHORT)EOS_PLAY, &rho_td0, 0);

                            if ((acq_sl == PSD_ON)&&(excitation > 0))
                                acq_data = (int)DABON;
                            else
                                acq_data = (int)DABOFF;
                        }

                        /* SPSP fat sat pulse */
                        if (SpSpFatSatRsp() == FAILURE) return FAILURE;

                        /* update Sat Move CATSAT Pulse */
                        SpSatUpdateRsp(1, pass_index, opccsat);

@inline Inversion.e InversionRSPcore

                        /* Set the rf pulse transmit frequencies */
                        if (ssRsp() == FAILURE) return FAILURE;

                        if(rspent == L_SCAN && rtb0_flag && rtb0_comp_flag)
                        {
                            setfrequency(rf1_freq[sliceindex]+rtb0_comp_cfoffset_TARDIS, &rf1, 0);
                            if (oppseq == PSD_SE)
                            {
                                setfrequency(rf2_freq[sliceindex]+rtb0_comp_cfoffset_TARDIS, &rf2, 0);
                            }
                        }
                        else
                        {   
			    /*jwg bb this is where we will change the tx frq for spsp excitation*/
			    /*is it pretty? Nope. But it works. */
			    if (num_freqs == 1)
			    {
			    	met_freq = df1 / TARDIS_FREQ_RES;
			    }
			    else if (num_freqs == 2)
			    {
				    if((freq_ctr % num_freqs) == 1) /*df1*/
				    {
				    	met_freq = df1 / TARDIS_FREQ_RES;
				    } 
				    else /*df2*/
				    { 
				    	met_freq = df2 / TARDIS_FREQ_RES;			    
				    }
		 	    }
			    else if (num_freqs == 3)			    
			    {
			    	if((freq_ctr % num_freqs) == 1) /*df1*/
			    	{
			    		met_freq = df1 / TARDIS_FREQ_RES;
			    	} 
			    	else if((freq_ctr % num_freqs) == 2) /*df2*/
			    	{ 
			    		met_freq = df2 / TARDIS_FREQ_RES;			    
			    	}	 
			    	else /*df3*/
			    	{ 
			    		met_freq = df3 / TARDIS_FREQ_RES;			    
			    	}
			    }			    
			    else if (num_freqs == 4)			    
			    {
			    	if((freq_ctr % num_freqs) == 1) /*df1*/
			    	{
			    		met_freq = df1 / TARDIS_FREQ_RES;
			    	} 
			    	else if((freq_ctr % num_freqs) == 2) /*df2*/
			    	{ 
			    		met_freq = df2 / TARDIS_FREQ_RES;			    
			    	}	 
			    	else if((freq_ctr % num_freqs) == 3) /*df3*/
			    	{ 
			    		met_freq = df3 / TARDIS_FREQ_RES;			    
			    	}	 				
			    	else /*df4*/
			    	{ 
			    		met_freq = df4 / TARDIS_FREQ_RES;			    
			    	}
			    }			    
			    else if (num_freqs == 5)			    
			    {
			    	if((freq_ctr % num_freqs) == 1) /*df1*/
			    	{
			    		met_freq = df1 / TARDIS_FREQ_RES;
			    	} 
			    	else if((freq_ctr % num_freqs) == 2) /*df2*/
			    	{ 
			    		met_freq = df2 / TARDIS_FREQ_RES;			    
			    	}	 
			    	else if((freq_ctr % num_freqs) == 3) /*df3*/
			    	{ 
			    		met_freq = df3 / TARDIS_FREQ_RES;			    
			    	}	 				
			    	else if((freq_ctr % num_freqs) == 4) /*df4*/
			    	{ 
			    		met_freq = df4 / TARDIS_FREQ_RES;			    
			    	}	 						
			    	else /*df5*/
			    	{ 
			    		met_freq = df5 / TARDIS_FREQ_RES;			    
			    	}
			    }			    
			    
			   /* fprintf(stderr,"RF Tx freq is %f \n",(rf1_freq[sliceindex] + met_freq)); */
			   /*jwg bb testing passband shifting for true null design*/
			   /*we shouldn't have to make any changes for rcv...*/
			   if (sw != 0  && (rspent == L_SCAN))
			   {
				   if(met_freq < (sw/2) )
				   {
                	           	setfrequency((rf1_freq[sliceindex] + met_freq), &rf1, 0);
				   } else {
			   		setfrequency((rf1_freq[sliceindex] - (sw - met_freq)), &rf1, 0);
				   }
			   } else {
                           	setfrequency((rf1_freq[sliceindex] + met_freq), &rf1, 0);
				fprintf(stderr,"RF Tx freq is %f \n",(rf1_freq[sliceindex] + met_freq));
			   }
			    
			    /*jwg bb update flip angle depending on RF table, but only for actual scan entry point*/
			    if((vfa_flag != 0) && (rspent == L_SCAN))
			    {
			    	/*freq_ctr starts at 1, so account for this!*/
				vfa_flip_angle = vfa_flips[(freq_ctr-1)];
				vfa_flip_ia =  (int)(vfa_flip_angle / 90 * ia_rf1); /*Not always 32767 with long, low power SPSP*/
				fprintf(stderr,"VFA flip is %f, ia is %f\n",vfa_flip_angle, vfa_flip_ia);
			    	setiamp(vfa_flip_ia, &rf1, 0);
			    }
			    
                            if (oppseq == PSD_SE)
                            {
                                setfrequency(rf2_freq[sliceindex], &rf2, 0);
                            }
                        }

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
                                      &sspdelay, 0);

                            setperiod(RUP_RF((int)((float)gldelaycval[sliceindex] +
                                                   pw_omegadelay + deltaomega)), &omegadelay, 0);

                            setperiod((int)((float)(pw_sspshift - gldelaycval[sliceindex])),
                                      &sspshift, 0);
                        }

                        if(rtb0_flag)
                        {
                            if(rspent == L_SCAN && rtb0_comp_flag)
                            {
                                setfreqphase((int)sl_rcvcf+rtb0_comp_cfoffset_TARDIS, 0, rtb0echoxtr);
                            }
                            if(rspent == L_SCAN && (rtb0_midsliceindex == sliceindex || rtb0_midsliceindex < 0) )
                            {
                                /* need to turn DAB off but RBA on for routing the frame to RTP */
                                loaddab(&(rtb0echo), 0, 0, DABSTORE, 1, DABOFF, PSD_LOAD_DAB_ACQON);
                                loaddab(&(rtb0echo), 0, 0, DABSTORE, 1, DABON, PSD_LOAD_DAB_ACQON_RBA);
                            }
                            else
                            {
                                loaddab(&(rtb0echo), 0, 0, DABSTORE, 1, DABOFF, PSD_LOAD_DAB_ALL);
                            }
                        }

                        /* mod_rba = FALSE; */
			
			/*fprintf(stderr,"temporal phase is %d\n",pass_rep);
			fprintf(stderr,"slice index is %d\n",sliceindex);
			fprintf(stderr,"freq ctr is %d\n",freq_ctr);			*/
                        dabrbaload();

                        /* Play out pass delay and send proper pass packet within seqcore.  We do
                           this to avoid having to play out a seperate pass sequence as is usually
                           done */

                        if ( (BoreOverTempFlag == PSD_ON) || ( (pass == (rspacq - 1)) && 
                                                               (pass_rep == (rspprp - 1) ) &&
                                                               (cmdir_rep == rsp_cmndir-1) &&
                                                               (slice == rspslq-1) && 
                                                               (excitation == rspnex) &&
                                                               (ileave == rspilv-1) &&
                                                               (core_rep == rsprep-1) ) )
                        { 
                            /* Set DAB pass packet to end of scan */
                            setwamp(SSPDS + DABDC, &pass_pulse, 0);
                            setwamp(SSPD + DABPASS + DABSCAN, &pass_pulse, 2);
                            setwamp(SSPDS + DABDC, &pass_pulse, 4);
                            /*MRIhc08588 at end of scan, no need to send the
                             * delay pass to pass_delay*/
                            for (i=0; i<num_passdelay; i++) {
                                setperiod(100, &ssp_pass_delay, i);
                            }
                            pause = MAY_PAUSE;
                            printdbg("End of Scan and Pass", debugstate);

                            passDoneFlag = 1;
                            InterPassDoneFlag = 0;

                        }
                        else if ( (cmdir_rep == rsp_cmndir-1) && 
                                  (slice == rspslq-1) &&
                                  (excitation == rspnex) &&
                                  (ileave == rspilv-1) &&
                                  (core_rep == rsprep-1) )
                        {
                            /* Set DAB pass packet to end of pass */
                            setwamp(SSPDS + DABDC, &pass_pulse, 0);
                            setwamp(SSPD + DABPASS, &pass_pulse, 2);
                            setwamp(SSPDS + DABDC, &pass_pulse, 4);
			    
			    /*jwg this is where the opsldelay for delay between temporal phases is used!*/
			    /*will use freq_ctr to tell when to pause things*/
                            for (i=0; i<num_passdelay; i++) { 
			        /*jwg this changed from just rspent to all this crap*/
                                if (rspent == L_REF &&
                                     !((mph_flag == PSD_ON) && (touch_flag == PSD_OFF) && (avminsldelay > 0))) 
				{
                                    setperiod(100, &ssp_pass_delay, i);
                                } else {
				    /*jwg bb only want the delay on the LAST slice of this frequency!!!*/
				    if( (freq_ctr % num_freqs) == 0)
				    {
                                       setperiod(100, &ssp_pass_delay, i);
				       setperiod(pass_delay, &jwg_delay, 0);				       
				       fprintf(stderr,"delaying now!\n");
				    } else {
                                       setperiod(100, &ssp_pass_delay, i);
				       setperiod(1, &jwg_delay, 0);
				      /* fprintf(stderr,"going through frequencies, no delay!\n");*/
				    }
                                }
                            }
			    

                            if (touch_flag)
                            {
                                /* Adjust how pausing is done for MRE */
                                pass_cnt++;

                                if( (opslicecnt != 0) && ( (pass_cnt % opslicecnt) == 0 ) )
                                {
                                    pause = MUST_PAUSE;
                                }
                                else
                                {
                                    pause = AUTO_PAUSE;
                                }
                            }
                            else
                            {
                                pause = AUTO_PAUSE;
                            }

                            printdbg("End of Pass", debugstate);

                            passDoneFlag = 1;
                            if (PSD_OFF == touch_flag){
                                InterPassDoneFlag = 1;
                            }
                        } else {
                            /* send null pass packet and use the minimum delay for pass_delay */
                            setwamp(SSPDS, &pass_pulse, 0);
                            setwamp(SSPD, &pass_pulse, 2);
                            setwamp(SSPDS, &pass_pulse, 4);
                            for (i=0; i<num_passdelay; i++) 
                                setperiod(100, &ssp_pass_delay, i);
                            pause = MAY_PAUSE;
                            printdbg("Null ssp pass packet", debugstate);
                            passDoneFlag = 0;
                            InterPassDoneFlag = 0;
			    /*jwg bb add this so that the interframe delay isn't present for all slices*/
     			    setperiod(1, &jwg_delay, 0);			    
                        }

                        printdbg("S", debugstate);
                        sp_sat_index = sliceindex;

%ifdef RT
@inline epiRTfile.e RT_startclock
%endif

                        startseq((short)sliceindex, (SHORT)pause);

%ifdef RT
@inline epiRTfile.e RT_readclock
%endif

#ifdef PSD_HW       /* Auto Voice  04/19/2005 YI */
                        if (mph_flag && InterPassDoneFlag) { 
                            broadcast_autovoice_timing((int)(act_tr/slquant1)/1ms, pass_delay*num_passdelay/1ms, TRUE, TRUE);
                        }
#endif		  

                        syncoff(&seqcore); 

                        /* ++++++++++++++++  In case scan starts with external trigger, set internal trigger for the rest of the scan. ++++++++++++++++ */
%ifndef RT
                        if ((pass == rspacqb) && (pass_rep == 0) && (slice == rspslqb) &&
                            (excitation == 1 - rspdex) && (ileave == rspilvb) && (core_rep == 0)) {

                            if((ext_trig == PSD_ON) && (rspent == L_SCAN))
                                settrigger((short)TRIG_INTERN,0);
                        }
%endif
                        /* ++++++++++++++++  In case scan starts with external trigger, set internal trigger for the rest of the scan. ++++++++++++++++ */


%ifdef RT
                        if(passDoneFlag > 0) {
@inline epiRTfile.e RT_save
                        }
%endif
                    }  /* slice */

                    if(rtb0_flag && rspent == L_SCAN)
                    {
                        if(rtb0_comp_flag)
                        {
                            if(excitation == rspnex && ileave == rspilv-1)
                            {
                                if ( 1 == getRTB0Feedback(&rtb0_processed_index, &rtb0_cfoffset) )
                                { 
                                    if (rtb0DebugFlag == PSD_ON)
                                    {
                                        printf("Processed Index = %d\t CF offset = %f\n", rtb0_processed_index,rtb0_cfoffset);
                                    }
                                    if(rtb0_rtp_1streturn == PSD_OFF)
                                    {
                                        /* set base CF offset for the first return from RTP */
                                        rtb0_base_cfoffset = rtb0_cfoffset;
                                        rtb0_comp_cfoffset = 0.0;
                                        rtb0_outlier_count = 0;
                                        rtb0_rtp_1streturn = PSD_ON;
                                    }
                                    else 
                                    {
                                        float rtb0_temp;
                                        /* If CF change is bigger than rtb0_outlier_threshold  and lasts shorter than   */
                                        /* rtb0_outlier_duration, it is a outlier and will be ignored for compensation. */

                                        rtb0_temp = rtb0_cfoffset-rtb0_base_cfoffset;
                                        if(fabs(rtb0_temp) > rtb0_outlier_threshold)
                                        {
                                            rtb0_outlier_count++;
                                            if(rtb0_outlier_count > rtb0_outlier_nTRs)
                                            {
                                                rtb0_outlier_count = 0;
                                                rtb0_comp_cfoffset += rtb0_temp;
                                            }
                                        }
                                        else
                                        {
                                            rtb0_outlier_count = 0;
                                            rtb0_comp_cfoffset += rtb0_temp;
                                        }
                                    }
                                    rtb0_comp_cfoffset_TARDIS = (int)(rtb0_comp_cfoffset/TARDIS_FREQ_RES);
                                    if(rtb0DebugFlag == PSD_ON) 
                                    {
                                        printf("CF compensation = %.2f\n", rtb0_comp_cfoffset);
                                    }
                                }
                            }
                        }
                    }

                    if (rspchp == CHOP_NONE) 
                        SpSatChop();

                } /* excitation */

            } /* ileave */

        } /* core_rep */	
    } /* cmdir_rep */

    fflush(stdout);

    return SUCCESS;
  

} /* End Core */

/***************************** blineacq  *************************/
STATUS blineacq( void )
{
    int bcnt;
    int nslice;
    int rcnt;
    int rcnt_end;
    int slindex;
    int bl_slice_end;

    /* For ref entry point, play baselines for all slices */
    if (rspent == L_REF) {

        bl_slice_end = rspslq;

    } else {

        /* Otherwise, play baselines for first slice only */
        bl_slice_end = rspslqb + 1;
    }

    /* BJM: MRIge51381 - fix for redundant baseline with seq. scans */
    if(rspent == L_SCAN && acqmode == 1) {
        rcnt_end = 1;
    } else {
        rcnt_end = rsprep;
    }

    /* Offset to baseline sequence in memory */
    boffset(off_seqblineacq);

    /* Set filter slot for XTR packet for baseline */  
    setrfltrs((int)scanslot, &blineacq1);

    settriggerarray((SHORT)1, rsptrigger_temp);

    if (baseline > 0 && rawdata == PSD_ON) {    /* collect single frame */

        sp_sat_index = 0;
        startseq((short)0, (SHORT)MAY_PAUSE);

    } else {

        dabop = 0; /* Store data */

        for (bcnt = rspbasb;bcnt <= rspbas; bcnt++) {
            for (rcnt = 0;rcnt < rcnt_end; rcnt++) {
                for (nslice = rspslqb;nslice < bl_slice_end; nslice++) {

                    /* play last baseline at longer TR */
                    if ( (rspbas > 1) && (bcnt == rspbas) && 
                         (nslice == bl_slice_end - 1) && (rcnt == rsprep - 1)  )

                        setperiod(bl_acq_tr2, &seqblineacq, 0);

                    if (nslice < slc_in_acq[pass_index]) {
                        slindex = nslice + rcnt*rspslq;

                        loadhsdab(&hyperdabbl,		/* load hyperdab */
                                  (LONG)slindex,
                                  (LONG)0,
                                  (LONG)dabop,
                                  (LONG)0,
                                  (LONG)1,
                                  (LONG)1,
                                  (LONG)1,
                                  (LONG)1,
                                  (TYPDAB_PACKETS)DABON,
                                  (LONG)hsdabmask);

                        sp_sat_index = 0;
                        startseq((short)0, (SHORT)MAY_PAUSE);

   /* +++++++  In case scan starts with external trigger, set internal trigger for baseline and the rest of the scan. ++++++++++++++++ */
%ifndef RT
                   if ((pass == rspacqb) && (pass_rep == 0) && (nslice == rspslqb) && (rcnt == 0) && (bcnt == rspbasb)) {
                  
                       if((ext_trig == PSD_ON) && (rspent == L_SCAN))
                                   settrigger((short)TRIG_INTERN,0);
                   }
%endif
   /* +++++++  In case scan starts with external trigger, set internal trigger for baseline and the rest of the scan. ++++++++++++++++ */
 

                    }		  
		
                } /* for (nslice = rspslqb;nslice <= rspslq; nslice++) */
            } /* reps loop */
            dabop = 1;       /* add baseviews */
        } /* for (bcnt = 1;bcnt <= rspbas; bcnt++)  */
    } /* if (baseline > 0 && rawdata == PSD_ON) */
  
    /* Return to standard trigger array and core offset */
    settriggerarray((SHORT)(opslquant*opphases), rsptrigger);

    return SUCCESS;
  
} /* end blineacq */


/***************************** dabrbaload *************************/
STATUS dabrbaload(void)
{
    TYPDAB_PACKETS dabacqctrl;
    int echo;  /* loop counter */
    int ii; /*jwg bb phase mod counter, need this to debug shift in PE direction*/
    int freq_ctrl = 0;
    int phase_ctrl = 0;

    dabacqctrl = (TYPDAB_PACKETS)acq_data;
    loadhsdab(&hyperdab,		/* load hyperdab */
              (LONG)slicerep,
              (LONG)cmdir_rep,  /* Changed from 0 to account for MEG directions */
              (LONG)dabop,
              (LONG)view1st[ileave],
              (LONG)viewskip[ileave],
              (LONG)tot_etl,
              (LONG)1,
              (LONG)1,
              dabacqctrl,
              (LONG)hsdabmask);

    ii = 0; /*jwg bb*/
    /*jwg bb need phase increment to fix unaccounted phase in PE direction*/
    phase_incr = (eesp * met_freq * TARDIS_FREQ_RES * 2 * 3.1415 / 1000);    

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
            if(rspent == L_SCAN && rtb0_flag && rtb0_comp_flag)
                freq_ctrl = sl_rcvcf + rtb0_comp_cfoffset_TARDIS;
            else 
            
	    /*jwg bb account for metabolite frequency shifting*/	
            freq_ctrl = sl_rcvcf + met_freq;
            phase_ctrl = recv_phase[sliceindex][ileave][echo];
          
            /* load demod. frequnecy in packet xtr packet */
	    /*jwg bb put linear phase ramp to try and fix PE shift*/
            setfreqphase((long)freq_ctrl,
                         (long)(phase_ctrl + phase_mod*phase_incr*ii),
                         echotrainxtr[echo]);

            /* frequency offset */ 
	    /*jwg bb this is just for off isocenter, no need to change for each metabolite!*/
            tempamp=(short)((recv_freq[sliceindex][ileave][echo]-sl_rcvcf)/omega_scale);
        
            if(vrgfsamp){

                /* Attack Ramp Offset */
                *(echotrainrampamp1[echo]) = tempamp;
                setamprsp((short)rs_omega_attack.wavegen_type,
                          tempamp,
                          (short)TYPINSTRMEM,
                          (int)echotrainramp1[echo]);
              
                /* Freq Offset on Flattop */
                *(echotrainrampamp[echo]) = tempamp;
                setamprsp((short)omega_flat.wavegen_type,
                          tempamp,
                          (short)TYPINSTRMEM,
                          (int)echotrainramp[echo]);

                /* Decay Ramp Offset */
                *(echotrainrampamp2[echo]) = tempamp;
                setamprsp((short)rs_omega_decay.wavegen_type,
                          tempamp,
                          (short)TYPINSTRMEM,
                          (int)echotrainramp2[echo]);          

            } else {
                            
               
                /* Freq Offset on Flattop */
                *(echotrainrampamp[echo]) = tempamp;
                setamprsp((short)omega_flat.wavegen_type,
                          tempamp,
                          (short)TYPINSTRMEM,
                          (int)echotrainramp[echo]);

            }
	    
	/*jwg bb increment counter*/
	ii = ii + 1;        

        } /* end acq_data condition */
      
        /* determine which echos will be collected */
        if ((echo >= rspe1st) && (echo < rspe1st + rspetot))
            dabacqctrl = (TYPDAB_PACKETS)acq_data;
        else
            dabacqctrl = DABOFF;
      
        /* set RBA bit for echos to acquire */
        acqctrl(dabacqctrl, fast_rec, echotrainrba[echo]);
      
    } /* end echo loop for setting up xtr & rba packets */  
  
    return SUCCESS;

} /* End dabrbaload */


/***************************** msmpTrig *************************/
/* Build the trigger for multi-slice, multi-phase cardiac */
STATUS msmpTrig(void )
{
    if ((opcgate == PSD_ON) && (opphases > 1) &&
        ((rspent == L_MPS2)||(rspent == L_APS2)||
         (rspent == L_SCAN)||(rspent == L_REF))) 
    {
        if (slice == 0) {
            switch(rspent) {
            case L_MPS2:
                settrigger((short)trig_mps2, (short)sliceindex);
                break;
            case L_APS2:
                settrigger((short)trig_aps2, (short)sliceindex);
                break;
            case L_SCAN:
            case L_REF:
                settrigger((short)trig_scan, (short)sliceindex);
                break;
            default:
                break;
            }
        }
        else
            settrigger((short)TRIG_INTERN, (short)sliceindex);
    }
    return SUCCESS;
}

/***************************** ygradctrl  *************************/
STATUS ygradctrl( INT blipsw,
                  INT blipwamp,
                  INT numblips )
{
    int bcnt;
    int dephaser_amp;
    int gmn_amp;
    int parity;
    int deltaAmp = 0;

    parity = gradpol[ileave];
    deltaAmp = blipwamp*percentBlipMod;  

    if (blipsw == 0) {
        dephaser_amp = 0;
        gmn_amp = 0;
        for (bcnt=0;bcnt<numblips-1;bcnt++) {
            if(bcnt%2 == 0) {
                setiampt((short)(-deltaAmp/2.0), &gyb, bcnt);
            } else {
                setiampt((short)(deltaAmp/2.0), &gyb, bcnt);
            }
        }

    } else {
        gmn_amp = ia_gymn2;
        if (pepolar == PSD_OFF) {
            dephaser_amp = -gy1f[0];
            for (bcnt=0;bcnt<numblips-1;bcnt++) {
                if (oblcorr_perslice == 1) {
		
		if(opuser26 ==0)
		{
                    if(bcnt%2 == 0)
                        setiampt((short)(-blipwamp - (deltaAmp/2.0) + parity*rspia_gyboc[slice]), &gyb, bcnt);
                    else
                        setiampt((short)(-blipwamp + (deltaAmp/2.0) + parity*rspia_gyboc[slice]), &gyb, bcnt);
		} else {
			/*setiampt((short)(-blipwamp - (deltaAmp/2.0*(int)opuser26) + parity*rspia_gyboc[slice]), &gyb, bcnt);*/
			setiampt((short)(-blipwamp * (int)sake_blips[bcnt] + parity*rspia_gyboc[slice]), &gyb, bcnt);			
		}
			
                }
                else {
                    setiampt((short)(-blipwamp + parity*rspia_gyboc[slice]), &gyb, bcnt);
                }
                parity *= -1;
            }

        } else {
            dephaser_amp = gy1f[0];
            for (bcnt=0;bcnt<numblips-1;bcnt++) {
                if (oblcorr_perslice == 1) {
                    if(bcnt%2 == 0) 
                        setiampt((short)(blipwamp + (deltaAmp/2.0) + parity*rspia_gyboc[slice]), &gyb, bcnt);
                    else
                        setiampt((short)(blipwamp - (deltaAmp/2.0) + parity*rspia_gyboc[slice]), &gyb, bcnt);
                    
                }
                else {
                    setiampt((short)(blipwamp + parity*rspia_gyboc[slice]), &gyb, bcnt);
                }
                parity *= -1;
            }
	}
    }	 

    setiampt((short)dephaser_amp, &gy1, 0);
    if (ygmn_type == CALC_GMN1) {
	setiampt((short)-gmn_amp, &gymn1, 0);
	setiampt((short)gmn_amp, &gymn2, 0);
    }


    return SUCCESS;

} /* End ygradctrl */

@inline SpSat.e SpSatChop
@inline ChemSat.e CsSatMod
@inline ChemSat.e SpSpFatSatRsp
@inline SpSat.e SpSatInitRsp 
@inline SpSat.e SpSatUpdateRsp
@inline SpSat.e SpSatON
@inline ss.e ssRsp
@inline refScan.e refScanRsp

/* Add more MRE RSP info */
@inline touch.e TouchRsp
@inline touch.e TouchPgInit
@inline BroadBand.e BBRspFuncs

void dummylinks( void )
{
    epic_loadcvs("thefile");            /* for downloading CVs */
}

