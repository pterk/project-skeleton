#! /bin/bash

source $HOME/bin/virtualenvwrapper.sh

PROJECT_NAME="$2"
workon $PROJECT_NAME


PROJECT_PATH=$HOME/webapps/${PROJECT_NAME}/${PROJECT_NAME}/daemons
SUPERVISORD=${VIRTUAL_ENV}/bin/supervisord
SUPERVISORCTL=${VIRTUAL_ENV}/bin/supervisorctl
PIDFILE=${PROJECT_PATH}/tmp/supervisord.pid
OPTS="-c ${PROJECT_PATH}/supervisord.conf"
PS=supervisord
TRUE=1
FALSE=0

test -x ${SUPERVISORD} || exit 0

isRunning(){
    PIDS=`ps -C ${PS} -o pid=`
    for PID in ${PIDS}; do
	PROCESSPATH=`readlink /proc/${PID}/exe`
	if [[ ${PROCESSPATH} ==  ${VIRTUAL_ENV}* ]]; then
	    if [ "${PID:-0}" -gt 0 ]; then
		return 1
	    fi
	fi
    done
    return 0
}

pidof_daemon() {
    PIDS=`ps -C ${PS} -o pid=` || true

    [ -e $PIDFILE ] && PIDS2=`cat ${PIDFILE}`

    for i in $PIDS; do
        if [ "$i" = "${PIDS2}" ]; then
            return 1
        fi
    done
    return 0
}

start () {
    #echo "Starting Supervisor daemon manager..."
    isRunning
    isAlive=$?

    if [ "${isAlive}" -eq $TRUE ]; then
        #echo "Supervisor is already running."
	: # do nothing
    else
	pushd $PROJECT_PATH >>/dev/null
        $SUPERVISORD $OPTS || exit 1
        #echo "OK"
	popd >>/dev/null
	exit 0
    fi
}

stop () {
    isRunning
    isAlive=$?

    if [ "${isAlive}" -eq $TRUE ]; then
	pushd $PROJECT_PATH >>/dev/null
        #echo "Stopping Supervisor daemon manager..."
	$SUPERVISORCTL shutdown || exit 1
        #echo "OK"
	popd >>/dev/null
	exit 0
    fi
}

case "$1" in
    start)
        start
        ;;

    stop)
        stop
        ;;

    restart|reload|force-reload)
        stop
        start
        ;;

esac

exit 0
