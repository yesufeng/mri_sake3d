/*
 *  EFFSLICESELZ_SPSP_JWG
 *  
 *  Type: Macro
 *  
 *  Description:
 *    This macro is based on EFFSLICESELZ and allows the user to
 *    create an EchoTrain on the Host side using a sequence of
 *    trapezoids.  On the TGT side, it will read an external file.
 *
 *  JWG: I modified this macro to do two things:
 *     1.) Create a waveform generator cv for the OMEGA pulse
 *     2.) Force the pulse to play out on wg_omega, rather than playout out on
 *         THETA or OMEGA depending on the RHO board.
 */
EFFSLICESELZ_SPSP_JWG( slsel_name, slsel_pos, slsel_dur, slsel_thk, slsel_flip,
                   slsel_cycles:1.0,slsel_usegrad:1, res_gz,extern_grad_file,
                   slsel_userf:1, res_rf, extern_rf_file, slsel_usetheta:0,
                   slsel_define:1, slsel_loggrd, slsel_tune:0 )
{
cv:{
    float a_gz$[slsel_name];
    int ia_gz$[slsel_name];
    int pw_gz$[slsel_name]a;
    int pw_gz$[slsel_name]d;
    int pw_gz$[slsel_name];
    int res_gz$[slsel_name];
    float a_$[slsel_name];
    int ia_$[slsel_name];
    int pw_$[slsel_name];
    int res_$[slsel_name];
    float cyc_$[slsel_name];
    int off_$[slsel_name] = 0;
    float alpha_$[slsel_name] = 0.46;
    float thk_$[slsel_name];
    float gscale_$[slsel_name] = 1.0;
    float flip_$[slsel_name];
    float a_theta$[slsel_name];
    int ia_theta$[slsel_name];
    int pw_theta$[slsel_name];
    int res_theta$[slsel_name];
    int off_theta$[slsel_name] = 0;
    int wg_$[slsel_name] = TYPRHO1 with {0, WF_MAX_PROCESSORS*2-1,
                                             TYPRHO1, VIS, , };
    int wg_omega$[slsel_name] = TYPOMEGA;
}
insert: cvinit =>{
    flip_$[slsel_name] = $[slsel_flip];
    a_$[slsel_name] = flip_$[slsel_name]/180;
    pw_gz$[slsel_name] = $[slsel_dur];
    res_gz$[slsel_name] = $[res_gz];
    res_$[slsel_name] = $[res_rf];
    pw_$[slsel_name] = $[slsel_dur];
    cyc_$[slsel_name] = $[slsel_cycles];
    thk_$[slsel_name] = $[slsel_thk];
    a_theta$[slsel_name] = 0;
    res_theta$[slsel_name] = $[res_gz];
    pw_theta$[slsel_name] = $[slsel_dur];
    wg_$[slsel_name] = TYPRHO1;
}
insert: predownload => {

    if (optramp( &pw_gz$[slsel_name]a,a_gz$[slsel_name],
                 $[slsel_loggrd].tz, $[slsel_loggrd].zrt, 
                 $[slsel_define] ) == FAILURE) {
        return FAILURE;
    }

    if (optramp( &pw_gz$[slsel_name]d,a_gz$[slsel_name],
                 $[slsel_loggrd].tz, $[slsel_loggrd].zft, 
                 $[slsel_define] ) == FAILURE) {
        return FAILURE;
    }

    ia_gz$[slsel_name] = a_gz$[slsel_name] * max_pg_iamp / $[slsel_loggrd].tz;

    ia_$[slsel_name] = a_$[slsel_name] * max_pg_iamp;

    ia_theta$[slsel_name] = a_theta$[slsel_name] * max_pg_iamp / $[slsel_loggrd].tz ;

}

var:{
    EXTERN_FILENAME2 grad_z$[slsel_name];
    EXTERN_FILENAME2 rf_$[slsel_name] ;
    EXTERN_FILENAME2 theta_$[slsel_name];
    WF_PULSE gz$[slsel_name]a = INITPULSE;
    WF_PULSE gz$[slsel_name]  = INITPULSE;
    WF_PULSE gz$[slsel_name]d = INITPULSE;
    WF_PULSE $[slsel_name] = INITPULSE;
    WF_PULSE theta$[slsel_name]  = INITPULSE;
}

subst:{
  {
      /* Check for RF waveform generator */
      RFEnvelopeWaveformGeneratorCheck("$[slsel_name]", 
                                       (WF_PROCESSOR)wg_$[slsel_name]);

      /* Select proper filename */
      grad_z$[slsel_name]=  $[extern_grad_file];
      rf_$[slsel_name] =  $[extern_rf_file];
      theta_$[slsel_name] = $[extern_grad_file];

      /* Now create the pulses */
      pulsename(&gz$[slsel_name]a,"gz$[slsel_name]a");
      pulsename(&gz$[slsel_name],"gz$[slsel_name]");
      pulsename(&gz$[slsel_name]d,"gz$[slsel_name]d");
      pulsename(&$[slsel_name],"$[slsel_name]");
      pulsename(&theta$[slsel_name], "theta$[slsel_name]");

      /*  Now create the slice select trapezoid */
      pg_beta = $[slsel_loggrd].zbeta;

      if ( $[slsel_usegrad] == PLAY_GFILE) {

#if defined(IPG_TGT) || defined(MGD_TGT)
          /* Use external gradient file for now */
          createextwave( &gz$[slsel_name], ZGRAD, res_gz$[slsel_name],
                         grad_z$[slsel_name] );

          createinstr( &gz$[slsel_name], (long)$[slsel_pos],
                       pw_gz$[slsel_name], ia_gz$[slsel_name] );

#elif defined(HOST_TGT)
          /* Create train of trapezoids on the Host side */
          int i;
          int polarity = 1;
       
          pulsepos = $[slsel_pos]; 
       
          for(i = 1; i <= num_rf1lobe; i++) {
              polarity *= -1;

              trapezoid( ZGRAD,"gz$[slsel_name]", &gz$[slsel_name], 
                         &gz$[slsel_name]a, &gz$[slsel_name]d,
                         pw_constant, pw_ss_rampz, pw_ss_rampz, 
                         (polarity*(ia_gz$[slsel_name])),
                         (polarity*(ia_gz$[slsel_name])),
                         (polarity*(ia_gz$[slsel_name])), 0, 0, 
                         pulsepos, TRAP_ALL, &$[slsel_loggrd] );

              pulsepos += pw_constant + 2 * pw_ss_rampz;
          }
#endif

      } else {

          /* Create simple trapezoid for chem sat + rf */
          createramp( &gz$[slsel_name]a,ZGRAD,pw_gz$[slsel_name]a,
                      (short)0, max_pg_wamp,
                      (short)(maxGradRes *
                              (pw_gz$[slsel_name]a / GRAD_UPDATE_TIME)),
                      pg_beta );

          createinstr( &gz$[slsel_name]a,
                       (long)($[slsel_pos] - pw_gz$[slsel_name]a),
                       pw_gz$[slsel_name]a, ia_gz$[slsel_name] );

          createconst( &gz$[slsel_name], ZGRAD, pw_$[slsel_name], max_pg_wamp );
          createinstr( &gz$[slsel_name], (long)$[slsel_pos],
                       pw_gz$[slsel_name], ia_gz$[slsel_name] );

          createramp( &gz$[slsel_name]d, ZGRAD, pw_gz$[slsel_name]d,
                      max_pg_wamp, (short)0,
                      (short)(maxGradRes *
                              (pw_gz$[slsel_name]d / GRAD_UPDATE_TIME)),
                      pg_beta );
          createinstr( &gz$[slsel_name]d,
                       (long)($[slsel_pos] + pw_gz$[slsel_name]),
                       pw_gz$[slsel_name]d, ia_gz$[slsel_name] );

      }

      /* Now create the rf pulse */
      if ( $[slsel_userf] == PLAY_RFFILE) {
          createextwave( &$[slsel_name], (WF_PROCESSOR)wg_$[slsel_name], res_$[slsel_name],
                         rf_$[slsel_name]);
      } else {
          createsinc( &$[slsel_name], (WF_PROCESSOR)wg_$[slsel_name], res_$[slsel_name],
                      max_pg_wamp,cyc_$[slsel_name], alpha_$[slsel_name] );
      }

      createinstr( &$[slsel_name],(long)$[slsel_pos] + psd_rf_wait +
                   $[slsel_tune],  pw_$[slsel_name],ia_$[slsel_name]);

      addrfbits( &$[slsel_name], off_$[slsel_name], (long)$[slsel_pos] +
                 psd_rf_wait + $[slsel_tune], pw_$[slsel_name] );

      /* Now create the theta pulse */
      if ( $[slsel_usetheta] == PLAY_THETA) {
          /*jwg force theta pulse on OMEGA*/
          /*createextwave( &theta$[slsel_name], (wg_$[slsel_name]==TYPRHO1)?TYPOMEGA:TYPTHETA,
                         res_theta$[slsel_name], theta_$[slsel_name] );	  */
          createextwave( &theta$[slsel_name], wg_omega$[slsel_name],
                         res_theta$[slsel_name], theta_$[slsel_name] );

          createinstr( &theta$[slsel_name], (long)$[slsel_pos] + psd_rf_wait +
                       $[slsel_tune], pw_theta$[slsel_name],
                       ia_theta$[slsel_name] );

          addrfbits( &theta$[slsel_name], off_theta$[slsel_name],
                     (long)$[slsel_pos] + psd_rf_wait + $[slsel_tune],
                     pw_theta$[slsel_name] );
      }
      if ( $[slsel_usegrad] == PLAY_GFILE) {
          #if defined(IPG_TGT) || defined(MGD_TGT)
          linkpulses( 3,
                      &$[slsel_name], &gz$[slsel_name], &theta$[slsel_name]);
          #endif
      } else {
          linkpulses( 4,
                      &$[slsel_name], &gz$[slsel_name],
                      &gz$[slsel_name]a, &gz$[slsel_name]d);
      }
  }
}
}
