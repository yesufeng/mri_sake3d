/*
 * touch.e
 *
 * Copyright (c) 2010 by General Electric Company. All Rights Reserved.
 */

/**
 * \file touch.e
 * MR-Touch EPIC inline file
 *
 * @author Zhenghui Zhang
 * @since 23.0
 */

/*
 * Comments:
 * Author (or Initials) Date (dd mmm CCYY)
 * Comment
 *
 * ZZ 16 Aug 2010
 * Original implementation based on Mayo prototype by Kevin Glaser.
 *
 */

@cv TouchCV
/* Start inline from touch.e TouchCV */
int touch_flag = PSD_OFF with { PSD_OFF, PSD_ON, PSD_OFF, VIS, "flag to turn on MR-Touch", };
float touch_target = 2.2 with { 0, 5.0, 2.2, INVIS, "common derated target", };
int touch_rt = 4 with { 4, 10000, 4, INVIS, "common derated rise time", };
int touch_time = 0 with { 0, 25000000, 0, VIS, "Total Duration of the MEG", };
int touch_gnum = 1 with { 0, 100, 1, VIS, "Number of MEG", };
int touch_period = 0 with { 0, 50000, 0, VIS, "1/freq in us", };
int touch_lobe = 0 with { 0, 25000, 0, VIS, "Half Period", };
int touch_delta = 0 with { 0, 25000, 0, VIS, "Time Between Offsets", };
float touch_act_freq = 60.0 with { 0.0, 5050.6, 60.0, VIS, "actual freq used based on gradient resolution",};
int touch_pwcon = 0 with { 0, 25000, 0, VIS, "Width of Flat Top for MEG",};
int touch_pwramp = 0 with { 0, 25000, 0, VIS, "Ramp Time for MEG", };
float touch_gdrate = 1.0 with { 0.0, 1.0, 1.0, VIS, "scale down from max amp of encoding gradients", };
float touch_gamp = 1.76 with { 0.0, 5.0, 1.76, VIS, "Amplitude of MEG in g/cm", };
float touch_gamp2 = -1 with { -1, 0, -1, VIS, "0 for 1-sided encoding; -1 for 2-sided encoding ", };
int touch_xdir = PSD_OFF with { PSD_OFF, PSD_ON, PSD_OFF, VIS, "MEG in X Direction", };
int touch_ydir = PSD_OFF with { PSD_OFF, PSD_ON, PSD_OFF, VIS, "MEG in Y Direction", };
int touch_zdir = PSD_OFF with { PSD_OFF, PSD_ON, PSD_OFF, VIS, "MEG in Z Direction", };
int touch_burst_count = 60 with { 1, 500, 60, VIS, "Resoundant Cycles per Trigger", };
int touch_ndir = 2 with { 2, 2, 2, INVIS, "Number of MEG Polarities: 2 for bi-polar", };
int touch_sync_pw = 50 with { 0, 200, 50, VIS, "Trigger Width in us", };
int touch_fcomp = 2 with { 0, 2, 2, VIS, "Flow Comp MEG Pulses. 1: Bipolar Pulse, 2: 1-2-1 Pulse", };
float touch_menc = 0 with { 0, 50000, 0, VIS, "Phase to Displacement Conversion Factor", };
int touch_tr_time = 0 with { 0, 30000000, 0, VIS, "Default TR for MR-Touch", };
int touch_driver_amp = 30 with { 0, 100, 30, VIS, "Resoundant Driver Amplitude", };

int touch_period_motion;
int touch_period_meg; /* period of the motion and the MEG (us) */
int touch_lobe_motion;
int touch_lobe_meg; /* half-period of the motion and the MEG (us) */
float touch_act_freq_motion;
float touch_act_freq_meg; /* actual frequency of motion and MEG based on gradient resolution (Hz) */
int touch_pos_sync;
int touch_pos_encode;
int cont_drive_ssp_delay = 0; /* time shift (us) to use on SSP board when placing trigger pulses to help avoid overlapping other waveforms */

/*   multiphase variables added based what was in 120m4 gremre.e */
int multiphase_flag = 0 with { 0, 1, 0, VIS, "0=OFF, 1=Support for sequential single slice multiphase", };
int multi_phases = 1 with { 1, 256, 1, VIS, "Number of phases when multiphase is ON", };

int rf2_time = 0;
int pw_gz2_tot = 0;
int M_half_periods = 0;
int meg_mode = 0; /* variables affecting MEGs around RF2 */
int grad_axis = 7; /* variables affecting which axes the MEGs are on */

int touch_maxshots = 1; /* max number of shots, currently only single shot EPI supported*/

/* End inline from touch.e TouchCV */

@host TouchInit
/* Start inline from touch.e TouchInit */
    if( (PSD_ON == exist(optouch)) && (Absent == !checkOptionKey(SOK_TOUCH2D)) )
    {
        epic_error(use_ermes, "%s is not available without the option key.", EM_PSD_FEATURE_OPTION_KEY, EE_ARGS(1), STRING_ARG, "MR-Touch");
        return FAILURE;
    }

    if( PSD_ON == (exist(optouch) && existcv(optouch)) )
    {
        touch_flag = PSD_ON;
    }
    else
    {
        touch_flag = PSD_OFF;
    }
/* End inline from touch.e TouchInit */

@host TouchEval
/* Start inline from touch.e TouchEval */
if( touch_flag )
{
    watchdogcount = 15; /* increase delay to allow for parameter download to active driver */
    /* Setup MR-Touch UI */
    pitouch = 1;

    pitouchaxnub = 7;
    pideftouchax = 4;
    pitouchaxval2 = 1;
    pitouchaxval3 = 2;
    pitouchaxval4 = 4;

    pideftouchtphases = 4;
    pideftouchfreq = 60;
    pideftouchcyc = 60;
    pideftouchamp = 70;
    pideftouchmegfreq = 60;

    pinecho = 1;

    pitrnub = 6;
    pitrval2 = 1s;
    pitrval3 = 2s;
    pitrval4 = 3s;
    pitrval5 = 4s;
    pitrval6 = 5s;
                         
    /* ****************************** */
    /* set some multiphase parameters */
    /* ****************************** */
    cvoverride(opfphases,  exist(optouchtphases), PSD_FIX_ON, PSD_EXIST_ON);
    TR_PASS = 20ms;
    cvmin(opsldelay, TR_PASS);
    cvdef(opsldelay, TR_PASS);
    opsldelay = TR_PASS;

    /* turn on multiphase screen */
    multiphase_flag = PSD_ON;

    cvdef(opacqo, 0);
    opacqo = 0;

    if( PSD_ON == multiphase_flag )
    {
        multi_phases = opfphases;
    }
    else
    {
        multi_phases = 1;
    }

    /* set frequency and phase encoding number pulldown menus */
    cvmax(opxres, 256);
    pixresval2 = 64;
    pixresval3 = 80;
    pixresval4 = 96;
    pixresval5 = 128;
    pixresval6 = 160;

    cvmax(opyres, 256);
    piyresval2 = 64;
    piyresval3 = 80;
    piyresval4 = 96;
    piyresval5 = 128;
    piyresval6 = 160;

    cvdef(optouchcyc, 60);
}
else{
    pitouch = 0;
    multiphase_flag = PSD_OFF;
    multi_phases = 1;
}
/* End inline from touch.e TouchEval */

@host TouchEvalTimings
/* Start inline from touch.e TouchEvalTimings */
/* Set up CVs other parameters */
if( touch_flag )
{
    /* Set some parameters for controlling sliding waveforms during multishot EPI acquisitions */
    pw_touch_wssp = esp + 8us;

    if( PSD_ON == multiphase_flag )
    { /* when multiphase is on for MRE, opfphases is the number of phase offsets */
        multi_phases = opfphases;
    }
    else
    { /* Set default values */
        multi_phases = 1;
    }

    touch_ndir = 2;

    meg_mode = 3; /* set variable that controls if MEGs will be both before and after the refocusing pulse or not */

    /* determine how the motion encoding is going to be done, including the number of encoding directions and which axes are invovled */
    /* grad_axis is a bit flag indicating which gradients will have MEGs on them */
    grad_axis = (int)exist(optouchax);
    touch_xdir = ((((int)grad_axis) & 1) != 0); /* flag indicating if there will be a MEG in the frequency-encoding direction */
    touch_ydir = ((((int)grad_axis) & 2) != 0); /* flag indicating if there will be a MEG in the phase-encoding direction */
    touch_zdir = ((((int)grad_axis) & 4) != 0); /* flag indicating if there will be a MEG in the slice-select direction */

    /* derate to lowest gradient parameters so all gradients have same response for the target gradient amplitude and minimum rise time */
    touch_target = FMin(3, loggrd.tx, loggrd.ty, loggrd.tz);
    touch_rt = IMax(3, loggrd.xrt, loggrd.yrt, loggrd.zrt);

    touch_fcomp = 2; /* flow comp. style for MEG (0=not flow comp'ed, 1=long MEG 1-2-1, 2=short MEG 1-2-1). This could be linked to opfcomp, but currently it is not for max flexibility. */
    /* set the number of motion-encoding gradients to be put before the refocusing pulse */
    if( touch_fcomp > 0 )
    { 
        touch_gnum = 1;
    }
    touch_gdrate = 0.8; /* derating scale factor to be multiplied times the hardware maximum gradient amplitude to get the MEG amplitude */
    touch_gamp = touch_gdrate * touch_target; /* scale the target maximum gradient amplitude to get the desired MEG amplitude */
    touch_pwramp = IMax(2, GRAD_UPDATE_TIME, RUP_GRD((int)(touch_rt * touch_gdrate))); /* calculate the attack/decay ramp times for the MEG accounting for derated amplitude of the MEG */
    if( touch_fcomp == 2 )
    {
        touch_pwramp = 2 * touch_pwramp; /* for this style of MEG, the flow comp. lobes have half the ramp and plateau times of the main MEG lobe we are defining, so make sure the small lobe doesn't violate slewing limits */
    }

    touch_period_meg = RUP_GRD((int)(1.0s / ((float)exist(optouchmegfreq)))); /* calculate the desired period of one MEG */
    if( touch_fcomp == 2 )
    {
        touch_period_meg = 4 * GRAD_UPDATE_TIME * (touch_period_meg / (4 * GRAD_UPDATE_TIME)); /* for this flow compensated MEG, make the main lobe size divisible by 4 UPDATE_TIME's . . . */
    }
    else
    {
        touch_period_meg = 2 * GRAD_UPDATE_TIME * (touch_period_meg / (2 * GRAD_UPDATE_TIME)); /* . . . otherwise, just make it divisible by 2 */
    }
    touch_pwcon = (touch_period_meg / 2) - 2 * touch_pwramp; /* calculate the plateau width for the main MEG lobe (i.e., half the period minus the attack and decay ramps) */
    /* if the MEG frequency is too high, we can't ramp up to the desired MEG amplitude, so we must artificially lower the MEG amplitude and recalculate everything */
    if( (touch_pwcon < GRAD_UPDATE_TIME) || ((touch_fcomp == 2) && (touch_pwcon < 2 * GRAD_UPDATE_TIME)) )
    {
        if( touch_fcomp == 2 )
        {
            touch_pwcon = 2 * GRAD_UPDATE_TIME;
            touch_pwramp = RDN_GRD((touch_period_meg - 2 * touch_pwcon) / 8)*2;
            touch_gdrate = touch_pwramp * 1. / (2 * touch_rt);
            touch_gamp = touch_gdrate * touch_target;
        }
        else
        {
            touch_pwcon = 1 * GRAD_UPDATE_TIME;
            touch_pwramp = RDN_GRD((touch_period_meg - 2 * touch_pwcon) / 4);
            touch_gdrate = touch_pwramp * 1. / touch_rt;
            touch_gamp = touch_gdrate * touch_target;
        }
    }
    touch_period_meg = 2 * (touch_pwcon + 2 * touch_pwramp); /* calculate the final period of the MEG */
    touch_period_motion = 2 * RUP_GRD((int)(1.0s / (2.0 * exist(optouchfreq))));
    touch_delta = RUP_GRD(touch_period_motion / multi_phases); /* calculate the amount of time between trigger pulses */
    touch_act_freq_motion = 1.0s / ((float)touch_period_motion); /* report the actual motion frequency after the above rounding of the period of motion . . . */
    touch_lobe_motion = touch_period_motion / 2; /* . . . and a half period of motion */
    touch_act_freq_meg = 1.0s / ((float)touch_period_meg); /* report the actual MEG frequency after the above adjustments to the gradient waveforms . . . */
    touch_lobe_meg = touch_period_meg / 2; /* and a half period of the MEG */

    touch_driver_amp = (int)exist(optouchamp);
    touch_burst_count = (int)exist(optouchcyc);
    
    calc_menc(&touch_menc); /* calculate the motion sensitivity (MENC) for this acquisition and update pitouchmenc to reflect that information while prescribing other parameters */
    pitouchmenc = touch_menc;

    /* Calculate the amount of time the MEG's will take based on the above gradient waveform durations.  This time will be needed to update the minimum echo time correctly */
    touch_time = 2 * touch_gnum * touch_lobe_meg;
    if( touch_fcomp == 1 )
    {
        touch_time += touch_lobe_meg;
    }

    /* set touch CVs */
    optouchtphases = opfphases;
    touch_act_freq = touch_act_freq_motion;

    /* Report the number of various MEG waveforms in the various grad structures acounting for things like flow comp, half gradient pairs, and motion-encoding on various axes */
    if( touch_fcomp )
    {
        gradx[TOUCH_GXU_SLOT].num = touch_xdir * (touch_gnum - 1);
        gradx[TOUCH_GXD_SLOT].num = touch_xdir * touch_gnum;
        grady[TOUCH_GYU_SLOT].num = touch_ydir * (touch_gnum - 1);
        grady[TOUCH_GYD_SLOT].num = touch_ydir * touch_gnum;
        gradz[TOUCH_GZU_SLOT].num = touch_zdir * (touch_gnum - 1);
        gradz[TOUCH_GZD_SLOT].num = touch_zdir * touch_gnum;
        gradx[TOUCH_GXF_SLOT].num = touch_xdir * 2;
        grady[TOUCH_GYF_SLOT].num = touch_ydir * 2;
        gradz[TOUCH_GZF_SLOT].num = touch_zdir * 2;
    }
    else
    {
        gradx[TOUCH_GXU_SLOT].num = touch_xdir * ((int)ceil(touch_gnum));
        gradx[TOUCH_GXD_SLOT].num = touch_xdir * ((int)touch_gnum);
        grady[TOUCH_GYU_SLOT].num = touch_ydir * ((int)ceil(touch_gnum));
        grady[TOUCH_GYD_SLOT].num = touch_ydir * ((int)touch_gnum);
        gradz[TOUCH_GZU_SLOT].num = touch_zdir * ((int)ceil(touch_gnum));
        gradz[TOUCH_GZD_SLOT].num = touch_zdir * ((int)touch_gnum);
        gradx[TOUCH_GXF_SLOT].num = 0;
        grady[TOUCH_GYF_SLOT].num = 0;
        gradz[TOUCH_GZF_SLOT].num = 0;
    }

    /* Now do the same thing for the MEG's that are after the refocusing pulse (which are not always present). */
    {
        int blip2_tmp;

        if( meg_mode >= 1 )
        {
            blip2_tmp = 1; /* if meg_mode >= 1, then these gradients are present, so set this scale factor to 1 so the number of MEGs is used . . . */
        }
        else
        {
            blip2_tmp = 0; /* . . . otherwise, set this scale factor to 0 */
        }

        if( touch_fcomp )
        {
            gradx[TOUCH_GXU2_SLOT].num = blip2_tmp * touch_xdir * (touch_gnum - 1);
            gradx[TOUCH_GXD2_SLOT].num = blip2_tmp * touch_xdir * touch_gnum;
            grady[TOUCH_GYU2_SLOT].num = blip2_tmp * touch_ydir * (touch_gnum - 1);
            grady[TOUCH_GYD2_SLOT].num = blip2_tmp * touch_ydir * touch_gnum;
            gradz[TOUCH_GZU2_SLOT].num = blip2_tmp * touch_zdir * (touch_gnum - 1);
            gradz[TOUCH_GZD2_SLOT].num = blip2_tmp * touch_zdir * touch_gnum;
            gradx[TOUCH_GXF2_SLOT].num = blip2_tmp * touch_xdir * 2;
            grady[TOUCH_GYF2_SLOT].num = blip2_tmp * touch_ydir * 2;
            gradz[TOUCH_GZF2_SLOT].num = blip2_tmp * touch_zdir * 2;
        }
        else
        {
            gradx[TOUCH_GXU2_SLOT].num = blip2_tmp * touch_xdir * ((int)ceil(touch_gnum));
            gradx[TOUCH_GXD2_SLOT].num = blip2_tmp * touch_xdir * ((int)touch_gnum);
            grady[TOUCH_GYU2_SLOT].num = blip2_tmp * touch_ydir * ((int)ceil(touch_gnum));
            grady[TOUCH_GYD2_SLOT].num = blip2_tmp * touch_ydir * ((int)touch_gnum);
            gradz[TOUCH_GZU2_SLOT].num = blip2_tmp * touch_zdir * ((int)ceil(touch_gnum));
            gradz[TOUCH_GZD2_SLOT].num = blip2_tmp * touch_zdir * ((int)touch_gnum);
            gradx[TOUCH_GXF2_SLOT].num = 0;
            grady[TOUCH_GYF2_SLOT].num = 0;
            gradz[TOUCH_GZF2_SLOT].num = 0;
        }
    }
}
else
{
    pw_touch_wssp = 0;
    multi_phases = 1;
}
/* End inline from touch.e TouchEvalTimings */

@host TouchTRCalc
/* Start inline from touch.e TouchTRCalc */
if( touch_flag )
{
    int touch_burst_per_tr;

    /* TR needs to be dividable by driver cycles, calculate cycles based
     * on the given TR  */
    touch_burst_count = ceil( (double)act_tr/(double)slquant1/(double)touch_period_motion);
    touch_burst_per_tr = touch_burst_count * slquant1;
    act_tr = RUP_GRD(touch_burst_per_tr * touch_period_motion);
    pitouchcycnub=0;
    pideftouchcyc = touch_burst_count;
    avmaxtouchcyc = touch_burst_count;
    avmintouchcyc = touch_burst_count;
    cvoverride(optouchcyc, touch_burst_count, PSD_FIX_ON, PSD_EXIST_ON);
    pitouchcyc = touch_burst_count;
}
else
{
    pitouchcyc = 0;
}
/* End inline from touch.e TouchTRCalc */

@host TouchTECalc
/* Start inline from touch.e TouchTECalc */
if( touch_flag )
{
    /* If MEGs are put on both sides of RF2, they must be synchronized with the motion the right way so that the phase due the motion and MEG's accrues constructively. */
    /* To do this, calculate how much time is needed for the left MEG and the RF2 gradients, and round this amount of time up to the next appropriate factor of a full or half period of motion to determine where to put the MEG on the right side of RF2 */
    /* rf2_time is going to be the amount of time reserved for RF2 between the end of the left MEG and the beginning of the right MEG */
    {
        int tmp1, tmp2;
        tmp1 = pw_gzrf2l1a + pw_gzrf2l1 + pw_gzrf2l1d + 0 * pw_gzrf2a + pw_gzrf2 / 2;
        tmp2 = pw_gzrf2 / 2 + 0 * pw_gzrf2d + pw_gzrf2r1a + pw_gzrf2r1 + pw_gzrf2r1d;
        pw_gz2_tot = 2 * IMax(2, tmp1, tmp2); /* time needed for the RF2 gradients */
    }

    /* calculate ssp time */
    int tmpssp;
    tmpssp = avminssp/2;

    int time_b4_rf2;
    time_b4_rf2 = IMax(2, touch_time+pw_gz2_tot, tmpssp);

    if( meg_mode == 3 )
    { /* L and R MEGs, minimum TE */
        M_half_periods = (int)ceil( time_b4_rf2 / ((float)touch_lobe_motion));
        rf2_time = M_half_periods * touch_lobe_motion - touch_time;
    }
    else if( meg_mode == 2 )
    { /* L and R MEGs, half periods */
        M_half_periods = (int)ceil( time_b4_rf2 / ((float)touch_lobe_motion));
        M_half_periods = M_half_periods + ((M_half_periods % 2) ? 0 : 1);
        rf2_time = M_half_periods * touch_lobe_motion - touch_time;
    }
    else if( meg_mode == 1 )
    { /* L and R MEGs, integer periods */
        M_half_periods = (int)ceil( time_b4_rf2 / ((float)touch_lobe_motion));
        M_half_periods = M_half_periods + (M_half_periods % 2);
        rf2_time = M_half_periods * touch_lobe_motion - touch_time;
    }
    else
    { /* Just L MEGs, no restrictions on TE */
        M_half_periods = 0;
        rf2_time = pw_gz2_tot;
        rf2_time = RUP_GRD(pw_gzrf2l1a + pw_gzrf2l1 + pw_gzrf2l1d + 0 * pw_gzrf2a + pw_gzrf2 + 0 * pw_gzrf2d + pw_gzrf2r1a + pw_gzrf2r1 + pw_gzrf2r1d);
    }
    rf2_time = RUP_GRD(rf2_time);
}
else
{
    rf2_time = 0;
}
/* End inline from touch.e TouchTECalc */

@host TouchMatrixCheck
/* Start inline from touch.e TouchMatrixCheck */
/* algorithm for calculating MENC */
void calc_menc( float *menc_factor )
{
    float sc_fact, gamma, N, F, G, T, fc, delta_rt, f_v, tmp1, tmp2, tmp3, q;
    int m_max, ms;

    sc_fact = 0; /* MEG sensitivity (rad/um) */
    gamma = GAM * 2 * PI; /* gyromagnetic ratio (rad/(s*G)) */
    N = touch_gnum; /* number of gradient pairs in single MEG train */
    F = touch_act_freq_meg; /* MEG frequency (Hz) */
    G = touch_gamp; /* MEG amplitude (G/cm) */
    T = touch_period_meg * (1e-6); /* period of MEG train (s) */
    fc = touch_fcomp; /* flow-compensation type (0=none, 1=type-1 (long MEG), 2=type-2 (short MEG)) */
    delta_rt = touch_pwramp * (1e-6); /* rise time from 0 to G (sec) */
    if( fc == 2 )
    {
        delta_rt = delta_rt / 2.0; /* need rise time of FC lobes for calculations involving this flow comp'ed MEG */
    }
    f_v = touch_act_freq_motion/0.99; /* frequency of vibration (Hz) */

    if( f_v == F )
    { /* motion freq. = MEG freq. */
        if( fc == 0 )
        { /* MEG is not flow compensated */
            N = 2 * N; /*  N is the # of half gradient lobes in this expression since single MEG lobes are supported now */
            sc_fact = (1e-4) * gamma * N * T * T * G * sin(2.0 * PI * delta_rt / T) / (2 * PI * PI * delta_rt);
        }
        else if( fc == 1 )
        { /*  type-1 flow compensation */
            sc_fact = (1e-4) * gamma * N * T * T * G * sin(2.0 * PI * delta_rt / T) / (PI * PI * delta_rt);
        }
        else if( fc == 2 )
        { /* type-2 flow compensation */
            m_max = 31;
            tmp1 = 0;
            for( ms = -m_max; ms <= m_max; ms += 2 )
            {
                tmp1 += (sin(PI * 4.0 * ms * delta_rt * F) / (PI * 4.0 * ms * delta_rt * F)) / (2.0 * PI * ms * (ms / 2.0 - 0.25));
            }
            tmp2 = (2.0 * N - 1.0) * sin(PI * 4.0 * delta_rt * F) / (PI * 4.0 * delta_rt * F) + tmp1;
            sc_fact = (1e-4) * gamma * T * G * tmp2 / PI;
        }
    }
    else
    {
        /* motion freq. != MEG freq. */
        if( fc == 0 )
        {
            N = 2 * N; /*  N is the # of half gradient lobes in this expression since single MEG lobes are supported now  */
            m_max = 31;
            tmp1 = 0;
            for( ms = -m_max; ms <= m_max; ms += 2 )
            {
                tmp1 += (sin(PI * 2.0 * ms * delta_rt / T) / (PI * 2.0 * ms * delta_rt / T)) * sin(PI * N * (ms - f_v * T) / 2.0) * pow(-1.0, (N * ms - (((int)N) % 2)) / 2.0) / (ms * (ms - f_v * T));
            }
            sc_fact = fabs((2.0 * (1e-4) * gamma * T * G / (PI * PI)) * (tmp1));
        }
        else if( fc == 1 )
        {
            m_max = 31;
            tmp1 = 0;
            for( ms = -m_max; ms <= m_max; ms += 2 )
            {
                tmp1 += (sin(PI * 2.0 * ms * delta_rt / T) / (PI * 2.0 * ms * delta_rt / T)) / (ms * (ms - f_v * T));
            }
            sc_fact = fabs((2.0 * (1e-4) * gamma * T * G * sin(PI * N * f_v * T) * sin(PI * f_v * T / 2.0) / (PI * PI)) * (tmp1));
        }
        else if( fc == 2 )
        {
            m_max = 31;
            tmp1 = 0;
            tmp2 = 0;
            q = f_v / F;
            for( ms = -m_max; ms <= m_max; ms += 2 )
            {
                tmp1 += (-(2.0 * N - 1.0) * cos(PI * q * (N - 0.5)) * (sin(PI * 4.0 * ms * delta_rt * F) / (PI * 4.0 * ms * delta_rt * F)) / (PI * (N - 0.5) * ms * (ms - q)));
                tmp2 += (cos(PI * q / 4.0) * (sin(PI * 4.0 * ms * delta_rt * F) / (PI * 4.0 * ms * delta_rt * F)) / (2.0 * PI * ms * (ms / 2.0 - q / 4.0)));
            }
            tmp3 = tmp1 * tmp1 + 2.0 * tmp2 * tmp2 + 4.0 * tmp1 * tmp2 * cos(PI * N * q - PI * q / 4.0) + 2.0 * tmp2 * tmp2 * cos(PI * q / 2.0 - 2.0 * PI * N * q);
            if( tmp3 < 0 )
            {
                sc_fact = 0.0;
            }
            else
            {
                sc_fact = (1e-4) * gamma * T * G * pow(tmp3, 0.5) / PI;
            }
        }
    } /* ends if (f_v == F), else statements */
    /* Assuming +/- phase subtraction with equal-amplitude MEGs, the motion sensitivity will be double what we just calculated, so we need an additional factor of 2. */
    /* We also need another factor of 2 if we are using MEGs after the refocusing pulse. */
    sc_fact = sc_fact * 2 * ((meg_mode > 0) ? 2 : 1);
    if( sc_fact > 0 )
    {
        *menc_factor = PI / sc_fact; /* MENC definition: touch_menc microns of motion results in PI radians of phase in the phase difference images*/
    }
    else
    {
        *menc_factor = 0;
    }
}
/* End inline from touch.e TouchMatrixCheck */

@host TouchPredownloadIhtdel
/* Start inline from touch.e TouchPredownloadIhtdel */
if( touch_flag )
{
    int i, j, ij;

    free(ihtdeltab);
    ihtdeltab = (int *)malloc(multi_phases * opslquant * sizeof(int));
    if( ihtdeltab == NULL )
    {
        epic_error(use_ermes, "malloc failed for %s.", EM_MALLOC_ERMES, EE_ARGS(1), STRING_ARG, "ihtdeltab");
        return FAILURE;
    }

    exportaddr(ihtdeltab, (int)(multi_phases * opslquant * sizeof(int)));
    ij = 0;
    for( i = 0; i < opslquant; i++ )
    {
        for( j = 0; j < multi_phases; j++ )
        {
            ihtdeltab[ij] = touch_delta * j;
            ij++;
        }
    }
}
/* End inline from touch.e TouchPredownloadIhtdel */

@host TouchAcqOrder
/* Start inline from touch.e TouchAcqOrder */
if( touch_flag )
{
    if( opacqo == 0 )
    {
        /* set multiphase with interleaved slices */
        int i, j, sloff;

        sloff = opslquant * opphases;

        for( j = 1; j < multi_phases; j++ )
        {
            for( i = 0; i < opslquant * opphases; i++ )
            {
                data_acq_order[sloff].slloc = data_acq_order[i].slloc;
                data_acq_order[sloff].slpass = data_acq_order[i].slpass + j * acqs;
                data_acq_order[sloff].sltime = data_acq_order[i].sltime;

                sloff++;
            }
        }

    }
    else
    {
        int i, j, sloff = 0;
        /* set multiphase with sequential slices */
        for( i = 0; i < opslquant * opphases; i++ )
        {
            for( j = 0; j < multi_phases; j++ )
            {
                data_acq_order[sloff].slloc = i;
                data_acq_order[sloff].slpass = sloff;
                data_acq_order[sloff].sltime = 0;
                sloff++;
            }
        }
    }
}
/* End inline from touch.e TouchAcqOrder */

@host TouchEvalGrad
/* Start inline from touch.e TouchEvalGrad */
/* Set MEG pulse width and amplitude values. */
if( touch_flag )
{
    gating = TRIG_INTERN;

    a_gxtouchu = touch_gamp;
    pw_gxtouchu = touch_pwcon;
    pw_gxtouchud = touch_pwramp;
    pw_gxtouchua = touch_pwramp;
    a_gytouchu = touch_gamp;
    pw_gytouchu = touch_pwcon;
    pw_gytouchud = touch_pwramp;
    pw_gytouchua = touch_pwramp;
    a_gztouchu = touch_gamp;
    pw_gztouchu = touch_pwcon;
    pw_gztouchud = touch_pwramp;
    pw_gztouchua = touch_pwramp;

    a_gxtouchd = -touch_gamp;
    pw_gxtouchd = touch_pwcon;
    pw_gxtouchdd = touch_pwramp;
    pw_gxtouchda = touch_pwramp;
    a_gytouchd = -touch_gamp;
    pw_gytouchd = touch_pwcon;
    pw_gytouchdd = touch_pwramp;
    pw_gytouchda = touch_pwramp;
    a_gztouchd = -touch_gamp;
    pw_gztouchd = touch_pwcon;
    pw_gztouchdd = touch_pwramp;
    pw_gztouchda = touch_pwramp;

    if( touch_fcomp == 1 )
    {
        a_gxtouchf = touch_gamp / 2;
        pw_gxtouchf = touch_pwcon;
        pw_gxtouchfd = touch_pwramp;
        pw_gxtouchfa = touch_pwramp;
        a_gytouchf = touch_gamp / 2;
        pw_gytouchf = touch_pwcon;
        pw_gytouchfd = touch_pwramp;
        pw_gytouchfa = touch_pwramp;
        a_gztouchf = touch_gamp / 2;
        pw_gztouchf = touch_pwcon;
        pw_gztouchfd = touch_pwramp;
        pw_gztouchfa = touch_pwramp;
    }
    else if( touch_fcomp == 2 )
    {
        a_gxtouchf = touch_gamp;
        pw_gxtouchf = touch_pwcon / 2;
        pw_gxtouchfd = touch_pwramp / 2;
        pw_gxtouchfa = touch_pwramp / 2;
        a_gytouchf = touch_gamp;
        pw_gytouchf = touch_pwcon / 2;
        pw_gytouchfd = touch_pwramp / 2;
        pw_gytouchfa = touch_pwramp / 2;
        a_gztouchf = touch_gamp;
        pw_gztouchf = touch_pwcon / 2;
        pw_gztouchfd = touch_pwramp / 2;
        pw_gztouchfa = touch_pwramp / 2;
    }

    /* 2nd set of MEGs for after RF2 */
    a_gxtouchu2 = touch_gamp;
    pw_gxtouchu2 = touch_pwcon;
    pw_gxtouchu2d = touch_pwramp;
    pw_gxtouchu2a = touch_pwramp;
    a_gytouchu2 = touch_gamp;
    pw_gytouchu2 = touch_pwcon;
    pw_gytouchu2d = touch_pwramp;
    pw_gytouchu2a = touch_pwramp;
    a_gztouchu2 = touch_gamp;
    pw_gztouchu2 = touch_pwcon;
    pw_gztouchu2d = touch_pwramp;
    pw_gztouchu2a = touch_pwramp;

    a_gxtouchd2 = -touch_gamp;
    pw_gxtouchd2 = touch_pwcon;
    pw_gxtouchd2d = touch_pwramp;
    pw_gxtouchd2a = touch_pwramp;
    a_gytouchd2 = -touch_gamp;
    pw_gytouchd2 = touch_pwcon;
    pw_gytouchd2d = touch_pwramp;
    pw_gytouchd2a = touch_pwramp;
    a_gztouchd2 = -touch_gamp;
    pw_gztouchd2 = touch_pwcon;
    pw_gztouchd2d = touch_pwramp;
    pw_gztouchd2a = touch_pwramp;

    if( touch_fcomp == 1 )
    {
        a_gxtouchf2 = touch_gamp / 2;
        pw_gxtouchf2 = touch_pwcon;
        pw_gxtouchf2d = touch_pwramp;
        pw_gxtouchf2a = touch_pwramp;
        a_gytouchf2 = touch_gamp / 2;
        pw_gytouchf2 = touch_pwcon;
        pw_gytouchf2d = touch_pwramp;
        pw_gytouchf2a = touch_pwramp;
        a_gztouchf2 = touch_gamp / 2;
        pw_gztouchf2 = touch_pwcon;
        pw_gztouchf2d = touch_pwramp;
        pw_gztouchf2a = touch_pwramp;
    }
    else if( touch_fcomp == 2 )
    {
        a_gxtouchf2 = touch_gamp;
        pw_gxtouchf2 = touch_pwcon / 2;
        pw_gxtouchf2d = touch_pwramp / 2;
        pw_gxtouchf2a = touch_pwramp / 2;
        a_gytouchf2 = touch_gamp;
        pw_gytouchf2 = touch_pwcon / 2;
        pw_gytouchf2d = touch_pwramp / 2;
        pw_gytouchf2a = touch_pwramp / 2;
        a_gztouchf2 = touch_gamp;
        pw_gztouchf2 = touch_pwcon / 2;
        pw_gztouchf2d = touch_pwramp / 2;
        pw_gztouchf2a = touch_pwramp / 2;
    }

    if( opphysplane != PSD_OBL )
    {
        gradx[TOUCH_GXU_SLOT].powscale = 1.0;
        gradx[TOUCH_GXD_SLOT].powscale = 1.0;
        gradx[TOUCH_GXF_SLOT].powscale = 1.0;
        grady[TOUCH_GYU_SLOT].powscale = 1.0;
        grady[TOUCH_GYD_SLOT].powscale = 1.0;
        grady[TOUCH_GYF_SLOT].powscale = 1.0;
        gradz[TOUCH_GZU_SLOT].powscale = 1.0;
        gradz[TOUCH_GZD_SLOT].powscale = 1.0;
        gradz[TOUCH_GZF_SLOT].powscale = 1.0;
        gradx[TOUCH_GXU2_SLOT].powscale = 1.0;
        gradx[TOUCH_GXD2_SLOT].powscale = 1.0;
        gradx[TOUCH_GXF2_SLOT].powscale = 1.0;
        grady[TOUCH_GYU2_SLOT].powscale = 1.0;
        grady[TOUCH_GYD2_SLOT].powscale = 1.0;
        grady[TOUCH_GYF2_SLOT].powscale = 1.0;
        gradz[TOUCH_GZU2_SLOT].powscale = 1.0;
        gradz[TOUCH_GZD2_SLOT].powscale = 1.0;
        gradz[TOUCH_GZF2_SLOT].powscale = 1.0;
    }
    else
    {
        float touch_powscale_factor;

        /* touch_powscale_factor = touch_gamp; */
        touch_powscale_factor = touch_target;

        gradx[TOUCH_GXU_SLOT].powscale = loggrd.xfs / touch_powscale_factor;
        gradx[TOUCH_GXD_SLOT].powscale = loggrd.xfs / touch_powscale_factor;
        gradx[TOUCH_GXF_SLOT].powscale = loggrd.xfs / touch_powscale_factor;
        grady[TOUCH_GYU_SLOT].powscale = loggrd.yfs / touch_powscale_factor;
        grady[TOUCH_GYD_SLOT].powscale = loggrd.yfs / touch_powscale_factor;
        grady[TOUCH_GYF_SLOT].powscale = loggrd.yfs / touch_powscale_factor;
        gradz[TOUCH_GZU_SLOT].powscale = loggrd.zfs / touch_powscale_factor;
        gradz[TOUCH_GZD_SLOT].powscale = loggrd.zfs / touch_powscale_factor;
        gradz[TOUCH_GZF_SLOT].powscale = loggrd.zfs / touch_powscale_factor;
        gradx[TOUCH_GXU2_SLOT].powscale = loggrd.xfs / touch_powscale_factor;
        gradx[TOUCH_GXD2_SLOT].powscale = loggrd.xfs / touch_powscale_factor;
        gradx[TOUCH_GXF2_SLOT].powscale = loggrd.xfs / touch_powscale_factor;
        grady[TOUCH_GYU2_SLOT].powscale = loggrd.yfs / touch_powscale_factor;
        grady[TOUCH_GYD2_SLOT].powscale = loggrd.yfs / touch_powscale_factor;
        grady[TOUCH_GYF2_SLOT].powscale = loggrd.yfs / touch_powscale_factor;
        gradz[TOUCH_GZU2_SLOT].powscale = loggrd.zfs / touch_powscale_factor;
        gradz[TOUCH_GZD2_SLOT].powscale = loggrd.zfs / touch_powscale_factor;
        gradz[TOUCH_GZF2_SLOT].powscale = loggrd.zfs / touch_powscale_factor;
    }
}
/* End inline from touch.e TouchEvalGrad */

@host TouchRhheader
/* Start inline from touch.e TouchRhheader */
/* Set recon header variables */
if( touch_flag )
{

    mag_mask = 0; /* turn off magnitude masks that might be applied to the data */

    rhyoff = 0;
    rhslblank = 0;
    rhvenc = 1000.0; /* this will scale the phase data by 1000 so it can be treated as integer values without significant discretizing artifacts (could even do 10000) */
    maxpc_cor = PSD_OFF;

    /* Set TEs and BWs to the same values for all echos since we are using
     * "echo" for motion encoding direction */
    ihte2 = ihte1;
    ihte3 = ihte1;
    ihte4 = ihte1;
    ihte5 = ihte1;
    ihte6 = ihte1;
    ihvbw2 = ihvbw1;
    ihvbw3 = ihvbw1;
    ihvbw4 = ihvbw1;
    ihvbw5 = ihvbw1;
    ihvbw6 = ihvbw1;

    phase_cor = 0;

    /* Setup phase constrast recon echo combination */
    rhvcoefxa = 1.0;
    rhvcoefxb = 2.0;
    rhvcoefxc = 2.0;
    rhvcoefxd = 1.0;
    rhvcoefya = 3.0;
    rhvcoefyb = 1.0;
    rhvcoefyc = 3.0;
    rhvcoefyd = 1.0;
    rhvcoefza = 4.0;
    rhvcoefzb = 1.0;
    rhvcoefzc = 4.0;
    rhvcoefzd = 1.0;

    rhvmcoef1 = 0.5;
    rhvmcoef2 = 0.5;
    rhvmcoef3 = 0.25;
    rhvmcoef4 = 0.25;

    rhvtype = VASCULAR + PHASE_CON + MAGNITUDE * opmagc;
}
else
{
    rhvtype = 0;
}
/* End inline from touch.e TouchRhheader */

@rspvar TouchRspVar
/* Start inline from touch.e TouchRspVar */
int cm_pass;
int rsp_cmnpass;
int pass_cnt;
int cmdir_rep;
int rsp_cmndir;
int wave_trigoff;
int wave_trigon;
int bp_pnts;
float tp;
float tz;
float Gp;
int max_pts;
int n_iter;

int rsp_slide;
int dab_slice;
int meg2_amp;

#define MAX_NUM_TOUCH_MOTION_DIRS 2
short touchxuamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchxdamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchxfamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchyuamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchydamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchyfamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchzuamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchzdamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchzfamp[MAX_NUM_TOUCH_MOTION_DIRS];
short touchxuamp2[MAX_NUM_TOUCH_MOTION_DIRS];
short touchxdamp2[MAX_NUM_TOUCH_MOTION_DIRS];
short touchxfamp2[MAX_NUM_TOUCH_MOTION_DIRS];
short touchyuamp2[MAX_NUM_TOUCH_MOTION_DIRS];
short touchydamp2[MAX_NUM_TOUCH_MOTION_DIRS];
short touchyfamp2[MAX_NUM_TOUCH_MOTION_DIRS];
short touchzuamp2[MAX_NUM_TOUCH_MOTION_DIRS];
short touchzdamp2[MAX_NUM_TOUCH_MOTION_DIRS];
short touchzfamp2[MAX_NUM_TOUCH_MOTION_DIRS];
/* End inline from touch.e TouchRspVar */

@pg TouchPg
/* Start inline from touch.e TouchPg */
/* Put the motion-encoding gradients and trigger pulses into the sequence */
if( touch_flag )
{
    int pos_enc, pos_enc0, pos_enc0_2;
    short dab6on[4];
    short dab6off[4];
    int i;

    dab6on[0] = SSPDS + EDC;
    dab6on[1] = SSPOC + DREG;
    dab6on[2] = SSPD + DABOUT6; /* SSPD+2*DSCP */
    dab6on[3] = SSPDS + 0x8000;
    dab6off[0] = SSPDS + EDC;
    dab6off[1] = SSPOC + DREG;
    dab6off[2] = SSPD;
    dab6off[3] = SSPDS + 0x8000;

    /* ***************************************************************
     Encoding gradients
     *****************************************************************/
    /* pos_enc will be the start of the motion-encoding gradients */
    if( oppseq == PSD_SE )
    {
        if( meg_mode == 0 )
        { /* left-side-only MEGs */
            if( opfcomp )
            {
                pos_enc0 = pend(&gzmnd, "gzmnd", 0); /* if flow comp. is on, MEG's start after GZMN . . . */
            }
            else
            {
                pos_enc0 = pendall(&gzrf1, gzrf1.ninsts - 1); /* otherwise they start after RF1 */
            }
        }
        else
        {
            pos_enc0 = RUP_GRD(pbeg(&gzrf2, "gzrf2", 0) + pw_gzrf2 / 2 - rf2_time / 2 - touch_time); /* if there will be MEG's on both sides of RF2, position them in a symmetric and synchronized fashion */
        }
    }
    else
    {
        pos_enc0 = ((opfcomp) ? pend(&gzmnd, "gzmnd", 0) : pend(&gz1d, "gz1d", 0)); /* for GRE EPI, put the MEG's after GZ1, or GZMN if flow comp. is on */
    }
    pos_enc0 = RUP_GRD(pos_enc0);
    pos_enc = pos_enc0;
    if( touch_fcomp == 1 )
    {
        if( touch_gnum )
        {
            AddEncodeFcomp(pos_enc, 0);
            AddEncodeDown(pos_enc + touch_lobe_meg, 0);
            pos_enc += touch_period_meg;
            for( i = 1; i < touch_gnum; i++ )
            {
                AddEncodeUp(pos_enc, 0);
                AddEncodeDown(pos_enc + touch_lobe_meg, 0);
                pos_enc += touch_period_meg;
            }
            AddEncodeFcomp(pos_enc, 0);
        }
    }
    else if( touch_fcomp == 2 )
    {
        if( touch_gnum )
        {
            AddEncodeFcomp(pos_enc, 0);
            AddEncodeDown(pos_enc + touch_lobe_meg / 2, 0);
            pos_enc += 3 * touch_lobe_meg / 2;
            for( i = 1; i < touch_gnum; i++ )
            {
                AddEncodeUp(pos_enc, 0);
                AddEncodeDown(pos_enc + touch_lobe_meg, 0);
                pos_enc += touch_period_meg;
            }
            AddEncodeFcomp(pos_enc, 0);
        }
    }
    else
    {
        if( touch_gnum > 0 )
        {
            for( i = 0; i < ceil(touch_gnum); i++ )
            {
                AddEncodeUp(pos_enc, 0);
                if( ((int)touch_gnum) == ceil(touch_gnum) )
                { /* if full MEG, always add down MEG */
                    AddEncodeDown(pos_enc + touch_lobe_meg, 0);
                }
                else
                { /* if half MEG, don't add last down MEG */
                    if( i < (ceil(touch_gnum) - 1) )
                    {
                        AddEncodeDown(pos_enc + touch_lobe_meg, 0);
                    }
                }
                pos_enc += touch_period_meg;
            }
        }
    }

    /* 2nd set of MEGs after the refocusing pulse */
    if( meg_mode >= 1 )
    {
        pos_enc0_2 = RUP_GRD(pos_enc0 + touch_time + rf2_time);
        pos_enc = pos_enc0_2;

        if( touch_fcomp == 1 )
        {
            if( touch_gnum )
            {
                AddEncodeFcomp(pos_enc, 1);
                AddEncodeDown(pos_enc + touch_lobe_meg, 1);
                pos_enc += touch_period_meg;
                for( i = 1; i < touch_gnum; i++ )
                {
                    AddEncodeUp(pos_enc, 1);
                    AddEncodeDown(pos_enc + touch_lobe_meg, 1);
                    pos_enc += touch_period_meg;
                }
                AddEncodeFcomp(pos_enc, 1);
            }
        }
        else if( touch_fcomp == 2 )
        {
            if( touch_gnum )
            {
                AddEncodeFcomp(pos_enc, 1);
                AddEncodeDown(pos_enc + touch_lobe_meg / 2, 1);
                pos_enc += 3 * touch_lobe_meg / 2;
                for( i = 1; i < touch_gnum; i++ )
                {
                    AddEncodeUp(pos_enc, 1);
                    AddEncodeDown(pos_enc + touch_lobe_meg, 1);
                    pos_enc += touch_period_meg;
                }
                AddEncodeFcomp(pos_enc, 1);
            }
        }
        else
        {
            if( touch_gnum > 0 )
            {
                for( i = 0; i < ceil(touch_gnum); i++ )
                {
                    AddEncodeUp(pos_enc, 1);
                    if( ((int)touch_gnum) == ceil(touch_gnum) )
                    { /* if full MEG, always add down MEG */
                        AddEncodeDown(pos_enc + touch_lobe_meg, 1);
                    }
                    else
                    { /* if half MEG, don't add last down MEG */
                        if( i < (ceil(touch_gnum) - 1) )
                        {
                            AddEncodeDown(pos_enc + touch_lobe_meg, 1);
                        }
                    }
                    pos_enc += touch_period_meg;
                }
            }
        }
    }

    /* ********************
     Sync Pulses
     *******************/
    int pos_sync = touch_pos_sync;

    /* if overlapping trigger pulses with the MEG's, start the trigger pulses after RF1, otherwise put them at the beginning of the sequence */
    pos_sync = pendallssp(&hyperdab, 0) + (multi_phases - 1.) * touch_delta + cont_drive_ssp_delay;

    while( pos_sync < 40us )
        pos_sync += act_tr + time_ssi;
    for( i = 0; i < multi_phases; i++ )
    {
        SSPPACKET(sync_on_2, pos_sync, 4, dab6on,);
        SSPPACKET(sync_off_2, pos_sync+touch_sync_pw-4, 4, dab6off,);
        pos_sync -= touch_delta;
    }
    getwave(&wave_trigon, &sync_on_2);
    getwave(&wave_trigoff, &sync_off_2);
}
/* End inline from touch.e TouchPg */

@pg TouchEncodePg
/* Start inline from touch.e TouchEncodePg */
void AddEncodeUp( int pos,
                  int meg_set )
{
    if( meg_set == 1 )
    {
        if( touch_xdir )
        {
            TRAPEZOID(XGRAD, gxtouchu2, pos + pw_gxtouchu2a, 0, TYPNDEF, loggrd);
        }
        if( touch_ydir )
        {
            TRAPEZOID(YGRAD, gytouchu2, pos + pw_gytouchu2a, 0, TYPNDEF, loggrd);
        }
        if( touch_zdir )
        {
            TRAPEZOID(ZGRAD, gztouchu2, pos + pw_gztouchu2a, 0, TYPNDEF, loggrd);
        }
    }
    else
    {
        if( touch_xdir )
        {
            TRAPEZOID(XGRAD, gxtouchu, pos + pw_gxtouchua, 0, TYPNDEF, loggrd);
        }
        if( touch_ydir )
        {
            TRAPEZOID(YGRAD, gytouchu, pos + pw_gytouchua, 0, TYPNDEF, loggrd);
        }
        if( touch_zdir )
        {
            TRAPEZOID(ZGRAD, gztouchu, pos + pw_gztouchua, 0, TYPNDEF, loggrd);
        }
    }
}

void AddEncodeDown( int pos,
                    int meg_set )
{
    if( meg_set == 1 )
    {
        if( touch_xdir )
        {
            TRAPEZOID(XGRAD, gxtouchd2, pos + pw_gxtouchd2a, 0, TYPNDEF, loggrd);
        }
        if( touch_ydir )
        {
            TRAPEZOID(YGRAD, gytouchd2, pos + pw_gytouchd2a, 0, TYPNDEF, loggrd);
        }
        if( touch_zdir )
        {
            TRAPEZOID(ZGRAD, gztouchd2, pos + pw_gztouchd2a, 0, TYPNDEF, loggrd);
        }
    }
    else
    {
        if( touch_xdir )
        {
            TRAPEZOID(XGRAD, gxtouchd, pos + pw_gxtouchda, 0, TYPNDEF, loggrd);
        }
        if( touch_ydir )
        {
            TRAPEZOID(YGRAD, gytouchd, pos + pw_gytouchda, 0, TYPNDEF, loggrd);
        }
        if( touch_zdir )
        {
            TRAPEZOID(ZGRAD, gztouchd, pos + pw_gztouchda, 0, TYPNDEF, loggrd);
        }
    }
}

void AddEncodeFcomp( int pos,
                     int meg_set )
{
    if( meg_set == 1 )
    {
        if( touch_xdir )
        {
            TRAPEZOID(XGRAD, gxtouchf2, pos + pw_gxtouchf2a, 0, TYPNDEF, loggrd);
        }
        if( touch_ydir )
        {
            TRAPEZOID(YGRAD, gytouchf2, pos + pw_gytouchf2a, 0, TYPNDEF, loggrd);
        }
        if( touch_zdir )
        {
            TRAPEZOID(ZGRAD, gztouchf2, pos + pw_gztouchf2a, 0, TYPNDEF, loggrd);
        }
    }
    else
    {
        if( touch_xdir )
        {
            TRAPEZOID(XGRAD, gxtouchf, pos + pw_gxtouchfa, 0, TYPNDEF, loggrd);
        }
        if( touch_ydir )
        {
            TRAPEZOID(YGRAD, gytouchf, pos + pw_gytouchfa, 0, TYPNDEF, loggrd);
        }
        if( touch_zdir )
        {
            TRAPEZOID(ZGRAD, gztouchf, pos + pw_gztouchfa, 0, TYPNDEF, loggrd);
        }
    }
}
/* End inline from touch.e TouchEncodePg */

@pg TouchRspInit
/* Start inline from touch.e TouchRspInit */
if( touch_flag )
{
    /* set scale factor for 2nd set of MEGs after 180 */
    if(meg_mode == 3)
    {
        meg2_amp = (int)pow(-1.0, M_half_periods + 1);
    }
    else if(meg_mode == 2)
    {
        meg2_amp = 1;
    }
    else if(meg_mode == 1)
    {
        meg2_amp = -1;
    }
    else
    {
        meg2_amp = 0;
    }

    /* ***************************************************************************************************** */
    /* put gradient amplitudes for each motion-encoding direction into arrays to be accessed during the scan */
    /* ***************************************************************************************************** */
    touchxuamp[0] = ia_gxtouchu;
    touchxuamp[1] = touch_gamp2 * ia_gxtouchu;
    touchxdamp[0] = ia_gxtouchd;
    touchxdamp[1] = touch_gamp2 * ia_gxtouchd;
    touchxfamp[0] = ia_gxtouchf;
    touchxfamp[1] = touch_gamp2 * ia_gxtouchf;
    touchyuamp[0] = ia_gytouchu;
    touchyuamp[1] = touch_gamp2 * ia_gytouchu;
    touchydamp[0] = ia_gytouchd;
    touchydamp[1] = touch_gamp2 * ia_gytouchd;
    touchyfamp[0] = ia_gytouchf;
    touchyfamp[1] = touch_gamp2 * ia_gytouchf;
    touchzuamp[0] = ia_gztouchu;
    touchzuamp[1] = touch_gamp2 * ia_gztouchu;
    touchzdamp[0] = ia_gztouchd;
    touchzdamp[1] = touch_gamp2 * ia_gztouchd;
    touchzfamp[0] = ia_gztouchf;
    touchzfamp[1] = touch_gamp2 * ia_gztouchf;
    /* MEGs after RF2 */
    touchxuamp2[0] = meg2_amp * ia_gxtouchu2;
    touchxuamp2[1] = meg2_amp * touch_gamp2 * ia_gxtouchu2;
    touchxdamp2[0] = meg2_amp * ia_gxtouchd2;
    touchxdamp2[1] = meg2_amp * touch_gamp2 * ia_gxtouchd2;
    touchxfamp2[0] = meg2_amp * ia_gxtouchf2;
    touchxfamp2[1] = meg2_amp * touch_gamp2 * ia_gxtouchf2;
    touchyuamp2[0] = meg2_amp * ia_gytouchu2;
    touchyuamp2[1] = meg2_amp * touch_gamp2 * ia_gytouchu2;
    touchydamp2[0] = meg2_amp * ia_gytouchd2;
    touchydamp2[1] = meg2_amp * touch_gamp2 * ia_gytouchd2;
    touchyfamp2[0] = meg2_amp * ia_gytouchf2;
    touchyfamp2[1] = meg2_amp * touch_gamp2 * ia_gytouchf2;
    touchzuamp2[0] = meg2_amp * ia_gztouchu2;
    touchzuamp2[1] = meg2_amp * touch_gamp2 * ia_gztouchu2;
    touchzdamp2[0] = meg2_amp * ia_gztouchd2;
    touchzdamp2[1] = meg2_amp * touch_gamp2 * ia_gztouchd2;
    touchzfamp2[0] = meg2_amp * ia_gztouchf2;
    touchzfamp2[1] = meg2_amp * touch_gamp2 * ia_gztouchf2;

    SetTouchAmp(0);
} /* ends if (touch_flag) { */
/* End inline from touch.e TouchRspInit */

@pg TouchPgInit
/* Start inline from touch.e TouchPgInit */
STATUS SetTouchAmpUd( int dir )
{

    if( dir >= MAX_NUM_TOUCH_MOTION_DIRS )
    {
        return FAILURE;
    }
    else
    {
        if( touch_gnum > 0 )
        {
            if( touch_xdir )
            {
                setiampt((int)touchxuamp[dir], &gxtouchu, INSTRALL);
            }
            if( touch_ydir )
            {
                setiampt((int)touchyuamp[dir], &gytouchu, INSTRALL);
            }
            if( touch_zdir )
            {
                setiampt((int)touchzuamp[dir], &gztouchu, INSTRALL);
            }
            if( touch_gnum > 0.5 )
            {
                if( touch_xdir )
                {
                    setiampt((int)touchxdamp[dir], &gxtouchd, INSTRALL);
                }
                if( touch_ydir )
                {
                    setiampt((int)touchydamp[dir], &gytouchd, INSTRALL);
                }
                if( touch_zdir )
                {
                    setiampt((int)touchzdamp[dir], &gztouchd, INSTRALL);
                }
            }
            if( meg_mode >= 1 )
            {
                if( touch_xdir )
                {
                    setiampt((int)touchxuamp2[dir], &gxtouchu2, INSTRALL);
                }
                if( touch_ydir )
                {
                    setiampt((int)touchyuamp2[dir], &gytouchu2, INSTRALL);
                }
                if( touch_zdir )
                {
                    setiampt((int)touchzuamp2[dir], &gztouchu2, INSTRALL);
                }
                if( touch_gnum > 0.5 )
                {
                    if( touch_xdir )
                    {
                        setiampt((int)touchxdamp2[dir], &gxtouchd2, INSTRALL);
                    }
                    if( touch_ydir )
                    {
                        setiampt((int)touchydamp2[dir], &gytouchd2, INSTRALL);
                    }
                    if( touch_zdir )
                    {
                        setiampt((int)touchzdamp2[dir], &gztouchd2, INSTRALL);
                    }
                }
            }
        }
        return SUCCESS;
    }
}

STATUS SetTouchAmpUdf( int dir )
{

    if( dir >= MAX_NUM_TOUCH_MOTION_DIRS )
    {
        return FAILURE;
    }
    else
    {
        if( touch_gnum > 0 )
        {
            if( touch_gnum > 1 )
            {
                if( touch_xdir )
                    setiampt((int)touchxuamp[dir], &gxtouchu, INSTRALL);
                if( touch_ydir )
                    setiampt((int)touchyuamp[dir], &gytouchu, INSTRALL);
                if( touch_zdir )
                    setiampt((int)touchzuamp[dir], &gztouchu, INSTRALL);
            }
            if( touch_xdir )
                setiampt((int)touchxdamp[dir], &gxtouchd, INSTRALL);
            if( touch_ydir )
                setiampt((int)touchydamp[dir], &gytouchd, INSTRALL);
            if( touch_zdir )
                setiampt((int)touchzdamp[dir], &gztouchd, INSTRALL);
            if( touch_xdir )
                setiampt((int)touchxfamp[dir], &gxtouchf, INSTRALL);
            if( touch_ydir )
                setiampt((int)touchyfamp[dir], &gytouchf, INSTRALL);
            if( touch_zdir )
                setiampt((int)touchzfamp[dir], &gztouchf, INSTRALL);
            if( meg_mode >= 1 )
            {
                if( touch_gnum > 1 )
                {
                    if( touch_xdir )
                        setiampt((int)touchxuamp2[dir], &gxtouchu2, INSTRALL);
                    if( touch_ydir )
                        setiampt((int)touchyuamp2[dir], &gytouchu2, INSTRALL);
                    if( touch_zdir )
                        setiampt((int)touchzuamp2[dir], &gztouchu2, INSTRALL);
                }
                if( touch_xdir )
                    setiampt((int)touchxdamp2[dir], &gxtouchd2, INSTRALL);
                if( touch_ydir )
                    setiampt((int)touchydamp2[dir], &gytouchd2, INSTRALL);
                if( touch_zdir )
                    setiampt((int)touchzdamp2[dir], &gztouchd2, INSTRALL);
                if( touch_xdir )
                    setiampt((int)touchxfamp2[dir], &gxtouchf2, INSTRALL);
                if( touch_ydir )
                    setiampt((int)touchyfamp2[dir], &gytouchf2, INSTRALL);
                if( touch_zdir )
                    setiampt((int)touchzfamp2[dir], &gztouchf2, INSTRALL);
            }
        }
        return SUCCESS;
    }
}

void SetTouchAmp( int dir )
{
    if( touch_flag && (touch_gnum > 0) )
    {
        if( touch_fcomp )
        {
            SetTouchAmpUdf(dir);
        }
        else
        {
            SetTouchAmpUd(dir);
        }
    }
}
/* End inline from touch.e TouchPgInit */

@rsp TouchRsp
/* Start inline from touch.e TouchRsp */

void SlideTouchTrig( void )
{
    int slide, i;

    /* ************************************************** */
    /* move the trigger pulse from one offset to the next */
    /* ************************************************** */
    slide = (opacqo == 0) ? pass_rep : pass % multi_phases;
    for( i = 0; i < multi_phases; i++ )
    {
        setwave(wave_trigoff, &sync_on_2, i);
    }
    if( rspent != L_REF )
    {
        if( slide < multi_phases )
        {
            setwave(wave_trigon, &sync_on_2, slide);
        }
    }
}

void NullTouchAmp( void )
{

    if( touch_gnum > 0 )
    {
        if( touch_xdir )
        {
            if( touch_fcomp )
            {
                setiampt(0, &gxtouchf, INSTRALL);
                if( touch_gnum > 1 )
                    setiampt(0, &gxtouchu, INSTRALL);
            }
            else
            {
                setiampt(0, &gxtouchu, INSTRALL);
            }
            if( touch_gnum > 0.5 )
            {
                setiampt(0, &gxtouchd, INSTRALL);
            }
        }
        if( touch_ydir )
        {
            if( touch_fcomp )
            {
                setiampt(0, &gytouchf, INSTRALL);
                if( touch_gnum > 1 )
                    setiampt(0, &gytouchu, INSTRALL);
            }
            else
            {
                setiampt(0, &gytouchu, INSTRALL);
            }
            if( touch_gnum > 0.5 )
            {
                setiampt(0, &gytouchd, INSTRALL);
            }
        }
        if( touch_zdir )
        {
            if( touch_fcomp )
            {
                setiampt(0, &gztouchf, INSTRALL);
                if( touch_gnum > 1 )
                    setiampt(0, &gztouchu, INSTRALL);
            }
            else
            {
                setiampt(0, &gztouchu, INSTRALL);
            }
            if( touch_gnum > 0.5 )
            {
                setiampt(0, &gztouchd, INSTRALL);
            }
        }
    } /* ends if (touch_gnum > 0) */
    /* MEGs after RF2 */
    if( meg_mode > 0 )
    {
        if( touch_gnum > 0 )
        {
            if( touch_xdir )
            {
                if( touch_fcomp )
                {
                    setiampt(0, &gxtouchf2, INSTRALL);
                    if( touch_gnum > 1 )
                        setiampt(0, &gxtouchu2, INSTRALL);
                }
                else
                {
                    setiampt(0, &gxtouchu2, INSTRALL);
                }
                if( touch_gnum > 0.5 )
                {
                    setiampt(0, &gxtouchd2, INSTRALL);
                }
            }
            if( touch_ydir )
            {
                if( touch_fcomp )
                {
                    setiampt(0, &gytouchf2, INSTRALL);
                    if( touch_gnum > 1 )
                        setiampt(0, &gytouchu2, INSTRALL);
                }
                else
                {
                    setiampt(0, &gytouchu2, INSTRALL);
                }
                if( touch_gnum > 0.5 )
                {
                    setiampt(0, &gytouchd2, INSTRALL);
                }
            }
            if( touch_zdir )
            {
                if( touch_fcomp )
                {
                    setiampt(0, &gztouchf2, INSTRALL);
                    if( touch_gnum > 1 )
                        setiampt(0, &gztouchu2, INSTRALL);
                }
                else
                {
                    setiampt(0, &gztouchu2, INSTRALL);
                }
                if( touch_gnum > 0.5 )
                {
                    setiampt(0, &gztouchd2, INSTRALL);
                }
            }
        }
    }
}
/* End inline from touch.e TouchRsp */
