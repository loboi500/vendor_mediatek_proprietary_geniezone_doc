1. please enable gz systrace in 
   kernel-x.x/drivers/misc/mediatek/geniezone/gz-trusty/gz-log.c
   change 0->1 at #define ENABLE_GZ_TRACE_DUMP (IS_ENABLED(CONFIG_FTRACE) & 0)
   rebuild/redownload boot.img

2. you can enable systrace by anyway or use gz_systrace_catch.bat( in this folder)

3. after stop systrace(I assume step2's file name is SYS_FTRACE_SOURCE). 
   please execute
   python parse_systrace.py -i SYS_FTRACE_SOURCE -o SYS_FTRACE_GZ
   then you can load SYS_FTRACE_GZ by chrome://tracing/

4. in example folder
   SYS_FTRACE_K6885_SOURCE is catch by gz_systrace_parse.py
   SYS_FTRACE_K6885_GZ is execut 
       python gz_systrace_parse.py -i SYS_FTRACE_K6885_SOURCE -o SYS_FTRACE_K6885_GZ
   in record trace period
       execute uree_test 
       M -> a -> 
       lazy com.mediatek.geniezone.test 12355(for dummp cmd) ->
       multicore 6 2
    if load SYS_FTRACE_K6885_GZ by chrome://tracing, you can find ha activity in Process 67
    if search srv.mem at 2nd, that is internal IPC. you can find echo HA call ser.mem