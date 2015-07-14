/*
 *  GE Medical Systems
 *  Copyright (C) 1997 The General Electric Company
 *  
 *  epiRtd.e
 *  
 *  Contains code for real-time-display of epi data.  This functionality is used by
 *  the epi tools 
 *  
 *  Language : ANSI C
 *  Author   : Bryan Mock 
 *  Date     : 5/10/01
 */
/* do not edit anything above this line */
/***************************************************************
 *14.5 10/09/2006 TS   MRIhc15304 - coil info related changes for 14.5
 
 ******************************************************************/

@host epiRtdCV
int rtd_on = 0 with {0,1,0,INVIS, "0:rtd off; 1: rtd on",};

@rsp epiRTD
STATUS epiRTD(void);

STATUS epiRTD (void) {
    
    int loopcnt;

    if(rtd_on == PSD_ON){
        
        attenlockoff(&atten);
        
        /* Modify rotation matrices if necessary */
        if (resrot == PSD_ON) {
            setrotatearray((short)(opslquant*opphases),origrot[0]);
            resrot = modrot = rotx = roty = rotz = 0;
        }
        
        if (modrot == PSD_ON) {
            modrotmats(origrot,rsprot,rotx,roty,rotz,(opslquant*opphases),
                                 debugstate);
            setrotatearray((short)(opslquant*opphases),rsprot[0]);
        }
        
        /* Modify slice location if necessary */
        if (resloc == PSD_ON) {
            setupslices(rf1_freq, orig_rsp_info, opslquant, a_gzrf1,
                        (float)1, (opfov*freq_scale), TYPTRANSMIT);
            setupslices(theta_freq, orig_rsp_info, opslquant, a_gzrf1/4.0,
                        (float)1, (opfov*freq_scale), TYPTRANSMIT);
            if (oppseq == PSD_SE)
            setupslices(rf2_freq, orig_rsp_info, opslquant, a_gzrf2,
                        (float)1, (opfov*freq_scale), TYPTRANSMIT);
            
            resloc = modloc = dso = dro = dpo = 0;
            xtr = xtr_rba_time;
            frt = frtime;
            ref_switch = 0;

            b0Dither_ifile(b0ditherval, ditheron, rdx, rdy, rdz, 
                           a_gxw, esp, opslquant,
                           debugdither, rsprot_unscaled, ccinx, cciny, ccinz, 
                           esp_in, fesp_in, &g0, &num_elements, &file_exist);
            
            calcdelayfile(delayval, delayon, dlyx, dlyy, dlyz,
                          &defaultdelay, opslquant, debugdelay, rsprot_unscaled, delay_buffer);
            
            
            for (slice = 0; slice < opslquant; slice++)
            {
                delayval[slice] += dacq_adjust;

                if (delayval[slice] < 0.0)
                    gldelaycval[slice] = (int)(delayval[slice] - 0.5);
                else
                    gldelaycval[slice] = (int)(delayval[slice] + 0.5);
            }
            /* MRIge89403: Added iref_etl for internal ref scan */ 
            epiRecvFrqPhs( opslquant, intleaves, etl, xtr-timedelta,
                           refdattime, frt, opfov, opyres, opphasefov,
                           b0ditherval, rf_phase_spgr, dro, dpo, orig_rsp_info,
                           view1st, viewskip, gradpol, ref_switch, ky_dir,
                           dc_chop, pepolar, recv_freq, recv_phase_angle,
                           recv_phase, gldelayfval, a_gxw, debugepc,
                           ref_with_xoffset, 1.0, iref_etl );
        }
        
        if (modloc == PSD_ON) {
            for (loopcnt=0; loopcnt< opslquant; loopcnt++){
                rsp_info[loopcnt].rsptloc = orig_rsp_info[loopcnt].rsptloc +
                    (float)dso;
                rsp_info[loopcnt].rsprloc = orig_rsp_info[loopcnt].rsprloc +
                    (float)dro;
                rsp_info[loopcnt].rspphasoff = orig_rsp_info[loopcnt].rspphasoff +
                    (float)dpo;
            }

            setupslices(rf1_freq, rsp_info, opslquant, a_gzrf1,
                        (float)1, (opfov*freq_scale), TYPTRANSMIT);
            setupslices(theta_freq, rsp_info, opslquant, a_gzrf1/4.0,
                        (float)1, (opfov*freq_scale), TYPTRANSMIT);

            if (oppseq == PSD_SE)
                setupslices(rf2_freq, rsp_info, opslquant, a_gzrf2,
                            (float)1, (opfov*freq_scale), TYPTRANSMIT);
            
            b0Dither_ifile(b0ditherval, ditheron, rdx, rdy, rdz, 
                           a_gxw, esp, opslquant,
                           debugdither, rsprot_unscaled, ccinx, cciny, ccinz, 
                           esp_in, fesp_in, &g0, &num_elements, &file_exist);
            
            calcdelayfile(delayval, delayon, dlyx, dlyy, dlyz,
                          &defaultdelay, opslquant, debugdelay, rsprot_unscaled, delay_buffer);         
            
            for (slice = 0; slice < opslquant; slice++)
            {

                delayval[slice] += dacq_adjust;

                if (delayval[slice] < 0.0)
                    gldelaycval[slice] = (int)(delayval[slice] - 0.5);
                else
                    gldelaycval[slice] = (int)(delayval[slice] + 0.5);
            }
            
            
            ref_switch = 0;
            /* MRIge89403: Added iref_etl for internal ref scan */ 
            epiRecvFrqPhs( opslquant, intleaves, etl, xtr-timedelta,
                           refdattime, frt, opfov, opyres, opphasefov,
                           b0ditherval, rf_phase_spgr, 0, 0, rsp_info,
                           view1st, viewskip, gradpol, ref_switch, ky_dir,
                           dc_chop, pepolar, recv_freq, recv_phase_angle,
                           recv_phase, gldelayfval, a_gxw, debugepc,
                           ref_with_xoffset, 1.0, iref_etl );
            
        } /* if (modloc == PSD_ON) */

    } /* rtd_on == PSD_ON */
    
    return SUCCESS;
    
} /* end epiRTD() */
