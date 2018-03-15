#! /bin/sh

# PostgreSQL boot time startup script for FreeBSD.  
# Ensure /usr/local/etc/rc.d directory exists
# # mkdir -p /usr/local/etc/rc.d
# Copy this file to
# /usr/local/etc/rc.d/postgresql.sh
# and give executable permission
# # chmod +x /usr/local/etc/rc.d/postgresql.sh

# Created through merger of the Linux start script by Ryan Kirkpatrick
# and the script in the FreeBSD ports collection.

# contrib/start-scripts/freebsd

## EDIT FROM HERE

# Installation prefix
prefix=/usr/local/pgsql

# Data directory
PGDATA="/usr/local/pgsql/data"

# Who to run the postmaster as, usually "postgres".  (NOT "root")
PGUSER=postgres

# Where to keep a log file
PGLOG="$PGDATA/serverlog"

## STOP EDITING HERE

# The path that is to be used for the script
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

PGCTL="$prefix/bin/pg_ctl"

# Only start if pg_ctl command exists and executable
if [ ! -x $PGCTL ]; then
	echo "$PGCTL not found"
	exit 1
fi

case $1 in
	start)
		su -l $PGUSER -c "$PGCTL start -D '$PGDATA' -l $PGLOG -s"
		echo 'PostgreSQL started.'
		;;
	stop)
		su -l $PGUSER -c "$PGCTL stop -D '$PGDATA' -s"
		echo 'PostgreSQL stopped.'
		;;
	restart)
		su -l $PGUSER -c "$PGCTL restart -D '$PGDATA' -l $PGLOG -s"
		echo 'PostgreSQL restarted.'
		;;
	reload)
		su -l $PGUSER -c "$PGCTL reload -D '$PGDATA' -s"
		echo 'PostgreSQL reloaded.'
		;;
	status)
		su -l $PGUSER -c "$PGCTL status -D '$PGDATA'"
		;;
	*)
		# Print usage
		echo "Usage: `basename $0` {start|stop|restart|reload|status}" 1>&2
		exit 1
		;;
esac

exit 0
