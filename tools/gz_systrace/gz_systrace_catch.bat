@echo off
adb root

adb shell "echo 16384 > /sys/kernel/debug/tracing/buffer_size_kb"

adb shell "echo nop > /sys/kernel/debug/tracing/current_tracer"

REM adb shell "echo 'sched_switch sched_wakeup sched_wakeup_new irq_handler_entry irq_handler_exit sched_migrate_task cpu_frequency mtk_events timer_expire_entry hrtimer_init hrtimer_start hrtimer_expire_entry hrtimer_expire_exit timer hrtimer softirq_entry softirq_raise' > /sys/kernel/debug/tracing/set_event"
REM tee_sched_start tee_sched_end
adb shell "echo 'sched_switch sched_wakeup sched_wakeup_new sched_migrate_task cpu_frequency mtk_events irq' > /sys/kernel/debug/tracing/set_event"

REM just in case tracing_enabled is disabled by user or other debugging tool
REM adb shell "echo 1 > /sys/kernel/debug/tracing/tracing_enabled"
adb shell "echo 0 > /sys/kernel/debug/tracing/tracing_on"

adb shell "echo 1 > d/tracing/events/block/enable"

REM erase previous recorded trace
adb shell "echo > /sys/kernel/debug/tracing/trace"

echo press any key to start capturing...
pause

adb shell "echo 1 > /sys/kernel/debug/tracing/tracing_on"

echo "Start recordng ftrace data"
echo "Press any key to stop..."
pause

adb shell "echo 0 > /sys/kernel/debug/tracing/tracing_on"
echo "Recording stopped..."

REM for /f "tokens=1,2,3,4,5,6,7 usebackq delims=:/ " %%a in ('%date% %time%') do set my_time=%%a-%%b-%%c_%%e_%%f_%%g
REM echo %my_time%
REM adb pull /sys/kernel/debug/tracing/trace SYS_FTRACE_%my_time%
adb pull /sys/kernel/debug/tracing/trace SYS_FTRACE_SOURCE

REM adb shell "echo 1 > /sys/kernel/debug/tracing/tracing_on"
REM echo "Please press 02-parse.bat to analyze it with gtkwave and csv file"

REM python parse_systrace.py -i SYS_FTRACE -o SYS_FTRACE_TEE

REM pause
