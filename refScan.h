/* This file simply contains the new macro definition EP_TRAIN_NAME */
/* which is used to set up the spin-echo reference scan code */
@pulsedef

/* MRIge89403: Added et_iref_etl for internal ref scan */ 
EP_TRAIN_NAME( ext_name, et_pos:0, et_vps:1, et_offset:0, et_vtot,
               et_recvr_type:0, et_filt_slot:4, et_dab_type:0,
               et_dacqdelay:0, et_samp_period:1, et_dab_off:0,
               et_xtr_off:0, et_iref_etl:0, et_loggrd) {
 
/* EP_TRAIN_NAME - DOES THE SAME THING as EP_TRAIN except allows you to name
   the pulses by passing in ext_name as the first argument:

   EP_TRAIN:  generates a blipped echo planar sequence with
   optional readout crushers.  Readout is generated on logical XGRAD,
   blips on logical YGRAD.  Data acquisition is generated for standard
   or fast receivers, with control of DAB packet type.

   This macro can be called recursively.  Memory allocation is done once
   on the first interation of the macro (i.e. when et_offset is set to zero).
   The allocation is based on the value of et_vtot; the user is responsibile
   for setting this equal to the views-per-shot (et_vps) times the total
   number of iterations.  An offset argument is provided to allow explicit
   labeling of each Exciter/Receiver(/DAB) packet.

   Argument definitions:                           
   et_pos         -  absolute time position of first non-zero pulsewidth on X
   et_vps         -  views per shot (number of echoes macro generates)
   et_offset      -  numeric offset for view labeling, typically n*et_vps,
                     where n is the current iteration
   et_vtot        -  Total number of frames (for memory allocation).
                     Include number of views for all iterations
   et_recvr_type  -  0: standard receiver, 1: research fast receiver
   et_filt_slot   -  optional filter slot (0-7)
   et_dab_type    -  0: don't create a dab packet
                     1: create a standard dab (1ms prior to RBA),
   et_dacqdelay   -  delay of data acquisition relative to begin of gxw pulse
                     (after gxwl if non-zero) in usec
   et_samp_period -  sample period for fast receiver in usec
   et_dab_off     -  0: default position (1ms prior to RBA),
                     x: time position offset of xtr packet relative to RBA
   et_xtr_off     -  0: default position (100us prior to RBA),
                     x: time position offset of dab packet relative to RBA
   et_loggrd      -  logical gradient structure name
 
   Pulse attribute CVs are declared (see CV section below).

   The following pulse widths can be set to zero if desired:
   pw_gxcla, pw_gxcl, pwgxcld, pwgxwl, pwgxwr, pw_gxgap, pw_gxcra,
   pw_gxcr, pw_gxcrd.
 
   Combined Exciter/Receiver(/DAB) packets are labeled as echoxxxx (where
   xxxx ranges from 0000 to 9999).  This is useful for programming exciter
   phase and frequency on a per-view basis.
 
*/
 
cv:{
  float $[ext_name]a_gxcl;
  float $[ext_name]a_gxw;
  float $[ext_name]a_gxcr;
  float $[ext_name]a_gyb;
  int   $[ext_name]ia_gxcl;
  int   $[ext_name]ia_gxw;
  int   $[ext_name]ia_gxcr;
  int   $[ext_name]ia_gyb;
  int   $[ext_name]pw_gxcla;
  int   $[ext_name]pw_gxcl;
  int   $[ext_name]pw_gxcld;
  int   $[ext_name]pw_gxwl;
  int   $[ext_name]pw_gxw;
  int   $[ext_name]pw_gxwr;
  int   $[ext_name]pw_gxwad;
  int   $[ext_name]pw_gxgap;
  int   $[ext_name]pw_gxcra;
  int   $[ext_name]pw_gxcr;
  int   $[ext_name]pw_gxcrd;
  int   $[ext_name]pw_gyba;
  int   $[ext_name]pw_gyb;
  int   $[ext_name]pw_gybd;
}

var:{
  WF_PULSE $[ext_name]gxcla = INITPULSE;
  WF_PULSE $[ext_name]gxcl = INITPULSE;
  WF_PULSE $[ext_name]gxcld = INITPULSE;
 
  WF_PULSE $[ext_name]gxwa = INITPULSE;
  WF_PULSE $[ext_name]gxw = INITPULSE;
  WF_PULSE $[ext_name]gxwd = INITPULSE;
  WF_PULSE $[ext_name]gxwde = INITPULSE;
  WF_PULSE $[ext_name]gxcra = INITPULSE;
  WF_PULSE $[ext_name]gxcr = INITPULSE;
  WF_PULSE $[ext_name]gxcrd = INITPULSE;
 
  WF_PULSE $[ext_name]gxgap = INITPULSE;
 
  WF_PULSE $[ext_name]gyb = INITPULSE;
  WF_PULSE $[ext_name]gyba = INITPULSE;
  WF_PULSE $[ext_name]gybd = INITPULSE;
   
  WF_PULSE *$[ext_name]echotrain;
}
 
insert: cvinit => {
}
 
insert: predownload => {
  $[ext_name]ia_gxcl = $[ext_name]a_gxcl * max_pg_wamp / $[et_loggrd].tx;
  $[ext_name]ia_gxw = $[ext_name]a_gxw * max_pg_wamp / $[et_loggrd].tx;
  $[ext_name]ia_gxcr = $[ext_name]a_gxcr * max_pg_wamp / $[et_loggrd].tx;
  $[ext_name]ia_gyb = $[ext_name]a_gyb * max_pg_iamp / $[et_loggrd].ty;
}
 
subst:{
    {
        int psd_gxwcnt;
        int psd_pulsepos;
        int psd_eparity;
        long psd_epxtroff;
        long psd_epdaboff;
        float psd_etbetax;
        float psd_etbetay;
        char psd_epstring[EPSTRING_LENGTH];

        psd_pulsepos = RUP_GRD($[et_pos]);           
 
        if ( $[et_offset] == 0 ) {
            $[ext_name]echotrain = (WF_PULSE *)AllocNode(($[et_vtot] + 3) * sizeof(WF_PULSE));
        }
 
        pulsename(&$[ext_name]gxcla, "$[ext_name]gxcla");
        pulsename(&$[ext_name]gxcl, "$[ext_name]gxcl");
        pulsename(&$[ext_name]gxcld, "$[ext_name]gxcld");
 
        pulsename(&$[ext_name]gxwa, "$[ext_name]gxwa");
        pulsename(&$[ext_name]gxw, "$[ext_name]gxw");
        pulsename(&$[ext_name]gxwd, "$[ext_name]gxwd");
        pulsename(&$[ext_name]gxwde, "$[ext_name]gxwde");
 
        pulsename(&$[ext_name]gxgap, "$[ext_name]gxgap");
 
        pulsename(&$[ext_name]gyba, "$[ext_name]gyba");
        pulsename(&$[ext_name]gyb, "$[ext_name]gyb");
        pulsename(&$[ext_name]gybd, "$[ext_name]gybd");
 
        pulsename(&$[ext_name]gxcra, "$[ext_name]gxcra");
        pulsename(&$[ext_name]gxcr, "$[ext_name]gxcr");
        pulsename(&$[ext_name]gxcrd, "$[ext_name]gxcrd");
 
        getbeta(&psd_etbetax, XGRAD, &$[et_loggrd]);
        getbeta(&psd_etbetay, YGRAD, &$[et_loggrd]);
 
        if (pw_gxcla >= GRAD_UPDATE_TIME) {
            createramp(&$[ext_name]gxcla, XGRAD, pw_gxcla, (short)0,
                       (short)ia_gxcl, (short)(maxGradRes*(pw_gxcla/
                       GRAD_UPDATE_TIME)), psd_etbetax);
            createinstr(&$[ext_name]gxcla, (long)psd_pulsepos,
                        pw_gxcla, max_pg_iamp);
            psd_pulsepos += pw_gxcla;
        }
    
        if (pw_gxcl >= GRAD_UPDATE_TIME) {
            createconst(&$[ext_name]gxcl, XGRAD, pw_gxcl, max_pg_wamp);
            createinstr(&$[ext_name]gxcl, (long)psd_pulsepos, pw_gxcl, ia_gxcl);
            psd_pulsepos += pw_gxcl;
        }
    
        if (pw_gxcld >= GRAD_UPDATE_TIME) {
            createramp(&$[ext_name]gxcld, XGRAD, pw_gxcld, (short)ia_gxcl,
                       (short)ia_gxw, (short)(maxGradRes*(pw_gxcld/
                       GRAD_UPDATE_TIME)), psd_etbetax);
            createinstr(&$[ext_name]gxcld, (long)psd_pulsepos,
                        pw_gxcld, max_pg_iamp);
            psd_pulsepos += pw_gxcld;
        }
    
        createconst(&$[ext_name]gxw, XGRAD, pw_gxwl+pw_gxw+pw_gxwr, max_pg_wamp);
        createinstr(&$[ext_name]gxw, (long)psd_pulsepos, pw_gxwl+pw_gxw+pw_gxwr, ia_gxw);
        psd_pulsepos += pw_gxwl;
    
        sprintf(psd_epstring, "echo%04d",$[et_offset]);
        pulsename(&($[ext_name]echotrain[$[et_offset]]), psd_epstring);
    
        if ($[et_dab_off] == 0)
            psd_epdaboff = 0;
        else
            psd_epdaboff = (long)(psd_pulsepos + $[et_dacqdelay] + $[et_dab_off]);            
        if ($[et_xtr_off] == 0)
            psd_epxtroff = 0;
        else
            psd_epxtroff = (long)(psd_pulsepos + $[et_dacqdelay] + $[et_xtr_off]);            
    
        epiacqq(&($[ext_name]echotrain[$[et_offset]]),                
                (long)(psd_pulsepos + $[et_dacqdelay]),
                psd_epdaboff, psd_epxtroff,
                (long)$[et_filt_slot], 
                (TYPDAB_PACKETS)DABNORM,
                (long)$[et_recvr_type],
                (long)$[et_dab_type]);
    
        psd_pulsepos += pw_gxw + pw_gxwr;      
    
        psd_eparity = 1;
        for (psd_gxwcnt = 2; psd_gxwcnt <= $[et_vps]; psd_gxwcnt++) {
            psd_eparity *= -1;
          if( psd_gxwcnt-1 > $[et_iref_etl] ){ /* internref */ 
            createramp(&$[ext_name]gyba, YGRAD, pw_gyba, 0, max_pg_wamp,
                       (short)((maxGradRes*pw_gyba)/GRAD_UPDATE_TIME), psd_etbetay);
            createinstr(&$[ext_name]gyba, (long)RUP_GRD(psd_pulsepos + pw_gxwad + pw_gxgap/2 -
                        (pw_gyba + pw_gyb/2)), pw_gyba, ia_gyb);
        
            if (pw_gyb >= GRAD_UPDATE_TIME) {
                createconst(&$[ext_name]gyb, YGRAD, pw_gyb, max_pg_wamp);
                createinstr(&$[ext_name]gyb, (long)RUP_GRD(psd_pulsepos + pw_gxwad + pw_gxgap/2 -
                            pw_gyb/2), pw_gyb, ia_gyb);
            }
        
            createramp(&$[ext_name]gybd, YGRAD, pw_gybd, max_pg_wamp, 0,
                       (short)((maxGradRes*pw_gybd)/GRAD_UPDATE_TIME), psd_etbetay);
            createinstr(&$[ext_name]gybd, (long)RUP_GRD(psd_pulsepos + pw_gxwad + pw_gxgap/2 +
                        pw_gyb/2), pw_gybd, ia_gyb);
        
            linkpulses(3,&$[ext_name]gyb,&$[ext_name]gyba,&$[ext_name]gybd);
          } 

          createramp(&$[ext_name]gxwd, XGRAD, pw_gxwad, -max_pg_wamp, 0,
                           (short)(maxGradRes*(pw_gxwad)/GRAD_UPDATE_TIME), psd_etbetax);
          createinstr(&$[ext_name]gxwd, (long)psd_pulsepos, pw_gxwad, psd_eparity*ia_gxw);
          psd_pulsepos += pw_gxwad;

          if( pw_gxgap == 0 ){
               if( (pw_iref_gxwait != 0) && (psd_gxwcnt == $[et_iref_etl]) ){ 
                   createconst(&$[ext_name]gxgap, XGRAD, pw_iref_gxwait, 0);
                   createinstr(&$[ext_name]gxgap, (long)psd_pulsepos, pw_iref_gxwait, 0);
                   psd_pulsepos += pw_iref_gxwait;
               }
          }else{ 
               int gapgap;
               if( (pw_iref_gxwait == 0) || (psd_gxwcnt != $[et_iref_etl]) ){
                   gapgap = pw_gxgap;
               }else{
                   gapgap = pw_gxgap+pw_iref_gxwait;
               }
               createconst(&$[ext_name]gxgap, XGRAD, gapgap, 0);
               createinstr(&$[ext_name]gxgap, (long)psd_pulsepos, gapgap, 0);
               psd_pulsepos += gapgap;
          }

          createramp(&$[ext_name]gxwa, XGRAD, pw_gxwad, 0, max_pg_wamp,
                     (short)(maxGradRes*(pw_gxwad)/GRAD_UPDATE_TIME), psd_etbetax);
          createinstr(&$[ext_name]gxwa, (long)psd_pulsepos, pw_gxwad, psd_eparity*ia_gxw);
          psd_pulsepos += pw_gxwad;
        
            createconst(&$[ext_name]gxw, XGRAD, pw_gxwl+pw_gxw+pw_gxwr, max_pg_wamp);
            createinstr(&$[ext_name]gxw, (long)psd_pulsepos,
                        pw_gxwl+pw_gxw+pw_gxwr, psd_eparity*ia_gxw);
            psd_pulsepos += pw_gxwl;
        
            sprintf(psd_epstring, "echo%04d", psd_gxwcnt-1 + $[et_offset]);
            pulsename(&($[ext_name]echotrain[psd_gxwcnt-1+$[et_offset]]), psd_epstring);
        
            if ($[et_dab_off] == 0)                                           
                psd_epdaboff = 0;
            else
                psd_epdaboff = (long)(psd_pulsepos + $[et_dacqdelay] + $[et_dab_off]);
        
            if ($[et_xtr_off] == 0)
                psd_epxtroff = 0;
            else
                psd_epxtroff = (long)(psd_pulsepos + $[et_dacqdelay] + $[et_xtr_off]);
        
            epiacqq(&($[ext_name]echotrain[psd_gxwcnt-1+$[et_offset]]),                
                    (long)(psd_pulsepos + $[et_dacqdelay]),
                    psd_epdaboff, psd_epxtroff,
                    (long)$[et_filt_slot], 
                    (TYPDAB_PACKETS)DABNORM,
                    (long)$[et_recvr_type],
                    (long)$[et_dab_type]);
        
            psd_pulsepos += pw_gxw + pw_gxwr;      
        } 
    
        if (($[et_vps] % 2) == 1) {    /* views per shot is odd */          
            if (pw_gxcra >= GRAD_UPDATE_TIME) {
                createramp(&$[ext_name]gxcra, XGRAD, pw_gxcra, (short)ia_gxw,
                           (short)ia_gxcr, (short)(maxGradRes*(pw_gxcra/
                           GRAD_UPDATE_TIME)), psd_etbetax);
                createinstr(&$[ext_name]gxcra, (long)(psd_pulsepos), pw_gxcra, max_pg_iamp);
                psd_pulsepos += pw_gxcra;
            }
        } else {                        /* views per shot is even */
            /* single transition ramp into crusher */                  
            if ((ia_gxw == ia_gxcr) && (pw_gxwad == pw_gxcra)) {
                createramp(&$[ext_name]gxwd, XGRAD, 2*pw_gxwad, -max_pg_wamp, max_pg_wamp,
                           (short)(maxGradRes*(2*pw_gxwad)/GRAD_UPDATE_TIME), psd_etbetax);
                createinstr(&$[ext_name]gxwd, (long)psd_pulsepos, 2*pw_gxwad, ia_gxw);
                psd_pulsepos += 2*pw_gxwad;
            } else {    /* two separate ramps, decay ramp needs new waveform */
                createramp(&$[ext_name]gxwde, XGRAD, pw_gxwad, -max_pg_wamp, 0,              
                           (short)(maxGradRes*(pw_gxwad)/GRAD_UPDATE_TIME), psd_etbetax);
                createinstr(&$[ext_name]gxwde, (long)psd_pulsepos, pw_gxwad, ia_gxw);
                psd_pulsepos += pw_gxwad;

                if (pw_gxcra >= GRAD_UPDATE_TIME) {
                    createramp(&$[ext_name]gxcra, XGRAD, pw_gxcra, (short)0,
                               (short)ia_gxcr, (short)(maxGradRes*(pw_gxcra/
                               GRAD_UPDATE_TIME)), psd_etbetax);
                    createinstr(&$[ext_name]gxcra, (long)(psd_pulsepos), pw_gxcra, max_pg_iamp);
                    psd_pulsepos += pw_gxcra;
                }
            }   
        }        
     }
  }
}  /* End EP_TRAIN_Name Macro */
