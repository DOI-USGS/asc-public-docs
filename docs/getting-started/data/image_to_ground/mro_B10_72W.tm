KPL/MK

   This meta-kernel lists the MRO SPICE kernels providing coverage for
   2009. All of the kernels listed below are archived in the MRO SPICE
   data set (DATA_SET_ID = "MRO-M-SPICE-6-V1.0"). This set of files and
   the order in which they are listed were picked to provide the best
   available data and the most complete coverage for the specified year
   based on the information about the kernels available at the time
   this meta-kernel was made. For detailed information about the
   kernels listed below refer to the internal comments included in the
   kernels and the documentation accompanying the MRO SPICE data set.

   It is recommended that users make a local copy of this file and
   modify the value of the PATH_VALUES keyword to point to the actual
   location of the MRO SPICE data set's ``data'' directory on their
   system. Replacing ``/'' with ``\'' and converting line terminators
   to the format native to the user's system may also be required if
   this meta-kernel is to be used on a non-UNIX workstation.

   This file was created on February 24, 2021 by Marc Costa Sitja, NAIF/JPL.
   The original name of this file was mro_2009_v14.tm.

   \begindata

      PATH_VALUES     = ( '.' )

      PATH_SYMBOLS    = ( 'KERNELS' )

      KERNELS_TO_LOAD = (

                          '$KERNELS/naif0012.tls'

                          '$KERNELS/pck00008.tpc'

                          '$KERNELS/mro_sclkscet_00082_65536.tsc'

                          '$KERNELS/mro_v16.tf'

                          '$KERNELS/mro_ctx_v11.ti'

                          '$KERNELS/B10_013341_1010_XN_79S172W_0.bsp'
                          '$KERNELS/B10_013341_1010_XN_79S172W_1.bsp'

                          '$KERNELS/mro_sc_psp_090526_090601_0_sliced_-74000.bc'
                          '$KERNELS/mro_sc_psp_090526_090601_1_sliced_-74000.bc'

                        )

   \begintext
