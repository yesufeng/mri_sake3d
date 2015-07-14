/*
 *  GE Medical Systems
 *  Copyright (C) 1997 The General Electric Company
 *  
 *  fse.h
 *  
 *  This file contains the prototypes declarations for all functions in epi.e
 *  
 *  Language : ANSI C
 *  Author   : Vinod Baskaran
 *  Date     : 12/11/97
 */
/* do not edit anything above this line */

/*
   Version    Author     Date       Comment
----------------------------------------------------------------------
     1.0       VB      1-May-98     Initial version.

     1.1       GFN    02-Apr-1999   Removed all prototypes already provided
                                    by psd_proto.h.
 */

#ifndef epi_h
#define epi_h

void dummylinks( void );

/*
 * @host section
 */

STATUS cveval1(void);

STATUS  getminesp( FILTER_INFO epi_filt,
               INT xtr_pkt_off,
               INT ileaves,
               INT hrd_per,
               INT vrgf_on,
               INT *minesp );

STATUS myscan(void);

STATUS avmintecalc(void);

INT avmintecalc_ref(void);

STATUS get_hrdwr_per(void);

STATUS setburstmode(void);

STATUS setb0rotmats(void);

STATUS nexcalc(void);

STATUS predownload1(void);

/*
 * @pg section
 */
void dummyssi(void);

STATUS setupphases(int *phase,int *freq,int slice,float rel_phase,int time_delay);

void ssisat(void);
 
/*
 * @rsp section
 */
STATUS core(void);

STATUS psdinit(void);

STATUS CardInit( int ctlend_tab[], int ctlend_intern,int ctlend_last, 
                 int ctlend_fill,int ctlend_unfill );

STATUS ref(void);

STATUS fstune(void);

STATUS rtd(void);

STATUS blineacq(void);

STATUS dabrbaload(void);

STATUS diffstep(void);

STATUS ddpgatetrig(void);

STATUS msmpTrig(void);

STATUS phaseReset(WF_PULSE_ADDR pulse, int control);

STATUS pgatetrig(void);

STATUS pgatedelay(void);

STATUS setreadpolarity(void);

STATUS ygradctrl(int blipsw,int blipwamp,int numblips);

STATUS getfiltdelay(float *delay_val,int fastrec,int vrgfflag);

#endif /* epi_h */

