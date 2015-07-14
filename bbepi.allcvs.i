extern char psd_name[255];
typedef int ptrdiff_t;
typedef unsigned int size_t;
typedef int wchar_t;
typedef signed char int8_t;
typedef short int int16_t;
typedef int int32_t;
__extension__
typedef long long int int64_t;
typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
__extension__
typedef unsigned long long int uint64_t;
typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef int int_least32_t;
__extension__
typedef long long int int_least64_t;
typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned int uint_least32_t;
__extension__
typedef unsigned long long int uint_least64_t;
typedef signed char int_fast8_t;
typedef int int_fast16_t;
typedef int int_fast32_t;
__extension__
typedef long long int int_fast64_t;
typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
__extension__
typedef unsigned long long int uint_fast64_t;
typedef int intptr_t;
typedef unsigned int uintptr_t;
__extension__
typedef long long int intmax_t;
__extension__
typedef unsigned long long int uintmax_t;

typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;
__extension__ typedef signed long long int __int64_t;
__extension__ typedef unsigned long long int __uint64_t;




__extension__ typedef long long int __quad_t;
__extension__ typedef unsigned long long int __u_quad_t;
__extension__ typedef __u_quad_t __dev_t;
__extension__ typedef unsigned int __uid_t;
__extension__ typedef unsigned int __gid_t;
__extension__ typedef unsigned long int __ino_t;
__extension__ typedef __u_quad_t __ino64_t;
__extension__ typedef unsigned int __mode_t;
__extension__ typedef unsigned int __nlink_t;
__extension__ typedef long int __off_t;
__extension__ typedef __quad_t __off64_t;
__extension__ typedef int __pid_t;
__extension__ typedef struct { int __val[2]; } __fsid_t;
__extension__ typedef long int __clock_t;
__extension__ typedef unsigned long int __rlim_t;
__extension__ typedef __u_quad_t __rlim64_t;
__extension__ typedef unsigned int __id_t;
__extension__ typedef long int __time_t;
__extension__ typedef unsigned int __useconds_t;
__extension__ typedef long int __suseconds_t;
__extension__ typedef int __daddr_t;
__extension__ typedef long int __swblk_t;
__extension__ typedef int __key_t;
__extension__ typedef int __clockid_t;
__extension__ typedef void * __timer_t;
__extension__ typedef long int __blksize_t;
__extension__ typedef long int __blkcnt_t;
__extension__ typedef __quad_t __blkcnt64_t;
__extension__ typedef unsigned long int __fsblkcnt_t;
__extension__ typedef __u_quad_t __fsblkcnt64_t;
__extension__ typedef unsigned long int __fsfilcnt_t;
__extension__ typedef __u_quad_t __fsfilcnt64_t;
__extension__ typedef int __ssize_t;
typedef __off64_t __loff_t;
typedef __quad_t *__qaddr_t;
typedef char *__caddr_t;
__extension__ typedef int __intptr_t;
__extension__ typedef unsigned int __socklen_t;
typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;
typedef __loff_t loff_t;
typedef __ino_t ino_t;
typedef __dev_t dev_t;
typedef __gid_t gid_t;
typedef __mode_t mode_t;
typedef __nlink_t nlink_t;
typedef __uid_t uid_t;
typedef __off_t off_t;
typedef __pid_t pid_t;
typedef __id_t id_t;
typedef __ssize_t ssize_t;




typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;





typedef __key_t key_t;

typedef __time_t time_t;


typedef __clockid_t clockid_t;
typedef __timer_t timer_t;
typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;
typedef unsigned int u_int8_t __attribute__ ((__mode__ (__QI__)));
typedef unsigned int u_int16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int u_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int u_int64_t __attribute__ ((__mode__ (__DI__)));
typedef int register_t __attribute__ ((__mode__ (__word__)));
typedef int __sig_atomic_t;
typedef struct
  {
    unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
  } __sigset_t;
typedef __sigset_t sigset_t;
struct timespec
  {
    __time_t tv_sec;
    long int tv_nsec;
  };
struct timeval
  {
    __time_t tv_sec;
    __suseconds_t tv_usec;
  };
typedef __suseconds_t suseconds_t;
typedef long int __fd_mask;
typedef struct
  {
    __fd_mask __fds_bits[1024 / (8 * sizeof (__fd_mask))];
  } fd_set;
typedef __fd_mask fd_mask;

extern int select (int __nfds, fd_set *__restrict __readfds,
     fd_set *__restrict __writefds,
     fd_set *__restrict __exceptfds,
     struct timeval *__restrict __timeout);
extern int pselect (int __nfds, fd_set *__restrict __readfds,
      fd_set *__restrict __writefds,
      fd_set *__restrict __exceptfds,
      const struct timespec *__restrict __timeout,
      const __sigset_t *__restrict __sigmask);

__extension__
extern unsigned int gnu_dev_major (unsigned long long int __dev)
     __attribute__ ((__nothrow__));
__extension__
extern unsigned int gnu_dev_minor (unsigned long long int __dev)
     __attribute__ ((__nothrow__));
__extension__
extern unsigned long long int gnu_dev_makedev (unsigned int __major,
            unsigned int __minor)
     __attribute__ ((__nothrow__));
typedef __blkcnt_t blkcnt_t;
typedef __fsblkcnt_t fsblkcnt_t;
typedef __fsfilcnt_t fsfilcnt_t;
typedef unsigned long int pthread_t;
typedef union
{
  char __size[36];
  long int __align;
} pthread_attr_t;
typedef struct __pthread_internal_slist
{
  struct __pthread_internal_slist *__next;
} __pthread_slist_t;
typedef union
{
  struct __pthread_mutex_s
  {
    int __lock;
    unsigned int __count;
    int __owner;
    int __kind;
    unsigned int __nusers;
    __extension__ union
    {
      int __spins;
      __pthread_slist_t __list;
    } __spins_union;
  } __data;
  char __size[24];
  long int __align;
} pthread_mutex_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_mutexattr_t;
typedef union
{
  struct
  {
    int __lock;
    unsigned int __futex;
    __extension__ unsigned long long int __total_seq;
    __extension__ unsigned long long int __wakeup_seq;
    __extension__ unsigned long long int __woken_seq;
    void *__mutex;
    unsigned int __nwaiters;
    unsigned int __broadcast_seq;
  } __data;
  char __size[48];
  __extension__ long long int __align;
} pthread_cond_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_condattr_t;
typedef unsigned int pthread_key_t;
typedef int pthread_once_t;
typedef union
{
  struct
  {
    int __lock;
    unsigned int __nr_readers;
    unsigned int __readers_wakeup;
    unsigned int __writer_wakeup;
    unsigned int __nr_readers_queued;
    unsigned int __nr_writers_queued;
    unsigned char __flags;
    unsigned char __shared;
    unsigned char __pad1;
    unsigned char __pad2;
    int __writer;
  } __data;
  char __size[32];
  long int __align;
} pthread_rwlock_t;
typedef union
{
  char __size[8];
  long int __align;
} pthread_rwlockattr_t;
typedef volatile int pthread_spinlock_t;
typedef union
{
  char __size[20];
  long int __align;
} pthread_barrier_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_barrierattr_t;

typedef char s8;
typedef unsigned char n8;
typedef int16_t s16;
typedef u_int16_t n16;
typedef long s32;
typedef unsigned long n32;
typedef int64_t s64;
typedef uint64_t n64;
typedef float f32;
typedef double f64;
struct EXT_CERD_PARAMS
{
  s32 alg;
  s32 demod;
} ;
typedef struct {
  f64 filfrq;
  struct EXT_CERD_PARAMS cerd;
  s32 taps;
  s32 outputs;
  s32 prefills;
  s32 filter_slot;
} PSD_FILTER_GEN;
enum
{
    COIL_CONNECTOR_A,
    COIL_CONNECTOR_P1,
    COIL_CONNECTOR_P2,
    COIL_CONNECTOR_P3,
    COIL_CONNECTOR_P4,
    COIL_CONNECTOR_P5,
    NUM_COIL_CONNECTORS,
    NUM_COIL_CONNECTORS_PADDED = 8
};
enum
{
    COIL_CONNECTOR_MNS_LEGACY_TOP,
    COIL_CONNECTOR_C_LEGACY_BOTTOM,
    COIL_CONNECTOR_PORT_A,
    COIL_CONNECTOR_PORT_B,
    NUM_COIL_CONNECTORS_PRE_HDV
};
enum
{
    COIL_STATE_UNKNOWN,
    COIL_STATE_DISCONNECTED,
    COIL_STATE_CONNECTED,
    COIL_STATE_ID,
    COIL_STATE_COMPLETE,
    NUM_COIL_STATES
};
enum
{
    COIL_INVALID,
    COIL_VALID,
    NUM_COIL_VALID_VALUES
};
enum
{
    COIL_TYPE_TRANSMIT,
    COIL_TYPE_RECEIVE,
    NUM_COIL_TYPE_VALUES
};
enum
{
    BODY_TRANSMIT_DISABLE,
    BODY_TRANSMIT_ENABLE,
    NUM_BODY_TRANSMIT_ENABLE_VALUES
};
enum
{
    TRANSMIT_SELECT_NONE,
    TRANSMIT_SELECT_A,
    TRANSMIT_SELECT_P1,
    NUM_TRANSMIT_SELECTS
};
enum
{
    MNS_CONVERTER_SELECT_NONE = 0x00000000,
    MNS_CONVERTER_SELECT_A = 0x00000001,
    MNS_CONVERTER_SELECT_MASK = 0x00000001,
};
typedef struct CTTEntry
{
    s8 logicalCoilName[128];
    s8 clinicalCoilName[32];
    n32 configUID;
    s32 coilConnector;
    n32 isActiveScanConfig;
    s16 channelTranslationMap[32];
} ChannelTransTableEntryType;
enum
{
    NORMAL_COIL,
    F000_COIL,
    FG00_COIL,
    P000_COIL,
    PG00_COIL,
    R000_COIL,
    SERV_COIL
};
typedef struct _INSTALL_COIL_INFO_
{
    char coilCode[(32 + 8)];
    int isInCoilDatabase;
}INSTALL_COIL_INFO;
typedef struct _INSTALL_COIL_CONNECTOR_INFO_
{
    int connector;
    int needsInstall;
    INSTALL_COIL_INFO installCoilInfo[4];
}INSTALL_COIL_CONNECTOR_INFO;
typedef struct coil_config_params
{
    char coilName[16];
    char GEcoilName[24];
    short pureCorrection;
    int maxNumOfReceivers;
    int coilType;
    int txCoilType;
    int fastTGmode;
    int fastTGstartTA;
    int fastTGstartRG;
    int nuclide;
    int tRPAvolumeRecEnable;
    int pureCompatible;
    int aps1StartTA;
    int cflStartTA;
    int cfhSensitiveAnatomy;
    float cableLoss;
    float coilLoss;
    float reconScale;
    float autoshimFOV;
    float coilWeights[4][32];
    ChannelTransTableEntryType cttEntry[4];
} COIL_CONFIG_PARAM_TYPE;
typedef struct application_config_param_type
{
    int aps1StartTA;
    int cflStartTA;
    int AScfPatLocChangeRL;
    int AScfPatLocChangeAP;
    int AScfPatLocChangeSI;
    int TGpatLocChangeRL;
    int TGpatLocChangeAP;
    int TGpatLocChangeSI;
    int autoshimFOV;
    int fastTGstartTA;
    int fastTGstartRG;
    int fastTGmode;
    int cfhSensitiveAnatomy;
    int aps1Mod;
    int aps1Plane;
    int pureCompatible;
    int maxFOV;
    int assetThresh;
    int scic_a_used;
    int scic_s_used;
    int scic_c_used;
    float aps1ModFOV;
    float aps1ModPStloc;
    float aps1ModPSrloc;
    float opthickPSMod;
    float pureScale;
    float pureCorrectionThreshold;
    float scic_a[7];
    float scic_s[7];
    float scic_c[7];
} APPLICATION_CONFIG_PARAM_TYPE;
typedef struct application_config_hdr
{
    int error;
    char clinicalName[32];
    APPLICATION_CONFIG_PARAM_TYPE appConfig;
} APPLICATION_CONFIG_HDR;
typedef struct {
    s8 coilName[32];
    s32 txIndexPri;
    s32 txIndexSec;
    n32 rxCoilType;
    n32 hubIndex;
    n32 rxNucleus;
    n32 aps1Mod;
    n32 aps1ModPlane;
    n32 coilSepDir;
    s32 assetCalThreshold;
    f32 aps1ModFov;
    f32 aps1ModSlThick;
    f32 aps1ModPsTloc;
    f32 aps1ModPsRloc;
    f32 autoshimFov;
    f32 assetCalMaxFov;
    f32 maxB1Rms;
} COIL_INFO;
typedef struct {
    s32 coilAtten;
    n32 txCoilType;
    n32 txPosition;
    n32 txNucleus;
    n32 txAmp;
    f32 maxB1Peak;
    f32 maxB1Squared;
    f32 cableLoss;
    f32 coilLoss;
    f32 reflCoeffSquared[10];
    f32 reflCoeffMassOffset;
    f32 reflCoeffCurveType;
    f32 exposedMass[8];
    f32 jstd[12];
    f32 meanJstd[12];
    f32 separationStdev;
} TX_COIL_INFO;
typedef struct _psd_coil_info_
{
    COIL_INFO imgRcvCoilInfo[10];
    COIL_INFO volRcvCoilInfo[10];
    TX_COIL_INFO txCoilInfo[5];
    int numCoils;
} PSD_COIL_INFO;
typedef struct {
    int xfull;
    int yfull;
    int zfull;
    float xfs;
    float yfs;
    float zfs;
    int xrt;
    int yrt;
    int zrt;
    int xft;
    int yft;
    int zft;
    float xcc;
    float ycc;
    float zcc;
    float xbeta;
    float ybeta;
    float zbeta;
    float xirms;
    float yirms;
    float zirms;
    float xipeak;
    float yipeak;
    float zipeak;
    float xamptran;
    float yamptran;
    float zamptran;
    float xiavrgabs;
    float yiavrgabs;
    float ziavrgabs;
    float xirmspos;
    float yirmspos;
    float zirmspos;
    float xirmsneg;
    float yirmsneg;
    float zirmsneg;
    float xpwmdc;
    float ypwmdc;
    float zpwmdc;
} PHYS_GRAD;
typedef struct {
    int x;
    int xy;
    int xz;
    int xyz;
} t_xact;
typedef struct {
    int y;
    int xy;
    int yz;
    int xyz;
} t_yact;
typedef struct {
    int z;
    int xz;
    int yz;
    int xyz;
} t_zact;
typedef struct {
    int xrt;
    int yrt;
    int zrt;
    int xft;
    int yft;
    int zft;
} ramp_t;
typedef struct {
    int xrt;
    int yrt;
    int zrt;
    int xft;
    int yft;
    int zft;
    ramp_t opt;
    t_xact xrta;
    t_yact yrta;
    t_zact zrta;
    t_xact xfta;
    t_yact yfta;
    t_zact zfta;
    float xbeta;
    float ybeta;
    float zbeta;
    float tx_xyz;
    float ty_xyz;
    float tz_xyz;
    float tx_xy;
    float tx_xz;
    float ty_xy;
    float ty_yz;
    float tz_xz;
    float tz_yz;
    float tx;
    float ty;
    float tz;
    float xfs;
    float yfs;
    float zfs;
    float xirms;
    float yirms;
    float zirms;
    float xipeak;
    float yipeak;
    float zipeak;
    float xamptran;
    float yamptran;
    float zamptran;
    float xiavrgabs;
    float yiavrgabs;
    float ziavrgabs;
    float xirmspos;
    float yirmspos;
    float zirmspos;
    float xirmsneg;
    float yirmsneg;
    float zirmsneg;
    float xpwmdc;
    float ypwmdc;
    float zpwmdc;
} LOG_GRAD;
typedef struct {
    long abcode;
    char text_string[256];
    char text_arg[16];
    long *longarg[4];
} PSD_EXIT_ARG;
typedef enum GRADIENT_COILS
{
    PSD_55_CM_COIL = 1,
    PSD_60_CM_COIL = 2,
    PSD_TRM_COIL = 3,
    PSD_4_COIL = 4,
    PSD_5_COIL = 5,
    PSD_CRM_COIL = 6,
    PSD_HFO_COIL = 7,
    PSD_XRMB_COIL = 8,
    PSD_OVATION_COIL = 9,
    PSD_10_COIL = 10,
    PSD_XRMW_COIL = 11,
} GRADIENT_COIL_E;
typedef enum PSD_BOARD_TYPE
{
    PSDCERD = 0,
    PSDDVMR,
    NUM_PSD_BOARD_TYPES,
} PSD_BOARD_TYPE_E;
typedef enum VALUE_SYSTEM_TYPE
{
  NON_VALUE_SYSTEM = 0,
  VALUE_SYSTEM_HDE,
  VALUE_SYSTEM_SVEM,
  VALUE_SYSTEM_SVDM,
  VALUE_SYSTEM_SVDMP,
} VALUE_SYSTEM_TYPE_E;
typedef struct {
    float xfs;
    float yfs;
    int xrt;
    int yrt;
    float xbeta;
    float ybeta;
    float xfov;
    float yfov;
    int xres;
    int yres;
    int ileaves;
    float xdis;
    float ydis;
    float tsp;
    int osamps;
    float fbhw;
    int vvp;
    float pnsf;
    float taratio;
} OPT_GRAD_INPUT;
typedef struct {
    float *agxw;
    int *pwgxw;
    int *pwgxwa;
    float *agyb;
    int *pwgyb;
    int *pwgyba;
    int *frsize;
    int *pwsamp;
    int *pwxgap;
} OPT_GRAD_PARAMS;
typedef struct {
  int ptype;
  int *attack;
  int *decay;
  int *pw;
  float *amps;
  float *amp;
  float *ampd;
  float *ampe;
  char *gradfile;
  int num;
  float scale;
  int *time;
  int tdelta;
  float powscale;
  float power;
  float powpos;
  float powneg;
  float powabs;
  float amptran;
  int pwm;
  int bridge;
  float intabspwmcurr;
} GRAD_PULSE;
typedef char EXTERN_FILENAME[80];
typedef char *EXTERN_FILENAME2;
typedef struct {
  int *pw;
  float *amp;
  float abswidth;
  float effwidth;
  float area;
  float dtycyc;
  float maxpw;
  int num;
  float max_b1;
  float max_int_b1_sq;
  float max_rms_b1;
  float nom_fa;
  float *act_fa;
  float nom_pw;
  float nom_bw;
  unsigned int activity;
  unsigned char reference;
  int isodelay;
  float scale;
  int *res;
  int extgradfile;
  int *exciter;
} RF_PULSE;
typedef struct {
  int change;
  int newres;
} RF_PULSE_INFO;
typedef struct {
  short slloc;
  short slpass;
  short sltime;
} DATA_ACQ_ORDER;
typedef struct {
  float optloc;
  float oprloc;
  float opphasoff;
  float oprot[9];
  } SCAN_INFO;
typedef struct {
  float rsptloc;
  float rsprloc;
  float rspphasoff;
  int slloc;
 } RSP_INFO;
typedef struct {
  s16 pmPredictSAR;
  s16 pmContinuousUpdate;
} power_monitor_table_t;
typedef struct {
  s16 pmBodyAveLimit;
  s16 pmTRAveLimit;
  s16 pmExtAveLimit;
  s16 pmCWAveLimit;
  s16 pmBody2Ptnt;
  s16 pmBody2TR;
  s16 pmBody2Ext;
  s16 pmBody2CW;
  s16 pmTR2Ptnt;
  s16 pmTR2TR;
  s16 pmTR2Ext;
  s16 pmTR2CW;
  s16 pmSpect2Ptnt;
  s16 pmSpect2TR;
  s16 pmSpect2Ext;
  s16 pmSpect2CW;
  s16 pmCW2Ptnt;
  s16 pmCW2TR;
  s16 pmCW2Ext;
  s16 pmCW2CW;
} average_mode_dump_t;
typedef struct {
  n32 epmcBiasEnable0;
  n32 epmcBiasEnable1;
  n32 epmcVoltConfig0;
  n32 epmcVoltConfig1;
  n32 epmcOpenCktConfig0;
  n32 epmcOpenCktConfig1;
  n32 epmcOpenCktConfig2;
  n32 epmcOpenCktConfig3;
  n32 epmcShortCktConfig0;
  n32 epmcShortCktConfig1;
  n32 epmcShortCktConfig2;
  n32 epmcShortCktConfig3;
  n32 epmcActiveConnectors;
  s8 epcoilCfgName[(24 + 1 + 3)];
} coil_info_table_t;
typedef struct{
  s8 epname[16];
  n32 epamph;
  n32 epampb;
  n32 epamps;
  n32 epampc;
  n32 epwidthh;
  n32 epwidthb;
  n32 epwidths;
  n32 epwidthc;
  n32 epdcycleh;
  n32 epdcycleb;
  n32 epdcycles;
  n32 epdcyclec;
  n8 epsmode;
  n8 epfilter;
  n8 eprcvrband;
  n8 eprcvrinput;
  n8 eprcvrbias;
  n8 eptrdriver;
  n8 epfastrec;
  s16 epxmtadd;
  s16 epprexres;
  s16 epshldctrl;
  s16 epgradcoil;
  n32 eppkpower;
  n32 epseqtime;
  s16 epstartrec;
  s16 ependrec;
  power_monitor_table_t eppmtable;
  n8 epGeneralBankIndex;
  n8 epR1BankIndex;
  n8 epNbTransmitSelect;
  n8 epBbTransmitSelect;
  n32 epMnsConverterSelect;
  n32 epRxCoilType;
  f32 epxgd_cableirmsmax;
  f32 epcoilAC_powersum;
} entry_point_table_t;
typedef entry_point_table_t ENTRY_POINT_TABLE;
typedef entry_point_table_t ENTRY_PNT_TABLE;
typedef coil_info_table_t COIL_ID_INFO;
typedef struct {
  float decimation;
  int tdaq;
  float bw;
  float tsp;
  int fslot;
  int outputs;
  int prefills;
  int taps;
  } FILTER_INFO;
typedef struct {
    int ysign;
    int yoffs;
} PHASE_OFF;
typedef struct {
  float oppsctloc;
  float oppscrloc;
  float oppscphasoff;
  float oppscrot[9];
  int oppsclenx;
  int oppscleny;
  int oppsclenz;
 } PSC_INFO;
typedef struct {
  float rsppsctloc;
  float rsppscrloc;
  float rsppscphasoff;
  long rsppscrot[10];
  int rsppsclenx;
  int rsppscleny;
  int rsppsclenz;
 } RSP_PSC_INFO;
typedef struct {
    float opgirthick;
    float opgirtloc;
    float opgirrot[9];
} GIR_INFO;


extern double acos (double __x) __attribute__ ((__nothrow__)); extern double __acos (double __x) __attribute__ ((__nothrow__));
extern double asin (double __x) __attribute__ ((__nothrow__)); extern double __asin (double __x) __attribute__ ((__nothrow__));
extern double atan (double __x) __attribute__ ((__nothrow__)); extern double __atan (double __x) __attribute__ ((__nothrow__));
extern double atan2 (double __y, double __x) __attribute__ ((__nothrow__)); extern double __atan2 (double __y, double __x) __attribute__ ((__nothrow__));
extern double cos (double __x) __attribute__ ((__nothrow__)); extern double __cos (double __x) __attribute__ ((__nothrow__));
extern double sin (double __x) __attribute__ ((__nothrow__)); extern double __sin (double __x) __attribute__ ((__nothrow__));
extern double tan (double __x) __attribute__ ((__nothrow__)); extern double __tan (double __x) __attribute__ ((__nothrow__));
extern double cosh (double __x) __attribute__ ((__nothrow__)); extern double __cosh (double __x) __attribute__ ((__nothrow__));
extern double sinh (double __x) __attribute__ ((__nothrow__)); extern double __sinh (double __x) __attribute__ ((__nothrow__));
extern double tanh (double __x) __attribute__ ((__nothrow__)); extern double __tanh (double __x) __attribute__ ((__nothrow__));


extern double acosh (double __x) __attribute__ ((__nothrow__)); extern double __acosh (double __x) __attribute__ ((__nothrow__));
extern double asinh (double __x) __attribute__ ((__nothrow__)); extern double __asinh (double __x) __attribute__ ((__nothrow__));
extern double atanh (double __x) __attribute__ ((__nothrow__)); extern double __atanh (double __x) __attribute__ ((__nothrow__));


extern double exp (double __x) __attribute__ ((__nothrow__)); extern double __exp (double __x) __attribute__ ((__nothrow__));
extern double frexp (double __x, int *__exponent) __attribute__ ((__nothrow__)); extern double __frexp (double __x, int *__exponent) __attribute__ ((__nothrow__));
extern double ldexp (double __x, int __exponent) __attribute__ ((__nothrow__)); extern double __ldexp (double __x, int __exponent) __attribute__ ((__nothrow__));
extern double log (double __x) __attribute__ ((__nothrow__)); extern double __log (double __x) __attribute__ ((__nothrow__));
extern double log10 (double __x) __attribute__ ((__nothrow__)); extern double __log10 (double __x) __attribute__ ((__nothrow__));
extern double modf (double __x, double *__iptr) __attribute__ ((__nothrow__)); extern double __modf (double __x, double *__iptr) __attribute__ ((__nothrow__));


extern double expm1 (double __x) __attribute__ ((__nothrow__)); extern double __expm1 (double __x) __attribute__ ((__nothrow__));
extern double log1p (double __x) __attribute__ ((__nothrow__)); extern double __log1p (double __x) __attribute__ ((__nothrow__));
extern double logb (double __x) __attribute__ ((__nothrow__)); extern double __logb (double __x) __attribute__ ((__nothrow__));


extern double pow (double __x, double __y) __attribute__ ((__nothrow__)); extern double __pow (double __x, double __y) __attribute__ ((__nothrow__));
extern double sqrt (double __x) __attribute__ ((__nothrow__)); extern double __sqrt (double __x) __attribute__ ((__nothrow__));


extern double hypot (double __x, double __y) __attribute__ ((__nothrow__)); extern double __hypot (double __x, double __y) __attribute__ ((__nothrow__));


extern double cbrt (double __x) __attribute__ ((__nothrow__)); extern double __cbrt (double __x) __attribute__ ((__nothrow__));


extern double ceil (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __ceil (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double fabs (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __fabs (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double floor (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __floor (double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double fmod (double __x, double __y) __attribute__ ((__nothrow__)); extern double __fmod (double __x, double __y) __attribute__ ((__nothrow__));
extern int __isinf (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int __finite (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int isinf (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int finite (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double drem (double __x, double __y) __attribute__ ((__nothrow__)); extern double __drem (double __x, double __y) __attribute__ ((__nothrow__));
extern double significand (double __x) __attribute__ ((__nothrow__)); extern double __significand (double __x) __attribute__ ((__nothrow__));

extern double copysign (double __x, double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __copysign (double __x, double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int __isnan (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int isnan (double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double j0 (double) __attribute__ ((__nothrow__)); extern double __j0 (double) __attribute__ ((__nothrow__));
extern double j1 (double) __attribute__ ((__nothrow__)); extern double __j1 (double) __attribute__ ((__nothrow__));
extern double jn (int, double) __attribute__ ((__nothrow__)); extern double __jn (int, double) __attribute__ ((__nothrow__));
extern double y0 (double) __attribute__ ((__nothrow__)); extern double __y0 (double) __attribute__ ((__nothrow__));
extern double y1 (double) __attribute__ ((__nothrow__)); extern double __y1 (double) __attribute__ ((__nothrow__));
extern double yn (int, double) __attribute__ ((__nothrow__)); extern double __yn (int, double) __attribute__ ((__nothrow__));

extern double erf (double) __attribute__ ((__nothrow__)); extern double __erf (double) __attribute__ ((__nothrow__));
extern double erfc (double) __attribute__ ((__nothrow__)); extern double __erfc (double) __attribute__ ((__nothrow__));
extern double lgamma (double) __attribute__ ((__nothrow__)); extern double __lgamma (double) __attribute__ ((__nothrow__));

extern double gamma (double) __attribute__ ((__nothrow__)); extern double __gamma (double) __attribute__ ((__nothrow__));
extern double lgamma_r (double, int *__signgamp) __attribute__ ((__nothrow__)); extern double __lgamma_r (double, int *__signgamp) __attribute__ ((__nothrow__));

extern double rint (double __x) __attribute__ ((__nothrow__)); extern double __rint (double __x) __attribute__ ((__nothrow__));
extern double nextafter (double __x, double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern double __nextafter (double __x, double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern double remainder (double __x, double __y) __attribute__ ((__nothrow__)); extern double __remainder (double __x, double __y) __attribute__ ((__nothrow__));
extern double scalbn (double __x, int __n) __attribute__ ((__nothrow__)); extern double __scalbn (double __x, int __n) __attribute__ ((__nothrow__));
extern int ilogb (double __x) __attribute__ ((__nothrow__)); extern int __ilogb (double __x) __attribute__ ((__nothrow__));

extern double scalb (double __x, double __n) __attribute__ ((__nothrow__)); extern double __scalb (double __x, double __n) __attribute__ ((__nothrow__));

extern float acosf (float __x) __attribute__ ((__nothrow__)); extern float __acosf (float __x) __attribute__ ((__nothrow__));
extern float asinf (float __x) __attribute__ ((__nothrow__)); extern float __asinf (float __x) __attribute__ ((__nothrow__));
extern float atanf (float __x) __attribute__ ((__nothrow__)); extern float __atanf (float __x) __attribute__ ((__nothrow__));
extern float atan2f (float __y, float __x) __attribute__ ((__nothrow__)); extern float __atan2f (float __y, float __x) __attribute__ ((__nothrow__));
extern float cosf (float __x) __attribute__ ((__nothrow__)); extern float __cosf (float __x) __attribute__ ((__nothrow__));
extern float sinf (float __x) __attribute__ ((__nothrow__)); extern float __sinf (float __x) __attribute__ ((__nothrow__));
extern float tanf (float __x) __attribute__ ((__nothrow__)); extern float __tanf (float __x) __attribute__ ((__nothrow__));
extern float coshf (float __x) __attribute__ ((__nothrow__)); extern float __coshf (float __x) __attribute__ ((__nothrow__));
extern float sinhf (float __x) __attribute__ ((__nothrow__)); extern float __sinhf (float __x) __attribute__ ((__nothrow__));
extern float tanhf (float __x) __attribute__ ((__nothrow__)); extern float __tanhf (float __x) __attribute__ ((__nothrow__));


extern float acoshf (float __x) __attribute__ ((__nothrow__)); extern float __acoshf (float __x) __attribute__ ((__nothrow__));
extern float asinhf (float __x) __attribute__ ((__nothrow__)); extern float __asinhf (float __x) __attribute__ ((__nothrow__));
extern float atanhf (float __x) __attribute__ ((__nothrow__)); extern float __atanhf (float __x) __attribute__ ((__nothrow__));


extern float expf (float __x) __attribute__ ((__nothrow__)); extern float __expf (float __x) __attribute__ ((__nothrow__));
extern float frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__)); extern float __frexpf (float __x, int *__exponent) __attribute__ ((__nothrow__));
extern float ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__)); extern float __ldexpf (float __x, int __exponent) __attribute__ ((__nothrow__));
extern float logf (float __x) __attribute__ ((__nothrow__)); extern float __logf (float __x) __attribute__ ((__nothrow__));
extern float log10f (float __x) __attribute__ ((__nothrow__)); extern float __log10f (float __x) __attribute__ ((__nothrow__));
extern float modff (float __x, float *__iptr) __attribute__ ((__nothrow__)); extern float __modff (float __x, float *__iptr) __attribute__ ((__nothrow__));


extern float expm1f (float __x) __attribute__ ((__nothrow__)); extern float __expm1f (float __x) __attribute__ ((__nothrow__));
extern float log1pf (float __x) __attribute__ ((__nothrow__)); extern float __log1pf (float __x) __attribute__ ((__nothrow__));
extern float logbf (float __x) __attribute__ ((__nothrow__)); extern float __logbf (float __x) __attribute__ ((__nothrow__));


extern float powf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __powf (float __x, float __y) __attribute__ ((__nothrow__));
extern float sqrtf (float __x) __attribute__ ((__nothrow__)); extern float __sqrtf (float __x) __attribute__ ((__nothrow__));


extern float hypotf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __hypotf (float __x, float __y) __attribute__ ((__nothrow__));


extern float cbrtf (float __x) __attribute__ ((__nothrow__)); extern float __cbrtf (float __x) __attribute__ ((__nothrow__));


extern float ceilf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __ceilf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float fabsf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __fabsf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float floorf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __floorf (float __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float fmodf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __fmodf (float __x, float __y) __attribute__ ((__nothrow__));
extern int __isinff (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int __finitef (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int isinff (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int finitef (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float dremf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __dremf (float __x, float __y) __attribute__ ((__nothrow__));
extern float significandf (float __x) __attribute__ ((__nothrow__)); extern float __significandf (float __x) __attribute__ ((__nothrow__));

extern float copysignf (float __x, float __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __copysignf (float __x, float __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int __isnanf (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int isnanf (float __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float j0f (float) __attribute__ ((__nothrow__)); extern float __j0f (float) __attribute__ ((__nothrow__));
extern float j1f (float) __attribute__ ((__nothrow__)); extern float __j1f (float) __attribute__ ((__nothrow__));
extern float jnf (int, float) __attribute__ ((__nothrow__)); extern float __jnf (int, float) __attribute__ ((__nothrow__));
extern float y0f (float) __attribute__ ((__nothrow__)); extern float __y0f (float) __attribute__ ((__nothrow__));
extern float y1f (float) __attribute__ ((__nothrow__)); extern float __y1f (float) __attribute__ ((__nothrow__));
extern float ynf (int, float) __attribute__ ((__nothrow__)); extern float __ynf (int, float) __attribute__ ((__nothrow__));

extern float erff (float) __attribute__ ((__nothrow__)); extern float __erff (float) __attribute__ ((__nothrow__));
extern float erfcf (float) __attribute__ ((__nothrow__)); extern float __erfcf (float) __attribute__ ((__nothrow__));
extern float lgammaf (float) __attribute__ ((__nothrow__)); extern float __lgammaf (float) __attribute__ ((__nothrow__));

extern float gammaf (float) __attribute__ ((__nothrow__)); extern float __gammaf (float) __attribute__ ((__nothrow__));
extern float lgammaf_r (float, int *__signgamp) __attribute__ ((__nothrow__)); extern float __lgammaf_r (float, int *__signgamp) __attribute__ ((__nothrow__));

extern float rintf (float __x) __attribute__ ((__nothrow__)); extern float __rintf (float __x) __attribute__ ((__nothrow__));
extern float nextafterf (float __x, float __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern float __nextafterf (float __x, float __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern float remainderf (float __x, float __y) __attribute__ ((__nothrow__)); extern float __remainderf (float __x, float __y) __attribute__ ((__nothrow__));
extern float scalbnf (float __x, int __n) __attribute__ ((__nothrow__)); extern float __scalbnf (float __x, int __n) __attribute__ ((__nothrow__));
extern int ilogbf (float __x) __attribute__ ((__nothrow__)); extern int __ilogbf (float __x) __attribute__ ((__nothrow__));

extern float scalbf (float __x, float __n) __attribute__ ((__nothrow__)); extern float __scalbf (float __x, float __n) __attribute__ ((__nothrow__));

extern long double acosl (long double __x) __attribute__ ((__nothrow__)); extern long double __acosl (long double __x) __attribute__ ((__nothrow__));
extern long double asinl (long double __x) __attribute__ ((__nothrow__)); extern long double __asinl (long double __x) __attribute__ ((__nothrow__));
extern long double atanl (long double __x) __attribute__ ((__nothrow__)); extern long double __atanl (long double __x) __attribute__ ((__nothrow__));
extern long double atan2l (long double __y, long double __x) __attribute__ ((__nothrow__)); extern long double __atan2l (long double __y, long double __x) __attribute__ ((__nothrow__));
extern long double cosl (long double __x) __attribute__ ((__nothrow__)); extern long double __cosl (long double __x) __attribute__ ((__nothrow__));
extern long double sinl (long double __x) __attribute__ ((__nothrow__)); extern long double __sinl (long double __x) __attribute__ ((__nothrow__));
extern long double tanl (long double __x) __attribute__ ((__nothrow__)); extern long double __tanl (long double __x) __attribute__ ((__nothrow__));
extern long double coshl (long double __x) __attribute__ ((__nothrow__)); extern long double __coshl (long double __x) __attribute__ ((__nothrow__));
extern long double sinhl (long double __x) __attribute__ ((__nothrow__)); extern long double __sinhl (long double __x) __attribute__ ((__nothrow__));
extern long double tanhl (long double __x) __attribute__ ((__nothrow__)); extern long double __tanhl (long double __x) __attribute__ ((__nothrow__));


extern long double acoshl (long double __x) __attribute__ ((__nothrow__)); extern long double __acoshl (long double __x) __attribute__ ((__nothrow__));
extern long double asinhl (long double __x) __attribute__ ((__nothrow__)); extern long double __asinhl (long double __x) __attribute__ ((__nothrow__));
extern long double atanhl (long double __x) __attribute__ ((__nothrow__)); extern long double __atanhl (long double __x) __attribute__ ((__nothrow__));


extern long double expl (long double __x) __attribute__ ((__nothrow__)); extern long double __expl (long double __x) __attribute__ ((__nothrow__));
extern long double frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__)); extern long double __frexpl (long double __x, int *__exponent) __attribute__ ((__nothrow__));
extern long double ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__)); extern long double __ldexpl (long double __x, int __exponent) __attribute__ ((__nothrow__));
extern long double logl (long double __x) __attribute__ ((__nothrow__)); extern long double __logl (long double __x) __attribute__ ((__nothrow__));
extern long double log10l (long double __x) __attribute__ ((__nothrow__)); extern long double __log10l (long double __x) __attribute__ ((__nothrow__));
extern long double modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__)); extern long double __modfl (long double __x, long double *__iptr) __attribute__ ((__nothrow__));


extern long double expm1l (long double __x) __attribute__ ((__nothrow__)); extern long double __expm1l (long double __x) __attribute__ ((__nothrow__));
extern long double log1pl (long double __x) __attribute__ ((__nothrow__)); extern long double __log1pl (long double __x) __attribute__ ((__nothrow__));
extern long double logbl (long double __x) __attribute__ ((__nothrow__)); extern long double __logbl (long double __x) __attribute__ ((__nothrow__));


extern long double powl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __powl (long double __x, long double __y) __attribute__ ((__nothrow__));
extern long double sqrtl (long double __x) __attribute__ ((__nothrow__)); extern long double __sqrtl (long double __x) __attribute__ ((__nothrow__));


extern long double hypotl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __hypotl (long double __x, long double __y) __attribute__ ((__nothrow__));


extern long double cbrtl (long double __x) __attribute__ ((__nothrow__)); extern long double __cbrtl (long double __x) __attribute__ ((__nothrow__));


extern long double ceill (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __ceill (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double fabsl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __fabsl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double floorl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __floorl (long double __x) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double fmodl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __fmodl (long double __x, long double __y) __attribute__ ((__nothrow__));
extern int __isinfl (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int __finitel (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int isinfl (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int finitel (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double dreml (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __dreml (long double __x, long double __y) __attribute__ ((__nothrow__));
extern long double significandl (long double __x) __attribute__ ((__nothrow__)); extern long double __significandl (long double __x) __attribute__ ((__nothrow__));

extern long double copysignl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __copysignl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));

extern int __isnanl (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int isnanl (long double __value) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double j0l (long double) __attribute__ ((__nothrow__)); extern long double __j0l (long double) __attribute__ ((__nothrow__));
extern long double j1l (long double) __attribute__ ((__nothrow__)); extern long double __j1l (long double) __attribute__ ((__nothrow__));
extern long double jnl (int, long double) __attribute__ ((__nothrow__)); extern long double __jnl (int, long double) __attribute__ ((__nothrow__));
extern long double y0l (long double) __attribute__ ((__nothrow__)); extern long double __y0l (long double) __attribute__ ((__nothrow__));
extern long double y1l (long double) __attribute__ ((__nothrow__)); extern long double __y1l (long double) __attribute__ ((__nothrow__));
extern long double ynl (int, long double) __attribute__ ((__nothrow__)); extern long double __ynl (int, long double) __attribute__ ((__nothrow__));

extern long double erfl (long double) __attribute__ ((__nothrow__)); extern long double __erfl (long double) __attribute__ ((__nothrow__));
extern long double erfcl (long double) __attribute__ ((__nothrow__)); extern long double __erfcl (long double) __attribute__ ((__nothrow__));
extern long double lgammal (long double) __attribute__ ((__nothrow__)); extern long double __lgammal (long double) __attribute__ ((__nothrow__));

extern long double gammal (long double) __attribute__ ((__nothrow__)); extern long double __gammal (long double) __attribute__ ((__nothrow__));
extern long double lgammal_r (long double, int *__signgamp) __attribute__ ((__nothrow__)); extern long double __lgammal_r (long double, int *__signgamp) __attribute__ ((__nothrow__));

extern long double rintl (long double __x) __attribute__ ((__nothrow__)); extern long double __rintl (long double __x) __attribute__ ((__nothrow__));
extern long double nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__)); extern long double __nextafterl (long double __x, long double __y) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern long double remainderl (long double __x, long double __y) __attribute__ ((__nothrow__)); extern long double __remainderl (long double __x, long double __y) __attribute__ ((__nothrow__));
extern long double scalbnl (long double __x, int __n) __attribute__ ((__nothrow__)); extern long double __scalbnl (long double __x, int __n) __attribute__ ((__nothrow__));
extern int ilogbl (long double __x) __attribute__ ((__nothrow__)); extern int __ilogbl (long double __x) __attribute__ ((__nothrow__));

extern long double scalbl (long double __x, long double __n) __attribute__ ((__nothrow__)); extern long double __scalbl (long double __x, long double __n) __attribute__ ((__nothrow__));
extern int signgam;
typedef enum
{
  _IEEE_ = -1,
  _SVID_,
  _XOPEN_,
  _POSIX_,
  _ISOC_
} _LIB_VERSION_TYPE;
extern _LIB_VERSION_TYPE _LIB_VERSION;
struct exception
  {
    int type;
    char *name;
    double arg1;
    double arg2;
    double retval;
  };
extern int matherr (struct exception *__exc);



extern void *memcpy (void *__restrict __dest,
       __const void *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memmove (void *__dest, __const void *__src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern void *memccpy (void *__restrict __dest, __const void *__restrict __src,
        int __c, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));

extern void *memset (void *__s, int __c, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int memcmp (__const void *__s1, __const void *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern void *memchr (__const void *__s, int __c, size_t __n)
      __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));


extern char *strcpy (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strncpy (char *__restrict __dest,
        __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strcat (char *__restrict __dest, __const char *__restrict __src)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strncat (char *__restrict __dest, __const char *__restrict __src,
        size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strcmp (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strncmp (__const char *__s1, __const char *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strcoll (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern size_t strxfrm (char *__restrict __dest,
         __const char *__restrict __src, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));

extern char *strdup (__const char *__s)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) __attribute__ ((__nonnull__ (1)));

extern char *strchr (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *strrchr (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));


extern size_t strcspn (__const char *__s, __const char *__reject)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern size_t strspn (__const char *__s, __const char *__accept)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strpbrk (__const char *__s, __const char *__accept)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strstr (__const char *__haystack, __const char *__needle)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strtok (char *__restrict __s, __const char *__restrict __delim)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));

extern char *__strtok_r (char *__restrict __s,
    __const char *__restrict __delim,
    char **__restrict __save_ptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 3)));
extern char *strtok_r (char *__restrict __s, __const char *__restrict __delim,
         char **__restrict __save_ptr)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2, 3)));

extern size_t strlen (__const char *__s)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));


extern char *strerror (int __errnum) __attribute__ ((__nothrow__));

extern int strerror_r (int __errnum, char *__buf, size_t __buflen) __asm__ ("" "__xpg_strerror_r") __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (2)));
extern void __bzero (void *__s, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern void bcopy (__const void *__src, void *__dest, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));
extern void bzero (void *__s, size_t __n) __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1)));
extern int bcmp (__const void *__s1, __const void *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *index (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern char *rindex (__const char *__s, int __c)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1)));
extern int ffs (int __i) __attribute__ ((__nothrow__)) __attribute__ ((__const__));
extern int strcasecmp (__const char *__s1, __const char *__s2)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern int strncasecmp (__const char *__s1, __const char *__s2, size_t __n)
     __attribute__ ((__nothrow__)) __attribute__ ((__pure__)) __attribute__ ((__nonnull__ (1, 2)));
extern char *strsep (char **__restrict __stringp,
       __const char *__restrict __delim)
     __attribute__ ((__nothrow__)) __attribute__ ((__nonnull__ (1, 2)));


struct _IO_FILE;

typedef struct _IO_FILE FILE;


typedef struct _IO_FILE __FILE;
typedef struct
{
  int __count;
  union
  {
    unsigned int __wch;
    char __wchb[4];
  } __value;
} __mbstate_t;
typedef struct
{
  __off_t __pos;
  __mbstate_t __state;
} _G_fpos_t;
typedef struct
{
  __off64_t __pos;
  __mbstate_t __state;
} _G_fpos64_t;
typedef int _G_int16_t __attribute__ ((__mode__ (__HI__)));
typedef int _G_int32_t __attribute__ ((__mode__ (__SI__)));
typedef unsigned int _G_uint16_t __attribute__ ((__mode__ (__HI__)));
typedef unsigned int _G_uint32_t __attribute__ ((__mode__ (__SI__)));
typedef __builtin_va_list __gnuc_va_list;
struct _IO_jump_t; struct _IO_FILE;
typedef void _IO_lock_t;
struct _IO_marker {
  struct _IO_marker *_next;
  struct _IO_FILE *_sbuf;
  int _pos;
};
enum __codecvt_result
{
  __codecvt_ok,
  __codecvt_partial,
  __codecvt_error,
  __codecvt_noconv
};
struct _IO_FILE {
  int _flags;
  char* _IO_read_ptr;
  char* _IO_read_end;
  char* _IO_read_base;
  char* _IO_write_base;
  char* _IO_write_ptr;
  char* _IO_write_end;
  char* _IO_buf_base;
  char* _IO_buf_end;
  char *_IO_save_base;
  char *_IO_backup_base;
  char *_IO_save_end;
  struct _IO_marker *_markers;
  struct _IO_FILE *_chain;
  int _fileno;
  int _flags2;
  __off_t _old_offset;
  unsigned short _cur_column;
  signed char _vtable_offset;
  char _shortbuf[1];
  _IO_lock_t *_lock;
  __off64_t _offset;
  void *__pad1;
  void *__pad2;
  void *__pad3;
  void *__pad4;
  size_t __pad5;
  int _mode;
  char _unused2[15 * sizeof (int) - 4 * sizeof (void *) - sizeof (size_t)];
};
typedef struct _IO_FILE _IO_FILE;
struct _IO_FILE_plus;
extern struct _IO_FILE_plus _IO_2_1_stdin_;
extern struct _IO_FILE_plus _IO_2_1_stdout_;
extern struct _IO_FILE_plus _IO_2_1_stderr_;
typedef __ssize_t __io_read_fn (void *__cookie, char *__buf, size_t __nbytes);
typedef __ssize_t __io_write_fn (void *__cookie, __const char *__buf,
     size_t __n);
typedef int __io_seek_fn (void *__cookie, __off64_t *__pos, int __w);
typedef int __io_close_fn (void *__cookie);
extern int __underflow (_IO_FILE *);
extern int __uflow (_IO_FILE *);
extern int __overflow (_IO_FILE *, int);
extern int _IO_getc (_IO_FILE *__fp);
extern int _IO_putc (int __c, _IO_FILE *__fp);
extern int _IO_feof (_IO_FILE *__fp) __attribute__ ((__nothrow__));
extern int _IO_ferror (_IO_FILE *__fp) __attribute__ ((__nothrow__));
extern int _IO_peekc_locked (_IO_FILE *__fp);
extern void _IO_flockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern void _IO_funlockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern int _IO_ftrylockfile (_IO_FILE *) __attribute__ ((__nothrow__));
extern int _IO_vfscanf (_IO_FILE * __restrict, const char * __restrict,
   __gnuc_va_list, int *__restrict);
extern int _IO_vfprintf (_IO_FILE *__restrict, const char *__restrict,
    __gnuc_va_list);
extern __ssize_t _IO_padn (_IO_FILE *, int, __ssize_t);
extern size_t _IO_sgetn (_IO_FILE *, void *, size_t);
extern __off64_t _IO_seekoff (_IO_FILE *, __off64_t, int, int);
extern __off64_t _IO_seekpos (_IO_FILE *, __off64_t, int);
extern void _IO_free_backup_area (_IO_FILE *) __attribute__ ((__nothrow__));

typedef _G_fpos_t fpos_t;

extern struct _IO_FILE *stdin;
extern struct _IO_FILE *stdout;
extern struct _IO_FILE *stderr;

extern int remove (__const char *__filename) __attribute__ ((__nothrow__));
extern int rename (__const char *__old, __const char *__new) __attribute__ ((__nothrow__));


extern FILE *tmpfile (void) ;
extern char *tmpnam (char *__s) __attribute__ ((__nothrow__)) ;

extern char *tmpnam_r (char *__s) __attribute__ ((__nothrow__)) ;
extern char *tempnam (__const char *__dir, __const char *__pfx)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;

extern int fclose (FILE *__stream);
extern int fflush (FILE *__stream);

extern int fflush_unlocked (FILE *__stream);

extern FILE *fopen (__const char *__restrict __filename,
      __const char *__restrict __modes) ;
extern FILE *freopen (__const char *__restrict __filename,
        __const char *__restrict __modes,
        FILE *__restrict __stream) ;

extern FILE *fdopen (int __fd, __const char *__modes) __attribute__ ((__nothrow__)) ;

extern void setbuf (FILE *__restrict __stream, char *__restrict __buf) __attribute__ ((__nothrow__));
extern int setvbuf (FILE *__restrict __stream, char *__restrict __buf,
      int __modes, size_t __n) __attribute__ ((__nothrow__));

extern void setbuffer (FILE *__restrict __stream, char *__restrict __buf,
         size_t __size) __attribute__ ((__nothrow__));
extern void setlinebuf (FILE *__stream) __attribute__ ((__nothrow__));

extern int fprintf (FILE *__restrict __stream,
      __const char *__restrict __format, ...);
extern int printf (__const char *__restrict __format, ...);
extern int sprintf (char *__restrict __s,
      __const char *__restrict __format, ...) __attribute__ ((__nothrow__));
extern int vfprintf (FILE *__restrict __s, __const char *__restrict __format,
       __gnuc_va_list __arg);
extern int vprintf (__const char *__restrict __format, __gnuc_va_list __arg);
extern int vsprintf (char *__restrict __s, __const char *__restrict __format,
       __gnuc_va_list __arg) __attribute__ ((__nothrow__));


extern int snprintf (char *__restrict __s, size_t __maxlen,
       __const char *__restrict __format, ...)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 4)));
extern int vsnprintf (char *__restrict __s, size_t __maxlen,
        __const char *__restrict __format, __gnuc_va_list __arg)
     __attribute__ ((__nothrow__)) __attribute__ ((__format__ (__printf__, 3, 0)));


extern int fscanf (FILE *__restrict __stream,
     __const char *__restrict __format, ...) ;
extern int scanf (__const char *__restrict __format, ...) ;
extern int sscanf (__const char *__restrict __s,
     __const char *__restrict __format, ...) __attribute__ ((__nothrow__));


extern int fgetc (FILE *__stream);
extern int getc (FILE *__stream);
extern int getchar (void);

extern int getc_unlocked (FILE *__stream);
extern int getchar_unlocked (void);
extern int fgetc_unlocked (FILE *__stream);

extern int fputc (int __c, FILE *__stream);
extern int putc (int __c, FILE *__stream);
extern int putchar (int __c);

extern int fputc_unlocked (int __c, FILE *__stream);
extern int putc_unlocked (int __c, FILE *__stream);
extern int putchar_unlocked (int __c);
extern int getw (FILE *__stream);
extern int putw (int __w, FILE *__stream);

extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
     ;
extern char *gets (char *__s) ;


extern int fputs (__const char *__restrict __s, FILE *__restrict __stream);
extern int puts (__const char *__s);
extern int ungetc (int __c, FILE *__stream);
extern size_t fread (void *__restrict __ptr, size_t __size,
       size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite (__const void *__restrict __ptr, size_t __size,
        size_t __n, FILE *__restrict __s) ;

extern size_t fread_unlocked (void *__restrict __ptr, size_t __size,
         size_t __n, FILE *__restrict __stream) ;
extern size_t fwrite_unlocked (__const void *__restrict __ptr, size_t __size,
          size_t __n, FILE *__restrict __stream) ;

extern int fseek (FILE *__stream, long int __off, int __whence);
extern long int ftell (FILE *__stream) ;
extern void rewind (FILE *__stream);

extern int fseeko (FILE *__stream, __off_t __off, int __whence);
extern __off_t ftello (FILE *__stream) ;

extern int fgetpos (FILE *__restrict __stream, fpos_t *__restrict __pos);
extern int fsetpos (FILE *__stream, __const fpos_t *__pos);


extern void clearerr (FILE *__stream) __attribute__ ((__nothrow__));
extern int feof (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int ferror (FILE *__stream) __attribute__ ((__nothrow__)) ;

extern void clearerr_unlocked (FILE *__stream) __attribute__ ((__nothrow__));
extern int feof_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int ferror_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;

extern void perror (__const char *__s);

extern int sys_nerr;
extern __const char *__const sys_errlist[];
extern int fileno (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int fileno_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern FILE *popen (__const char *__command, __const char *__modes) ;
extern int pclose (FILE *__stream);
extern char *ctermid (char *__s) __attribute__ ((__nothrow__));
extern void flockfile (FILE *__stream) __attribute__ ((__nothrow__));
extern int ftrylockfile (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern void funlockfile (FILE *__stream) __attribute__ ((__nothrow__));


struct flock
  {
    short int l_type;
    short int l_whence;
    __off_t l_start;
    __off_t l_len;
    __pid_t l_pid;
  };


extern int fcntl (int __fd, int __cmd, ...);
extern int open (__const char *__file, int __oflag, ...) __attribute__ ((__nonnull__ (1)));
extern int creat (__const char *__file, __mode_t __mode) __attribute__ ((__nonnull__ (1)));
extern int lockf (int __fd, int __cmd, __off_t __len);
extern int posix_fadvise (int __fd, __off_t __offset, __off_t __len,
     int __advise) __attribute__ ((__nothrow__));
extern int posix_fallocate (int __fd, __off_t __offset, __off_t __len);


extern int flock (int __fd, int __operation) __attribute__ ((__nothrow__));

typedef s8 CHAR;
typedef s16 SHORT;
typedef int INT;
typedef INT LONG;
typedef f32 FLOAT;
typedef f64 DOUBLE;
typedef n8 UCHAR;
typedef n16 USHORT;
typedef unsigned int UINT;
typedef UINT ULONG;
typedef int STATUS;
typedef void * ADDRESS;
typedef enum e_axis {
    X = 0,
    Y,
    Z
} t_axis;
typedef enum e_fopen_mode {
   READ_MODE = 0,
   WRITE_MODE
} t_fopen_mode;
int Alert_confirm(CHAR *message, INT n_buttons, ...);
ADDRESS WTAlloc( size_t size );
void WTFree( ADDRESS address );
STATUS DefOpenUsrFile( const CHAR *filename, const CHAR *marker );
STATUS DefOpenFile( const CHAR *markername );
STATUS DefFindKey( const CHAR *key, const INT mark );
STATUS DefReadData( const CHAR *format_str, ADDRESS data_addr );
STATUS DefCloseFile( void );
INT ExtractNameTo( CHAR *orig_name, CHAR *key, CHAR *new_name );
    double FMax( int info, ... );
    double FMin( int info, ... );
    int IMax( int info, ... );
    int IMin( int info, ... );
FILE *OpenFile( const CHAR *filename, const t_fopen_mode mode );
STATUS CloseFile( FILE *plotdata_fptr );
STATUS RewindFile( FILE *plotdata_fptr );
STATUS RemoveFile( const CHAR *filename );
STATUS FileExists( const CHAR *filename );
LONG FileDate( CHAR *path );
void WriteError( const CHAR *string );
STATUS FileExecs( const CHAR *filename );
STATUS IsaWDir( const CHAR *filename );
STATUS IsSunview( void );
CHAR *Resides( CHAR *env_varname );
CHAR *SetBase( CHAR *filename );
CHAR *ExtractBase( CHAR *filename );
int ScalePlot( double start, double range, double *minor_tic_start,
               double *minor_tic_delta, double *major_tic_start,
               double *major_tic_delta, double *label_tic_start,
               double *label_tic_delta );
int RNEAREST_RF( int n, int fact );
STATUS EpicConf(
 void
);
extern SHORT rffrequency_length[2];
extern SHORT rffreq_bits[2][14];
extern SHORT rfunblank_length[2];
extern SHORT rfunblank_bits[2][4];
extern SHORT DAB_length[2];
extern SHORT DAB_bits[2][16];
extern LONG DAB_start;
extern SHORT XTR_length[2];
extern SHORT XTR_bits[2][18];
extern LONG XTR_start;
extern SHORT RBA_length[2];
extern SHORT RBA_bits[2][12];
extern LONG RBA_start;
extern SHORT FAST_RBA_length;
extern SHORT FAST_RBA_bits[];
extern LONG FAST_RBA_start;
extern SHORT FAST_PROG_length;
extern SHORT FAST_PROG_bits[];
extern LONG FAST_PROG_start;
extern SHORT FAST_DIAG_length;
extern SHORT FAST_DIAG_bits[];
extern LONG FAST_DIAG_start;
extern SHORT SUF_length;
extern SHORT SUF_bits[];
extern LONG SUF_start;
extern SHORT HSDAB_length;
extern SHORT HSDAB_bits[];
extern SHORT HSDAB_start;
extern SHORT COPY_DAB_length;
extern SHORT COPY_DAB_bits[];
extern SHORT COPY_DAB_start;
extern SHORT DIM_length;
extern SHORT DIM_bits[];
extern LONG DIM_start;
extern SHORT DIM2_length;
extern SHORT DIM2_bits[];
extern LONG DIM2_start;
extern SHORT sq_sync_length[2];
extern SHORT sq_sync_bits[2][13];
extern SHORT sq_lockout_length;
extern SHORT sq_lockout_bits[];
extern SHORT pass_length;
extern SHORT pass_bits[];
extern LONG pass_start;
extern SHORT ATTEN_unlock_length[2];
extern SHORT ATTEN_unlock_bits[2][6];
extern LONG ATTEN_start;
extern INT psd_gxwcnt;
extern INT psd_pulsepos;
extern INT psd_eparity;
extern FLOAT psd_etbetax, psd_etbetay;
extern CHAR psd_epstring[];
extern LONG rfupa;
extern LONG rfupd;
extern LONG rfublwait;
extern STATUS rfdisable_add;
extern INT EDC;
extern INT RDC;
extern INT ECF;
extern INT EMISC;
extern INT ESSL;
extern INT ESYNC;
extern INT ETHETA;
extern INT EUBL;
extern INT EXTATTEN;
extern INT ERFREQ;
extern INT ERPHASE;
extern INT RFLTRS;
extern INT RFLTRC;
extern INT RFUBL;
extern INT RSYNC;
extern INT RATTEN;
extern INT RRFSEL;
extern INT ESEL0;
extern INT ESEL1;
extern INT ESEL_ALL;
extern INT RSEL0;
extern INT RSEL1;
extern INT RSEL_ALL;
extern INT RATTEN_ALL;
extern INT RATTEN_1;
extern INT RATTEN_2;
extern INT RATTEN_3;
extern INT RATTEN_4;
extern INT RLOOP;
extern INT RHEADI;
extern INT RFAUX;
extern INT RFBODYI;
extern INT ECCF;
extern INT EDSYNC;
extern INT EMRST;
extern INT EMSSS1;
extern INT EMSSS2;
extern INT EMSSS3;
extern INT ESSP;
extern INT EXUBL;
extern INT EDDSP;
extern INT EATTEN_TEST;
extern INT ETHETA_L;
extern INT EOMEGA_L;
extern INT RBA;
extern INT RBL;
extern INT RFF;
extern INT RDSYNC;
extern INT RSAD;
extern INT RSUF;
extern INT RUBL;
extern INT RUBL_1;
extern INT RUBL_2;
extern INT RUBL_3;
extern INT RUBL_4;
extern INT RATTEN_FSEL;
extern INT RATTEN_3DB;
extern INT RATTEN_6DB;
extern INT RATTEN_12DB;
extern INT RATTEN_23DB;
extern INT FAST_EDC;
extern INT FAST_RDC;
extern INT FAST_RFLTRS;
extern INT RFHUBSEL;
extern INT HUBIND;
extern INT R1IND;
extern INT EXTATTEN_Q;
extern INT DB_I;
extern INT DB_Q;
extern INT PHASELAG_Q;
extern INT SRI_C;
typedef enum {
 TYPINSTRMEM,
 TYPWAVEMEM
} WF_HARDWARE_TYPE;
typedef enum {
 TOHARDWARE,
 FROMHARDWARE
} HW_DIRECTION;
typedef enum {
 SSPS1,
 SSPS2,
 SSPS3,
 SSPS4
} SSP_S_ATTRIB;
typedef enum {
 DABNORM,
 DABCINE,
        DABON,
        DABOFF
} TYPDAB_PACKETS;
typedef enum {
        NOPASS,
        PASSTHROUGH
} TYPACQ_PASS;
typedef enum {
        TYPXGRAD,
        TYPYGRAD,
        TYPZGRAD,
        TYPRHO1,
        TYPRHO2,
        TYPTHETA,
        TYPOMEGA,
        TYPSSP,
        TYPAUX,
        TYPBXGRAD,
        TYPBYGRAD,
        TYPBZGRAD,
        TYPBRHO1,
        TYPBRHO2,
        TYPBTHETA,
        TYPBOMEGA,
        TYPBSSP,
        TYPBAUX
} WF_PROCESSOR;
typedef long WF_HW_WAVEFORM_PTR;
typedef long WF_HW_INSTR_PTR;
typedef ADDRESS WF_PULSE_FORWARD_ADDR;
typedef ADDRESS WF_INSTR_PTR;
typedef struct INST_NODE {
 struct INST_NODE *next;
        WF_HW_INSTR_PTR wf_instr_ptr;
        long amplitude;
        long period;
        long start;
        long end;
        long entry_group;
        WF_PULSE_FORWARD_ADDR pulse_hdr;
} WF_INSTR_HDR;
typedef struct {
 short amplitude;
} CONST_EXT;
typedef struct {
        short amplitude;
        float separation;
        float nsinc_cycles;
        float alpha;
} HADAMARD_EXT;
typedef struct {
 short start_amplitude;
 short end_amplitude;
} RAMP_EXT;
typedef struct {
 short amplitude;
        float nsinc_cycles;
        float alpha;
} SINC_EXT;
typedef struct {
 short amplitude;
 float start_phase;
 float phase_length;
 short offset;
} SINUSOID_EXT;
typedef union {
        CONST_EXT constext;
        HADAMARD_EXT hadamard;
 RAMP_EXT ramp;
        SINC_EXT sinc;
        SINUSOID_EXT sinusoid;
} WF_PULSE_EXT;
typedef enum {
 TYPBITS,
 TYPBRIDGED_CONST,
 TYPBRIDGED_RAMP,
 TYPCONSTANT,
 TYPEXTERNAL,
    TYPHADAMARD,
 TYPRAMP,
 TYPRESERVE,
    TYPSINC,
 TYPSINUSOID
} WF_PULSE_TYPES;
typedef enum {
   SSPUNKN,
   SSPDAB,
   SSPRBA,
   SSPXTR,
   SSPSYNC,
   SSPFREQ,
   SSPUBR,
   SSPPA,
   SSPPD,
   SSPPM,
   SSPPMD,
   SSPPEA,
   SSPPED,
   SSPPEM,
   SSPRFBITS,
   SSPSEQ,
   SSPSCP,
   SSPPASS,
   SSPATTEN,
   SSP3DIM,
   SSPTREG
} WF_PGMTAG;
typedef enum {
   PSDREUSEP,
   PSDNEWP
} WF_PGMREUSE;
typedef enum {
   ROUTE_TO_AP,
   ROUTE_TO_APS
} MGD_DATA_DESTINATION;
typedef struct PULSE {
        char *pulsename;
 long ninsts;
 WF_HW_WAVEFORM_PTR wave_addr;
 int board_type;
 WF_PGMREUSE reusep;
 WF_PGMTAG tag;
 long addtag;
        int id;
 long ctrlfield;
        WF_INSTR_HDR *inst_hdr_tail;
        WF_INSTR_HDR *inst_hdr_head;
        WF_PROCESSOR wavegen_type;
        WF_PULSE_TYPES type;
 short resolution;
        struct PULSE *assoc_pulse;
      WF_PULSE_EXT *ext;
} WF_PULSE;
typedef WF_PULSE * WF_PULSE_ADDR;
typedef struct INST_QUEUE_NODE {
 WF_INSTR_HDR *instr;
        struct INST_QUEUE_NODE *next;
 struct INST_QUEUE_NODE *new_queue;
 struct INST_QUEUE_NODE *last_queue;
} WF_INSTR_QUEUE;
typedef long SEQUENCE_ENTRIES[9];
typedef struct ENTRY_PT_NODE{
        WF_PULSE_ADDR ssp_pulse;
 long *entry_addresses;
 long time;
 struct ENTRY_PT_NODE *next;
} SEQUENCE_LIST;
typedef enum exciter_type {
       NO_EXCITER = 0,
       MASTER_EXCITER,
       SLAVE_EXCITER,
       ALL_EXCITERS
} exciterSelection;
typedef enum receiver_type {
       NO_RECEIVER = 0,
       MASTER_RECEIVER,
       SLAVE_RECEIVER,
       ALL_RECEIVERS
} receiverSelection;
typedef enum oscillator_source {
    LO_MASTER_RCVALL = 0,
    LO_SLAVE_RCVB1,
    LO_SLAVE_RCVB2,
    LO_SLAVE_RCVB3,
    LO_SLAVE_RCVB4,
    LO_SLAVE_RCVB1B2,
    LO_SLAVE_RCVB1B3,
    LO_SLAVE_RCVB1B4,
    LO_SLAVE_RCVB1B2B3,
    LO_SLAVE_RCVB1B2B4,
    LO_SLAVE_RCVB1B3B4,
    LO_SLAVE_RCVB2B3,
    LO_SLAVE_RCVB2B4,
    LO_SLAVE_RCVB2B3B4,
    LO_SLAVE_RCVB3B4,
    LO_SLAVE_RCVALL,
    NO_LO_CHANGE
} demodSelection;
typedef enum nav_type {
    NAV_OFF = 0,
    NAV_ON,
    NAV_MASTER,
    NAV_SLAVE,
    NO_NAV_CHANGE
} navSelection;
extern INT EDC;
extern INT RDC;
extern INT ECF;
extern INT EMISC;
extern INT ESSL;
extern INT ESYNC;
extern INT ETHETA;
extern INT EUBL;
extern INT EXTATTEN;
extern INT EXTATTEN_Q;
extern INT PHASELAG_Q;
extern INT DDIQSWOC;
extern INT DB_I;
extern INT DB_Q;
extern INT SRI_C;
extern INT RFHUBSEL;
extern INT HUBIND;
extern INT R1IND;
extern INT ERFREQ;
extern INT ERPHASE;
extern INT RFLTRS;
extern INT RFLTRC;
extern INT RFUBL;
extern INT RSYNC;
extern INT RATTEN;
extern INT RRFSEL;
extern INT ESEL0;
extern INT ESEL1;
extern INT ESEL_ALL;
extern INT RSEL0;
extern INT RSEL1;
extern INT RSEL_ALL;
extern INT RATTEN_ALL;
extern INT RATTEN_1;
extern INT RATTEN_2;
extern INT RATTEN_3;
extern INT RATTEN_4;
extern INT RLOOP;
extern INT RHEADI;
extern INT RFAUX;
extern INT RFBODYI;
extern INT ECCF;
extern INT EDSYNC;
extern INT EMRST;
extern INT EMSSS1;
extern INT EMSSS2;
extern INT EMSSS3;
extern INT ESSP;
extern INT EXUBL;
extern INT EDDSP;
extern INT EATTEN_TEST;
extern INT ETHETA_L;
extern INT EOMEGA_L;
extern INT RBA;
extern INT RBL;
extern INT RFF;
extern INT RDSYNC;
extern INT RSAD;
extern INT RSUF;
extern INT RUBL;
extern INT RUBL_1;
extern INT RUBL_2;
extern INT RUBL_3;
extern INT RUBL_4;
extern INT RATTEN_FSEL;
extern INT RATTEN_3DB;
extern INT RATTEN_6DB;
extern INT RATTEN_12DB;
extern INT RATTEN_23DB;
extern INT FAST_EDC;
extern INT FAST_RDC;
extern INT FAST_RFLTRS;
extern INT RRFMISC;
extern INT LOSOURCE;
extern INT cfrfupa;
extern INT cfrfupd;
extern INT cfrfminunblk;
extern INT cfrfminblank;
extern INT cfrfminblanktorcv;
extern float cfrfampftconst;
extern float cfrfampftlinear;
extern float cfrfampftquadratic;
extern const INT opcode_xcvr[NUM_PSD_BOARD_TYPES][65];
extern int psd_board_type;
extern int psd_id_count;
extern int bd_index;
typedef enum dbLevel_e {
    NODEBUG = 0,
    DBLEVEL1,
    DBLEVEL2,
    DBLEVEL3,
    DBLEVEL4,
    DBLEVEL5,
    DBLEVEL6,
    DBLEVEL7,
    DBLEVEL8,
    DBLEVEL9,
    DBLEVEL10
} dbLevel_t;
void printDebug( const dbLevel_t level, const dbLevel_t dbLevel,
                 const CHAR *functionName, const CHAR *format, ... );
void setDebugFileExt( char fileName[], int fileFlag );
typedef enum aptype_e
{
    UNKNOWN = 0,
    REFLEX100,
    REFLEX200,
    REFLEX400,
    REFLEX800
} aptype_t;
aptype_t check_apconfig( const int e_flag );
STATUS init_apconfig( const int n_proc, const float memsize,
                      const int proc_type, const int e_flag );
typedef enum rbw_update_type {OVERWRITE_NONE, OVERWRITE_OPRBW, OVERWRITE_OPRBW2} RBW_UPDATE_TYPE;
typedef enum filter_block_type {SCAN, PRESCAN} FILTER_BLOCK_TYPE;
typedef struct s_list {
    INT time;
    FLOAT ampl;
    INT ptype;
} t_list;
STATUS calcChecksumScanInfo(
    n32 *chksum_val, const SCAN_INFO *si, const int numslices, int psdcrucial_debug
);
long hostToRspRotMat(
    const float fval
);
STATUS orderslice(
    const INT acqType, const INT numLocs, const INT locsPerPass,
    const INT gating
);
STATUS orderslice2(
    const INT acqType, const INT numLocs, const INT numAcqs, INT *sl_pass,
    INT *prescan_pass, const INT gating
);
STATUS scalerotmats(
    long (*rsprot)[9], const LOG_GRAD *lgrad, const PHYS_GRAD *pgrad,
    const INT slquant, const INT debug
);
STATUS setupphasetable(
    SHORT *phaseTab, INT respCompType, INT phaseRes
);
STATUS set_echo_flip(
    int *rhdacqctrl, n32 * chksum_rhdacqctrl, const int eepf, const int oepf,
    const int eeff, const int oeff
);
STATUS typ3dmscat(
    DATA_ACQ_ORDER data_acq_order[], INT *pislab, INT numLocs, INT numSlabs, INT numAcqs
);
STATUS typ3dmsncat(
    DATA_ACQ_ORDER data_acq_order[], INT *pislab, INT numLocs, INT numSlabs, INT numAcqs
);
STATUS typcard(
    DATA_ACQ_ORDER data_acq_order[], INT *indexrot, INT numLocs, INT maxphase
);
STATUS typcat(
    DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs,
    INT locsPerPass, INT numAcqs, INT opimode, INT oppseq, INT opflaxall,
    INT oppomp, INT rhnpomp
);
STATUS typfsa(
    DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT *locsPass, INT numAcqs
);
STATUS typncat(
    DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs,
    INT opimode, INT oppseq, INT opflaxall
);
STATUS typncatPomp(
    DATA_ACQ_ORDER *tempAcqTab, INT *pislice, INT numLocs, INT numAcqs
);
STATUS typssfse(
    DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT *locsPerPass, INT numAcqs, INT orderType
);
STATUS typssfseint(
    DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT locsPerPass, INT numAcqs
);
STATUS typssfseseq(
    DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT locsPerPass, INT numAcqs
);
STATUS typxrr(
    DATA_ACQ_ORDER data_acq_order[], INT *pislice, INT numLocs, INT numAcqs
);
STATUS typxrrPomp(
    DATA_ACQ_ORDER *tempAcqTab, INT *pislice, INT numLocs, INT numAcqs
);
typedef struct maxslquanttps_option {
    FLOAT arcRxToAcqSlicesSlope;
    FLOAT arcRxToAcqSlicesIntercept;
} MAXSLQUANTTPS_OPTION;
int activePowerMonChannel(
     const TX_COIL_INFO txCoil
);
STATUS advroundup(
    INT *adv_panel_value
);
STATUS advrounddown(
    INT *adv_panel_value
);
STATUS altrfgen(
    INT gentypflag, INT resolution, SHORT *kernel, DOUBLE cycles,
    DOUBLE slice_offset, DOUBLE slice_mod_fact, SHORT *phase_kernel,
    DOUBLE start_phase, SHORT *result_wave, DOUBLE freq_step
);
STATUS altcomplexrfgen(
    INT gentypflag, INT resolution, SHORT *kernel_rho, SHORT *kernel_theta, DOUBLE cycles,
    DOUBLE slice_offset, DOUBLE slice_mod_fact, SHORT *phase_kernel,
    DOUBLE start_phase, SHORT *result_wave_rho, SHORT *result_wave_theta, DOUBLE freq_step
);
STATUS ampfov(
    FLOAT *Ampfov, DOUBLE readout_filter, DOUBLE fov
);
STATUS amplifierB1Limit(
    double *B1_limit, const TX_COIL_INFO txCoil
);
STATUS amppwcombpe(
    DOUBLE a_start, DOUBLE area_const, DOUBLE area_pe, DOUBLE max_amp,
    DOUBLE slew_rate, INT nencodes, INT *pw_attack, INT *pw_plat,
    INT *pw_decay, FLOAT *a_base, FLOAT *a_ramp
);
STATUS amppwcrush(
    GRAD_PULSE *rightgradcrush, GRAD_PULSE *leftgradcrush, INT echonum,
    DOUBLE crushscale, DOUBLE targetamp, DOUBLE ampslicesel, DOUBLE stdarea,
    INT minconstpw, INT rmpfullscale
);
STATUS amppwencode(
    GRAD_PULSE *gradpulse, INT *total_pw, DOUBLE target_amp, INT rise_time,
    DOUBLE fov, INT num_encodes, DOUBLE area_offset
);
STATUS amppwencode2(
    GRAD_PULSE *gradpulse, INT *total_pw, DOUBLE target_amp, INT rise_time,
    DOUBLE fov, INT num_encodes, DOUBLE area_offset, DOUBLE area_offset_scale
);
STATUS amppwencodefse(
    FLOAT *ampencode, INT *pw_encode, DOUBLE fov, INT encodes, INT logaxis,
    INT xflag, INT yflag, INT zflag
);
STATUS amppwencodet(
    FLOAT *a_attack, FLOAT *a_decay, INT *pw_middle, INT *pw_attack,
    INT *pw_decay, DOUBLE target_amp, INT rise_time, DOUBLE fov, INT size
);
STATUS amppwfcse1(
    GRAD_PULSE *gxf11, GRAD_PULSE *gxf21, GRAD_PULSE *gzf11, GRAD_PULSE *gzf21,
    GRAD_PULSE *gxw, GRAD_PULSE *gzrf1, GRAD_PULSE *gzrf2, GRAD_PULSE *gzrf2l1,
    GRAD_PULSE *gzrf2r1, DOUBLE pw_read, DOUBLE fnecho, DOUBLE pcor90,
    DOUBLE pcor180, DOUBLE xtarget, INT pw_rampx, DOUBLE ztarget,
    INT pw_rampz, INT te, INT isodelay
);
STATUS amppwfcse2(
    GRAD_PULSE *gxf12, GRAD_PULSE *gxf22, GRAD_PULSE *gzf12, GRAD_PULSE *gzf22,
    GRAD_PULSE *gxw, GRAD_PULSE *gxw2, GRAD_PULSE *gzrf1, GRAD_PULSE *gzrf2,
    GRAD_PULSE *gzrf2l2, GRAD_PULSE *gzrf2r2, DOUBLE pw_read, DOUBLE te2_te1,
    DOUBLE pcor180, DOUBLE xtarget, INT pw_rampx, DOUBLE ztarget, INT pw_rampz
);
STATUS amppwfcse1opt(
    GRAD_PULSE *gxf11, GRAD_PULSE *gxf21, GRAD_PULSE *gzf11, GRAD_PULSE *gzf21,
    GRAD_PULSE *gxw, GRAD_PULSE *gzrf1, GRAD_PULSE *gzrf2, GRAD_PULSE *gzrf2l1,
    GRAD_PULSE *gzrf2r1, DOUBLE pw_read, DOUBLE fnecho, DOUBLE pcor90,
    DOUBLE pcor180, DOUBLE xtarget, INT pw_rampx, DOUBLE ztarget,
    INT pw_rampz, INT te, INT isodelay, INT xflow_gap, INT *minte_temp
);
STATUS amppwfcse2opt(
    GRAD_PULSE *gxf12, GRAD_PULSE *gxf22, GRAD_PULSE *gzf12, GRAD_PULSE *gzf22,
    GRAD_PULSE *gxw, GRAD_PULSE *gxw2, GRAD_PULSE *gzrf1, GRAD_PULSE *gzrf2,
    GRAD_PULSE *gzrf2l2, GRAD_PULSE *gzrf2r2, DOUBLE pw_read, INT te1, INT te2,
    DOUBLE pcor180, DOUBLE xtarget, INT pw_rampx, DOUBLE ztarget, INT pw_rampz,
    INT xflow_gap, INT *minte2_temp
);
STATUS amppwgmn(
    DOUBLE ref_area, DOUBLE ref_moment, DOUBLE encode_area, DOUBLE moment_area,
    INT max_allowable_time, DOUBLE beta, DOUBLE targetamp, INT ramp2target,
    INT minconstpw, FLOAT *a_gmn1, INT *pw_gmn1a, INT *pw_gmn1, INT *pw_gmn1d,
    FLOAT *a_gmn2, INT *pw_gmn2a, INT *pw_gmn2, INT *pw_gmn2d
);
STATUS amppwgrad(
    DOUBLE targetArea, DOUBLE targetAmp, DOUBLE startAmp, DOUBLE endAmp,
    INT riseTime, INT minConst, FLOAT *Amp, INT *Attack, INT *Pw, INT *Decay
);
STATUS amppwgradmethod(
    GRAD_PULSE *gradpulse, DOUBLE targetArea, DOUBLE targetAmp,
    DOUBLE startAmp, DOUBLE endAmp, INT riseTime, INT minConst
);
STATUS amppwgx1(
    FLOAT *ampgx1, INT *c_pwgx1, INT *a_pwgx1, INT *d_pwgx1, INT seq_type,
    DOUBLE area, DOUBLE area_ramp, INT avai_ptime, DOUBLE fract_echo,
    INT minconstpw, INT rmpfullscale, DOUBLE target
);
STATUS amppwgxfc(
    DOUBLE a_gxw, INT pw_gxwa, INT pw_gxw, INT pw_gxwd, INT pw_ramp,
    INT avail_time, DOUBLE frac_echo, FLOAT *a_gx1, INT *pw_gx1a,
    INT *pw_gx1, INT *pw_gx1d, FLOAT *a_gxfc, INT *pw_gxfca, INT *pw_gxfc,
    INT *pw_gxfcd
);
STATUS amppwgxfc2(
    DOUBLE a_gxw, INT pw_gxw, INT pw_gxwd, INT pw_gxw2a, INT pw_gxw2,
    INT pw_ramp, INT avail_time, DOUBLE loggrd_target, INT te1_te2,
    FLOAT *a_gxfc2, INT *pw_gxfc2a, INT *pw_gxfc2, INT *pw_gxfc2d,
    FLOAT *a_gxfc3, INT *pw_gxfc3a, INT *pw_gxfc3, INT *pw_gxfc3d
);
STATUS amppwgxfcmin(
    DOUBLE a_gxw, INT pw_gxwa, INT pw_gxw, INT pw_gxwd, INT avail_time,
    DOUBLE frac_echo, DOUBLE amp_target, INT pw_rampx, DOUBLE xbeta,
    FLOAT *a_gx1, INT *pw_gx1a, INT *pw_gx1, INT *pw_gx1d, FLOAT *a_gxfc,
    INT *pw_gxfca, INT *pw_gxfc, INT *pw_gxfcd
);
STATUS amppwgy1(
    FLOAT *ampgy1, INT *pw_gy1, INT yresolution, DOUBLE foview,
    LONG avail_pwgy1_time, INT numGrad
);
STATUS amppwgz1(
    FLOAT *ampgz1, INT *c_pwgz1, INT *a_pwgz1, INT *d_pwgz1, DOUBLE area,
    INT avai_ptime, INT minconstpw, INT rmpfullscale, DOUBLE target
);
STATUS amppwgzfc(
    DOUBLE a_gzrf1, INT pw_gzrf1a, INT pw_gzrf1, INT pw_gzrf1d, INT pw_ramp,
    INT avail_time, FLOAT *a_gz1, INT *pw_gz1a, INT *pw_gz1, INT *pw_gz1d,
    FLOAT *a_gzfc, INT *pw_gzfca, INT *pw_gzfc, INT *pw_gzfcd
);
STATUS amppwgzfcmin(
    DOUBLE a_gzrf1, INT pw_gzrf1a, INT fulltexb, INT pw_gzrf1d,
    INT avail_time, INT off_90, DOUBLE amp_target, INT pw_rampz, DOUBLE zbeta,
    FLOAT *a_gz1, INT *pw_gz1a, INT *pw_gz1, INT *pw_gz1d, FLOAT *a_gzfc,
    INT *pw_gzfca, INT *pw_gzfc, INT *pw_gzfcd
);
STATUS amppwlcrsh(
    GRAD_PULSE *gradleftcrush, GRAD_PULSE *gradrightcrush, DOUBLE area_rephase,
    DOUBLE amp_180slicesel, DOUBLE target_amp, INT minconstpw,
    INT rmpfullscale, INT *attackpw_180slicesel
);
STATUS amppwtpe(
    FLOAT *a_attack, FLOAT *a_decay, INT *pw_middle, INT *pw_attack,
    INT *pw_decay, DOUBLE target_amp, INT rise_time, DOUBLE target_area
);
STATUS amppwtpe2(
    FLOAT *a_attack, FLOAT *a_decay, INT *pw_middle, INT *pw_attack,
    INT *pw_decay, DOUBLE target_amp, INT rise_time, DOUBLE target_area,
    DOUBLE target_area_largest
);
STATUS amppwygmn(
    DOUBLE zeromoment, DOUBLE firstmoment, INT pw_gy1fa, INT pw_gy1f,
    INT pw_gy1fd, DOUBLE a_gy1fa, DOUBLE a_gy1fb, DOUBLE targetamp,
    DOUBLE ramp2target, INT method, INT *pw_gymna, INT *pw_gymn,
    INT *pw_gymnd, FLOAT *a_gymn
);
STATUS ampslice(
    FLOAT *amp_slice_select, LONG trans_bwd, DOUBLE slice_thk, DOUBLE factor,
    INT def_type
);
STATUS amptarget(
    FLOAT *Amptarget, INT laxis, INT lx, INT ly, INT lz
);
STATUS applyRotMatrices(
    FLOAT **amplitude, FLOAT **pulsetype,
    const INT numpoints, const FLOAT *rot_mat,
    FLOAT **rot_amplitude, FLOAT **rot_ptype
);
STATUS avecrushpepowscale(
    FLOAT *scale_fact, INT num_encodes, INT overscans, int even_sym,
    float crush_area, float encode_area
);
STATUS avepepowscale(
    FLOAT *scale_fact, INT num_encodes, INT overscans
);
STATUS b0Dither_ifile(
    FLOAT *dither_val, INT control, DOUBLE dx, DOUBLE dy, DOUBLE dz,
    DOUBLE agxw, INT esp, INT nslices, INT debug,
    long (*rsprot)[9], FLOAT *ccinx, FLOAT *cciny, FLOAT *ccinz,
    INT *esp_in, FLOAT *fesp_in, FLOAT *g0, INT *num_elements, INT *exist
);
STATUS b0DitherFile(
    FLOAT *dither_val, INT control, DOUBLE dx, DOUBLE dy, DOUBLE dz,
    DOUBLE agxw, INT esp, INT nslices, INT debug,
    long (*rsprot)[9], FLOAT *buffer
);
STATUS blipcorr(
    INT *ia_gyb_corr, DOUBLE da_gyb_corr, INT debug, long (*rsprot)[9],
    DOUBLE mult_fact, INT xfs, INT yfs, INT zfs, DOUBLE itx, DOUBLE ity,
    DOUBLE itz, INT control, INT nslices, LOG_GRAD *lgrad, INT pw_gyb,
    INT pw_gyba, DOUBLE a_gxw
);
STATUS blipcorrdel(
    FLOAT *bc_delx, FLOAT *bc_dely, FLOAT *bc_delz, INT esp, INT coiltype,
    INT debug
);
STATUS calcB1Val(
    DOUBLE *b1Val, DOUBLE *scale, const RF_PULSE *rfpulse, const INT pulse,
    const UCHAR active, const INT e_flag
);
STATUS calcfilter(
    FILTER_INFO *echortf, DOUBLE des_bandwidth, INT outputs,
    RBW_UPDATE_TYPE update_rbw
);
double calcCoilWeight(
    const TX_COIL_INFO txCoil, const double weight
);
STATUS calcDualJstd(
    double *jstd, double *meanJstd, const double weight,
    const TX_COIL_INFO txCoil, const int gradcoil, const int field
);
double calcExtremityLimit(
    const TX_COIL_INFO txCoil, const double mass, const double maxExtremity,
    const double maxBody
);
STATUS calcIntegratedB1Squared(
    DOUBLE *b1Sqr, DOUBLE *scale, const RF_PULSE *rfpulse, const INT pulse,
    const UCHAR active, const INT e_flag
);
STATUS calcJstd(
    double *jstd, const double weight, const TX_COIL_INFO txCoil,
    const int gradcoil, const int field
);
STATUS calcMeanJstd(
    double *meanJstd, const double weight, const TX_COIL_INFO txCoil,
    const int gradcoil, const int field
);
STATUS calcOptimizedPulses(
    LOG_GRAD *p_loggrd, FLOAT *Pidbdtper, FLOAT *derate_factor,
    const FLOAT cf_dbdt_per, const INT core_index, const INT debug_level,
    const INT e_flag, const INT higher_dbdt_mode
);
STATUS calcPulseB1Rms(
    DOUBLE *b1RMSVal, DOUBLE *scale, const RF_PULSE *rfpulse, const INT pulse,
    const UCHAR active, const INT e_flag
);
STATUS calcRfForward(
    double *rfforward, const double weight, const TX_COIL_INFO txCoil,
    const int gradcoil, const int field
);
STATUS calcRFPower(
    double *power_factor, double *coil_jstd, const TX_COIL_INFO txCoil
);
STATUS calcTGLimit(
int *tgcap_output, int *tgwindow_output, const float maxB1Seq, const TX_COIL_INFO txCoil
);
DOUBLE calcStdRF(
    const RF_PULSE *rfpulse, const DOUBLE b1Val, const double gamma_factor
);
STATUS calctrap1stmom(
    FLOAT *moment, DOUBLE ampl, INT attack, INT plateau, INT decay,
    DOUBLE timeref
);
STATUS calcvalidrbw(
    DOUBLE des_bandwidth, FLOAT *rbw, FLOAT *max_bw,
    FLOAT *decimation, RBW_UPDATE_TYPE override_rbw, INT vrgf_samp
);
STATUS coilB1Limit(
    double *B1_limit, const TX_COIL_INFO txCoil
);
STATUS crusherutil(
    FLOAT *crusher_scale, INT psd_type
);
STATUS dbdtderate(
    LOG_GRAD *lgrad, INT debug
);
STATUS dual_peakrf_coil(
    DOUBLE *peak_output, DOUBLE *mean_peak_output, DOUBLE *est_jstd,
    DOUBLE *mean_est_jstd, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry, const INT activeExciter, const TX_COIL_INFO txCoil
);
STATUS dump_Data_Acquisition_Order_Table(
    INT numAcqs, INT sl_in_pass[]
);
void dump_filter_info(
    const FILTER_INFO *filtinfo
);
void dump_runtime_filter_info(
    const PSD_FILTER_GEN *filtgen
);
STATUS dump_Scan_Rsp_Info_Table(
    INT num_slice
);
STATUS endview(
    INT resolution, INT *last_phase_iamp
);
STATUS entrytabinit(
    ENTRY_POINT_TABLE *entryPoint, INT numEntries
);
STATUS epiRFP_mxwl(
    INT nslices, INT nileaves, INT etl, INT esp, DOUBLE tsp,
    DOUBLE xtr_rba_time, DOUBLE frtime, INT fast_rec, DOUBLE opfov,
    INT opyres, DOUBLE oprbw, DOUBLE fovar, INT frsize, FLOAT *b0_dither_val,
    INT spgr_flag, INT **rf_phase_spgr, INT dro, INT dpo, FLOAT *dpo_shift,
    RSP_INFO *rspinfo, INT *view1st, INT *viewskip, INT *gradpol,
    INT ref_mode, INT kydir, INT dc_chop_flag, INT pepolar_flag,
    INT ***recv_freq, DOUBLE ***recv_phase_angle, INT ***recv_phase_ctrl,
    FLOAT *gldelayfval, DOUBLE ampgxw, INT debug
);
STATUS epiRecvFrqPhs(
    INT nslices, INT nileaves, INT etl,
    DOUBLE xtr_rba_time, FLOAT *reftime, DOUBLE frtime, DOUBLE opfov,
    INT opyres, DOUBLE fovar, FLOAT *b0_dither_val,
    INT **rf_phase_spgr, INT dro, INT dpo, RSP_INFO *rspinfo,
    INT *view1st, INT *viewskip, INT *gradpol, INT ref_mode, INT kydir,
    INT dc_chop_flag, INT pepolar_flag, INT ***recv_freq,
    DOUBLE ***recv_phase_angle, INT ***recv_phase_ctrl, FLOAT *gldelayfval,
    DOUBLE ampgxw, INT debug, INT refxoff, FLOAT asset_factor, INT iref_etl
);
STATUS epigradopt(
    OPT_GRAD_INPUT *gradin, OPT_GRAD_PARAMS *gradout, FLOAT *pidbdtts,
    FLOAT *pidbdtper, DOUBLE cfdbdtts, DOUBLE cfdbdtper, DOUBLE cfdbdtdx,
    DOUBLE cfdbdtdy, INT reqesp, INT autogap, INT rampsamp, INT vrgsamp,
    INT debug
);
void error_out(
    CHAR *message, INT line, CHAR *file
);
void error_param(
    CHAR *message, INT line, CHAR *file
);
STATUS extractActivePowerMonValues(
    ENTRY_POINT_TABLE *entryPoint, const TX_COIL_INFO txCoil,
    int *pm_amp, int *pm_pw, int *pm_dc
);
STATUS extractPowerMonValues(
    ENTRY_POINT_TABLE *entryPoint, const int pmchannel,
    int *pm_amp, int *pm_pw, int *pm_dc
);
STATUS filterutilv6(
    FILTER_INFO *echo1rtf, FILTER_INFO *echo2rtf, INT outputs,
    DOUBLE fnecholim, INT pwramp, INT read_timel, INT read_timer,
    INT read_wingl, INT read_wingr, INT read_wing2l, INT read_wing2r,
    INT treadvbw, INT maxseqtime
);
STATUS fitresol(
    SHORT *resolution, INT *pulsewidth, INT maxlimit, INT minlimit, INT cycle
);
STATUS fpntoxyz(
    long (*rotmit)[9], INT slquant, FLOAT (*xyz)[3], RSP_INFO *fpn,
    LOG_GRAD *lgrad, PHYS_GRAD *pgrad, INT contdebug
);
STATUS fractecho(
    INT *tfe_extra, DOUBLE fnecho_lim, INT seq_type, INT min_tenfe,
    INT read_pw, INT max_gx1time, DOUBLE amp_targetx, INT target_xrt,
    INT xres, DOUBLE fov
);
STATUS fseminti(
    INT *mintitime, INT hrf0, INT pw_gzrf0d, INT cs_sattime, INT sp_sattime,
    INT satdelay, INT t_exa
);
STATUS getActivePowerMonPeakLimits(
    double *fsrf, double *fspw, double *fsdc, const int field
);
STATUS getPowerMonPeakLimits(
    double *fsrf, double *fspw, double *fsdc, const int field,
    const int pmchannel
);
INT get_grad_dly(
    void
);
FLOAT get_max_rbw_hw(
    void
);
INT get_rf_dly(
    void
);
INT get_tsp_mgd (
    void
);
STATUS getCornerPoints(
    FLOAT **time, FLOAT *ampl[3], FLOAT *pul_type[3], INT *num_totpoints,
    const LOG_GRAD *log_grad, const INT seq_entry_index, const INT samp_rate,
    const INT min_tr, const FLOAT dbdtinf, const FLOAT dbdtfactor,
    const FLOAT efflength, const dbLevel_t debug
);
STATUS getfiltparams(
    INT decimation, INT outputs, INT *filtertaps, INT *prefills,
    FLOAT *filtergain, INT *minesp, INT xtr_pkt_off
);
STATUS getGamma(
    FLOAT* gamma,
    INT nucleus
);
CHAR *getGradType(
    const INT ptype
);
void
getSilentSpec(
     INT silent, INT *Gctrl, FLOAT *Glimit, FLOAT *Srate
);
STATUS genVRGF(
    OPT_GRAD_PARAMS *gradout, INT xres, DOUBLE period, DOUBLE tamp,
    DOUBLE tfthw, DOUBLE tadw, DOUBLE alpha, DOUBLE beta
);
STATUS highlow(
    INT *low, INT *high, INT resolution, SHORT *waveform
);
STATUS ileaveinit(
    INT nframes, INT kydir, INT intleaves, INT alt_fact, INT gpolarity,
    INT bpolarity, INT debug, INT rfamp, INT blipamp,
    INT pepolarity, INT etl, INT seqdata, DOUBLE tshift, INT tfon,
    INT fract_ky, DOUBLE ky_off, INT overscan, INT pe_end_iamp, INT esp,
    DOUBLE tsp, INT samples, DOUBLE ro_amp, INT xft_size, INT slquant,
    INT lpf, INT iref_etl, INT *gy1f, INT *view1st, INT *viewskip, INT *tf,
    INT *rfpol, INT *gradpol, INT *blippol, INT *mintf
);
STATUS imgtimutil(
    LONG premidRF1_time, LONG acqType, LONG gating, LONG *availimagetime
);
STATUS initfilter(
    void
);
STATUS inittargets(
    LOG_GRAD *lgrad, PHYS_GRAD *pgrad
);
STATUS insertActivePowerMonValues(
     ENTRY_POINT_TABLE *entryPoint, const TX_COIL_INFO txCoil,
     int pm_amp, int pm_pw, int pm_dc
);
STATUS insertPowerMonValues(
     ENTRY_POINT_TABLE *entryPoint, const int pmchannel,
     int pm_amp, int pm_pw, int pm_dc
);
STATUS l_p_transver(
    FLOAT *phy, FLOAT a, FLOAT b, FLOAT c, DOUBLE logx, DOUBLE logy, DOUBLE logz
);
STATUS matrixcheck(
    INT maxx, INT maxy
);
STATUS matrixcheck_ext(
    INT max_x, INT max_y, INT min_yres
);
STATUS maxfov(
    FLOAT *Maxfov
);
STATUS maxnecho(
    INT *Maxnecho, LONG nonTEtime, LONG maxSeqTime, INT echoType
);
STATUS maxpass(
    INT *Maxpass, INT acqType, INT numLocs, INT locsPerPass
);
STATUS maxphases(
    INT *Maxphases, LONG seqTimPresc, INT acqType, LONG otherslicelimit
);
STATUS maxsar(
    INT *Maxseqsar, INT *Maxslicesar, DOUBLE *Avesar, DOUBLE *Cavesar,
    DOUBLE *Pksar, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry, const int TR_val
);
STATUS maxsar_coil(
    INT *Maxseqsar, INT *Maxslicesar, DOUBLE *Avesar, DOUBLE *Cavesar,
    DOUBLE *Pksar, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry, const TX_COIL_INFO txCoil,
    const INT activeExciter, const int TR_val
);
STATUS maxsar_exciter(
    INT *Maxseqsar_exciter, INT *Maxslicesar_exciter, DOUBLE *Avesar_exciter,
    DOUBLE *Cavesar_exciter, DOUBLE *Pksar_exciter, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry, const int TR_val, INT *exciterUsedFlag
);
STATUS maxseqsar(
    INT *Maxseqsar, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry
);
STATUS maxseqsar_b1scale(
    INT *Maxseqsar, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry
);
STATUS maxseqslicesar(
    INT *Maxseqsar, INT *Maxslicesar, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry
);
STATUS maxslicesar(
    INT *Maxslicesar, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry
);
STATUS maxslicesar_b1scale(
    INT *Maxslicesar, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry
);
STATUS maxslicesar_modified(
    LONG *Maxslicesar, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry, const int tr_val
);
STATUS maxslquant(
    INT *Maxslquant, INT repetitionTime, INT otherslicelimit, INT acqType,
    INT seqTimPresc
);
STATUS maxslquant1(
    INT Maxslquant, INT *repetitionTime, INT acqType, INT seqTimPresc,
    INT gating
);
STATUS
maxslquanttps( INT *Maxslquanttps,
               const INT imageSize,
               const INT siSize,
               const INT numTemporalPhases,
               const MAXSLQUANTTPS_OPTION *option
);
STATUS maxte1(
    LONG *Maxte1, LONG maxSeqTime, INT echoType, LONG nonTEtime, INT min_fullte
);
STATUS maxte2(
    LONG *Maxte2, LONG maxSeqTime, LONG nonTEtime
);
STATUS maxti(
    INT *maxtitime, INT gating, INT te_time, INT nonteti, INT slquant_one,
    INT tmin, INT left_rf0_time, INT left_rf1_time
);
STATUS maxti_rep(
    INT *maxtitime, INT gating, INT te_time, INT nonteti, INT slquant_one,
    INT tmin, INT left_rf0_time, INT left_rf1_time, INT num_reps
);
STATUS maxtr(
    INT *Maxtr
);
STATUS maxwellcomp(
    FLOAT *a_mid, INT *pw_attack, INT *pw_mid, INT *pw_decay, DOUBLE maxterm,
    DOUBLE a_start, DOUBLE targetAmp, INT riseTime, FLOAT *r1, FLOAT *r2,
    FLOAT *r3
);
STATUS maxwell_pc_calc(
    INT max_flag, INT num_points, INT debug, INT pwgx1a, INT pwgx1, INT pwgx1d,
    INT pwgxfca, INT pwgxfc, INT pwgxfcd, INT pwgz1a, INT pwgz1, INT pwgz1d,
    INT pwgzfca, INT pwgzfc, INT pwgzfcd, INT pwgyfe1a, INT pwgyfe1,
    INT pwgyfe1d, INT pwgxwa, INT pwgy1a, INT pwgy1, INT pwgy1d, INT pwgzrf1d,
    DOUBLE flow_wdth_x, DOUBLE flow_wdth_z, INT iagx1fen, INT iagx1feu,
    INT iagx1fed, INT iagx2fen, INT iagx2feu, INT iagx2fed, INT iagz1fen,
    INT iagz1feu, INT iagz1fed, INT iagz2fen, INT iagz2feu, INT iagz2fed,
    INT iagy1feu, INT iagy1fed, INT iagy2feu, INT iagy2fed, DOUBLE agxw,
    DOUBLE agzrf1, long *rotmat, FLOAT *maxcoef1a, FLOAT *maxcoef1b,
    FLOAT *maxcoef1c, FLOAT *maxcoef1d, FLOAT *maxcoef2a, FLOAT *maxcoef2b,
    FLOAT *maxcoef2c, FLOAT *maxcoef2d, FLOAT *maxcoef3a, FLOAT *maxcoef3b,
    FLOAT *maxcoef3c, FLOAT *maxcoef3d
);
STATUS maxyres(
    INT *Maxyres, DOUBLE targetAmp, INT ramp_time, INT avaiPhaseTime,
    DOUBLE fov, GRAD_PULSE *gradstruct_y, INT stepsize
);
STATUS mean_peakrf_coil(
    DOUBLE *mean_peak_output, DOUBLE *mean_est_jstd, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry, const INT activeExciter,
    const TX_COIL_INFO txCoil
);
STATUS minfov(
    FLOAT *Minfov, GRAD_PULSE *gradstruct, DOUBLE foview, INT seq_type,
    INT phase_time, INT freq_time, DOUBLE readout_BW,
    INT phase_encode_resolution, INT existyres, INT phasestep,
    DOUBLE yaspect_ratio, INT flow_comp_type, INT readout_pw,
    DOUBLE fractecho_fact, DOUBLE gxwtargetamp, DOUBLE gx1targetamp,
    INT ramp2xtarget, DOUBLE gy1targetamp, INT ramp2ytarget
);
STATUS
minpulsesep (
    INT *Minpulsesep,
    const INT pwgzrf1d,
    const INT pwgzrf2l1a,
    const INT pwgzrf2l1,
    const INT pwgzrf2l1d
);
STATUS minseq(
    INT *p_minseqgrad,
    GRAD_PULSE *gradx, const INT gx_free, GRAD_PULSE *grady, const INT gy_free,
    GRAD_PULSE *gradz, const INT gz_free, const LOG_GRAD *loggrd,
    const INT seq_entry_index, const INT samp_rate, const INT min_tr,
    const INT e_flag, const INT debug_flag
);
STATUS minseqcoil(
    INT *minseqtime, FLOAT *xa2s, FLOAT *ya2s, FLOAT *za2s, INT srmode,
    GRAD_PULSE *gradx, GRAD_PULSE *grady, GRAD_PULSE *gradz, INT numXpulse,
    INT numYpulse, INT numZpulse, DOUBLE gcontirms
);
STATUS minseqcable(
    INT *minseqtime, FLOAT *xa2s, FLOAT *ya2s, FLOAT *za2s, INT srmode,
    GRAD_PULSE *gradx, GRAD_PULSE *grady, GRAD_PULSE *gradz, INT numXpulse,
    INT numYpulse, INT numZpulse, DOUBLE gcontirms, INT tmin_minseq
);
STATUS minseqbusbar(
    INT *minseqtime,
    INT minseqcable,
    INT tmin_minseq
);
STATUS minseqgrad(
    INT *minseqgrddrv, INT *minseqgrddrvx, INT *minseqgrddrvy,
    INT *minseqgrddrvz, INT *ro_time, INT *pe_time, INT *ss_time, INT *px_time,
    INT *py_time, INT *pz_time, GRAD_PULSE *gradx, GRAD_PULSE *grady,
    GRAD_PULSE *gradz, INT numx, INT numy, INT numz, const LOG_GRAD *lgrad,
    PHYS_GRAD *pgrad, SCAN_INFO *scaninfotab, INT slquant, INT plane_type,
    INT coaxial, INT _sigrammode, INT debug, FLOAT *amptrans_px,
    FLOAT *amptrans_py, FLOAT *amptrans_pz, FLOAT *amptrans_lx,
    FLOAT *amptrans_ly, FLOAT *amptrans_lz, FLOAT *abspower_px,
    FLOAT *abspower_py, FLOAT *abspower_pz, FLOAT *abspower_lx,
    FLOAT *abspower_ly, FLOAT *abspower_lz, FLOAT *power_lx,
    FLOAT *pospower_lx, FLOAT *negpower_lx, FLOAT *power_ly,
    FLOAT *pospower_ly, FLOAT *negpower_ly, FLOAT *power_lz,
    FLOAT *pospower_lz, FLOAT *negpower_lz, INT *minseqgpm
);
STATUS minseqgram(
    INT *minseqtime, INT *ro_time, INT *pe_time, INT *ss_time, INT *px_time,
    INT *py_time, INT *pz_time, GRAD_PULSE *gradx, GRAD_PULSE *grady,
    GRAD_PULSE *gradz, INT numx, INT numy, INT numz, PHYS_GRAD *pgrad,
    SCAN_INFO *scaninfotab, INT slquant, INT plane_type, INT coaxial,
    INT _sigrammode, INT debug, FLOAT *amptrans_px, FLOAT *amptrans_py,
    FLOAT *amptrans_pz, FLOAT *amptrans_lx, FLOAT *amptrans_ly,
    FLOAT *amptrans_lz, FLOAT *abspower_px, FLOAT *abspower_py,
    FLOAT *abspower_pz, FLOAT *abspower_lx, FLOAT *abspower_ly,
    FLOAT *abspower_lz
);
STATUS minseqgrddrv(
    LONG *minseqtime, FLOAT *power, FLOAT *pospower, FLOAT *negpower,
    INT numPulses, GRAD_PULSE *grad, INT gramtype, DOUBLE irmspos,
    DOUBLE irmsneg, DOUBLE irms, DOUBLE ampgcmfs, DOUBLE gcmfs
);
STATUS minseqrfamp(
    INT *Minseqrfamp, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry
);
STATUS minseqrfamp_b1scale(
    INT *Minseqrfamp, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry
);
STATUS minseqrfamp_coil(
    INT *Minseqrfamp, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry, const INT activeExciter, const TX_COIL_INFO txCoil
);
STATUS minseqrfamp_exciter(
    INT *Minseqrfamp_exciter, const INT numPulses, const RF_PULSE *rfpulse,
    const INT entry, INT *exciterUsedFlag
);
STATUS minseqsys(
    INT *Minseqsys
);
STATUS minte1_enh(
    INT *Minte1, INT yresolution, DOUBLE foview, INT min_seq1, INT min_seq2,
    INT min_seq3, INT seq_type, INT echo_type, INT read_pw, DOUBLE left_wing_area, INT iso_delay,
    INT rf_180_pw, INT flow_comp_type, DOUBLE fnecho_lim,
    GRAD_PULSE *gradstruct_y, DOUBLE gxw_target, DOUBLE gx1_target,
    INT pw_rampx
);
STATUS minte1(
    INT *Minte1, INT yresolution, DOUBLE foview, INT min_seq1, INT min_seq2,
    INT min_seq3, INT seq_type, INT echo_type, INT read_pw, INT iso_delay,
    INT rf_180_pw, INT flow_comp_type, DOUBLE fnecho_lim,
    GRAD_PULSE *gradstruct_y, DOUBLE gxw_target, DOUBLE gx1_target,
    INT pw_rampx
);
STATUS minte2(
    INT *Minte2, INT tfe_extra, INT min_seq1, INT min_seq2, INT seq_type,
    INT echo_type, INT read_pw1, DOUBLE amp_read1, INT read_pw2,
    DOUBLE amp_read2, INT flow_comp_type, DOUBLE target_ampx, INT target_xrt
);
STATUS minti(
    INT *Minti, INT slquant1, INT tmin, INT tileftovers, INT sat2flag
);
STATUS mintr(
    LONG *Mintr, INT acqType, LONG minseqTime, INT Slquant1, INT gating
);
STATUS modrotmats(
    long (*inrot)[9], long (*outrot)[9], INT alpha, INT beta, INT gamma,
    INT slquant, INT debug
);
STATUS newrotatearray(
    long (*inrot)[9], long (*outrot)[9], DOUBLE alpha, DOUBLE beta,
    DOUBLE gamma, INT slquant, LOG_GRAD *lgrad, PHYS_GRAD *pgrad,
    INT contdebug
);
STATUS obloptimize(
    LOG_GRAD *lgrad, PHYS_GRAD *pgrad, SCAN_INFO *scaninfotab,
    INT slquant, INT plane_type, INT coaxial, INT method, INT debug,
    INT *newgeo, INT srmode
);
STATUS obloptimize_epi(
    LOG_GRAD *lgrad, PHYS_GRAD *pgrad, SCAN_INFO *scaninfotab,
    INT slquant, INT plane_type, INT coaxial, INT method, INT debug,
    INT *newgeo, INT srmode
);
STATUS obloptimizecalc(
    LOG_GRAD *lgrad, PHYS_GRAD *pgrad, SCAN_INFO *scaninfotab,
    INT slquant, INT plane_type, INT coaxial, INT method, INT debug,
    INT *newgeo, INT srmode, INT epimode
);
STATUS OpenDelayFile(
    FLOAT *buffer
);
STATUS OpenDitherFile(
    INT coiltype, FLOAT *buffer
);
STATUS OpenDitherInterpoFile(
    INT coiltype, FLOAT *ccinx, FLOAT *cciny, FLOAT *ccinz, INT *esp_in,
    FLOAT *fesp_in, FLOAT *g0, INT *num_elements, INT *exist
);
STATUS optdda(
    INT *dda, INT T1_dda
);
STATUS opt_pw_amp(
    DOUBLE area, DOUBLE targetamp, DOUBLE maxamp, INT rmp2fs, DOUBLE *amp,
    INT *c_pw, INT *a_pw, INT *d_pw
);
STATUS optgmn(
    DOUBLE a_left, INT pw_lefta, INT pw_left, INT pw_leftd, DOUBLE a_right,
    INT pw_righta, INT pw_right, INT pw_rightd, FLOAT *a_mid, INT *pw_mida,
    INT *pw_mid, INT *pw_midd, DOUBLE rate, INT *pos_mid, INT *pos_right
);
STATUS optramp(
    LONG *pulsewidth, DOUBLE ampdelta, DOUBLE maxamp, INT rmp2fullscale,
    INT defineType
);
STATUS optspecir(
    FLOAT *opttheta, INT *maxti, INT soltype
);
STATUS orderphases(
    SHORT *phase2view, INT respCompType, INT phaseRes
);
STATUS pcflowtarget(
    INT flaxx, INT flaxy, INT flaxz, DOUBLE derate_factor, FLOAT *xtarget,
    FLOAT *ytarget, FLOAT *ztarget, LOG_GRAD *Loggrdp, INT derate_flag
);
STATUS peakAveSars(
    double *Avesar, double *Cavesar, double *Pksar, const int numPulses,
    const RF_PULSE *rfpulse, const int entry, const int tr_val
);
STATUS peakB1(
    FLOAT *maxB1Val, const INT entryPoint, const INT numPulseEntries,
    const RF_PULSE *rfpulse
);
STATUS peakB1_exciter(
    FLOAT *maxB1Val, const INT entryPoint, const INT numPulseEntries,
    const RF_PULSE *rfpulse, const INT activeExciter
);
STATUS peakrf(
    DOUBLE *peak_output, DOUBLE *est_jstd, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry
);
STATUS peakrf_coil(
    DOUBLE *peak_output, DOUBLE *est_jstd, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry, const INT activeExciter,
    const TX_COIL_INFO txCoil
);
STATUS peakrf_exciter(
    DOUBLE *peak_output_exciter, DOUBLE *est_jstd_exciter, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry, INT *exciterUsedFlag
);
INT phase_order_fgre3d(
     SHORT *view_tab, INT phase_order, INT rspviews, INT viewoffset,
     INT nframes, INT noverscans, FLOAT fractnex
);
STATUS power_peraxis(
    FLOAT *power, INT numPulses, GRAD_PULSE *grad
);
STATUS power_peraxis_cable(
    FLOAT *power, INT numPulses, GRAD_PULSE *grad
);
STATUS powermon(
    ENTRY_POINT_TABLE *entryPoint, const INT entry, const INT numPulses,
    const RF_PULSE *rfpulse, const INT sarTseq
);
s16 scalePowermonWatts (
    const float wattsperkg
);
STATUS prescanslice(
    INT *slpass, INT *sltime, LONG numLocs
);
STATUS prescanslice1(
    INT *preslorder, INT pre_slquant, LONG numLocs
);
STATUS printGRADPULSE( GRAD_PULSE *pulse );
STATUS printRFPULSE( RF_PULSE *pulse );
STATUS printLOGGRAD( LOG_GRAD *pulse );
STATUS printPHYSGRAD( PHYS_GRAD *pulse );
STATUS printARGS( CHAR *routine, ... );
INT psd_getgradmode(
    void
);
void psd_dump_scan_info(
    void
);
void psd_dump_rsp_info(
    void
);
void psd_dump_coil_info(
    void
);
STATUS rampmoments(
    DOUBLE ampinitial, DOUBLE ampfinal, INT duration, INT invertphaseflag,
    INT *pulsepos, FLOAT *zerothmoment, FLOAT *firstmoment,
    FLOAT *zeromomentsum, FLOAT *firstmomentsum
);
STATUS readgrdcfg(
    void
);
void rfB1opt(
    void
);
void rfB1optplus(
    void
);
STATUS rfsafetyopt(
    FLOAT *opt_deratingfactor, INT rfscale_flag, FLOAT *orig_rfscale,
    FLOAT *limit_scale_seed, INT rf1slot, RF_PULSE *rfpulse,
    RF_PULSE_INFO *rfpulseInfo
);
STATUS scale(
    FLOAT (*inrotmat)[9], long (*outrotmat)[9], INT slquant, LOG_GRAD *lgrad,
    PHYS_GRAD *pgrad, INT contdebug
);
STATUS scalerfpulses(
    const DOUBLE weight, const INT gcoiltype, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry, RF_PULSE_INFO *rfpulseInfo
);
STATUS scalerfpulses_derate(
    const DOUBLE weight, const INT gcoiltype, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry, RF_PULSE_INFO *rfpulseInfo,
    const INT b1_derate_type
);
STATUS scalerfpulses_coil(
    const DOUBLE weight, const INT gcoiltype, const INT numPulses,
    const RF_PULSE *rfpulse, const INT entry, RF_PULSE_INFO *rfpulseInfo,
    const int derate_type, const TX_COIL_INFO txCoil,
    const INT activeExciter
);
STATUS scalerfpulses2ut(
    const DOUBLE derateb1, const INT updatetime, const RF_PULSE *rfpulse,
    const INT entry, const INT pulse, RF_PULSE_INFO *rfpulseInfo,
    const INT activeExciter
);
STATUS scalerfpulsescalc(
    const INT oldpwrf, INT newpwrf, const INT updatetime,
    const RF_PULSE *rfpulse, const INT entry, const INT pulse,
    RF_PULSE_INFO *rfpulseInfo, const INT activeExciter
);
STATUS scaninfotab_init(
    SCAN_INFO *scaninfotab, INT plane_type, INT slquant, INT debug
);
STATUS setfilter(
    FILTER_INFO *echofilt, FILTER_BLOCK_TYPE type
);
STATUS setGradCalcMethod(
    const INT gradmethod, const INT e_flag
);
STATUS setPowerMonAmplitudeLimit(
    ENTRY_POINT_TABLE *entryPoint, const INT entry, const INT numPulses,
    const RF_PULSE *rfpulse, const INT *txIndexUsed, const INT *exciterUsed,
    const INT numTxIndexUsed, const double pk_sar, const double avg_sar,
    const double *pmlim
);
STATUS setPowerMonDutyCycleLimit(
    ENTRY_POINT_TABLE *entryPoint, const INT entry, const INT numPulses,
    const RF_PULSE *rfpulse, const INT *txIndexUsed, const INT *exciterUsed,
    const INT numTxIndexUsed, const int sarTseq, const double *pmlim
);
STATUS setPowerMonPulseLimits(
    ENTRY_POINT_TABLE *entryPoint, const INT entry, const INT numPulses,
    const RF_PULSE *rfpulse, const int sarTseq, const double pk_sar,
    const double avg_sar
);
STATUS setPowerMonWidthLimit(
    ENTRY_POINT_TABLE *entryPoint, const INT entry, const INT numPulses,
    const RF_PULSE *rfpulse, const INT *txIndexUsed, const INT *exciterUsed,
    const INT numTxIndexUsed, const double *pmlim
);
STATUS setrfpulsepointers(
    const INT slot, INT *pw, FLOAT *amp, FLOAT *act_fa,
    INT *res, INT *exciter, RF_PULSE *rfpulse
);
STATUS setScale(
    const INT entryPoint, const INT numPulseEntries, const RF_PULSE *rfpulse,
    const FLOAT maxB1, const FLOAT extraScale
);
STATUS setUniversalPowerMonLimits(
    average_mode_dump_t *amd
);
STATUS
set_grad_spec(
    INT spec_ctrl,FLOAT g_max,FLOAT s_rate,INT duty_limit,INT debug
);
STATUS setsysparms(
    void
);
STATUS setupConfig(
    void
);
STATUS setupPowerMonitor(
    ENTRY_POINT_TABLE *entryPoint, const INT entry, const INT numPulses,
    const RF_PULSE *rfpulse, const int sarTseq, const double avg_sar,
    const double coil_sar, const double pk_sar
);
STATUS setuprfpulse(
    const INT slot, INT *pw, FLOAT *amp, const DOUBLE abswidth,
    const DOUBLE effwidth, const DOUBLE area, const DOUBLE dtycyc,
    const DOUBLE maxpw, const INT num, const DOUBLE max_b1,
    const DOUBLE max_int_b1_sq, const DOUBLE max_rms_b1, const DOUBLE nom_fa,
    FLOAT *act_fa, const DOUBLE nom_pw, const DOUBLE nom_bw,
    const UINT activity, const UCHAR reference, const INT isodelay,
    const DOUBLE scale, INT *res, const INT extgradfile, INT *exciter,
    RF_PULSE *rfpulse
);
STATUS setupslices(
    INT *sliceTab, RSP_INFO *rspInfoTab, INT numLocs, DOUBLE gradStrength,
    DOUBLE receiveBW, DOUBLE fov, INT transmitFlag
);
STATUS seqtime(
    LONG *Seqtime, LONG availimagetime, INT Slquant1, INT acqType
);
STATUS seqtype(
    LONG *Seqtype
);
STATUS slicein1(
    INT *Slquant1, INT numAcqs, INT acqType
);
STATUS slicesort(
    INT *Slquant1, INT *sl_pass, INT *sl_angle, INT maxlocsPerPass,
    INT *numAcqs, INT *numAngles, INT MaxAcq, INT acqType
);
STATUS
setAccelPulldown( const float arc_ph_maxnetaccel,
    const float arc_sl_maxnetaccel, float* piaccel_phval2, float* piaccel_phval3, float* piaccel_phval4,
    float* piaccel_phval5, float* piaccel_phval6, int* piaccel_phnub, int* piaccel_phedit,
    float* piaccel_slval2, float* piaccel_slval3, float* piaccel_slval4, float* piaccel_slval5,
    float* piaccel_slval6, int* piaccel_slnub, int* piaccel_sledit, float *ph_stepsize,
    float *sl_stepsize
);
STATUS specparamset(
    FLOAT* gamma, INT* bbandfilt, INT* xmtband, INT nucleus
);
STATUS trapmaxwell(
    DOUBLE a_start, INT pw_attack, DOUBLE a_mid, INT pw_mid, DOUBLE a_end,
    INT pw_decay, FLOAT *maxterm
);
STATUS trapvals(
    DOUBLE area, INT *a_pw, INT *d_pw, FLOAT *amp, INT *c_pw, INT def_type
);
STATUS UpdateEntryTabRecCoil(
    ENTRY_POINT_TABLE *entryTab,
    INT index
);
STATUS unscale(
    long (*inrotmat)[9], FLOAT (*outrotmat)[9], INT slquant, LOG_GRAD *lgrad,
    PHYS_GRAD *pgrad, INT contdebug
);
STATUS updateIndex(
    int *index
);
STATUS updaterfpulse(
    const INT slot, const DOUBLE abswidth, const DOUBLE effwidth,
    const DOUBLE area, const DOUBLE dtycyc, const DOUBLE maxpw,
    const INT num, const DOUBLE max_b1, const DOUBLE max_int_b1_sq,
    const DOUBLE max_rms_b1, const DOUBLE nom_fa, const DOUBLE nom_pw,
    const DOUBLE nom_bw, const UINT activity, const UCHAR reference,
    const INT isodelay, const DOUBLE scale, const INT extgradfile,
    RF_PULSE *rfpulse
);
STATUS vrghighlow(
    INT *low, INT *high, INT resolution, SHORT *waveform
);
STATUS xyztofpn(
    long (*rotmit)[9], INT slquant, FLOAT (*xyz)[3], RSP_INFO *fpn,
    LOG_GRAD *lgrad, PHYS_GRAD *pgrad, INT contdebug
);
STATUS zoom_limit(
    INT *index_limit, FLOAT *off_cent_dist,
    INT app_grad_type, INT grad_mode, INT zoom_coil_index,
    FLOAT zoom_fov_xy, FLOAT zoom_fov_z,
    FLOAT zoom_dist_ax, FLOAT zoom_dist_cor, FLOAT zoom_dist_sag,
    DOUBLE foview, DOUBLE fov_phase_frac, INT imag_plane,
    INT slquant, SCAN_INFO *scaninfotab
);
INT isCoilDBEnabled(
    void
);
INT getNumTxCoils(
    const COIL_INFO coilinfo[],
    const INT ncoils
);
void getTxAndExciter(
    INT *txIndex,
    INT *exciterIndex,
    INT *exciterUsed,
    INT *numTxIndexUsed,
    const COIL_INFO coilinfo[],
    const INT ncoils
);
INT getTxIndex(
    const COIL_INFO coilinfo
);
void getCoilIndex(
    INT *coilIndex, INT *indexFilled,
    const COIL_INFO coilinfo[],
    const INT ncoils, const INT txIndex
);
s32 getCoilAtten(void);
f32 getTxCoilMaxB1Peak(void);
n32 getTxCoilType(void);
n32 getRxCoilType(void);
n32 getTxPosition(void);
n32 getTxAmp(void);
n32 getAps1Mod(void);
n32 getAps1ModPlane(void);
f32 getAps1ModFov(void);
f32 getAps1ModSlThick(void);
f32 getAps1ModPsRloc(void);
f32 getAps1ModPsTloc(void);
STATUS getbeta( FLOAT *beta, WF_PROCESSOR wgname, LOG_GRAD *lgrad );
STATUS getramptime( INT *risetime, INT *falltime, WF_PROCESSOR wgname, LOG_GRAD *lgrad );
STATUS gettarget( FLOAT *target, WF_PROCESSOR wgname, LOG_GRAD *lgrad );
STATUS setxdcntrl( WF_PULSE *pulse_ptr, INT state, INT rcvr);
int sizeMaintenance(
    const char *fname, const char *pname, const int file_sz, const char *maint_msg
);
void epic_error( const int ermes, const char *plain_fmt, const int ermes_num,
                 const int num_args, ... );
int log_error(const char* pathname,const char* filename,const int headerinfo,const char* format,...);
STATUS attenlockon(
    WF_PULSE_ADDR pulse
);
STATUS attenlockoff(
    WF_PULSE_ADDR pulse
);
STATUS BoreOverTemp(
    INT monitor_temp, INT debug
);
STATUS buildinstr(
    void
);
STATUS calcdelay(
    FLOAT *delay_val, INT control, DOUBLE gldelayx,
    DOUBLE gldelayy, DOUBLE gldelayz, INT *defaultdelay, INT nslices,
    INT gradmode, INT debug, long (*rsprot)[9]
);
STATUS calcdelayfile(
    FLOAT *delay_val, INT control, DOUBLE gldelayx,
    DOUBLE gldelayy, DOUBLE gldelayz, INT *defaultdelay, INT nslices,
    INT debug, long (*rsprot)[9], FLOAT *buffer
);
LONG calciphase(
    DOUBLE phase
);
STATUS copyframe(
    WF_PULSE_ADDR pulse, LONG frame_control, LONG pass_src, LONG slice_src, LONG echo_src, LONG view_src, LONG pass_des, LONG slice_des, LONG echo_des, LONG view_des, LONG nframes, TYPDAB_PACKETS acqon_flag
);
STATUS create3dim(
    WF_PULSE_ADDR pulse, LONG pos_readout, LONG pos_ref
);
STATUS create3dim2(
    WF_PULSE_ADDR pulse, LONG pos_readout, LONG pos_ref
);
STATUS rfon(
    WF_PULSE_ADDR pulse, LONG index
);
STATUS rfoff(
    WF_PULSE_ADDR pulse, LONG index
);
STATUS scopeoff(
    WF_PULSE_ADDR pulse
);
STATUS scopeon(
    WF_PULSE_ADDR pulse
);
STATUS setPSDtags(
    WF_PULSE_ADDR pulse, WF_PGMREUSE reuse, WF_PGMTAG tag, LONG addtag, INT id, INT board_type, STATUS force
);
LONG getAmpControlBits(
    const WF_PROCESSOR type
);
STATUS getctrl(
    long *ctrl, WF_PULSE_ADDR pulse, LONG index
);
STATUS getiwave(
    long *waveform_ix, WF_PULSE_ADDR pulse, LONG index
);
STATUS getiphase(
    INT *phase, WF_PULSE_ADDR pulse, LONG index
);
STATUS getphase(
    FLOAT *phase, WF_PULSE_ADDR pulse, LONG index
);
STATUS getieos(
    SHORT *eos, WF_PULSE_ADDR pulse, LONG index
);
STATUS getpulse(
    WF_PULSE_ADDR *ret_pulse, WF_PULSE_ADDR pulse, WF_PGMTAG tagfield, INT id, LONG index
);
STATUS getRFBits(
    LONG* bits, const WF_PROCESSOR type, const WF_PGMTAG field,
    n32 selector
);
STATUS getRFPABits(
    LONG* bits, const WF_PROCESSOR type, n32 selector
);
STATUS getRFPDBits(
    LONG* bits, const WF_PROCESSOR type, n32 selector
);
STATUS getRFPemBits(
    LONG* bits, const WF_PROCESSOR type, n32 selector
);
STATUS getssppulse(
    WF_PULSE_ADDR *ssppulse, WF_PULSE_ADDR pulse, CHAR *pulsesuff, LONG index
);
STATUS getssppulse_modal(
    WF_PULSE_ADDR *ssppulse, WF_PULSE_ADDR pulse, CHAR *pulsesuff, LONG index, LONG exit_mode
);
STATUS getiamp(
    SHORT *amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS getperiod(
    long *period, WF_PULSE_ADDR pulse, LONG index
);
STATUS getwamp(
    SHORT *amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS getweos(
    SHORT *eos, WF_PULSE_ADDR pulse, LONG index
);
STATUS getwave(
    LONG *waveform_ix, WF_PULSE_ADDR pulse
);
STATUS initfastrec(
    WF_PULSE_ADDR pulse, LONG pos_ref, LONG xres, LONG tsptics, LONG deltics, LONG lpf
);
int isRFEnvelopeWaveformGenerator(
    const WF_PROCESSOR waveform_gen_rf
);
int isRFWaveformGenerator(
    const WF_PROCESSOR waveform_gen_rf
);
STATUS linkExcitersToAmplifiers(
    void
);
STATUS movewave(
    SHORT *pulse_mem, WF_PULSE_ADDR pulse, LONG index, INT resolution, HW_DIRECTION direction
);
void requestTransceiver(
    int bd_type, exciterSelection e, receiverSelection r
);
void requestTransceiverDemod(
    int bd_type, exciterSelection e, receiverSelection r, demodSelection o, navSelection n
);
void RFEnvelopeWaveformGeneratorCheck(
    const CHAR *pulse_name,
    const WF_PROCESSOR waveform_gen
);
void RFWaveformGeneratorCheck(
    const CHAR *pulse_name,
    const WF_PROCESSOR waveform_gen
);
STATUS setattenlock(
    STATUS restore_flag, WF_PULSE_ADDR pulse
);
STATUS setctrl(
    LONG ctrl_mask, WF_PULSE_ADDR pulse, LONG index
);
STATUS setfastdly(
    WF_PULSE_ADDR pulse, LONG deltics
);
STATUS setfreqphase(
    LONG frequency, LONG phase, WF_PULSE_ADDR pulse
);
STATUS setfrequency(
    LONG frequency, WF_PULSE_ADDR pulse, LONG index
);
STATUS setmrtouchdriver(
    const float freq, const int cycles, const int amp
);
void SetHWMem(
    void
);
STATUS setiamp(
    INT amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS setiampssp(
    LONG amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS setiampall(
    INT amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS setiampimm(
    INT amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS setiamptimm(
    INT amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS setiphase(
    LONG phase, WF_PULSE_ADDR pulse, LONG index
);
STATUS setphase(
    DOUBLE phase, WF_PULSE_ADDR pulse, LONG index
);
STATUS setiampt(
    INT amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS setieos(
    INT eos_flag, WF_PULSE_ADDR pulse, LONG index
);
STATUS setperiod(
    LONG period, WF_PULSE_ADDR pulse, LONG index
);
STATUS setrf(
    STATUS restore_flag, WF_PULSE_ADDR pulse, LONG index
);
STATUS setrf_ex(
    STATUS restore_flag, WF_PULSE_ADDR pulse, LONG index
);
STATUS setrf_amp(
    STATUS restore_flag, WF_PULSE_ADDR pulse, LONG index
);
STATUS setrfltrs(
    LONG filter_no, WF_PULSE_ADDR pulse
);
STATUS setEpifilter(
    LONG filter_no, WF_PULSE_ADDR pulse
);
STATUS settransceiver(
    INT board
);
STATUS setwampimm(
    INT amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS setwamp(
    INT amplitude, WF_PULSE_ADDR pulse, LONG index
);
STATUS setwave(
    WF_HW_WAVEFORM_PTR waveform_ix, WF_PULSE_ADDR pulse, LONG index
);
void simulationInit(
    long *rot_ptr
);
STATUS setweos(
    INT eos_flag, WF_PULSE_ADDR pulse, LONG index
);
STATUS sspextload(
    LONG *loc_addr, WF_PULSE_ADDR pulse, LONG index, INT resolution, HW_DIRECTION direction, SSP_S_ATTRIB s_attr
);
STATUS sspinit(
    INT psd_board_type
);
STATUS sspload(
    SHORT *loc_addr, WF_PULSE_ADDR pulse, LONG index, INT resolution, HW_DIRECTION direction, SSP_S_ATTRIB s_attr
);
STATUS syncon(
    WF_PULSE_ADDR pulse
);
STATUS syncoff(
    WF_PULSE_ADDR pulse
);
STATUS movewaversp(
    void
);
STATUS stretchpulse(
    INT oldres, INT newres, SHORT *opulse, SHORT *newpulse
);
STATUS AddToInstrQueue(
    WF_INSTR_QUEUE *queue, WF_INSTR_HDR *instr_ptr
);
ADDRESS AllocNode(
    LONG size
);
STATUS FreeNode(
    ADDRESS address
);
STATUS FreePSDHeap(
    void
);
STATUS BridgeTrap(
    WF_PULSE_ADDR *pulses, LONG n_pulses, STATUS bridge_first, WF_INSTR_QUEUE *queue
);
STATUS BuildBridgesIn(
    WF_INSTR_QUEUE *queue
);
STATUS CreatePulse(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, WF_PULSE_TYPES waveform_type, INT resol, WF_PULSE_EXT *extension, WF_HW_WAVEFORM_PTR wave_addr
);
STATUS FreePsdsQ(
    void
);
STATUS AddToPsdQ(
    WF_PULSE_ADDR pulse
);
LONG GetMinPeriod(
    WF_PROCESSOR waveform_gen, LONG pulse_width, const INT sworhw_flag
);
INT SetResol(
    LONG pulse_width, LONG min_period
);
STATUS TimeHist(
    CHAR *ipgname
);
STATUS acqctrl(
    TYPDAB_PACKETS acqon_flag, INT recvr, WF_PULSE_ADDR pulse
);
void MsgHndlr(
    const CHAR *routine, ...
);
STATUS acqq(
    WF_PULSE_ADDR pulse, LONG pos_ref, LONG dab_ref, LONG xtr_ref, LONG fslot_value, TYPDAB_PACKETS cine_flag
);
STATUS acqq2(
    WF_PULSE_ADDR dabpulse, WF_PULSE_ADDR rcvpulse, LONG pos_ref, LONG fslot_value, LONG dabstart, TYPDAB_PACKETS cine_flag, TYPACQ_PASS passthrough_flag
);
STATUS addrfbits(
    WF_PULSE_ADDR pulse, LONG offset, LONG refstart, LONG refduration
);
STATUS fastAddrfbits(
    WF_PULSE_ADDR pulse, LONG offset, LONG refstart, LONG refduration, LONG init_ublnk_time
);
STATUS setrfcontrol(
    SHORT selectamp, int mod_number, WF_PULSE_ADDR pulse, LONG index
);
STATUS
paAmpBits(
    LONG* paBits, const WF_PROCESSOR type
);
STATUS
paControlBits(
    LONG* paBits, const WF_PROCESSOR type
);
STATUS
paExciterBits(
    LONG* paBits, const WF_PROCESSOR type
);
STATUS
pdAmpBits(
    LONG* pdBits, const WF_PROCESSOR type
);
STATUS
pdControlBits(
    LONG* pdBits, const WF_PROCESSOR type
);
STATUS
pdExciterBits(
    LONG* pdBits, const WF_PROCESSOR type
);
STATUS
pemAmpBits(
    LONG* pemBits, const WF_PROCESSOR type
);
STATUS
pemControlBits(
    LONG* pemBits, const WF_PROCESSOR type
);
STATUS
pemExciterBits(
    LONG* pemBits, const WF_PROCESSOR type
);
STATUS attenflagon(
    WF_PULSE_ADDR pulse, LONG index
);
STATUS attenflagoff(
    WF_PULSE_ADDR pulse, LONG index
);
STATUS createatten(
    WF_PULSE_ADDR pulse, LONG start
);
STATUS createbits(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, INT resol, SHORT *bits_array
);
STATUS createcine(
    WF_PULSE *pulse, CHAR *name
);
STATUS createconst(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, LONG pulse_width, INT amplitude
);
STATUS createextwave(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, INT resol, CHAR *ext_wave_pathname
);
void destroyExtWave(
    void
);
void printExtWave(
    void
);
STATUS createhadamard(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, INT resol, INT amplitude, DOUBLE sep, DOUBLE ncycles, DOUBLE alpha
);
void CleanUp(
    void
);
STATUS createhsdab(
    WF_PULSE_ADDR pulse, LONG pos_ref
);
STATUS createhscdab(
    WF_PULSE_ADDR pulse,
    LONG pos_ref,
    TYPDAB_PACKETS cine_flag
);
STATUS createinstr(
    WF_PULSE_ADDR pulse, LONG start, LONG pulse_width, LONG ampl
);
STATUS createpass(
    WF_PULSE_ADDR pulse, LONG start
);
STATUS createramp(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, LONG pulse_width, INT start_amp, INT end_amp, INT resol, DOUBLE ramp_beta
);
STATUS createreserve(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, INT resol
);
STATUS createsinc(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, INT resol, INT amplitude, DOUBLE ncycles, DOUBLE alpha
);
STATUS createsinusoid(
    WF_PULSE_ADDR pulse, WF_PROCESSOR waveform_gen, INT resol, INT amplitude, DOUBLE start_phase, DOUBLE phase_length, INT offset
);
STATUS createseq(
    WF_PULSE_ADDR ssp_pulse, LONG length, long int *entry_array
);
STATUS createtraps(
    WF_PROCESSOR wgname, WF_PULSE *traparray, WF_PULSE *traparraya, WF_PULSE *traparrayd, INT ia_start, INT ia_end, DOUBLE a_base, DOUBLE a_delta, INT nsteps, INT pw_plateau, INT pw_attack, INT pw_decay, INT slope_direction, DOUBLE target_amp, DOUBLE beta
);
STATUS createubr(
    WF_PULSE_ADDR pulse, LONG pos_ref, INT board_type
);
STATUS dabrecorder(
    int record_mask
);
STATUS epiacqq(
    WF_PULSE_ADDR pulse, LONG pos_ref, LONG dab_ref, LONG xtr_ref, LONG fslot_value, TYPDAB_PACKETS cine_flag, LONG receiver_type, LONG dab_on
);
STATUS loaddab(
    WF_PULSE_ADDR pulse, LONG slice, LONG echo, LONG oper, LONG view, TYPDAB_PACKETS acqon_flag, LONG ctrlmask
);
STATUS loaddab_hub_r1(
               WF_PULSE_ADDR pulse, LONG slice, LONG echo, LONG oper, LONG view,
               LONG hubIndex, LONG r1Index, TYPDAB_PACKETS acqon_flag, LONG ctrlmask
);
STATUS loaddabwithnex(
    WF_PULSE_ADDR pulse, LONG nex, LONG slice, LONG echo, LONG oper, LONG view, TYPDAB_PACKETS acqon_flag, LONG ctrlmask
);
STATUS loaddab2(
    WF_PULSE_ADDR pulse, WF_PULSE_ADDR rbapulse, LONG slice, LONG echo, LONG oper, LONG view, TYPDAB_PACKETS acqon_flag
);
STATUS load3d(
    WF_PULSE_ADDR pulse, LONG view, TYPDAB_PACKETS acqon_flag
);
STATUS loaddabecho(
    WF_PULSE_ADDR pulse, LONG echo
);
STATUS loaddaboper(
    WF_PULSE_ADDR pulse, LONG oper
);
STATUS loaddabset(
    WF_PULSE_ADDR pulse, TYPDAB_PACKETS dab_acq, TYPDAB_PACKETS rba_acq
);
STATUS loaddabslice(
    WF_PULSE_ADDR pulse, LONG slice
);
STATUS loaddabview(
    WF_PULSE_ADDR pulse, LONG view
);
STATUS load3decho(
    WF_PULSE_ADDR pulse, LONG view, LONG echo, TYPDAB_PACKETS acqon_flag
);
STATUS loadcine(
    WF_PULSE_ADDR pulse, INT arr, INT op, LONG pview, INT frame1, INT frame2, INT frame3, INT frame4, LONG delay, LONG fslice, TYPDAB_PACKETS acqon_flag
);
STATUS loadhsdab(
    WF_PULSE_ADDR pulse, LONG slnum, LONG ecno, LONG dab_op, LONG vstart, LONG vskip, LONG vnum, LONG card_rpt, LONG k_read, TYPDAB_PACKETS acqon_flag, LONG ctrlmask
);
STATUS movewave(
    SHORT *pulse_mem, WF_PULSE_ADDR pulse, LONG index, INT resolution, HW_DIRECTION direction
);
STATUS movewaveimm(
    SHORT *pulse_mem, WF_PULSE_ADDR pulse, LONG index, INT resolution, HW_DIRECTION direction
);
STATUS linkpulses(
    INT l_arg, ...
);
STATUS pulsename(
    WF_PULSE_ADDR pulse, CHAR *pulse_name
);
STATUS scan(
    void
);
LONG pbeg(
    WF_PULSE_ADDR pulse, CHAR *pulse_name, LONG index
);
LONG pbegall(
    WF_PULSE_ADDR pulse, LONG index
);
LONG pbegallssp(
    WF_PULSE_ADDR pulse, LONG index
);
LONG pend(
    WF_PULSE_ADDR pulse, CHAR *pulse_name, LONG index
);
LONG pendall(
    WF_PULSE_ADDR pulse, LONG index
);
LONG pendallssp(
    WF_PULSE_ADDR pulse, LONG index
);
WF_INSTR_HDR *GetFreqInstrNode(
    WF_PULSE *this_pulse, LONG index, CHAR *name
);
void init_pgen_times(
    void
);
void print_pgen_times(
    void
);
void start_timer(
    long *start_time
);
void end_timer(
    long start_time, INT function_index, CHAR *name
);
LONG pmid(
    WF_PULSE_ADDR pulse, CHAR *pulse_name, LONG index
);
LONG pmidall(
    WF_PULSE_ADDR pulse, LONG index
);
void psdexit(
    INT ermes_no, INT abcode, CHAR *txt_str, const CHAR *routine, ...
);
STATUS routedataFrame(
    WF_PULSE_ADDR pulse,
    MGD_DATA_DESTINATION destination,
    INT routetype
);
STATUS routedataFrame2(
    WF_PULSE_ADDR pulse,
    MGD_DATA_DESTINATION destination
);
STATUS trapezoid(
    WF_PROCESSOR wgname, CHAR *name, WF_PULSE_ADDR pulseptr,
    WF_PULSE_ADDR pulseptra, WF_PULSE_ADDR pulseptrd, LONG pw_pulse,
    LONG pw_pulsea, LONG pw_pulsed, LONG ia_pulse, LONG ia_pulsewa,
    LONG ia_pulsewb, LONG ia_start, LONG ia_end, LONG position,
    LONG trp_parts, LOG_GRAD *loggrd
);
WF_INSTR_HDR *GetPulseInstrNode(
    WF_PULSE_ADDR pulse, LONG position
);
STATUS psd_update_spu_hrate(
    LONG hrate
);
STATUS psd_update_spu_trigger_window(
    LONG trigger_window
);
int broadcast_autovoice_init(void);
int broadcast_autovoice_timing(int delayStartOffsetMS, int acqDelayMS, int playPostMessage, int playPreMessage);
int broadcast_scan_end_for_autovoice(void);
int set_autovoice_playing_state(int playingState);
STATUS ChemSatEval( INT *time_cssat );
STATUS ChemSatFlip( INT delay_time,
      INT tetime,
      INT rc_time,
      INT slquant,
      INT tr_time );
STATUS ChemSatCheck( void );
STATUS SelectSpSpFatSatPulse(void);
STATUS ChemSatPG( INT chemsat_start, INT *cssat_index );
STATUS CsSatMod( INT num_chemsats );
STATUS CsSatPrep( INT num_chemsats );
STATUS CsSatChopKiller( INT num_chemsats );
STATUS SpSpFatSatRsp(void);
STATUS aps1(
     void
);
STATUS aps2(
     void
);
STATUS autoshim(
     void
);
STATUS calcPulseParams(
     void
);
STATUS cfh(
     void
);
STATUS cfl(
     void
);
STATUS cvcheck(
    void
);
STATUS cveval(
    void
);
STATUS cvevaliopts(
    void
);
STATUS cvfeatureiopts(
     void
);
STATUS cvinit(
     void
);
STATUS cvsetfeatures(
     void
);
STATUS fasttg(
     void
);
STATUS mps1(
    void
);
STATUS mps2(
    void
);
STATUS predownload(
     void
);
STATUS psdinit(
     void
);
void psd_init_iopts(
     void
);
STATUS pulsegen(
     void
);
STATUS scan(
    void
);
STATUS scanloop(
     void
);
STATUS syscheck(
     INT *syscheck_safety_limit, int *status_flag
);
void dummylinks( void );
STATUS cveval1(void);
STATUS getminesp( FILTER_INFO epi_filt,
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
void dummyssi(void);
STATUS setupphases(int *phase,int *freq,int slice,float rel_phase,int time_delay);
void ssisat(void);
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
int epic_checkcvs( const dbLevel_t debug );
int get_cvs_changed_flag( void );
void set_cvs_changed_flag( int flag );
void calc_menc(float *menc_factor);
void AddEncodeUp(int pos, int meg_set);
void AddEncodeDown(int pos, int meg_set);
void AddEncodeFcomp(int pos, int meg_set);
STATUS SetTouchAmpUd(int dir);
STATUS SetTouchAmpUdf(int dir);
void SetTouchAmp(int dir);
void SlideTouchTrig(void);
void NullTouchAmp(void);
void sp_init_rf( INT *pw_ptr,FLOAT *amp_ptr, FLOAT *flip_ptr,INT type,
                 RF_PULSE *rfstruct );
STATUS SpSatInit( INT sat_type);
void sp_set_num_pulses( RF_PULSE *rf_struct, GRAD_PULSE *grad_struct);
void sp_set_rfpulse( INT pulse_type, RF_PULSE *rf_struct, INT *resoln,
                     INT *pw_rf,INT *bw_rf, INT sat_band_type );
STATUS sp_set_slice_select( INT *pw_slice_select, INT *pw_slice_select_a,
                            INT *pw_slice_select_d, INT pw_rf,
                            FLOAT *amp_slice_select, INT *bw_rf,
                            DOUBLE thickness, DOUBLE targetamp,
                            INT target_rt, INT pulse_type );
STATUS sp_initrfpulseInfo( RF_PULSE_INFO rfPulseInfo[], INT pulse );
STATUS sp_scalerfpulses( DOUBLE weight, INT gcoiltype,
                         RF_PULSE rfpulse[], INT numentry,
                         RF_PULSE_INFO rfPulseInfo[], INT pulse );
void sp_get_rot_matrix( float *source, long *dest );
void sp_get_scaninfo_matrix(float *source, SCAN_INFO * dest);
STATUS sp_init_satloggrd( LOG_GRAD *sloggrd );
STATUS SpSatEval( INT *time_spsat );
STATUS SpSatCheck( void );
void SatGetZOffset( DOUBLE locpos, DOUBLE locneg,
                    INT *offset1, INT *offset2 );
int SatCatRelaxtime( INT acqs,INT seq_time,INT seq_type );
STATUS SatPlacement( INT numPasses );
STATUS SpSatIAmp( void );
STATUS SpSatPG( INT sat_type, INT start_time,
                INT *sat_index, INT cardiacsat_pos );
STATUS SpSatPG_fgre( INT sat_type, INT start_time,
                     INT *sat_index, INT cardiacsat_pos,
                     INT seq_time );
STATUS SpSatCatRelaxPG( INT ssi_time );
STATUS SpSatCatRelaxOffsets( SEQUENCE_ENTRIES sequence_offsets );
void dump_sat_input( void );
void sp_dump_rsp_rot( INT ir_mode );
void sp_dump_sat_rot( void );
void sp_set_rot_matrix( void );
void sp_set_rot_matrix_card( void );
void sp_set_rot_matrix_seqir123( void );
void sp_set_rot_matrix_seqir12( void );
void sp_set_rot_matrix_seqir13( void );
STATUS sp_update_rot_matrix( long *slice_rot_matrix, long (*sat_rot_array)[9],
                             const INT num_explicit_sats,
                             const INT num_default_sats );
void SpSat_set_sat1_matrix( long (*orig_rot_matrix)[9],
                            long (*new_rot_matrix)[9],
                            int entries, long (*sat_array)[9],
                            int num_explicit_sats, int num_default_sats,
                            int cardiacsat_pos, int sequence_flag );
STATUS SpSatInitRsp( INT num_sat_grps, INT cardiacsat_pos, INT ir_sattype );
STATUS SpSatUpdateRsp( INT num_sat_grps, INT pass, INT cat_seq_type );
STATUS SpSatPlayRelaxers( void );
STATUS SpSatChop( void );
STATUS SpSatChopKiller( void );
void SpSatSPGR( INT phase );
void SpSat_Satoff(INT sat_index );
void SpSat_Saton( INT sat_index);
void SpSat_Satrfoff( INT sat_index );
void SpSat_Satrfon( INT sat_index );
STATUS InversionCheck(void );
EXTERN_FILENAME pulse_rho;
EXTERN_FILENAME pulse_pha;
EXTERN_FILENAME pulse_grd;
STATUS PScvinit(void);
STATUS PS1cvinit(void);
STATUS CFLcvinit(void);
STATUS CFHcvinit(void);
STATUS FTGcvinit(void);
STATUS AScvinit(void);
STATUS RCVNcvinit(void);
STATUS PScveval(void);
STATUS PScveval1(int local_ps_te);
STATUS PS1cveval(FLOAT *opthickPS);
STATUS CFLcveval(FLOAT opthickPS);
STATUS CFHfilter(void);
STATUS CFHcveval(FLOAT opthickPS);
STATUS FTGcveval(void);
STATUS AScveval(void);
STATUS RCVNcveval(void);
STATUS PSfilter(void);
STATUS PSpredownload(void);
STATUS PS1predownload(void);
STATUS CFLpredownload(void);
STATUS CFHpredownload(void);
STATUS FTGpredownload(void);
STATUS ASpredownload(void);
STATUS RCVNpredownload(void);
STATUS mps1(void);
STATUS aps1(void);
STATUS cfl(void);
STATUS cfh(void);
STATUS fasttg(void);
STATUS autoshim(void);
STATUS rcvn(void);
STATUS PSpulsegen(void);
STATUS PS1pulsegen(INT posstart);
STATUS CFLpulsegen(INT posstart);
STATUS CFHpulsegen(INT posstart);
STATUS FTGpulsegen(void);
STATUS ASpulsegen(void);
STATUS RCVNpulsegen(INT posstart);
STATUS PSmps1(INT mps1nex);
STATUS PScfl(void);
STATUS PScfh(void);
STATUS PSrcvn(void);
void StIRMod(void);
STATUS PSinit(long (*PSrotmat)[9]);
STATUS PSfasttg(void);
STATUS FastTGCore( DOUBLE slice_loc, INT ftg_disdaqs, INT ftg_views,
                   INT ftg_nex, INT ftg_debug );
INT ASautoshim(void);
STATUS CoilSwitchSetCoil( const COIL_INFO coil,
                          const INT setRcvPortFlag);
int CoilSwitchGetTR(const int setRcvPortFlag);
void SDL_PrintFStrengthWarning(int psdCode, int fieldStrength,char *fileName,
                               int lineNo);
void SDL_Print0_7Debug(int psdCode, char *fileName, int lineNo);
void SDL_Print3_0Debug(int psdCode, char *fileName, int lineNo);
void SDL_Print4_0Debug(int psdCode, char *fileName, int lineNo);
void SDL_FStrengthPanic(int psdCode, int fieldStrength,char *fileName,int lineNo);
int SDL_CheckValidFieldStrength(int psdCode, int fieldStrength, int use_ermes);
void SDL_SetLimTE(int psdCode,int fStrength,int opautote,
                  int *llimte1,int *llimte2,int *llimte3,
                  int *ulimte1,int *ulimte2,int *ulimte3);
void SDL_CalcRF1RF2Scale(int psdCode,int fStrength,int coilType,
                          float slThickness,float *gscale_rf1, float *gscale_rf2,
                          float *gscale_rf1se1,float *gscale_rf1se2);
void SDL_SetFOV(int psdCode,int fStrength);
void SDL_SetSLTHICK(int psdCode,int fStrength);
void SDL_SetCS(int psdCode,int fStrength);
float SDL_GetChemicalShift( const int fStrength );
STATUS SDL_RFDerating( double *deRateB1, const int fStrength,
                       const double weight, const TX_COIL_INFO txCoil,
                       const int gcoiltype );
STATUS SDL_RFDerating_calc( double *deRateB1, const int fStrength,
                            const double weight, const TX_COIL_INFO txCoil,
                            const int gcoiltype, const int prescan_entry,
                            double safety_factor );
STATUS SDL_RFDerating_entry( double *deRateB1, const int fStrength,
                             const double weight, const TX_COIL_INFO txCoil,
                             const int gcoiltype, const int entry );
STATUS SDL_RFDerating_entry_sat( double *deRateB1, const int fStrength,
                                 const double weight,
                                 const TX_COIL_INFO txCoil,
                                 const int gcoiltype, const int entry,
                                 const double safetyfactor );
void SDL_InitSPSATRFPulseInfo( const int fStrength,
                               const int rfSlot,
                               int *pw_rfse1,
                               RF_PULSE_INFO rfPulseInfo[] );
STATUS ReadFtgTr( int *ftr, int dbg);
short isValidNucleus( const int nuclide, const int field );
STATUS BBcveval( int nucleus );
STATUS BBpredownload( ENTRY_POINT_TABLE *ep_table, int entry, int nucleus );
STATUS BBExciterUsage( int acqtype );
int getOffsetFrequencyInversion( const float field, const int nucleus );
STATUS BBboards( INT bdtype );
void BBboardsRho( INT bdtype, INT *rfrho_board );
void BBboardsPhase( INT bdtype, INT *rfphase_board );
void BBboardsFreq( INT bdtype, INT *rffreq_board );
WF_PROCESSOR rfrho_bd;
WF_PROCESSOR rfphase_bd;
WF_PROCESSOR rffreq_bd;
STATUS BBboards(INT bdtype)
{
    if ((bdtype == 0)
        || (bdtype == 3)){
        rfrho_bd = TYPRHO1;
        rfphase_bd = TYPTHETA;
        rffreq_bd = TYPOMEGA;
    } else {
        rfrho_bd = TYPRHO2;
        rfphase_bd = TYPOMEGA;
        rffreq_bd = TYPTHETA;
    }
    return (1);
}
void BBboardsRho( INT bdtype, INT *rfrho_board )
{
    if ((bdtype == 0)
        || (bdtype == 3)){
        *rfrho_board = TYPRHO1;
    } else {
        *rfrho_board = TYPRHO2;
    }
}
void BBboardsPhase( INT bdtype, INT *rfphase_board )
{
    if ((bdtype == 0)
        || (bdtype == 3)){
        *rfphase_board = TYPTHETA;
    } else {
        *rfphase_board = TYPOMEGA;
    }
}
void BBboardsFreq( INT bdtype, INT *rffreq_board )
{
    if ((bdtype == 0)
        || (bdtype == 3)){
        *rffreq_board = TYPOMEGA;
    } else {
        *rffreq_board = TYPTHETA;
    }
}
STATUS ssInit(void);
STATUS ssEval1(void);
STATUS ssEval2(void);
float get_fa_scaling_factor_ss(float * max_fa, float act_fa, float nom_fa, float nom_max_b1);
STATUS ssCheck(void);
STATUS ssRsp(void);
STATUS ssRsp3D(void);
STATUS init_arc_variables(void);
STATUS reset_accel_variables(void);
STATUS print_arc_params(void);
void print_asset_params(void);
STATUS initialize_arc_asset_variables(void);
long _firstcv = 0;
int opresearch = 0
;
float opweight = 50
;
int oplandmark = 0
;
int optabent = 0
;
int opentry = 1
;
int oppos = 1
;
int opplane = 1
;
int opphysplane = 1
;
int opobplane = 1
;
int opimode = 1
;
int oppseq = 1
;
int opgradmode = 0
;
int piimgoptlist = 0
;
int opcgate = 0
;
int opexor = 0
;
int opcmon = 0
;
int opfcomp = 0
;
int opgrx = 0
;
int opgrxroi = 0
;
int opnopwrap = 0
;
int opptsize = 2
;
int oppomp = 0
;
int opscic = 0
;
int oprect = 0
;
int opsquare = 0
;
int opvbw = 0
;
int opblim = 0
;
int opfast = 0
;
int opcs = 0
;
int opdeprep = 0
;
int opirprep = 0
;
int opmph = 0
;
int opdynaplan = 0
;
int opbsp = 0
;
int oprealtime = 0
;
int opfluorotrigger = 0
;
int opET = 0
;
int opmultistation = 0
;
int opepi = 0
;
int opflair = 0
;
int optlrdrf = 0
;
int opfulltrain = 0
;
int opirmode = 1
;
int opmt = 0
;
int opzip512 = 0
;
int opzip1024 = 0
;
int opslzip2 = 0
;
int opslzip4 = 0
;
int opsmartprep = 0
;
int opssrf = 0
;
int opt2prep = 0
;
int opspiral = 0
;
int opnav = 0
;
int opfmri = 0
;
int opectricks = 0
;
int optricksdel = 1000000
;
int optrickspause = 1
;
int opfr = 0
;
int opcube = 0
;
int ophydro = 0
;
int opphasecycle = 0
;
int oplava = 0
;
int opbrava = 0
;
int opcosmic = 0
;
int opvibrant = 0
;
int opbravo = 0
;
int opbreastmrs = 0
;
int opjrmode = 0
;
int opssfse = 0
;
int t1flair_flag = 0
;
int opbilateral = 0
;
int opphsen = 0
;
int opbc = 0
;
int opfatwater = 0
;
int oprtbc = 0
;
int opnseg = 1
;
int opnnex = 0
;
int opsilent = 0
;
int opsilentlevel = 1
;
int opmerge = 0
;
int opswan = 0
;
int opdixon = 0
;
int opdixproc = 0
;
int opmedal = 0
;
int oplavade = 0
;
int opvibrantde = 0
;
int opquickstep = 0
;
int opidealiq = 0
;
float opzoom_fov_xy = 440.0
;
float opzoom_fov_z = 350.0
;
float opzoom_dist_ax = 120.0
;
float opzoom_dist_cor = 120.0
;
float opzoom_dist_sag = 150.0
;
int app_grad_type = 0
;
int opzoom_coil_ind = 0
;
int pizoom_index = 0
;
int opsat = 0
;
int opsatx = 0
;
int opsaty = 0
;
int opsatz = 0
;
float opsatxloc1 = 9999
;
float opsatxloc2 = 9999
;
float opsatyloc1 = 9999
;
float opsatyloc2 = 9999
;
float opsatzloc1 = 9999
;
float opsatzloc2 = 9999
;
float opsatxthick = 40.0
;
float opsatythick = 40.0
;
float opsatzthick = 40.0
;
int opsatmask = 0
;
int opfat = 0
;
int opwater = 0
;
int opccsat = 0
;
int opfatcl = 0
;
int opspecir = 0
;
int opexsatmask = 0
;
float opexsathick1 = 40.0
;
float opexsathick2 = 40.0
;
float opexsathick3 = 40.0
;
float opexsathick4 = 40.0
;
float opexsathick5 = 40.0
;
float opexsathick6 = 40.0
;
float opexsatloc1 = 9999
;
float opexsatloc2 = 9999
;
float opexsatloc3 = 9999
;
float opexsatloc4 = 9999
;
float opexsatloc5 = 9999
;
float opexsatloc6 = 9999
;
int opexsatparal = 0
;
int opexsatoff1 = 0
;
int opexsatoff2 = 0
;
int opexsatoff3 = 0
;
int opexsatoff4 = 0
;
int opexsatoff5 = 0
;
int opexsatoff6 = 0
;
int opexsatlen1 = 480
;
int opexsatlen2 = 480
;
int opexsatlen3 = 480
;
int opexsatlen4 = 480
;
int opexsatlen5 = 480
;
int opexsatlen6 = 480
;
float opdfsathick1 = 40.0
;
float opdfsathick2 = 40.0
;
float opdfsathick3 = 40.0
;
float opdfsathick4 = 40.0
;
float opdfsathick5 = 40.0
;
float opdfsathick6 = 40.0
;
float exsat1_normth_R = 0;
float exsat1_normth_A = 0;
float exsat1_normth_S = 0;
float exsat2_normth_R = 0;
float exsat2_normth_A = 0;
float exsat2_normth_S = 0;
float exsat3_normth_R = 0;
float exsat3_normth_A = 0;
float exsat3_normth_S = 0;
float exsat4_normth_R = 0;
float exsat4_normth_A = 0;
float exsat4_normth_S = 0;
float exsat5_normth_R = 0;
float exsat5_normth_A = 0;
float exsat5_normth_S = 0;
float exsat6_normth_R = 0;
float exsat6_normth_A = 0;
float exsat6_normth_S = 0;
float exsat1_dist = 0;
float exsat2_dist = 0;
float exsat3_dist = 0;
float exsat4_dist = 0;
float exsat5_dist = 0;
float exsat6_dist = 0;
int pigirscrn = 0;
int piautoirbands = 0;
float pigirdefthick = 200.0;
int opnumgir = 0
;
int opgirmode = 0
;
int optagging = 0
;
int optagspc = 7
;
float optagangle = 45.0
;
float opvenc = 50.0
;
int opflaxx = 0
;
int opflaxy = 0
;
int opflaxz = 0
;
int opflaxall = 0
;
int opproject = 0
;
int opcollapse = 1
;
int oprlflow = 0
;
int opapflow = 0
;
int opsiflow = 0
;
int opmagc = 1
;
int opflrecon = 0
;
int oprampdir = 0
;
int project = 0
;
int vas_ovrhd = 0
;
int slice_col = 1
;
int phase_col = 0
;
int read_col = 0
;
int mag_mask = 1
;
int phase_cor = 1
;
int extras = 0
;
int mag_create = 1
;
int rl_flow = 0
;
int ap_flow = 0
;
int si_flow = 0
;
int imagenum = 1
;
int motsa_ovrhd = 0
;
int opslinky = 0
;
int opinhance = 0
;
int opautosubtract = 0
;
int opsepseries = 0
;
int pititle = 0 ;
float opuser0 = 0 ;
float opuser1 = 0 ;
float opuser2 = 0 ;
float opuser3 = 0 ;
float opuser4 = 0 ;
float opuser5 = 0 ;
float opuser6 = 0 ;
float opuser7 = 0 ;
float opuser8 = 0 ;
float opuser9 = 0 ;
float opuser10 = 0 ;
float opuser11 = 0 ;
float opuser12 = 0 ;
float opuser13 = 0 ;
float opuser14 = 0 ;
float opuser15 = 0 ;
float opuser16 = 0 ;
float opuser17 = 0 ;
float opuser18 = 0 ;
float opuser19 = 0 ;
float opuser20 = 0 ;
float opuser21 = 0 ;
float opuser22 = 0 ;
float opuser23 = 0 ;
float opuser24 = 0 ;
float opuser25 = 0 ;
float opuser26 = 0 ;
float opuser27 = 0 ;
float opuser28 = 0 ;
float opuser29 = 0 ;
float opuser30 = 0 ;
float opuser31 = 0 ;
float opuser32 = 0 ;
float opuser33 = 0 ;
float opuser34 = 0 ;
float opuser35 = 0 ;
float opuser36 = 0 ;
float opuser37 = 0 ;
float opuser38 = 0 ;
float opuser39 = 0 ;
float opuser40 = 0 ;
float opuser41 = 0 ;
float opuser42 = 0 ;
float opuser43 = 0 ;
float opuser44 = 0 ;
float opuser45 = 0 ;
float opuser46 = 0 ;
float opuser47 = 0 ;
float opuser48 = 0 ;
int opnostations = 1
;
int opstation = 1
;
int oploadprotocol = 0
;
int opmask = 0
;
int opvenous = 0
;
int opprotRxMode = 0
;
int opacqo = 1
;
int opfphases = 1
;
int opsldelay = 50000
;
int avminsldelay = 50000
;
int optphases = 1
;
int opdynaplan_nphases = 1
;
int opdiffuse = 0
;
int opsavedf = 0
;
int opmintedif = 1
;
int opdfaxx = 0;
int opdfaxy = 0;
int opdfaxz = 0;
int opdfaxall = 0;
int opdfaxtetra = 0;
int opdfax3in1 = 0;
int opbval = 0
;
int opnumbvals = 1
;
int opautonumbvals = 0
;
float opdifnext2 = 1
;
int opautodifnext2 = 0
;
int optensor = 0
;
int opdifnumdirs = 1
;
int opdifnumt2 = 1
;
int opautodifnumt2 = 0
;
int opdualspinecho = 0
;
int opdifproctype = 0
;
int opdifnumbvalues = 1
;
int dti_plus_flag = 0
;
int optouch = 0
;
int optouchfreq = 60
;
int optouchmegfreq = 60
;
int optouchamp = 30
;
int optouchtphases = 4
;
int optouchcyc = 3
;
int optouchax = 4
;
int opasl = 0
;
float oppostlabeldelay = 1525.0
;
int rhchannel_combine_method = 0
;
int rhasl_perf_weighted_scale = 32
;
float cfslew_artmedium = 2.0
;
float cfgmax_artmedium = 3.3
;
float cfslew_arthigh = 2.0
;
float cfgmax_arthigh = 3.3
;
int cfnumartlevels = 0
;
int pinumartlevels = 0
;
int oprep_active = 1
;
int oprep_rest = 1
;
int opdda = 0
;
int opinit_state = 0
;
int opfMRIPDTYPE = 0
;
int opview_order = 1
;
int opslice_order = 0
;
int oppsd_trig = 0
;
int oppdgm_str = -1
;
int opbwrt = 0
;
int cont_flag = 0
;
int opautonecho = 1
;
int opnecho = 1
;
int opnshots = 1
;
int opautote = 0
;
int opte = 25000
;
int opte2 = 50000
;
int optefw = 0
;
int opti = 50000
;
int opbspti = 50000
;
int opautoti = 0
;
int opautobti = 0
;
int opautotr = 0
;
int optr = 400000
;
float opflip = 90
;
int opautoetl = 0
;
int opetl = 8
;
int opautorbw = 0
;
float oprbw = 16.0
;
float oprbw2 = 16.0
;
float opfov = 500
;
float opphasefov = 1
;
float opfreqfov = 1
;
int opslquant = 1
;
int opsllocs = 1
;
float opslthick = 5
;
float opslspace = 10
;
int opileave = 0
;
int opcoax = 1
;
float opvthick = 320
;
int opvquant = 1
;
int opovl = 0
;
float oplenrl = 0
;
float oplenap = 0
;
float oplensi = 0
;
float oplocrl = 0
;
float oplocap = 0
;
float oplocsi = 0
;
float oprlcsiis = 1
;
float opapcsiis = 2
;
float opsicsiis = 3
;
float opmonfov = 200
;
float opmonthick = 20
;
float opinittrigdelay = 1000000
;
int opxres = 256
;
int opyres = 128
;
int opautonex = 0
;
float opnex = 1
;
int opslicecnt = 0
;
int opspf = 0
;
int opcfsel = 2
;
int opfcaxis = 0
;
int opphcor = 0
;
float opdose = 0
;
int opchrate = 100
;
int opcphases = 1
;
int opclocs = 1
;
int ophrate = 60
;
int oparr = 10
;
int ophrep = 1
;
int opautotdel1 = 0
;
int optdel1 = 20000
;
int optseq = 1
;
int opphases = 1
;
int opcardseq = 0
;
int opmphases = 0
;
int oparrmon = 1
;
int opvps = 8
;
int opcgatetype = 0
;
int opadvgate = 0
;
int opfcine = 0
;
int opcineir = 0
;
int opstress = 0
;
int opnrr = 0
;
int opnrr_dda = 8
;
int oprtcgate = 0
;
int oprtrate = 12
;
int oprtrep = 1
;
int oprttdel1 = 20000
;
int oprttseq = 1
;
int oprtcardseq = 0
;
int oprtarr = 10
;
int oprtpoint= 10
;
int opasset = 0
;
int opassetcal = 0
;
int opassetscan = 0
;
float opphasset_factor = 1.0
;
float opslasset_factor = 1.0
;
int rhcoilno = 0
;
int rhasset = 0
;
int rhasset_calthresh = 10000
;
float rhasset_R = 0.5
;
int rhasset_phases = 1
;
float rhscancent = 0.0
;
int rhasset_alt_cal = 0
;
int rhasset_torso = 0
;
int rhasset_localTx = 0
;
int oppure = 0
;
int rhpure = 0
;
int rhpurechannel = 0
;
int rhpurefilter= 0
;
float rhpure_scale_factor = 1.0
;
int sifsetwokey = 0
;
int opautosldelay = 0
;
int specnuc = 1
;
int specpts = 256
;
int specwidth = 2000
;
int specnavs = 1
;
int specnex = 2
;
int specdwells = 1
;
int acquire_type = 0
;
int pixmtband = 1
;
int pibbandfilt = 0
;
int opwarmup = 0
;
int pscahead = 0
;
int opprescanopt = 0
;
int autoadvtoscn = 0
;
int opapa = 0
;
int oppscapa = 0
;
int PSslice_ind = 0
;
float asfov = 500
;
int asslquant = 1
;
float asflip = 20
;
float asslthick = 10
;
int asxres = 256
;
int asyres = 128
;
int asbaseline = 8
;
int asrhblank = 4
;
int asptsize = 4
;
int opascalcfov = 0
;
float tgfov = 500
;
int tgcap = 200
;
int tgwindow = 200
;
int oppscvquant = 0
;
int opdrivemode = 1
;
int pidrivemodenub = 7
;
float lp_stretch = 2.0
;
int lp_mode = 0
;
float derateb1_body_factor = 1.0
;
float SAR_bodyNV_weight_lim = 110.0
;
float derateb1_NV_factor = 1.0
;
float jstd_multiplier_body = 0.145
;
float jstd_multiplier_NV = 0.0137
;
float jstd_exponent_body = 0.763
;
float jstd_exponent_NV = 1.154
;
int pidiffmode = 0;
int pifmriscrn = 0;
int piresol = 0
;
int pioverlap = 0
;
int piforkvrgf = 0;
int pinofreqoffset = 0;
int pirepactivenub = 0;
int pireprestnub = 0;
int piddanub = 0;
int piinitstatnub = 0;
int piviewordernub = 0;
int pisliceordnub = 0;
int pipsdtrignub = 0;
int pispssupnub = 1;
int pi_neg_sp = 0
;
float piisvaldef = 2.0
;
int pidmode = 0
;
int piviews = 0
;
int piclckcnt = 1
;
float avmintscan = 0.0
;
float pitslice = 0.0
;
float pitscan = 0.0
;
float pimscan = 0.0
;
float pireconlag = -3.0
;
float pitres = 0.0
;
int pisaveinter = 0
;
int pivextras = 0
;
int pinecho = 0
;
float piscancenter = 0.0
;
int pismode = 0
;
int pishldctrl = 0
;
int pinolr = 1
;
int pinoadc = 0
;
int pimixtime = 0
;
int pishim2 = 0
;
int pi1stshimb = 0
;
float pifractecho = 1.0
;
int nope = 0
;
int opuser_usage_tag = 0x00000000
;
int rhuser_usage_tag = 0x00000000
;
int rhFillMapMSW = 0x00000000
;
int rhFillMapLSW = 0x00000000
;
int rhbline = 0
;
int rhblank = 4
;
int rhnex = 1
;
int rhnavs = 1
;
int rhnslices = 1
;
int rhnframes = 256
;
int rhfrsize = 256
;
int rhnecho = 1
;
int rhnphases = 1
;
int rhmphasetype = 0
;
int rhtrickstype = 0
;
int rhtype = 0
;
int rhtype1 = 0
;
int rhformat = 0
;
int rhptsize = 2
;
int rhnpomp = 1
;
int rhrcctrl = 1
;
int rhdacqctrl = 2
;
int rhexecctrl = 9
;
int rhfdctrl = 0
;
float rhxoff = 0.0
;
float rhyoff = 0.0
;
int rhrecon = 0
;
int rhdatacq = 0
;
int rhvquant = 0
;
int rhslblank = 2
;
int rhhnover = 0
;
int rhfeextra = 0
;
int rhheover = 0
;
int rhoscans = 0
;
int rhddaover = 0
;
float rhzeroph = 128.5
;
float rhalpha = 0.46
;
float rhnwin = 0.0
;
float rhntran = 2.0
;
int rhherawflt = 0
;
float rhherawflt_befnwin = 1.0
;
float rhherawflt_befntran = 2.0
;
float rhherawflt_befamp = 1.0
;
float rhherawflt_hpfamp = 1.0
;
float rhfermw = 10.0
;
float rhfermr = 128.0
;
float rhferme = 1.0
;
float rhclipmin = 0.0
;
float rhclipmax = 16383.0
;
float rhdoffset = 0.0
;
int rhudasave = 0
;
int rhsspsave = 0
;
float rh2dscale = 1.0
;
float rh3dscale = 1.0
;
int rhnpasses = 1
;
int rhincrpass = 1
;
int rhinitpass = 1
;
int rhmethod = 0
;
int rhdaxres = 256
;
int rhdayres = 256
;
int rhrcxres = 256
;
int rhrcyres = 256
;
int rhimsize = 256
;
float rhuser0 = 0 ;
float rhuser1 = 0 ;
float rhuser2 = 0 ;
float rhuser3 = 0 ;
float rhuser4 = 0 ;
float rhuser5 = 0 ;
float rhuser6 = 0 ;
float rhuser7 = 0 ;
float rhuser8 = 0 ;
float rhuser9 = 0 ;
float rhuser10 = 0 ;
float rhuser11 = 0 ;
float rhuser12 = 0 ;
float rhuser13 = 0 ;
float rhuser14 = 0 ;
float rhuser15 = 0 ;
float rhuser16 = 0 ;
float rhuser17 = 0 ;
float rhuser18 = 0 ;
float rhuser19 = 0 ;
float rhuser20 = 0 ;
float rhuser21 = 0 ;
float rhuser22 = 0 ;
float rhuser23 = 0 ;
float rhuser24 = 0 ;
float rhuser25 = 0 ;
float rhuser26 = 0 ;
float rhuser27 = 0 ;
float rhuser28 = 0 ;
float rhuser29 = 0 ;
float rhuser30 = 0 ;
float rhuser31 = 0 ;
float rhuser32 = 0 ;
float rhuser33 = 0 ;
float rhuser34 = 0 ;
float rhuser35 = 0 ;
float rhuser36 = 0 ;
float rhuser37 = 0 ;
float rhuser38 = 0 ;
float rhuser39 = 0 ;
float rhuser40 = 0 ;
float rhuser41 = 0 ;
float rhuser42 = 0 ;
float rhuser43 = 0 ;
float rhuser44 = 0 ;
float rhuser45 = 0 ;
float rhuser46 = 0 ;
float rhuser47 = 0 ;
float rhuser48 = 0 ;
int rhdab0s = 0
;
int rhdab0e = 0
;
float rhctr = 1.0
;
float rhcrrtime = 1.0
;
int rhcphases = 1
;
int rhovl = 0
;
int rhvtype = 0
;
float rhvenc = 0.0
;
float rhvcoefxa = 0.0
;
float rhvcoefxb = 0.0
;
float rhvcoefxc = 0.0
;
float rhvcoefxd = 0.0
;
float rhvcoefya = 0.0
;
float rhvcoefyb = 0.0
;
float rhvcoefyc = 0.0
;
float rhvcoefyd = 0.0
;
float rhvcoefza = 0.0
;
float rhvcoefzb = 0.0
;
float rhvcoefzc = 0.0
;
float rhvcoefzd = 0.0
;
float rhvmcoef1 = 0.0
;
float rhvmcoef2 = 0.0
;
float rhvmcoef3 = 0.0
;
float rhvmcoef4 = 0.0
;
float rhphasescale = 1.0
;
float rhfreqscale = 1.0
;
int rawmode = 0
;
int rhileaves = 1
;
int rhkydir = 0
;
int rhalt = 0
;
int rhreps = 1
;
int rhref = 1
;
int rhpcthrespts = 2
;
int rhpcthrespct = 15
;
int rhpcdiscbeg = 0
;
int rhpcdiscmid = 0
;
int rhpcdiscend = 0
;
int rhpcileave = 0
;
int rhpcextcorr = 0
;
int rhrefframes = 0
;
int rhpcsnore = 0
;
int rhpcspacial = 0
;
int rhpctemporal = 0
;
float rhpcbestky = 64.0
;
int rhhdbestky = 0
;
int rhpcinvft = 0
;
int rhpcctrl = 0
;
int rhpctest = 0
;
int rhpcgraph = 0
;
int rhpclin = 0
;
int rhpclinnorm = 0
;
int rhpclinnpts = 0
;
int rhpclinorder = 2
;
int rhpclinfitwt = 0
;
int rhpclinavg = 0
;
int rhpccon = 0
;
int rhpcconnorm = 0
;
int rhpcconnpts = 2
;
int rhpcconorder = 2
;
int rhpcconfitwt = 0
;
int rhvrgfxres = 128
;
int rhvrgf = 0
;
int rhbp_corr = 0
;
float rhrecv_freq_s = 0.0
;
float rhrecv_freq_e = 0.0
;
int rhhniter = 0
;
int rhfast_rec = 0
;
int rhgridcontrol = 0
;
int rhb0map = 0
;
int rhtediff = 0
;
float rhradiusa = 0
;
float rhradiusb = 0

;

float rhmaxgrad = 0.0





;

float rhslewmax = 0.0





;

float rhscanfov = 0.0





;

float rhtsamp = 0.0





;

float rhdensityfactor = 0.0





;

float rhdispfov = 0.0





;

int rhmotioncomp = 0





;

int grid_fov_factor = 2





;





int rhte = 25000





;

int rhte2 = 50000





;

int rhdfm = 0





;

int rhdfmnavsperpass = 1





;

int rhdfmnavsperview = 1





;

float rhdfmrbw = 4.0





;

int rhdfmptsize = 2





;

int rhdfmxres = 32





;

int rhdfmdebug = 0





;

float rhdfmthreshold = 0.0





;


int rh_rc_enhance_enable = 0





;

int rh_ime_scic_enable = 0





;

float rh_ime_scic_edge = 0.0





;

float rh_ime_scic_smooth = 0.0





;

float rh_ime_scic_focus = 0.0





;

int rh_ime_clariview_type = 0





;

float rh_ime_clariview_edge = 0.0





;

float rh_ime_clariview_smooth = 0.0





;

float rh_ime_clariview_focus = 0.0





;

float rh_ime_scic_reduction = 0.0





;

float rh_ime_scic_gauss = 0.0





;

float rh_ime_scic_threshold = 0.0





;



int rhapp = 0






;

int rhapp_option = 0






;



int rhncoilsel = 0






;

int rhncoillimit = 45






;

int rhrefframep = 0






;

int rhscnframe = 0






;

int rhpasframe = 0






;

int rhpcfitorig = 1






;

int rhpcshotfirst = 0






;

int rhpcshotlast = 0






;

int rhpcmultegrp = 0






;

int rhpclinfix = 1






;

float rhpclinslope = 0.0






;

int rhpcconfix = 1






;

float rhpcconslope = 0.0






;

int rhpccoil = 1






;

float rhmaxcoef1a = 0






;

float rhmaxcoef1b = 0






;

float rhmaxcoef1c = 0






;

float rhmaxcoef1d = 0






;

float rhmaxcoef2a = 0






;

float rhmaxcoef2b = 0






;

float rhmaxcoef2c = 0






;

float rhmaxcoef2d = 0






;

float rhmaxcoef3a = 0






;

float rhmaxcoef3b = 0






;

float rhmaxcoef3c = 0






;

float rhmaxcoef3d = 0






;

int rhdptype = 0






;

int rhnumbvals = 1





;

int rhdifnext2 = 1





;

int rhnumdifdirs = 1





;

int rhutctrl = 0






;

float rhzipfact = 0






;

int rhfcinemode = 0






;

int rhfcinearw = 10






;

int rhvps = 8






;

int rhvvsaimgs = 1






;

int rhvvstr = 0






;

int rhvvsgender = 0






;


int rhgradmode = 0;

int rhfatwater = 0






;

int rhfiesta = 0






;

int rhlcfiesta = 0






;

float rhlcfiesta_phase = 0.0






;




int rhdwnavview = 0






;

int rhdwnavcorecho = 2






;

int rhdwnavsview = 1






;

int rhdwnaveview = 1






;

int rhdwnavsshot = 1






;

int rhdwnaveshot = 2






;

float rhdwnavcoeff = 0.5






;







int rhdwnavcor = 0






;


float rhassetsl_R = 1.0






;

float rhasset_slwrap = 0.0






;



int rh3dwintype = 0






;

float rh3dwina = 0.1






;

float rh3dwinq = 0.0






;


int rhectricks_num_regions = 0;

int rhectricks_input_regions = 0;
int rhretro_control = 0
;
int rhetl = 0
;
int rhleft_blank = 0
;
int rhright_blank = 0
;
float rhspecwidth = 0.0
;
int rhspeccsidims = 0
;
int rhspecrescsix = 0
;
int rhspecrescsiy = 0
;
int rhspecrescsiz = 0
;
float rhspecroilenx = 0.0
;
float rhspecroileny = 0.0
;
float rhspecroilenz = 0.0
;
float rhspecroilocx = 0.0
;
float rhspecroilocy = 0.0
;
float rhspecroilocz = 0.0
;
int rhexciterusage = 1
;
int rhexciterfreqs = 1
;
int rhwiener = 0
;
float rhwienera = 0.0
;
float rhwienerb = 0.0
;
float rhwienert2 = 0.0
;
float rhwieneresp = 0.0
;
int rhflipfilter = 0
;
int rhdbgrecon = 0
;
int rhech2skip = 0
;
int rhrcideal = 0
;
int rhrcdixproc = 0
;
int rhrcidealctrl = 0
;
int rhdf = 210
;
int rhmedal_mode = 0
;
int rhmedal_nstack_size = 54
;
int rhmedal_echo_order = 0
;
int rhmedal_up_kernel_size = 15
;
int rhmedal_down_kernel_size = 8
;
int rhmedal_smooth_kernel_size = 8
;
int rhmedal_starting_slice = 0
;
int rhmedal_ending_slice = 10
;
int rhvibrant = 0
;
int rhkacq_uid = 0
;
int rhnex_unacquired = 1
;
int rhdiskacqctrl = 0
;
int rhechopc_extra_bot = 0
;
int rhechopc_ylines = 0
;
int rhechopc_primary_yfirst = 0
;
int rhechopc_reverse_yfirst = 0
;
int rhechopc_zlines = 0
;
int rhechopc_yxfitorder = 1
;
int rhechopc_ctrl = 0
;
int ihtr = 100
;
int ihti = 0
;
int ihtdel1 = 10
;
float ihnex = 1
;
float ihflip = 90
;
int ihte1 = 0
;
int ihte2 = 0
;
int ihte3 = 0
;
int ihte4 = 0
;
int ihte5 = 0
;
int ihte6 = 0
;
int ihte7 = 0
;
int ihte8 = 0
;
int ihte9 = 0
;
int ihte10 = 0
;
int ihte11 = 0
;
int ihte12 = 0
;
int ihte13 = 0
;
int ihte14 = 0
;
int ihte15 = 0
;
int ihte16 = 0
;
int ihdixonte = 0
;
int ihdixonipte = 0
;
int ihdixonoopte = 0
;
float ihvbw1 = 16.0
;
float ihvbw2 = 16.0
;
float ihvbw3 = 16.0
;
float ihvbw4 = 16.0
;
float ihvbw5 = 16.0
;
float ihvbw6 = 16.0
;
float ihvbw7 = 16.0
;
float ihvbw8 = 16.0
;
float ihvbw9 = 16.0
;
float ihvbw10 = 16.0
;
float ihvbw11 = 16.0
;
float ihvbw12 = 16.0
;
float ihvbw13 = 16.0
;
float ihvbw14 = 16.0
;
float ihvbw15 = 16.0
;
float ihvbw16 = 16.0
;
int ihnegscanspacing = 0
;
int ihoffsetfreq = 1200
;
int ihbsoffsetfreq = 4000
;
int iheesp = 0
;
int ihfcineim = 0
;
int ihfcinent = 0
;
int ihbspti = 50000
;
float ihtagfa = 180.0
;
float ihtagor = 45.0
;
float ih_idealdbg_cv1 = 0 ;
float ih_idealdbg_cv2 = 0 ;
float ih_idealdbg_cv3 = 0 ;
float ih_idealdbg_cv4 = 0 ;
float ih_idealdbg_cv5 = 0 ;
float ih_idealdbg_cv6 = 0 ;
float ih_idealdbg_cv7 = 0 ;
float ih_idealdbg_cv8 = 0 ;
float ih_idealdbg_cv9 = 0 ;
float ih_idealdbg_cv10 = 0 ;
float ih_idealdbg_cv11 = 0 ;
float ih_idealdbg_cv12 = 0 ;
float ih_idealdbg_cv13 = 0 ;
float ih_idealdbg_cv14 = 0 ;
float ih_idealdbg_cv15 = 0 ;
float ih_idealdbg_cv16 = 0 ;
float ih_idealdbg_cv17 = 0 ;
float ih_idealdbg_cv18 = 0 ;
float ih_idealdbg_cv19 = 0 ;
float ih_idealdbg_cv20 = 0 ;
float ih_idealdbg_cv21 = 0 ;
float ih_idealdbg_cv22 = 0 ;
float ih_idealdbg_cv23 = 0 ;
float ih_idealdbg_cv24 = 0 ;
float ih_idealdbg_cv25 = 0 ;
float ih_idealdbg_cv26 = 0 ;
float ih_idealdbg_cv27 = 0 ;
float ih_idealdbg_cv28 = 0 ;
float ih_idealdbg_cv29 = 0 ;
float ih_idealdbg_cv30 = 0 ;
float ih_idealdbg_cv31 = 0 ;
float ih_idealdbg_cv32 = 0 ;
int ihlabeltime = 0
;
int ihpostlabeldelay = 0
;
int dbdt_option_key_status = 0
;
int dbdt_mode = 0
;
int cfdbdttype = 0
;
float cfrinf = 23.4
;
int cfrfact = 334
;
float cfdbdtper_norm = 80.0
;
float cfdbdtper_cont = 100.0
;
float cfdbdtper_max = 200.0
;
int cfnumicn = 1
;
int cfdppericn = 4
;
int cfgradcoil = 2;
int cfswgut = 4;
int cfswrfut = 2;
int cfswssput = 1;
int cfhwgut = 4;
int cfhwrfut = 2;
int cfhwssput = 1;
int cfoption = -1
;
int cfrfboardtype = 0
;
int psd_board_type = PSDDVMR
;
int opdfm = 0
;
int opdfmprescan = 0
;
int cfdfm = 0
;
int cfdfmTG = 70
;
int cfdfmR1 = 13
;
int cfdfmDX = 0
;
int derate_ACGD = 0
;
int rhextra_frames_top = 0
;
int rhextra_frames_bot = 0
;
int rhpc_ref_start = 0
;
int rhpc_ref_stop = 0
;
int rhpc_ref_skip = 0
;
int opaxial_slice=0
;
int opsagittal_slice =0
;
int opcoronal_slice=0
;
int opvrg = 0
;
int opmart = 0
;
int piassetscrn = 0
;
int opseriessave = 0
;
int opt2map = 0
;
int opmer2 = 0
;
int rhnew_wnd_level_flag = 1
;
int rhwnd_image_hist_area = 60
;
float rhwnd_high_hist = 1.0
;
float rhwnd_lower_hist = 1.0
;
int cfrfupa = -50
;
int cfrfupd = 50
;
int cfrfminblank = 200
;
int cfrfminunblk = 200
;
int cfrfminblanktorcv = 50
;
float cfrfampftconst = 0.784
;
float cfrfampftlinear = 0.0
;
float cfrfampftquadratic = 15.125
;
int opgem = 0
;
float opgem_factor = 1.0
;
float opgem_sl_limit = 1.0
;
float opgem_ph_limit = 1.0
;
int opautogem_factor = 0
;
int optracq = 0
;
int opswift = 0
;
int rhswiftenable = 0
;
int rhnumCoilConfigs = 0
;
int rhnumslabs = 1
;
int opncoils = 1
;
int rtsar_first_series_flag = 0
;
int rtsar_enable_flag = 0
;
int measured_TG = -1
;
int predicted_TG = -1
;
float sar_correction_factor = 1.0
;
int gradHeatMethod = 0
;
int gradHeatFile = 0
;
int gradCoilMethod = 3
;
int gradHeatFlag = 0
;
int xgd_optimization = 1
;
int gradChokeFlag = 0
;
int piburstmode = 0
;
int opburstmode = 0
;
int burstreps = 1
;
float piburstcooltime = 0.0
;
float opaccel_ph_stride = 1.0
;
float opaccel_sl_stride = 1.0
;
float opaccel_t_stride = 1.0
;
int oparc = 0
;
int op3dgradwarp = 0
;
int opauto3dgradwarp = 1
;
int cfreceiveroffsetfreq = 0
;
int cfcoilswitchmethod = 0x0004
;
int prevent_scan_under_emul = 0
;
int acqs = 1
;
int avround = 1
;
int baseline = 0
;
int nex = 1
;
float fn = 1.0
;
int enablfracdec = 1
;
float nop = 1
;
int acq_type = 0
;
int seq_type = 0
;
int num_images = 1
;
int mag = 1
;
int pha = 0
;
int imag = 0
;
int qmag = 0
;
int slquant1 = 1
;
int psd_grd_wait = 56
;
int psd_rf_wait = 0
;
int pos_moment_start = 0
;
int mps1rf1_inst = 0
;
int scanrf1_inst = 0
;
int cfcarddelay = 10
;
int psd_card_hdwr_delay = 0
;
float GAM = 4257.59
;
int off90 = 80
;
int TR_SLOP = 2000
;
int TR_PASS = 50000
;
int TR_PASS3D = 550000
;
int csweight= 100
;
int exnex = 1
;
float truenex = 0.0
;
int eg_phaseres = 128
;
int sp_satcard_loc = 0
;
int min_rfdycc = 0;
int min_rfavgpow = 0;
int min_rfrmsb1 = 0;
int coll_prefls = 1
;
int maxGradRes = 1
;
float dfg = 2
;
float pg_beta = 1.0
;
int split_dab = 0
;
float freq_scale = 1.0
;
int numrecv = 1
;
int pe_on = 1
;
float psd_targetscale = 1.0;
float psd_zero = 0.0
;
int lx_pwmtime = 0;
int ly_pwmtime = 0;
int lz_pwmtime = 0;
int px_pwmtime = 0;
int py_pwmtime = 0;
int pz_pwmtime = 0;
int min_seqgrad = 0;
int min_seqrfamp = 0;
float xa2s = 0;
float ya2s = 0;
float za2s = 0;
int minseqcoil_t = 0;
int minseqcoilburst_t = 0;
int minseqgram_t = 0;
int minseqchoke_t = 0;
int minseqcable_t = 0;
int minseqcableburst_t = 0;
int minseqbusbar_t = 0;
int minseqgrddrv_t = 0;
int minseqgrddrvx_t = 0;
int minseqgrddrvy_t = 0;
int minseqgrddrvz_t = 0;
float powerx = 0;
float powery = 0;
float powerz = 0;
float pospowerx = 0;
float pospowery = 0;
float pospowerz = 0;
float negpowerx = 0;
float negpowery = 0;
float negpowerz = 0;
float amptrans_lx = 0;
float amptrans_ly = 0;
float amptrans_lz = 0;
float amptrans_px = 0;
float amptrans_py = 0;
float amptrans_pz = 0;
float abspower_lx = 0;
float abspower_ly = 0;
float abspower_lz = 0;
float abspower_px = 0;
float abspower_py = 0;
float abspower_pz = 0;
int minseqpwm_x = 0;
int minseqpwm_y = 0;
int minseqpwm_z = 0;
int minseqgpm_t = 0;
int time_pgen = 0;
int cont_debug = 0
;
int maxpc_cor = 0
;
int maxpc_debug = 0
;
int maxpc_points = 500
;
int pass_thru_mode = 0
;
int tmin = 0
;
int tmin_total = 0
;
int psd_tol_value = 0
;
int bd_index = 1
;
int use_ermes = 0
;
float fieldstrength = 15000;
int asymmatrix = 0
;
int psddebugcode = 0
;
int psddebugcode2 = 0
;
int serviceMode = 0
;
int upmxdisable = 16
;
int tsamp = 4
;
int seg_debug = 0
;
int CompositeRMS_method = 0
;
int gradDriverMethod = 0
;
int gradDCsafeMethod = 1
;
int stopwatchFlag = 0
;
int seqEntryIndex = 0
;
int dbdt_debug = 0
;
int reilly_mode = 0
;
int dbdt_disable = 0
;
int use_dbdt_opt = 1
;
float srderate = 1.0
;
int config_update_mode = 0
;
int phys_record_flag = 0
;
int phys_rec_resolution = 25
;
int phys_record_channelsel = 15
;
int rotateflag = 0
;
int rhpcspacial_dynamic = 0
;
int rhpc_rationalscale = 0
;
int rhpcmag = 0
;
int mild_note_support = 0
;
int save_grad_spec_flag = 0
;
int grad_spec_change_flag = 0
;
int value_system_flag = 0
;
int rectfov_npw_support = 0
;
int pigeosrot = 0
;
int minseqrf_cal = 1
;
int min_rfampcpblty = 0
;
int b1derate_flag = 0
;
int oblmethod_dbdt_flag = 0
;
int minseqcoil_esp = 1000
;
int aspir_flag = 0
;
int rhrawsizeview = 0
;
int chksum_scaninfo_view = 0
;
int chksum_rhdacqctrl_view = 0
;
float fnecho_lim = 1.0
;
int psdcrucial_debug = 0
;
int cs_sat = 0;
int cs_satstart = 0, cs_sattime = 0;
float a_rfcssatcfh = 0, flip_rfcssatcfh = 0;
int pw_rfcssatcfh = 0, ia_rfcssatcfh = 0;
int ChemSatPulse=1;
float area_gxkcs = 0;
float area_gykcs = 0;
float area_gyakcs = 0;
float area_gzkcs = 0;
int pw_rfcssat = 0, pw_omega_hs_rfcssat = 0;
int off_rfcssat = 0;
int ia_rfcssat = 0, ia_omega_hs_rfcssat = 0;
float cyc_rfcssat = 0;
float a_rfcssat = 0, a_omega_hs_rfcssat = 0;
float alpha_rfcssat = 0;
float gscale_rfcssat = 0;
float flip_rfcssat = 0;
float a_gzrfcssat = 0;
int ia_gzrfcssat = 0;
int pw_gzrfcssat = 0;
int res_gzrfcssat = 0;
float a_gzrfcssat_wrf = 0;
float a_thetarfcssat = 0;
int ia_thetarfcssat = 0;
int pw_thetarfcssat = 0;
int res_thetarfcssat = 0;
int off_thetarfcssat = 0;
int bw_rfcssat = 0;
int num_gzrfcssat_lobe = 0;
int pw_gzrfcssat_lobe = 0;
int pw_gzrfcssat_constant = 0;
int pw_gzrfcssat_rampz = 0;
int num_gzrfcssat_lobe_norf = 0;
int pw_gzrfcssat_lobe_norf = 0;
int pw_gzrfcssat_constant_norf = 0;
int pw_gzrfcssat_rampz_norf = 0;
int ext_pw_rfcssat = 0;
int ext_res_rfcssat = 0;
int ext_isodelay = 0;
int ext_water_freq_flag = 0;
int ext_pw_grad_sub_lobe = 0;
int ext_pw_grad_sub_lobe_ramp = 0;
int ext_num_grad_sub_lobe = 0;
int ext_pw_grad_sub_lobe_norf = 0;
int ext_pw_grad_sub_lobe_ramp_norf = 0;
int ext_num_grad_sub_lobe_norf = 0;
float ext_abswidth = 0;
float ext_effwidth = 0;
float ext_area = 0;
float ext_dtycyc = 0;
float ext_maxpw = 0;
float ext_max_b1 = 0;
float ext_max_int_b1_sq = 0;
float ext_max_rms_b1 = 0;
float ext_nom_fa = 0;
float ext_nom_pw = 0;
float ext_nom_bw = 0;
float ext_gzrfcssat_scale_fac = 0;
float ext_fatsat_min_slthick = 0;
float fatsat_factor = 1.0 ;
 int csat_rfupa = -600 ;
 int csat_sys_type = 0 ;
int aspir_delay = 0;
int aspir_cfoffset = 0;
int aspir_minti = 0;
float aspir_T1 = 0;
float aspir_TI = 0;
float aspir_TI_null = 0;
float aspir_TI_extra = 0;
float aspir_TI_min = 0;
float aspir_eff = 0;
int fatFlag = 0;
int cs_isodelay = 0;
int cs_delay = 0;
int recovery_time = 0;
float flip_sat = 0;
float flip_satcfh = 0;
int fStrength = 0;
int use_spsp_fatsat = 0 ;
int debug_spsp_fatsat = 0;
float spsp_fatsat_slthick = 30.0 ;
int spsp_fatsat_pulse_extra_time = 0 ;
int spsp_fatsat_spatial_mode = 0 ;
float spsp_fatsat_spatial_offset = 0.0 ;
int spsp_fatsat_pulse_override = 0 ;
float spsp_fatsat_omega_scale= 256.0 ;
float ccs_dead = 3000000 ;
int ccs_relaxers = 0;
int ccs_relaxtime = 0;
int ccs_relaxseqtime = 0;
int SatRelaxers = 0;
float gsat_scale = 0;
float cyc_rfs = 0;
int pw_rfs = 0;
int pw_satrampx = 0, pw_satrampy = 0, pw_satrampz = 0;
int sat_rot_ex_num = 0;
int sat_rot_df_num = 0;
int sat_rot_index = 0;
int pw_isisat= 200 ;
int pw_rotupdate = 12 ;
int isi_satdelay = 100 ;
int rot_delay = 12 ;
int isi_extra = 32 ;
int sat_debug = 0;
int spsat_host_debug = 0 ;
int sp_first_scan = 0;
int sat_obl_debug = 0;
int sat_newgeo = 1;
 int spsat_rfupa = -600 ;
 int spsat_sys_type = 0 ;
int xkiller_set = 0;
int maxkiller_time = 0;
float satgapxpos= 0
;
float satgapxneg= 0
;
float satgapypos= 0
;
float satgapyneg= 0
;
float satgapzpos= 0
;
float satgapzneg= 0
;
float satspacex1 = 0,
        satspacex2 = 0,
        satspacey1 = 0,
        satspacey2 = 0,
        satspacez1 = 0,
        satspacez2 = 0,
        satspace1 = 0,
        satspace2 = 0,
        satspace3 = 0,
        satspace4 = 0,
        satspace5 = 0,
        satspace6 = 0;
float satthickx1 = 0,
        satthickx2 = 0,
        satthickdfx = 0,
        satthicky1 = 0,
        satthicky2 = 0,
        satthickdfy = 0,
        satthickz1 = 0,
        satthickz2 = 0,
        satthickdfz = 0,
        exsatthick1 = 0,
        exsatthick2 = 0,
        exsatthick3 = 0,
        exsatthick4 = 0,
        exsatthick5 = 0,
        exsatthick6 = 0;
float satxlocpos = 0,
        satxlocneg = 0,
        satylocpos = 0,
        satylocneg = 0,
        satzlocpos = 0,
        satzlocneg = 0,
        satzloca = 0,
        satzlocb = 0,
        satloce1 = 0,
        satloce2 = 0,
        satloce3 = 0,
        satloce4 = 0,
        satloce5 = 0,
        satloce6 = 0;
float area_rfsx1 = 0 ;
float area_rfsx2 = 0 ;
float area_rfsy1 = 0 ;
float area_rfsy2 = 0 ;
float area_rfsz1 = 0 ;
float area_rfsz2 = 0 ;
float area_rfse1 = 0 ;
float area_rfse2 = 0 ;
float area_rfse3 = 0 ;
float area_rfse4 = 0 ;
float area_rfse5 = 0 ;
float area_rfse6 = 0 ;
float area_gyksx1 = 0,area_gyksx2 = 0,area_gyksy1 = 0,area_gyksy2 = 0,area_gyksz1 = 0,
          area_gyksz2 = 0,area_gykse1 = 0,area_gykse2 = 0,area_gykse3 = 0,area_gykse4 = 0,
          area_gykse5 = 0,area_gykse6 = 0;
float area_gxksx1 = 0,area_gxksx2 = 0,area_gxksy1 = 0,area_gxksy2 = 0,area_gxksz1 = 0,
          area_gxksz2 = 0,area_gxkse1 = 0,area_gxkse2 = 0,area_gxkse3 = 0,area_gxkse4 = 0,
          area_gxkse5 = 0,area_gxkse6 = 0;
int sp_sattime = 0 ;
int sp_satstart = 0 ;
int vrgsat = 2 ;
int numsatramp = 0 ;
int had_sat = 0 ;
float rtia3d_sat_flip = 70
;
float rtia3d_sat_pos = 100.0
;
int sat_pulse_type = 0 ;
int autolock = 0
;
int blank = 4
;
int nograd = 0
;
int nofermi = 0
;
int rawdata = 0
;
int saveinter = 0
;
int zchop = 1
;
int eepf = 0
;
int oepf = 0
;
int eeff = 0
;
int oeff = 0
;
int cine_choplet = 0
;
float fermi_rc = 0.5
;
float fermi_wc = 1.0
;
int rcvinput = 3
;
int rcvbias = 16
 ;
int trdriver = 1
;
int rcvband = 0
;
int freq_inv = 1
;
 int cv_rfupa = -600 ;
 int system_type = 0 ;
 int cvlock = 1 ;
 int psd_taps = -1
;
 int fix_fermi = 0
;
 int grad_spec_ctrl = 0
  ;
 float srate = 1.651 ;
 float glimit = 1.0 ;
 float save_gmax = 1.0;
 float save_srate = 2.551;
 int save_cfxfull = 32752;
 int save_cfyfull = 32752;
 int save_cfzfull = 32752;
 float save_cfxipeak = 194.0;
 float save_cfyipeak = 194.0;
 float save_cfzipeak = 194.0;
 int save_ramptime = 600;
 int debug_grad_spec = 0 ;
 float act_srate=1.651;
 int val15_lock = 0
  ;
float mpsfov = 100 ;
int fastprescan = 0 ;
int pre_slice = 0 ;
int PSslice_num = 0;
float xmtaddAPS1 = 0, xmtaddCFL = 0, xmtaddCFH = 0, xmtaddFTG = 0, xmtadd = 0, xmtaddRCVN = 0;
float ps1scale = 0, cflscale = 0, cfhscale = 0, ftgscale = 0;
float extraScale = 0;
int PSdebugstate = 0 ;
int PSfield_strength = 5000 ;
int PScs_sat = 1 ;
int PSir = 1 ;
int PSmt = 1 ;
int tg_1_2_pw = 1 ;
int tg_axial = 1 ;
float coeff_pw_tg = 1.0;
float fov_lim_mps = 350.0 ;
int TGspf = 0 ;
float flip_rf2cfh = 0;
float flip_rf3cfh = 0;
int ps1_tr=2000000;
int cfl_tr=398000;
int cfh_tr=398000;
int rcvn_tr=398000;
float cfh_ec_position = (16.0/256.0) ;
int cfl_dda = 4 ;
int cfl_nex = 2 ;
int cfh_dda = 4 ;
int cfh_nex = 2 ;
int rcvn_dda = 0 ;
int rcvn_nex = 1 ;
int presscfh_override = 0 ;
int presscfh = 4 ;
int presscfh_ctrl = 4 ;
int presscfh_outrange = 0;
int presscfh_cgate = 0;
int presscfh_debug = 0 ;
int presscfh_wait_rf12 = 0;
int presscfh_minte = 20000;
float presscfh_fov = 0.0;
float presscfh_fov_ratio = 1.0;
float presscfh_pfov_ratio = 1.0;
float presscfh_slab_ratio = 1.0;
float presscfh_pfov = 0.0;
float presscfh_slthick = 10.0;
float presscfh_ir_slthick = 10.0;
int presscfh_ir_noselect = 1;
float presscfh_minfov_ratio = 0.3;
int cfh_steam_flag = 0;
int steam_pg_gap = 8;
float area_gykcfl = 0;
float area_gykcfh = 0;
int PSoff90=80 ;
int dummy_pw = 0;
int min180te = 0;
float PStloc = 0;
float PSrloc = 0;
float PSphasoff = 0;
int PStrigger = 0;
float PStloc_mod = 0;
float PSrloc_mod = 0;
float thickPS_mod = 0;
float asx_killer_area = 840.0;
float asz_killer_area = 840.0;
float cfhir_killer_area = 4086.0;
float ps_crusher_area = 714.0;
float cfh_crusher_area = 4000.0;
float target_cfh_crusher = 0;
float target_cfh_crusher2 = 0;
int cfh_newmode = 1;
float cfh_rf2freq = 0 ;
float cfh_rf3freq = 0 ;
float cfh_rf1freq = 0 ;
float cfh_fov = 0 ;
int cfh_ti = 120000;
int eff_cfh_te = 50000;
float FTGslthk = 20 ;
float FTGopslthickz1=80 ;
float FTGopslthickz2=80 ;
float FTGopslthickz3=20 ;
int ftgtr = 2000000 ;
float FTGfov = 480.0 ;
float FTGau = 4 ;
float FTGtecho = 4 ;
int FTGtau1 = 8192 ;
int FTGtau2 = 32768 ;
int FTGacq1 = 0 ;
int FTGacq2 = 1 ;
int epi_ir_on = 0 ;
int ssfse_ir_on = 0 ;
int ftg_dda = 0 ;
float FTGecho1bw = 3.90625 ;
int FTGtestpulse = 0
;
int FTGxres = 256 ;
float FTGxmtadd = 0;
int CFLxres = 256 ;
float echo1bwcfl = 2.016129 ;
float echo1bwcfh = 0.50 ;
int echo1ptcfh = 256 ;
float echo1bwrcvn = 15.625 ;
int rcvn_xres = 4096 ;
int rcvn_loops = 10;
float echo1bwas = 15.625 ;
int off90as = 80 ;
int td0as = 4 ;
int t_exaas = 0 ;
int time_ssias = 400 ;
int tleadas = 25 ;
int te_as = 0;
int tr_as = 0;
int as_dda = 4 ;
float aslenap = 200 ;
float aslenrl = 200 ;
float aslensi = 200 ;
float aslocap = 0 ;
float aslocrl = 0 ;
float aslocsi = 0 ;
float area_gxwas = 0;
float area_gz1as = 0;
float area_readrampas = 0;
int avail_pwgx1as = 0;
int avail_pwgy1as = 0;
int avail_pwgz1as = 0;
int bw_rf1as = 0;
float flip_pctas=1.0;
int dix_timeas = 0;
float xmtaddas = 0,xmtlogas = 0;
int asobl_debug = 0
;
int as_newgeo = 1;
int pw_gy1as_tot = 0;
int endview_iampas = 0;
float endview_scaleas = 0;
int cfh_newgeo = 1;
int cfhobl_debug = 0
;
float deltf = 1.0 ;
int IRinCFH = 0 ;
int cfh_each = 0 ;
int cfh_slquant = 0 ;
int noswitch_slab_psc = 0 ;
int noswitch_coil_psc = 0 ;
int PStest_slab = 1 ;
int pimrsapsflg = 0 ;
int pimrsaps1 = 1
;
int pimrsaps2 = 104
;
int pimrsaps3 = 103
;
int pimrsaps4 = 4
;
int pimrsaps5 = 12
;
int pimrsaps6 = 3
;
int pimrsaps7 = 0
;
int pimrsaps8 = 0
;
int pimrsaps9 = 0
;
int pimrsaps10 = 0
;
int pimrsaps11 = 0
;
int pimrsaps12 = 0
;
int pimrsaps13 = 0
;
int pimrsaps14 = 0
;
int pimrsaps15 = 0
;
int pw_contrfhubsel = 4 ;
int delay_rfhubsel = 20;
int pw_contrfsel = 4 ;
int csw_tr = 0 ;
int csw_wait_setrspimm = 100000
;
int csw_wait_before = 10000 ;
int csw_time_ssi = 50
;
float area_gxkrcvn = 10000;
float area_gykrcvn = 10000;
float area_gzkrcvn = 10000;
int pre_rcvn_tr = 20000 ;
int rcvn_flag = 1 ;
float yk0_killer_area = 4140.0;
int ir_on = 0 ;
int ir_start = 0 ;
int irk_start = 0 ;
int ir_grad_time = 0 ;
int ir_time = 0 ;
int ir_time_total= 0 ;
int ext_ir_pulse = 1 ;
float rf0_phase = 0 ;
int non_tetitime = 0 ;
int irslquant = 0;
int bw_rf0 = 0 ;
int hrf0 = 0 ;
int pos_ref = 0;
int pos_start_rf0 = 0 ;
int titime = 0 ;
int seq_shift = 0 ;
int time_to_rf1 = 0;
int inner_spacing = 0;
int post_spacing = 0;
int silver_hoult = 1 ;
float tmpslthick = 0;
float csf_fact=0.5;
float invthick = 0;
int invseqlen = 0;
int invseqlen2 = 0;
int flair_on = 0;
int ir_index = 0 ;
int ir3t_flag = 0;
 int ir_rfupa = -600 ;
 int ir_sys_type = 0 ;
int t2flair_extra_ir_flag = 0 ;
int ss_rf1 = 0 ;
int fat_flag = 0 ;
float fat_delta = -230.0
;
int fat_offset = -386 ;
int sszchop = 0
;
int pw_gzrf1lobe = 0;
int pw_constant = 0;
int num_rf1lobe = 0;
int gradient_mode = 1 ;
int ss_rf_wait = 0
;
int pw_ss_rampz = 0;
int ss_override = 0 ;
int whichss = 0;
float nbw_ssrf = 0;
float ss_min_slthk = 0, ss_maxoff = 0, ss_minslthk1 = 0;
int ss_convolution_flag = 0 ;
int breast_spsp_flag = 0 ;
int ss_fa_scaling_flag = 0 ;
float max_ss_fa = 0;
int ss_maxoffex = 0;
int off90minor = 0;
float omega_amp = 0;
float gz1_zero_moment = 0;
float gz1_first_moment = 0;
int freqSign = 1;
int rtd_on = 0 ;
int maxwell_flag = 1;
int maxwell_blip = 1;
float B0_field = 0;
float pw_gxw_MAX_l = 0;
float pw_gxw_MAX_r = 0;
float pw_gyb_MAX_l = 0;
float pw_gyb_MAX_r = 0;
int max_debug=0;
int nodelay=0;
int nodelayesp=0;
int b0dither_new = 1 ;
int nob0dither=0;
int nob0dither_interpo=0;
int nobcfile=0;
int number_of_bc_files = 0;
int activeReceivers=-1;
int flagWarning = (1);
int refScanTe = 0;
int minTeFrac_ref = 0;
int minTeFull_ref = 0;
int tempTe_ref = 0;
int se_ref = 0;
int reMap = 1;
float asset_factor = 0.5 ;
float assetsl_factor = 1.0 ;
int assetph_flag = 0 ;
int assetsl_flag = 0 ;
int asset_supported_direction = 0
;
int rtb0_flag = 0 ;
int numRtB0 = 1 ;
int rtb0_first_skip = 20 ;
int rtb0_last_skip = 20 ;
int rtb0_movAvg = 5 ;
int rtb0_pathway = 1 ;
int rtb0_min_points = 10 ;
int rtb0DebugFlag = 0;
int rtb0SaveRaw = 0;
int rtb0_comp_flag = 0 ;
int rtb0_acq_delay = 0 ;
int rtb0_midsliceindex = -1 ;
float rtb0_outlier_threshold = 10.0 ;
float rtb0_outlier_duration = 30.0 ;
int rtb0_outlier_nTRs = 0;
int rtb0_minintervalb4acq = 0;
int epiespopt_flag = 0 ;
int epiRTespopt_flag = 0 ;
int epiminesp_flag = 0 ;
int epiRTminesp_flag = 0 ;
int epira3_flag = 0 ;
int epiRTra3_flag = 0 ;
int ra3_minesp_flag = 0 ;
int ra3_sndpc_flag = 0 ;
int dbdt_model = 0 ;
float dbdtper_new = 0;
int esprange_check = 0 ;
int espopt = 1 ;
int espincway = 0 ;
int no_gy1_ol_gxw = 0 ;
int epigradopt_debug = 0;
int epigradopt_output = 0;
int saved_tmin_total = 0;
int tr_corr_mode = 1 ;
int num_passdelay = 1 ;
int temp_rhpcspacial = 0 ;
float taratio = 0.0 ;
int rampopt = 1 ;
int taratio_override = 0 ;
float totarea = 0;
float actratio = 0;
int fmri_coil_limit = 1.0;
int iref_etl = 0 ;
int iref_frames = 0;
int MinFram2FramTime = 30 ;
float phase_dither = 0.0 ;
int spgr_flag = 0 ;
int newyres=0;
int avmintefull = 0 ;
int cvrefindex1 = 0;
int avmintetemp = 0;
int cfh_crusher = 0 ;
int fast_rec = 0 ;
int bl_acq_tr1 = 100000 ;
int bl_acq_tr2 = 300000 ;
float fecho_factor = 0;
float tsp = 8.0 ;
int intleaves = 1 ;
int ky_dir = 2 ;
int dc_chop = 1 ;
int kx_dir = 0 ;
int etot = 0 ;
int emid = 0 ;
int e1st = 0 ;
int seq_data = 0 ;
float msamp = 0.0 ;
float dsamp = 0.0 ;
float delpw = 0;
int reps = 1 ;
int pass_reps = 1 ;
int max_dsht = 8 ;
int rf_chop = 1 ;
int rftype = 1 ;
int thetatype = 0 ;
int gztype = 1 ;
int hsdab = 1 ;
int slice_num = 1 ;
int rep_num = 1 ;
int endview_iamp = 0;
int endview_scale = 0;
int gx1pos = 1 ;
int gy1pos = 1 ;
int eosxkiller = 0 ;
int eosykiller = 1 ;
int eoszkiller = 1 ;
int eoskillers = 1 ;
int eosrhokiller = 1 ;
int gyctrl = 1 ;
int gxctrl = 1 ;
int gzctrl = 1 ;
int ygmn_type = 0;
int zgmn_type = 0;
int vrgfsamp = 0 ;
int autovrgf = 1 ;
float vrgf_targ = 2.0 ;
float fbhw = 1.0 ;
int vrgf_reorder = 1 ;
int osamp = 0 ;
int esp = 0 ;
int etl = 1 ;
int eesp = 0 ;
int nblips = 0, blips2cent = 0;
int ep_alt = 0 ;
int tia_gx1 = 0, tia_gxw = 0, tia_gxk = 0;
float ta_gxwn = 0;
float rbw = 0;
int avminxa = 0, avminxb = 0, avminx = 0, avminya = 0, avminyb = 0, avminy = 0;
int avminza = 0, avminzb = 0, avminz = 0, avminssp = 0;
float avminfovx = 0, avminfovy = 0;
int hrdwr_period = 4 ;
int samp_period = 8 ;
int pwmin_gap = 2*4 ;
float frqx = 200.0 ;
float frqy = 2.0 ;
int dacq_offset = 0 ;
int pepolar = 0 ;
int tdaqhxa = 0, tdaqhxb = 0;
float delt = 0;
int tfon = 1 ;
int fract_ky = 0 ;
float ky_offset = 0.0 ;
float gy1_offset = 0.0 ;
int rhhnover_max=0;
int rhhnover_min = 8;
int num_overscan = 8;
int fract_ky_topdown = 1 ;
int smart_numoverscan = 0 ;
int ky_offset_save = 0;
int rhhnover_save = 0;
int rhnframes_tmp = 0;
int satdelay = 0000 ;
int td0 = 4 ;
int t_exa = 0 ;
int te_time = 0 ;
int pos_start = 0 ;
int post_echo_time = 0 ;
int psd_tseq = 0 ;
int time_ssi = 1000 ;
float dacq_adjust = 0.0 ;
int watchdogcount = 15 ;
int dabdelay = 0 ;
int long_hrdwr_period = 1 ;
int tlead = 25 ;
int tleadssp = 25 ;
int act_tr = 0 ;
int rfconf = 1 + 4 + 8 + 128;
int ctlend = 0 ;
int ctlend_last = 0 ;
int ctlend_fill = 0 ;
int ctlend_unfill = 0 ;
int dda = 0 ;
int debug = 0 ;
int debugipg = 0 ;
int debugepc = 0 ;
int debugRecvFrqPhs= 0 ;
int debugdither = 0 ;
int debugdelay = 0 ;
int debugileave = 0 ;
int dex = 0 ;
int gating = 0 ;
int ipg_trigtest = 1 ;
int gxktime = 0 ;
int gyktime = 0 ;
int gzktime = 0 ;
int gktime = 0 ;
int gkdelay = 100 ;
int scanslot = 0 ;
float gx1_area = 0;
float area_gz1 = 0, area_gzrf2l1 = 0;
float area_std = 0;
int avail_pwgz1 = 0;
int prescan1_tr = 2000000 ;
int ps2_dda = 0 ;
int avail_pwgx1 = 0;
int avail_image_time = 0;
int avail_zflow_time = 0;
int test_getecg = 1;
int premid_rf90 = 0 ;
int sar_amp = 0;
int sar_cycle = 0;
int sar_width = 0;
int max_seqtime = 0;
int max_slicesar = 0;
float myrloc = 0 ;
int other_slice_limit = 0;
float target_area = 0;
float start_amp = 0;
float end_amp = 0;
int pre_pass = 0 ;
int nreps = 0 ;
int max_num_pass = 512 ;
float xmtaddScan = 0;
float rfscale = 1.0 ;
int rfExIso = 0;
int innerVol = 0 ;
float ivslthick = 5 ;
int psd_mantrig = 0 ;
int trig_mps2 = 1 ;
int trig_aps2 = 1 ;
int trig_scan = 1 ;
int trig_prescan = 1 ;
int read_truncate = 1 ;
int trigger_time = 0 ;
int use_myscan = 0 ;
int t_postreadout = 0;
int initnewgeo = 1;
int obl_debug = 0 ;
int obl_method = 1 ;
int debug_order = 0 ;
int debug_tdel = 0 ;
int debug_scan = 0 ;
int postsat = 0;
int order_routine = 0 ;
int scan_offset = 0;
int dither_control = 0;
int dither_value = 0 ;
int slquant_per_trig = 0 ;
int xtr_offset = -56 ;
int non_tetime = 0;
int slice_size = 0;
int max_bamslice = 0;
int bw_rf1 = 0, bw_rf2 = 0;
float a_gx1 = 0;
int ia_gx1 = 0;
int pw_gx1a = 0;
int pw_gx1d = 0;
int pw_gx1 = 0;
int single_ramp_gx1d = 0;
float area_gy1 = 0;
float area_gyb = 0;
float a_omega = 0;
int ia_omega = 0;
int pw_dummy = 0;
float bline_time = 0;
float scan_time = 0;
int pw_gx1_tot = 0;
int pw_gy1_tot = 0;
int pw_gymn1_tot = 0, pw_gymn2_tot = 0;
float gyb_tot_0thmoment = 0;
float gyb_tot_1stmoment = 0;
int pw_gz1_tot = 0;
int pw_gzrf2l1_tot = 0;
int pw_gzrf2r1_tot = 0;
int ia_hyperdab=0;
int ia_hyperdabbl=0;
int dab_offset = 0;
int rcvr_ub_off = -100;
int temprhfrsize = 0;
float zeromoment = 0;
float firstmoment = 0;
float zeromomentsum = 0;
float firstmomentsum = 0;
int pulsepos = 0;
int invertphase = 0;
float xtarg = 1.0 ;
float ytarg = 1.0 ;
int slice_reset = 0 ;
float slice_loc = 0.0 ;
int ditheron = 1 ;
float dx = 0.0 ;
float dy = 0.0 ;
float dz = 0.0 ;
int b0calmode = 0 ;
int delayon = 1 ;
int pkt_delay = 0 ;
int gxdelay = 0 ;
int gydelay = 0 ;
float gldelayx = 0 ;
float gldelayy = 0 ;
float gldelayz = 0 ;
float pckeeppct = 100.0 ;
int mph_flag = 0 ;
int acqmode = 0 ;
int max_phases = 0;
int opslquant_old = 1 ;
int piphases = 0;
int reqesp = 0 ;
int autogap = 0 ;
int minesp = 0;
int fft_xsize = 0 ;
int fft_ysize = 0 ;
int image_size = 0 ;
float xtr_rba_control = 1 ;
float xtr_rba_time = 130 + 5 ;
float frtime = 0.0 ;
int readpolar = 1 ;
int blippolar = 1 ;
int ref_mode = 1 ;
int refnframes = 256 ;
int ref_with_xoffset = 1 ;
int RefDatCorrection = 0 ;
float phaseScale = 2.0 ;
int setDataAcqDelays = 1 ;
int xtr_calibration = 0 ;
int refSliceNum = -1 ;
int ghost_check = 0 ;
int gck_offset_fov = 1 ;
int core_shots = 0;
int disdaq_shots = 0;
int pass_shots = 0;
int passr_shots = 0;
int pass_time = 0;
int pw_gxwl1 = 0;
int pw_gxwl2 = 0;
int pw_gxwr1 = 0;
int pw_gxwr2 = 0;
int pw_gxw_total = 0 ;
int pass_delay = 1 ;
int nshots_locks = 1 ;
int min_nshots = 1 ;
float da_gyboc = 0.0 ;
float oc_fact = 2.0 ;
int oblcorr_on = 1 ;
int oblcorr_perslice = 1 ;
int debug_oblcorr = 0 ;
float bc_delx = 0.0 ;
float bc_dely = 0.0 ;
float bc_delz = 0.0 ;
float percentBlipMod = 0.0;
int cvxfull = 32767;
int cvyfull = 32767;
int cvzfull = 32767;
float bw_flattop = 0;
float area_usedramp = 0;
float pw_usedramp = 0;
float area_usedtotal = 0;
int epispec_flag = 0 ;
float omega_scale= 256.0 ;
int start_pulse = 0;
float my_alpha = 0.0 ;
float my_beta = 0 ;
float my_gamma = 0.0 ;
int ext_trig = 0 ;
float rup_factor = 2.0;
int override_fatsat_high_weight = 0 ;
int bigpat_warning_flag = 1;
int epigradspec_flag = 0 ;
int dvw_grad_test = 0 ;
int fullk_nframes = 1;
int specspat_temp = 1;
int res_temp = 320;
int nom_pw_temp = 1280;
float nom_flip_temp = 90;
float abswidth_temp = 0.32058;
float effwidth_temp = 0.21609;
float area_temp = 0.24701;
float dtycyc_temp = 0.39062;
float maxpw_temp = 1.0;
float max_b1_temp = 0.11607;
float max_int_b1_sqr_temp = 0.00596;
float max_rms_b1_temp = 0.05396;
float nom_bw_temp = 0;
int isodelay_temp = 0;
float a_gzs_temp = 0;
float nom_thk_temp = 0;
int extgradfile_temp = 0;
float nom_thk_rf1 = 0;
float target = 0;
float phase_mod = 10.5 ;
int user_bw = 0;
int met_freqs = 0;
float df1 = 0, df2 = 0, df3 = 0, df4 = 0, df5 = 0;
float df1_ppm = 0 ;
float df2_ppm = 12 ;
float df3_ppm = -8 ;
float df4_ppm = 8 ;
float df5_ppm = 6 ;
float met_ppm = 0;
int wg_omegaro1 = TYPOMEGA;
int touch_flag = 0 ;
float touch_target = 2.2 ;
int touch_rt = 4 ;
int touch_time = 0 ;
int touch_gnum = 1 ;
int touch_period = 0 ;
int touch_lobe = 0 ;
int touch_delta = 0 ;
float touch_act_freq = 60.0 ;
int touch_pwcon = 0 ;
int touch_pwramp = 0 ;
float touch_gdrate = 1.0 ;
float touch_gamp = 1.76 ;
float touch_gamp2 = -1 ;
int touch_xdir = 0 ;
int touch_ydir = 0 ;
int touch_zdir = 0 ;
int touch_burst_count = 60 ;
int touch_ndir = 2 ;
int touch_sync_pw = 50 ;
int touch_fcomp = 2 ;
float touch_menc = 0 ;
int touch_tr_time = 0 ;
int touch_driver_amp = 30 ;
int touch_period_motion = 0;
int touch_period_meg = 0;
int touch_lobe_motion = 0;
int touch_lobe_meg = 0;
float touch_act_freq_motion = 0;
float touch_act_freq_meg = 0;
int touch_pos_sync = 0;
int touch_pos_encode = 0;
int cont_drive_ssp_delay = 0;
int multiphase_flag = 0 ;
int multi_phases = 1 ;
int rf2_time = 0;
int pw_gz2_tot = 0;
int M_half_periods = 0;
int meg_mode = 0;
int grad_axis = 7;
int touch_maxshots = 1;
  int pw_x_td0 = 0;
  int wg_x_td0 = 0;
  int pw_y_td0 = 0;
  int wg_y_td0 = 0;
  int pw_z_td0 = 0;
  int wg_z_td0 = 0;
  int pw_rho_td0 = 0;
  int wg_rho_td0 = 0;
  int pw_theta_td0 = 0;
  int wg_theta_td0 = 0;
  int pw_omega_td0 = 0;
  int wg_omega_td0 = 0;
  int pw_ssp_td0 = 0;
  int wg_ssp_td0 = 0;
    float a_gzrf0 = 0;
    int ia_gzrf0 = 0;
    int pw_gzrf0a = 0;
    int pw_gzrf0d = 0;
    int pw_gzrf0 = 0;
    int res_gzrf0 = 0;
    float a_rf0 = 0;
    int ia_rf0 = 0;
    int pw_rf0 = 0;
    int res_rf0 = 0;
    float cyc_rf0 = 0;
    int off_rf0 = 0;
    float alpha_rf0 = 0.46;
    float thk_rf0 = 0;
    float gscale_rf0 = 1.0;
    float flip_rf0 = 0;
    int wg_rf0 = TYPRHO1
;
  float a_omegarf0 = 0;
  int ia_omegarf0 = 0;
  int pw_omegarf0 = 0;
  int res_omegarf0 = 0;
  int off_omegarf0 = 0;
  int rfslot_omegarf0 = 0;
  float gscale_omegarf0 = 1.0;
  int n_omegarf0 = 0;
  int wg_omegarf0 = 0;
  float a_gyk0 = 0;
  int ia_gyk0 = 0;
  int pw_gyk0a = 0;
  int pw_gyk0d = 0;
  int pw_gyk0 = 0;
  int wg_gyk0 = 0;
    float a_gzrf1 = 0;
    int ia_gzrf1 = 0;
    int pw_gzrf1a = 0;
    int pw_gzrf1d = 0;
    int pw_gzrf1 = 0;
    int res_gzrf1 = 0;
    float a_rf1 = 0;
    int ia_rf1 = 0;
    int pw_rf1 = 0;
    int res_rf1 = 0;
    float cyc_rf1 = 0;
    int off_rf1 = 0;
    float alpha_rf1 = 0.46;
    float thk_rf1 = 0;
    float gscale_rf1 = 1.0;
    float flip_rf1 = 0;
    float a_thetarf1 = 0;
    int ia_thetarf1 = 0;
    int pw_thetarf1 = 0;
    int res_thetarf1 = 0;
    int off_thetarf1 = 0;
    int wg_rf1 = TYPRHO1
;
    int wg_omegarf1 = TYPOMEGA;
  float a_gzrf2 = 0;
  int ia_gzrf2 = 0;
  int pw_gzrf2a = 0;
  int pw_gzrf2d = 0;
  int pw_gzrf2 = 0;
  float a_rf2 = 0;
  int ia_rf2 = 0;
  int pw_rf2 = 0;
  int res_rf2 = 0;
  float cyc_rf2 = 0;
  int off_rf2 = 0;
  float alpha_rf2 = 0.46;
  float thk_rf2 = 0;
  float gscale_rf2 = 1.0;
  float flip_rf2 = 0;
  int wg_rf2 = TYPRHO1
;
  int res_rf2se1b4 = 0;
  int wg_rf2se1b4 = 0;
  float a_gyrf2iv = 0;
  int ia_gyrf2iv = 0;
  int pw_gyrf2iva = 0;
  int pw_gyrf2ivd = 0;
  int pw_gyrf2iv = 0;
  int wg_gyrf2iv = 0;
  float a_gzrf2l1 = 0;
  int ia_gzrf2l1 = 0;
  int pw_gzrf2l1a = 0;
  int pw_gzrf2l1d = 0;
  int pw_gzrf2l1 = 0;
  int wg_gzrf2l1 = 0;
  float a_gzrf2r1 = 0;
  int ia_gzrf2r1 = 0;
  int pw_gzrf2r1a = 0;
  int pw_gzrf2r1d = 0;
  int pw_gzrf2r1 = 0;
  int wg_gzrf2r1 = 0;
  float a_gxcl = 0;
  float a_gxw = 0;
  float a_gxcr = 0;
  float a_gyb = 0;
  int ia_gxcl = 0;
  int ia_gxw = 0;
  int ia_gxcr = 0;
  int ia_gyb = 0;
  int pw_gxcla = 0;
  int pw_gxcl = 0;
  int pw_gxcld = 0;
  int pw_gxwl = 0;
  int pw_gxw = 0;
  int pw_gxwr = 0;
  int pw_gxwad = 0;
  int pw_gxgap = 0;
  int pw_gxcra = 0;
  int pw_gxcr = 0;
  int pw_gxcrd = 0;
  int pw_gyba = 0;
  int pw_gyb = 0;
  int pw_gybd = 0;
  int pw_iref_gxwait = 0;
  int ia_rec_unblank = 0;
  int filter_rtb0echo = 0;
  int ia_rec_unblank2 = 0;
  float a_gy1 = 0;
  float a_gy1a = 0;
  float a_gy1b = 0;
  int ia_gy1 = 0;
  int ia_gy1wa = 0;
  int ia_gy1wb = 0;
  int pw_gy1a = 0;
  int pw_gy1d = 0;
  int pw_gy1 = 0;
  int wg_gy1 = 0;
  float a_gymn2 = 0;
  int ia_gymn2 = 0;
  int pw_gymn2a = 0;
  int pw_gymn2d = 0;
  int pw_gymn2 = 0;
  int wg_gymn2 = 0;
  float a_gymn1 = 0;
  int ia_gymn1 = 0;
  int pw_gymn1a = 0;
  int pw_gymn1d = 0;
  int pw_gymn1 = 0;
  int wg_gymn1 = 0;
  float a_gz1 = 0;
  int ia_gz1 = 0;
  int pw_gz1a = 0;
  int pw_gz1d = 0;
  int pw_gz1 = 0;
  int wg_gz1 = 0;
  float a_gzmn = 0;
  int ia_gzmn = 0;
  int pw_gzmna = 0;
  int pw_gzmnd = 0;
  int pw_gzmn = 0;
  int wg_gzmn = 0;
  int res_rf2se1 = 0;
  int wg_rf2se1 = 0;
  float a_gxk = 0;
  int ia_gxk = 0;
  int pw_gxka = 0;
  int pw_gxkd = 0;
  int pw_gxk = 0;
  int wg_gxk = 0;
  float a_gyk = 0;
  int ia_gyk = 0;
  int pw_gyka = 0;
  int pw_gykd = 0;
  int pw_gyk = 0;
  int wg_gyk = 0;
  float a_gzk = 0;
  int ia_gzk = 0;
  int pw_gzka = 0;
  int pw_gzkd = 0;
  int pw_gzk = 0;
  int wg_gzk = 0;
  int ia_sync_on_2 = 0;
  int ia_sync_off_2 = 0;
  int pw_wgx = 0;
  int wg_wgx = 0;
  int pw_wgy = 0;
  int wg_wgy = 0;
  int pw_wgz = 0;
  int wg_wgz = 0;
  int pw_wssp = 0;
  int wg_wssp = 0;
  int pw_sspdelay = 0;
  int wg_sspdelay = 0;
  int pw_omegadelay = 0;
  int wg_omegadelay = 0;
  int pw_womega = 0;
  int wg_womega = 0;
  int pw_sspshift = 0;
  int wg_sspshift = 0;
  int pw_ssp_pass_delay = 0;
  int wg_ssp_pass_delay = 0;
  int pw_touch_wssp = 0;
  int wg_touch_wssp = 0;
  int ia_rec_unblankref = 0;
  float refa_gxcl = 0;
  float refa_gxw = 0;
  float refa_gxcr = 0;
  float refa_gyb = 0;
  int refia_gxcl = 0;
  int refia_gxw = 0;
  int refia_gxcr = 0;
  int refia_gyb = 0;
  int refpw_gxcla = 0;
  int refpw_gxcl = 0;
  int refpw_gxcld = 0;
  int refpw_gxwl = 0;
  int refpw_gxw = 0;
  int refpw_gxwr = 0;
  int refpw_gxwad = 0;
  int refpw_gxgap = 0;
  int refpw_gxcra = 0;
  int refpw_gxcr = 0;
  int refpw_gxcrd = 0;
  int refpw_gyba = 0;
  int refpw_gyb = 0;
  int refpw_gybd = 0;
  int ia_bline_unblank = 0;
  int filter_blineacq1 = 0;
  float a_gxtouchu2 = 0;
  int ia_gxtouchu2 = 0;
  int pw_gxtouchu2a = 0;
  int pw_gxtouchu2d = 0;
  int pw_gxtouchu2 = 0;
  int wg_gxtouchu2 = 0;
  float a_gytouchu2 = 0;
  int ia_gytouchu2 = 0;
  int pw_gytouchu2a = 0;
  int pw_gytouchu2d = 0;
  int pw_gytouchu2 = 0;
  int wg_gytouchu2 = 0;
  float a_gztouchu2 = 0;
  int ia_gztouchu2 = 0;
  int pw_gztouchu2a = 0;
  int pw_gztouchu2d = 0;
  int pw_gztouchu2 = 0;
  int wg_gztouchu2 = 0;
  float a_gxtouchu = 0;
  int ia_gxtouchu = 0;
  int pw_gxtouchua = 0;
  int pw_gxtouchud = 0;
  int pw_gxtouchu = 0;
  int wg_gxtouchu = 0;
  float a_gytouchu = 0;
  int ia_gytouchu = 0;
  int pw_gytouchua = 0;
  int pw_gytouchud = 0;
  int pw_gytouchu = 0;
  int wg_gytouchu = 0;
  float a_gztouchu = 0;
  int ia_gztouchu = 0;
  int pw_gztouchua = 0;
  int pw_gztouchud = 0;
  int pw_gztouchu = 0;
  int wg_gztouchu = 0;
  float a_gxtouchd2 = 0;
  int ia_gxtouchd2 = 0;
  int pw_gxtouchd2a = 0;
  int pw_gxtouchd2d = 0;
  int pw_gxtouchd2 = 0;
  int wg_gxtouchd2 = 0;
  float a_gytouchd2 = 0;
  int ia_gytouchd2 = 0;
  int pw_gytouchd2a = 0;
  int pw_gytouchd2d = 0;
  int pw_gytouchd2 = 0;
  int wg_gytouchd2 = 0;
  float a_gztouchd2 = 0;
  int ia_gztouchd2 = 0;
  int pw_gztouchd2a = 0;
  int pw_gztouchd2d = 0;
  int pw_gztouchd2 = 0;
  int wg_gztouchd2 = 0;
  float a_gxtouchd = 0;
  int ia_gxtouchd = 0;
  int pw_gxtouchda = 0;
  int pw_gxtouchdd = 0;
  int pw_gxtouchd = 0;
  int wg_gxtouchd = 0;
  float a_gytouchd = 0;
  int ia_gytouchd = 0;
  int pw_gytouchda = 0;
  int pw_gytouchdd = 0;
  int pw_gytouchd = 0;
  int wg_gytouchd = 0;
  float a_gztouchd = 0;
  int ia_gztouchd = 0;
  int pw_gztouchda = 0;
  int pw_gztouchdd = 0;
  int pw_gztouchd = 0;
  int wg_gztouchd = 0;
  float a_gxtouchf2 = 0;
  int ia_gxtouchf2 = 0;
  int pw_gxtouchf2a = 0;
  int pw_gxtouchf2d = 0;
  int pw_gxtouchf2 = 0;
  int wg_gxtouchf2 = 0;
  float a_gytouchf2 = 0;
  int ia_gytouchf2 = 0;
  int pw_gytouchf2a = 0;
  int pw_gytouchf2d = 0;
  int pw_gytouchf2 = 0;
  int wg_gytouchf2 = 0;
  float a_gztouchf2 = 0;
  int ia_gztouchf2 = 0;
  int pw_gztouchf2a = 0;
  int pw_gztouchf2d = 0;
  int pw_gztouchf2 = 0;
  int wg_gztouchf2 = 0;
  float a_gxtouchf = 0;
  int ia_gxtouchf = 0;
  int pw_gxtouchfa = 0;
  int pw_gxtouchfd = 0;
  int pw_gxtouchf = 0;
  int wg_gxtouchf = 0;
  float a_gytouchf = 0;
  int ia_gytouchf = 0;
  int pw_gytouchfa = 0;
  int pw_gytouchfd = 0;
  int pw_gytouchf = 0;
  int wg_gytouchf = 0;
  float a_gztouchf = 0;
  int ia_gztouchf = 0;
  int pw_gztouchfa = 0;
  int pw_gztouchfd = 0;
  int pw_gztouchf = 0;
  int wg_gztouchf = 0;
  int res_rfcssat = 0;
  int wg_rfcssat = 0;
  int res_omega_hs_rfcssat = 0;
  int wg_omega_hs_rfcssat = 0;
  float a_gykcs = 0;
  int ia_gykcs = 0;
  int pw_gykcsa = 0;
  int pw_gykcsd = 0;
  int pw_gykcs = 0;
  int wg_gykcs = 0;
  float a_gxkcs = 0;
  int ia_gxkcs = 0;
  int pw_gxkcsa = 0;
  int pw_gxkcsd = 0;
  int pw_gxkcs = 0;
  int wg_gxkcs = 0;
  float a_gzkcs = 0;
  int ia_gzkcs = 0;
  int pw_gzkcsa = 0;
  int pw_gzkcsd = 0;
  int pw_gzkcs = 0;
  int wg_gzkcs = 0;
  int pw_isi_cardiacsat = 0;
  int wg_isi_cardiacsat = 0;
  int pw_rot_update_cardiacsat = 0;
  int wg_rot_update_cardiacsat = 0;
  float a_gzrfse1 = 0;
  int ia_gzrfse1 = 0;
  int pw_gzrfse1a = 0;
  int pw_gzrfse1d = 0;
  int pw_gzrfse1 = 0;
  float a_rfse1 = 0;
  int ia_rfse1 = 0;
  int pw_rfse1 = 0;
  int res_rfse1 = 0;
  int temp_res_rfse1 = 0;
  float cyc_rfse1 = 0;
  int off_rfse1 = 0;
  float alpha_rfse1 = 0.46;
  float thk_rfse1 = 0;
  float gscale_rfse1 = 1.0;
  float flip_rfse1 = 0;
  int wg_rfse1 = TYPRHO1
;
  int pw_isi_sate1 = 0;
  int wg_isi_sate1 = 0;
  int pw_rot_update_e1 = 0;
  int wg_rot_update_e1 = 0;
  float a_gykse1 = 0;
  int ia_gykse1 = 0;
  int pw_gykse1a = 0;
  int pw_gykse1d = 0;
  int pw_gykse1 = 0;
  int wg_gykse1 = 0;
  float a_gxkse1 = 0;
  int ia_gxkse1 = 0;
  int pw_gxkse1a = 0;
  int pw_gxkse1d = 0;
  int pw_gxkse1 = 0;
  int wg_gxkse1 = 0;
  int pw_isi_satek1 = 0;
  int wg_isi_satek1 = 0;
  int pw_rot_update_ek1 = 0;
  int wg_rot_update_ek1 = 0;
  float a_gzrfse2 = 0;
  int ia_gzrfse2 = 0;
  int pw_gzrfse2a = 0;
  int pw_gzrfse2d = 0;
  int pw_gzrfse2 = 0;
  float a_rfse2 = 0;
  int ia_rfse2 = 0;
  int pw_rfse2 = 0;
  int res_rfse2 = 0;
  int temp_res_rfse2 = 0;
  float cyc_rfse2 = 0;
  int off_rfse2 = 0;
  float alpha_rfse2 = 0.46;
  float thk_rfse2 = 0;
  float gscale_rfse2 = 1.0;
  float flip_rfse2 = 0;
  int wg_rfse2 = TYPRHO1
;
  int pw_isi_sate2 = 0;
  int wg_isi_sate2 = 0;
  int pw_rot_update_e2 = 0;
  int wg_rot_update_e2 = 0;
  float a_gykse2 = 0;
  int ia_gykse2 = 0;
  int pw_gykse2a = 0;
  int pw_gykse2d = 0;
  int pw_gykse2 = 0;
  int wg_gykse2 = 0;
  float a_gxkse2 = 0;
  int ia_gxkse2 = 0;
  int pw_gxkse2a = 0;
  int pw_gxkse2d = 0;
  int pw_gxkse2 = 0;
  int wg_gxkse2 = 0;
  int pw_isi_satek2 = 0;
  int wg_isi_satek2 = 0;
  int pw_rot_update_ek2 = 0;
  int wg_rot_update_ek2 = 0;
  float a_gzrfse3 = 0;
  int ia_gzrfse3 = 0;
  int pw_gzrfse3a = 0;
  int pw_gzrfse3d = 0;
  int pw_gzrfse3 = 0;
  float a_rfse3 = 0;
  int ia_rfse3 = 0;
  int pw_rfse3 = 0;
  int res_rfse3 = 0;
  int temp_res_rfse3 = 0;
  float cyc_rfse3 = 0;
  int off_rfse3 = 0;
  float alpha_rfse3 = 0.46;
  float thk_rfse3 = 0;
  float gscale_rfse3 = 1.0;
  float flip_rfse3 = 0;
  int wg_rfse3 = TYPRHO1
;
  int pw_isi_sate3 = 0;
  int wg_isi_sate3 = 0;
  int pw_rot_update_e3 = 0;
  int wg_rot_update_e3 = 0;
  float a_gykse3 = 0;
  int ia_gykse3 = 0;
  int pw_gykse3a = 0;
  int pw_gykse3d = 0;
  int pw_gykse3 = 0;
  int wg_gykse3 = 0;
  float a_gxkse3 = 0;
  int ia_gxkse3 = 0;
  int pw_gxkse3a = 0;
  int pw_gxkse3d = 0;
  int pw_gxkse3 = 0;
  int wg_gxkse3 = 0;
  int pw_isi_satek3 = 0;
  int wg_isi_satek3 = 0;
  int pw_rot_update_ek3 = 0;
  int wg_rot_update_ek3 = 0;
  float a_gzrfse4 = 0;
  int ia_gzrfse4 = 0;
  int pw_gzrfse4a = 0;
  int pw_gzrfse4d = 0;
  int pw_gzrfse4 = 0;
  float a_rfse4 = 0;
  int ia_rfse4 = 0;
  int pw_rfse4 = 0;
  int res_rfse4 = 0;
  int temp_res_rfse4 = 0;
  float cyc_rfse4 = 0;
  int off_rfse4 = 0;
  float alpha_rfse4 = 0.46;
  float thk_rfse4 = 0;
  float gscale_rfse4 = 1.0;
  float flip_rfse4 = 0;
  int wg_rfse4 = TYPRHO1
;
  int pw_isi_sate4 = 0;
  int wg_isi_sate4 = 0;
  int pw_rot_update_e4 = 0;
  int wg_rot_update_e4 = 0;
  float a_gykse4 = 0;
  int ia_gykse4 = 0;
  int pw_gykse4a = 0;
  int pw_gykse4d = 0;
  int pw_gykse4 = 0;
  int wg_gykse4 = 0;
  float a_gxkse4 = 0;
  int ia_gxkse4 = 0;
  int pw_gxkse4a = 0;
  int pw_gxkse4d = 0;
  int pw_gxkse4 = 0;
  int wg_gxkse4 = 0;
  int pw_isi_satek4 = 0;
  int wg_isi_satek4 = 0;
  int pw_rot_update_ek4 = 0;
  int wg_rot_update_ek4 = 0;
  float a_gzrfse5 = 0;
  int ia_gzrfse5 = 0;
  int pw_gzrfse5a = 0;
  int pw_gzrfse5d = 0;
  int pw_gzrfse5 = 0;
  float a_rfse5 = 0;
  int ia_rfse5 = 0;
  int pw_rfse5 = 0;
  int res_rfse5 = 0;
  int temp_res_rfse5 = 0;
  float cyc_rfse5 = 0;
  int off_rfse5 = 0;
  float alpha_rfse5 = 0.46;
  float thk_rfse5 = 0;
  float gscale_rfse5 = 1.0;
  float flip_rfse5 = 0;
  int wg_rfse5 = TYPRHO1
;
  int pw_isi_sate5 = 0;
  int wg_isi_sate5 = 0;
  int pw_rot_update_e5 = 0;
  int wg_rot_update_e5 = 0;
  float a_gykse5 = 0;
  int ia_gykse5 = 0;
  int pw_gykse5a = 0;
  int pw_gykse5d = 0;
  int pw_gykse5 = 0;
  int wg_gykse5 = 0;
  float a_gxkse5 = 0;
  int ia_gxkse5 = 0;
  int pw_gxkse5a = 0;
  int pw_gxkse5d = 0;
  int pw_gxkse5 = 0;
  int wg_gxkse5 = 0;
  int pw_isi_satek5 = 0;
  int wg_isi_satek5 = 0;
  int pw_rot_update_ek5 = 0;
  int wg_rot_update_ek5 = 0;
  float a_gzrfse6 = 0;
  int ia_gzrfse6 = 0;
  int pw_gzrfse6a = 0;
  int pw_gzrfse6d = 0;
  int pw_gzrfse6 = 0;
  float a_rfse6 = 0;
  int ia_rfse6 = 0;
  int pw_rfse6 = 0;
  int res_rfse6 = 0;
  int temp_res_rfse6 = 0;
  float cyc_rfse6 = 0;
  int off_rfse6 = 0;
  float alpha_rfse6 = 0.46;
  float thk_rfse6 = 0;
  float gscale_rfse6 = 1.0;
  float flip_rfse6 = 0;
  int wg_rfse6 = TYPRHO1
;
  int pw_isi_sate6 = 0;
  int wg_isi_sate6 = 0;
  int pw_rot_update_e6 = 0;
  int wg_rot_update_e6 = 0;
  float a_gykse6 = 0;
  int ia_gykse6 = 0;
  int pw_gykse6a = 0;
  int pw_gykse6d = 0;
  int pw_gykse6 = 0;
  int wg_gykse6 = 0;
  float a_gxkse6 = 0;
  int ia_gxkse6 = 0;
  int pw_gxkse6a = 0;
  int pw_gxkse6d = 0;
  int pw_gxkse6 = 0;
  int wg_gxkse6 = 0;
  int pw_isi_satek6 = 0;
  int wg_isi_satek6 = 0;
  int pw_rot_update_ek6 = 0;
  int wg_rot_update_ek6 = 0;
  float a_gxrfsx1 = 0;
  int ia_gxrfsx1 = 0;
  int pw_gxrfsx1a = 0;
  int pw_gxrfsx1d = 0;
  int pw_gxrfsx1 = 0;
  float a_rfsx1 = 0;
  int ia_rfsx1 = 0;
  int pw_rfsx1 = 0;
  int res_rfsx1 = 0;
  int temp_res_rfsx1 = 0;
  float cyc_rfsx1 = 0;
  int off_rfsx1 = 0;
  float alpha_rfsx1 = 0.46;
  float gscale_rfsx1 = 1.0;
  float thk_rfsx1 = 0;
  float flip_rfsx1 = 0;
  int wg_rfsx1 = TYPRHO1
;
  int pw_isi_satx1 = 0;
  int wg_isi_satx1 = 0;
  int pw_rot_update_x1 = 0;
  int wg_rot_update_x1 = 0;
  float a_gyksx1 = 0;
  int ia_gyksx1 = 0;
  int pw_gyksx1a = 0;
  int pw_gyksx1d = 0;
  int pw_gyksx1 = 0;
  int wg_gyksx1 = 0;
  float a_gxksx1 = 0;
  int ia_gxksx1 = 0;
  int pw_gxksx1a = 0;
  int pw_gxksx1d = 0;
  int pw_gxksx1 = 0;
  int wg_gxksx1 = 0;
  int pw_isi_satxk1 = 0;
  int wg_isi_satxk1 = 0;
  int pw_rot_update_xk1 = 0;
  int wg_rot_update_xk1 = 0;
  float a_gxrfsx2 = 0;
  int ia_gxrfsx2 = 0;
  int pw_gxrfsx2a = 0;
  int pw_gxrfsx2d = 0;
  int pw_gxrfsx2 = 0;
  float a_rfsx2 = 0;
  int ia_rfsx2 = 0;
  int pw_rfsx2 = 0;
  int res_rfsx2 = 0;
  int temp_res_rfsx2 = 0;
  float cyc_rfsx2 = 0;
  int off_rfsx2 = 0;
  float alpha_rfsx2 = 0.46;
  float gscale_rfsx2 = 1.0;
  float thk_rfsx2 = 0;
  float flip_rfsx2 = 0;
  int wg_rfsx2 = TYPRHO1
;
  int pw_isi_satx2 = 0;
  int wg_isi_satx2 = 0;
  int pw_rot_update_x2 = 0;
  int wg_rot_update_x2 = 0;
  float a_gyksx2 = 0;
  int ia_gyksx2 = 0;
  int pw_gyksx2a = 0;
  int pw_gyksx2d = 0;
  int pw_gyksx2 = 0;
  int wg_gyksx2 = 0;
  float a_gxksx2 = 0;
  int ia_gxksx2 = 0;
  int pw_gxksx2a = 0;
  int pw_gxksx2d = 0;
  int pw_gxksx2 = 0;
  int wg_gxksx2 = 0;
  int pw_isi_satxk2 = 0;
  int wg_isi_satxk2 = 0;
  int pw_rot_update_xk2 = 0;
  int wg_rot_update_xk2 = 0;
  float a_gyrfsy1 = 0;
  int ia_gyrfsy1 = 0;
  int pw_gyrfsy1a = 0;
  int pw_gyrfsy1d = 0;
  int pw_gyrfsy1 = 0;
  float a_rfsy1 = 0;
  int ia_rfsy1 = 0;
  int pw_rfsy1 = 0;
  int res_rfsy1 = 0;
  int temp_res_rfsy1 = 0;
  float cyc_rfsy1 = 0;
  int off_rfsy1 = 0;
  float alpha_rfsy1 = 0.46;
  float thk_rfsy1 = 0;
  float gscale_rfsy1 = 1.0;
  float flip_rfsy1 = 0;
  int wg_rfsy1 = TYPRHO1
;
  int pw_isi_saty1 = 0;
  int wg_isi_saty1 = 0;
  int pw_rot_update_y1 = 0;
  int wg_rot_update_y1 = 0;
  float a_gyksy1 = 0;
  int ia_gyksy1 = 0;
  int pw_gyksy1a = 0;
  int pw_gyksy1d = 0;
  int pw_gyksy1 = 0;
  int wg_gyksy1 = 0;
  float a_gxksy1 = 0;
  int ia_gxksy1 = 0;
  int pw_gxksy1a = 0;
  int pw_gxksy1d = 0;
  int pw_gxksy1 = 0;
  int wg_gxksy1 = 0;
  int pw_isi_satyk1 = 0;
  int wg_isi_satyk1 = 0;
  int pw_rot_update_yk1 = 0;
  int wg_rot_update_yk1 = 0;
  float a_gyrfsy2 = 0;
  int ia_gyrfsy2 = 0;
  int pw_gyrfsy2a = 0;
  int pw_gyrfsy2d = 0;
  int pw_gyrfsy2 = 0;
  float a_rfsy2 = 0;
  int ia_rfsy2 = 0;
  int pw_rfsy2 = 0;
  int res_rfsy2 = 0;
  int temp_res_rfsy2 = 0;
  float cyc_rfsy2 = 0;
  int off_rfsy2 = 0;
  float alpha_rfsy2 = 0.46;
  float thk_rfsy2 = 0;
  float gscale_rfsy2 = 1.0;
  float flip_rfsy2 = 0;
  int wg_rfsy2 = TYPRHO1
;
  int pw_isi_saty2 = 0;
  int wg_isi_saty2 = 0;
  int pw_rot_update_y2 = 0;
  int wg_rot_update_y2 = 0;
  float a_gyksy2 = 0;
  int ia_gyksy2 = 0;
  int pw_gyksy2a = 0;
  int pw_gyksy2d = 0;
  int pw_gyksy2 = 0;
  int wg_gyksy2 = 0;
  float a_gxksy2 = 0;
  int ia_gxksy2 = 0;
  int pw_gxksy2a = 0;
  int pw_gxksy2d = 0;
  int pw_gxksy2 = 0;
  int wg_gxksy2 = 0;
  int pw_isi_satyk2 = 0;
  int wg_isi_satyk2 = 0;
  int pw_rot_update_yk2 = 0;
  int wg_rot_update_yk2 = 0;
  float a_gzrfsz1 = 0;
  int ia_gzrfsz1 = 0;
  int pw_gzrfsz1a = 0;
  int pw_gzrfsz1d = 0;
  int pw_gzrfsz1 = 0;
  float a_rfsz1 = 0;
  int ia_rfsz1 = 0;
  int pw_rfsz1 = 0;
  int res_rfsz1 = 0;
  int temp_res_rfsz1 = 0;
  float cyc_rfsz1 = 0;
  int off_rfsz1 = 0;
  float alpha_rfsz1 = 0.46;
  float thk_rfsz1 = 0;
  float gscale_rfsz1 = 1.0;
  float flip_rfsz1 = 0;
  int wg_rfsz1 = TYPRHO1
;
  int pw_isi_satz1 = 0;
  int wg_isi_satz1 = 0;
  int pw_rot_update_z1 = 0;
  int wg_rot_update_z1 = 0;
  float a_gyksz1 = 0;
  int ia_gyksz1 = 0;
  int pw_gyksz1a = 0;
  int pw_gyksz1d = 0;
  int pw_gyksz1 = 0;
  int wg_gyksz1 = 0;
  float a_gxksz1 = 0;
  int ia_gxksz1 = 0;
  int pw_gxksz1a = 0;
  int pw_gxksz1d = 0;
  int pw_gxksz1 = 0;
  int wg_gxksz1 = 0;
  int pw_isi_satzk1 = 0;
  int wg_isi_satzk1 = 0;
  int pw_rot_update_zk1 = 0;
  int wg_rot_update_zk1 = 0;
  float a_gzrfsz2 = 0;
  int ia_gzrfsz2 = 0;
  int pw_gzrfsz2a = 0;
  int pw_gzrfsz2d = 0;
  int pw_gzrfsz2 = 0;
  float a_rfsz2 = 0;
  int ia_rfsz2 = 0;
  int pw_rfsz2 = 0;
  int res_rfsz2 = 0;
  int temp_res_rfsz2 = 0;
  float cyc_rfsz2 = 0;
  int off_rfsz2 = 0;
  float alpha_rfsz2 = 0.46;
  float thk_rfsz2 = 0;
  float gscale_rfsz2 = 1.0;
  float flip_rfsz2 = 0;
  int wg_rfsz2 = TYPRHO1
;
  int pw_isi_satz2 = 0;
  int wg_isi_satz2 = 0;
  int pw_rot_update_z2 = 0;
  int wg_rot_update_z2 = 0;
  float a_gyksz2 = 0;
  int ia_gyksz2 = 0;
  int pw_gyksz2a = 0;
  int pw_gyksz2d = 0;
  int pw_gyksz2 = 0;
  int wg_gyksz2 = 0;
  float a_gxksz2 = 0;
  int ia_gxksz2 = 0;
  int pw_gxksz2a = 0;
  int pw_gxksz2d = 0;
  int pw_gxksz2 = 0;
  int wg_gxksz2 = 0;
  int pw_isi_satzk2 = 0;
  int wg_isi_satzk2 = 0;
  int pw_rot_update_zk2 = 0;
  int wg_rot_update_zk2 = 0;
  int pw_y_ccs_null = 0;
  int wg_y_ccs_null = 0;
  float a_gzrf1mps1 = 0;
  int ia_gzrf1mps1 = 0;
  int pw_gzrf1mps1a = 0;
  int pw_gzrf1mps1d = 0;
  int pw_gzrf1mps1 = 0;
  float a_rf1mps1 = 0;
  int ia_rf1mps1 = 0;
  int pw_rf1mps1 = 0;
  int res_rf1mps1 = 0;
  int temp_res_rf1mps1 = 0;
  float cyc_rf1mps1 = 0;
  int off_rf1mps1 = 0;
  float alpha_rf1mps1 = 0.46;
  float thk_rf1mps1 = 0;
  float gscale_rf1mps1 = 1.0;
  float flip_rf1mps1 = 0;
  int wg_rf1mps1 = TYPRHO1
;
  float a_gz1mps1 = 0;
  int ia_gz1mps1 = 0;
  int pw_gz1mps1a = 0;
  int pw_gz1mps1d = 0;
  int pw_gz1mps1 = 0;
  int wg_gz1mps1 = 0;
  float a_gx1mps1 = 0;
  int ia_gx1mps1 = 0;
  int pw_gx1mps1a = 0;
  int pw_gx1mps1d = 0;
  int pw_gx1mps1 = 0;
  int wg_gx1mps1 = 0;
  float a_gzrf2mps1 = 0;
  int ia_gzrf2mps1 = 0;
  int pw_gzrf2mps1a = 0;
  int pw_gzrf2mps1d = 0;
  int pw_gzrf2mps1 = 0;
  float a_rf2mps1 = 0;
  int ia_rf2mps1 = 0;
  int pw_rf2mps1 = 0;
  int res_rf2mps1 = 0;
  int temp_res_rf2mps1 = 0;
  float cyc_rf2mps1 = 0;
  int off_rf2mps1 = 0;
  float alpha_rf2mps1 = 0.46;
  float thk_rf2mps1 = 0;
  float gscale_rf2mps1 = 1.0;
  float flip_rf2mps1 = 0;
  int wg_rf2mps1 = TYPRHO1
;
  float a_gzrf2lmps1 = 0;
  int ia_gzrf2lmps1 = 0;
  int pw_gzrf2lmps1a = 0;
  int pw_gzrf2lmps1d = 0;
  int pw_gzrf2lmps1 = 0;
  int wg_gzrf2lmps1 = 0;
  float a_gzrf2rmps1 = 0;
  int ia_gzrf2rmps1 = 0;
  int pw_gzrf2rmps1a = 0;
  int pw_gzrf2rmps1d = 0;
  int pw_gzrf2rmps1 = 0;
  int wg_gzrf2rmps1 = 0;
  float a_gxwmps1 = 0;
  int ia_gxwmps1 = 0;
  int pw_gxwmps1a = 0;
  int pw_gxwmps1d = 0;
  int pw_gxwmps1 = 0;
  int wg_gxwmps1 = 0;
  int filter_echo1mps1 = 0;
  float a_gzrf1cfl = 0;
  int ia_gzrf1cfl = 0;
  int pw_gzrf1cfla = 0;
  int pw_gzrf1cfld = 0;
  int pw_gzrf1cfl = 0;
  float a_rf1cfl = 0;
  int ia_rf1cfl = 0;
  int pw_rf1cfl = 0;
  int res_rf1cfl = 0;
  int temp_res_rf1cfl = 0;
  float cyc_rf1cfl = 0;
  int off_rf1cfl = 0;
  float alpha_rf1cfl = 0.46;
  float thk_rf1cfl = 0;
  float gscale_rf1cfl = 1.0;
  float flip_rf1cfl = 0;
  int wg_rf1cfl = TYPRHO1
;
  float a_gz1cfl = 0;
  int ia_gz1cfl = 0;
  int pw_gz1cfla = 0;
  int pw_gz1cfld = 0;
  int pw_gz1cfl = 0;
  int wg_gz1cfl = 0;
  int filter_cfl_fid = 0;
  float a_gykcfl = 0;
  int ia_gykcfl = 0;
  int pw_gykcfla = 0;
  int pw_gykcfld = 0;
  int pw_gykcfl = 0;
  int wg_gykcfl = 0;
  float a_gxkrcvn = 0;
  int ia_gxkrcvn = 0;
  int pw_gxkrcvna = 0;
  int pw_gxkrcvnd = 0;
  int pw_gxkrcvn = 0;
  int wg_gxkrcvn = 0;
  float a_gykrcvn = 0;
  int ia_gykrcvn = 0;
  int pw_gykrcvna = 0;
  int pw_gykrcvnd = 0;
  int pw_gykrcvn = 0;
  int wg_gykrcvn = 0;
  float a_gzkrcvn = 0;
  int ia_gzkrcvn = 0;
  int pw_gzkrcvna = 0;
  int pw_gzkrcvnd = 0;
  int pw_gzkrcvn = 0;
  int wg_gzkrcvn = 0;
  int pw_rcvn_wait = 0;
  int wg_rcvn_wait = 0;
  int ia_rcvrbl = 0;
  int filter_rcvn_fid = 0;
  int ia_rcvrbl2 = 0;
  float a_gzrf0cfh = 0;
  int ia_gzrf0cfh = 0;
  int pw_gzrf0cfha = 0;
  int pw_gzrf0cfhd = 0;
  int pw_gzrf0cfh = 0;
  int res_gzrf0cfh = 0;
  float a_rf0cfh = 0;
  int ia_rf0cfh = 0;
  int pw_rf0cfh = 0;
  int res_rf0cfh = 0;
  float cyc_rf0cfh = 0;
  int off_rf0cfh = 0;
  float alpha_rf0cfh = 0.46;
  float thk_rf0cfh = 0;
  float gscale_rf0cfh = 1.0;
  float flip_rf0cfh = 0;
  int wg_rf0cfh = TYPRHO1
;
  float a_omegarf0cfh = 0;
  int ia_omegarf0cfh = 0;
  int pw_omegarf0cfh = 0;
  int res_omegarf0cfh = 0;
  int off_omegarf0cfh = 0;
  int rfslot_omegarf0cfh = 0;
  float gscale_omegarf0cfh = 1.0;
  int n_omegarf0cfh = 0;
  int wg_omegarf0cfh = 0;
  float a_gyrf0kcfh = 0;
  int ia_gyrf0kcfh = 0;
  int pw_gyrf0kcfha = 0;
  int pw_gyrf0kcfhd = 0;
  int pw_gyrf0kcfh = 0;
  int wg_gyrf0kcfh = 0;
  int pw_zticfh = 0;
  int wg_zticfh = 0;
  int pw_rticfh = 0;
  int wg_rticfh = 0;
  int pw_xticfh = 0;
  int wg_xticfh = 0;
  int pw_yticfh = 0;
  int wg_yticfh = 0;
  int pw_sticfh = 0;
  int wg_sticfh = 0;
  float a_gzrf1cfh = 0;
  int ia_gzrf1cfh = 0;
  int pw_gzrf1cfha = 0;
  int pw_gzrf1cfhd = 0;
  int pw_gzrf1cfh = 0;
  float a_rf1cfh = 0;
  int ia_rf1cfh = 0;
  int pw_rf1cfh = 0;
  int res_rf1cfh = 0;
  int temp_res_rf1cfh = 0;
  float cyc_rf1cfh = 0;
  int off_rf1cfh = 0;
  float alpha_rf1cfh = 0.46;
  float thk_rf1cfh = 0;
  float gscale_rf1cfh = 1.0;
  float flip_rf1cfh = 0;
  int wg_rf1cfh = TYPRHO1
;
  float a_rf2cfh = 0;
  int ia_rf2cfh = 0;
  int pw_rf2cfh = 0;
  int res_rf2cfh = 0;
  float cyc_rf2cfh = 0;
  int off_rf2cfh = 0;
  float alpha_rf2cfh = 0;
  int wg_rf2cfh = 0;
  float a_rf3cfh = 0;
  int ia_rf3cfh = 0;
  int pw_rf3cfh = 0;
  int res_rf3cfh = 0;
  float cyc_rf3cfh = 0;
  int off_rf3cfh = 0;
  float alpha_rf3cfh = 0;
  int wg_rf3cfh = 0;
  float a_gxrf2cfh = 0;
  int ia_gxrf2cfh = 0;
  int pw_gxrf2cfha = 0;
  int pw_gxrf2cfhd = 0;
  int pw_gxrf2cfh = 0;
  int wg_gxrf2cfh = 0;
  float a_gyrf2cfh = 0;
  int ia_gyrf2cfh = 0;
  int pw_gyrf2cfha = 0;
  int pw_gyrf2cfhd = 0;
  int pw_gyrf2cfh = 0;
  int wg_gyrf2cfh = 0;
  float a_gzrf2lcfh = 0;
  int ia_gzrf2lcfh = 0;
  int pw_gzrf2lcfha = 0;
  int pw_gzrf2lcfhd = 0;
  int pw_gzrf2lcfh = 0;
  int wg_gzrf2lcfh = 0;
  float a_gzrf2rcfh = 0;
  int ia_gzrf2rcfh = 0;
  int pw_gzrf2rcfha = 0;
  int pw_gzrf2rcfhd = 0;
  int pw_gzrf2rcfh = 0;
  int wg_gzrf2rcfh = 0;
  float a_gyrf3cfh = 0;
  int ia_gyrf3cfh = 0;
  int pw_gyrf3cfha = 0;
  int pw_gyrf3cfhd = 0;
  int pw_gyrf3cfh = 0;
  int wg_gyrf3cfh = 0;
  float a_gzrf3lcfh = 0;
  int ia_gzrf3lcfh = 0;
  int pw_gzrf3lcfha = 0;
  int pw_gzrf3lcfhd = 0;
  int pw_gzrf3lcfh = 0;
  int wg_gzrf3lcfh = 0;
  float a_gzrf3rcfh = 0;
  int ia_gzrf3rcfh = 0;
  int pw_gzrf3rcfha = 0;
  int pw_gzrf3rcfhd = 0;
  int pw_gzrf3rcfh = 0;
  int wg_gzrf3rcfh = 0;
  float a_gy1cfh = 0;
  int ia_gy1cfh = 0;
  int pw_gy1cfha = 0;
  int pw_gy1cfhd = 0;
  int pw_gy1cfh = 0;
  int wg_gy1cfh = 0;
  float a_gx1cfh = 0;
  int ia_gx1cfh = 0;
  int pw_gx1cfha = 0;
  int pw_gx1cfhd = 0;
  int pw_gx1cfh = 0;
  int wg_gx1cfh = 0;
  int filter_cfh_fid = 0;
  float a_gykcfh = 0;
  int ia_gykcfh = 0;
  int pw_gykcfha = 0;
  int pw_gykcfhd = 0;
  int pw_gykcfh = 0;
  int wg_gykcfh = 0;
  int ia_contrfhubsel = 0;
  int ia_contrfsel = 0;
  int pw_csw_wait = 0;
  int wg_csw_wait = 0;
  float a_gzrf1ftg = 0;
  int ia_gzrf1ftg = 0;
  int pw_gzrf1ftga = 0;
  int pw_gzrf1ftgd = 0;
  int pw_gzrf1ftg = 0;
  float a_rf1ftg = 0;
  int ia_rf1ftg = 0;
  int pw_rf1ftg = 0;
  int res_rf1ftg = 0;
  int temp_res_rf1ftg = 0;
  float cyc_rf1ftg = 0;
  int off_rf1ftg = 0;
  float alpha_rf1ftg = 0.46;
  float thk_rf1ftg = 0;
  float gscale_rf1ftg = 1.0;
  float flip_rf1ftg = 0;
  int wg_rf1ftg = TYPRHO1
;
  float a_gz1ftg = 0;
  int ia_gz1ftg = 0;
  int pw_gz1ftga = 0;
  int pw_gz1ftgd = 0;
  int pw_gz1ftg = 0;
  int wg_gz1ftg = 0;
  float a_gzrf2ftg = 0;
  int ia_gzrf2ftg = 0;
  int pw_gzrf2ftga = 0;
  int pw_gzrf2ftgd = 0;
  int pw_gzrf2ftg = 0;
  float a_rf2ftg = 0;
  int ia_rf2ftg = 0;
  int pw_rf2ftg = 0;
  int res_rf2ftg = 0;
  int temp_res_rf2ftg = 0;
  float cyc_rf2ftg = 0;
  int off_rf2ftg = 0;
  float alpha_rf2ftg = 0.46;
  float thk_rf2ftg = 0;
  float gscale_rf2ftg = 1.0;
  float flip_rf2ftg = 0;
  int wg_rf2ftg = TYPRHO1
;
  float a_gz2ftg = 0;
  int ia_gz2ftg = 0;
  int pw_gz2ftga = 0;
  int pw_gz2ftgd = 0;
  int pw_gz2ftg = 0;
  int wg_gz2ftg = 0;
  float a_gzrf3ftg = 0;
  int ia_gzrf3ftg = 0;
  int pw_gzrf3ftga = 0;
  int pw_gzrf3ftgd = 0;
  int pw_gzrf3ftg = 0;
  float a_rf3ftg = 0;
  int ia_rf3ftg = 0;
  int pw_rf3ftg = 0;
  int res_rf3ftg = 0;
  int temp_res_rf3ftg = 0;
  float cyc_rf3ftg = 0;
  int off_rf3ftg = 0;
  float alpha_rf3ftg = 0.46;
  float thk_rf3ftg = 0;
  float gscale_rf3ftg = 1.0;
  float flip_rf3ftg = 0;
  int wg_rf3ftg = TYPRHO1
;
  float a_gz3ftg = 0;
  int ia_gz3ftg = 0;
  int pw_gz3ftga = 0;
  int pw_gz3ftgd = 0;
  int pw_gz3ftg = 0;
  int wg_gz3ftg = 0;
  float a_gx1ftg = 0;
  int ia_gx1ftg = 0;
  int pw_gx1ftga = 0;
  int pw_gx1ftgd = 0;
  int pw_gx1ftg = 0;
  int wg_gx1ftg = 0;
  float a_gx1bftg = 0;
  int ia_gx1bftg = 0;
  int pw_gx1bftga = 0;
  int pw_gx1bftgd = 0;
  int pw_gx1bftg = 0;
  int wg_gx1bftg = 0;
  float a_gxw1ftg = 0;
  int ia_gxw1ftg = 0;
  int pw_gxw1ftga = 0;
  int pw_gxw1ftgd = 0;
  int pw_gxw1ftg = 0;
  int wg_gxw1ftg = 0;
  float a_postgxw1ftg = 0;
  int ia_postgxw1ftg = 0;
  int pw_postgxw1ftga = 0;
  int pw_postgxw1ftgd = 0;
  int pw_postgxw1ftg = 0;
  int wg_postgxw1ftg = 0;
  int filter_echo1ftg = 0;
  float a_gz2bftg = 0;
  int ia_gz2bftg = 0;
  int pw_gz2bftga = 0;
  int pw_gz2bftgd = 0;
  int pw_gz2bftg = 0;
  int wg_gz2bftg = 0;
  float a_gx2ftg = 0;
  int ia_gx2ftg = 0;
  int pw_gx2ftga = 0;
  int pw_gx2ftgd = 0;
  int pw_gx2ftg = 0;
  int wg_gx2ftg = 0;
  float a_gxw2ftg = 0;
  int ia_gxw2ftg = 0;
  int pw_gxw2ftga = 0;
  int pw_gxw2ftgd = 0;
  int pw_gxw2ftg = 0;
  int wg_gxw2ftg = 0;
  float a_gx2test = 0;
  int ia_gx2test = 0;
  int pw_gx2testa = 0;
  int pw_gx2testd = 0;
  int pw_gx2test = 0;
  int wg_gx2test = 0;
  int filter_echo2ftg = 0;
  float a_gzrf1as = 0;
  int ia_gzrf1as = 0;
  int pw_gzrf1asa = 0;
  int pw_gzrf1asd = 0;
  int pw_gzrf1as = 0;
  float a_rf1as = 0;
  int ia_rf1as = 0;
  int pw_rf1as = 0;
  int res_rf1as = 0;
  int temp_res_rf1as = 0;
  float cyc_rf1as = 0;
  int off_rf1as = 0;
  float alpha_rf1as = 0.46;
  float thk_rf1as = 0;
  float gscale_rf1as = 1.0;
  float flip_rf1as = 0;
  int wg_rf1as = TYPRHO1
;
  float a_gz1as = 0;
  int ia_gz1as = 0;
  int pw_gz1asa = 0;
  int pw_gz1asd = 0;
  int pw_gz1as = 0;
  int wg_gz1as = 0;
  float a_gxwas = 0;
  int ia_gxwas = 0;
  int pw_gxwasa = 0;
  int pw_gxwasd = 0;
  int pw_gxwas = 0;
  int wg_gxwas = 0;
  int filter_echo1as = 0;
  float a_gx1as = 0;
  int ia_gx1as = 0;
  int pw_gx1asa = 0;
  int pw_gx1asd = 0;
  int pw_gx1as = 0;
  int wg_gx1as = 0;
  float a_gy1as = 0;
  float a_gy1asa = 0;
  float a_gy1asb = 0;
  int ia_gy1as = 0;
  int ia_gy1aswa = 0;
  int ia_gy1aswb = 0;
  int pw_gy1asa = 0;
  int pw_gy1asd = 0;
  int pw_gy1as = 0;
  int wg_gy1as = 0;
  float a_gy1ras = 0;
  float a_gy1rasa = 0;
  float a_gy1rasb = 0;
  int ia_gy1ras = 0;
  int ia_gy1raswa = 0;
  int ia_gy1raswb = 0;
  int pw_gy1rasa = 0;
  int pw_gy1rasd = 0;
  int pw_gy1ras = 0;
  int wg_gy1ras = 0;
  float a_gxkas = 0;
  int ia_gxkas = 0;
  int pw_gxkasa = 0;
  int pw_gxkasd = 0;
  int pw_gxkas = 0;
  int wg_gxkas = 0;
  float a_gzkas = 0;
  int ia_gzkas = 0;
  int pw_gzkasa = 0;
  int pw_gzkasd = 0;
  int pw_gzkas = 0;
  int wg_gzkas = 0;
  float a_xdixon = 0;
  int ia_xdixon = 0;
  int pw_xdixon = 0;
  int wg_xdixon = 0;
  float a_ydixon = 0;
  int ia_ydixon = 0;
  int pw_ydixon = 0;
  int wg_ydixon = 0;
  float a_zdixon = 0;
  int ia_zdixon = 0;
  int pw_zdixon = 0;
  int wg_zdixon = 0;
  float a_sdixon = 0;
  int ia_sdixon = 0;
  int pw_sdixon = 0;
  int wg_sdixon = 0;
  float a_sdixon2 = 0;
  int ia_sdixon2 = 0;
  int pw_sdixon2 = 0;
  int wg_sdixon2 = 0;
long _lastcv = 0;
RSP_INFO rsp_info[(2048)] = { {0,0,0,0} };
long rsprot[2*(2048)][9]= {{0}};
long rsptrigger[2*(2048)]= {0};
long ipg_alloc_instr[9] = {
4096,
4096,
4096,
4096,
4096,
4096,
4096,
8192,
64};
RSP_INFO asrsp_info[3] = { {0,0,0,0} };
long sat_rot_matrices[14][9]= {{0}};
PHYS_GRAD phygrd = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
LOG_GRAD loggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
LOG_GRAD satloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
LOG_GRAD asloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
SCAN_INFO asscan_info[3] = { {0,0,0,{0}} };
long PSrot[1][9]= {{0}};
long PSrot_mod[1][9]= {{0}};
PHASE_OFF phase_off[(2048)] = { {0,0} };
int yres_phase= {0};
int yoffs1= {0};
int off_rfcsz_base[(2048)]= {0};
SCAN_INFO scan_info_base[1] = { {0,0,0,{0}} };
float xyz_base[(2048)][3]= {{0}};
long rsprot_base[2*(2048)][9]= {{0}};
int rtia_first_scan_flag = 1 ;
RSP_PSC_INFO rsp_psc_info[5] = { {0,0,0,{0},0,0,0} };
COIL_INFO coilInfo_tgt[10] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };
COIL_INFO volRecCoilInfo_tgt[10] = { { {0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } };
TX_COIL_INFO txCoilInfo_tgt[5] = { { 0,0,0,0,0,0,0,0,0,{0},0,0,{0},{0},{0},0 } };
ChannelTransTableEntryType cttEntry_tgt[4] = { { {0},{0},0,0,0,{0} } };
int PSfreq_offset[20]= {0};
int cfl_tdaq= {0};
int cfh_tdaq= {0};
int rcvn_tdaq= {0};
long rsp_PSrot[5] [9]= {{0}};
long presscfh_PSrot[5] [9]= {{0}};
PSC_INFO presscfh_info[5]={ {0,0,0,{0},0,0,0} };
LOG_GRAD cfhloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
WF_PROCESSOR read_axis = TYPXGRAD;
char ext_spsp_fatsat_rf_filename[256]= {0};
char ext_spsp_fatsat_gz_filename[256]= {0};
long rsprot_unscaled[(2048)][9]= {{0}};
int off_rfcsz[(2048)]= {0};
int field_strength= {0};
PHYS_GRAD epiphygrd = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
LOG_GRAD epiloggrd = {0,0,0,0,0,0,{0,0,0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},{0,0,0,0},0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
RF_PULSE_INFO rfpulseInfo[16 +13] = { {0,0} };
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
float taratio_arr[3]= {0};
float totarea_arr[3]= {0};
char ssrffile[40]= {0};
char ssgzfile[40]= {0};
char hgzssfn[40]= {0};
long _lasttgtex = 0;
