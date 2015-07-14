/*
 * touch.h
 *
 * Copyright (c) 2010 by General Electric Company. All Rights Reserved.
 */

/**
 * \file touch.h
 * MR-Touch EPIC inline function prototypes
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
 * Original implementation.
 *
 */

#ifndef touch_h
#define touch_h

/* Host functions */
void calc_menc(float *menc_factor);

/* Target functions */
void AddEncodeUp(int pos, int meg_set);
void AddEncodeDown(int pos, int meg_set);
void AddEncodeFcomp(int pos, int meg_set);

STATUS SetTouchAmpUd(int dir);
STATUS SetTouchAmpUdf(int dir);
void SetTouchAmp(int dir);

void SlideTouchTrig(void);
void NullTouchAmp(void);

#endif /* touch_h */
